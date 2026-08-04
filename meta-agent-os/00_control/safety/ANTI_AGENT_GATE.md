# Anti-Agent Gate

## Purpose

Force an explicit answer to the question most agent projects skip: **should this be an agent at all?**

The gate runs in the Oracle stage, before any design work. It is called the anti-agent gate because its default answer is no. An agent must be argued for, not assumed.

## Why This Exists

Almost every incentive in this space pushes toward more agents. Vendors sell inference. Frameworks assume you have already decided. Consultants are paid to build. Nobody in that chain is paid to say "a scheduled script would do this better, cheaper, and more reliably."

Meta Agent OS is upstream of the build, so it is the only place the question can still be asked cheaply.

## The Gate

A workflow passes only if **all four** conditions hold. Any single failure blocks it.

| # | Condition | Fails When |
|---|---|---|
| 1 | The task requires judgement that cannot be expressed as rules | The logic can be written as a decision table, a query, or a regex |
| 2 | The inputs are genuinely unstructured or varied | Inputs arrive in a fixed schema from a system you control |
| 3 | An imperfect answer is still useful | The task requires a provably correct answer every time |
| 4 | A human can review or recover from a wrong output | A wrong output is silent, irreversible, or reaches a customer unchecked |

## When The Gate Blocks

A block is a finding, not a failure. Record it in the Oracle output and recommend the cheaper alternative:

| Pattern | Better Tool |
|---|---|
| Fixed rules on structured data | A script or a database query |
| Extraction from a consistent format | A parser or a template |
| Routing on known categories | A lookup table or a classifier, not an agent |
| Scheduled repetitive action | A cron job |
| Anything needing a provable audit trail | Deterministic code with logging |

Reporting that a workflow does not need agents is one of the more valuable outputs this framework produces. It is cheaper to conclude that at the Oracle stage than after a build.

## Partial Passes

Most real workflows are mixed. A ticket triage flow may need judgement to summarise and classify, but not to route once classified. The correct outcome is usually a **narrower agent inside a deterministic workflow**, not an agent that owns the whole flow.

Where the gate passes for only part of a workflow, say which part, and design the rest as code.

## Relationship To ROI

The gate asks whether an agent is *appropriate*. The ROI method in `meta-agent-os/00_control/economics/ROI_METHOD.md` asks whether it is *worth it*. Both must pass.

Run the gate first. A workflow that fails the gate should never reach a cost model, because the cost of the wrong architecture is not a useful number.

## Recording The Result

The Oracle output must contain an Agent Suitability Assessment section stating, for each candidate workflow: the four gate conditions and whether each holds, the resulting score from `scripts/agent-suitability.py`, and the verdict. An assessment that omits the failing conditions has not run the gate; it has narrated a decision already made.
