# RUN_META_AGENT_OS.md

## Purpose

This file defines the full controlled run protocol for the Meta Agent OS.

It is designed to be invoked by a coding agent or agentic workspace after the framework has been dropped into a project repository.

## Key Rule

The system should run agentically, but not recklessly.

It should continue through stages while inputs are sufficient and risk is low. It should stop at meaningful human decision gates.

## Full Stage Sequence

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
```

## Stage Output Paths

```text
/meta-agent-os/03_outputs/diagnosis/ORACLE_DIAGNOSIS.md
/meta-agent-os/03_outputs/research/SOPHIA_RESEARCH_PORTFOLIO.md
/meta-agent-os/03_outputs/maps/CARTOGRAPHER_WORKFLOW_MAP.md
/meta-agent-os/03_outputs/architecture/ARCHITECT_SYSTEM_DESIGN.md
/meta-agent-os/03_outputs/costs/QS_COSTS_AND_OPTIONS.md
/meta-agent-os/03_outputs/risk/GUARDIAN_RISK_SECURITY_REVIEW.md
/meta-agent-os/03_outputs/build/BUILDER_IMPLEMENTATION_LOG.md
/meta-agent-os/03_outputs/evals/EVALUATOR_QA_EVALS.md
/meta-agent-os/03_outputs/runtime/ORCHESTRATOR_RUNTIME_LOG.md
/meta-agent-os/05_memory/project_brain.md
/meta-agent-os/05_memory/decision_log.md
/meta-agent-os/05_memory/assumptions_log.md
/meta-agent-os/05_memory/changelog.md
```

## Run Protocol

When invoked:

1. Read:
   - `CLAUDE.md`
   - `AGENTS.md`
   - `META_AGENT_BOOTSTRAP.md`
   - `/meta-agent-os/00_control/STAGE_STATE.md`
   - `/meta-agent-os/00_control/STAGE_GATES.md`
   - `/meta-agent-os/00_control/AGENT_MANIFEST.md`

2. Inspect the repository context.

3. Determine the current stage from `STAGE_STATE.md`.

4. Check whether the expected output file for the current stage already exists.

5. If it does not exist, run the current stage and create the output file.

6. If it does exist, validate it briefly and move to the next incomplete stage.

7. After every stage:
   - Update `STAGE_STATE.md`
   - Update `/meta-agent-os/05_memory/project_brain.md`
   - Update `/meta-agent-os/05_memory/assumptions_log.md`
   - Update `/meta-agent-os/05_memory/decision_log.md` if a decision was made
   - Update `/meta-agent-os/05_memory/changelog.md`

8. Continue until:
   - All stages are complete
   - A stage gate requires human approval
   - Required context is missing
   - The Guardian blocks the system
   - The Builder would modify application code without approval
   - External actions would be required
   - Costs, credentials, data access, or permissions require approval

## Stage Advancement Logic

Use this table:

| Current Stage | Required Input | Output | Next Stage |
|---|---|---|---|
| Oracle | Repo context | ORACLE_DIAGNOSIS.md | Sophia |
| Sophia | Oracle Diagnosis | SOPHIA_RESEARCH_PORTFOLIO.md | Cartographer |
| Cartographer | Oracle + Sophia | CARTOGRAPHER_WORKFLOW_MAP.md | Architect |
| Architect | Oracle + Sophia + Cartographer | ARCHITECT_SYSTEM_DESIGN.md | QS |
| QS | Architect Design | QS_COSTS_AND_OPTIONS.md | Guardian |
| Guardian | Architect + QS | GUARDIAN_RISK_SECURITY_REVIEW.md | Builder or blocked |
| Builder | Guardian-approved scope | BUILDER_IMPLEMENTATION_LOG.md | Evaluator |
| Evaluator | Built system | EVALUATOR_QA_EVALS.md | Orchestrator |
| Orchestrator | Eval-approved system | ORCHESTRATOR_RUNTIME_LOG.md | Librarian |
| Librarian | All outputs | Updated memory files | Complete |

## Stop Conditions

Stop and ask for human input if:

- The objective is unclear.
- The project appears to contain sensitive or regulated data.
- The project requires credentials.
- A planned action would affect external systems.
- A planned action would send email, publish content, spend money, deploy code, modify production, or delete files.
- The Guardian verdict is not approved.
- The estimated cost is meaningfully uncertain.
- The Builder needs to modify application code and the user has not approved this.

## Builder Restriction

During a full first run, The Builder may create framework files, prompts, documentation, test plans, and implementation notes.

The Builder must not modify application source code unless the user explicitly asked for implementation and the Guardian has approved the action.

## Completion

The run is complete when:

```text
Current stage: Complete
Blocked: no
Required human approval: no
Completed stages:
- Oracle
- Sophia
- Cartographer
- Architect
- QS
- Guardian
- Builder
- Evaluator
- Orchestrator
- Librarian
```
