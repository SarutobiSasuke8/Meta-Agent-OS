# Cartographer Workflow Map

**Stage:** Cartographer  
**Date:** 2026-05-06  
**Project:** Meta Agent OS  
**Status:** Complete  
**Feeds into:** Architect, QS, Guardian

---

## Objective

Map Meta Agent OS as a public framework product: how users enter, move through diagnosis and design stages, validate outputs, preserve memory, and export the framework into other repositories.

## Inputs Used

- `README.md`
- `AGENTS.md`
- `CLAUDE.md`
- `CODEX_RUNBOOK.md`
- `META_AGENT_BOOTSTRAP.md`
- `ROADMAP.md`
- `docs/REPO_HARDENING.md`
- `skills/meta-agent-os/SKILL.md`
- `meta-agent-os/00_control/STAGE_STATE.json`
- `meta-agent-os/00_control/STAGE_MANIFEST.json`
- `meta-agent-os/00_control/STAGE_GATES.md`
- `meta-agent-os/00_control/RUN_MODES.json`
- `meta-agent-os/03_outputs/diagnosis/ORACLE_DIAGNOSIS.md`
- `meta-agent-os/03_outputs/research/SOPHIA_RESEARCH_PORTFOLIO.md`

---

## 1. System Boundary

Meta Agent OS is a repo-native design and governance layer for multi-agent systems. It operates before runtime implementation frameworks such as LangGraph, CrewAI, AutoGen, OpenAI Agents SDK, n8n, or custom code.

In scope:

- Stage methodology
- Persona roles
- Control manifests
- Schemas and validators
- Claude slash commands
- Codex prompt triggers
- Skill adapter
- Durable memory
- Worked examples
- Internal hardening checks

Out of scope:

- Runtime execution engine
- Hosted dashboard
- Secret management
- Production deployment automation
- Live agent orchestration against external systems

## 2. Users And Stakeholders

| Stakeholder | Need | Success Signal |
|---|---|---|
| Solo builder | Turn a vague agent idea into a build-ready plan | Diagnosis, workflow map, architecture, and risk review exist |
| Consultant | Scope client agent systems consistently | Repeatable outputs and handoff standard |
| Enterprise architect | Evaluate agent suitability before build | Cost, risk, governance, and approval gates are explicit |
| Developer team | Implement from a clear spec | Builder receives concrete architecture and constraints |
| Compliance/security reviewer | Understand risks before runtime | Guardian output is specific and actionable |
| Maintainer | Keep framework files aligned | Hardening check passes |

## 3. Current-State Workflow

Current workflow is file-driven and agent-operated:

1. User reads README or AGENTS.
2. User invokes a Claude command, Codex prompt, or skill trigger.
3. Agent reads control files and current state.
4. Agent produces stage output under `03_outputs`.
5. Agent updates memory under `05_memory`.
6. Agent updates `STAGE_STATE.json` and `STAGE_STATE.md`.
7. Agent runs structural hardening check.
8. Human reviews next action or approval gate.

Current friction:

- The full workflow is powerful but still feels heavy for first-time users.
- Stage validation is mostly structural.
- There is no complete worked example.
- The product boundary versus Agent Ops OS needs sharper explanation.

## 4. Future-State Workflow

Future workflow should feel like:

1. User asks a simple trigger: "diagnose this agent idea" or `/mao-diagnose`.
2. Meta Agent OS identifies the smallest suitable run mode.
3. Oracle determines whether agents are needed at all.
4. Cartographer maps the real workflow before architecture.
5. Architect proposes lightweight, balanced, and advanced options.
6. QS estimates implementation and operating cost without fake precision.
7. Guardian approves, restricts, or blocks.
8. Builder creates internal specs, prompts, configs, or templates only after Guardian.
9. Evaluator defines tests and launch readiness.
10. Librarian preserves decisions, assumptions, and reusable patterns.

## 5. Data Sources

| Source | Role | Risk |
|---|---|---|
| Root docs | Public product framing | Can drift from control files |
| `00_control` | State machine and operating protocol | Missing files break runs |
| `03_outputs` | Stage evidence and outputs | Weak outputs weaken later stages |
| `05_memory` | Durable project memory | Can become stale if not updated |
| Version folders | Recovery source for released layers | Can diverge from active root layer |
| Sibling repos | Inspiration and hardening patterns | Should not be copied blindly |

## 6. Tools And Interfaces

| Interface | Primary User | Purpose |
|---|---|---|
| README | New users | Understand what the framework is |
| AGENTS.md | Generic agents and Codex | Canonical operating rules |
| CLAUDE.md | Claude Code | Claude-specific instructions |
| CODEX_RUNBOOK.md | Codex | Prompt-based triggers |
| `.claude/commands` | Claude Code users | Slash command interface |
| `skills/meta-agent-os` | Codex skill users | Reusable trigger/navigation layer |
| `scripts/check-meta-agent-os.*` | Maintainers and CI | Structural validation |
| GitHub Actions | Maintainers | Prevent drift on PRs |

## 7. Decision Points

| Decision | Owner | When |
|---|---|---|
| Is an agent system actually needed? | Oracle + human | Before design |
| Which run mode is sufficient? | Agent + human | Before running stages |
| Which architecture variant should proceed? | Architect + human | Before QS/Guardian |
| Is cost/effort justified? | QS + human | Before Builder |
| Are risks acceptable? | Guardian + human | Before Builder |
| Is this public, private, or commercial? | Maintainer | Before release |
| Does this belong in MAS or Agent Ops OS? | Maintainer | Before adding features |

## 8. Human Approval Gates

Human approval is required for:

