# Inference Risk Profiles

## Purpose

Extend the Guardian stage with the risks that come specifically from *which model runs where*, rather than from the workflow design. Guardian already covers data, permissions, autonomy, and abuse. This adds the inference layer.

## Task Criticality

Classify every step before choosing a model for it.

| Tier | Definition | Examples |
|---|---|---|
| **C1 Critical** | A wrong output causes harm that is expensive, irreversible, or reaches a person as fact | Medical, legal, financial, safety, or compliance output; anything sent to a customer unreviewed |
| **C2 Significant** | A wrong output causes rework or visible embarrassment but is recoverable | Customer-facing drafts under review, internal decisions with downstream effects |
| **C3 Routine** | A wrong output is cheap to catch and cheap to fix | Summaries, classification with review, internal drafting, formatting |

Criticality is a property of the **step**, not the workflow. A C3 workflow usually contains at least one C1 step, and that step sets the floor.

## Model Quality Floors

| Tier | Floor | Rationale |
|---|---|---|
| C1 | Highest-capability hosted model available; no local or small-model substitution | Capability differences show up exactly where they are most expensive |
| C2 | Mid-tier or better; substitution permitted only with an eval showing parity on this task | Parity must be demonstrated on the real task, not assumed from a benchmark |
| C3 | Any model that passes the task's evals | The cheapest model that measurably works |

**A cost saving that lowers a model below its tier floor is not a saving.** It moves cost from the inference budget to the failure budget, where it is harder to see and usually larger.

## Local Model Risks

Local models are attractive for cost and privacy. Both benefits are real. The risks are specific:

| Risk | Why It Matters |
|---|---|
| Silent capability gap | A weaker model does not announce that it is out of its depth. It produces fluent, wrong output. |
| No vendor safety layer | Behaviour that a hosted model refuses may be produced without friction. |
| Unversioned drift | Local weights and quantisations change without release notes, so yesterday's evals may not describe today's model. |
| False privacy assurance | Local inference protects data from the vendor, not from an unsecured host, logs, or the network. |
| Eval debt | Local substitution is usually adopted for cost and evaluated later, if at all. |

Local models are permitted for C3, permitted for C2 only with a passing parity eval on the real task, and not permitted for C1.

## Hosted Escalation

Where a cheaper or local model handles a step, define escalation **before** deployment:

1. **Trigger.** Low confidence, refusal, malformed output, retry exhaustion, or a detected C1 topic.
2. **Target.** The specific model escalated to.
3. **Budget.** What escalation costs at the expected trigger rate, included in the running cost, not treated as an exception.
4. **Visibility.** Escalations are logged and counted. An escalation rate that climbs is the earliest signal that the cheap model was the wrong choice.

An escalation path that exists only in the design document is not a control.

## Local Versus Hosted Decision

Answer in order. Stop at the first blocking answer.

1. Is any step C1? If so, that step is hosted. Others may still be local.
2. Does data sensitivity prohibit sending data to a vendor? If so, local is required, and the criticality floor must be met locally or the workflow is redesigned.
3. Is there a passing eval for the local model on this task? If not, local is not yet an option; it is a hypothesis.
4. Does the cost saving survive the escalation rate and the eval maintenance? If not, the saving is nominal.

## Inference Efficiency Without Cutting Corners

Legitimate ways to reduce inference cost that do not lower the quality floor:

- Cache stable prompt prefixes rather than shortening context that the task needs
- Remove tool definitions the step cannot use
- Cut retrieved context by relevance, measured, not guessed
- Move deterministic steps out of the model entirely
- Reduce retries by fixing the cause rather than raising the limit
- Batch where latency permits

Each reduces tokens without reducing the capability applied to the decision. Downgrading the model on a C1 step does the opposite.

## Guardian Verdict Interaction

An inference risk finding can produce "Approved with restrictions" on its own. Typical restrictions:

- Named model floor per step, recorded in the build
- Escalation path implemented and logged before launch
- Parity evals required before any local substitution
- Escalation rate monitored with a threshold that triggers review

A favourable ROI does not override a Guardian block. Cost is an input to the decision; it is not the decision.
