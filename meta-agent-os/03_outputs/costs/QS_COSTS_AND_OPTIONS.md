# QS Costs And Options

**Stage:** QS  
**Date:** 2026-05-06  
**Project:** Meta Agent OS  
**Status:** Complete  
**Feeds into:** Guardian, Builder

---

## Objective

Estimate the effort, complexity, and operating implications of improving Meta Agent OS into a credible public framework pack. Estimates are directional, not precise.

## Inputs Used

- `meta-agent-os/03_outputs/architecture/ARCHITECT_SYSTEM_DESIGN.md`
- `meta-agent-os/03_outputs/maps/CARTOGRAPHER_WORKFLOW_MAP.md`
- `ROADMAP.md`
- `docs/REPO_HARDENING.md`
- Existing hardening scripts and command layer

---

## 1. Executive Summary

Recommended path: a low-cost Balanced release. Finish the stage outputs, add one worked example, strengthen validation, clean docs, and clarify positioning. Defer CLI, local studio, and hosted concepts.

Estimated effort: 2-5 focused sessions for a polished public release candidate, depending on how deep the example and validation become.

## 2. Architecture Options Reviewed

| Option | Summary | QS View |
|---|---|---|
| Variant A | Lightweight framework pack | Cheapest, but may feel unfinished |
| Variant B | Balanced framework pack | Best value |
| Variant C | Advanced CLI/product | Too much now |

## 3. Cost Drivers

- Writing a strong worked example.
- Cleaning docs and encoding artifacts.
- Improving validators without creating false confidence.
- Clarifying product boundary versus Agent Ops OS.
- Maintaining versioned files and active root files.

## 4. Variant A Cost Plan

Estimated effort: 1-2 sessions.

Includes:

- Existing docs
- Existing hardening scripts
- Current command/skill layer

Risk:

- Public repo may still feel like an internal framework dump.

## 5. Variant B Cost Plan

Estimated effort: 2-5 sessions.

Includes:

- Finish core stage outputs through Guardian/Builder/Evaluator.
- Add `docs/WHY.md`.
- Add one complete worked example.
- Strengthen section validation.
- Clean encoding artifacts.
- Update README and roadmap.

Risk:

- Requires discipline to stop before CLI.

## 6. Variant C Cost Plan

Estimated effort: 2-6 weeks for a credible CLI MVP; longer for dashboard or hosted product.

Includes:

- CLI package
- Config schema
- Tests and fixtures
- Release/versioning machinery
- Upgrade logic

Risk:

- Premature productization and overlap with Agent Ops OS.

## 7. Infrastructure Options

| Option | Cost | Recommendation |
|---|---|---|
| Markdown + scripts | Very low | Use now |
| CLI | Medium | Defer |
| Local web UI | Medium-high | Defer |
| Hosted platform | High | Not for MAS core |

## 8. Model Options

No fixed model dependency is required. MAS should remain model-agnostic.

Directional guidance:

- Use stronger reasoning models for Oracle, Architect, Guardian.
- Use cheaper/faster models for status, formatting, and structural checks.
- Use scripts for deterministic validation.

## 9. Tooling Options

Current tooling is enough:

- PowerShell check for Windows.
- Bash/Python check for CI/Linux.
- GitHub Actions for public PR validation.
- Markdown commands for Claude.
- Skill adapter for Codex.

## 10. Human Labour Estimate

| Work Item | Estimate |
|---|---|
| Stage outputs through Guardian | 1 session |
| Builder/Evaluator documentation | 1 session |
| Worked example | 1-2 sessions |
| Validation strengthening | 1 session |
| Encoding cleanup and README polish | 0.5-1 session |
| Release checklist | 0.5 session |

## 11. Build Timeline

Minimum polished path:

1. Day 1: complete stage outputs and validation.
2. Day 2: add worked example and WHY doc.
3. Day 3: polish README, roadmap, release checklist.
4. Day 4: use MAS on a real target repo and capture feedback.

## 12. Operating Costs

Operating cost is mostly agent/model usage during runs. The repo itself has no infrastructure cost unless GitHub Actions usage becomes material, which is unlikely for early public use.

## 13. Maintenance Costs

Expected maintenance:

- Update commands when tools change.
- Keep active root and versioned folders aligned.
- Improve validators as stage schemas evolve.
- Maintain examples.

## 14. Risk Contingency

Add 25-40 percent effort contingency for:

- Encoding cleanup surprises.
- Markdown validator edge cases.
- Reworking positioning after user feedback.
- Example quality revisions.

