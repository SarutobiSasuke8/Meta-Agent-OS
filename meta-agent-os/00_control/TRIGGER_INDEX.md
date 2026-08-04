# TRIGGER_INDEX.md

## Purpose

This file lists the correct trigger method for each agentic coding environment.

## Claude Code

Use slash commands:

```text
/diagnose
/run-meta-agent-os
/continue-meta-agent-os
/stage-status
```

Claude-specific files:

```text
CLAUDE.md
.claude/commands/diagnose.md
.claude/commands/run-meta-agent-os.md
.claude/commands/continue-meta-agent-os.md
.claude/commands/stage-status.md
```

## Codex

Use prompt-based triggers.

Codex-specific files:

```text
AGENTS.md
CODEX_RUNBOOK.md
/meta-agent-os/00_control/codex/full_run.md
/meta-agent-os/00_control/codex/diagnose_only.md
/meta-agent-os/00_control/codex/resume.md
/meta-agent-os/00_control/codex/status.md
```

Best first prompt:

```text
Read AGENTS.md and CODEX_RUNBOOK.md, then run the full Meta Agent OS.
```

## Cursor / Generic Coding Agents

Use:

```text
/meta-agent-os/00_control/full_run_prompt.md
```

or:

```text
Read AGENTS.md, META_AGENT_BOOTSTRAP.md, and /meta-agent-os/00_control/full_run_prompt.md. Then run the full Meta Agent OS.
```

## Manual Mode

If no agentic tool is available, manually execute stages using:

```text
/meta-agent-os/00_control/RUN_META_AGENT_OS.md
/meta-agent-os/00_control/STAGE_STATE.md
/meta-agent-os/00_control/STAGE_GATES.md
```