- External actions
- Public posting or publishing
- Credential, permission, or payment changes
- Destructive file operations
- Application source modifications during diagnosis
- Proceeding when Guardian verdict is more restrictive than "Approved with restrictions"

Internal docs, schemas, examples, and framework hardening may continue automatically when scoped and reversible.

## 9. Automation Candidates

| Candidate | Why |
|---|---|
| State consistency check | Deterministic and easy to validate |
| Required file check | Deterministic |
| Required section check | Deterministic enough for Markdown |
| Encoding artifact scan | Deterministic |
| Export readiness report | Deterministic plus light judgment |
| Stage status summary | Mostly deterministic |

## 10. Agent Candidates

| Candidate | Why Agent Fit |
|---|---|
| Oracle diagnosis | Requires judgment and synthesis |
| Sophia research | Requires evidence selection and implications |
| Cartographer mapping | Requires workflow reasoning |
| Architect variants | Requires tradeoff design |
| QS planning | Requires approximate estimation and phasing |
| Guardian review | Requires risk judgment |
| Evaluator QA design | Requires scenario and failure-mode thinking |

## 11. Non-Agent Automation Candidates

| Candidate | Better As Script? | Reason |
|---|---|---|
| JSON parsing | Yes | Deterministic |
| Required path validation | Yes | Deterministic |
| Required Markdown heading check | Yes | Deterministic |
| Broken encoding scan | Yes | Deterministic |
| CI invocation | Yes | Deterministic |
| Diff/stat summary | Yes | Deterministic |

## 12. Risk Zones

- Overlap with Agent Ops OS could blur product positioning.
- Too many commands could make the framework feel larger than it is.
- Weak examples could make the method seem theoretical.
- Validators that only check file presence could create false confidence.
- Vertical/commercial packs could confuse the open-source boundary.
- Running full stages for small ideas could feel like bureaucracy.

## 13. Dependency Map

```text
README / AGENTS / CLAUDE / CODEX_RUNBOOK
  -> 00_control manifests, gates, schemas, validators
  -> stage outputs in 03_outputs
  -> memory in 05_memory
  -> hardening scripts and CI
  -> skill adapter and slash commands
```

## 14. Handoff Map

| From | To | Handoff Artifact |
|---|---|---|
| Oracle | Sophia | Diagnosis, assumptions, open questions |
| Sophia | Cartographer | Research implications and positioning |
| Cartographer | Architect | Workflow map and automation/agent fit |
| Architect | QS | Architecture variants |
| QS | Guardian | Recommended phased plan and cost warnings |
| Guardian | Builder | Verdict and restrictions |
| Builder | Evaluator | Implementation log |
| Evaluator | Orchestrator | QA verdict and test plan |
| Orchestrator | Librarian | Runtime/coordination notes |
| Librarian | Future runs | Updated memory |

## 15. Recommendations For The Architect

Architect should design around a balanced public framework pack:

- Keep Markdown and control files as the core product.
- Keep CLI and dashboard ideas later, not immediate.
- Add one complete worked example before expanding features.
- Strengthen validators before adding more stages.
- Keep Agent Ops OS separate: it operates AI coding agents in repos; MAS designs multi-agent systems before build.

## 16. Workflow Step Table

| Workflow Step | Current Owner | Input | Output | Frequency | Complexity | Risk | Agent Fit | Better As Script? | Human Approval Needed? |
|---|---|---|---|---|---|---|---|---|---|
| Trigger run | Human | Goal or command | Selected run mode | Per project | Low | Low | Medium | No | No |
| Diagnose | Oracle | Repo context, user goal | Diagnosis | Per project/system | Medium | Medium | High | No | No |
| Research | Sophia | Diagnosis, project files | Research portfolio | As needed | Medium | Medium | High | No | Only for external research |
| Map workflow | Cartographer | Diagnosis, research | Workflow map | Per system | Medium | Medium | High | No | No |
| Design variants | Architect | Workflow map | Architecture options | Per system | High | Medium | High | No | No |
| Cost plan | QS | Architecture options | Cost and implementation plan | Per system | Medium | Medium | High | No | If exact paid decisions required |
| Risk review | Guardian | Costed architecture | Risk verdict | Per system | High | High | High | No | If restricted/blocking verdict |
| Build internal files | Builder | Approved plan | Prompts/configs/examples | As approved | Medium | Medium | Medium | Partly | If app code/external actions |
| Define evals | Evaluator | Build log | QA/eval plan | Per build | Medium | Medium | High | Partly | No |
| Update memory | Librarian | Outputs and decisions | Durable memory | Every major run | Low | Medium | Medium | Partly | No |
| Check structure | Script/CI | Repo files | Pass/fail | Every PR/run | Low | Low | Low | Yes | No |

## Assumptions

- Meta Agent OS remains a design-time methodology rather than a runtime framework.
- The active root `meta-agent-os` folder is the source of truth for current operation.
- A small operator layer is valuable if it does not duplicate the methodology.

## Risks

- Users may expect runtime execution if the word "OS" is overextended.
- Existing docs still contain encoding artifacts that reduce polish.
- The current example set is too thin for strangers to trust the framework quickly.

## Open Questions

- Should the first public example target software teams, consultants, or game studios?
- Should the CLI be named `mas`, `meta-agent-os`, or deferred entirely?
- Should vertical packs live in this repo as stubs or in separate private/commercial repos?

## Recommended Next Action

Proceed to Architect. Design three product-shape options and recommend the smallest credible public release architecture.

## Files Created Or Updated

- `meta-agent-os/03_outputs/maps/CARTOGRAPHER_WORKFLOW_MAP.md`
