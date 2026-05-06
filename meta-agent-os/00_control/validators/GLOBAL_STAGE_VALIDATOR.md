# GLOBAL_STAGE_VALIDATOR.md

## Purpose

Use this before marking any stage complete.

## Universal Stage Completion Checklist

- [ ] The expected output file exists.
- [ ] The output follows its schema.
- [ ] The output names its inputs.
- [ ] Facts and assumptions are separated.
- [ ] Risks are included.
- [ ] Open questions are included.
- [ ] The next action is explicit.
- [ ] The output is specific to this project.
- [ ] The output avoids generic filler.
- [ ] The output does not trigger a human approval gate.
- [ ] `STAGE_STATE.md` is updated.
- [ ] `STAGE_STATE.json` is updated.
- [ ] Memory files are updated where relevant.

## Advance / Stop Decision

Advance only if all critical checks pass.

Stop if:
- The output is weak.
- Required context is missing.
- A stage gate is triggered.
- Guardian blocks the system.
- Human approval is required.
