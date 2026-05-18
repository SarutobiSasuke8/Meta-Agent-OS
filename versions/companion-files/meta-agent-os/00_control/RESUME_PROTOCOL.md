# RESUME_PROTOCOL.md

## Purpose

This file explains how to resume the Meta Agent OS after interruption, context loss, or a human decision gate.

## Resume Trigger

Use:

```text
/continue-meta-agent-os
```

Or paste:

```text
Read STAGE_STATE.md and RESUME_PROTOCOL.md. Continue the Meta Agent OS from the latest incomplete stage.
```

## Resume Steps

1. Read `STAGE_STATE.md`.
2. Read the last completed output file.
3. Verify whether the stage marked as complete actually has an output.
4. Check `STAGE_GATES.md`.
5. Continue from the first incomplete stage.
6. Do not redo completed stages unless the user asks for a revision.
7. If a prior output is weak or missing required fields, improve it before advancing.
8. Update `STAGE_STATE.md` after the next stage.

## Recovery Rules

### If `STAGE_STATE.md` is missing

Recreate it by inspecting files in:

```text
/meta-agent-os/03_outputs
/meta-agent-os/05_memory
```

### If output files exist but state says not started

Trust the files, validate them, then update state.

### If state says complete but files are missing

Mark the affected stage incomplete and regenerate the missing file.

### If multiple outputs exist

Use the newest clearly named output unless the user specifies another.

### If interrupted during Builder

Do not continue modifying code unless the user explicitly authorises it.

## Resume Output

At the start of resume, produce:

```markdown
# Resume Status

## Last Completed Stage

## Current Stage

## Missing Outputs

## Gate Check

## Next Action
```
