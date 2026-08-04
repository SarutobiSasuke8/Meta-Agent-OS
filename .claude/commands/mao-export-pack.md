# /mao-export-pack

Prepare Meta Agent OS for reuse in another repository.

## Instructions

1. Read:
   - `README.md`
   - `INSTALL.md`
   - `AGENTS.md`
   - `CLAUDE.md`
   - `CODEX_RUNBOOK.md`
   - `META_AGENT_BOOTSTRAP.md`
   - `docs/REPO_HARDENING.md`
   - `meta-agent-os/00_control/OUTPUT_MANIFEST.json`
   - `meta-agent-os/00_control/STAGE_MANIFEST.json`
   - `skills/meta-agent-os/SKILL.md`

2. Run the hardening check:

```powershell
./scripts/check-meta-agent-os.ps1 -Strict
```

3. Report whether the repo is ready to copy as a framework pack:
   - Required root docs
   - `meta-agent-os` control layer
   - Schemas and validators
   - Claude commands
   - Codex prompts
   - Skill adapter
   - Hardening scripts
   - CI files

4. If asked to produce an actual archive, request explicit approval before creating or deleting files outside the repo.

5. End with ready/not ready, blockers, and recommended next action.
