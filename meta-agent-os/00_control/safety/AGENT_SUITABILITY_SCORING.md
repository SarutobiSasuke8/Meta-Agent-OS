# Agent Suitability Scoring

## Purpose

Turn the anti-agent gate from a judgement call into a recorded, arguable score, so two people assessing the same workflow reach comparable conclusions and disagreements land on a specific dimension rather than a general feeling.

## Scope

Scoring supports the decision. It does not make it. A high score on a workflow that fails a gate condition is still blocked, because the gate is a set of preconditions, not a weighting.

## Dimensions

Score each from 0 to 4. `scripts/agent-suitability.py` implements this and refuses to score a dimension you have not justified.

| Dimension | 0 | 4 |
|---|---|---|
| `judgement_required` | Fully expressible as rules | Requires weighing ambiguous, context-dependent evidence |
| `input_variability` | Fixed schema from a controlled system | Free-form input from many uncontrolled sources |
| `tolerance_for_error` | Must be provably correct every time | An imperfect draft is still useful |
| `recoverability` | Wrong output is silent and irreversible | Wrong output is visible, cheap to catch, cheap to undo |
| `volume` | Rare enough to do by hand | High enough that automation changes the economics |
| `stability` | Requirements change weekly | Stable enough that a built system stays correct |

## Scoring Bands

| Total (0-24) | Band | Meaning |
|---|---|---|
| 0-8 | Not suitable | Build deterministic automation instead. |
| 9-14 | Marginal | A narrow agent inside a deterministic workflow, if anything. |
| 15-19 | Suitable | Proceed, with the supervision the recoverability score implies. |
| 20-24 | Well suited | Proceed. Verify the score is not optimism; low scores are more often correct than high ones. |

## Critical Dimensions

`tolerance_for_error` and `recoverability` are **critical**. A score of 0 on either caps the workflow at Not Suitable regardless of the total.

A workflow that must be right every time, or whose errors cannot be caught, is not made safe by being valuable. That combination is how agent systems cause damage: high value justifies deployment, low recoverability means nobody notices the failures until they compound.

## Justifications Are Mandatory

Every dimension requires a one-line justification. This is not bureaucracy. An unjustified score is an opinion with a number attached, and it cannot be argued with in review. The tool refuses to produce a verdict without them.

## Scoring Discipline

- Score the workflow you will actually build, not the ideal version.
- Score before seeing the ROI, so a large number does not pull the scores upward.
- When genuinely torn between two values, take the lower one. Optimism about suitability is the more expensive error.
- Re-score after the first real usage. Pre-build scores are assumptions.

## Relationship To Guardian

Suitability scoring feeds the Guardian stage. `recoverability` in particular maps directly to required supervision: a low score means the design needs review gates, monitoring, and a kill switch, all of which belong in the running cost.

See `meta-agent-os/00_control/safety/INFERENCE_RISK_PROFILES.md`.