## 15. Recommended Phased Plan

Phase 1:

- Balanced framework pack.
- Strong example.
- Stronger validation.
- Clear positioning.

Phase 2:

- Release checklist.
- More examples.
- Vertical pack stubs.

Phase 3:

- CLI exploration only after repeated manual usage proves the command set.

## 16. Minimum Viable Build

Minimum viable public MAS:

- Root docs are clean.
- `00_control` complete.
- Stage outputs through Guardian exist.
- `/mao-*` commands exist.
- `skills/meta-agent-os` exists.
- Hardening check passes.
- One worked example exists.
- README explains what MAS is not.

## 17. Budget Warnings

- Do not build a CLI before the framework has real example-driven proof.
- Do not add hosted features to MAS core.
- Do not create vertical packs before the generic method is polished.
- Do not overinvest in exact cost calculations without current model pricing verification.

## 18. Token Budget

Added 2026-08-04 with the v0.6 Inference Economics Layer.

This project is a Markdown framework, not an agent workflow that consumes tokens in production. Its own token budget is therefore the cost of *operating* the framework with an agentic coding tool, not the cost of a deployed system.

| Item | Estimate | Basis |
|---|---|---|
| Full ten-stage run | One long agent session per stage, dominated by repository reading | Assumption, not measured |
| Repeat runs | Cheaper than the first, since diagnosis and memory already exist | Assumption |
| Validation | Zero inference cost; the checks are deterministic scripts | Fact |
| Ongoing operation | Occasional stage refresh plus memory updates | Assumption |

The framework deliberately pushes work that does not need judgement into scripts. Every check in `scripts/check-meta-agent-os.ps1` and `scripts/check-meta-agent-os.sh` is work an agent would otherwise pay tokens to redo on each run.

For agent workflows designed *using* this framework, use `meta-agent-os/00_control/economics/TOKEN_BUDGET_TEMPLATE.md` and `scripts/roi-calculator.py` rather than estimating by hand.

## 19. ROI Assessment

Added 2026-08-04 with the v0.6 Inference Economics Layer.

The ROI method is defined in `meta-agent-os/00_control/economics/ROI_METHOD.md` and implemented in `scripts/roi-calculator.py`. Applied to this project:

- **Baseline:** designing a multi-agent system ad hoc, without staged diagnosis. The dominant cost of that baseline is not tokens; it is building the wrong system and discovering it late.
- **Running cost:** operator time per stage plus inference for the agentic tool. No infrastructure, no paid services, no credentials.
- **Return:** avoided rework, and avoided builds that should not have happened at all. Both are real and neither is precisely measurable here.
- **Verdict:** favourable, but on an unmeasured baseline. This is stated as a judgement, not a calculation.

The honest limitation: this project cannot compute its own ROI with the calculator, because its baseline is a counterfactual rather than a metered process. Workflows designed with the framework can, and should.

## 20. Pricing Verification

Added 2026-08-04 with the v0.6 Inference Economics Layer.

| Check | State |
|---|---|
| Rates used in this output | None. No figure here depends on a model rate. |
| Pricing registry | `meta-agent-os/00_control/economics/MODEL_PRICING.json`, shipped empty by design |
| Registry integrity | Enforced in strict validation: every entry needs `verified_on`, `source`, numeric rates, and must be newer than `max_age_days` |
| Staleness policy | Re-verify against the vendor's current published pricing; do not raise the threshold |

Meta Agent OS ships no default prices. Published rates change, and a stale rate produces a confident wrong number, which is more damaging than no number. Any cost figure quoted externally must be traceable to a registry entry verified on the day of use.

## 21. Files Created Or Updated

- `meta-agent-os/03_outputs/costs/QS_COSTS_AND_OPTIONS.md`
- `meta-agent-os/00_control/economics/MODEL_PRICING.json`
- `meta-agent-os/00_control/economics/TOKEN_BUDGET_TEMPLATE.md`
- `meta-agent-os/00_control/economics/ROI_METHOD.md`
- `scripts/roi-calculator.py`

## Assumptions

- Estimates are directional and based on current local repo state.
- No paid infrastructure is required for the next release.

## Risks

- Public release quality depends more on clarity and examples than feature count.

## Open Questions

- Which example should become the flagship public demo?
- Should v0.5 be "Commercial Refinement" or "Public Framework Polish"?

## Recommended Next Action

Proceed to Guardian. Approve the Balanced plan with restrictions if risks are manageable.
