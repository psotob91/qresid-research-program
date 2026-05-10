Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before hurdle count implementation or benchmark work

# QRESID_HURDLE_RQR_THEORY_AND_BENCHMARK.md

Date: 2026-05-10

POST_CHANGE_SYNC_DONE: hurdle RQR theory gate opened and updated after Hilbe-Hardin Stata ado pinning/extraction benchmark.
SUPPORT_MATRIX_SYNC_DONE: support matrix, unified extension matrix, math/software evidence matrix and registry reviewed; qresid support remains implementation-pending.

## Decision

`HURDLE_COUNT_IMPLEMENTATION_ALLOWED: no_not_in_this_cycle`

`HURDLE_COUNT_BENCHMARK_ALLOWED: yes_hplogit_hnblogit_gate_passed`

`CHURDLE_IS_COUNT_HURDLE: no`

The probability-integral-transform and Dunn-Smyth randomized quantile residual
theory is suitable for hurdle count distributions once the fitted CDF is
closed. The previous blocker was the Stata estimator route. That route is now
closed for pinned external `hplogit` and `hnblogit` logit-hurdle commands, but
`qresid.ado` implementation remains a separate cycle because both commands
leave `e(cmd)="ml"` and require route-specific dispatch.

Estimator-level benchmarks must be attempted before residual benchmarks. If
the R and Stata estimators are not equivalent, the route may only use
`R_CDF_REPLAY` after a Stata estimator exports all fitted CDF parameters
robustly. Until that happens, hurdle remains gated even though its PIT/RQR
formula is closed.

## Count Hurdle RQR Target

For count hurdle Poisson/NB routes, the fitted distribution has a mass at zero
and a positive-count component:

- `P(Y=0)=pi_i`.
- For `y>0`, `F_i(y)=pi_i+(1-pi_i)*F_plus_i(y)`.
- `F_plus_i` is the CDF of the positive truncated count distribution.

Randomized PIT endpoints:

- if `y=0`: `F_low=0`, `F_high=pi_i`;
- if `y>0`: `F_low=pi_i+(1-pi_i)*F_plus_i(y-1)`;
- if `y>0`: `F_high=pi_i+(1-pi_i)*F_plus_i(y)`;
- `U_i=F_low+V_i*(F_high-F_low)`, with `V_i ~ Uniform(0,1)`;
- `qres_i=invnormal(U_i)`.

This is a direct application of randomized PIT/RQR for discrete distributions
with atoms. With estimated parameters the normality/uniformity target is
approximate, as in other fitted-model quantile residuals.

## Candidate R Evidence

| package_or_source | role | current_local_status | use_for_qresid |
|---|---|---|---|
| `pscl::hurdle` | Estimator for Poisson/NB hurdle count models; documented formula interface and zero/count components. | not installed locally at gate opening | Primary R exact/approx benchmark candidate if installed or if docs/source are used for design. |
| `glmmTMB` | Estimator using zero component plus truncated count families; can mimic non-correlated hurdle count models. | installed `1.1.14` | Estimator benchmark candidate and DHARMa simulation sanity route, not an analytic substitute. |
| `VGAM` | Zero-altered and positive count families with distribution functions. | installed `1.1.14` | CDF/PIT replay candidate for hurdle Poisson/NB layers. |
| `topmodels::qresiduals` | General PIT/RQR infrastructure. | not installed locally | Documentation authority for PIT/RQR interpretation; not required for endpoint replay. |
| `DHARMa` | Simulation-based residual diagnostics. | installed `0.4.7` | `SIMULATION_SANITY_CHECK` only; never a gold standard for analytic endpoint claims. |

## Required Stata Closure

Before implementation, these route-specific items must close:

- external Stata hurdle-count ado is source/version/license pinned and
  extraction is audited. This is now complete for `hplogit` and `hnblogit`;
- future `qresid` dispatcher policy must handle `e(cmd)="ml"` safely;
- public help/examples/certification must be added in a separate
  implementation cycle.

`churdle` is not that route. It is official Stata Cragg hurdle regression for
bounded/continuous outcomes and receives a separate gate.

## Dataset Design

Each candidate route needs three convergent datasets:

| dataset_id | purpose | requirements |
|---|---|---|
| `HURDLE_POISSON_SYNTH_BASIC` | synthetic controlled Poisson hurdle | moderate zero mass, log count mean, no separation in zero part |
| `HURDLE_NB_SYNTH_OVERDISP` | synthetic overdispersed NB hurdle | moderate theta/alpha, enough positive counts, stable zero process |
| `HURDLE_EDGE_STABLE` | adversarial stable | many zeros and low counts, but no perfect prediction and no degenerate positive support |

## Benchmark Layers

Every route must compare:

- estimation sample;
- zero-part probability `pi`;
- positive-part mean `mu`;
- ancillary parameters such as `theta`/`alpha`;
- support and positive truncation;
- `F_low`;
- `F_high`;
- fixed `V`/`uvar()` layer;
- final qres.

## Promotion Rule

Move to `READY_FOR_EXTENSION_PRERELEASE` only after a Stata estimator route is
accepted, three datasets pass, the CDF endpoints are reproducible, and public
docs/examples/certification/matrices are synchronized.

Until implementation, hurdle count remains `MISSING_NOT_BLOCKING` for current
package validity and `BENCHMARK_GATE_PASSED_IMPLEMENTATION_PENDING` for the
pinned Hilbe-Hardin logit routes.

## Sources

- Dunn, P. K., and G. K. Smyth. 1996. Randomized quantile residuals.
- `pscl::hurdle`: https://search.r-project.org/CRAN/refmans/pscl/html/hurdle.html
- `hplogit`: https://econpapers.repec.org/RePEc%3Aboc%3Abocode%3As456405
- `hnblogit`: https://ideas.repec.org/c/boc/bocode/s456401.html
- `glmmTMB`: https://glmmtmb.github.io/glmmTMB/reference/glmmTMB.html
- `VGAM` zero-altered families: https://www.rdocumentation.org/packages/VGAM/versions/1.1-14/topics/zanegbinomial
- `topmodels::qresiduals`: https://rdrr.io/rforge/topmodels/man/qresiduals.html
- Stata `churdle`: https://www.stata.com/features/overview/hurdle-models/
