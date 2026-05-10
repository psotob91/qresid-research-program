Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before extension prerelease or public RC decision

# QRESID_EXTENSION_RELEASE_AUDIT.md

Date: 2026-05-10

Status source: root branch `dev-qresid-extension-integrated`; `qresid` commit `32641db`.

POST_CHANGE_SYNC_DONE: extension hardening reports, public help/examples and registry synchronized after validation.

## Executive Summary

Readiness decision: `PROMOTE_TO_EXTENSION_PRERELEASE_READY`.

The integrated extension branch satisfies the local extension prerelease gate. The latest count-extension pass additionally promotes NB2 `nbreg, dispersion(mean)` with no-offset, `offset()`, and `exposure()`, plus grouped-binomial `binreg, n()` aliases `or`, `rr`, and `rd`, to local extension prerelease readiness.

This remains an extension prerelease, not a public RC. Direct `[pweight=]` remains model-based diagnostic support and not `svy:` support. Public RC still requires a human release-policy decision for pweight claims.

## Evidence Reviewed

| evidence | status | latest artifact |
|---|---|---|
| qresid commit | PASS | `32641db docs: harden extension prerelease help and examples` |
| qresid ado unchanged | PASS | `git -C qresid diff -- qresid.ado` empty before commit |
| install/help smoke | PASS | `qresid/tests/logs/10_May_2026_144247_hardening_smoke.log` |
| examples smoke | PASS | `qresid/tests/logs/10_May_2026_144247_hardening_smoke.log` |
| Stata certification | PASS | `qresid/certification/logs/10_May_2026_144312_certify_phase1.log` |
| Gamma R check | PASS | `qresid/tests/logs/10_May_2026_144316_gamma_benchmark_r_check.csv` |
| Phase 1 R check | PASS | `qresid/tests/logs/10_May_2026_144317_phase1_benchmark_r_check.csv` |
| GLM/link R check | PASS | `qresid/tests/logs/10_May_2026_144317_glm_link_matrix_r_check.csv` |
| grouped binomial R check | PASS | `qresid/tests/logs/20260510_144354_grouped_binomial_benchmark_r.log` |
| NB R check | PASS | `qresid/tests/logs/20260510_144354_nb_benchmark_r.log` |
| fweight R check | PASS | `qresid/tests/logs/20260510_144354_fweight_benchmark_r.log` |
| pweight diagnostic | STATA_ONLY_DIAGNOSTIC | `qresid/tests/logs/20260510_144355_pweight_direct_benchmark_r.log` |

## Scope Audit

Claims aligned with evidence:

- Grouped binomial is limited to unweighted `glm, family(binomial trials)` and tested links.
- NB is limited to unweighted `nbreg, dispersion(mean)`.
- `fweight` is limited to Gaussian/Poisson.
- Direct `[pweight=]` is explicitly experimental, not `svy:`, and remains `STATA_ONLY_DIAGNOSTIC`.
- `qresid.pkg` remains minimal: `qresid.ado` and `qresid.sthlp` only.
- `qresid.sthlp` now includes PIT, CDF endpoint, Dunn-Smyth RQR formulas, and references.
- NB2 offset/exposure and grouped-binomial/binreg support statuses are synchronized across the support matrix, GLM/link report, unified extension matrix, and registry.

No public-package traces found:

- No prompts, agent traces, ChatGPT/Codex references, or reasoning traces were found in public package files after hardening.

## Recommendation

Promote the branch to a local extension prerelease checkpoint:

- `qresid/` tag: `v0.1.0-extension-prerelease.1`
- root tag: `qresid-v0.1.0-extension-prerelease.1`

Do not promote to public RC until a human release-policy decision resolves whether direct `[pweight=]` diagnostic support should be public, hidden, or split into a separate experimental branch.
