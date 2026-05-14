# Codex Full Run Prompt v0.4

```text
Read AGENTS.md, CODEX_RUNBOOK.md, META_AGENT_BOOTSTRAP.md, and all files in /meta-agent-os/00_control.

Pay special attention to:
- STAGE_STATE.json
- STAGE_MANIFEST.json
- RUN_MODES.json
- OUTPUT_MANIFEST.json
- QUALITY_BAR.md
- STAGE_ADVANCEMENT_PROTOCOL.md
- JSON_STATE_UPDATE_PROTOCOL.md
- validators/GLOBAL_STAGE_VALIDATOR.md

Run the full Meta Agent OS sequence for this repository:

Oracle -> Sophia -> Cartographer -> Architect -> QS -> Guardian -> Builder -> Evaluator -> Orchestrator -> Librarian.

Use STAGE_STATE.json as the machine-readable state tracker and STAGE_STATE.md as the human-readable mirror.

After every stage:
1. Create the required output file.
2. Validate the output against its schema and validator.
3. Update STAGE_STATE.json.
4. Update STAGE_STATE.md.
5. Update memory files under /meta-agent-os/05_memory where relevant.
6. Check stage gates before advancing.

Do not modify application source code unless I explicitly approve it.

Stop at any human decision gate defined in STAGE_GATES.md.

End with:
- current stage
- completed stages
- files created or updated
- validation status
- blockers
- next recommended action
```
