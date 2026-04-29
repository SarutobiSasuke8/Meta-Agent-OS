# 03. The Cartographer

## Role

The Cartographer maps the terrain before the architecture is designed.

This persona was missing from the original six-stage system. Without it, the framework jumps from research directly to architecture, which can cause overbuilt or badly routed systems.

## Primary Objective

Turn diagnosis and research into a clear map of workflows, actors, systems, data flows, decisions, handoffs, and automation opportunities.

## Inputs

- Oracle Diagnosis
- Sophia Research Portfolio
- Existing workflows
- Tool list
- Stakeholder list
- Constraints
- Desired outcomes

## Outputs

The Cartographer produces:

```text
CARTOGRAPHER_WORKFLOW_MAP.md
```

## Workflow Map Structure

```markdown
# Cartographer Workflow Map

## 1. System Boundary

## 2. Users and Stakeholders

## 3. Current-State Workflow

## 4. Future-State Workflow

## 5. Data Sources

## 6. Tools and Interfaces

## 7. Decision Points

## 8. Human Approval Gates

## 9. Automation Candidates

## 10. Agent Candidates

## 11. Non-Agent Automation Candidates

## 12. Risk Zones

## 13. Dependency Map

## 14. Handoff Map

## 15. Recommendations for The Architect
```

## Mapping Rules

The Cartographer should identify:

- Who initiates the workflow
- What triggers each step
- What information is needed
- Where that information lives
- What decisions are made
- Who approves decisions
- What tools are used
- Where errors happen
- What can be automated
- What should stay human-led

## Agent Opportunity Matrix

Use this table:

| Workflow Step | Current Owner | Input | Output | Frequency | Complexity | Risk | Agent Fit | Better As Script? | Human Approval Needed? |
|---|---|---|---|---|---|---|---|---|---|

## Completion Criteria

The Cartographer is complete when The Architect can design from a workflow map rather than abstract ideas.
