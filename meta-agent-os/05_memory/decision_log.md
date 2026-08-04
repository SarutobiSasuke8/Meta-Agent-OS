# decision_log.md

**Last updated:** 2026-05-15

---

| # | Date | Stage | Decision | Reason | Made By |
|---|---|---|---|---|---|
| D1 | 2026-04-29 | Oracle | Began with full-run mode on the Meta Agent OS repo itself | User said "lets begin" - CLAUDE.md protocol requires Oracle first | System |
| D2 | 2026-04-29 | Oracle | Created root-level meta-agent-os/ structure | CLAUDE.md: "If the folder is not present, create it before continuing" | System |
| D3 | 2026-04-29 | Oracle | Deployment target left open - human decision gate raised | Three viable options exist; cannot advance Sophia without clarity | System |

---

## Pending Decisions

| # | Decision Needed | Options | Recommended |
|---|---|---|---|
| PD2 | v0.6.1 migration execution | (A) Implement full migration now, (B) split into v0.5/v0.6/v0.6.1 commits, (C) keep as noted only | B if preparing a clean public history; A if speed matters |

---

## Additional Decisions - 2026-04-29 (continued)

| # | Date | Stage | Decision | Reason | Made By |
|---|---|---|---|---|---|
| D5 | 2026-04-29 | PD1 Resolution | Deployment target: ship Meta Agent OS itself as open framework product | User selected Option A - framework is the product | User |
| D6 | 2026-04-29 | Sophia | License: Apache 2.0 for core framework; commercial for vertical packs | Enterprise trust, multi-contributor patent protection, Open Core precedent | Sophia research |
| D7 | 2026-04-29 | Sophia | Primary audience: management consultants + enterprise architects (Tier 1) | Highest WTP; immediate TAM; self-referential use case for consulting pack | Sophia research |
| D8 | 2026-04-29 | Sophia | Deferred v0.6.1 migration - ship clean v0.4 baseline, document v0.5-v0.6.1 in ROADMAP.md | Speed to public release; avoids half-implemented features | System |

---

## Additional Decisions - 2026-04-29

| # | Date | Stage | Decision | Reason | Made By |
|---|---|---|---|---|---|
| D4 | 2026-04-29 | Librarian | Logged v0.4 to v0.6.1 migration as pending, not implemented | User provided an external migration spec and asked to note the changes | System |

---

## Additional Decisions - 2026-05-06

| # | Date | Stage | Decision | Reason | Made By |
|---|---|---|---|---|---|
| D9 | 2026-05-06 | Cartographer/Guardian | Adopted the generalist template's drift-check pattern as a Meta Agent OS hardening check | The repos are converging around canonical agent contracts, adapters, deterministic checks, and handoff discipline; Meta Agent OS needs a repo-specific validator rather than the whole generic template | Codex |
| D10 | 2026-05-06 | Builder | Added `/mao-*` operator commands and a `skills/meta-agent-os` adapter | The command layer improves day-to-day operation while the skill makes the framework easier to reuse from Codex without duplicating canonical control files | Codex |
| D11 | 2026-05-06 | Architect | Selected the Balanced public framework architecture | Lightweight is too thin for public trust; advanced CLI/product work is premature and overlaps Agent Ops OS | Codex |
| D12 | 2026-05-06 | Guardian | Approved internal framework Builder work with restrictions | Work is limited to docs, examples, validation, outputs, and memory; no external or destructive actions | Codex |
| D13 | 2026-05-06 | QS/Architect | Reframed v0.5 as Public Framework Polish before commercial packs | The repo needs clarity, examples, validation, and release polish before commercial refinement | Codex |
| D14 | 2026-05-06 | Librarian | Marked the active full run complete after Orchestrator and Librarian updates | All expected stage outputs now exist and strict validation passes | Codex |
| D15 | 2026-05-08 | Librarian | Codified v0.4 as complete for now as the public framework/spec layer | The repo is public and should remain the inspectable methodology/control-plane while true runtime execution moves to a separate implementation track | Codex |
| D16 | 2026-05-15 | Builder/Evaluator | Added release-readiness, runtime-track, and second-example assets without external actions | User asked to progress through all safe internal steps without further intervention | Codex |
| D17 | 2026-05-15 | Builder/Evaluator | Added JSON output mode to validation scripts and CI strict checks | Machine-readable validator results help future automation without creating a runtime engine | Codex |

---

## Additional Decisions - 2026-08-04

