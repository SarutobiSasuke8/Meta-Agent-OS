# /mao-diagnose

Run or refresh the Oracle diagnosis stage.

## Instructions

1. Read:
   - `AGENTS.md`
   - `CLAUDE.md`
   - `CODEX_RUNBOOK.md`
   - `META_AGENT_BOOTSTRAP.md`
   - `meta-agent-os/00_control/STAGE_MANIFEST.json`
   - `meta-agent-os/00_control/STAGE_GATES.md`
   - `meta-agent-os/00_control/schemas/oracle_diagnosis_schema.md`
   - `meta-agent-os/00_control/validators/GLOBAL_STAGE_VALIDATOR.md`

2. Inspect the repository structure and key docs.

3. Create or update:
   - `meta-agent-os/03_outputs/diagnosis/ORACLE_DIAGNOSIS.md`
   - `meta-agent-os/05_memory/project_brain.md`
   - `meta-agent-os/05_memory/assumptions_log.md`
   - `meta-agent-os/05_memory/decision_log.md`

4. Update `STAGE_STATE.json` and `STAGE_STATE.md` using `JSON_STATE_UPDATE_PROTOCOL.md`.

5. Run `./scripts/check-meta-agent-os.ps1` when available.

6. End with the standard Meta Agent OS handoff.
