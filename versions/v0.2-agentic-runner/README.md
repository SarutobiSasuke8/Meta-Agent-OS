# Meta Agent OS Companion Files

## What This Is

This pack contains the project-root files that make the Meta Agent OS easier to drop into an existing repository and use with coding agents such as Claude Code, Codex, Cursor, or similar agentic development tools.

The companion files do not replace the main Meta Agent OS framework. They sit beside it and tell agentic tools how to behave when working inside the repository.

## Included Files

```text
CLAUDE.md
AGENTS.md
META_AGENT_BOOTSTRAP.md
INSTALL.md
.claude/commands/diagnose.md
meta-agent-os/00_control/first_run_diagnosis_prompt.md
meta-agent-os/03_outputs/
meta-agent-os/05_memory/
```

## What Each File Does

### `CLAUDE.md`

Root-level instructions for Claude Code.

Use this to define:

- The purpose of the Meta Agent OS
- The ten-persona council
- The default behaviour for Claude Code
- The first-run diagnosis protocol
- Safety and approval rules

### `AGENTS.md`

Cross-agent instructions for tools that read `AGENTS.md`, including Codex-style coding agents.

Use this to define:

- Repository operating rules
- Persona routing logic
- File handling rules
- Build rules
- First-run diagnosis expectations

### `META_AGENT_BOOTSTRAP.md`

The first-run bootstrap manual.

Use this when you want an agent to inspect the project and start the diagnosis stage from existing project context.

### `.claude/commands/diagnose.md`

A Claude Code custom command.

Once copied into a project, you can run:

```text
/diagnose
```

This should trigger The Oracle diagnosis stage.

### `meta-agent-os/00_control/first_run_diagnosis_prompt.md`

A reusable first-run prompt for Codex, Claude Code, Cursor, or another coding agent.

### `meta-agent-os/03_outputs/`

Where stage outputs should be saved.

Expected first-run diagnosis output:

```text
meta-agent-os/03_outputs/diagnosis/ORACLE_DIAGNOSIS.md
```

### `meta-agent-os/05_memory/`

Where durable project memory should be stored.

Expected first-run memory files:

```text
meta-agent-os/05_memory/project_brain.md
meta-agent-os/05_memory/assumptions_log.md
meta-agent-os/05_memory/decision_log.md
```

## How To Install

Copy the contents of this pack into the root of your target project.

Your project should look roughly like this:

```text
/project-root
  README.md
  CLAUDE.md
  AGENTS.md
  META_AGENT_BOOTSTRAP.md
  INSTALL.md
  /.claude
    /commands
      diagnose.md
  /meta-agent-os
    /00_control
    /03_outputs
    /05_memory
```

If you are also using the full Meta Agent OS framework, merge the folders so you have:

```text
/meta-agent-os
  /00_control
  /01_agents
  /02_workflows
  /03_outputs
  /04_evals
  /05_memory
  /06_templates
```

## How To Start Diagnosis

### Claude Code

From the project root, run:

```text
/diagnose
```

Or paste:

```text
Read CLAUDE.md, AGENTS.md, and META_AGENT_BOOTSTRAP.md. Run The Oracle diagnosis stage for this repository.
```

### Codex Or Other Coding Agents

Paste:

```text
Read AGENTS.md and META_AGENT_BOOTSTRAP.md. Run The Oracle diagnosis stage for this repository.

Inspect the repo structure and relevant documentation.

Create:
- /meta-agent-os/03_outputs/diagnosis/ORACLE_DIAGNOSIS.md
- /meta-agent-os/05_memory/project_brain.md
- /meta-agent-os/05_memory/assumptions_log.md
- /meta-agent-os/05_memory/decision_log.md

Do not modify application code yet.

Separate facts from assumptions.

After the diagnosis, recommend whether the next step should be Sophia research, Cartographer workflow mapping, or Architect system design.
```

## Important Behaviour

These files do not execute automatically just because they exist.

They guide an agent once the agent is invoked.

To start the system, you need a trigger such as:

- A Claude Code slash command
- A prompt
- A Codex task
- A Cursor instruction
- A script
- A scheduled automation
- A Git hook or CI step, if you intentionally wire one up

