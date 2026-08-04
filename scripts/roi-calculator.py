#!/usr/bin/env python3
"""Estimate the running cost and ROI of an agent workflow.

Implements the calculation defined in
`meta-agent-os/00_control/economics/ROI_METHOD.md`, using operator-verified
rates from `meta-agent-os/00_control/economics/MODEL_PRICING.json`.

The tool refuses to produce a number from stale, undated, or unsourced
pricing. A confident wrong cost is worse than no cost.

Usage:
    python scripts/roi-calculator.py WORKFLOW.json
    python scripts/roi-calculator.py WORKFLOW.json --pricing path/to/pricing.json
    python scripts/roi-calculator.py WORKFLOW.json --today 2026-08-04
    python scripts/roi-calculator.py WORKFLOW.json --json
"""

import argparse
import datetime
import json
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
DEFAULT_PRICING = REPO_ROOT / "meta-agent-os" / "00_control" / "economics" / "MODEL_PRICING.json"

# Thresholds from ROI_METHOD.md. Set before seeing the result, not after.
MARGINAL_ROI = 0.5
SLOW_PAYBACK_MONTHS = 12
SUPERVISION_DOMINATED_SHARE = 0.5


class InputError(Exception):
    """Raised when the workflow or pricing input cannot be trusted."""


def load_json(path: Path, label: str):
    if not path.exists():
        raise InputError(f"{label} not found: {path}")
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except json.JSONDecodeError as exc:
        raise InputError(f"{label} is not valid JSON ({path}): {exc}") from exc


def parse_date(value, label):
    try:
        return datetime.date.fromisoformat(value)
    except (TypeError, ValueError):
        raise InputError(f"{label} must be an ISO date (YYYY-MM-DD), got: {value!r}")


def build_rate_table(pricing, today):
    """Validate the pricing registry and return {model_id: entry}.

    Every entry must be dated, sourced, and within max_age_days. This mirrors
    the strict validator so the two cannot drift apart in what they accept.
    """
    models = pricing.get("models")
    if not models:
        raise InputError(
            f"No models in the pricing registry ({DEFAULT_PRICING.name}). "
            "Populate it with rates you have verified today. Meta Agent OS "
            "ships no default prices on purpose."
        )

    max_age = pricing.get("max_age_days")
    if not isinstance(max_age, int) or max_age <= 0:
        raise InputError("Pricing registry must set a positive integer 'max_age_days'.")

    table = {}
    for index, entry in enumerate(models):
        model_id = entry.get("id")
        if not model_id:
            raise InputError(f"Pricing entry {index} has no 'id'.")

        for field in ("input", "output"):
            if not isinstance(entry.get(field), (int, float)):
                raise InputError(f"Pricing entry '{model_id}' has a non-numeric '{field}' rate.")

        if not entry.get("source"):
            raise InputError(f"Pricing entry '{model_id}' has no 'source'. An unsourced rate is a guess.")

        verified = parse_date(entry.get("verified_on"), f"Pricing entry '{model_id}' verified_on")
        age = (today - verified).days
        if age < 0:
            raise InputError(f"Pricing entry '{model_id}' is dated in the future: {verified}.")
        if age > max_age:
            raise InputError(
                f"Pricing entry '{model_id}' was verified {age} days ago, exceeding "
                f"max_age_days={max_age}. Re-verify against the vendor's current published "
                "pricing rather than raising the threshold."
            )

        table[model_id] = entry

    return table


