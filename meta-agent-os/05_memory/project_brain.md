# project_brain.md

**Last updated:** 2026-05-15  
**Stage:** Sophia (complete) — Cartographer next

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

## Stage State (as of 2026-05-15)

Authoritative tracker: `meta-agent-os/00_control/STAGE_STATE.json`.

| Stage | Status |
|---|---|
| Oracle | Complete |
| Sophia | Complete |
| Cartographer | In progress (current stage) |
| Architect | Not started |
| QS | Not started |
| Guardian | Not started |
| Builder | Not started |
| Evaluator | Not started |
| Orchestrator | Not started |
| Librarian | Not started |

## Resolved Decision

**Deployment target confirmed: Option A** — ship the Meta Agent OS itself
as an open framework product (decision_log D5). The framework is its own
demonstration use case.

## Known Gaps

- v0.3 not a separate folder (documented in README/ROADMAP, never built as a named version folder)
- v0.6.1 migration documented but deliberately deferred (decision_log D8)

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
