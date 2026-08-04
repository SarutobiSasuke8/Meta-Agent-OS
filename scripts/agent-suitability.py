#!/usr/bin/env python3
"""Score whether a workflow should be built with agents at all.

Implements the anti-agent gate from
`meta-agent-os/00_control/safety/ANTI_AGENT_GATE.md` and the scoring rubric
from `meta-agent-os/00_control/safety/AGENT_SUITABILITY_SCORING.md`.

The gate's default answer is no. An agent must be argued for. The tool
refuses to produce a verdict from unjustified scores, because an
unjustified score is an opinion with a number attached.

Usage:
    python scripts/agent-suitability.py ASSESSMENT.json
    python scripts/agent-suitability.py ASSESSMENT.json --json
"""

import argparse
import json
import sys
from pathlib import Path

# Each dimension is scored 0-4. See AGENT_SUITABILITY_SCORING.md.
DIMENSIONS = (
    "judgement_required",
    "input_variability",
    "tolerance_for_error",
    "recoverability",
    "volume",
    "stability",
)

# A zero on either of these caps the verdict regardless of the total. A workflow
# that must be right every time, or whose errors cannot be caught, is not made
# safe by being valuable.
CRITICAL_DIMENSIONS = ("tolerance_for_error", "recoverability")

MAX_SCORE = len(DIMENSIONS) * 4

BANDS = (
    (8, "NOT SUITABLE", "Build deterministic automation instead."),
    (14, "MARGINAL", "A narrow agent inside a deterministic workflow, if anything."),
    (19, "SUITABLE", "Proceed, with the supervision the recoverability score implies."),
    (MAX_SCORE, "WELL SUITED", "Proceed. Verify the score is not optimism."),
)

GATE_CONDITIONS = {
    "requires_judgement": "The task requires judgement that cannot be expressed as rules",
    "unstructured_inputs": "The inputs are genuinely unstructured or varied",
    "imperfect_answer_useful": "An imperfect answer is still useful",
    "human_can_recover": "A human can review or recover from a wrong output",
}

DETERMINISTIC_ALTERNATIVES = {
    "requires_judgement": "A script, decision table, or database query.",
    "unstructured_inputs": "A parser or template against the known schema.",
    "imperfect_answer_useful": "Deterministic code with a provable audit trail.",
    "human_can_recover": "Redesign so the output is reviewable, or do not automate this step.",
}


class InputError(Exception):
    """Raised when the assessment cannot be scored as given."""


def load_assessment(path: Path):
    if not path.exists():
        raise InputError(f"Assessment file not found: {path}")
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except json.JSONDecodeError as exc:
        raise InputError(f"Assessment is not valid JSON ({path}): {exc}") from exc


def check_gate(assessment):
    """The four preconditions. Any single failure blocks, regardless of score."""
    gate = assessment.get("gate")
    if not isinstance(gate, dict):
        raise InputError(
            "Assessment has no 'gate' object. The anti-agent gate runs before scoring; "
            "a score without it has not asked whether an agent is appropriate."
        )

    failures = []
    for key, description in GATE_CONDITIONS.items():
        if key not in gate:
            raise InputError(f"Gate condition '{key}' is missing. All four must be answered.")
        entry = gate[key]
        holds = entry.get("holds") if isinstance(entry, dict) else entry
        if not isinstance(holds, bool):
            raise InputError(f"Gate condition '{key}' must state a boolean 'holds'.")
        if not holds:
            reason = entry.get("reason") if isinstance(entry, dict) else None
            failures.append(
                {
                    "condition": key,
                    "description": description,
                    "reason": reason or "(no reason recorded)",
                    "alternative": DETERMINISTIC_ALTERNATIVES[key],
                }
            )
    return failures


def score(assessment):
    scores = assessment.get("scores")
    if not isinstance(scores, dict):
        raise InputError("Assessment has no 'scores' object.")

    justifications = assessment.get("justifications") or {}
    total = 0
    detail = {}

    for dimension in DIMENSIONS:
        if dimension not in scores:
            raise InputError(f"Missing score for dimension '{dimension}'.")
        value = scores[dimension]
        if not isinstance(value, int) or not 0 <= value <= 4:
            raise InputError(f"Dimension '{dimension}' must be an integer from 0 to 4, got {value!r}.")

        justification = justifications.get(dimension)
        if not justification or not str(justification).strip():
            raise InputError(
                f"Dimension '{dimension}' has no justification. An unjustified score is an "
                "opinion with a number attached, and cannot be argued with in review."
            )

        total += value
        detail[dimension] = {"score": value, "justification": str(justification).strip()}

    return total, detail


