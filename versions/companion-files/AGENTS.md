# AGENTS.md

## Repository Purpose

This repository uses the Meta Agent OS, a Markdown-based framework for building and operating multi-agent systems.

The system should diagnose the project before designing or building agents.

## Agent Operating Instructions

Before doing work:

1. Inspect the project structure.
2. Read `README.md`, `CLAUDE.md`, this `AGENTS.md`, and relevant files inside `/meta-agent-os`.
3. Check whether a diagnosis exists at:

```text
/meta-agent-os/03_outputs/diagnosis/ORACLE_DIAGNOSIS.md
```

4. If the diagnosis does not exist and the task involves system design, automation, agents, workflows, strategy, or repo setup, run The Oracle diagnosis stage first.
5. If the diagnosis exists, continue from the latest relevant stage.

## Meta Agent OS Personas

Use the smallest useful combination of personas:

- Oracle: diagnosis
- Sophia: research
- Cartographer: workflow mapping
- Architect: system design
- QS: cost and implementation planning
- Guardian: risk and permissions
- Builder: implementation
- Evaluator: tests and evals
- Orchestrator: runtime coordination
- Librarian: docs and memory

## Required Handoff Standard

Every major output should include:

- Objective
- Inputs used
- Findings
- Assumptions
- Risks
- Open questions
- Recommended next action
- Files created or updated

## Project File Rules

- Keep durable project context in `/meta-agent-os/05_memory/project_brain.md`.
- Keep decisions in `/meta-agent-os/05_memory/decision_log.md`.
- Keep assumptions in `/meta-agent-os/05_memory/assumptions_log.md`.
- Keep generated stage outputs in `/meta-agent-os/03_outputs`.
- Do not scatter important agent instructions across random files.
- Do not overwrite valuable context without preserving it.

## Build Rules

- Diagnose before building.
- Prefer simple, useful, testable systems.
- Avoid overengineering.
- Use scripts for deterministic tasks.
- Use LLM agents for judgement, synthesis, research, routing, and writing.
- Add evals before calling a system production-ready.
- Require human approval for external or risky actions.

## First-Run Command

If the user says any of the following:

- "start"
- "initialise"
- "initialize"
- "run diagnosis"
- "analyse this project"
- "set up the meta agent OS"
- "build the agent framework"

Then perform the first-run diagnosis protocol from `META_AGENT_BOOTSTRAP.md`.
