# /continue-meta-agent-os

Resume the Meta Agent OS from the latest incomplete stage.

## Instructions

1. Read:
   - `/meta-agent-os/00_control/STAGE_STATE.md`
   - `/meta-agent-os/00_control/RESUME_PROTOCOL.md`
   - `/meta-agent-os/00_control/STAGE_GATES.md`

2. Inspect existing outputs under:

```text
/meta-agent-os/03_outputs
/meta-agent-os/05_memory
```

3. Identify the first incomplete stage.

4. Continue from that stage.

5. Do not redo completed stages unless an output is missing, invalid, or the user asks for revision.

6. Stop at human decision gates.

7. Update `STAGE_STATE.md` after progress.
