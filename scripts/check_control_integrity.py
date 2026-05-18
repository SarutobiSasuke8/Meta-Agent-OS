#!/usr/bin/env python3
"""Read-only control-layer integrity check for the Meta Agent OS.

Built under Guardian verdict "Approved with restrictions" (Variant B).
This script is strictly READ-ONLY: it never writes, deletes, mutates,
makes network calls, or reads secrets. It exits non-zero on any failure
so CI can gate a release.

Checks:
  1. Drift  - root meta-agent-os/00_control/{schemas,validators} must be
              byte-identical to the v0.4 release snapshot under versions/.
  2. Manifest- every schema/validator path in STAGE_MANIFEST.json must
              resolve from the repository root tree.
  3. State   - STAGE_STATE.json must be well-formed and internally consistent.

Usage: python3 scripts/check_control_integrity.py
Exit:  0 = all checks pass, 1 = one or more checks failed.
"""

from __future__ import annotations

import filecmp
import json
import os
import sys

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ROOT_CONTROL = os.path.join(REPO_ROOT, "meta-agent-os", "00_control")
SNAPSHOT_CONTROL = os.path.join(
    REPO_ROOT,
    "versions",
    "v0.4-reliability-layer",
    "meta-agent-os",
    "00_control",
)

VALID_STAGE_STATUSES = {"not_started", "in_progress", "complete"}
VALID_RUN_STATUSES = {"in_progress", "awaiting_human_decision", "complete", "blocked"}

failures: list[str] = []


def fail(msg: str) -> None:
    failures.append(msg)
    print(f"FAIL: {msg}")


def ok(msg: str) -> None:
    print(f"ok:   {msg}")


def check_dir_identical(name: str) -> None:
    root_dir = os.path.join(ROOT_CONTROL, name)
    snap_dir = os.path.join(SNAPSHOT_CONTROL, name)
    if not os.path.isdir(root_dir):
        fail(f"root {name}/ is missing at {root_dir}")
        return
    if not os.path.isdir(snap_dir):
        fail(f"v0.4 snapshot {name}/ is missing at {snap_dir}")
        return
    cmp = filecmp.dircmp(snap_dir, root_dir)
    if cmp.left_only:
        fail(f"{name}/ present in v0.4 snapshot but missing at root: {sorted(cmp.left_only)}")
    if cmp.right_only:
        fail(f"{name}/ present at root but not in v0.4 snapshot: {sorted(cmp.right_only)}")
    mismatch = []
    common = cmp.common_files
    match, mism, errors = filecmp.cmpfiles(snap_dir, root_dir, common, shallow=False)
    mismatch.extend(mism)
    mismatch.extend(errors)
    if mismatch:
        fail(f"{name}/ drift - files differ from v0.4 snapshot: {sorted(mismatch)}")
    if not (cmp.left_only or cmp.right_only or mismatch):
        ok(f"{name}/ is byte-identical to the v0.4 snapshot ({len(common)} files)")


def check_manifest_paths() -> None:
    manifest_path = os.path.join(ROOT_CONTROL, "STAGE_MANIFEST.json")
    try:
        manifest = json.load(open(manifest_path, encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        fail(f"cannot read/parse STAGE_MANIFEST.json: {exc}")
        return
    missing = []
    checked = 0
    for stage in manifest.get("stages", []):
        for key in ("schema", "validator"):
            rel = str(stage.get(key, "")).lstrip("/")
            if not rel:
                continue
            checked += 1
            if not os.path.isfile(os.path.join(REPO_ROOT, rel)):
                missing.append(f"{stage.get('name')}:{key} -> {stage.get(key)}")
    if missing:
        fail(f"STAGE_MANIFEST.json paths do not resolve from root: {missing}")
    else:
        ok(f"all {checked} STAGE_MANIFEST.json schema/validator paths resolve from root")


def check_stage_state() -> None:
    state_path = os.path.join(ROOT_CONTROL, "STAGE_STATE.json")
    try:
        state = json.load(open(state_path, encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        fail(f"cannot read/parse STAGE_STATE.json: {exc}")
        return
    required = {
        "current_stage",
        "status",
        "completed_stages",
        "next_stage",
        "blocked",
        "stage_status",
    }
    missing_keys = sorted(required - set(state))
    if missing_keys:
        fail(f"STAGE_STATE.json missing required keys: {missing_keys}")
        return
    if state["status"] not in VALID_RUN_STATUSES:
        fail(f"STAGE_STATE.json unknown status: {state['status']!r}")
    bad = {
        s: v for s, v in state["stage_status"].items() if v not in VALID_STAGE_STATUSES
    }
    if bad:
        fail(f"STAGE_STATE.json invalid stage_status values: {bad}")
    for stage in state["completed_stages"]:
        if state["stage_status"].get(stage) != "complete":
            fail(
                f"STAGE_STATE.json inconsistency: '{stage}' in completed_stages "
                f"but stage_status is {state['stage_status'].get(stage)!r}"
            )
    if not failures:
        ok("STAGE_STATE.json is well-formed and internally consistent")


def main() -> int:
    print("Meta Agent OS - control-layer integrity check (read-only)\n")
    check_dir_identical("schemas")
    check_dir_identical("validators")
    check_manifest_paths()
    check_stage_state()
    print()
    if failures:
        print(f"RESULT: {len(failures)} check(s) FAILED")
        return 1
    print("RESULT: all checks passed")
    return 0


if __name__ == "__main__":
    sys.exit(main())
