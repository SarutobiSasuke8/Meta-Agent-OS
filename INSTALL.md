# Install Meta Agent OS Companion Files

## 1. Copy Files To Project Root

Copy these files into the root of your target project:

```text
CLAUDE.md
AGENTS.md
META_AGENT_BOOTSTRAP.md
.claude/commands/
meta-agent-os/
```

The `meta-agent-os/00_control/` folder is the **canonical control layer**
and now ships its own `schemas/` and `validators/` at root — you do **not**
need the `versions/` history for a working install. The slim install bundle
in `versions/companion-files/` includes this complete control layer and a
fresh `STAGE_STATE.json`.

## 2. Start Diagnosis

### Claude Code

From the project root, run Claude Code and use:

```text
/diagnose
```

Or paste:

```text
Read CLAUDE.md, AGENTS.md, and META_AGENT_BOOTSTRAP.md. Run The Oracle diagnosis stage for this repository.
```

### Codex

From the project root, run Codex and say:

```text
Read AGENTS.md and META_AGENT_BOOTSTRAP.md. Run The Oracle diagnosis stage for this repository.
```

## 3. Expected Outputs

The first run should create:

```text
/meta-agent-os/03_outputs/diagnosis/ORACLE_DIAGNOSIS.md
/meta-agent-os/05_memory/project_brain.md
/meta-agent-os/05_memory/assumptions_log.md
/meta-agent-os/05_memory/decision_log.md
```

## 4. Important Note

These files guide agent behaviour. They do not execute automatically by simply being present. You need to trigger them through a prompt, slash command, CLI command, scheduled routine, or automation.

## v0.2 Full Agentic Runner Commands

After copying the files into your project root, use these commands in Claude Code:

```text
/diagnose
```

Runs only The Oracle diagnosis.

```text
/run-meta-agent-os
```

Runs the full controlled sequence until complete or blocked by a human decision gate.

```text
/continue-meta-agent-os
```

Resumes from the latest incomplete stage.

```text
/stage-status
```

Reports current state and missing outputs.

## Expected Full Run Outputs

```text
/meta-agent-os/03_outputs/diagnosis/ORACLE_DIAGNOSIS.md
/meta-agent-os/03_outputs/research/SOPHIA_RESEARCH_PORTFOLIO.md
/meta-agent-os/03_outputs/maps/CARTOGRAPHER_WORKFLOW_MAP.md
/meta-agent-os/03_outputs/architecture/ARCHITECT_SYSTEM_DESIGN.md
/meta-agent-os/03_outputs/costs/QS_COSTS_AND_OPTIONS.md
/meta-agent-os/03_outputs/risk/GUARDIAN_RISK_SECURITY_REVIEW.md
/meta-agent-os/03_outputs/build/BUILDER_IMPLEMENTATION_LOG.md
/meta-agent-os/03_outputs/evals/EVALUATOR_QA_EVALS.md
/meta-agent-os/03_outputs/runtime/ORCHESTRATOR_RUNTIME_LOG.md
/meta-agent-os/05_memory/project_brain.md
/meta-agent-os/05_memory/decision_log.md
/meta-agent-os/05_memory/assumptions_log.md
/meta-agent-os/05_memory/changelog.md
```

## Important

The system is agentic when invoked through a tool that can read, reason, and write files.

It is not a daemon, server, scheduler, or autonomous background process.

## Codex Installation and Use

After copying the files into your project root, Codex should see:

```text
AGENTS.md
CODEX_RUNBOOK.md
META_AGENT_BOOTSTRAP.md
/meta-agent-os/00_control
```

### Full Run In Codex

Paste:

```text
Read AGENTS.md and CODEX_RUNBOOK.md, then run the full Meta Agent OS.
```

### Diagnosis Only In Codex

Paste:

```text
Read AGENTS.md and CODEX_RUNBOOK.md, then run the Codex Diagnosis-Only Prompt from /meta-agent-os/00_control/codex/diagnose_only.md.
```

### Resume In Codex

Paste:

```text
Read AGENTS.md and CODEX_RUNBOOK.md, then run the Codex Resume Prompt from /meta-agent-os/00_control/codex/resume.md.
```

### Status In Codex

Paste:

```text
Read AGENTS.md and CODEX_RUNBOOK.md, then run the Codex Status Prompt from /meta-agent-os/00_control/codex/status.md.
```

## v0.4 Reliability Layer

v0.4 adds machine-readable state and validation.

After install, the most robust Codex trigger is:

```text
Read AGENTS.md and CODEX_RUNBOOK.md, then run the Codex Full Run Prompt v0.4 from /meta-agent-os/00_control/codex/full_run_v0_4.md.
```

The most robust Claude Code trigger remains:

```text
/run-meta-agent-os
```

But the agent should now also read:

```text
/meta-agent-os/00_control/STAGE_STATE.json
/meta-agent-os/00_control/STAGE_MANIFEST.json
/meta-agent-os/00_control/RUN_MODES.json
/meta-agent-os/00_control/OUTPUT_MANIFEST.json
/meta-agent-os/00_control/QUALITY_BAR.md
/meta-agent-os/00_control/schemas/
/meta-agent-os/00_control/validators/
```

## Control-Layer Integrity Check

This release ships a read-only integrity check that verifies the root
control layer has not drifted from the v0.4 snapshot, that all
`STAGE_MANIFEST.json` schema/validator paths resolve, and that
`STAGE_STATE.json` is well-formed:

```text
python3 scripts/check_control_integrity.py
```

It runs automatically in CI (`.github/workflows/control-integrity.yml`) on
every push and pull request. It is strictly read-only — no writes, no
network, no secrets — and exits non-zero on drift so a broken control
layer cannot be released.

## Example Run vs. Framework

This upstream repository contains a **self-hosted example run** (the
framework was run on itself). When you adopt it, reset
`meta-agent-os/00_control/STAGE_STATE.json` and clear
`meta-agent-os/03_outputs/` and `meta-agent-os/05_memory/` to start a
fresh run for your own project. See `EXAMPLE_RUN.md` for the exact
framework-vs-example file split. Do not delete the upstream example
history — it is preserved deliberately as the methodology's audit trail.
