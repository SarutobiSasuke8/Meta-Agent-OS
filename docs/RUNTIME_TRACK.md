# Runtime Track

## Objective

Describe the separate implementation track required to move Meta Agent OS from a framework/specification layer toward full agentic runtime behaviour.

## Inputs Used

- `docs/PUBLIC_BOUNDARY.md`
- `meta-agent-os/00_control/STAGE_MANIFEST.json`
- `meta-agent-os/00_control/STAGE_STATE.json`
- `meta-agent-os/00_control/STAGE_GATES.md`
- `meta-agent-os/00_control/RUN_MODES.json`
- `meta-agent-os/03_outputs/runtime/ORCHESTRATOR_RUNTIME_LOG.md`

## Findings

The current repo can guide an agentic workspace through staged work, but it does not execute agents itself. A runtime track should treat this repo as the doctrine and state-machine specification, then implement execution outside the public core.

## Runtime Scope

A minimal runtime should:

1. Read `STAGE_STATE.json`.
2. Read `STAGE_MANIFEST.json`.
3. Select the next runnable stage.
4. Load the relevant stage schema, gate, and validator.
5. Produce or update the stage output.
6. Run strict validation.
7. Update `STAGE_STATE.json` and `STAGE_STATE.md`.
8. Stop at human approval gates.

## Runtime Non-Goals

The first runtime should not:

- Deploy code.
- Spend money.
- Manage credentials.
- Publish externally.
- Send messages to third parties.
- Modify production systems.
- Hide state transitions from the operator.

## Suggested Milestones

| Milestone | Capability | Safe Completion Test |
|---|---|---|
| R0 | Read-only status runner | Reports current stage and next action from state files |
| R1 | Local stage runner | Creates one missing Markdown stage output from repo context |
| R2 | Validator integration | Blocks advancement when strict validation fails |
| R3 | Gate enforcement | Stops before Builder, Orchestrator, or external action gates |
| R4 | Tool adapter boundary | Routes allowed internal tools through explicit allowlists |
| R5 | Eval loop | Runs defined evals after Builder and records results |
| R6 | Recovery | Resumes cleanly after interruption or invalid output |

## Permission Model

| Action Class | Runtime Default |
|---|---|
| Read repo files | Allowed |
| Write stage outputs and memory | Allowed when stage permits |
| Modify application source | Block until approved |
| Install dependencies | Block until approved |
| Use credentials | Block until approved |
| Deploy, publish, email, pay, delete | Block until explicit approval |

## Assumptions

- The runtime is developed in a separate private implementation repo or clearly separated package.
- Meta Agent OS remains the specification source of truth.
- Human approval gates remain part of the system, not a temporary training wheel.

## Risks

- A runtime could weaken the current safety posture if it bypasses gates.
- Tool adapters can create accidental external side effects.
- Agents may produce valid-looking Markdown that passes structural checks but lacks substance.

## Open Questions

- Should the runtime be a CLI, local daemon, GitHub Action, or agent-workspace plugin?
- Should model/tool adapters be provider-neutral from day one?
- Should stage outputs be Markdown only, or paired with machine-readable JSON?

## Recommended Next Action

Build R0 and R1 outside the public core: a read-only status runner plus a local single-stage runner that cannot perform external actions.

## Files Created Or Updated

- `docs/RUNTIME_TRACK.md`
