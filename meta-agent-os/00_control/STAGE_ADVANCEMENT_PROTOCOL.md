# STAGE_ADVANCEMENT_PROTOCOL.md

## Purpose

This protocol defines how the Meta Agent OS advances from one stage to the next.

## Required Files

Before running, read:

```text
/meta-agent-os/00_control/STAGE_STATE.md
/meta-agent-os/00_control/STAGE_STATE.json
/meta-agent-os/00_control/STAGE_MANIFEST.json
/meta-agent-os/00_control/RUN_MODES.json
/meta-agent-os/00_control/STAGE_GATES.md
/meta-agent-os/00_control/QUALITY_BAR.md
```

## Advancement Rules

A stage may advance only if:

1. The expected output file exists.
2. The output follows the relevant schema.
3. The validator checklist passes.
4. Stage gates do not require human approval.
5. The output is useful to the next stage.
6. `STAGE_STATE.md` and `STAGE_STATE.json` are updated.

## Machine-Readable State

`STAGE_STATE.json` is the machine-readable source of truth.

`STAGE_STATE.md` is the human-readable mirror.

If they conflict, inspect output files and repair both state files.

## Validation

After each stage:

1. Read the stage schema.
2. Read the validator file.
3. Check the output.
4. If weak, revise before advancing.
5. If blocked, update state and stop.

## Human Approval Gate

If a stage would trigger an action above approval level 2 in `STAGE_GATES.md`, stop.

Write:

```text
The Meta Agent OS has paused at a human decision gate.
```

Then explain:

- Stage
- Trigger
- Risk
- Options
- Recommended decision

## Completion

A run is complete when:

- The selected run mode stages are complete.
- Memory files are updated.
- No required human approval is pending.
- `STAGE_STATE.json` says `"status": "complete"`.
