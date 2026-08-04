# Worked Example: Support Triage Agent System

## Objective

Show how Meta Agent OS turns a vague agent idea into a safer build-ready plan.

This is a synthetic example. It contains no real customer data, credentials, or private workflows.

## Starting Prompt

```text
We want an AI agent system to handle customer support tickets automatically.
It should read tickets, decide priority, draft replies, update the CRM, and escalate hard cases.
```

## Oracle Diagnosis

### Findings

- The real problem is slow and inconsistent support triage, not full support automation.
- Fully automatic replies and CRM updates are risky before trust is established.
- Human review is needed for customer-facing messages and account-impacting changes.
- A staged support assistant is more appropriate than a fully autonomous support agent.

### Assumptions

- Tickets contain customer data.
- Some tickets may include billing, security, or legal concerns.
- The team already has a ticketing system and CRM.

### Recommended Scope

Start with triage and draft assistance:

- Classify ticket type.
- Estimate urgency.
- Suggest routing.
- Draft a response.
- Flag sensitive cases.
- Require human approval before sending or updating external systems.

## Sophia Research

### Comparable Patterns

- Human-in-the-loop support assistants
- Ticket classification systems
- Retrieval-assisted draft reply systems
- Escalation routers

### Implication

The first useful system should improve human support workflow, not replace support staff.

## Cartographer Workflow Map

| Step | Current Owner | Input | Output | Agent Fit | Human Approval |
|---|---|---|---|---|---|
| Receive ticket | Ticketing system | Customer message | New ticket | Low | No |
| Classify issue | Support agent | Ticket text | Category | High | No |
| Prioritize | Support agent | Ticket + customer context | Priority | Medium | For high-impact cases |
| Draft reply | Support agent | Ticket + policy docs | Draft response | High | Yes |
| Update CRM | Support agent | Final decision | CRM note | Medium | Yes |
| Escalate | Support lead | Risk flags | Escalation | High | Yes |

## Architect Design

### Lightweight Option

One assistant that classifies tickets and drafts replies in the support UI.

Pros:

- Simple.
- Low integration risk.
- Fast to test.

Cons:

- Less automated routing.

### Balanced Option

Three-role system:

- Triage Agent: classifies and prioritizes.
- Drafting Agent: writes suggested replies from approved knowledge.
- Escalation Agent: flags billing, legal, security, angry customer, or unclear cases.

Human approves every external action.

### Advanced Option

Full workflow automation with CRM updates and auto-send for low-risk tickets.

Rejected for first build because it is too risky before evals and trust data exist.

## QS Cost Plan

Directional estimate:

- Prototype: 1-2 weeks.
- Internal pilot: 2-4 additional weeks.
- Production hardening: depends on integrations, data access, evals, and compliance.

Main cost drivers:

- Ticket/CRM integration.
- Knowledge base cleanup.
- Evaluation dataset.
- Human review interface.

## Guardian Risk Review

Verdict: Approved with restrictions.

Restrictions:

- No auto-send in prototype.
- No CRM write-back without approval.
- Sensitive categories must escalate.
- Drafts must cite source policy where possible.
- Logs must avoid unnecessary customer data retention.

## Builder-Ready Plan

Minimum viable system:

1. Ingest ticket text from a test dataset.
2. Classify category and urgency.
3. Generate draft reply using approved help-center content.
4. Flag escalation reasons.
5. Output a reviewer packet for a human support agent.

## Evaluator Plan

Acceptance criteria:

- Classification is correct on a labeled test set.
- Escalation triggers catch billing, legal, security, and angry-customer cases.
- Drafts do not invent policies.
- Human reviewer can approve, edit, or reject.
- No external messages are sent during prototype.

## Final Recommendation

Build the Balanced option as a supervised support triage assistant.

Do not build full support automation until the system passes evals and the team has reviewed risk, cost, customer impact, and failure modes.

## Files Created Or Updated

- `docs/examples/WORKED_EXAMPLE_SUPPORT_TRIAGE.md`