## First-Run Logic

The agent should follow this rule:

```text
Check whether /meta-agent-os/03_outputs/diagnosis/ORACLE_DIAGNOSIS.md exists.

If it does not exist:
  Run The Oracle diagnosis stage first.

If it exists:
  Continue from the latest relevant stage.
```

## The Ten Meta Agent OS Personas

1. **The Oracle**  
   Diagnoses the user, project, workflow, constraints, bottlenecks, and true needs.

2. **Sophia**  
   Conducts research and builds an evidence base.

3. **The Cartographer**  
   Maps workflows, tools, data sources, stakeholders, and handoffs.

4. **The Architect**  
   Designs optimised multi-agent deployment variants.

5. **The QS**  
   Costs the options and creates practical phased plans.

6. **The Guardian**  
   Reviews risk, privacy, security, permissions, compliance, and failure modes.

7. **The Builder**  
   Implements prompts, files, configs, workflows, scripts, and agent assets.

8. **The Evaluator**  
   Creates tests, evals, acceptance criteria, and launch readiness checks.

9. **The Orchestrator**  
   Routes work, manages handoffs, supervises runtime, and improves the system.

10. **The Librarian**  
   Maintains memory, documentation, decision logs, assumptions, changelog, and reusable patterns.

## Recommended First Use Case

Use this pack when you want to turn a repo into a self-diagnosing agent workspace.

Good first targets:

- A game development hub
- Press Start Games
- Cryptic Grove
- CGG website
- AI consulting company
- Web3 BD operating system
- Multi-agent research and content engine

## Non-Negotiables

- Diagnose before building.
- Do not modify app code during first diagnosis.
- Separate facts from assumptions.
- Preserve existing project context.
- Record major decisions.
- Record major assumptions.
- Do not grant agents risky tool permissions by default.
- Add evals before treating any agent system as production-ready.

## Suggested Next Step After Install

Run:

```text
/diagnose
```

Then review:

```text
meta-agent-os/03_outputs/diagnosis/ORACLE_DIAGNOSIS.md
```

After that, move into:

```text
Sophia -> Cartographer -> Architect
```

unless the diagnosis shows the project is already well understood.

## v0.2 Agentic Runner Layer

This version adds the missing runner layer that lets an agentic coding tool progress through the Meta Agent OS as a controlled multi-stage system.

New files:

```text
meta-agent-os/00_control/RUN_META_AGENT_OS.md
meta-agent-os/00_control/STAGE_STATE.md
meta-agent-os/00_control/STAGE_GATES.md
meta-agent-os/00_control/RESUME_PROTOCOL.md
meta-agent-os/00_control/AGENT_MANIFEST.md
meta-agent-os/00_control/STAGE_STATUS_TEMPLATE.md
.claude/commands/run-meta-agent-os.md
.claude/commands/continue-meta-agent-os.md
.claude/commands/stage-status.md
```

### Full Trigger

In Claude Code, run:

```text
/run-meta-agent-os
```

This should attempt to progress through:

```text
Oracle -> Sophia -> Cartographer -> Architect -> QS -> Guardian -> Builder -> Evaluator -> Orchestrator -> Librarian
```

It will stop at human decision gates.

### Resume Trigger

If the run stops or loses context, run:

```text
/continue-meta-agent-os
```

### Status Trigger

To check progress, run:

```text
/stage-status
```

## Will This Truly Work By Dropping It Into A Folder?

It will work as a guided agentic system when these conditions are true:

1. The files are copied into the project root.
2. The agentic tool can read project files.
3. The agentic tool recognises either `CLAUDE.md`, `AGENTS.md`, or the explicit prompt you give it.
4. The trigger command or prompt is run.
5. The agent has permission to create Markdown files.
6. The tool respects the stage gates.

It will not run merely because the folder exists. Markdown files are instructions and state, not an always-on process.

The reliable pattern is:

```text
Drop files into project -> open with Claude Code/Codex/Cursor -> run trigger -> agent reads state -> agent advances stages -> agent stops at gates
```

## Recommended First Command

```text
/run-meta-agent-os
```

If you only want diagnosis:

```text
/diagnose
```
