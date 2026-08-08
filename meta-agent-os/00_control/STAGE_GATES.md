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

May run automatically **only after the suitability gate passes.**

Must include at least one lightweight option.

Do not assume complex multi-agent architecture is required.

#### Suitability Gate (added v0.6.1)

Architect must not advance when any of the following holds. Each is a stop, not a warning.

| Condition | Source | Action |
|---|---|---|
| Any anti-agent gate condition fails | `scripts/agent-suitability.py` exits non-zero | Stop. Report the finding and recommend the deterministic alternative. |
| Suitability band is Not Suitable | Total 0-8, or a zero on `tolerance_for_error` or `recoverability` | Stop. Build deterministic automation instead. |
| Suitability band is Marginal | Total 9-14 | Stop for human decision. Proceed only with an explicit, recorded justification and a narrowed scope. |
| ROI is negative | `scripts/roi-calculator.py` | Stop. Running cost exceeds the baseline. |
| ROI is between 0 and 0.5 | `scripts/roi-calculator.py` | Stop for human decision. Proceed only if a named non-cost benefit justifies it. |
| The verdict flips inside the sensitivity range | `scripts/roi-calculator.py` | Stop. Run a measured pilot before committing to a build. |

Run suitability **before** ROI. A workflow that fails the gate should never reach a cost model, because the cost of the wrong architecture is not a useful number.

Both tools exit non-zero when they block, so this gate can be enforced in a pipeline rather than remembered. As of v0.6.1, the strict hardening check (`scripts/check-meta-agent-os.sh` / `.ps1 -Strict`) enforces the record of that verdict: when Architect is marked complete in `STAGE_STATE.json`, strict validation fails unless the assessment file named by `STAGE_MANIFEST.json`'s `assessment_file` field exists, is valid JSON, and answers all four anti-agent gate conditions, and unless Architect's own output contains the required "Suitability And ROI Gate" section. This closes the gap between the tools existing and the gate being checked automatically.

This is enforcement of the *record*, not a runtime interlock: there is no running process that stops an agent from marking Architect complete without having run the tools first. The check catches it after the fact, on the next `/mao-validate`, `/mao-harden`, or CI run, not before the agent writes the output. An agent (or operator) that skips strict validation entirely can still advance unchecked.

A blocked advancement is a successful outcome for the framework. It is cheaper to stop here than after a build.

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
