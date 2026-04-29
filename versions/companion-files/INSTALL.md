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
