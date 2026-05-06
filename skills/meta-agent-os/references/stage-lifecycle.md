# Stage Lifecycle

## Objective

Run Meta Agent OS stages in a controlled sequence while preserving evidence, state, and human decision gates.

## Canonical Sequence

Oracle -> Sophia -> Cartographer -> Architect -> QS -> Guardian -> Builder -> Evaluator -> Orchestrator -> Librarian

## Stage Advancement

Before advancing:

1. Check the current stage in `meta-agent-os/00_control/STAGE_STATE.json`.
2. Find its output, schema, and validator in `meta-agent-os/00_control/STAGE_MANIFEST.json`.
3. Create or update the expected output under `meta-agent-os/03_outputs` or `meta-agent-os/05_memory`.
4. Validate against the stage schema.
5. Apply the stage validator and `validators/GLOBAL_STAGE_VALIDATOR.md`.
6. Check `STAGE_GATES.md`.
7. Update `STAGE_STATE.json`.
8. Update `STAGE_STATE.md`.
9. Update memory files when decisions, assumptions, or durable facts changed.

## Resume Behavior

Do not restart from Oracle if completed outputs exist. Resume from the current incomplete stage unless the user explicitly asks for a rerun or validation finds the prior output unusable.

## Run Modes

Use the smallest suitable mode from `RUN_MODES.json`. Do not run the full system when diagnosis, research, hardening, or validation is enough.
