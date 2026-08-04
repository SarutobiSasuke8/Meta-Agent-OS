# First Run Diagnosis Prompt

Paste this into Codex, Claude Code, Cursor, or another coding agent after dropping the Meta Agent OS into a repository.

```text
Read AGENTS.md, CLAUDE.md, and META_AGENT_BOOTSTRAP.md.

Run The Oracle diagnosis stage for this repository.

Inspect the repo structure and relevant documentation.

Create:
- /meta-agent-os/03_outputs/diagnosis/ORACLE_DIAGNOSIS.md
- /meta-agent-os/05_memory/project_brain.md
- /meta-agent-os/05_memory/assumptions_log.md
- /meta-agent-os/05_memory/decision_log.md

Do not modify application code yet.

Separate facts from assumptions.

After the diagnosis, recommend whether the next step should be Sophia research, Cartographer workflow mapping, or Architect system design.
```
