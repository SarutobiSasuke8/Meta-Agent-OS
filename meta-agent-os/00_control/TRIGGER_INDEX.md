# TRIGGER_INDEX.md

## Purpose

This file lists the correct trigger method for each agentic coding environment.

## Claude Code

Use the `/mao-*` slash command generation:

| Command | File | Purpose |
|---|---|---|
| `/mao-diagnose` | `.claude/commands/mao-diagnose.md` | Run or refresh the Oracle diagnosis stage |
| `/mao-status` | `.claude/commands/mao-status.md` | Report Meta Agent OS status without changing files |
| `/mao-resume` | `.claude/commands/mao-resume.md` | Resume from the latest incomplete stage |
| `/mao-validate` | `.claude/commands/mao-validate.md` | Validate current state and current stage output |
| `/mao-harden` | `.claude/commands/mao-harden.md` | Harden the Meta Agent OS repository structure |
| `/mao-export-pack` | `.claude/commands/mao-export-pack.md` | Prepare Meta Agent OS for reuse in another repository |
| `/mao-memory` | `.claude/commands/mao-memory.md` | Update durable Meta Agent OS memory |
| `/mao-init` | `.claude/commands/mao-init.md` | One-time reset to a fresh, unstarted state in a newly adopted project |

Claude-specific files:

```text
CLAUDE.md
.claude/commands/mao-init.md
.claude/commands/mao-diagnose.md
.claude/commands/mao-status.md
.claude/commands/mao-resume.md
.claude/commands/mao-validate.md
.claude/commands/mao-harden.md
.claude/commands/mao-export-pack.md
.claude/commands/mao-memory.md
```

## Codex

Use prompt-based triggers.

Codex-specific files:

```text
AGENTS.md
CODEX_RUNBOOK.md
/meta-agent-os/00_control/codex/full_run_v0_4.md
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
