Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before extension prerelease or public RC decision

# QRESID_EXTENSION_RELEASE_AUDIT.md

Date: 2026-05-10

Status source: root `edd1de5` / `qresid` `b686ad9`, branch `dev-qresid-extension-integrated`.

POST_CHANGE_SYNC_DONE: active release-audit reports and registry updated.

## Executive Summary

Readiness decision: `ITERATE_EXTENSION_HARDENING`.

The integrated extension branch is valid as an experimental checkpoint. Local Stata tests, install/help smoke, certification, R benchmark checks, and pweight diagnostic checks passed. It should not yet be promoted to extension prerelease because public help/README claims include experimental weight routes but `.sthlp` does not yet include executable examples for `fweight` and direct `[pweight=]`.

This is not a blocker for the frozen experimental tag. It is a prerelease-promotion blocker under `STATA_PACKAGE_STYLE_RULES.md`, which requires every declared supported model/path to have executable examples and no claims beyond test evidence.

## Evidence Reviewed

| evidence | status | latest artifact |
|---|---|---|
| git root clean | PASS | `dev-qresid-extension-integrated` |
| git subrepo clean | PASS | `dev-qresid-extension-integrated` |
| root tag | PASS | `qresid-extension-integrated-freeze.1` |
| qresid tag | PASS | `v0.1.0-extension.1` |
| install/help smoke | PASS | `qresid/tests/logs/10_May_2026_142416_hardening_smoke.log` |
| examples smoke | PASS | `qresid/tests/logs/10_May_2026_142416_hardening_smoke.log` |
| Stata test runner | PASS | `qresid/tests/logs/10_May_2026_142411_run_all_tests.log` |
| Stata certification | PASS | `qresid/certification/logs/10_May_2026_142411_certify_phase1.log` |
| Gamma R check | PASS | `qresid/tests/logs/10_May_2026_142416_gamma_benchmark_r_check.csv` |
| Phase 1 R check | PASS | `qresid/tests/logs/10_May_2026_142416_phase1_benchmark_r_check.csv` |
| GLM/link R check | PASS | `qresid/tests/logs/10_May_2026_142417_glm_link_matrix_r_check.csv` |
| grouped binomial R check | PASS | `qresid/tests/logs/20260510_142437_grouped_binomial_benchmark_r.log` |
| NB R check | PASS | `qresid/tests/logs/20260510_142438_nb_benchmark_r.log` |
| fweight R check | PASS | `qresid/tests/logs/20260510_142438_fweight_benchmark_r.log` |
| pweight diagnostic | PASS_DIAGNOSTIC | `qresid/tests/logs/20260510_142438_pweight_direct_benchmark_r.log` |

## Scope Audit

Claims aligned with evidence:

- Grouped binomial is limited to unweighted `glm, family(binomial trials)` and tested links.
- NB is limited to unweighted `nbreg, dispersion(mean)`.
- `fweight` is limited to Gaussian/Poisson.
- Direct `[pweight=]` is explicitly experimental, not `svy:`, and `STATA_ONLY_DIAGNOSTIC`.
- `qresid.pkg` remains minimal: `qresid.ado` and `qresid.sthlp` only.

Promotion blockers:

- `.sthlp` declares experimental `fweight` and direct `[pweight=]` support but lacks corresponding executable help examples.
- `qresid.pkg` / `stata.toc` still say "tested Phase 1 families"; acceptable for experimental freeze, but should be reviewed before an extension prerelease label.

No public-package traces found:

- No prompts, agent traces, ChatGPT/Codex references, or reasoning traces were found in `qresid.ado`, `.sthlp`, README, changelog, pkg, or toc.

## Recommendation

Keep the current frozen branch as a valid experimental checkpoint. Do one focused extension hardening iteration before promotion:

1. Add `.sthlp` examples for direct `fweight` Gaussian/Poisson and direct `[pweight=]` Gaussian/Poisson/Bernoulli.
2. Add matching `examples/*.do` scripts or update existing examples runner if the package policy requires repo examples for those routes.
3. Review `qresid.pkg` and `stata.toc` wording for extension-prerelease accuracy.
4. Re-run install/help/examples smoke, certification, and R checkers.

