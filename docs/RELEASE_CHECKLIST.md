# Release Checklist

## Objective

Define the minimum checks before treating Meta Agent OS as ready for a public release, reuse in another repository, or a tagged internal baseline.

## Inputs Used

- `README.md`
- `ROADMAP.md`
- `docs/PUBLIC_BOUNDARY.md`
- `meta-agent-os/00_control/STAGE_STATE.json`
- `meta-agent-os/00_control/STAGE_MANIFEST.json`
- `scripts/check-meta-agent-os.ps1`
- `scripts/check-meta-agent-os.sh`

## Findings

The repo is ready for internal use when strict validation passes and all stage outputs exist. Public release needs a few extra checks because positioning, examples, unsupported claims, and install paths shape user trust.

## Required Checks

| Check | Required State |
|---|---|
| Product boundary | README and docs say Meta Agent OS is not a runtime engine |
| Stage state | `STAGE_STATE.json` and `STAGE_STATE.md` agree |
| Outputs | Every completed stage has the expected output file |
| Schemas | Completed stage outputs include required schema sections |
| Substance | Required sections carry real content; Assumptions, Risks, Open Questions, and file lists enumerate entries |
| Placeholders | No unresolved `TBD`, `TODO`, `FIXME`, or `{{template}}` markers in prose |
| Provenance | Every completed stage output carries `**Date:**` and `**Status:**` metadata |
| State freshness | `STAGE_STATE.json` `last_updated` is not older than any output it describes |
| Links | Every relative Markdown link resolves |
| Validation | Strict validation passes in both PowerShell and Bash, in plain and JSON modes |
| Validator parity | Both scripts report the same findings; a divergence is a defect, not a platform difference |
| CI | GitHub workflow runs strict PowerShell and Bash checks |
| Examples | Public examples use synthetic data only |
| Claims | Market, adoption, pricing, and benchmark claims are cited, softened, or marked unverified |
| External actions | No deployment, publishing, credentials, or paid services are required |
| Community files | `CONTRIBUTING.md`, `SECURITY.md`, `CODE_OF_CONDUCT.md`, and issue templates are present and current |
| Version | README, ROADMAP, `STAGE_STATE.json`, and `project_brain.md` all name the same version |
| Memory | Project brain, decision log, assumptions log, and changelog are current |
| Tag | The release is tagged, and the tag is pushed |

## Release Commands

PowerShell:

```powershell
./scripts/check-meta-agent-os.ps1 -Strict
./scripts/check-meta-agent-os.ps1 -Strict -Json
```

Bash:

```bash
./scripts/check-meta-agent-os.sh --strict
./scripts/check-meta-agent-os.sh --strict --json
```

## Assumptions

- Public release means publishing this repository as a framework/specification layer, not launching a hosted service.
- Runtime implementation remains separate unless a later decision deliberately changes the repo boundary.

## Risks

- Users may expect autonomous runtime behaviour because of the word "OS".
- Unsupported market claims may be copied into public materials without verification.
- Stage outputs can pass substance validation while still needing human editorial review. The checks raise the floor; they cannot prove an output is correct or insightful.
- Content floors are tunable heuristics. An author who wants to pad a section can still pass them, which is why editorial review stays on this list.

## Open Questions

- Should a tagged release require a second reviewer?
- Should JSON validation output be uploaded as a CI artifact later?
- Should public examples be limited to one flagship example or include a small catalog?

## Recommended Next Action

Run strict validation locally and in CI before tagging or announcing a release.

## Files Created Or Updated

- `docs/RELEASE_CHECKLIST.md`
