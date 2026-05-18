# ARCHITECT_SYSTEM_DESIGN.md

**Stage:** Architect — Multi-Agent Architecture & Public-Release Design
**Date:** 2026-05-18
**Status:** Complete
**Feeds into:** QS, Guardian, Builder

---

## Objective

Design the architecture for the Meta Agent OS **as a public open-source release** (decision D5: the framework is the product). The persona set is frozen for v0.4 (assumption A9), so the architecture problem is **packaging, control-layer integrity, and adoption structure** — not designing new agents. Resolve Cartographer Open Question 1 (root control-layer integrity gap) and treat PD2/D8 as a fixed constraint.

## Inputs Used

- `meta-agent-os/03_outputs/diagnosis/ORACLE_DIAGNOSIS.md`
- `meta-agent-os/03_outputs/research/SOPHIA_RESEARCH_PORTFOLIO.md`
- `meta-agent-os/03_outputs/maps/CARTOGRAPHER_WORKFLOW_MAP.md`
- `meta-agent-os/00_control/` (STAGE_MANIFEST, STAGE_STATE, OUTPUT_MANIFEST, RUN_MODES, STAGE_GATES, QUALITY_BAR)
- `meta-agent-os/05_memory/*`, `ROADMAP.md`, repo structure

---

## 1. Design Brief

Ship a credible, self-consistent v0.4 of the Meta Agent OS that an external adopter can drop into their own repository and run with Claude Code (primary) or Codex (secondary), where the staged methodology validates against its own schemas **from the adopter's root tree** — without needing the `versions/` history. The framework demonstrates its own methodology by having been run on itself (Oracle → Cartographer outputs are the proof).

## 2. Key Requirements

| # | Requirement | Source |
|---|---|---|
| R1 | Schemas + validators must resolve from root `meta-agent-os/00_control/` | Cartographer risk zone (High) |
| R2 | `STAGE_MANIFEST.json` paths must be valid for an adopter who copies only the root tree | Cartographer OQ1 |
| R3 | At least one lightweight install path (no `versions/` history needed) | STAGE_GATES (Architect must include lightweight option) |
| R4 | Clear separation: shipped framework files vs this run's example outputs | Cartographer risk (self-hosting confusion) |
| R5 | v0.4 scope frozen; v0.5–v0.6.1 documented in ROADMAP only (D8) | PD2/D8 constraint |
| R6 | Apache-2.0 core; vertical packs out of scope for v0.4 | D6 |
| R7 | Primary runtime Claude Code; Codex parity preserved | Oracle §6 |
| R8 | Memory + decision history preserved, never overwritten | CLAUDE.md rule 6 |

## 3. Design Principles

1. **Single source of truth at root.** The adopter's root `meta-agent-os/00_control/` is canonical; `versions/` is history/reference only.
2. **The control layer is elegant; stage outputs are comprehensive.** (QUALITY_BAR.)
3. **No new agents.** Resist architecture inflation (STAGE_GATES).
4. **Mechanical work is scripted, not agentic.** Sync/lint/validation are CI scripts (Cartographer §11).
5. **Self-hosting is a feature, not a leak.** Example outputs are labelled, not deleted.
6. **Ship small and correct over large and fragile.** (CLAUDE.md.)

## 4. Non-Goals

- No runtime execution engine, GUI, or hosted SaaS (ROADMAP "Not Planned").
- No new personas or vertical packs in v0.4.
- No implementation of v0.5/v0.6/v0.6.1 features (D8 — ROADMAP only).
- No automated publishing/release to a package registry or docs host in v0.4.

## 5. Architecture Variant A: Lightweight

**"Companion bundle, manifest re-pointed."**

- Keep schemas/validators **only** under `versions/v0.4-reliability-layer/`.
- Re-point `STAGE_MANIFEST.json` (and OUTPUT_MANIFEST if needed) to the versioned paths so they resolve.
- Ship `versions/companion-files/` as the install bundle; adopter copies that.
- Effort: minimal (path edits + one INSTALL.md note).
- Pros: smallest change; fast to ship.
- Cons: couples the adopter's runtime to a `versions/` path that is conceptually "history"; fragile if `versions/` is excluded from a slim copy; violates Design Principle 1. **Re-pointing to a history folder is the wrong dependency direction.**

