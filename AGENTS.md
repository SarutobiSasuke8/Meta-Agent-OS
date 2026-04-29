# AGENTS.md

## Repository Purpose

This repository contains the Meta Agent OS, a Markdown-based framework for diagnosing, designing, costing, building, testing, and operating multi-agent AI systems.

The system enforces diagnosis before design and design before build.

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

## Full Runner Protocol

When asked to run the full system, read:

```text
/meta-agent-os/00_control/RUN_META_AGENT_OS.md
/meta-agent-os/00_control/STAGE_STATE.json
/meta-agent-os/00_control/STAGE_GATES.md
/meta-agent-os/00_control/RESUME_PROTOCOL.md
/meta-agent-os/00_control/AGENT_MANIFEST.md
```

Then progress through stages until complete or blocked.

Do not treat the presence of this file as automatic execution. The system begins when the user invokes a trigger command or prompt.

## Codex-Specific Operation

Codex should use `CODEX_RUNBOOK.md` as the primary trigger manual after reading this file.

Codex does not use Claude slash commands. Instead, use prompt-based triggers:

```text
/meta-agent-os/00_control/codex/full_run_v0_4.md
/meta-agent-os/00_control/codex/diagnose_only.md
/meta-agent-os/00_control/codex/resume.md
/meta-agent-os/00_control/codex/status.md
```

Default Codex behaviour:

- For a full setup, use `codex/full_run_v0_4.md`.
- For first diagnosis only, use `codex/diagnose_only.md`.
- To continue after interruption, use `codex/resume.md`.
- To check progress, use `codex/status.md`.

## v0.4 Reliability Rules

When running the Meta Agent OS, use the machine-readable reliability layer:

```text
/meta-agent-os/00_control/STAGE_STATE.json
/meta-agent-os/00_control/STAGE_MANIFEST.json
/meta-agent-os/00_control/RUN_MODES.json
/meta-agent-os/00_control/OUTPUT_MANIFEST.json
/meta-agent-os/00_control/QUALITY_BAR.md
/meta-agent-os/00_control/STAGE_ADVANCEMENT_PROTOCOL.md
/meta-agent-os/00_control/JSON_STATE_UPDATE_PROTOCOL.md
/meta-agent-os/00_control/schemas
/meta-agent-os/00_control/validators
```

Before advancing a stage:

1. Check the expected output path in `STAGE_MANIFEST.json`.
2. Validate the output against the relevant schema.
3. Apply the global validator.
4. Check `STAGE_GATES.md`.
5. Update `STAGE_STATE.json`.

Prefer the smallest suitable run mode from `RUN_MODES.json`.
