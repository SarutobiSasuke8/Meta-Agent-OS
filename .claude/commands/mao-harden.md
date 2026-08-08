# /mao-harden

Harden the Meta Agent OS repository structure.

## Instructions

1. Read:
   - `AGENTS.md`
   - `docs/REPO_HARDENING.md` if present
   - `meta-agent-os/00_control/STAGE_MANIFEST.json`
   - `meta-agent-os/00_control/OUTPUT_MANIFEST.json`
   - `meta-agent-os/00_control/STAGE_STATE.json`
   - `meta-agent-os/00_control/QUALITY_BAR.md`

2. Check for missing or inconsistent:
   - Control files
   - Schemas
   - Validators
   - Codex prompts
   - Claude slash commands
   - `skills/meta-agent-os`
   - Memory files
   - CI and PR templates

3. Run:

```powershell
./scripts/check-meta-agent-os.ps1 -Strict
```

4. If the check fails because expected files are missing, restore them from a preserved version snapshot. Historical versions are archived as git tags (`v0.1`, `v0.2`, `v0.4`, `v0.5`, `v0.6`, `v0.6.1`), not in-tree folders. Recover a file with `git checkout <tag> -- <path>` (e.g. `git checkout v0.6.1 -- meta-agent-os/00_control/...`), or list a snapshot's tree with `git ls-tree -r <tag>`.

5. Keep changes scoped to repo hardening. Do not alter stage methodology unless requested.

6. Update memory files with assumptions, decisions, and changelog entries.

7. End with verification results and remaining risks.
