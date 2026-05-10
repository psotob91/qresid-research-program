Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before extension implementation, benchmark or support-status decisions

# QRESID_MATH_SOFTWARE_EVIDENCE_MATRIX.md

Date: 2026-05-10

POST_CHANGE_SYNC_DONE: math/software evidence matrix created for NB ML, truncated count, censored count and simulated PIT scope.
SUPPORT_MATRIX_SYNC_DONE: support matrix, unified extension matrix, glossary and registry were reconciled with this evidence layer.

## Purpose

This matrix records whether a candidate route has mathematical CDF/PIT support,
Stata extraction support, R estimator support, RQR/PIT tooling, paper/code
evidence, and enough benchmark evidence for local extension prerelease.

It separates three different ideas:

- an estimator may exist in Stata;
- a comparable estimator or CDF replay route may exist in R;
- an analytic RQR/PIT target may be closed for `qresid`.

## Evidence Matrix

| route | math_reference | cdf_formula_status | estimation_R_package_function | pit_rqr_R_package_function | paper_code_or_supplement | benchmark_type | simulation_benchmark_possible | blocks_prerelease |
|---|---|---|---|---|---|---|---|---|
| `glm, family(nbinomial ml)` | NB2 CDF theory; Stata GLM uses internal NB ML fit | `NO_RELIABLE_PARAMETER_EXTRACTION` because exact estimated alpha is not exposed in `e()` | `MASS::glm.nb`; `MASS::negative.binomial(theta)` only after theta is known | `statmod::qresiduals` for compatible NB GLM objects; manual `pnbinom` replay if theta is known | no package code copied; local Stata `glm.ado` shows alpha is only retained internally and rounded in `e(varfuncf)` | `STATA_INTERNAL_VALIDATION` for gate; no support claim | `DHARMA_SIMULATION_ONLY` possible as sanity check, not gold standard | no, because route remains gated and alternatives exist |
| `tpoisson`; `ztp` | Truncated discrete distribution: conditional CDF over observed support | `ANALYTIC_CDF_CLOSED` for lower truncation and tested constant upper truncation | `VGAM::pospoisson` candidate; base R `ppois` CDF replay used | manual PIT/RQR via `ppois`; `VGAM` has residual tooling but qresid endpoint replay is authority here | no supplementary code required | `R_CDF_REPLAY` with official Stata extraction | possible, but not needed for analytic support | no; now ready for extension prerelease |
| `tnbreg`; `ztnb` | Truncated NB CDF with Stata NB mean-dispersion extraction | `ANALYTIC_CDF_CLOSED` for lower truncation | `VGAM::posnegbinomial` candidate; base R `pnbinom` CDF replay used | manual PIT/RQR via `pnbinom` | no supplementary code required | `R_CDF_REPLAY` with official Stata extraction | possible, but not needed for analytic support | no; now ready for extension prerelease |
| `cpoisson` | Censored discrete PIT interval: left, right and uncensored intervals | `ANALYTIC_CDF_CLOSED` for tested left, right and two-sided censoring | `VGAM::cens.poisson` candidate; base R `ppois` CDF replay used | manual interval PIT/RQR via `ppois` | no supplementary code required | `STATA_INTERNAL_VALIDATION` plus `R_CDF_REPLAY` | possible, but not needed for analytic support | no; now ready for extension prerelease |
| DHARMa/glmmTMB sanity | Simulated PIT residuals for fitted count models | `DHARMA_SIMULATION_ONLY` | `glmmTMB` installed; DHARMa not installed in this environment | DHARMa is simulation-based residual tooling when available | no supplementary code copied | `SIMULATION_SANITY_CHECK` only | yes | no; not used for analytic claims |

## Interpretation

- `glm, family(nbinomial ml)` remains a controlled-error route. The user should
  use `nbreg` or fixed-parameter `glm, family(nbinomial #)` when `qresid`
  residuals are needed.
- Truncated and censored official count routes are now analytic CDF/PIT routes
  with local extension-prerelease evidence.
- DHARMa/glmmTMB can help future simulation sanity checks, but cannot replace
  exact CDF endpoint validation for this package.
