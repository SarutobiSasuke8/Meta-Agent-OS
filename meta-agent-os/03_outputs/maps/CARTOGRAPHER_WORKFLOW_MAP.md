# CARTOGRAPHER_WORKFLOW_MAP.md

**Stage:** Cartographer — Workflow, Stakeholder, Tool & Handoff Mapping
**Date:** 2026-05-18
**Status:** Complete
**Feeds into:** Architect, QS, Guardian

---

## Objective

Map the Meta Agent OS as a product being designed for public open-source release (decision D5: ship the framework itself as the product). Produce the workflow, stakeholder, tool, data, decision-point, and handoff map the Architect needs to design the public release structure and the QS needs to cost it.

This is a self-referential map: the "system" being charted is the framework's own run lifecycle and the human/tool workflow that surrounds adopting it.

---

## Inputs Used

- `meta-agent-os/03_outputs/diagnosis/ORACLE_DIAGNOSIS.md`
- `meta-agent-os/03_outputs/research/SOPHIA_RESEARCH_PORTFOLIO.md`
- `meta-agent-os/00_control/` (STAGE_MANIFEST.json, STAGE_STATE.json, STAGE_GATES.md, RUN_META_AGENT_OS.md, AGENT_MANIFEST.md, QUALITY_BAR.md, RUN_MODES.json, OUTPUT_MANIFEST.json)
- `meta-agent-os/05_memory/` (project_brain, decision_log, assumptions_log, changelog)
- Repository structure (`versions/`, `.claude/commands/`, root docs, `archive/`)

---

## 1. System Boundary

**In scope (the product):**

- The 10-persona staged methodology (Oracle → Librarian)
- The control layer: `meta-agent-os/00_control/` (state machine, gates, manifests, schemas, validators, run modes)
- The memory layer: `meta-agent-os/05_memory/`
- The output contract: `meta-agent-os/03_outputs/`
- Adoption surfaces: `.claude/commands/` slash commands, `CODEX_RUNBOOK.md`, `AGENTS.md`, `INSTALL.md`, `META_AGENT_BOOTSTRAP.md`
- Versioned history under `versions/` and the public release story (`ROADMAP.md`, `README.md`, `LICENSE`)

**Out of scope:**

- Any runtime execution engine (explicitly "Not Planned" in ROADMAP — defer to LangGraph/CrewAI/AutoGen)
- Hosted SaaS / GUI / web app
- The eventual target projects a *user* applies the framework to (their data and systems are outside this boundary)
- Commercial vertical packs (separate license, separate boundary — only referenced as future handoff)

**Boundary risk:** the framework is self-hosting (it is being run on itself). The boundary between "the product" and "this run's outputs" must stay clear so example outputs are not mistaken for shipped framework files.

---

## 2. Users And Stakeholders

| Stakeholder | Type | Relationship to System | Primary Need |
|---|---|---|---|
| SarutobiSasuke8 (owner/operator) | Internal | Runs the framework, owns the repo | Ship a clean, credible v0.4 public baseline |
| Management consultants | Tier 1 buyer (Sophia) | Adopt framework to spec client agent solutions | Reusable, defensible design templates |
| Enterprise architects | Tier 1 buyer | Design + govern multi-agent strategy pre-code | Cost/risk modelling, audit trail |
| Solution engineers / pre-sales | Tier 1 buyer | Spec RFP solutions without dev resources | Fast, repeatable playbooks |
| Product managers, governance/compliance teams | Tier 2 | Capability/cost modelling, stage gates as checkpoints | Communicable, auditable artifacts |
| Dev teams on CrewAI/LangGraph | Tier 2 | Use as pre-code specification layer | Reduce build rework |
| Open-source contributors | Ecosystem | Extend personas, schemas, packs | Clear contribution guidelines (gap — v0.5) |
| Agentic runtimes (Claude Code primary, Codex secondary) | Tool actor | Execute the staged run | Unambiguous control files |

**Out of scope users:** pure no-code builders, single-agent chatbot builders, teams with existing internal playbooks (Sophia §4).

---

## 3. Current-State Workflow

How the framework is operated **today** (v0.4, self-run):

