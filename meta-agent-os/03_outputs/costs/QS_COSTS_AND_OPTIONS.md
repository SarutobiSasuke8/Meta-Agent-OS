# QS_COSTS_AND_OPTIONS.md

**Stage:** QS — Cost, Effort & Phased Planning
**Date:** 2026-05-18
**Status:** Complete
**Feeds into:** Guardian, Builder

> All figures are **estimates**, expressed as ranges and effort bands. This is a Markdown-only framework with no infrastructure, so cost is dominated by agent-token usage and human review time, both of which are inherently variable. No fake precision is implied.

---

## Objective

Cost and phase the Architect's recommended **Variant B** (root becomes canonical: mirror schemas/validators into root `00_control/`, no manifest change, add one read-only CI drift/lint script, mark self-hosted outputs as example). Confirm whether D8 closes PD2 so Builder scope is unambiguous, and carry the CI-script approval-level question to Guardian.

## Inputs Used

- `meta-agent-os/03_outputs/architecture/ARCHITECT_SYSTEM_DESIGN.md` (Variant B, roadmap, OQs)
- `meta-agent-os/03_outputs/maps/CARTOGRAPHER_WORKFLOW_MAP.md` (risk zones)
- `meta-agent-os/03_outputs/research/SOPHIA_RESEARCH_PORTFOLIO.md` (Open Core; docs-site is v0.5)
- `ROADMAP.md`, `meta-agent-os/05_memory/*`, repo structure

---

## 1. Executive Summary

Variant B is a **small, single-phase, low-cost build**. It is mostly file movement plus one short CI script and a documentation pass. There is **no infrastructure spend, no model API spend for the framework itself, and no licensing cost** (Apache-2.0, D6). The dominant cost is a few hours of agent + human review time. Estimated total effort: **~0.5–1.5 person-days** of focused work, or **one Builder + Evaluator pass** in agentic terms. Recommended: proceed as a single MVP phase; defer all v0.5 items (docs site, contribution guidelines, release automation) per D8.

## 2. Architecture Options Reviewed

| Variant | Architect Verdict | QS Cost View |
|---|---|---|
| A — Lightweight (re-point manifest at `versions/`) | Rejected (wrong dependency direction) | Cheapest (~1–2 hrs) but creates fragile coupling → higher long-term maintenance cost; **false economy** |
| B — Balanced (root canonical + CI drift script) | **Recommended (D9)** | Low one-time cost; low recurring cost (one CI job); **best cost/benefit** |
| C — Advanced (docs site + release automation) | Rejected for v0.4 → v0.5 | High cost; out of v0.4 budget by D8; correctly deferred |

## 3. Cost Drivers

1. **Agent token usage** — Builder + Evaluator passes over a small file set. Modest; one-off.
2. **Human review time** — reviewing mirrored files, the CI script, and the example-marker convention.
3. **CI minutes** — one lightweight read-only job per push (seconds of runtime; negligible on free tiers, e.g. GitHub Actions public-repo free minutes).
4. **Maintenance** — keeping root and the v0.4 snapshot in sync (the CI drift script *removes* this as a manual cost — that is its purpose).
5. **No drivers:** no servers, no databases, no model inference at runtime, no third-party SaaS, no license fees.

## 4. Variant A Cost Plan

One-time: ~1–2 hrs (edit `STAGE_MANIFEST.json` + INSTALL note). Recurring: low, but **hidden cost** — every slim/partial copy that omits `versions/` silently breaks validation; debugging that for adopters is an unbounded support cost. **Not recommended on cost grounds either.**

## 5. Variant B Cost Plan

