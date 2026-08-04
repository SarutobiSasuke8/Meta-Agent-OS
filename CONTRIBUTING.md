# Contributing to Meta Agent OS

Thanks for considering a contribution. This repository is a **methodology and specification layer**, not a runtime. That boundary shapes what does and does not belong here.

Read [`docs/PUBLIC_BOUNDARY.md`](docs/PUBLIC_BOUNDARY.md) and [`docs/WHY.md`](docs/WHY.md) before proposing anything substantial.

---

## What Belongs In This Repository

- Stage schemas, validators, and quality bars
- Control files, run modes, gates, and state protocols
- Worked examples that demonstrate the method end to end
- Documentation that clarifies the method or its boundaries
- Validation tooling that keeps the framework honest
- Agent adapter files (`CLAUDE.md`, `AGENTS.md`, `CODEX_RUNBOOK.md`) and slash commands

## What Does Not Belong Here

- A runtime execution engine. See [`docs/RUNTIME_TRACK.md`](docs/RUNTIME_TRACK.md) — that work happens in a separate implementation track.
- A GUI, web application, or hosted service.
- Vendor-specific SDK integrations in the core.
- Vertical domain packs (Consulting, Financial Services, Healthcare, Legal). These are distributed under separate commercial licenses.
- Real client data, credentials, or internal company material of any kind.

If your idea is a runtime feature, it is not rejected — it is routed. Open an issue describing the runtime milestone it maps to in `docs/RUNTIME_TRACK.md`.

---

## Ground Rules

The framework's core claim is that diagnosis precedes building. Contributions are held to the same standard.

1. **Diagnose before proposing.** Open an issue describing the problem before opening a PR that solves it, unless the change is trivially small.
2. **Separate facts from assumptions.** If a claim is unverified, mark it as unverified. Do not present market or adoption claims as fact without a citation.
3. **Preserve history.** Do not overwrite prior stage outputs or memory entries. Extend, append, or add an addendum.
4. **No unresolved placeholders.** `TODO:` and `{{template}}` markers fail strict validation.
5. **ASCII by default.** Use plain hyphens, arrows (`->`), and straight quotes so output stays readable in every terminal.

---

## Development Setup

No build step and no dependencies beyond a shell. Clone the repo and run the validator.

```bash
./scripts/check-meta-agent-os.sh --strict
```

```powershell
./scripts/check-meta-agent-os.ps1 -Strict
```

Both scripts are kept in behavioural parity. **If you change one, change the other.** CI runs both on Windows and Ubuntu, and a divergence between them will fail the build.

JSON output is available for tooling:

```bash
./scripts/check-meta-agent-os.sh --strict --json
```

---

## Making a Change

1. Branch from `master`. Use a descriptive prefix: `fix/`, `feat/`, `docs/`, `chore/`.
2. Make the change. Keep the two validator scripts in sync.
3. Run strict validation locally, in both plain and JSON modes.
4. Update memory files if the change is material:
   - `meta-agent-os/05_memory/changelog.md` for what changed
   - `meta-agent-os/05_memory/decision_log.md` for why, if a decision was made
   - `meta-agent-os/05_memory/assumptions_log.md` for anything assumed rather than verified
5. Open a PR using the template. Fill in the validation section honestly — if a check failed, say so.

## Adding or Changing a Stage Schema

Schemas in `meta-agent-os/00_control/schemas/` drive strict validation. A numbered list item in a schema becomes a required section in that stage's output.

Adding a required section will fail validation for every existing output that lacks it. That is intentional. If you add one, either update the affected outputs in the same PR or add a schema-alignment addendum to each.

## Adding a Worked Example

Worked examples live in `docs/examples/`. A good one:

- Uses synthetic data only, never real client material
- Starts from a genuinely vague request
- Shows the diagnosis changing the shape of the answer
- Reaches a supervised, risk-reviewed plan rather than an agent swarm
- Names what was assumed and what would validate it

---

## Reporting Bugs and Requesting Features

Use the issue templates. For anything security-related, do not open a public issue — follow [`SECURITY.md`](SECURITY.md).

## Code of Conduct

Participation is governed by [`CODE_OF_CONDUCT.md`](CODE_OF_CONDUCT.md).

## Licensing

By contributing, you agree that your contributions are licensed under Apache 2.0, matching [`LICENSE`](LICENSE).