1. User drops framework into a repo and ensures root `CLAUDE.md` is present.
2. User invokes `/diagnose` or `/run-meta-agent-os` (Claude Code) or the Codex runbook.
3. Agent reads control files, determines current stage from `STAGE_STATE.json`.
4. Agent runs the current persona, writes its output to the mapped path under `03_outputs/`.
5. Agent updates the four memory files and `STAGE_STATE.json`.
6. Agent advances to the next stage unless a stage gate or stop condition fires.
7. Human reviews at decision gates (e.g. deployment target, Guardian verdict, Builder code changes).

**Observed friction (current state):**

- Schemas and validators exist only under `versions/v0.4-reliability-layer/` — **not at the active root `meta-agent-os/00_control/`**. STAGE_MANIFEST.json references paths that do not resolve at root. The run works only because the operating agent reads the versioned copies.
- No root copies of some adoption docs were a prior gap (now resolved: root `CLAUDE.md`, `README.md`, `INSTALL.md`, `AGENTS.md` present).
- State is split across JSON (`STAGE_STATE.json`) and prose memory; manual edits risk drift.

---

## 4. Future-State Workflow

Target operation for the public v0.4 release:

1. User clones repo or copies `companion-files/` into their project.
2. `INSTALL.md` walks them through placing `CLAUDE.md`/`AGENTS.md` and the `meta-agent-os/` tree at root **with schemas and validators present at root**.
3. User picks a run mode (`RUN_MODES.json`: full_run / diagnose_only / resume).
4. Staged run proceeds with schema-validated outputs and per-stage validators enforced from root.
5. Human decision gates are explicit and documented in one place.
6. Librarian closes the run; memory files form the durable record.

**Delta current → future:** mirror `schemas/` and `validators/` into the root control folder; close pending decision PD2 (v0.6.1 migration handling); add contribution guidelines (deferred to v0.5).

---

## 5. Data Sources

| Data Source | Type | Sensitivity | Notes |
|---|---|---|---|
| Repository Markdown/JSON | Project context | None | Sole input to every stage |
| `05_memory/*` | Run state / decisions | None | Mutable; must preserve history (CLAUDE.md rule 6) |
| `03_outputs/*` | Stage artifacts | None | Append-only by convention; one file per stage |
| `00_control/*.json` | State machine | None | Source of truth for stage position |
| External migration spec (v0.6.1) | Off-repo reference | Unknown origin | Only a *note* exists in-repo; original lives on owner's machine |
| Future: user's target project | External | **Unknown — could be regulated** | Out of this boundary; Guardian must flag at adoption time |

Oracle confirmed (A6) no sensitive data in this repo. The sensitivity risk is entirely downstream, in projects users point the framework at.

---

## 6. Tools And Interfaces

| Tool / Interface | Role | Status |
|---|---|---|
| Claude Code (`.claude/commands/`) | Primary runtime; 5 slash commands | Active |
| Codex (`CODEX_RUNBOOK.md`, `00_control/codex/`) | Secondary runtime | Ready (versioned copy) |
| Generic agents (`AGENTS.md`) | Tertiary adoption path | Supported |
| Git / GitHub | Version control + public distribution | Active (branch `claude/review-project-status-dVMa0`); remote present |
| JSON state files | Machine-readable control | Active |
| Markdown schemas + validators | Output contract enforcement | **Present only in versioned copy — root gap** |

---

## 7. Decision Points

| ID | Decision | When | Owner |
|---|---|---|---|
| DP1 | Deployment target (A/B/C) | Before Sophia | Human — **resolved** (D5: Option A) |
| DP2 | License choice | Sophia | Resolved (D6: Apache 2.0 core) |
| DP3 | Primary audience | Sophia | Resolved (D7: consultants + architects) |
| DP4 | v0.6.1 migration handling | Before Builder | **OPEN — PD2** (full now / split commits / noted only) |
| DP5 | Architecture variant for public release | Architect | Pending — next stage |
| DP6 | Guardian verdict before Builder | Guardian | Pending |
| DP7 | Docs site vs GitHub-only launch | Sophia open Q | Open — defer to Architect/QS |

---

## 8. Human Approval Gates

Per `STAGE_GATES.md`, automatic continuation is allowed through Levels 0–2 (read-only, internal docs, internal framework setup). Hard stops:

- **Guardian verdict** not `Approved for prototype` / `Approved with restrictions` → stop before Builder.
- **Builder** modifying application code or installing packages → explicit human approval.
- **Level 3+** actions: external systems, deletion, credentials, spend → explicit approval.
- **PD2 (v0.6.1 migration)** is a live decision gate the human should close before Builder runs, or Builder scope is ambiguous.

