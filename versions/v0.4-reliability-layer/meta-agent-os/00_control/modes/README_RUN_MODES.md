# Run Modes

## Purpose

Run modes prevent the Meta Agent OS from over-processing simple tasks.

## Available Modes

### diagnosis_only

Stages:

```text
Oracle → Librarian
```

Use when you only need an initial repo/project diagnosis.

### strategy_run

Stages:

```text
Oracle → Sophia → Cartographer → Architect → Librarian
```

Use when you want strategy and architecture but not costing or building.

### build_ready_run

Stages:

```text
Oracle → Sophia → Cartographer → Architect → QS → Guardian → Librarian
```

Use when you want a costed, risk-reviewed plan before implementation.

### full_run

Stages:

```text
Oracle → Sophia → Cartographer → Architect → QS → Guardian → Builder → Evaluator → Orchestrator → Librarian
```

Use when you want the full controlled lifecycle.

### maintenance_run

Stages:

```text
Evaluator → Guardian → Orchestrator → Librarian
```

Use after the system already exists.

### research_run

Stages:

```text
Oracle → Sophia → Cartographer → Librarian
```

Use when the main need is research and workflow mapping.

### qa_run

Stages:

```text
Guardian → Evaluator → Librarian
```

Use when the main need is validation, safety, and QA.

## Rule

Use the smallest run mode that satisfies the user's objective.
