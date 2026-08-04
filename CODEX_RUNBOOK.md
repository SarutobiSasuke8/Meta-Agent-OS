# CODEX_RUNBOOK.md

## Purpose

This file makes the Meta Agent OS first-class for Codex.

Codex should treat `AGENTS.md` as the primary repo instruction file, then use this runbook to trigger the Meta Agent OS workflow.

## Important

Codex does not use Claude Code slash commands such as:

```text
/run-meta-agent-os
/continue-meta-agent-os
/stage-status
```

Instead, use the prompt-based triggers in this file.

## Full Run Trigger

Paste this into Codex from the project root:

```text
Read AGENTS.md, CODEX_RUNBOOK.md, META_AGENT_BOOTSTRAP.md, and all files in /meta-agent-os/00_control.

Run the full Meta Agent OS sequence for this repository:

Oracle -> Sophia -> Cartographer -> Architect -> QS -> Guardian -> Builder -> Evaluator -> Orchestrator -> Librarian.

Use `/meta-agent-os/00_control/STAGE_STATE.json` as the machine-readable state tracker and `/meta-agent-os/00_control/STAGE_STATE.md` as the human-readable mirror.

Create each required output file under /meta-agent-os/03_outputs and update memory files under /meta-agent-os/05_memory.

Do not modify application source code unless I explicitly approve it.

Stop at any human decision gate defined in /meta-agent-os/00_control/STAGE_GATES.md.

End with:
- current stage
- completed stages
- files created or updated
- blockers
- next recommended action
```

## Diagnosis-Only Trigger

```text
Read AGENTS.md, CODEX_RUNBOOK.md, META_AGENT_BOOTSTRAP.md, and /meta-agent-os/00_control/STAGE_GATES.md.

Run only The Oracle diagnosis stage for this repository.

Inspect the repo structure, README, documentation, package files, source folders, config files, and existing Markdown files.

Create or update:
- /meta-agent-os/03_outputs/diagnosis/ORACLE_DIAGNOSIS.md
- /meta-agent-os/05_memory/project_brain.md
- /meta-agent-os/05_memory/assumptions_log.md
- /meta-agent-os/05_memory/decision_log.md
- /meta-agent-os/00_control/STAGE_STATE.json
- /meta-agent-os/00_control/STAGE_STATE.md

Do not modify application source code.

End with the recommended next stage.
```

## Resume Trigger

```text
Read AGENTS.md, CODEX_RUNBOOK.md, /meta-agent-os/00_control/STAGE_STATE.json, /meta-agent-os/00_control/STAGE_STATE.md, /meta-agent-os/00_control/RESUME_PROTOCOL.md, and /meta-agent-os/00_control/STAGE_GATES.md.

Resume the Meta Agent OS from the latest incomplete stage.

Inspect existing outputs under:
- /meta-agent-os/03_outputs
- /meta-agent-os/05_memory

Do not redo completed stages unless an output is missing, weak, invalid, or I ask for revision.

Stop at human decision gates.

Update `STAGE_STATE.json` after progress and keep `STAGE_STATE.md` as its human-readable mirror.

End with a concise status report.
```

## Status Trigger

```text
Read AGENTS.md, CODEX_RUNBOOK.md, /meta-agent-os/00_control/STAGE_STATE.json, /meta-agent-os/00_control/STAGE_STATE.md, and /meta-agent-os/00_control/STAGE_STATUS_TEMPLATE.md.

Check whether the expected output files exist.

Report:
- current stage
- completed stages
- missing outputs
- blocked status
- whether human approval is required
- last output
- next recommended action

Do not modify files unless I explicitly ask you to.
```

## Codex Operating Rules

When using this system, Codex should:

1. Read `AGENTS.md` first.
2. Treat `CODEX_RUNBOOK.md` as the Codex-specific trigger manual.
3. Use `STAGE_STATE.json` to track progress and keep `STAGE_STATE.md` synchronized as the human-readable mirror.
4. Use `STAGE_GATES.md` to decide when to stop.
5. Use `RESUME_PROTOCOL.md` after interruptions.
6. Prefer Markdown output during diagnosis and planning.
7. Avoid modifying application code unless explicitly approved.
8. Create stage outputs under `/meta-agent-os/03_outputs`.
9. Update durable memory under `/meta-agent-os/05_memory`.
10. End every run with status and next action.

## Recommended First Codex Command

Use the Full Run Trigger above.

If the repo is large or messy, start with the Diagnosis-Only Trigger first.

## Skill Adapter

This repo includes a compact reusable skill adapter at:

```text
skills/meta-agent-os/SKILL.md
```

Use it as a navigation layer when operating Meta Agent OS from Codex. The canonical framework still lives in `/meta-agent-os`; the skill must not become a second source of truth.

## v0.4 Codex Reliability Trigger

Preferred v0.4 prompt:

```text
Read AGENTS.md and CODEX_RUNBOOK.md, then run the Codex Full Run Prompt v0.4 from /meta-agent-os/00_control/codex/full_run_v0_4.md.
```

Codex should use:

```text
/meta-agent-os/00_control/STAGE_STATE.json
```

as the machine-readable state tracker, and:

```text
/meta-agent-os/00_control/STAGE_STATE.md
```

as the human-readable mirror.

Before advancing any stage, validate against:

```text
/meta-agent-os/00_control/schemas
/meta-agent-os/00_control/validators
/meta-agent-os/00_control/QUALITY_BAR.md
```
