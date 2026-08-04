# Token Budget Template

## Objective

Give the QS stage a repeatable way to estimate what an agent workflow costs to run, before it is built, using operator-verified pricing rather than remembered rates.

## How To Use

1. Populate `meta-agent-os/00_control/economics/MODEL_PRICING.json` with rates you have verified today, each carrying `verified_on` and `source`.
2. Copy the workflow shape below into a JSON file.
3. Run `scripts/roi-calculator.py` against both files.
4. Paste the output into the QS stage's Token Budget section, keeping the estimate labelled as an estimate.

## Workflow Shape

```json
{
  "workflow": "Support ticket triage",
  "runs_per_month": 4000,
  "steps": [
    {
      "name": "Classify",
      "model": "vendor-model-name",
      "input_tokens": 1800,
      "output_tokens": 250,
      "calls_per_run": 1,
      "cached_input_tokens": 1200
    },
    {
      "name": "Draft reply",
      "model": "vendor-model-name",
      "input_tokens": 3200,
      "output_tokens": 700,
      "calls_per_run": 1
    }
  ],
  "retry_rate": 0.08,
  "human_review": {
    "share_of_runs": 0.25,
    "minutes_per_review": 4,
    "loaded_hourly_rate": 42.0
  },
  "baseline": {
    "minutes_per_run_without_agents": 9,
    "loaded_hourly_rate": 42.0
  }
}
```

## Field Notes

| Field | Meaning | Common Mistake |
|---|---|---|
| `input_tokens` | Tokens sent per call, including system prompt, tools, and retrieved context | Counting only the user message. System prompts and tool definitions usually dominate. |
| `output_tokens` | Tokens generated per call | Using the cap rather than the realistic average. |
| `calls_per_run` | How many times this step fires in one workflow run | Assuming one. Agent loops iterate. |
| `cached_input_tokens` | Portion of input eligible for prompt caching | Assuming caching applies to the whole prompt, or that it applies at all. |
| `retry_rate` | Fraction of runs that repeat because of failure, refusal, or bad output | Setting it to zero. Measure it; do not hope. |
| `human_review` | The supervision the design actually requires | Excluding it, which is how agent workflows appear cheaper than they are. |
| `baseline` | What the work costs today without agents | Skipping it, which makes ROI unfalsifiable. |

## Estimating Discipline

- Mark every figure as an estimate. Do not present modelled costs as measured costs.
- Avoid fake precision. `$1,200 - $1,900 per month` is more honest than `$1,543.27`.
- Token counts before a build are assumptions. Record them in the assumptions log and re-measure after the first real runs.
- Human review time is a cost of the agent design, not an externality.
- If the workflow cannot beat its baseline, that is a finding worth reporting, not a failure to hide.

## Rate Hygiene

Prices are inputs, not constants. `MODEL_PRICING.json` requires `verified_on` and `source` on every entry, and strict validation fails entries older than `max_age_days`. When it fails, re-verify against the vendor's current published pricing rather than raising the threshold.
