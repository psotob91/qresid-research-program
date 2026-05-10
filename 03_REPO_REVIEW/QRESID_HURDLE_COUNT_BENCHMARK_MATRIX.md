Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before hurdle count benchmark implementation

# QRESID_HURDLE_COUNT_BENCHMARK_MATRIX.md

Date: 2026-05-10

POST_CHANGE_SYNC_DONE: benchmark matrix updated after Hilbe-Hardin hurdle implementation.
SUPPORT_MATRIX_SYNC_DONE: active qresid support claim added only for pinned unweighted hplogit/hnblogit routes.

## Status

`HURDLE_COUNT_IMPLEMENTATION_ALLOWED: yes_for_pinned_unweighted_hplogit_hnblogit`

`BENCHMARK_MATRIX_READY: yes_for_hplogit_hnblogit_logit_routes`

The mathematical endpoint design is closed at the distribution level, and
external Stata estimator routes are now pinned and implemented for the
Hilbe-Hardin logit routes.

## Benchmark Matrix

| route | Stata estimator route | R estimator candidate | R CDF/PIT candidate | dataset_id | benchmark_type | required_layers | current_decision |
|---|---|---|---|---|---|---|---|
| Hurdle Poisson, logit zero part | pinned SSC/RePEc `hplogit` | `pscl::hurdle(..., dist="poisson", zero.dist="binomial", link="logit")`; `glmmTMB(..., family=truncated_poisson, ziformula=...)` | base `ppois` positive-truncation replay; `VGAM::zapoisson`/`pospoisson` candidates | `synthetic`; `real_like`; `edge_stable` | `R_EXACT_BENCHMARK` for coefficients after zero-equation sign adjustment; `R_CDF_REPLAY` for endpoints | sample, pi, mu, support, F_low, F_high, V, qres | `READY_FOR_EXTENSION_PRERELEASE` |
| Hurdle Poisson, probit zero part | pending official/external Stata route | `pscl::hurdle(..., zero.dist="binomial", link="probit")`; route-specific `glmmTMB` if supported | base `ppois` positive-truncation replay | `HURDLE_POISSON_SYNTH_BASIC`; `HURDLE_EDGE_STABLE`; real-like dataset TBD | `R_EXACT_BENCHMARK` if zero link and truncation match | sample, pi, mu, support, F_low, F_high, V, qres | `GATED_MODEL_FAMILY` until Stata route closes |
| Hurdle NB, logit zero part | pinned SSC/RePEc `hnblogit` | `pscl::hurdle(..., dist="negbin")`; `glmmTMB(..., family=truncated_nbinom2, ziformula=...)` | base `pnbinom` positive-truncation replay; `VGAM::zanegbinomial`/`posnegbinomial` candidates | `synthetic`; `real_like`; `edge_stable` | `R_EXACT_BENCHMARK` for coefficients/theta after zero-equation sign adjustment; `R_CDF_REPLAY` for endpoints | sample, pi, mu, theta/alpha, support, F_low, F_high, V, qres | `READY_FOR_EXTENSION_PRERELEASE` |
| Hurdle NB, probit zero part | pending official/external Stata route | `pscl::hurdle(..., dist="negbin", link="probit")`; route-specific `glmmTMB` if supported | base `pnbinom` positive-truncation replay | `HURDLE_NB_SYNTH_OVERDISP`; `HURDLE_EDGE_STABLE`; real-like dataset TBD | `R_EXACT_BENCHMARK` if zero link and theta align | sample, pi, mu, theta/alpha, support, F_low, F_high, V, qres | `GATED_MODEL_FAMILY` until Stata route closes |
| DHARMa simulation sanity | not a Stata implementation route | `glmmTMB` non-correlated parameterization | `DHARMa::simulateResiduals` | same datasets after estimator closes | `SIMULATION_SANITY_CHECK` | distributional uniformity only | supplemental; never promotion evidence by itself |

## Exclusions

| excluded_route | reason |
|---|---|
| Stata `churdle` as count hurdle | official `churdle` is Cragg hurdle for bounded/continuous outcomes, not Poisson/NB count hurdle support |
| correlated, panel, multilevel hurdle routes | outside current non-correlated extension gate |
| hurdle weights | no weight semantics or benchmark gate yet |
| hurdle generalized Poisson | depends on a separate generalized Poisson hurdle estimator/source and is not covered by pinned `st0279` |

## Next Actions Before Code

1. Maintain strict `ml` dispatch by pinned-source signatures and equations.
2. Keep controlled errors for weights, `svy`, probit routes and unpinned hurdle commands.
3. Keep `churdle`, `ztpnm` and hurdle weights as separate gates.
