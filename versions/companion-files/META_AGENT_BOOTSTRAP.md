# META_AGENT_BOOTSTRAP.md

## Purpose

This file makes the Meta Agent OS drop-in friendly.

Use it when adding the framework to an existing project repository.

## What This Can Do

When loaded by an agentic coding tool, this framework can inspect the project context and start the diagnosis stage.

However, the presence of this file alone does not execute anything. A human, CLI command, slash command, scheduled routine, or automation must trigger the agent.

## Recommended First Prompt

```text
Read CLAUDE.md, AGENTS.md, and META_AGENT_BOOTSTRAP.md.

Then initialise the Meta Agent OS for this repository.

Start with The Oracle.

Inspect the project structure, README, docs, package files, source folders, and existing Markdown files.

Create:

1. /meta-agent-os/03_outputs/diagnosis/ORACLE_DIAGNOSIS.md
2. /meta-agent-os/05_memory/project_brain.md
3. /meta-agent-os/05_memory/assumptions_log.md
4. /meta-agent-os/05_memory/decision_log.md

Do not modify application code yet.

After diagnosis, recommend the next best stage.
```

## Oracle First-Run Checklist

The Oracle should inspect:

- Repository tree
- README
- Existing documentation
- Package files
- Config files
- Source folder names
- Existing prompts
- Existing agent files
- Existing scripts
- Existing workflows
- Existing tests
- Existing deployment files

## First Diagnosis Output

Create:

```text
/meta-agent-os/03_outputs/diagnosis/ORACLE_DIAGNOSIS.md
```

With this structure:

```markdown
# Oracle Diagnosis

## 1. Executive Summary

## 2. What This Project Appears To Be

## 3. Evidence From Repository Context

## 4. Current Workflows

## 5. Likely User / Operator Needs

## 6. Bottlenecks

## 7. Existing Assets

## 8. Missing Assets

## 9. Agent Opportunities

## 10. Non-Agent Automation Opportunities

## 11. Risks

## 12. Assumptions

## 13. Open Questions

## 14. Recommended Next Stage
```

## Important Constraints

- Do not pretend uncertain repo context is fact.
- Mark inferred points as assumptions.
- Do not create a complex agent architecture yet.
- Do not edit code during diagnosis.
- Do not delete files.
- Do not call external services unless explicitly asked.
- Do not expose secrets or credentials.

## Next Step After Diagnosis

Usually hand off to:

```text
Sophia → Cartographer → Architect
```

If the project is already well understood, skip Sophia and go directly to Cartographer.
