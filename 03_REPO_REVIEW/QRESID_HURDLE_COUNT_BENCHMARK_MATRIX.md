Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before hurdle count benchmark implementation

# QRESID_HURDLE_COUNT_BENCHMARK_MATRIX.md

Date: 2026-05-10

POST_CHANGE_SYNC_DONE: benchmark matrix created for hurdle count research gate.
SUPPORT_MATRIX_SYNC_DONE: no active support claim added; matrix records gated benchmark design.

## Status

`HURDLE_COUNT_IMPLEMENTATION_ALLOWED: no`

`BENCHMARK_MATRIX_READY: partial`

The mathematical endpoint design is closed at the distribution level, but the
Stata estimator route is not yet closed. No `qresid.ado` implementation is
authorized from this matrix alone.

## Benchmark Matrix

| route | Stata estimator route | R estimator candidate | R CDF/PIT candidate | dataset_id | benchmark_type | required_layers | current_decision |
|---|---|---|---|---|---|---|---|
| Hurdle Poisson, logit zero part | pending official/external Stata route | `pscl::hurdle(..., dist="poisson", zero.dist="binomial", link="logit")`; `glmmTMB(..., family=truncated_poisson, ziformula=...)` | base `ppois` positive-truncation replay; `VGAM::zapoisson`/`pospoisson` candidates | `HURDLE_POISSON_SYNTH_BASIC`; `HURDLE_EDGE_STABLE`; real-like dataset TBD | `R_EXACT_BENCHMARK` if Stata/R parameterization aligns; otherwise `R_CDF_REPLAY` | sample, pi, mu, support, F_low, F_high, V, qres | `GATED_MODEL_FAMILY` until Stata route closes |
| Hurdle Poisson, probit zero part | pending official/external Stata route | `pscl::hurdle(..., zero.dist="binomial", link="probit")`; route-specific `glmmTMB` if supported | base `ppois` positive-truncation replay | `HURDLE_POISSON_SYNTH_BASIC`; `HURDLE_EDGE_STABLE`; real-like dataset TBD | `R_EXACT_BENCHMARK` if zero link and truncation match | sample, pi, mu, support, F_low, F_high, V, qres | `GATED_MODEL_FAMILY` until Stata route closes |
| Hurdle NB, logit zero part | pending official/external Stata route | `pscl::hurdle(..., dist="negbin")`; `glmmTMB(..., family=truncated_nbinom2, ziformula=...)` | base `pnbinom` positive-truncation replay; `VGAM::zanegbinomial`/`posnegbinomial` candidates | `HURDLE_NB_SYNTH_OVERDISP`; `HURDLE_EDGE_STABLE`; real-like dataset TBD | `R_EXACT_BENCHMARK` if theta/alpha aligns; otherwise `R_CDF_REPLAY` | sample, pi, mu, theta/alpha, support, F_low, F_high, V, qres | `GATED_MODEL_FAMILY` until Stata route closes |
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

1. Identify or pin a Stata count-hurdle estimator.
2. Audit extraction for zero-part `pi`, positive-part `mu`, and ancillary parameters.
3. Install or otherwise authorize `pscl` if exact estimator-level R benchmark is required.
4. Run three datasets per accepted route.
5. Update this matrix from `GATED_MODEL_FAMILY` only after all layers pass.
