# STAGE_GATES.md

## Purpose

This file defines when the Meta Agent OS may continue automatically and when it must stop for human approval.

## Default Position

The system may continue through read-only analysis, documentation, planning, and internal framework file creation.

The system must stop before external, irreversible, risky, costly, or production-affecting actions.

## Approval Levels

| Level | Action Type | Examples | May Continue Automatically? |
|---|---|---|---|
| 0 | Read-only analysis | Inspect repo, read docs, summarise files | Yes |
| 1 | Internal documentation | Create Markdown diagnosis, plans, prompts | Yes |
| 2 | Internal framework setup | Create agent files, eval templates, state files | Yes |
| 3 | Application code modification | Edit app source, install dependencies, change configs | No, unless explicitly requested |
| 4 | External system action | Send email, post publicly, update live tools, deploy | No |
| 5 | Sensitive / irreversible action | Delete files, modify credentials, spend money, change permissions | No, explicit confirmation required |

## Stage Gate Rules

### Oracle

May run automatically.

Stop if the repo contains sensitive data that appears unsafe to inspect further.

### Sophia

May run automatically using available repo context.

If web research is required but the local agent has no browsing access, create a research brief and mark external research as required.

### Cartographer

May run automatically.

Stop only if workflow context is too thin to map meaningfully.

### Architect

May run automatically.

Must include at least one lightweight option.

Do not assume complex multi-agent architecture is required.

### QS

May run automatically.

If exact costs require current pricing, mark estimates as approximate and identify what must be verified.

### Guardian

May run automatically.

If Guardian verdict is anything other than `Approved for prototype` or `Approved with restrictions`, stop before Builder.

### Builder

May create internal Meta Agent OS files automatically.

Must not modify application code unless explicitly authorised.

Must not install packages unless explicitly authorised.

Must not delete files.

### Evaluator

May run automatically on internal files and generated docs.

Must not execute destructive tests.

### Orchestrator

May simulate runtime or run read-only internal routing.

Must not take external action.

### Librarian

May update memory docs automatically.

Must preserve prior context.

## Required Stop Phrases

If blocked, the agent should write:

```text
The Meta Agent OS has paused at a human decision gate.
```

Then explain:

- Stage
- Reason
- Risk
- Options
- Recommended decision