## 6. Architecture Variant B: Balanced

**"Root is canonical; versioned copies are snapshots; CI guards drift."**

- Mirror `schemas/` and `validators/` into root `meta-agent-os/00_control/` (the paths `STAGE_MANIFEST.json` already expects — **no manifest change needed**).
- Treat `versions/v0.4-reliability-layer/` as an immutable snapshot of the v0.4 release.
- Add a non-agent **sync/lint script** (Cartographer §11) that fails CI if root control files diverge from the v0.4 snapshot, and validates `STAGE_STATE.json` against a small schema.
- Add an `EXAMPLE_RUN.md` (or a header banner convention) marking the in-repo `03_outputs/*` and `05_memory/*` as a self-hosted example, not framework defaults (R4).
- Ship both: full repo (with history) and a generated slim `companion-files/` bundle.
- Effort: moderate (file mirroring + ~1 script + docs).
- Pros: satisfies R1–R5, R8; correct dependency direction; adopter can copy just the root tree; drift is mechanically prevented.
- Cons: introduces a CI script to maintain; duplicated schema files (mitigated by the drift check).

## 7. Architecture Variant C: Advanced

**"Generated control layer + release tooling + docs site."**

- Everything in B, plus: a build step that *generates* the root control layer and the companion bundle from a single source; a docs site (Docusaurus/Mintlify, Sophia OQ2); contribution guidelines; release automation/tagging.
- Effort: high.
- Pros: best long-term DX and contributor onboarding.
- Cons: **overbuilt for v0.4.** Docs site, contribution guidelines, and release automation are explicitly v0.5 scope (ROADMAP) and D8 says ship clean v0.4 now. **Rejected for v0.4** — fold into the v0.5 roadmap.

## 8. Recommended Architecture

**Variant B — Balanced.**