| # | Date | Stage | Decision | Reason | Made By |
|---|---|---|---|---|---|
| D18 | 2026-08-04 | Librarian | Cut v0.5 (Public Framework Polish) and tagged it | Every v0.5 roadmap item was already shipped except community guidelines; leaving the release undeclared made the repo look stalled at v0.4 | Claude |
| D19 | 2026-08-04 | Builder | Added `CONTRIBUTING.md`, `SECURITY.md`, `CODE_OF_CONDUCT.md`, and issue templates | Last outstanding v0.5 item, and the files a public repo is judged on first; `CONTRIBUTING.md` also routes runtime proposals to the separate track instead of rejecting them | Claude |
| D20 | 2026-08-04 | Evaluator | Extended strict validation from structural checks to substance checks | Heading-presence checks let an empty section pass as complete, which made the framework's own outputs the weakest evidence for its method | Claude |
| D21 | 2026-08-04 | Evaluator | Required `**Date:**` and `**Status:**` provenance on completed stage outputs, and blocked state older than its own outputs | The prior run left `STAGE_STATE.json` claiming a date earlier than an output it described, with nothing to catch it | Claude |
| D22 | 2026-08-04 | Evaluator | Added relative Markdown link validation to strict mode rather than a separate CI action | Keeps local and CI behaviour identical and avoids a third tool in a repo that deliberately has no dependencies | Claude |
| D23 | 2026-08-04 | Builder | Made the bash validator probe for a Python 3 interpreter by execution | The Windows Store `python3` alias is on PATH under Git Bash but only prints an install prompt, so presence checks resolved to a non-functional interpreter | Claude |
| D24 | 2026-08-04 | Architect/QS | Split the pending v0.6.1 migration into separate v0.6 and v0.6.1 increments | A single migration commit risks leaving state, manifests, schemas, and docs partially updated, which is the exact risk the migration note itself flags | Claude |
| D25 | 2026-08-04 | Guardian | Kept runtime track work outside this repository | Preserves the public core as the specification layer; R0 and R1 remain the correct first milestones | Claude |

| D26 | 2026-08-04 | QS/Builder | Shipped `MODEL_PRICING.json` empty, with no default model prices | Published rates change; a stale baked-in rate produces a confident wrong cost, which is more damaging than refusing to produce one | Claude |
| D27 | 2026-08-04 | QS/Evaluator | Made the ROI calculator refuse to run on undated, unsourced, or stale rates | A control that warns is ignored; a control that blocks is honoured. Mirrors the strict validator so the two cannot drift | Claude |
| D28 | 2026-08-04 | QS | Made a baseline mandatory and put supervision cost inside running cost | Excluding either is how agent proposals show returns they do not have | Claude |
| D29 | 2026-08-04 | QS/Evaluator | Report a sensitivity range rather than a point estimate, and flag when the verdict flips inside it | A single number hides the risk and invites false confidence in pre-build assumptions | Claude |
| D30 | 2026-08-04 | Builder | Added CI steps that exercise the calculator, including its refusal path | Without them the tooling could rot into documentation, which is the failure mode this increment was meant to avoid | Claude |

| D31 | 2026-08-04 | Oracle/Guardian | Made the anti-agent gate default to no | Every incentive in the market pushes toward more agents; this framework is the only cheap place left to ask whether one is needed | Claude |
| D32 | 2026-08-04 | Oracle | Made a failed gate condition override the suitability score entirely | A high score behind a failed gate is a well-scored wrong architecture, and reporting it as SUITABLE would be self-contradictory | Claude |
| D33 | 2026-08-04 | Oracle | Made `tolerance_for_error` and `recoverability` critical, capping at Not Suitable on a zero | High value plus low recoverability is precisely how agent systems cause compounding damage nobody notices | Claude |
| D34 | 2026-08-04 | Evaluator | Required a written justification per scored dimension, refusing to score without one | An unjustified score is an opinion with a number attached and cannot be argued with in review | Claude |
| D35 | 2026-08-04 | Guardian | Classified Guardian as the only C1 stage with no local substitution | Its failure mode is silent: a risk never surfaced produces no error message | Claude |
| D36 | 2026-08-04 | Guardian | Recorded missing parity evals as eval debt rather than approving local substitution for C2 | An eval that does not exist is a hypothesis, and approving on it would be the exact false confidence this layer exists to prevent | Claude |
| D37 | 2026-08-04 | Architect | Placed the suitability gate before the ROI gate | A workflow that fails suitability should never reach a cost model; the cost of the wrong architecture is not a useful number | Claude |
