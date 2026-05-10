Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before GLM/link, benchmark, certification or release-scope decisions

# QRESID_GLM_LINK_MATRIX_AUDIT.md

Date: 2026-05-10

Status source: local Stata/R execution after GLM/link matrix hardening.

## Executive Summary

Readiness impact: `PRERELEASE_READY_LOCAL_WITH_GLM_LINK_MATRIX`

The previous Phase 1 benchmark coverage was not exhaustive across Stata
estimation forms, GLM links, or offset/exposure count models. This audit adds a
Phase 1 safe GLM/link matrix while keeping NB, weights, grouped binomial and
Phase 2 families gated.

Implemented support expansion:

- individual Bernoulli after `glm, family(binomial)` where `e(m)==1`;
- individual Bernoulli after `binreg` where `e(m)==1`;
- no public API change.

## Matrix Executed

The active matrix covers 75 Stata/R check groups, each on three datasets:

- `synthetic`;
- `real_like`;
- `adversarial`.

Families and commands covered:

| family | commands/links covered | status |
|---|---|---|
| Gaussian | `regress`; `glm gaussian` with identity, log, inverse/reciprocal | `SUPPORTED_TESTED` |
| Poisson | `poisson`; `glm poisson` with log, identity, sqrt; log-link offset/exposure | `SUPPORTED_TESTED` |
| Bernoulli individual | `logit`, `logistic`, `glm binomial` logit/probit/cloglog/log/identity, `binreg` logit/log/identity | `SUPPORTED_TESTED` |
| Gamma | `glm gamma` log/identity/inverse | `SUPPORTED_TESTED` |
| grouped binomial | inventoried only | `GATED_FUTURE` |
| NB | inventoried only | `GATED_FUTURE` |
| weights | inventoried only | `GATED_FUTURE` |
| inverse Gaussian, quasi, ZIP/ZINB, hurdle, truncados, mixed/GLMM/GSEM | inventoried only | `DEFERRED_PHASE2` or `EVIDENCIA_PENDIENTE` |

## Evidence

| artifact | status |
|---|---|
| `qresid/tests/benchmark_glm_link_matrix_stata.do` | created; Stata producer passed |
| `qresid/tests/benchmark_glm_link_matrix_r.R` | created; R checker passed |
| `qresid/certification/reports/qresid_glm_link_matrix.html` | generated HTML evidence report |
| latest Stata matrix log | `qresid/tests/logs/10_May_2026_122110_glm_link_matrix_stata.log`: `QRESID_GLM_LINK_MATRIX_STATA_STATUS PASS` |
| latest R matrix log | `qresid/tests/logs/10_May_2026_122110_glm_link_matrix_r.log`: `QRESID_GLM_LINK_MATRIX_R_STATUS PASS` |

## Scope Guardrails

- The matrix compares CDF endpoints, PIT `U`, and final residuals from Stata
  output against R distribution functions.
- Discrete residual comparisons use deterministic external uniforms.
- Offset and exposure are tested for count log-link models and rely on final
  `predict` values to avoid double-counting.
- The HTML report is repository/certification evidence, not `qresid.pkg`
  install payload.

## Remaining Gaps

| gap | status | action |
|---|---|---|
| grouped binomial trials | `GATED_FUTURE` | validate trials extraction and grouped CDF before support |
| NB | `GATED_FUTURE` | resolve NB1/NB2 and `alpha/theta/k` mapping |
| weights | `GATED_FUTURE` | resolve family x weight-type semantics |
| R-side refitting equivalence by every link | `SHOULD_REVIEW_BEFORE_PUBLIC_RC` | current matrix validates qresid CDF/PIT/RQR from Stata fitted means; coefficient-level R refits can be added before public RC if desired |
| broader stress testing | `CAN_DEFER` | post-prerelease hardening |

## Decision

Decision: `ADVANCE_TO_NEXT_STAGE`

The active Phase 1 safe matrix is sufficient for local prerelease readiness.
Do not block on NB, weights, grouped binomial or Phase 2 families.

## Post-Change Sync

POST_CHANGE_SYNC_DONE
