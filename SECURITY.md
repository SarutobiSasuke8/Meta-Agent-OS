# Security Policy

## Scope

Meta Agent OS is a Markdown-based methodology and specification layer. It does not execute agents, hold credentials, make network calls, or process user data at runtime. The realistic security surface is therefore narrow, but it is not empty.

In scope:

- The validation scripts in `scripts/` — these execute on developer machines and in CI
- The GitHub Actions workflow in `.github/workflows/`
- Guidance in control files, schemas, or docs that would lead an operator to weaken a safety gate, grant excessive permissions, or take an unapproved external action
- Any instruction in this repository that could be used to prompt-inject an agent reading it

Out of scope:

- Vulnerabilities in agent tools that consume this framework (Claude Code, Codex, Cursor, and similar). Report those to their vendors.
- The behaviour of any runtime built against this specification. See [`docs/RUNTIME_TRACK.md`](docs/RUNTIME_TRACK.md).
- Theoretical risks that require an operator to ignore an explicit approval gate.

## Supported Versions

| Version | Supported |
|---|---|
| v0.6.1 | Yes |
| v0.6 | Security fixes only |
| v0.5 and earlier | No |

Earlier versions are preserved as git tags for reference, not for use.

## Reporting a Vulnerability

**Do not open a public issue.**

Use GitHub's private vulnerability reporting: go to the **Security** tab of this repository and select **Report a vulnerability**. If that is unavailable to you, contact the maintainer through the email on the GitHub profile of [@SarutobiSasuke8](https://github.com/SarutobiSasuke8).

Include:

- What the issue is and where it lives (file and line where possible)
- How to reproduce it
- What an attacker gains
- Any suggested fix

## What To Expect

| Stage | Target |
|---|---|
| Acknowledgement | Within 5 working days |
| Initial assessment | Within 10 working days |
| Fix or documented mitigation | Depends on severity; you will be kept informed |

This is a single-maintainer open source project without a paid security team. Targets are good-faith commitments, not contractual SLAs.

## Disclosure

Please give a reasonable window to ship a fix before public disclosure. Reporters will be credited in the changelog unless they ask not to be.

## Safety Posture

The framework's own safety model is the action-level table in [`CLAUDE.md`](CLAUDE.md) and the gates in `meta-agent-os/00_control/STAGE_GATES.md`. A contribution that removes, weakens, or routes around an approval gate is treated as a security issue, not a feature request.
