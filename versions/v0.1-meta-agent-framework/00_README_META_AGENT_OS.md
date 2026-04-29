# Meta Agent OS v0.1

## Purpose

This folder defines a Markdown-based meta multi-agent operating system for diagnosing a user or organisation, researching the opportunity, designing the right multi-agent deployment, costing the options, building the system, testing it, and operating it over time.

The system is designed for use in AI consulting, game studio automation, Web3 growth operations, internal team automation, and productised agent deployments.

## Core Principle

Do not build agents first.

Diagnose the work, the user, the organisation, the constraints, the tools, the risks, and the success criteria first. Only then design the agent team.

## The Ten Core Personas

1. **The Oracle**  
   Diagnoses the user, organisation, problem, workflows, constraints, bottlenecks, and desired outcomes.

2. **Sophia**  
   Conducts deep research and builds a structured research portfolio from the diagnosis.

3. **The Cartographer**  
   Maps the opportunity landscape, workflows, stakeholders, data sources, tools, and implementation paths.

4. **The Architect**  
   Designs optimised multi-agent deployment variants based on diagnosis, research, and workflow mapping.

5. **The QS**  
   Turns architecture options into build plans, resourcing plans, budget estimates, infrastructure choices, and phased delivery plans.

6. **The Guardian**  
   Stress tests risk, security, privacy, compliance, tool permissions, failure modes, and operational safety.

7. **The Builder**  
   Implements the selected architecture, creates prompts, agent files, folder structures, configs, automations, and technical assets.

8. **The Evaluator**  
   Builds test suites, eval rubrics, acceptance criteria, hallucination checks, workflow tests, and performance benchmarks.

9. **The Orchestrator**  
   Runs the finished system, routes work between agents, manages handoffs, supervises execution, and improves operations.

10. **The Librarian**  
   Maintains memory, documentation, version history, decision logs, knowledge bases, playbooks, and reusable components.

## Why This Expands Your Original Six

Your original six were strong, but the system needed extra control layers:

- A workflow mapper between research and architecture.
- A risk/security persona before building.
- A QA/evaluation persona before live use.
- A memory/documentation persona to stop the system from decaying.
- A combined meta-controller that can impersonate and coordinate the whole council.

## Standard Run Sequence

```text
Oracle
  ↓
Sophia
  ↓
Cartographer
  ↓
Architect
  ↓
QS
  ↓
Guardian
  ↓
Builder
  ↓
Evaluator
  ↓
Orchestrator
  ↓
Librarian
  ↺ feedback loop into Oracle, Sophia, Architect, Builder
```

## Operating Modes

### Mode 1: Full Council

Use all personas for high-stakes systems, client deployments, AI consulting engagements, complex game studio automation, or anything with cost, risk, or technical uncertainty.

### Mode 2: Fast Sprint

Use Oracle, Architect, QS, Builder, Evaluator, Orchestrator.

### Mode 3: Research Sprint

Use Oracle, Sophia, Cartographer, Architect.

### Mode 4: Build Sprint

Use Architect, QS, Guardian, Builder, Evaluator.

### Mode 5: Live Ops

Use Orchestrator, Evaluator, Guardian, Librarian.

## File Naming Convention

Use this convention for outputs:

```text
YYYY-MM-DD_project-name_stage_persona_output.md
```

Example:

```text
2026-04-29_press-start-games_oracle_diagnosis.md
2026-04-29_press-start-games_architect_agent-options.md
```

## Minimum Viable Workflow

For a first real run, create these files:

1. `01_ORACLE_DIAGNOSIS.md`
2. `02_SOPHIA_RESEARCH.md`
3. `04_ARCHITECT_SYSTEM_DESIGN.md`
4. `05_QS_COSTS_AND_OPTIONS.md`
5. `07_BUILDER_IMPLEMENTATION.md`
6. `08_EVALUATOR_QA_EVALS.md`
7. `09_ORCHESTRATOR_RUNTIME.md`

## Non-Negotiables

- Every agent must produce structured outputs.
- Every handoff must include assumptions, unknowns, risks, and next actions.
- No agent is allowed to invent facts when research or user confirmation is required.
- The Builder must not build until the Guardian and Evaluator define safety and quality gates.
- The Orchestrator must log decisions and feed learnings back into the Librarian.
