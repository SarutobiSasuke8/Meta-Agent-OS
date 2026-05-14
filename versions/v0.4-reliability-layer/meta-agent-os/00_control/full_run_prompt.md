# Full Run Prompt

Use this in Codex, Cursor, Claude Code, or another coding agent if slash commands are unavailable.

```text
Read CLAUDE.md, AGENTS.md, META_AGENT_BOOTSTRAP.md, and all files in /meta-agent-os/00_control.

Run the full Meta Agent OS sequence for this repository:

Oracle -> Sophia -> Cartographer -> Architect -> QS -> Guardian -> Builder -> Evaluator -> Orchestrator -> Librarian.

Use STAGE_STATE.md as the state tracker.

Create each required output file under /meta-agent-os/03_outputs and update memory files under /meta-agent-os/05_memory.

Do not modify application source code unless I explicitly approve it.

Stop at any human decision gate defined in STAGE_GATES.md.

End with stage status, files created, blockers, and next recommended action.
```

## Codex Note

For Codex, prefer:

```text
CODEX_RUNBOOK.md
/meta-agent-os/00_control/codex/full_run.md
```
