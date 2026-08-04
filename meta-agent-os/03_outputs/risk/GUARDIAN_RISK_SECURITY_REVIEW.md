# Guardian Risk And Security Review

**Stage:** Guardian  
**Date:** 2026-05-06  
**Project:** Meta Agent OS  
**Status:** Complete  
**Feeds into:** Builder, Evaluator

---

## Objective

Review the recommended Balanced architecture for risks before further Builder work on internal framework files, examples, validators, and public-facing docs.

## Inputs Used

- `meta-agent-os/03_outputs/architecture/ARCHITECT_SYSTEM_DESIGN.md`
- `meta-agent-os/03_outputs/costs/QS_COSTS_AND_OPTIONS.md`
- `meta-agent-os/03_outputs/maps/CARTOGRAPHER_WORKFLOW_MAP.md`
- `meta-agent-os/00_control/STAGE_GATES.md`
- `docs/REPO_HARDENING.md`
- `ROADMAP.md`

---

## 1. Executive Risk Summary

Guardian verdict: Approved with restrictions.

The Balanced plan is safe for prototype/public-framework polish because it modifies internal docs, examples, validators, and command wrappers only. The main risks are product confusion, overengineering, weak claims, and false confidence from shallow validation.

## 2. Data Sensitivity

Current repo data is low sensitivity. It is mostly public-framework Markdown and JSON control files.

Sensitive risk remains if future examples include:

- Client workflows
- Credentials
- Private business strategies
- Personal machine paths
- Internal commercial-pack content

Restriction: public examples must use synthetic or clearly non-sensitive scenarios.

## 3. Tool Permission Risks

Allowed:

- Read local files.
- Edit internal framework docs.
- Edit stage outputs.
- Run local validation scripts.

Restricted:

- Delete files.
- Install packages.
- Push to remote.
- Publish releases.
- Modify credentials.
- Edit unrelated application source.

## 4. Autonomy Risks

Risk: The full-run language may imply agents can continue too far without human review.

Mitigation:

- Preserve stage gates.
- Keep Guardian before Builder.
- Keep human approval for external and destructive actions.
- Prefer smallest suitable run mode.

## 5. Privacy Risks

Risk: Worked examples could accidentally include personal or client-specific content.

Mitigation:

- Use synthetic examples.
- Avoid names, emails, real client data, or private file paths.
- Add privacy reminders to examples if needed.

## 6. Security Risks

Risk: Future CLI or scripts could overreach.

Mitigation:

- Current scripts should remain validation-only.
- No network calls in hardening checks.
- No secret scanning claims unless actually implemented.

## 7. Financial Risks

No direct financial risk in current Balanced plan.

Warning: QS cost claims should remain approximate unless current model pricing is verified.

## 8. Legal / Compliance Risks

Risks:

- Commercial pack boundary is not yet formalized.
- Public claims about market stats may need citations.
- Apache 2.0 plus separate commercial vertical packs should be explained carefully.

Mitigation:

- Keep commercial packs as planned, separate-license items.
- Avoid unsupported market claims in main README until cited.

## 9. Hallucination Risks

Risks:

- Agents may invent missing repo facts.
- Stage outputs may sound complete while validation is shallow.
- Research claims may be treated as verified without citations.

Mitigation:

- Require Inputs Used.
- Separate facts and assumptions.
- Strengthen required-section validation.
- Mark external claims as needing verification.

## 10. Brand / Reputation Risks

Risks:

- "OS" may sound larger than the product.
- Overlap with Agent Ops OS may confuse users.
- Broken encoding artifacts reduce polish.

Mitigation:

- Add `docs/WHY.md`.
- State "not a runtime" clearly.
- Clean encoding artifacts.
- Keep Agent Ops OS comparison simple.

## 11. Operational Failure Modes

| Failure Mode | Impact | Mitigation |
|---|---|---|
| State JSON and Markdown drift | Agents resume incorrectly | Hardening check and state protocol |
| Missing validators | Stage advancement is fake | Required path check |
| Weak stage output | Later stages repeat work | Quality bar and section validation |
| Too much process | Users abandon framework | Smallest run mode guidance |
| Example too abstract | Users do not see value | Add concrete worked example |

## 12. Abuse Cases

- Using MAS to justify unnecessary agent systems.
- Treating approximate cost plans as procurement-grade estimates.
- Skipping Guardian and building risky automation.
- Publishing private workflows as examples.

## 13. Human Approval Gates

Require approval before:

- Publishing release or pushing remote changes.
- Creating commercial/private pack contents.
- Adding dependencies.
- Adding CLI package scaffolding.
- Using real client or personal data in examples.
- Changing license terms.