def step_cost(step, rates, retry_multiplier):
    """Cost of one workflow step for a single run, retries included."""
    model_id = step.get("model")
    if model_id not in rates:
        raise InputError(
            f"Step '{step.get('name', '?')}' uses model '{model_id}', which is not in the "
            "pricing registry. Add it with a verified rate, or correct the step."
        )
    rate = rates[model_id]

    calls = step.get("calls_per_run", 1)
    input_tokens = step.get("input_tokens", 0)
    output_tokens = step.get("output_tokens", 0)
    cached_tokens = step.get("cached_input_tokens", 0) or 0

    if cached_tokens > input_tokens:
        raise InputError(
            f"Step '{step.get('name', '?')}' claims more cached input tokens than input tokens."
        )

    cached_rate = rate.get("cached_input")
    if cached_tokens and cached_rate is None:
        raise InputError(
            f"Step '{step.get('name', '?')}' assumes prompt caching, but model '{model_id}' "
            "has no 'cached_input' rate. Set one, or drop the assumption."
        )

    uncached_tokens = input_tokens - cached_tokens
    per_call = (
        uncached_tokens / 1_000_000 * rate["input"]
        + cached_tokens / 1_000_000 * (cached_rate or 0.0)
        + output_tokens / 1_000_000 * rate["output"]
    )
    return per_call * calls * retry_multiplier


def calculate(workflow, rates):
    runs = workflow.get("runs_per_month")
    if not isinstance(runs, (int, float)) or runs <= 0:
        raise InputError("Workflow must set a positive 'runs_per_month'.")

    steps = workflow.get("steps")
    if not steps:
        raise InputError("Workflow must define at least one step.")

    retry_rate = workflow.get("retry_rate", 0.0)
    if not 0 <= retry_rate < 1:
        raise InputError("'retry_rate' must be a fraction in [0, 1).")
    retry_multiplier = 1 + retry_rate

    per_run = sum(step_cost(step, rates, retry_multiplier) for step in steps)
    inference_cost = per_run * runs

    review = workflow.get("human_review") or {}
    review_share = review.get("share_of_runs", 0.0)
    review_minutes = review.get("minutes_per_review", 0.0)
    review_rate = review.get("loaded_hourly_rate", 0.0)
    supervision_cost = runs * review_share * (review_minutes / 60) * review_rate

    running_cost = inference_cost + supervision_cost

    baseline = workflow.get("baseline")
    if not baseline:
        raise InputError(
            "Workflow has no 'baseline'. ROI is a comparison; without the cost of doing "
            "the work the current way there is no denominator and no decision. If nobody "
            "can state the baseline, that is the finding."
        )
    baseline_cost = (
        runs
        * (baseline.get("minutes_per_run_without_agents", 0.0) / 60)
        * baseline.get("loaded_hourly_rate", 0.0)
    )

    net_monthly = baseline_cost - running_cost
    roi = net_monthly / running_cost if running_cost else float("inf")

    build_cost = workflow.get("build_cost")
    payback_months = None
    if build_cost and net_monthly > 0:
        payback_months = build_cost / net_monthly

    supervision_share = supervision_cost / running_cost if running_cost else 0.0

    return {
        "workflow": workflow.get("workflow", "(unnamed)"),
        "runs_per_month": runs,
        "cost_per_run": per_run,
        "inference_cost": inference_cost,
        "supervision_cost": supervision_cost,
        "running_cost": running_cost,
        "baseline_cost": baseline_cost,
        "net_monthly": net_monthly,
        "roi": roi,
        "payback_months": payback_months,
        "supervision_share": supervision_share,
        "verdict": verdict(roi, payback_months, supervision_share),
    }


def verdict(roi, payback_months, supervision_share):
    signals = []
    if roi < 0:
        signals.append("DO NOT BUILD: running cost exceeds the baseline.")
    elif roi < MARGINAL_ROI:
        signals.append(
            "MARGINAL: build only if a non-cost benefit justifies it, and name that benefit."
        )
    else:
        signals.append("FAVOURABLE ON COST: proceed to Guardian review.")

    if payback_months is not None and payback_months > SLOW_PAYBACK_MONTHS:
        signals.append(
            f"SLOW PAYBACK: {payback_months:.1f} months. Re-scope to a smaller first increment."
        )
    if supervision_share > SUPERVISION_DOMINATED_SHARE:
        signals.append(
            "SUPERVISION-DOMINATED: review, not inference, is the bottleneck. "
            "A cheaper model will not fix it."
        )
    return signals


