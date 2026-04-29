# /validate-stage

Validate the current Meta Agent OS stage output.

## Instructions

1. Read:
   - `/meta-agent-os/00_control/STAGE_STATE.md`
   - `/meta-agent-os/00_control/STAGE_STATE.json`
   - `/meta-agent-os/00_control/STAGE_MANIFEST.json`
   - `/meta-agent-os/00_control/validators/GLOBAL_STAGE_VALIDATOR.md`
   - the current stage validator
   - the current stage schema

2. Check whether the current stage output exists and meets the schema.

3. Report:
   - pass/fail
   - missing sections
   - weak sections
   - risks
   - whether the system may advance

4. Do not advance the stage unless explicitly asked.