def band_for(total):
    for ceiling, name, guidance in BANDS:
        if total <= ceiling:
            return name, guidance
    return BANDS[-1][1], BANDS[-1][2]


def assess(assessment):
    gate_failures = check_gate(assessment)
    total, detail = score(assessment)
    band, guidance = band_for(total)

    capped_by = [d for d in CRITICAL_DIMENSIONS if detail[d]["score"] == 0]
    if capped_by:
        band, guidance = "NOT SUITABLE", "Build deterministic automation instead."

    blocked = bool(gate_failures) or bool(capped_by) or band == "NOT SUITABLE"

    # The gate is a precondition, not a weighting. A high score behind a failed
    # gate is not a favourable verdict; it is a well-scored wrong architecture.
    if gate_failures:
        band = "BLOCKED BY GATE"
        guidance = (
            "The score below is retained for the record, but it does not apply: "
            "a failed gate condition means an agent is the wrong tool regardless of score."
        )

    return {
        "workflow": assessment.get("workflow", "(unnamed)"),
        "gate_failures": gate_failures,
        "total": total,
        "max": MAX_SCORE,
        "dimensions": detail,
        "band": band,
        "guidance": guidance,
        "capped_by": capped_by,
        "blocked": blocked,
    }


def render(result):
    lines = [f"Workflow: {result['workflow']}", ""]

    if result["gate_failures"]:
        lines.append("ANTI-AGENT GATE: BLOCKED")
        lines.append("")
        for failure in result["gate_failures"]:
            lines.append(f"  Failed: {failure['description']}")
            lines.append(f"    Reason:      {failure['reason']}")
            lines.append(f"    Use instead: {failure['alternative']}")
            lines.append("")
        lines.append("  A block is a finding, not a failure. Record it in the Oracle output")
        lines.append("  and recommend the cheaper alternative.")
        lines.append("")
    else:
        lines.append("ANTI-AGENT GATE: passed (all four conditions hold)")
        lines.append("")

    lines.append(f"Suitability score: {result['total']}/{result['max']}")
    lines.append("")
    for dimension, info in result["dimensions"].items():
        marker = " (critical)" if dimension in CRITICAL_DIMENSIONS else ""
        lines.append(f"  {dimension:<22} {info['score']}/4{marker}")
        lines.append(f"    {info['justification']}")
    lines.append("")

    if result["capped_by"]:
        lines.append(
            "  Capped at NOT SUITABLE by a zero on: " + ", ".join(result["capped_by"]) + "."
        )
        lines.append(
            "  A workflow that must be right every time, or whose errors cannot be caught,"
        )
        lines.append("  is not made safe by being valuable.")
        lines.append("")

    lines.append(f"Verdict: {result['band']}")
    lines.append(f"  {result['guidance']}")

    if result["blocked"]:
        lines.append("")
        lines.append("  Do not advance to Architect. Report the finding and the alternative.")
    else:
        lines.append("")
        lines.append("  Next: run the ROI method. Both suitability and ROI must pass.")

    return "\n".join(lines)


def main():
    parser = argparse.ArgumentParser(description="Score agent suitability and run the anti-agent gate.")
    parser.add_argument("assessment", type=Path, help="Path to the assessment JSON file.")
    parser.add_argument("--json", action="store_true", dest="as_json", help="Emit machine-readable JSON.")
    args = parser.parse_args()

    try:
        result = assess(load_assessment(args.assessment))
    except InputError as exc:
        print(f"agent-suitability: {exc}", file=sys.stderr)
        return 2

    print(json.dumps(result, indent=2) if args.as_json else render(result))

    # Exit 1 when blocked, so this can gate advancement in a pipeline.
    return 1 if result["blocked"] else 0


if __name__ == "__main__":
    sys.exit(main())
