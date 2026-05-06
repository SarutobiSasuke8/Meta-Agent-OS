---
name: meta-agent-os
description: Use when Codex needs to run, resume, validate, harden, install, or operate the Meta Agent OS methodology in a repository; triggers include "Meta Agent OS", "run diagnosis", "diagnose before design", "resume stage", "validate stage", "harden this repo", "agent framework", "multi-agent system design", and "export the Meta Agent OS pack".
---

# Meta Agent OS

Use this skill as a compact operator adapter. The canonical framework remains the repository files under `meta-agent-os/`; do not duplicate or replace them.

## Core Rule

Diagnose before design. Design before build. Run Guardian before Builder modifies implementation files.

## First Reads

When operating inside a repo that already contains Meta Agent OS, read:

- `AGENTS.md`
- `CODEX_RUNBOOK.md`
- `META_AGENT_BOOTSTRAP.md`
- `meta-agent-os/00_control/STAGE_STATE.json`
- `meta-agent-os/00_control/STAGE_MANIFEST.json`
- `meta-agent-os/00_control/STAGE_GATES.md`
- `meta-agent-os/00_control/QUALITY_BAR.md`

For detailed navigation, read `references/stage-lifecycle.md`. For output structure, read `references/output-standard.md`.

## Common Operations

- Diagnose only: run Oracle and write `meta-agent-os/03_outputs/diagnosis/ORACLE_DIAGNOSIS.md`.
- Status: inspect state, completed stages, expected outputs, blockers, and next action.
- Resume: continue from `STAGE_STATE.json` without redoing completed stages unless output is missing or weak.
- Validate: check the current output against its schema, stage validator, global validator, quality bar, and stage gates.
- Harden: run `scripts/check-meta-agent-os.ps1 -Strict`; repair missing control assets only from an authoritative versioned source.
- Memory: append durable updates to `meta-agent-os/05_memory`.
- Export: verify root docs, control files, schemas, validators, slash commands, skill adapter, scripts, and CI before reuse.

## State Rules

Use `STAGE_STATE.json` as machine-readable truth and `STAGE_STATE.md` as the human mirror. Update both after stage progress.

Do not mark a stage complete until the expected output exists, the relevant schema and validator have been checked, the global validator has been applied, and `STAGE_GATES.md` allows advancement.

## Safety Rules

- Do not delete files.
- Do not overwrite valuable memory; append dated updates.
- Do not perform external actions, credentials changes, deployments, payments, or irreversible changes without explicit approval.
- Do not modify application code during diagnosis.

## Handoff

Every major output should include:

- Objective
- Inputs used
- Findings
- Assumptions
- Risks
- Open questions
- Recommended next action
- Files created or updated
