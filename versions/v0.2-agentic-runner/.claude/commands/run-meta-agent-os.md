# /run-meta-agent-os

Run the full Meta Agent OS sequence for this repository.

## Instructions

1. Read:
   - `CLAUDE.md`
   - `AGENTS.md`
   - `META_AGENT_BOOTSTRAP.md`
   - `/meta-agent-os/00_control/RUN_META_AGENT_OS.md`
   - `/meta-agent-os/00_control/STAGE_STATE.md`
   - `/meta-agent-os/00_control/STAGE_GATES.md`
   - `/meta-agent-os/00_control/RESUME_PROTOCOL.md`
   - `/meta-agent-os/00_control/AGENT_MANIFEST.md`

2. Inspect the repository context.

3. Continue through the Meta Agent OS stages in order:

```text
Oracle → Sophia → Cartographer → Architect → QS → Guardian → Builder → Evaluator → Orchestrator → Librarian
```

4. After each stage:
   - Create the required output file.
   - Update `STAGE_STATE.md`.
   - Update memory files as needed.
   - Check stage gates before continuing.

5. Stop only if:
   - Human approval is required.
   - The Guardian blocks the system.
   - The Builder would modify application code without approval.
   - External actions, credentials, payments, deployments, or destructive operations are required.
   - Required context is missing.

6. Do not modify application source code during the first full run unless explicitly authorised.

7. End with:
   - Current stage
   - Completed stages
   - Files created
   - Blockers
   - Next recommended action