def sensitivity(workflow, rates):
    """Vary the three inputs most likely to be wrong. A point estimate hides the risk."""
    scenarios = []

    for label, factor in (("tokens 0.5x", 0.5), ("tokens 2x", 2.0)):
        variant = json.loads(json.dumps(workflow))
        for step in variant["steps"]:
            for field in ("input_tokens", "output_tokens", "cached_input_tokens"):
                if step.get(field):
                    step[field] = step[field] * factor
        scenarios.append((label, variant))

    for label, value in (("retries 0", 0.0), ("retries 2x", min(workflow.get("retry_rate", 0.0) * 2, 0.95))):
        variant = json.loads(json.dumps(workflow))
        variant["retry_rate"] = value
        scenarios.append((label, variant))

    if workflow.get("human_review"):
        variant = json.loads(json.dumps(workflow))
        variant["human_review"]["share_of_runs"] = 1.0
        scenarios.append(("every run reviewed", variant))

    results = []
    for label, variant in scenarios:
        outcome = calculate(variant, rates)
        results.append({"scenario": label, "roi": outcome["roi"], "running_cost": outcome["running_cost"]})
    return results


def money(value):
    return f"${value:,.2f}"


def render(result, sensitivity_rows):
    lines = []
    lines.append(f"Workflow: {result['workflow']}")
    lines.append(f"Runs per month: {result['runs_per_month']:,.0f}")
    lines.append("")
    lines.append("All figures are estimates, not measurements.")
    lines.append("")
    lines.append(f"  Cost per run          {money(result['cost_per_run'])}")
    lines.append(f"  Inference cost        {money(result['inference_cost'])}")
    lines.append(f"  Supervision cost      {money(result['supervision_cost'])}")
    lines.append(f"  Running cost          {money(result['running_cost'])}")
    lines.append(f"  Baseline cost         {money(result['baseline_cost'])}")
    lines.append(f"  Net monthly           {money(result['net_monthly'])}")
    lines.append(f"  ROI                   {result['roi']:.2f}")
    if result["payback_months"] is not None:
        lines.append(f"  Payback               {result['payback_months']:.1f} months")
    lines.append(f"  Supervision share     {result['supervision_share'] * 100:.0f}% of running cost")
    lines.append("")
    lines.append("Verdict:")
    for signal in result["verdict"]:
        lines.append(f"  - {signal}")

    if sensitivity_rows:
        lines.append("")
        lines.append("Sensitivity (the decision should survive this range):")
        for row in sensitivity_rows:
            lines.append(
                f"  {row['scenario']:<20} ROI {row['roi']:>7.2f}   running {money(row['running_cost'])}"
            )
        flips = {row["roi"] >= MARGINAL_ROI for row in sensitivity_rows}
        if len(flips) > 1:
            lines.append("")
            lines.append(
                "  The verdict flips inside the sensitivity range. The honest conclusion is "
                "'we do not yet know'. Run a measured pilot before committing to a build."
            )
    return "\n".join(lines)


def main():
    parser = argparse.ArgumentParser(description="Estimate agent workflow running cost and ROI.")
    parser.add_argument("workflow", type=Path, help="Path to the workflow JSON file.")
    parser.add_argument("--pricing", type=Path, default=DEFAULT_PRICING, help="Path to the pricing registry.")
    parser.add_argument("--today", help="Override today's date (YYYY-MM-DD) for rate-age checks.")
    parser.add_argument("--json", action="store_true", dest="as_json", help="Emit machine-readable JSON.")
    parser.add_argument("--no-sensitivity", action="store_true", help="Skip the sensitivity range.")
    args = parser.parse_args()

    try:
        today = parse_date(args.today, "--today") if args.today else datetime.date.today()
        workflow = load_json(args.workflow, "Workflow file")
        pricing = load_json(args.pricing, "Pricing registry")
        rates = build_rate_table(pricing, today)
        result = calculate(workflow, rates)
        rows = [] if args.no_sensitivity else sensitivity(workflow, rates)
    except InputError as exc:
        print(f"roi-calculator: {exc}", file=sys.stderr)
        return 2

    if args.as_json:
        print(json.dumps({"result": result, "sensitivity": rows}, indent=2))
    else:
        print(render(result, rows))
    return 0


if __name__ == "__main__":
    sys.exit(main())
