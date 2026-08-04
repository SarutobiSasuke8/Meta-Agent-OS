# Meta Agent OS

A Markdown-based operating system for diagnosing, designing, costing, building, testing, and operating multi-agent AI systems.

**Current version:** v0.6.1 (Inference Safety Layer)  
**License:** Apache 2.0

---

## What It Is

Meta Agent OS is a structured methodology and knowledge management system that lives **upstream of code**. It is not a runtime framework. It does not execute agents. It gives you a repeatable process for designing agent systems that are worth building.

The core insight: most multi-agent projects fail because teams build before they diagnose. Meta Agent OS enforces diagnosis first.

For the deeper product boundary, see [`docs/WHY.md`](docs/WHY.md), [`docs/PUBLIC_BOUNDARY.md`](docs/PUBLIC_BOUNDARY.md), and [`docs/RUNTIME_TRACK.md`](docs/RUNTIME_TRACK.md).

## Current Status

Meta Agent OS v0.6.1 is complete as the public framework and specification layer. It is not permanently finished, but the current repo should remain focused on methodology, control files, examples, validation, and memory.

Truly agentic runtime behavior should be explored in a separate implementation track rather than added directly to this public repo by default.

---

## How It Works

Ten specialist personas progress through ordered stages. Each stage produces a structured Markdown output. Human decision gates prevent unreviewed advancement.

```
Oracle -> Sophia -> Cartographer -> Architect -> QS -> Guardian -> Builder -> Evaluator -> Orchestrator -> Librarian
```

| Stage | Persona | Output |
|-------|---------|--------|
| 1 | **The Oracle** | Diagnosis - project purpose, gaps, constraints, true needs |
| 2 | **Sophia** | Research - evidence, competitive analysis, positioning |
| 3 | **The Cartographer** | Workflow map - stakeholders, tools, data, handoffs |
| 4 | **The Architect** | System design variants - agents, roles, architecture options |
| 5 | **The QS** | Cost and implementation plan - tokens, effort, phased build |
| 6 | **The Guardian** | Risk review - security, privacy, permissions, failure modes |
| 7 | **The Builder** | Implementation - prompts, configs, workflows, scripts |
| 8 | **The Evaluator** | QA and evals - acceptance criteria, test cases, launch readiness |
| 9 | **The Orchestrator** | Runtime - routing, handoffs, execution, improvement loops |
| 10 | **The Librarian** | Memory - decisions, assumptions, changelog, reusable patterns |

---

## Quick Start

### Claude Code

Copy this repository into your project root. Then run:

```
/diagnose
```

Or for the full staged run:

```
/run-meta-agent-os
```

Operator shortcuts are also available:

| Command | Purpose |
|---|---|
| `/mao-status` | Inspect current stage, missing outputs, blockers, and next action |
| `/mao-diagnose` | Run or refresh Oracle diagnosis |
| `/mao-resume` | Continue from the current incomplete stage |
| `/mao-validate` | Validate current state and current stage output |
| `/mao-harden` | Check and repair repository structure |
| `/mao-memory` | Update project brain, assumptions, decisions, and changelog |
| `/mao-export-pack` | Verify the framework is ready to reuse in another repo |

### Codex or Other Coding Agents

```
Read AGENTS.md and CODEX_RUNBOOK.md, then run the Codex Full Run Prompt v0.4 from /meta-agent-os/00_control/codex/full_run_v0_4.md.
```

### Manual Trigger

```
Read CLAUDE.md, AGENTS.md, and META_AGENT_BOOTSTRAP.md. Run The Oracle diagnosis stage for this repository.
```

---

## Repository Structure

```
/meta-agent-os
  /00_control       - run manifests, stage state, schemas, validators, modes
  /03_outputs       - stage outputs (diagnosis, research, maps, architecture, costs, risk, build, evals, runtime)
  /05_memory        - project brain, decision log, assumptions log, changelog

/docs               - positioning, boundaries, release checklist, repo hardening
/docs/examples      - worked examples (support triage, research assistant)
/docs/notes         - dated working notes, kept out of the repository root
/scripts            - validation scripts (PowerShell and bash, behaviourally paired)
/skills             - reusable skill adapter

CLAUDE.md           - instructions for Claude Code
AGENTS.md           - instructions for Codex and other coding agents
CODEX_RUNBOOK.md    - Codex-specific trigger manual
META_AGENT_BOOTSTRAP.md - first-run bootstrap instructions
INSTALL.md          - installation guide
ROADMAP.md          - planned milestones
CONTRIBUTING.md     - what belongs here, and how to run validation
SECURITY.md         - how to report a vulnerability privately
CODE_OF_CONDUCT.md  - community standards
```

---

## Non-Negotiables

- Diagnose before building.
- Do not modify application code during first diagnosis.
- Separate facts from assumptions.
- Record major decisions and assumptions.
- Require human approval for external actions, financial changes, or irreversible operations.
- Add evals before treating any agent system as production-ready.

## Worked Example

Start with [`docs/examples/WORKED_EXAMPLE_SUPPORT_TRIAGE.md`](docs/examples/WORKED_EXAMPLE_SUPPORT_TRIAGE.md) to see how a vague support automation idea becomes a supervised, risk-reviewed agent-system plan.

