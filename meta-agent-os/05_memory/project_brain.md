# project_brain.md

**Last updated:** 2026-04-29  
**Stage:** Oracle (complete)

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

## Stage State (as of 2026-04-29)

| Stage | Status |
|---|---|
| Oracle | Complete |
| Sophia | Not started — awaiting deployment target decision |
| Cartographer | Not started |
| Architect | Not started |
| QS | Not started |
| Guardian | Not started |
| Builder | Not started |
| Evaluator | Not started |
| Orchestrator | Not started |
| Librarian | Not started |

## Open Decision

**Deployment target not confirmed.**  
Options: (A) ship the framework itself, (B) apply to a sibling repo, (C) apply to a new project.  
Oracle recommends Option A.

## Known Gaps

- No git commits or remote yet
- CLAUDE.md not at root (lives in versions/v0.4)
- v0.3 not a separate folder
- No README at root

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