This run (Cartographer) is Level 1–2 (internal documentation) — no gate; safe to proceed automatically per STAGE_GATES "Cartographer: may run automatically."

---

## 9. Automation Candidates

| Candidate | Rationale |
|---|---|
| Stage advancement + STAGE_STATE.json updates | Deterministic; already semi-automated, low risk |
| Schema conformance check on each stage output | Mechanical; reduces drift |
| Memory file appends (changelog, decision_log) | Repetitive, rule-driven |
| Root ↔ versioned control-file sync | Currently manual and error-prone; prime automation target |

## 10. Agent Candidates

The framework *is* the agent system. The 10 personas are the agent candidates and are already defined. No new agents are warranted to ship v0.4 — Architect should resist adding agents (STAGE_GATES: "Do not assume complex multi-agent architecture is required"). The genuine agent-fit work is **packaging and release**, not new personas.

## 11. Non-Agent Automation Candidates

These should be **scripts/CI, not agents**:

- A sync/lint script that copies `schemas/` and `validators/` into root and fails CI if root and versioned copies diverge.
- A `STAGE_STATE.json` schema validator.
- A release-packaging script that assembles the `companion-files/` install bundle.
- A Markdown structure linter enforcing the per-stage schemas.

## 12. Risk Zones

| Zone | Risk | Severity |
|---|---|---|
| Root vs versioned control files | Schemas/validators absent at root; manifest paths don't resolve at root — adopters get a broken validation layer | High |
| PD2 unresolved | Builder scope ambiguous; risk of half-implemented v0.5/v0.6/v0.6.1 in a "clean" baseline | Medium |
| Self-hosting confusion | This run's example outputs could ship as if they were framework defaults | Medium |
| State drift | JSON + prose memory edited by hand can disagree | Medium |
| Downstream data sensitivity | Users may point the framework at regulated data; framework gives no adoption-time Guardian prompt | Medium |
| No contribution guidelines | Open-source contributors lack a path (deferred v0.5) | Low |

## 13. Dependency Map

```
CLAUDE.md (root) ──► RUN_META_AGENT_OS.md ──► STAGE_MANIFEST.json
                                               │
                                               ├─► schemas/*  (ROOT GAP — only in versions/v0.4)
                                               ├─► validators/* (ROOT GAP — only in versions/v0.4)
                                               └─► STAGE_STATE.json ──► 03_outputs/<stage> ──► 05_memory/*
Oracle ─► Sophia ─► Cartographer ─► Architect ─► QS ─► Guardian ─► Builder ─► Evaluator ─► Orchestrator ─► Librarian
(each stage strictly depends on the prior stage's output file existing and passing its validator)
```

## 14. Handoff Map

| From | To | Artifact Handed Off | Contract |
|---|---|---|---|
| Oracle | Sophia | ORACLE_DIAGNOSIS.md | Diagnosis + open decision gate |
| Sophia | Cartographer | SOPHIA_RESEARCH_PORTFOLIO.md | Positioning, license, audience |
| **Cartographer** | **Architect** | **this file** | **System boundary, workflows, risk zones, recommendations** |
| Architect | QS | ARCHITECT_SYSTEM_DESIGN.md | Release-structure variants incl. ≥1 lightweight option |
| QS | Guardian | QS_COSTS_AND_OPTIONS.md | Phased plan + cost (mark estimates approximate) |
| Guardian | Builder | GUARDIAN_RISK_SECURITY_REVIEW.md | Verdict gate |
| Builder | Evaluator | BUILDER_IMPLEMENTATION_LOG.md | Built framework files only (no app code) |
| Evaluator | Orchestrator | EVALUATOR_QA_EVALS.md | Eval results |
| Orchestrator | Librarian | ORCHESTRATOR_RUNTIME_LOG.md | Runtime/routing record |
| Librarian | Complete | memory files | Durable record |

## 15. Recommendations For The Architect