For a second pattern, see [`docs/examples/WORKED_EXAMPLE_RESEARCH_ASSISTANT.md`](docs/examples/WORKED_EXAMPLE_RESEARCH_ASSISTANT.md), which shows how Meta Agent OS keeps a research-agent request grounded in sources, review gates, and citation discipline.

## Release Readiness

Use [`docs/RELEASE_CHECKLIST.md`](docs/RELEASE_CHECKLIST.md) before tagging, publishing, or reusing this repo as a baseline.

Local validation:

```powershell
./scripts/check-meta-agent-os.ps1 -Strict
./scripts/check-meta-agent-os.ps1 -Strict -Json
```

```bash
./scripts/check-meta-agent-os.sh --strict
./scripts/check-meta-agent-os.sh --strict --json
```

Strict mode goes beyond checking that files and headings exist. It also verifies that required sections carry real content, that Assumptions, Risks, Open Questions, and file lists enumerate entries rather than gesture at them, that no unresolved placeholders remain in prose, that completed stage outputs carry `**Date:**` and `**Status:**` provenance, that state is not older than the outputs it describes, and that every relative Markdown link resolves.

---

## Should This Be An Agent?

The Oracle stage runs an anti-agent gate before any design work. Its default answer is no; an agent has to be argued for.

```bash
python scripts/agent-suitability.py YOUR_ASSESSMENT.json
```

Four conditions must all hold, and six dimensions are scored with mandatory justifications. `tolerance_for_error` and `recoverability` are critical: a zero on either caps the workflow at Not Suitable no matter how valuable it is. The tool exits non-zero when it blocks, so [`STAGE_GATES.md`](meta-agent-os/00_control/STAGE_GATES.md) can enforce it rather than rely on someone remembering.

Concluding that a workflow does **not** need agents is a valid and valuable output. See [`ANTI_AGENT_GATE.md`](meta-agent-os/00_control/safety/ANTI_AGENT_GATE.md) and [`AGENT_SUITABILITY_SCORING.md`](meta-agent-os/00_control/safety/AGENT_SUITABILITY_SCORING.md).

Model choice carries its own risks, covered in [`INFERENCE_RISK_PROFILES.md`](meta-agent-os/00_control/safety/INFERENCE_RISK_PROFILES.md): task criticality tiers, model quality floors, local-model limits, and escalation paths. A cost saving that drops a step below its tier floor is not a saving.

---

## Costing An Agent Workflow

The QS stage estimates what a workflow costs to run before it is built.

```bash
python scripts/roi-calculator.py YOUR_WORKFLOW.json
```

The calculation, its thresholds, and what it deliberately does not price are defined in [`meta-agent-os/00_control/economics/ROI_METHOD.md`](meta-agent-os/00_control/economics/ROI_METHOD.md). Start from [`TOKEN_BUDGET_TEMPLATE.md`](meta-agent-os/00_control/economics/TOKEN_BUDGET_TEMPLATE.md) for the input shape, and [`docs/examples/roi/`](docs/examples/roi/) for a runnable synthetic example.

Supervision cost is inside the running cost, and a baseline is mandatory. Both are how agent proposals usually overstate their return.

**Meta Agent OS ships no model prices.** Published rates change, and a stale rate produces a confident wrong number. Populate [`MODEL_PRICING.json`](meta-agent-os/00_control/economics/MODEL_PRICING.json) with rates you verified today; strict validation rejects any entry that is undated, unsourced, or older than `max_age_days`.

---

## Contributing

See [`CONTRIBUTING.md`](CONTRIBUTING.md) for what belongs in this repository and what is routed to the separate runtime track. Report security issues privately per [`SECURITY.md`](SECURITY.md). Participation is governed by [`CODE_OF_CONDUCT.md`](CODE_OF_CONDUCT.md).

---

## Supported Tools

| Tool | Primary File | Trigger |
|------|-------------|---------|
| Claude Code | `CLAUDE.md` | `/diagnose`, `/run-meta-agent-os`, `/mao-*` |
| Codex | `AGENTS.md` + `CODEX_RUNBOOK.md` | Prompt commands |
| Cursor / generic agent | `AGENTS.md` | Prompt commands |

---

## Versions

| Version | Name | Key Addition |
|---------|------|-------------|
| v0.1 | Meta Agent Framework | Ten personas, ten stage outputs |
| v0.2 | Agentic Runner | Stage state, gates, resume protocol, Claude commands |
| v0.4 | Reliability Layer | JSON state, schemas, validators, quality bar, run modes |
| v0.5 | Public Framework Polish | Positioning docs, worked examples, substance-level validation, link and provenance checks, community guidelines |
| v0.6 | Inference Economics Layer | Token budgets, ROI method and calculator, verified-pricing registry, extended QS stage |
| v0.6.1 | Inference Safety Layer | Anti-agent gate, suitability scoring, suitability and ROI gates before Architect, model quality floors |

Earlier full-tree snapshots are preserved as git tags rather than in-tree folders. Retrieve one with `git checkout v0.1` (or `v0.2` / `v0.4` / `v0.5` / `v0.6` / `v0.6.1`), or pull a single file with `git checkout v0.6.1 -- <path>`.

See [ROADMAP.md](ROADMAP.md) for planned milestones.

---

## License

Apache 2.0. See [LICENSE](LICENSE).

Vertical domain packs (Consulting, Financial Services, Healthcare, Legal) are distributed under separate commercial licenses.
