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
| Validation | PowerShell strict validation passes |
| CI | GitHub workflow runs strict PowerShell and Bash checks |
| Examples | Public examples use synthetic data only |
| Claims | Market, adoption, pricing, and benchmark claims are cited, softened, or marked unverified |
| External actions | No deployment, publishing, credentials, or paid services are required |
| Memory | Project brain, decision log, assumptions log, and changelog are current |

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
- Stage outputs can pass structural validation while still needing human editorial review.

## Open Questions

- Should a tagged release require a second reviewer?
- Should JSON validation output be uploaded as a CI artifact later?
- Should public examples be limited to one flagship example or include a small catalog?

## Recommended Next Action

Run strict validation locally and in CI before tagging or announcing a release.

## Files Created Or Updated

- `docs/RELEASE_CHECKLIST.md`
