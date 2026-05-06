#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STRICT=0

for arg in "$@"; do
  case "$arg" in
    --strict) STRICT=1 ;;
    *) echo "Unknown argument: $arg" >&2; exit 2 ;;
  esac
done

python3 - "$ROOT" "$STRICT" <<'PY'
import json
import re
import sys
from pathlib import Path

root = Path(sys.argv[1])
strict = sys.argv[2] == "1"
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


def check_stage_sections(stage_name: str, output_path: str, schema_path: str):
    target = repo_path(output_path)
    if not target.exists():
        return
    content = target.read_text(encoding="utf-8", errors="replace")
    for section in required_sections(schema_path):
        pattern = r"(?m)^#{1,4}\s+(?:\d+\.\s+)?" + re.escape(section) + r"(\s|$)"
        if not re.search(pattern, content):
            errors.append(f"Stage output '{stage_name}' missing required section from schema: {section}")


required_files = [
    "README.md",
    "AGENTS.md",
    "CLAUDE.md",
    "CODEX_RUNBOOK.md",
    "META_AGENT_BOOTSTRAP.md",
    "INSTALL.md",
    "ROADMAP.md",
    "LICENSE",
    ".claude/commands/mao-status.md",
    ".claude/commands/mao-diagnose.md",
    ".claude/commands/mao-resume.md",
    ".claude/commands/mao-validate.md",
    ".claude/commands/mao-harden.md",
    ".claude/commands/mao-memory.md",
    ".claude/commands/mao-export-pack.md",
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
    for item in ("README.md", "AGENTS.md", "CLAUDE.md", "CODEX_RUNBOOK.md", "INSTALL.md", "ROADMAP.md"):
        target = repo_path(item)
        if not target.exists():
            continue
        content = target.read_text(encoding="utf-8", errors="replace")
        if re.search(r"TODO:|{{[^}]+}}", content):
            errors.append(f"Strict mode: unresolved placeholder in {item}")

if errors:
    print("Meta Agent OS hardening check failed:")
    for error in errors:
        print(f" - {error}")
    raise SystemExit(1)

if strict:
    print("Meta Agent OS hardening check passed in strict mode.")
else:
    print("Meta Agent OS hardening check passed.")
PY
