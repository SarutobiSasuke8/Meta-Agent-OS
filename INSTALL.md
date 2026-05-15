# Install Meta Agent OS Companion Files

## 1. Copy Files To Project Root

Copy these files into the root of your target project:

```text
CLAUDE.md
AGENTS.md
META_AGENT_BOOTSTRAP.md
.claude/commands/diagnose.md
meta-agent-os/
```

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
Read AGENTS.md and CODEX_RUNBOOK.md, then run the Diagnosis-Only Trigger from CODEX_RUNBOOK.md.
```

### Resume In Codex

Paste:

```text
Read AGENTS.md and CODEX_RUNBOOK.md, then run the Resume Trigger from CODEX_RUNBOOK.md.
```

### Status In Codex

Paste:

```text
Read AGENTS.md and CODEX_RUNBOOK.md, then run the Status Trigger from CODEX_RUNBOOK.md.
```

## v0.4 Reliability Layer

v0.4 adds machine-readable state and validation.

After install, the most robust Codex trigger is:

```text
Read AGENTS.md and CODEX_RUNBOOK.md, then run the Full Run Trigger from CODEX_RUNBOOK.md.
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
/meta-agent-os/00_control/STAGE_ADVANCEMENT_PROTOCOL.md
/meta-agent-os/00_control/JSON_STATE_UPDATE_PROTOCOL.md
```
