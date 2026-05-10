Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before NB variant, ZIP/ZINB, count-model support or extension-prerelease decisions

# QRESID_NB_ZEROINFLATED_EXTENSION_AUDIT.md

Date: 2026-05-10

POST_CHANGE_SYNC_DONE: active support reports, help/README/changelog, certification, and registry were reconciled after NB variant and zero-inflated benchmark implementation.
SUPPORT_MATRIX_SYNC_DONE: support matrix, unified extension matrix, GLM/link scoped inventory, glossary and consistency checker were updated or reviewed.

## Decision

Decision: `NB_ZEROINFLATED_EXTENSION_READY_FOR_EXTENSION_PRERELEASE`

The following routes are ready for local extension prerelease:

- `nbreg, dispersion(constant)` using row-specific `theta_i = mu_i/delta` and `p = 1/(1+delta)`.
- `gnbreg` using `predict, alpha`, row-specific `theta_i = 1/alpha_i`, and `p_i = theta_i/(theta_i+mu_i)`.
- fixed-parameter `glm, family(nbinomial #)` using the fixed variance parameter from `e(varfuncf)`.
- unweighted `zip` and `zinb`, including count-component `offset()` and `exposure()` handling.

Still gated:

- `glm, family(nbinomial ml)` because robust postestimation extraction of the estimated NB parameter is not closed.
- NB weights beyond already tested direct `fweight` routes.
- ZIP/ZINB weights and survey routes.
- Hurdle, truncated, censored, correlated, panel, multilevel, finite-mixture and mixed count models.

## Evidence

| route | validation_type | evidence |
|---|---|---|
| `nbreg, dispersion(constant)` | `STATA_INTERNAL_VALIDATION` + `R_CDF_REPLAY` | `benchmark_nb_variants_stata.do` and `benchmark_nb_variants_r.R` pass on three datasets. |
| `gnbreg` | `STATA_INTERNAL_VALIDATION` + `R_CDF_REPLAY` | Observation-specific `alpha_i` endpoints and qres pass on three datasets. |
| `glm, family(nbinomial #)` | `R_EXACT_BENCHMARK` for fixed theta CDF layers | Fixed alpha/theta endpoints and qres pass on three datasets. |
| `glm, family(nbinomial ml)` | `GATED_VARIANT` | Estimator runs, but `qresid` rejects it with controlled `rc=198` until parameter extraction is closed. |
| `zip` | `STATA_INTERNAL_VALIDATION` + `R_CDF_REPLAY` | Mixture endpoints and qres pass for no offset, `offset()`, and `exposure()`. |
| `zinb` | `STATA_INTERNAL_VALIDATION` + `R_CDF_REPLAY` | Mixture NB endpoints and qres pass for no offset, `offset()`, and `exposure()`. |

## Scope Guardrails

- `qresid` remains a postestimation residual tool, not an estimator.
- Public RC remains separate from local extension prerelease.
- Missing count models do not invalidate the package if not claimed.
- No correlated count model support was added.
- No external ado code was copied.