| Work Item | Effort (est.) | Cost Type |
|---|---|---|
| Mirror `schemas/` → root `00_control/schemas/` | ~15–30 min | One-time |
| Mirror `validators/` → root `00_control/validators/` | ~15–30 min | One-time |
| Verify all STAGE_MANIFEST.json paths resolve from root | ~15 min | One-time (Evaluator) |
| Write read-only CI drift/lint + STAGE_STATE.json validator script | ~1–3 hrs | One-time |
| Wire CI workflow (one job) | ~30–60 min | One-time |
| Add example-marker (`EXAMPLE_RUN.md` top-level — Architect's lean) | ~30 min | One-time |
| Refresh `companion-files/` slim bundle | ~30–60 min | One-time |
| Update `INSTALL.md` | ~20–30 min | One-time |
| **Total** | **~0.5–1.5 person-days** | **One-time** |
| CI run cost | ~seconds/push | Recurring, negligible |

Monetary: effectively **$0 out-of-pocket** (public-repo CI free tier; Apache-2.0). Cost is time only.

## 6. Variant C Cost Plan

Not costed in detail — out of v0.4 scope (D8). Indicative only: docs site + contribution guidelines + release automation is a **multi-day to multi-week** effort and belongs in the v0.5 budget. Costing it now would be premature.

## 7. Infrastructure Options

None required. Option set: (a) **GitHub Actions public-repo free tier** for the CI drift job — recommended; (b) any generic CI (GitLab CI, local pre-commit) as a fallback. No hosting, no compute provisioning, no storage beyond the git repo itself.

## 8. Model Options

The framework is model-agnostic and consumes no model inference at rest. Models are only used *when an adopter runs a staged pass*:

| Runtime | Typical model | Cost bearer |
|---|---|---|
| Claude Code (primary) | Claude Opus/Sonnet | The adopter, at their own usage |
| Codex (secondary) | OpenAI models | The adopter |

For *this* build (Variant B), one Builder + one Evaluator agentic pass over a small file set — token cost is minor and one-off. No model cost is incurred by shipping the framework.

## 9. Tooling Options

- Git + GitHub (already in use) — no added cost.
- CI: GitHub Actions (free tier) — recommended.
- Optional pre-commit hook mirroring the CI check locally — zero cost, improves DX. Defer decision to Builder.

## 10. Human Labour Estimate

| Role | Task | Effort (est.) |
|---|---|---|
| Builder (agent) | Items 1–8 in Variant B plan | ~0.5–1 day equivalent |
| Reviewer (human) | Review mirrored files + CI script + INSTALL | ~1–2 hrs |
| Evaluator (agent) | Run acceptance checks (Architect §14) | ~0.5–1 hr |

Single contributor is sufficient. No specialist skills beyond basic shell/CI scripting.

## 11. Build Timeline

Single phase. Calendar estimate: **one focused session** (half a day) for an agent + a short human review. No dependency on external parties. No procurement, no provisioning lead time.

## 12. Operating Costs

~$0 ongoing. The only recurring cost is the CI drift job (seconds of free-tier CI per push). The framework has no servers, no licenses, no subscriptions.

## 13. Maintenance Costs

Low and *decreasing*: the CI drift script converts the current **manual, error-prone** root↔snapshot sync (a recurring hidden cost / Cartographer High risk) into an automated gate. Net effect: Variant B **reduces** long-term maintenance cost. Periodic maintenance: update schemas/validators in one place (root), let CI enforce parity with the v0.4 snapshot.

## 14. Risk Contingency

Add ~25–50% effort buffer to the CI-script item (the only item with real uncertainty — STAGE_STATE.json schema edge cases). Worst realistic case for the whole build remains within **~2 person-days**. No financial contingency needed (no spend). Primary contingency trigger: if Guardian rules the CI script needs explicit approval as "tooling" (OQ for Guardian), Builder pauses for that approval — schedule impact only, not cost.

## 15. Recommended Phased Plan

**Phase 1 (v0.4 — this build, MVP):** Variant B in full, single phase, as scoped in §5. Gate: Guardian approval.
**Phase 2 (v0.5 — deferred, NOT now):** docs site, contribution guidelines, release automation, first vertical pack (Variant C scope + ROADMAP v0.5). Out of current budget by D8.

**On PD2:** QS confirms **D8 closes PD2 for costing purposes** — there is no v0.5/v0.6/v0.6.1 cost in the v0.4 budget; those are explicitly Phase 2. Recommend the human formally mark PD2 closed (= D8) before Builder so scope is unambiguous; QS treats it as closed.

## 16. Minimum Viable Build

If time-boxed hard, the irreducible core is just **R1–R2**: mirror `schemas/` + `validators/` into root and verify manifest paths resolve (~1 hr). The CI drift script and example-marker are high-value but technically deferrable to a fast-follow within v0.4. Recommended MVP = full Variant B (the script is cheap and removes the High maintenance risk — cutting it is a false economy, same logic as rejecting Variant A).

## 17. Budget Warnings

- **Estimates, not quotes.** Token/CI/time figures are indicative ranges; actuals vary with runtime and reviewer speed.
- **Don't pull Phase 2 forward.** The biggest budget risk is scope creep into v0.5 (docs site, packs) under PD2 ambiguity — D8 must hold.
- **Don't pick Variant A to "save time."** Its hidden adopter-support cost is unbounded; the apparent saving is false.
- No spend approval is required (no money involved); the only gate is Guardian on the CI script's approval level.

## 18. Files Created Or Updated

- Created: `meta-agent-os/03_outputs/costs/QS_COSTS_AND_OPTIONS.md` (this file; created `03_outputs/costs/`)
- To be updated by state/Librarian step: `STAGE_STATE.json`, `project_brain.md`, `assumptions_log.md`, `changelog.md`

---

## Assumptions

- A13: Public-repo CI free tier is available (GitHub Actions) → operating cost ≈ $0. Validate at Builder.
- A14: D8 holds and PD2 is treated as closed for budget purposes (no v0.5–v0.6.1 cost in v0.4). Human to formally confirm.
- A11/A12 (carried): root mirroring needs no manifest edit; CI script is Level-2 scope (Guardian to confirm).

## Risks (summary)

Scope creep into v0.5 under PD2 ambiguity (Medium — mitigated by D8 + recommended formal closure); CI-script effort uncertainty (Low — buffered); Variant A "false economy" if reconsidered (Low — explicitly warned).

## Open Questions

1. **Guardian:** is the read-only CI drift script auto-approvable Level 2, or does it require explicit human approval as tooling? (Carried from Architect OQ3 — drives whether Builder pauses.)
2. **Human:** formally mark PD2 = closed (D8) before Builder? QS recommends yes; treats it as closed for costing.

## Recommended Next Action

Proceed to **Guardian**. Risk/security review of Variant B scope: confirm it stays at STAGE_GATES Level 2, rule on the CI-script approval level (OQ1), and issue a verdict (`Approved for prototype` / `Approved with restrictions`) so Builder can proceed — or stop Builder if the verdict is anything else.
