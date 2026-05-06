# JSON_STATE_UPDATE_PROTOCOL.md

## Purpose

This file defines how to keep `STAGE_STATE.json` updated.

## After Completing A Stage

Update:

```json
{
  "current_stage": "NextStage",
  "status": "in_progress or complete",
  "completed_stages": ["CompletedStage"],
  "next_stage": "NextStage",
  "blocked": false,
  "requires_human_approval": false,
  "last_output_file": "/path/to/output.md",
  "last_updated": "ISO-8601 timestamp",
  "stage_status": {
    "CompletedStage": "complete",
    "NextStage": "not_started"
  }
}
```

## If Blocked

Update:

```json
{
  "status": "blocked",
  "blocked": true,
  "requires_human_approval": true,
  "human_approval_reason": "Reason here"
}
```

## If Complete

Update:

```json
{
  "current_stage": "Complete",
  "status": "complete",
  "next_stage": null,
  "blocked": false,
  "requires_human_approval": false
}
```

## Rule

Always update both:

```text
/meta-agent-os/00_control/STAGE_STATE.json
/meta-agent-os/00_control/STAGE_STATE.md
```

The JSON file supports machine-readable execution.

The Markdown file supports human review.
