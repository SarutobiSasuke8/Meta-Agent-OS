# /mao-init

One-time reset that turns this copy of Meta Agent OS into a fresh, unstarted framework for a new project.

Run this once, immediately after copying the framework into a new project, before running `/mao-diagnose` or any other stage command. Do not run this again inside a project that already has a real run in progress: it resets state and moves prior outputs out of the way, so a second run in the same project would bury real work.

## Why This Exists

Meta Agent OS ships with `STAGE_STATE.json` already marked `"status": "complete"` with all ten stages finished, because this repository is Meta Agent OS's own self-run. Without this command, a new adopter who clones the repo and runs a stage command is told their project is already done and is handed ten documents about the Meta Agent OS repository itself instead of their own project.

## Instructions

1. Confirm this looks like a fresh install, not a project mid-run:
   - If `meta-agent-os/00_control/STAGE_STATE.json` has `"status"` other than `"complete"`, or `"completed_stages"` is not the full ten-stage list, stop and ask the user whether they really want to reset — this may already be a fresh or partially-run project.
   - If this is Meta Agent OS's own repository (the framework's own source, not a copy adopted into another project), stop and ask for explicit confirmation before touching `03_outputs/` — those outputs are the framework's own proof-of-work and reference example, not disposable scratch state.

2. Ask the user to confirm the target project name. Do not guess it from the folder name without confirming.

3. Copy `meta-agent-os/00_control/STAGE_STATE.template.json` over `meta-agent-os/00_control/STAGE_STATE.json`, then fill in:
   - `"last_updated"`: today's date.
   - `"current_objective"`: a one-line objective naming the confirmed project (e.g. `"Run Oracle diagnosis for <project name>."`).
   - Leave `"status": "not_started"`, `"current_stage": "Oracle"`, `"next_stage": "Oracle"`, `"completed_stages": []`, and all `"stage_status"` entries at `"not_started"`.

4. Reset the human-readable mirror `meta-agent-os/00_control/STAGE_STATE.md` to match: current stage Oracle, status not started, no completed stages, next stage Oracle.

5. Move existing contents of `meta-agent-os/03_outputs/` to `meta-agent-os/03_outputs/_meta-agent-os-self-run-reference/` rather than deleting them. These are Meta Agent OS's own proof-of-work outputs and are worth keeping as a worked reference example — just out of the way of the new project's fresh run. Skip this step if `03_outputs/` is already empty or already contains only the reference folder.

6. Update `meta-agent-os/05_memory/project_brain.md` to name the new project instead of Meta Agent OS itself, preserving the file's structure. Do not delete the file; this is a fresh project's memory file, not Meta Agent OS's own.

7. Report what was reset, what was moved, and confirm the next command to run is `/mao-diagnose`.

## Safety

- This command never touches git history.
- This command never deletes `03_outputs/` content; it only moves it.
- If run inside Meta Agent OS's own repository without explicit confirmation in step 1, refuse and explain why.
