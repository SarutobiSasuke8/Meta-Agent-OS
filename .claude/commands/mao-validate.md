# /mao-validate

Validate the current Meta Agent OS state and current stage output.

## Instructions

1. Read:
   - `meta-agent-os/00_control/STAGE_STATE.json`
   - `meta-agent-os/00_control/STAGE_STATE.md`
   - `meta-agent-os/00_control/STAGE_MANIFEST.json`
   - `meta-agent-os/00_control/OUTPUT_MANIFEST.json`
   - `meta-agent-os/00_control/QUALITY_BAR.md`
   - `meta-agent-os/00_control/STAGE_ADVANCEMENT_PROTOCOL.md`
   - `meta-agent-os/00_control/validators/GLOBAL_STAGE_VALIDATOR.md`
   - the current stage schema
   - the current stage validator

2. Run `./scripts/check-meta-agent-os.ps1` if available.

3. Check the current stage output for:
   - Required sections
   - Repo-grounded evidence
   - Assumptions
   - Risks
   - Open questions
   - Recommended next action
   - Files created or updated

4. Report pass/fail, weak sections, missing sections, and whether advancement is allowed.

5. Do not advance the stage unless explicitly asked.
