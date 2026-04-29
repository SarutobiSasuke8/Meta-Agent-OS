# QUALITY_BAR.md

## Purpose

This file defines the quality standard for Meta Agent OS outputs.

The system should be concise in control logic and comprehensive in stage outputs.

## Core Standard

Every major output must be:

- Specific
- Grounded in repository/project context
- Structured
- Useful to the next stage
- Honest about uncertainty
- Clear about assumptions
- Clear about risks
- Clear about next actions

## Bad Output Patterns

Reject or revise outputs that are:

- Generic
- Vague
- Inspirational but not operational
- Missing assumptions
- Missing risks
- Missing file paths
- Missing next actions
- Overconfident without evidence
- Overbuilt for the user's actual context
- Too long without structure
- Too short to be useful downstream
- Full of agent theatre rather than practical work

## Good Output Patterns

Good outputs include:

- Objective
- Inputs used
- Evidence from repo context
- Findings
- Constraints
- Assumptions
- Risks
- Open questions
- Recommended next action
- Files created or updated

## Elegance vs Comprehensiveness

The control layer should be elegant.

The stage outputs should be comprehensive enough to support the next decision.

## Quality Gate

Before a stage is marked complete, ask:

```text
Could the next persona use this output without asking the same basic questions again?
```

If the answer is no, improve the output before advancing.
