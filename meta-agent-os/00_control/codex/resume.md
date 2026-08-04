# Codex Resume Prompt

```text
Read AGENTS.md, CODEX_RUNBOOK.md, /meta-agent-os/00_control/STAGE_STATE.json, /meta-agent-os/00_control/STAGE_STATE.md, /meta-agent-os/00_control/RESUME_PROTOCOL.md, and /meta-agent-os/00_control/STAGE_GATES.md.

Resume the Meta Agent OS from the latest incomplete stage.

Inspect existing outputs under:
- /meta-agent-os/03_outputs
- /meta-agent-os/05_memory

Do not redo completed stages unless an output is missing, weak, invalid, or I ask for revision.

Stop at human decision gates.

Update STAGE_STATE.json after progress and keep STAGE_STATE.md synchronized as the human-readable mirror.

End with a concise status report.
```
