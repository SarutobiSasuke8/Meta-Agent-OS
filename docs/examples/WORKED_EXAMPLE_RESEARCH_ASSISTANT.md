# Worked Example: Research Assistant

## Objective

Show how Meta Agent OS handles a tempting "build me a research agent" request without jumping straight into automation.

## Inputs Used

- Synthetic product request
- Meta Agent OS stage sequence
- Current public boundary: framework/specification layer, not runtime engine

## Scenario

A small strategy team wants an AI research assistant that watches competitor sites, summarizes changes, drafts weekly briefs, and alerts the team when a competitor launches a new product.

This example is synthetic. It contains no real client data, credentials, private sources, or live monitoring setup.

## Oracle Diagnosis

Initial diagnosis:

- The team needs better competitor awareness.
- The stated request mixes research, monitoring, summarization, alerting, and workflow routing.
- The highest-risk parts are source reliability, hallucinated claims, copyright handling, and alert fatigue.
- A fully autonomous watcher is premature until source lists, review standards, and escalation rules are defined.

Oracle verdict:

- Proceed to research and workflow mapping.
- Do not build a live monitoring agent yet.

## Sophia Research

Research questions:

- Which sources are approved?
- Which sources are high trust versus weak signals?
- What counts as a meaningful competitor change?
- What citation standard does the team need?
- How often should summaries be produced?

External claims should be cited or marked unverified before they enter the weekly brief.

## Cartographer Workflow Map

Workflow:

1. Maintain approved source list.
2. Collect changes from approved sources.
3. Deduplicate repeated announcements.
4. Summarize only material changes.
5. Attach citations and source dates.
6. Route draft brief to a human reviewer.
7. Publish internally after review.
8. Record decisions and recurring false positives.

## Architect Design

Recommended design:

- Source Collector: gathers approved URLs or feeds.
- Evidence Keeper: stores citations, dates, and source snippets.
- Brief Writer: drafts summaries with explicit uncertainty labels.
- Reviewer Gate: requires human approval before internal publication.
- Memory Keeper: tracks recurring competitors, false positives, and decisions.

Rejected design:

- A fully autonomous agent that monitors the open web and posts alerts directly to Slack without review.

## QS Cost And Options

Minimal first build:

- Manual source list.
- Weekly run.
- Draft-only brief.
- Human review before sharing.

Future expansion:

- Scheduled collection.
- Source-change detection.
- Internal dashboard.
- Alert thresholds.

## Guardian Risk Review

Main risks:

- False claims about competitors.
- Copyright-sensitive reuse of source content.
- Over-alerting.
- Secret or paid-source leakage.
- Treating weak signals as facts.

Required controls:

- Approved sources only.
- Citations required.
- Human review before publication.
- Clear labels for confirmed, likely, and unverified findings.

## Builder Scope

Safe Builder output:

- Prompt templates.
- Source-list format.
- Brief template.
- Review checklist.
- Evaluation cases.

Unsafe without approval:

- Live scraping.
- Paid API use.
- Posting to Slack or email.
- Storing credentials.

## Evaluator Checks

Acceptance criteria:

- Every claim has a source.
- Every source has a date.
- Weak claims are labelled.
- The brief separates facts from interpretation.
- The reviewer can reject or revise before publishing.

## Orchestrator Runtime Shape

If later implemented as a runtime:

- Run on a fixed schedule.
- Use approved sources only.
- Stop at reviewer gate.
- Record final reviewed brief and rejected claims.
- Escalate only when thresholds are met.

## Librarian Memory

Memory should preserve:

- Approved sources.
- Rejected sources.
- Common false positives.
- Competitor taxonomy.
- Brief decisions and reviewer feedback.

## Findings

The first useful system is not a fully autonomous research agent. It is a supervised evidence-to-brief workflow with strong citation discipline.

## Assumptions

- The team already has a known competitor set.
- Internal publication is lower risk than public publication.
- Weekly cadence is sufficient for the first version.

## Risks

- Source access terms may limit collection.
- Competitive claims can become stale quickly.
- The team may over-trust polished summaries.

## Open Questions

- Which sources are allowed?
- What is the review SLA?
- Which findings require immediate escalation?
- Where should approved briefs be stored?

## Recommended Next Action

Create a source-list template and a weekly brief template before building any monitoring runtime.

## Files Created Or Updated

- `docs/examples/WORKED_EXAMPLE_RESEARCH_ASSISTANT.md`