## 14. Monitoring Requirements

For current repo:

- Run `scripts/check-meta-agent-os.ps1 -Strict`.
- Review Git diffs before commit.
- Check README and examples for unsupported claims.
- Check state files after stage updates.

Future:

- Add CI checks for required stage sections.
- Add encoding artifact scan.

## 15. Kill Switch Requirements

For this repo, kill switch means stop the run and do not advance stage state if:

- Guardian verdict becomes "Not approved" or "Rejected".
- A required output is missing or weak.
- A risky external action is requested without approval.
- Validation fails.

## 16. Task Criticality And Model Floors

Added 2026-08-04 with the v0.6.1 Inference Safety Layer. Tiers and floors are defined in `meta-agent-os/00_control/safety/INFERENCE_RISK_PROFILES.md`.

Applied to operating this framework:

| Stage | Criticality | Reasoning | Model Floor |
|---|---|---|---|
| Oracle | C2 | A wrong diagnosis misdirects everything downstream, but it is reviewed before it drives a build | Mid-tier or better |
| Sophia | C2 | Unsupported claims that reach public materials cause reputational damage | Mid-tier or better |
| Cartographer | C3 | Mapping errors are visible and cheap to correct | Any model passing evals |
| Architect | C2 | Architecture choices are expensive to reverse after a build starts | Mid-tier or better |
| QS | C2 | Cost errors drive investment decisions | Mid-tier or better |
| Guardian | C1 | This stage is the safety control. A missed risk is exactly the failure nobody catches downstream | Highest available; no local substitution |
| Builder | C3 | Output is code and docs, reviewed before merge | Any model passing evals |
| Evaluator | C2 | Weak evals create false confidence, which is worse than no evals | Mid-tier or better |
| Orchestrator | C3 | Routing decisions are visible in state files | Any model passing evals |
| Librarian | C3 | Memory errors are correctable and version-controlled | Any model passing evals |

Guardian is the only C1 stage, and deliberately so. It is the stage whose failure is silent: a risk that is never surfaced produces no error message. Downgrading the model on this stage to save cost moves spend from the inference budget to the failure budget, where it is larger and harder to see.

## 17. Inference Risk Profile

| Risk | Applies Here | Control |
|---|---|---|
| Silent capability gap | Yes | A weaker model produces fluent, plausible stage outputs. Substance validation raises the floor but cannot detect confident wrongness. Human review remains required. |
| No vendor safety layer | Low | The framework produces documents, not actions. It holds no credentials and takes no external actions. |
| Unversioned local drift | Yes, if local models are used | Record the model and quantisation used for each stage output; re-run evals after any change. |
| False privacy assurance | Yes | Local inference protects repository content from a vendor, not from an unsecured host or logs. |
| Eval debt | Yes | This is the live gap. The framework defines eval requirements but has no automated evals of stage-output *quality*, only of structure and substance. |

**Escalation:** where a cheaper model runs a C3 stage, escalate to a mid-tier model on refusal, malformed output, or a validation failure that persists after one retry. Escalations must be recorded in the Orchestrator runtime log. An escalation rate that climbs is the earliest signal that the cheaper model was the wrong choice.

**Local versus hosted:** local models are permitted for C3 stages, permitted for C2 only with a parity eval on the real task, and not permitted for Guardian.

**Honest limitation:** the parity evals this profile requires do not yet exist in this repository. Until they do, local substitution for C2 stages is a hypothesis, not an approved option. This is recorded as eval debt rather than waived.

## 18. Guardian Verdict

Approved with restrictions.

Restrictions:

- Keep improvements internal to framework docs, examples, validators, and commands.
- Do not create CLI scaffolding yet.
- Do not add hosted/dashboard work.
- Use synthetic example data only.
- Clean unsupported claims before public marketing.

## 19. Files Created Or Updated

- `meta-agent-os/03_outputs/risk/GUARDIAN_RISK_SECURITY_REVIEW.md`
- `meta-agent-os/00_control/safety/INFERENCE_RISK_PROFILES.md`

## Assumptions

- The next Builder work will stay within internal framework files.
- No external publishing happens in this pass.

## Risks

- Users may still confuse MAS and Agent Ops OS unless positioning is simplified.

## Open Questions

- Should unsupported market stats in Sophia be revised or cited before public release?
- Should v0.5 be renamed from Commercial Refinement to Public Framework Polish?

## Recommended Next Action

Proceed to Builder under restrictions: add `docs/WHY.md`, one synthetic worked example, stronger validation, encoding cleanup, and memory updates.
