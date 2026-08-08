# Architect System Design

**Stage:** Architect  
**Date:** 2026-05-06  
**Project:** Meta Agent OS  
**Status:** Complete  
**Feeds into:** QS, Guardian, Builder

---

## Objective

Design the public-release architecture for Meta Agent OS as a design-time methodology and governance pack for multi-agent systems.

## Inputs Used

- `meta-agent-os/03_outputs/diagnosis/ORACLE_DIAGNOSIS.md`
- `meta-agent-os/03_outputs/research/SOPHIA_RESEARCH_PORTFOLIO.md`
- `meta-agent-os/03_outputs/maps/CARTOGRAPHER_WORKFLOW_MAP.md`
- `README.md`
- `ROADMAP.md`
- `docs/REPO_HARDENING.md`
- `skills/meta-agent-os/SKILL.md`
- `meta-agent-os/00_control/STAGE_MANIFEST.json`
- `meta-agent-os/00_control/RUN_MODES.json`
- `meta-agent-os/00_control/STAGE_GATES.md`

---

## 1. Design Brief

Meta Agent OS should ship as an inspectable repo-native framework that helps users decide what agent system should exist before they build it. The architecture should make the staged process easy to run, validate, explain, and reuse.

The design should not become a runtime engine, generic AI coding template, hosted dashboard, or task manager.

## 2. Key Requirements

- Preserve diagnosis-before-design-before-build.
- Support Claude, Codex, and generic agents.
- Keep Markdown as the primary artifact format.
- Maintain machine-readable state and manifests.
- Validate outputs and state consistency.
- Provide clear examples for new users.
- Keep future CLI optional and later.
- Avoid confusing MAS with Agent Ops OS.

## 3. Design Principles

- Methodology first, automation second.
- Smallest useful run mode by default.
- Human approval before risky actions.
- Scripts validate deterministic structure.
- Agents handle judgment, synthesis, and tradeoffs.
- Memory is durable and append-friendly.
- Public core stays generous; vertical packs can be separate.

## 4. Non-Goals

- No runtime execution engine.
- No hosted SaaS in the core repo.
- No secret handling.
- No generic software-project scaffolding.
- No broad persona marketplace in the first public release.
- No claim that MAS replaces LangGraph, CrewAI, AutoGen, OpenAI Agents SDK, or n8n.

## 5. Architecture Variant A: Lightweight

Core shape:

- Markdown docs
- `meta-agent-os/00_control`
- `meta-agent-os/03_outputs`
- `meta-agent-os/05_memory`
- Claude commands
- Codex prompts
- Skill adapter
- Hardening script
- One worked example

Benefits:

- Easy to understand.
- Low maintenance.
- Strong fit with current repo.
- Public release can happen soon.

Tradeoffs:

- No CLI UX.
- Validation remains mostly local script based.
- Users must still operate through agents or manual prompts.

## 6. Architecture Variant B: Balanced

Core shape:

- Everything in Variant A
- Stronger Markdown section validation
- `docs/WHY.md`
- `docs/examples/` with at least one complete system-design example
- Export readiness command
- Clear pack boundary for future verticals
- Versioned release checklist

Benefits:

- Credible public framework.
- Better onboarding.
- Better quality gates.
- Keeps future CLI possible without committing to it now.

Tradeoffs:

- More docs and examples to maintain.
- Still not a polished product interface.

## 7. Architecture Variant C: Advanced

Core shape:

- Everything in Variant B
- CLI package
- Config schema
- Pack installer
- JSON output from validators
- Local dashboard prototype
- Vertical pack registry structure

Benefits:

- Product-like.
- Easier for strangers to adopt at scale.
- Could become commercial foundation.

Tradeoffs:

- Too much for current repo state.
- Risks premature productization.
- Blurs with Agent Ops OS roadmap.
- Requires tests, packaging, versioning, support burden.

## 8. Recommended Architecture

Choose Variant B: Balanced.

Reason:

Variant A is useful but not polished enough for public trust. Variant C is overbuilt right now. Variant B makes MAS clear, credible, and testable while preserving its identity as a design-time framework.

## 9. Agent Roles

| Persona | Role In Recommended Architecture |
|---|---|
| Oracle | Diagnose need, anti-agent gate, context scan |
| Sophia | Research and positioning |
| Cartographer | Workflow map and handoff model |
| Architect | Architecture variants and recommendation |
| QS | Cost, effort, phasing |
| Guardian | Risk, permissions, approval gates |
| Builder | Internal files, prompts, examples, templates |
| Evaluator | Acceptance criteria, tests, launch readiness |
| Orchestrator | Runtime coordination design or simulation only |
| Librarian | Durable memory and changelog |

