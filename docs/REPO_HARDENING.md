# Repo Hardening Notes

## Objective

Identify useful hardening patterns from `vibe-coding-generalist-template` and adapt only the parts that fit Meta Agent OS.

## Inputs Used

- `C:\Users\sarut\Documents\Public GitHub Projects\vibe-coding-generalist-template\README.md`
- `C:\Users\sarut\Documents\Public GitHub Projects\vibe-coding-generalist-template\AGENTS.md`
- `C:\Users\sarut\Documents\Public GitHub Projects\vibe-coding-generalist-template\scripts\check-agent-docs.ps1`
- `C:\Users\sarut\Documents\Public GitHub Projects\vibe-coding-generalist-template\.github\workflows\agent-docs.yml`
- `C:\Users\sarut\Documents\Public GitHub Projects\vibe-coding-generalist-template\.github\pull_request_template.md`
- `meta-agent-os/00_control/STAGE_MANIFEST.json`
- `meta-agent-os/00_control/STAGE_STATE.json`
- `meta-agent-os/05_memory/project_brain.md`

## Findings

The two repos are converging around the same durable idea: a canonical agent contract plus thin tool adapters, persona-guided work, and deterministic checks that stop agent instructions from drifting.

The generalist template is a broad software-project starter. Meta Agent OS is narrower and stronger as a staged methodology. The useful transfer is not its full persona council or project brief structure, because Meta Agent OS already has personas, memory files, gates, and stage outputs. The useful transfer is its operational hardening pattern:

- scriptable drift checks
- CI that runs the checks on relevant documentation and control changes
- PR templates that match the repo handoff standard
- session or memory discipline for decision-heavy work

## Adopted Hardening

- Added `scripts/check-meta-agent-os.ps1` and `scripts/check-meta-agent-os.sh`.
- Added `.github/workflows/meta-agent-os.yml`.
- Added `.github/pull_request_template.md`.
- Added `.claude/commands/mao-*` operator commands.
- Added `skills/meta-agent-os` as a compact reusable skill adapter.
- Restored missing v0.4 reliability files from `versions/v0.4-reliability-layer/meta-agent-os/00_control` into the active root control layer.

## Assumptions

- Meta Agent OS should remain a methodology/control repo, not become a generic coding-template repo.
- The root `meta-agent-os/00_control` directory should be the active runtime control layer.
- The versioned `versions/v0.4-reliability-layer` files are authoritative for missing v0.4 reliability assets.

## Risks

- CI only protects checks once the repo is pushed to GitHub and Actions are enabled.
- The new check validates structure and references; it does not judge the semantic quality of stage outputs.
- The human-readable `STAGE_STATE.md` can still drift unless agents update it alongside `STAGE_STATE.json`.

## Open Questions

- Should Meta Agent OS also adopt a session-log folder, or should `05_memory` remain the single durable memory location?
- Should future strict mode fail on mojibake encoding artifacts in legacy Markdown files?
- Should the hardening check eventually validate stage-output sections against the Markdown schemas?

## Recommended Next Action

Run Cartographer on the public-release workflow, then Guardian before any deeper Builder changes.

## Files Created Or Updated

- `scripts/check-meta-agent-os.ps1`
- `scripts/check-meta-agent-os.sh`
- `.github/workflows/meta-agent-os.yml`
- `.github/pull_request_template.md`
- `.claude/commands/mao-status.md`
- `.claude/commands/mao-diagnose.md`
- `.claude/commands/mao-resume.md`
- `.claude/commands/mao-validate.md`
- `.claude/commands/mao-harden.md`
- `.claude/commands/mao-memory.md`
- `.claude/commands/mao-export-pack.md`
- `skills/meta-agent-os/SKILL.md`
- `skills/meta-agent-os/references/stage-lifecycle.md`
- `skills/meta-agent-os/references/output-standard.md`
- `docs/REPO_HARDENING.md`
- `meta-agent-os/00_control` restored reliability files and directories
