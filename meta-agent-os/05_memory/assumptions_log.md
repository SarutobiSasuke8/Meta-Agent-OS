# assumptions_log.md

**Last updated:** 2026-05-18

---

| # | Assumption | Confidence | Stage | Validated? |
|---|---|---|---|---|
| A1 | The user wants to ship this as a usable product or consulting tool | High | Oracle | No |
| A2 | The Cryptic Gaming Guild is a likely early deployment target | Medium | Oracle | No |
| A3 | v0.3 content was merged into v0.4 rather than lost | Medium | Oracle | No |
| A4 | Sibling repos (ai-agent-toolkit, openai-agents-python, prompt-library) are candidate deployment targets | Medium | Oracle | No |
| A5 | The framework should be published to GitHub as an open or semi-open repo | Medium | Oracle | No |
| A6 | No sensitive data is present in this repo | High | Oracle | Yes — manual scan confirmed |
| A7 | The user wants the v0.4 to v0.6.1 migration changes recorded before implementation | Medium | Librarian | Partially - migration note created |
| A8 | "Public release" means a GitHub-distributed Apache-2.0 framework; a docs site is optional and out of v0.4 scope | Medium | Cartographer | No |
| A9 | The 10-persona set is frozen for v0.4 — no new agents are needed to ship | High | Cartographer | No |
| A10 | The root `meta-agent-os/00_control/` folder should be the adopter's source of truth, not `versions/` | High | Cartographer | No |
| A11 | Mirroring schemas/validators to root satisfies STAGE_MANIFEST.json without manifest edits (paths already expect root) | Medium | Architect | **Yes — Builder: integrity script confirms 20/20 paths resolve, no manifest edit** |
| A12 | A single read-only CI drift/lint script is acceptable v0.4 (Level 2) scope | Medium | Architect | No — Guardian to confirm |
| A13 | Public-repo CI free tier (GitHub Actions) is available → operating cost ≈ $0 | Medium | QS | No — validate at Builder |
| A14 | D8 holds; PD2 treated as closed for budget purposes (no v0.5–v0.6.1 cost in v0.4) | Medium | QS | No — human to formally confirm |
| A15 | CI drift script will be authored read-only, secret-free, network-free (else escalates to Level 3) | Medium | Guardian | **Yes — Builder: script is stdlib-only read-only; CI is contents:read, no secrets, checkout SHA-pinned** |
