Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before GLM/link, benchmark, certification or release-scope decisions

# QRESID_GLM_LINK_MATRIX_AUDIT.md

Date: 2026-05-10

Status source: local Stata/R execution after GLM/link matrix reconciliation for inverse Gaussian support and canonical support/report row synchronization.

CANONICAL_SUPPORT_ROW_SYNC: GLM/link inventory now reads from `QRESID_SUPPORT_REPORT_CANONICAL_ROWS.md`; every canonical model/gate row must appear in the support matrix, unified matrix and GLM/link inventory.

## Executive Summary

Readiness impact: `EXTENSION_PRERELEASE_LOCAL_WITH_RECONCILED_GLM_LINK_MATRIX`

The previous GLM/link evidence report became stale after inverse Gaussian moved
from gated research to locally validated experimental support. This audit
reconciles the family-by-link matrix by adding inverse Gaussian links to the
executed Stata/R benchmark matrix while keeping expanded `fweight` evidence in
its dedicated benchmark report.

Implemented/reconciled support:

- individual Bernoulli after `glm, family(binomial)` where `e(m)==1`;
- individual Bernoulli after `binreg` where `e(m)==1`;
- inverse Gaussian after `glm, family(igaussian)` for `power -2`, `log`,
  `identity`, and `power -1`;
- no public API change.

## Matrix Executed

The active matrix covers 87 Stata/R check groups, each on three datasets:

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
| inverse Gaussian | `glm igaussian` `power -2`/log/identity/`power -1` | `EXPERIMENTAL_VALIDATED_LOCAL` |
| grouped binomial | validated in grouped-binomial benchmarks, not executed in this family-by-link matrix | `EXPERIMENTAL_VALIDATED_SEPARATE_BENCHMARK`; `READY_FOR_EXTENSION_PRERELEASE` in the support matrix for `glm, family(binomial trials)` and `binreg, n()` aliases `or`/`rr`/`rd`; `binreg hr` is `STATA_INTERNAL_VALIDATION`; grouped-binomial untested weights remain `GATED_VARIANT` |
| NB | validated in NB benchmarks for `nbreg, dispersion(mean)`, not executed in this family-by-link matrix | `EXPERIMENTAL_VALIDATED_SEPARATE_BENCHMARK`; `READY_FOR_EXTENSION_PRERELEASE` in the support matrix for NB2 with tested `offset()`/`exposure()`; `dispersion(constant)`, `gnbreg`, `glm nbinomial`, and untested variants remain `GATED_VARIANT` |
| weights | separate benchmark evidence | `EXPERIMENTAL_VALIDATED_SEPARATE_BENCHMARK` for tested direct `fweight`; `GATED_VARIANT` for unclaimed weight types/routes |
| Official truncated count | validated in separate truncated-count benchmarks, not executed in this family-by-link matrix | `READY_FOR_EXTENSION_PRERELEASE`; evidence is `SEPARATE_BENCHMARK` |
| Official censored count | validated in separate censored-count benchmarks, not executed in this family-by-link matrix | `READY_FOR_EXTENSION_PRERELEASE`; evidence is `SEPARATE_BENCHMARK` |
| Hurdle count Poisson/NB | pinned unweighted Hilbe-Hardin `hplogit`/`hnblogit` validated in separate hurdle-count benchmarks | `READY_FOR_EXTENSION_PRERELEASE`; evidence is `SEPARATE_BENCHMARK`; other hurdle variants remain `GATED_VARIANT` |
| Stata `churdle` Cragg bounded/continuous | separate continuous/bounded Cragg gate, not count-hurdle support | `GATED_MODEL_FAMILY`; row is `REPORT_SCOPE_ONLY` |
| quasi, Tweedie, mixed/GLMM/GSEM and external Hilbe-style count models | inventoried only | `FUTURE_PHASE`, `GATED_MODEL_FAMILY` or `NO_OFFICIAL_STATA_COMMAND` |

## Evidence

