# ROADMAP.md

Current stable release: **v0.4 (Reliability Layer)**

v0.4 is complete for now as the public framework and specification layer. Future runtime execution should be treated as a separate implementation track unless the project deliberately re-scopes this public repo.

---

## Released

### v0.1 - Meta Agent Framework

Ten personas, ten stage outputs. The foundational methodology.

### v0.2 - Agentic Runner Layer

Stage state, gates, resume protocol. Claude Code slash commands (`/diagnose`, `/run-meta-agent-os`, `/continue-meta-agent-os`, `/stage-status`).

### v0.4 - Reliability Layer

JSON state machine, stage manifest, run modes, output manifest, per-stage schemas, validators, quality bar, advancement protocol. First-class Codex support.

---

## Planned

### v0.5 - Public Framework Polish

- Clearer positioning and `docs/WHY.md`
- Public boundary clarified in `docs/PUBLIC_BOUNDARY.md`
- Runtime track boundary documented in `docs/RUNTIME_TRACK.md`
- Release checklist documented in `docs/RELEASE_CHECKLIST.md`
- At least two complete worked examples
- Stronger stage-output validation
- JSON output mode for local validation
- Public documentation cleanup
- Community contribution guidelines
- Open Core and commercial-pack boundaries clarified

### v0.6 - Inference Economics Layer

- Token budget tooling integrated into QS stage
- Cost modelling templates per model, with pricing verified at time of use
- ROI calculator for agent workflows
- Inference efficiency guidance in Guardian stage

### v0.6.1 - Inference Safety Layer

- Anti-agent gate formalised in Oracle stage
- Agent suitability scoring template
- Workflow ROI threshold checks before Architect stage advances
- Guardian stage extended with inference risk profiles

---

## Vertical Packs (Commercial, Separate License)

| Pack | Status |
|---|---|
| Consulting Delivery Pack | Planned after v0.5 |
| Financial Services Pack | Planned after v0.6 |
| Healthcare & Life Sciences Pack | Planned after v0.6 |
| Legal & Compliance Pack | Planned after v0.6 |

---

## Not Planned

- Runtime execution engine in the public core repo
- GUI or web application in the core repo
- Hosted SaaS in the core repo
