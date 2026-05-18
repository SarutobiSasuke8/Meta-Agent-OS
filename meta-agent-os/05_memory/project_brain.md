# project_brain.md

**Last updated:** 2026-05-18  
**Stage:** Architect (complete) — next: QS

---

## What This Project Is

The Meta Agent OS is a Markdown-based framework for running structured multi-agent workflows. It orchestrates ten specialised personas (Oracle through Librarian) in a controlled stage sequence, from diagnosis to live operation.

It is a methodology + prompt library + control layer — not a running application.

## Current Version

v0.4 — Reliability Layer. Adds JSON state, schemas, run modes, quality bar, and advancement protocol on top of the v0.2 agentic runner.

## Owner

SarutobiSasuke8 / thecrypticgamingguild@gmail.com

## Primary Runtime

Claude Code. Secondary: Codex.

## Stage State (as of 2026-05-18)

| Stage | Status |
|---|---|
| Oracle | Complete |
| Sophia | Complete |
| Cartographer | Complete |
| Architect | Complete |
| QS | Not started — next |
| QS | Not started |
| Guardian | Not started |
| Builder | Not started |
| Evaluator | Not started |
| Orchestrator | Not started |
| Librarian | Not started |

## Resolved Decisions

- **Deployment target:** Option A — ship the framework itself as the product (D5).
- **License:** Apache 2.0 core; commercial vertical packs (D6).
- **Audience:** management consultants + enterprise architects (D7).

## Open Decision

**PD2 — v0.6.1 migration handling.** Effectively deferred by D8 (ship clean v0.4, keep v0.5–v0.6.1 as ROADMAP only) but not formally closed. Cartographer flags this must be confirmed by a human before the Builder stage.

## Known Gaps

- **Root control-layer integrity gap (High):** `schemas/` and `validators/` exist only under `versions/v0.4-reliability-layer/`, not at root. **Architect resolution (D9): Variant B** — Builder will mirror them into root `00_control/` (no manifest change) + add a CI drift script. Pending QS cost + Guardian approval.
- Self-hosting risk: this run's example outputs must not ship as framework defaults.
- No contribution guidelines (deferred to v0.5).
- Git commits + remote now in place; root CLAUDE.md/README/INSTALL/AGENTS present.

## Pending Migration Target

v0.6.1 has been noted as the next target state from an external migration spec, but the repo has not yet been upgraded. The migration adds:

- v0.5 Commercial Refinement Layer
- v0.6 Inference Economics Layer
- v0.6.1 Inference Safety Layer

Migration note:

```text
meta-agent-os/03_outputs/migration/V0_4_TO_V0_6_1_MIGRATION_NOTE.md
```

Open implementation decision: whether to run the full v0.6.1 Builder migration now, split it into v0.5/v0.6/v0.6.1 commits, or keep the migration noted only.