1. **Treat "public release packaging" as the architecture problem**, not "design new agents." The persona set is fixed for v0.4.
2. **Make a root control-layer integrity decision.** Pick one: (a) mirror `schemas/` + `validators/` into root `meta-agent-os/00_control/` and add a sync check, or (b) re-point STAGE_MANIFEST.json to the versioned paths. Option (a) is recommended — adopters copy the root tree, not `versions/`.
3. **Provide at least one lightweight release variant** (per STAGE_GATES): e.g. "minimal companion bundle" vs "full repo with versioned history."
4. **Force closure of PD2 before Builder.** Recommend the documented stance (D8): ship clean v0.4, keep v0.5–v0.6.1 as ROADMAP only — and have Architect state this as a constraint so Builder scope is unambiguous.
5. **Separate product files from this run's example outputs.** Recommend an explicit convention so self-hosted outputs are clearly "example," not "default."
6. **Defer contribution guidelines and docs-site (DP7) to QS phasing** as v0.5 scope, not v0.4 blockers.

## 16. Files Created Or Updated

- Created: `meta-agent-os/03_outputs/maps/CARTOGRAPHER_WORKFLOW_MAP.md` (this file)
- To be updated by Librarian/state step: `STAGE_STATE.json`, `project_brain.md`, `assumptions_log.md`, `decision_log.md`, `changelog.md`

---

## Required Workflow Table

| Workflow Step | Current Owner | Input | Output | Frequency | Complexity | Risk | Agent Fit | Better As Script? | Human Approval Needed? |
|---|---|---|---|---|---|---|---|---|---|
| Diagnose project | Oracle persona | Repo context | ORACLE_DIAGNOSIS.md | Once / run | Medium | Low | High | No | No |
| Research & positioning | Sophia persona | Oracle output | SOPHIA_RESEARCH_PORTFOLIO.md | Once / run | Medium | Low | High | No | No |
| Map workflows | Cartographer persona | Oracle + Sophia | CARTOGRAPHER_WORKFLOW_MAP.md | Once / run | Medium | Low | High | No | No |
| Design variants | Architect persona | + Cartographer | ARCHITECT_SYSTEM_DESIGN.md | Once / run | High | Medium | High | No | No |
| Cost & phase | QS persona | Architect design | QS_COSTS_AND_OPTIONS.md | Once / run | Medium | Medium | High | Partly (calc) | No |
| Risk & security review | Guardian persona | Architect + QS | GUARDIAN_RISK_SECURITY_REVIEW.md | Once / run | High | High | High | No | Verdict gate |
| Build framework files | Builder persona | Guardian-approved scope | BUILDER_IMPLEMENTATION_LOG.md | Once / run | High | High | Restricted | No | Yes (code/pkg) |
| Evaluate quality | Evaluator persona | Built system | EVALUATOR_QA_EVALS.md | Once / run | Medium | Medium | High | Partly | No |
| Runtime routing | Orchestrator persona | Eval-approved system | ORCHESTRATOR_RUNTIME_LOG.md | Once / run | Medium | Medium | Restricted | No | No external |
| Update memory/docs | Librarian persona | All outputs | memory files | Per stage | Low | Low | High | Partly (appends) | No |
| Advance stage + write state | Runtime agent | Stage output + validator | Updated STAGE_STATE.json | Per stage | Low | Medium | Low | **Yes** | No |
| Sync root ↔ versioned control files | Manual (gap) | versions/v0.4 control files | Root control files | On release | Low | High | Low | **Yes** | No |

---

## Assumptions

- A8: "Public release" means GitHub-distributed Apache-2.0 framework (from D5/D6); a docs site is optional and out of v0.4 scope.
- A9: The persona set is frozen for v0.4 — no new agents needed to ship.
- A10: The root control folder *should* be the adopter's source of truth (not `versions/`).

## Risks (summary)

Root control-layer integrity gap (High), unresolved PD2 (Medium), self-hosting/example-output confusion (Medium), state drift (Medium), downstream data sensitivity (Medium).

## Open Questions

1. Should STAGE_MANIFEST.json point to root paths (requires mirroring schemas/validators) or to versioned paths? — Architect to resolve.
2. Is PD2 closed in favour of D8 (ship clean v0.4, ROADMAP-only for v0.5–v0.6.1)? — needs explicit human confirmation before Builder.
3. GitHub-only vs docs-site launch (Sophia open Q / DP7)? — QS phasing input.

## Recommended Next Action

Proceed to **Architect**. Architect should design 2–3 public-release structure variants (including one lightweight option), resolve Open Question 1 (root control-layer integrity), and treat PD2/D8 as a fixed constraint pending human confirmation.
