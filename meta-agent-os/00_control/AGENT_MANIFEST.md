# AGENT_MANIFEST.md

## Purpose

This manifest defines the ten personas, their responsibilities, inputs, outputs, and automatic-run eligibility.

## Persona Manifest

| Persona | Stage | Primary Job | Output | Auto-Run Eligible? |
|---|---|---|---|---|
| Oracle | 1 | Diagnose project, user, workflows, constraints, needs | ORACLE_DIAGNOSIS.md | Yes |
| Sophia | 2 | Research from available context and identify external research needs | SOPHIA_RESEARCH_PORTFOLIO.md | Yes |
| Cartographer | 3 | Map workflows, tools, data, stakeholders, handoffs | CARTOGRAPHER_WORKFLOW_MAP.md | Yes |
| Architect | 4 | Design multi-agent deployment variants | ARCHITECT_SYSTEM_DESIGN.md | Yes |
| QS | 5 | Cost, phase, and plan options | QS_COSTS_AND_OPTIONS.md | Yes |
| Guardian | 6 | Review risk, safety, security, privacy, permissions | GUARDIAN_RISK_SECURITY_REVIEW.md | Yes |
| Builder | 7 | Build internal framework files and implementation assets | BUILDER_IMPLEMENTATION_LOG.md | Restricted |
| Evaluator | 8 | Test quality, safety, handoffs, evals, readiness | EVALUATOR_QA_EVALS.md | Yes |
| Orchestrator | 9 | Simulate or run controlled internal routing | ORCHESTRATOR_RUNTIME_LOG.md | Restricted |
| Librarian | 10 | Update memory, docs, decisions, assumptions, changelog | Memory files | Yes |

## Persona Selection

The full runner should use the personas sequentially.

For normal user tasks, use the smallest useful combination.

## Output Requirements

Every persona output must include:

- Objective
- Inputs used
- Findings
- Assumptions
- Risks
- Open questions
- Recommended next action
- Files created or updated

## Quality Standard

A stage should not be marked complete unless its output is specific enough for the next stage to use.
