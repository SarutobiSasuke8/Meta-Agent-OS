# Meta Agent OS

A Markdown-based operating system for diagnosing, designing, costing, building, testing, and operating multi-agent AI systems.

**Current version:** v0.4 (Reliability Layer)  
**License:** Apache 2.0

---

## What It Is

Meta Agent OS is a structured methodology and knowledge management system that lives **upstream of code**. It is not a runtime framework. It does not execute agents. It gives you a repeatable process for designing agent systems that are worth building.

The core insight: most multi-agent projects fail because teams build before they diagnose. Meta Agent OS enforces diagnosis first.

---

## How It Works

Ten specialist personas progress through ordered stages. Each stage produces a structured Markdown output. Human decision gates prevent unreviewed advancement.

```
Oracle → Sophia → Cartographer → Architect → QS → Guardian → Builder → Evaluator → Orchestrator → Librarian
```

| Stage | Persona | Output |
|-------|---------|--------|
| 1 | **The Oracle** | Diagnosis — project purpose, gaps, constraints, true needs |
| 2 | **Sophia** | Research — evidence, competitive analysis, positioning |
| 3 | **The Cartographer** | Workflow map — stakeholders, tools, data, handoffs |
| 4 | **The Architect** | System design variants — agents, roles, architecture options |
| 5 | **The QS** | Cost and implementation plan — tokens, effort, phased build |
| 6 | **The Guardian** | Risk review — security, privacy, permissions, failure modes |
| 7 | **The Builder** | Implementation — prompts, configs, workflows, scripts |
| 8 | **The Evaluator** | QA and evals — acceptance criteria, test cases, launch readiness |
| 9 | **The Orchestrator** | Runtime — routing, handoffs, execution, improvement loops |
| 10 | **The Librarian** | Memory — decisions, assumptions, changelog, reusable patterns |

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
  /00_control       — run manifests, stage state, schemas, validators, modes
  /03_outputs       — stage outputs (diagnosis, research, maps, architecture, costs, risk, build, evals, runtime)
  /05_memory        — project brain, decision log, assumptions log, changelog
  /07_examples      — skeleton full-run examples

CLAUDE.md           — instructions for Claude Code
AGENTS.md           — instructions for Codex and other coding agents
CODEX_RUNBOOK.md    — Codex-specific trigger manual
META_AGENT_BOOTSTRAP.md — first-run bootstrap instructions
INSTALL.md          — installation guide
ROADMAP.md          — planned milestones
```

---

## Non-Negotiables

- Diagnose before building.
- Do not modify application code during first diagnosis.
- Separate facts from assumptions.
- Record major decisions and assumptions.
- Require human approval for external actions, financial changes, or irreversible operations.
- Add evals before treating any agent system as production-ready.

---

## Supported Tools

| Tool | Primary File | Trigger |
|------|-------------|---------|
| Claude Code | `CLAUDE.md` | `/diagnose`, `/run-meta-agent-os` |
| Codex | `AGENTS.md` + `CODEX_RUNBOOK.md` | Prompt commands |
| Cursor / generic agent | `AGENTS.md` | Prompt commands |

---

## Versions

| Version | Name | Key Addition |
|---------|------|-------------|
| v0.1 | Meta Agent Framework | Ten personas, ten stage outputs |
| v0.2 | Agentic Runner | Stage state, gates, resume protocol, Claude commands |
| v0.4 | Reliability Layer | JSON state, schemas, validators, quality bar, run modes |

See [ROADMAP.md](ROADMAP.md) for planned milestones.

---

## License

Apache 2.0. See [LICENSE](LICENSE).

Vertical domain packs (Consulting, Financial Services, Healthcare, Legal) are distributed under separate commercial licenses.