| artifact | status |
|---|---|
| `qresid/tests/benchmark_glm_link_matrix_stata.do` | created; Stata producer passed |
| `qresid/tests/benchmark_glm_link_matrix_r.R` | created; R checker passed |
| `qresid/certification/reports/qresid_glm_link_matrix.html` | generated HTML evidence report |
| latest Stata matrix log | `qresid/tests/logs/10_May_2026_160031_glm_link_matrix_stata.log`: `QRESID_GLM_LINK_MATRIX_STATA_STATUS PASS` |
| latest R matrix log | `qresid/tests/logs/10_May_2026_160031_glm_link_matrix_r.log`: `QRESID_GLM_LINK_MATRIX_R_STATUS PASS` |
| latest matrix rows | 87 family/link/command/dataset/offset groups |
| separate grouped-binomial R check | `qresid/tests/logs/10_May_2026_160036_grouped_binomial_benchmark_r.log`: `QRESID_GROUPED_BINOMIAL_R_STATUS PASS` |
| separate NB R check | `qresid/tests/logs/10_May_2026_160037_nb_benchmark_r.log`: `QRESID_NB_R_STATUS PASS` |
| separate fweight extended R check | `qresid/tests/logs/10_May_2026_160039_fweight_extended_benchmark_r.log`: `QRESID_FWEIGHT_EXTENDED_BENCHMARK_R_STATUS PASS` |
| latest grouped-binomial expansion check | `qresid/tests/logs/10_May_2026_173033_grouped_binomial_benchmark_stata.log` and matching R checker: `PASS` for GLM and `binreg, n()` aliases |
| latest NB offset/exposure check | `qresid/tests/logs/10_May_2026_173033_nb_benchmark_stata.log` and matching R checker: `PASS` for no offset, `offset()`, and `exposure()` |

## Scope Guardrails

- The matrix compares CDF endpoints, PIT `U`, and final residuals from Stata
  output against R distribution functions.
- Discrete residual comparisons use deterministic external uniforms.
- Offset and exposure are tested for count log-link models and rely on final
  `predict` values to avoid double-counting.
- Inverse Gaussian uses the same stable closed-form CDF already validated in
  `benchmark_igaussian_*`.
- Expanded direct `fweight` support is intentionally not folded into this
  family-by-link matrix; it is validated by `benchmark_fweight_extended_*` and
  summarized in the live support matrix.
- The HTML report is repository/certification evidence, not `qresid.pkg`
  install payload.
- The generated inventory separates `status` from `evidence_scope` and
  `evidence_artifact`, so `EXPERIMENTAL_VALIDATED_LOCAL` means evidence is in
  this report, while `EXPERIMENTAL_VALIDATED_SEPARATE_BENCHMARK` points to a
  named separate benchmark.

## Report Scope Harmonization

This report is not the single authority for package support. It is a
family-by-link evidence report. Routes validated in other active benchmarks are
shown as `EXPERIMENTAL_VALIDATED_SEPARATE_BENCHMARK`, while specific unclaimed
variants are shown as `GATED_VARIANT`. The live support matrix remains the quick
answer for "what can I use?".

The automatic consistency check `qresid/tests/check_support_report_consistency.R`
must pass whenever canonical rows, support matrix, unified matrix, GLM/link
report, glossary or registry status changes. It fails if a canonical model/gate
row is absent from any active HTML view, if the R PIT/RQR column is missing, if
the obsolete `hurdle_truncated_censored_count` aggregate returns, or if validated
separate-benchmark routes regress to an absolute `GATED_FUTURE` status.

## Remaining Gaps

| gap | status | action |
|---|---|---|
| weighted routes beyond tested direct `fweight` | `GATED_FUTURE` | keep in weights-specific benchmark/research reports |
| R-side refitting equivalence by every link | `SHOULD_REVIEW_BEFORE_PUBLIC_RC` | current matrix validates qresid CDF/PIT/RQR from Stata fitted means; coefficient-level R refits can be added before public RC if desired |
| broader stress testing | `CAN_DEFER` | post-prerelease hardening |

## Decision

Decision: `ADVANCE_TO_NEXT_STAGE`

The active Phase 1 safe matrix is sufficient for local prerelease readiness.
The reconciled extension matrix is sufficient for local extension prerelease
readiness. Do not block on unclaimed weighted routes or Phase 2 families.

## Post-Change Sync

POST_CHANGE_SYNC_DONE
SUPPORT_MATRIX_SYNC_DONE
