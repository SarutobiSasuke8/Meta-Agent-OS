# ROI Method

## Objective

Define how Meta Agent OS decides whether an agent workflow is worth building, so the QS stage produces a defensible number rather than an optimistic one.

## The Calculation

```
inference_cost   = sum over steps of (tokens / 1e6) * rate, scaled by calls and retries
supervision_cost = runs * review_share * review_minutes / 60 * loaded_hourly_rate
running_cost     = inference_cost + supervision_cost
baseline_cost    = runs * baseline_minutes / 60 * loaded_hourly_rate
net_monthly      = baseline_cost - running_cost
roi              = net_monthly / running_cost
payback_months   = build_cost / net_monthly
```

`scripts/roi-calculator.py` implements exactly this and prints each term, so the number can be argued with rather than trusted.

## Why Supervision Is Inside The Cost

An agent workflow that needs a human to check every output has not removed the work; it has changed its shape. Excluding review time is the most common way an agent proposal shows a return it does not have. If the design requires supervision, the supervision is part of the running cost.

## Why The Baseline Is Mandatory

ROI is a comparison. Without a measured or estimated cost of doing the work the current way, the calculation has no denominator and the decision has no evidence. If nobody can state the baseline, that is the finding: the workflow is not understood well enough to automate.

## Thresholds

These are defaults for the QS stage. Projects may set their own, but should set them **before** seeing the result.

| Signal | Threshold | Meaning |
|---|---|---|
| ROI below 0 | Running cost exceeds baseline | Do not build. Report the finding. |
| ROI 0 to 0.5 | Marginal | Build only if a non-cost benefit justifies it, and name that benefit explicitly. |
| ROI above 0.5 | Favourable on cost | Proceed to Guardian review. |
| Payback beyond 12 months | Slow | Re-scope to a smaller first increment. |
| Supervision above 50% of running cost | Supervision-dominated | The bottleneck is review, not inference. A cheaper model will not fix it. |

## Sensitivity Is Not Optional

A single point estimate hides the risk. Vary the three inputs most likely to be wrong and report the range:

- Token counts, at 0.5x and 2x
- Retry rate, at 0 and double the assumed value
- Review share, at the assumed value and at 1.0

If the decision flips inside that range, the honest conclusion is "we do not yet know", and the next action is a measured pilot rather than a build.

## What This Method Does Not Do

- It does not price quality. A cheaper workflow that produces worse outcomes is not a saving.
- It does not price risk. Guardian handles that, and a favourable ROI does not override a Guardian block.
- It does not price opportunity cost of the build team's time beyond the stated build cost.
- It does not survive stale rates. Re-verify pricing before quoting any figure externally.

## Relationship To The Anti-Agent Gate

A workflow can be profitable and still be the wrong thing to build with agents. Deterministic automation is usually cheaper, faster, and easier to verify. Run the ROI method after the Oracle stage has established that the work genuinely needs an agent, not before.