## 10. Tool Access

| Tool | Access Level |
|---|---|
| Filesystem | Internal docs and framework files only by default |
| Git | Status, diff, commit only when requested |
| Web | Optional for research; cite sources if used |
| External services | Human approval required |
| Package installs | Human approval required |
| Application source | Human approval required unless explicitly in Builder scope |

## 11. Memory Strategy

Use `05_memory` as the durable memory layer:

- `project_brain.md` for stable context
- `decision_log.md` for decisions
- `assumptions_log.md` for assumptions
- `changelog.md` for completed changes

Do not add a separate session-log system yet. That belongs more naturally to Agent Ops OS.

## 12. Data Strategy

Primary data is local Markdown and JSON:

- Stage state and manifests are machine-readable JSON.
- Stage outputs are human-readable Markdown.
- Validators are Markdown checklists plus scriptable structural checks.
- Examples should live under `docs/examples`.

No database is needed.

## 13. Handoff Protocol

Every stage output and major change must include:

- Objective
- Inputs used
- Findings
- Assumptions
- Risks
- Open questions
- Recommended next action
- Files created or updated

## 14. Evaluation Strategy

Evaluate MAS on:

- Can a new user understand the boundary in under 10 minutes?
- Can an agent run status, diagnosis, validation, and resume without confusion?
- Does each stage output feed the next stage?
- Do checks catch missing files, missing schemas, and state drift?
- Does a worked example demonstrate real value?

## 15. Security Strategy

Security posture:

- Default read-only or internal-doc changes.
- Human approval for external, destructive, credential, payment, deployment, or app-source actions.
- Guardian stage required before Builder modifies implementation artifacts.
- No secrets in examples.
- No hidden autonomy.

## 16. Implementation Roadmap

1. Complete Cartographer, Architect, QS, and Guardian outputs.
2. Add `docs/WHY.md`.
3. Add a complete worked example.
4. Strengthen validation to check required output sections.
5. Clean encoding artifacts.
6. Update README and ROADMAP after validation.
7. Defer CLI until the framework pack is stable.

## 17. Risks

- Variant C temptation could slow public release.
- Too much stage language could intimidate casual users.
- Poor examples could make the framework look theoretical.
- Current research claims may need citation before public marketing use.

## 18. Open Questions For QS, Guardian, And Builder

- What is the minimum public release bundle?
- Which example best demonstrates value?
- How strict should validation be before it becomes annoying?
- Should v0.5 include CLI planning or only framework polish?

## 19. Files Created Or Updated

- `meta-agent-os/03_outputs/architecture/ARCHITECT_SYSTEM_DESIGN.md`

## Assumptions

- The project should prioritize a credible public framework over a productized CLI right now.
- Agent Ops OS remains a separate product track.

## Recommended Next Action

Proceed to QS and cost the Balanced architecture as the recommended path.

## Schema Alignment Addendum - 2026-08-08

Added with the v0.6.1-era gate-binding fix (audit-driven). The Architect schema now requires a "Suitability And ROI Gate" section that records the actual verdict from the deterministic tools rather than narrating a conclusion without the underlying data.

## Suitability And ROI Gate

Recorded assessment file: `meta-agent-os/03_outputs/safety/AGENT_SUITABILITY_ASSESSMENT.json`.

Anti-agent gate (`scripts/agent-suitability.py` rubric, `meta-agent-os/00_control/safety/ANTI_AGENT_GATE.md`): all four conditions hold for this project's own methodology work (judgement required, unstructured inputs, an imperfect answer is useful, a human can review and recover). This mirrors the verdict already recorded in `ORACLE_DIAGNOSIS.md`.

Agent suitability score: 21/24, band "Well suited." No critical dimension scores zero. `volume` is the weakest dimension at 2/4, stated honestly rather than hidden, because a full run is occasional rather than continuous.

ROI: this project cannot compute its own ROI with `scripts/roi-calculator.py`, because its baseline is a counterfactual (ad hoc multi-agent design without staged diagnosis) rather than a metered process. The verdict recorded is a stated judgement, not a calculation: favourable but unmeasured. This matches the limitation already documented in `QS_COSTS_AND_OPTIONS.md` section 19. Workflows designed using this framework for other projects have a real metered baseline and must run the calculator rather than rely on judgement.

Gate outcome: passed. Proceeding to the recommended architecture above is consistent with this record.
