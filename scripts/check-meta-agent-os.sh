#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STRICT=0
JSON_OUTPUT=0

for arg in "$@"; do
  case "$arg" in
    --strict) STRICT=1 ;;
    --json) JSON_OUTPUT=1 ;;
    *) echo "Unknown argument: $arg" >&2; exit 2 ;;
  esac
done

# Resolve a Python 3 interpreter. Git Bash on Windows often exposes only the `py` launcher.
# Candidates are probed by execution, not by presence: the Windows Store aliases for
# `python`/`python3` exist on PATH but only print an install prompt when run.
PYTHON_BIN=()
probe='import sys; sys.exit(0 if sys.version_info[0] == 3 else 1)'
for candidate in "python3" "python" "py -3"; do
  # shellcheck disable=SC2086
  if $candidate -c "$probe" >/dev/null 2>&1; then
    # shellcheck disable=SC2206
    PYTHON_BIN=($candidate)
    break
  fi
done

if [ ${#PYTHON_BIN[@]} -eq 0 ]; then
  echo "Python 3 is required to run this check. Tried: python3, python, py -3." >&2
  exit 2
fi

"${PYTHON_BIN[@]}" - "$ROOT" "$STRICT" "$JSON_OUTPUT" <<'PY'
import datetime
import json
import re
import sys
from pathlib import Path

root = Path(sys.argv[1])
strict = sys.argv[2] == "1"
json_output = sys.argv[3] == "1"
errors = []


def repo_path(path: str) -> Path:
    return root / path.lstrip("/").replace("\\", "/")


def required(path: str, kind: str = "file") -> bool:
    target = repo_path(path)
    if not target.exists():
        errors.append(f"Missing required {kind}: {path}")
        return False
    return True


def read_json(path: str):
    target = repo_path(path)
    if not target.exists():
        errors.append(f"Missing JSON file: {path}")
        return None
    try:
        return json.loads(target.read_text(encoding="utf-8"))
    except Exception as exc:
        errors.append(f"Invalid JSON in {path}: {exc}")
        return None


def required_sections(schema_path: str):
    target = repo_path(schema_path)
    if not target.exists():
        return []
    sections = []
    for line in target.read_text(encoding="utf-8", errors="replace").splitlines():
        match = re.match(r"^\s*\d+\.\s+(.+?)\s*$", line)
        if match:
            sections.append(match.group(1))
    return sections


# Sections that must enumerate their content rather than gesture at it.
ENUMERATED_SECTIONS = {
    "assumptions",
    "risks",
    "open questions",
    "files created or updated",
}

# Minimum non-whitespace characters of body text under a required section.
MIN_SECTION_CHARS = 80

PLACEHOLDER_PATTERN = re.compile(
    r"\bTBD\b|\bTODO\b|\bFIXME\b|\bXXX\b|lorem ipsum|\{\{[^}]*\}\}|<placeholder",
    re.IGNORECASE,
)

HEADING_PATTERN = re.compile(r"(?m)^(#{1,6})\s+(.*?)\s*$")


def section_bodies(content: str, section: str):
    """Return every body block that sits under a heading matching `section`."""
    headings = [
        (match.start(), match.end(), len(match.group(1)), match.group(2))
        for match in HEADING_PATTERN.finditer(content)
    ]
    normalized = section.strip().lower()
    bodies = []
    for index, (_, end, level, title) in enumerate(headings):
        clean_title = re.sub(r"^\d+\.\s*", "", title).strip().lower()
        if clean_title != normalized:
            continue
        stop = len(content)
        for later_start, _, later_level, _ in headings[index + 1:]:
            if later_level <= level:
                stop = later_start
                break
        bodies.append(content[end:stop].strip())
    return bodies


def has_enumerated_item(body: str) -> bool:
    return bool(re.search(r"(?m)^\s*(?:[-*+]\s+\S|\d+\.\s+\S|\|)", body))


def check_stage_sections(stage_name: str, output_path: str, schema_path: str):
    target = repo_path(output_path)
    if not target.exists():
        return
    content = target.read_text(encoding="utf-8", errors="replace")
    for section in required_sections(schema_path):
        bodies = section_bodies(content, section)
        if not bodies:
            errors.append(f"Stage output '{stage_name}' missing required section from schema: {section}")
            continue

        # A section may legitimately appear more than once (for example, a schema
        # alignment addendum). Accept the stage if any occurrence carries substance.
        # Enumerated sections are judged on having entries; a one-line list is complete.
        # Prose sections are judged on length, since a single clause is not an analysis.
        if section.strip().lower() in ENUMERATED_SECTIONS:
            substantive = [b for b in bodies if has_enumerated_item(b)]
            if not substantive:
                errors.append(
                    f"Stage output '{stage_name}' section '{section}' must enumerate entries "
                    "as a list or table, not a single narrative sentence."
                )
                continue
        else:
            # A list or table is self-evidently content regardless of length. Only
            # pure prose has to clear the length bar.
            substantive = [
                b for b in bodies
                if has_enumerated_item(b) or len(re.sub(r"\s", "", b)) >= MIN_SECTION_CHARS
            ]
            if not substantive:
                errors.append(
                    f"Stage output '{stage_name}' section '{section}' has no substantive content "
                    f"(needs a list, a table, or at least {MIN_SECTION_CHARS} non-whitespace characters)."
                )
                continue

        for body in substantive:
            # Placeholder tokens inside code spans or fences are being discussed,
            # not left behind. Strip them before scanning.
            prose = re.sub(r"```.*?```", " ", body, flags=re.DOTALL)
            prose = re.sub(r"`[^`]*`", " ", prose)
            placeholder = PLACEHOLDER_PATTERN.search(prose)
            if placeholder:
                errors.append(
                    f"Stage output '{stage_name}' section '{section}' contains an unresolved "
                    f"placeholder: {placeholder.group(0)}"
                )
                break


def check_stage_metadata(stage_name: str, output_path: str, state_updated: str):
    """Completed outputs must carry their own provenance, and state must not lag them."""
    target = repo_path(output_path)
    if not target.exists():
        return
    content = target.read_text(encoding="utf-8", errors="replace")

    date_match = re.search(r"(?m)^\*\*Date:\*\*\s*(\d{4}-\d{2}-\d{2})\s*$", content)
    if not date_match:
        errors.append(
            f"Stage output '{stage_name}' is missing a '**Date:** YYYY-MM-DD' metadata line."
        )
    if not re.search(r"(?m)^\*\*Status:\*\*\s*\S", content):
        errors.append(f"Stage output '{stage_name}' is missing a '**Status:**' metadata line.")

    if date_match and state_updated and date_match.group(1) > state_updated:
        errors.append(
            f"Stage output '{stage_name}' is dated {date_match.group(1)} but STAGE_STATE.json "
            f"last_updated is {state_updated}. State is stale relative to its own output."
        )


required_files = [
    "README.md",
    "AGENTS.md",
    "CLAUDE.md",
    "CODEX_RUNBOOK.md",
    "META_AGENT_BOOTSTRAP.md",
    "INSTALL.md",
    "ROADMAP.md",
    "docs/PUBLIC_BOUNDARY.md",
    "docs/RELEASE_CHECKLIST.md",
    "docs/RUNTIME_TRACK.md",
    "docs/WHY.md",
    "docs/examples/WORKED_EXAMPLE_SUPPORT_TRIAGE.md",
    "docs/examples/WORKED_EXAMPLE_RESEARCH_ASSISTANT.md",
    "LICENSE",
    ".claude/commands/mao-status.md",
    ".claude/commands/mao-diagnose.md",
    ".claude/commands/mao-resume.md",
    ".claude/commands/mao-validate.md",
    ".claude/commands/mao-harden.md",
    ".claude/commands/mao-memory.md",
    ".claude/commands/mao-export-pack.md",
    "CONTRIBUTING.md",
    "SECURITY.md",
    "CODE_OF_CONDUCT.md",
    ".github/pull_request_template.md",
    ".github/workflows/meta-agent-os.yml",
    ".github/ISSUE_TEMPLATE/bug_report.yml",
    ".github/ISSUE_TEMPLATE/feature_request.yml",
    ".github/ISSUE_TEMPLATE/config.yml",
    "meta-agent-os/00_control/AGENT_MANIFEST.md",
    "meta-agent-os/00_control/OUTPUT_MANIFEST.json",
    "meta-agent-os/00_control/QUALITY_BAR.md",
    "meta-agent-os/00_control/RESUME_PROTOCOL.md",
    "meta-agent-os/00_control/RUN_META_AGENT_OS.md",
    "meta-agent-os/00_control/RUN_MODES.json",
    "meta-agent-os/00_control/STAGE_ADVANCEMENT_PROTOCOL.md",
    "meta-agent-os/00_control/STAGE_GATES.md",
    "meta-agent-os/00_control/STAGE_MANIFEST.json",
    "meta-agent-os/00_control/STAGE_STATE.json",
    "meta-agent-os/00_control/STAGE_STATE.md",
    "meta-agent-os/00_control/JSON_STATE_UPDATE_PROTOCOL.md",
    "meta-agent-os/00_control/validators/GLOBAL_STAGE_VALIDATOR.md",
    "meta-agent-os/00_control/safety/ANTI_AGENT_GATE.md",
    "meta-agent-os/00_control/safety/AGENT_SUITABILITY_SCORING.md",
    "meta-agent-os/00_control/safety/INFERENCE_RISK_PROFILES.md",
    "scripts/agent-suitability.py",
    "docs/examples/safety/EXAMPLE_ASSESSMENT.json",
    "meta-agent-os/00_control/economics/MODEL_PRICING.json",
    "meta-agent-os/00_control/economics/TOKEN_BUDGET_TEMPLATE.md",
    "meta-agent-os/00_control/economics/ROI_METHOD.md",
    "scripts/roi-calculator.py",
    "docs/examples/roi/EXAMPLE_WORKFLOW.json",
    "docs/examples/roi/EXAMPLE_PRICING.json",
    "meta-agent-os/05_memory/project_brain.md",
    "meta-agent-os/05_memory/decision_log.md",
    "meta-agent-os/05_memory/assumptions_log.md",
    "meta-agent-os/05_memory/changelog.md",
    "skills/meta-agent-os/SKILL.md",
    "skills/meta-agent-os/references/stage-lifecycle.md",
    "skills/meta-agent-os/references/output-standard.md",
]

required_dirs = [
    "meta-agent-os/00_control/codex",
    "meta-agent-os/00_control/schemas",
    "meta-agent-os/00_control/validators",
    "meta-agent-os/03_outputs/diagnosis",
    "meta-agent-os/03_outputs/research",
    "meta-agent-os/03_outputs/maps",
    "meta-agent-os/03_outputs/architecture",
    "meta-agent-os/03_outputs/costs",
    "meta-agent-os/03_outputs/risk",
    "meta-agent-os/03_outputs/build",
    "meta-agent-os/03_outputs/evals",
    "meta-agent-os/03_outputs/runtime",
    "meta-agent-os/05_memory",
    "skills/meta-agent-os",
    "skills/meta-agent-os/references",
    "docs/examples",
]

for item in required_files:
    required(item, "file")

for item in required_dirs:
    required(item, "directory")

stage_manifest = read_json("meta-agent-os/00_control/STAGE_MANIFEST.json")
stage_state = read_json("meta-agent-os/00_control/STAGE_STATE.json")
output_manifest = read_json("meta-agent-os/00_control/OUTPUT_MANIFEST.json")
run_modes = read_json("meta-agent-os/00_control/RUN_MODES.json")

if stage_manifest and stage_manifest.get("stages"):
    seen = set()
    for stage in stage_manifest["stages"]:
        name = stage.get("name")
        if not name:
            errors.append("STAGE_MANIFEST contains a stage without a name.")
        elif name in seen:
            errors.append(f"Duplicate stage in STAGE_MANIFEST: {name}")
        seen.add(name)

        for field in ("output", "schema", "validator"):
            value = stage.get(field)
            if not value:
                errors.append(f"Stage '{name}' is missing field '{field}' in STAGE_MANIFEST.")
                continue
            if field == "output":
                if not repo_path(value).parent.exists():
                    errors.append(f"Output parent directory does not exist for stage '{name}': {value}")
            else:
                required(value, field)

if output_manifest:
    for item in output_manifest.get("required_memory_files", []):
        required(item, "memory file")
    for item in output_manifest.get("required_output_directories", []):
        required(item, "output directory")

if stage_state and stage_manifest:
    known = [stage.get("name") for stage in stage_manifest.get("stages", [])]
    current = stage_state.get("current_stage")
    if stage_state.get("status") == "complete" and current == "Complete":
        pass
    elif current not in known:
        errors.append(f"STAGE_STATE current_stage is not in STAGE_MANIFEST: {current}")

    stage_status = stage_state.get("stage_status", {})
    for completed in stage_state.get("completed_stages", []):
        if completed not in known:
            errors.append(f"STAGE_STATE completed_stages contains unknown stage: {completed}")
            continue
        manifest_entry = next(stage for stage in stage_manifest["stages"] if stage.get("name") == completed)
        required(manifest_entry["output"], "completed stage output")
        if strict:
            check_stage_sections(completed, manifest_entry["output"], manifest_entry["schema"])
            check_stage_metadata(completed, manifest_entry["output"], stage_state.get("last_updated", ""))
        if stage_status.get(completed) != "complete":
            errors.append(f"STAGE_STATE completed stage '{completed}' is not marked complete in stage_status.")

    if stage_state.get("status") == "in_progress" and stage_status.get(current) != "in_progress":
        errors.append(
            f"STAGE_STATE current stage '{current}' has status '{stage_status.get(current)}' "
            "but top-level status is in_progress."
        )

    if strict:
        current_entry = next((stage for stage in stage_manifest["stages"] if stage.get("name") == current), None)
        if current_entry:
            check_stage_sections(current, current_entry["output"], current_entry["schema"])

if run_modes and not run_modes.get("modes"):
    errors.append("RUN_MODES.json does not define modes.")

for item in ("AGENTS.md", "CLAUDE.md", "CODEX_RUNBOOK.md"):
    target = repo_path(item)
    if not target.exists():
        continue
    content = target.read_text(encoding="utf-8", errors="replace")
    for marker in ("Meta Agent OS", "Oracle", "Guardian", "Evaluator"):
        if marker not in content:
            errors.append(f"{item} missing expected Meta Agent OS marker: {marker}")

skill = repo_path("skills/meta-agent-os/SKILL.md")
if skill.exists():
    content = skill.read_text(encoding="utf-8", errors="replace")
    for marker in ("name: meta-agent-os", "description:", "Diagnose before design", "STAGE_STATE.json", "STAGE_MANIFEST.json"):
        if marker not in content:
            errors.append(f"skills/meta-agent-os/SKILL.md missing expected marker: {marker}")

if strict:
    for item in (
        "README.md",
        "AGENTS.md",
        "CLAUDE.md",
        "CODEX_RUNBOOK.md",
        "INSTALL.md",
        "ROADMAP.md",
        "docs/PUBLIC_BOUNDARY.md",
        "docs/RELEASE_CHECKLIST.md",
        "docs/RUNTIME_TRACK.md",
    ):
        target = repo_path(item)
        if not target.exists():
            continue
        content = target.read_text(encoding="utf-8", errors="replace")
        # Code spans and fences name these tokens deliberately; only prose counts.
        prose = re.sub(r"```.*?```", " ", content, flags=re.DOTALL)
        prose = re.sub(r"`[^`]*`", " ", prose)
        if re.search(r"TODO:|{{[^}]+}}", prose):
            errors.append(f"Strict mode: unresolved placeholder in {item}")

# STAGE_STATE.json must stay in sync with its human-readable Markdown mirror.
state_md_path = repo_path("meta-agent-os/00_control/STAGE_STATE.md")
if stage_state and state_md_path.exists():
    state_md = state_md_path.read_text(encoding="utf-8", errors="replace").lower()
    current = stage_state.get("current_stage")
    if current and current.lower() not in state_md:
        errors.append(f"STAGE_STATE.md out of sync: current_stage '{current}' from JSON not found in Markdown mirror.")
    status_val = stage_state.get("status")
    if status_val and status_val.lower() not in state_md:
        errors.append(f"STAGE_STATE.md out of sync: status '{status_val}' from JSON not found in Markdown mirror.")
    for completed in stage_state.get("completed_stages", []):
        if completed.lower() not in state_md:
            errors.append(f"STAGE_STATE.md out of sync: completed stage '{completed}' from JSON not found in Markdown mirror.")

# Pricing registry integrity. Rates are inputs, not constants: an undated or
# unsourced rate produces a confident wrong cost, which is worse than no cost.
# Mirrors the checks in scripts/roi-calculator.py so the two cannot drift apart.
pricing = read_json("meta-agent-os/00_control/economics/MODEL_PRICING.json")
if pricing is not None:
    max_age = pricing.get("max_age_days")
    if not isinstance(max_age, int) or max_age <= 0:
        errors.append("MODEL_PRICING.json must set a positive integer 'max_age_days'.")
    if not isinstance(pricing.get("models"), list):
        errors.append("MODEL_PRICING.json must define a 'models' list (empty is valid).")
    else:
        today = datetime.date.today()
        seen_ids = set()
        for index, entry in enumerate(pricing["models"]):
            model_id = entry.get("id")
            if not model_id:
                errors.append(f"MODEL_PRICING.json entry {index} has no 'id'.")
                continue
            if model_id in seen_ids:
                errors.append(f"MODEL_PRICING.json has a duplicate model id: {model_id}")
            seen_ids.add(model_id)

            for field in ("input", "output"):
                if not isinstance(entry.get(field), (int, float)):
                    errors.append(
                        f"MODEL_PRICING.json entry '{model_id}' has a non-numeric '{field}' rate."
                    )
            if not entry.get("source"):
                errors.append(
                    f"MODEL_PRICING.json entry '{model_id}' has no 'source'. "
                    "An unsourced rate is a guess."
                )

            raw_date = entry.get("verified_on")
            try:
                verified = datetime.date.fromisoformat(str(raw_date))
            except (TypeError, ValueError):
                errors.append(
                    f"MODEL_PRICING.json entry '{model_id}' needs a 'verified_on' ISO date "
                    f"(YYYY-MM-DD), got: {raw_date!r}"
                )
                continue

            if isinstance(max_age, int) and max_age > 0:
                age = (today - verified).days
                if age < 0:
                    errors.append(
                        f"MODEL_PRICING.json entry '{model_id}' is dated in the future: {verified}."
                    )
                elif age > max_age:
                    errors.append(
                        f"MODEL_PRICING.json entry '{model_id}' was verified {age} days ago, "
                        f"exceeding max_age_days={max_age}. Re-verify against current published "
                        "pricing rather than raising the threshold."
                    )

# Relative Markdown links must resolve. Renames are the usual way docs rot.
if strict:
    skip_dirs = {".git", "node_modules"}
    link_pattern = re.compile(r"\[[^\]]*\]\(\s*(<[^>]*>|[^)\s]+)")
    for md_file in sorted(root.rglob("*.md")):
        if any(part in skip_dirs for part in md_file.relative_to(root).parts):
            continue
        rel_file = md_file.relative_to(root).as_posix()
        content = md_file.read_text(encoding="utf-8", errors="replace")
        for match in link_pattern.finditer(content):
            target_raw = match.group(1).strip()
            if target_raw.startswith("<") and target_raw.endswith(">"):
                target_raw = target_raw[1:-1]
            if not target_raw or target_raw.startswith(("http://", "https://", "mailto:", "#")):
                continue
            target_clean = target_raw.split("#", 1)[0].replace("%20", " ")
            if not target_clean:
                continue
            if target_clean.startswith("/"):
                resolved = repo_path(target_clean)
            else:
                resolved = (md_file.parent / target_clean).resolve()
            if not resolved.exists():
                errors.append(f"Broken relative link in {rel_file}: {target_raw}")

# README must not document meta-agent-os subdirectories that do not exist.
readme_path = repo_path("README.md")
if readme_path.exists():
    readme_content = readme_path.read_text(encoding="utf-8", errors="replace")
    for sub in sorted(set(re.findall(r"/(\d\d_[a-z_]+)", readme_content))):
        if not repo_path(f"meta-agent-os/{sub}").exists():
            errors.append(f"README documents meta-agent-os/{sub} but that directory does not exist.")

if errors:
    if json_output:
        print(json.dumps({
            "ok": False,
            "strict": strict,
            "error_count": len(errors),
            "errors": errors,
        }, indent=2))
    else:
        print("Meta Agent OS hardening check failed:")
        for error in errors:
            print(f" - {error}")
    raise SystemExit(1)

if json_output:
    print(json.dumps({
        "ok": True,
        "strict": strict,
        "error_count": 0,
        "errors": [],
    }, indent=2))
else:
    if strict:
        print("Meta Agent OS hardening check passed in strict mode.")
    else:
        print("Meta Agent OS hardening check passed.")
PY