Rationale: it is the minimum architecture that makes the framework *correct from the adopter's perspective* (R1–R4) without re-pointing dependencies at history (A's flaw) or pulling v0.5 scope forward (C's flaw). It directly closes Cartographer Open Question 1: **mirror schemas/validators into root; do not change the manifest.** Variant A is explicitly rejected (wrong dependency direction; violates Design Principle 1). Variant C is explicitly rejected for v0.4 (overbuilt; collides with D8) and recommended as the v0.5 target.

## 9. Agent Roles

Frozen — the 10 personas in `AGENT_MANIFEST.md` (Oracle…Librarian) are unchanged. No roles added, removed, or merged. The Architect's contribution is **not** new roles; it is the release structure those roles ship inside.

## 10. Tool Access

| Actor | Tool | Access | Change |
|---|---|---|---|
| Personas | Claude Code (primary), Codex (secondary) | Read repo, write stage outputs + memory | None |
| Drift/lint script | Git + CI runner | Read-only compare root vs v0.4 snapshot; validate STAGE_STATE.json | **New (non-agent, Builder scope)** |
| Adopter | Their own runtime | Copies root tree or companion bundle | Documented in INSTALL.md |

No new credentials, no network/external tool access. Stays within STAGE_GATES Level 2.

## 11. Memory Strategy

Unchanged contract: four files in `05_memory/` (project_brain, decision_log, assumptions_log, changelog), append/preserve only (R8, CLAUDE.md rule 6). New: a banner/README convention marking the repo's own `05_memory/*` as a *live self-hosted example*, so adopters know to reset it (not delete the format) when they install. Builder must not wipe history to "clean" the example.

## 12. Data Strategy

No data stores. Inputs are repo Markdown/JSON only (Oracle A6: no sensitive data). Add an adoption-time note: when a user points the framework at *their* project, downstream data sensitivity is the Guardian's concern at that site — the framework ships a Guardian prompt for this (Cartographer risk zone). v0.4 ships the prompt text only; no tooling.

## 13. Handoff Protocol

Stage-to-stage handoff contract is unchanged (Cartographer §14): each stage writes exactly one output file at the `OUTPUT_MANIFEST.json` path, updates `STAGE_STATE.json`, and the next stage's validator must pass. Architectural addition: the **drift script runs in CI on every push** as a gate *outside* the persona handoff chain — it does not block a stage run, it blocks a release.

## 14. Evaluation Strategy

Hand to Evaluator: (1) every per-stage schema in root must have a matching validator in root; (2) `STAGE_MANIFEST.json` paths must all resolve from a fresh checkout of root only; (3) the slim companion bundle, copied alone, must run Oracle→Cartographer without referencing `versions/`; (4) example-output banners present on all `03_outputs/*` and `05_memory/*`. These become Evaluator acceptance checks.

## 15. Security Strategy

Hand to Guardian: confirms scope stays at STAGE_GATES Level 2 (internal files + a read-only CI script — no app code, no packages, no external calls, no deletion). Risk surface added is minimal: one CI script with read-only git access. Guardian should issue `Approved for prototype` or `Approved with restrictions` if it agrees scope is Level 2; anything else stops Builder per STAGE_GATES.

## 16. Implementation Roadmap

Builder scope (v0.4, pending Guardian approval):

1. Copy `versions/v0.4-reliability-layer/meta-agent-os/00_control/schemas/` → root `meta-agent-os/00_control/schemas/`.
2. Copy `.../validators/` → root `meta-agent-os/00_control/validators/`.
3. Verify all `STAGE_MANIFEST.json` paths resolve from root (no manifest edit expected).
4. Add the drift/lint + STAGE_STATE.json validation script (non-agent).
5. Add example-output banner/convention to `03_outputs/*` and `05_memory/*` (or a top-level `EXAMPLE_RUN.md`).
6. Regenerate/refresh the `companion-files/` slim bundle to include root control layer.
7. Update `INSTALL.md` with the root-tree install path.

Out of scope (→ ROADMAP v0.5, per D8): docs site, contribution guidelines, release automation, vertical packs.

## 17. Risks

| Risk | Severity | Mitigation |
|---|---|---|
| Duplicated schemas drift between root and v0.4 snapshot | Medium | CI drift script (core of Variant B) |
| Builder over-cleans the self-hosted example, destroying history | Medium | R8 + Memory Strategy banner; Guardian gate |
| PD2 reopened, pulling v0.5 scope into v0.4 | Medium | D8 fixed as constraint; QS/Guardian to reaffirm |
| CI script is the only new attack surface | Low | Read-only git; Guardian review |
| Codex parity overlooked when mirroring root | Low | Evaluator check #3 covers runtime-agnostic copy |

## 18. Open Questions For QS, Guardian, And Builder

1. **QS:** cost/effort of Variant B (file mirroring + 1 CI script + docs) — confirm it is a small, single-phase build; estimate is expected to be low but mark approximate.
2. **QS/Guardian:** confirm D8 stays fixed (no v0.5–v0.6.1 in v0.4) — this is the PD2 closure the Builder needs.
3. **Guardian:** is a read-only CI script within auto-approvable Level 2, or does it need explicit human approval as "tooling"?
4. **Builder:** preferred example-marker mechanism — per-file banner vs single top-level `EXAMPLE_RUN.md` (Architect leans top-level file: less churn).

## 19. Files Created Or Updated

- Created: `meta-agent-os/03_outputs/architecture/ARCHITECT_SYSTEM_DESIGN.md` (this file; created `03_outputs/architecture/`)
- To be updated by state/Librarian step: `STAGE_STATE.json`, `project_brain.md`, `assumptions_log.md`, `decision_log.md`, `changelog.md`

---

## Assumptions

- A11: Mirroring schemas/validators to root will satisfy `STAGE_MANIFEST.json` without manifest edits (paths already expect root). Validate in Builder/Evaluator.
- A12: A single read-only CI drift script is acceptable v0.4 scope (Guardian to confirm — OQ3).
- A9 (carried): persona set frozen for v0.4.

## Risks (summary)

Schema duplication drift (Medium, mitigated by CI), example-history destruction (Medium), PD2 scope creep (Medium), new CI surface (Low).

## Open Questions (summary)

Effort/cost of Variant B (QS); D8/PD2 formal closure (QS+Guardian); CI-script approval level (Guardian); example-marker mechanism (Builder).

## Recommended Next Action

Proceed to **QS**. Cost Variant B as a single low-effort phase, confirm D8 closes PD2, and surface the CI-script approval-level question for Guardian.
