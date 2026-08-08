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

## Pass Standard

The next persona can use this output without asking the same basic questions again.

## If Failed

Revise the output before advancing.

## Note On Per-Role Validators

This single checklist replaces the ten former per-role validator files (`architect_validator.md`, `builder_validator.md`, `cartographer_validator.md`, `evaluator_validator.md`, `guardian_validator.md`, `librarian_validator.md`, `oracle_validator.md`, `orchestrator_validator.md`, `qs_validator.md`, `sophia_validator.md`). Those files were byte-identical apart from the persona name in the heading and one sentence naming that persona; they carried no genuinely role-specific criteria. Apply this checklist to every stage's output regardless of persona.
