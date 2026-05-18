# This Repository Contains a Self-Hosted Example Run

The Meta Agent OS was run **on itself** to produce its own public-release
plan. That means the following files in this repository are a **worked
example**, not framework defaults you must keep:

- `meta-agent-os/03_outputs/**` — example stage outputs (Oracle → Guardian → Builder)
- `meta-agent-os/05_memory/**` — example memory (project brain, decision log, assumptions, changelog)
- `meta-agent-os/00_control/STAGE_STATE.json` — example run state

## What is the framework vs. what is the example

| Treat as the framework (reuse as-is) | Treat as example (reset for your project) |
|---|---|
| `meta-agent-os/00_control/` control files, `schemas/`, `validators/` | `meta-agent-os/03_outputs/**` |
| `.claude/commands/`, `CLAUDE.md`, `AGENTS.md`, `INSTALL.md` | `meta-agent-os/05_memory/**` |
| `scripts/`, `.github/workflows/` | `STAGE_STATE.json` (reset to a fresh run) |

## When you adopt this framework

Start a clean run for **your** project. Do **not** delete the example
history in this upstream repo — it is preserved deliberately (the
methodology's audit trail is part of the demonstration). In your own copy,
reset `STAGE_STATE.json` and clear `03_outputs/` / `05_memory/` to begin
fresh. See `INSTALL.md`.

The control-layer integrity check (`scripts/check_control_integrity.py`,
run in CI) guards only the **framework** files — it does not depend on the
example outputs.
