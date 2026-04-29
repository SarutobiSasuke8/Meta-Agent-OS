# 12. Handoff Protocols

## Purpose

This file defines how one persona hands work to the next.

Bad handoffs are one of the biggest failure points in multi-agent systems.

## Universal Handoff Template

```markdown
# Handoff

## From

## To

## Project

## Date

## Objective

## Summary of Work Completed

## Key Findings

## Decisions Made

## Assumptions

## Unknowns

## Risks

## Recommended Next Actions

## Required Inputs for Next Agent

## Output Files Created
```

## Persona-Specific Handoffs

### Oracle to Sophia

The Oracle should hand Sophia:

- User profile
- Core problem
- Constraints
- Research questions
- Key unknowns
- Priority areas

### Sophia to Cartographer

Sophia should hand Cartographer:

- Research findings
- Comparable systems
- Tooling landscape
- Workflow implications
- Technical feasibility notes

### Cartographer to Architect

Cartographer should hand Architect:

- Current workflow
- Future workflow
- Data map
- Tool map
- Stakeholder map
- Agent opportunity matrix

### Architect to QS

Architect should hand QS:

- Architecture variants
- Recommended variant
- Infrastructure assumptions
- Model assumptions
- Tool requirements
- Complexity level

### QS to Guardian

QS should hand Guardian:

- Cost plan
- Infrastructure plan
- Tool permissions
- Budget risks
- Operational assumptions

### Guardian to Builder

Guardian should hand Builder:

- Approved permissions
- Restricted permissions
- Required approval gates
- Security requirements
- Failure modes to avoid

### Builder to Evaluator

Builder should hand Evaluator:

- Built assets
- Setup instructions
- Known limitations
- Test environment
- Expected behaviours

### Evaluator to Orchestrator

Evaluator should hand Orchestrator:

- Test results
- Launch verdict
- Acceptance criteria
- Known weaknesses
- Monitoring requirements

### Orchestrator to Librarian

Orchestrator should hand Librarian:

- Runtime logs
- Decisions made
- Changes made
- Learnings
- Recurring issues
- Next improvements

## Handoff Quality Checklist

Before accepting a handoff:

- Is the next action obvious?
- Are assumptions stated?
- Are risks stated?
- Are blockers stated?
- Are output files named?
- Are success criteria clear?
- Is there enough context to continue without asking the same questions again?
