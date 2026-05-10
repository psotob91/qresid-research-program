Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before any NB implementation or benchmark decision

# NB_PARAMETRIZATION_RESEARCH.md

Date: 2026-05-10

Branch: `dev-qresid-nb-weights-grouped-binomial`

Status source: local Stata/R inspection on root `b91e964`; qresid subrepo `388e595`.

POST_CHANGE_SYNC_DONE: registered in `DOCUMENT_STATUS_REGISTRY.md`.

## 1. Decision

`NB_IMPLEMENTATION_ALLOWED: yes`

`NB_BENCHMARK_ALLOWED: yes`

NB support is allowed only for the narrow integrated experimental scope after the benchmark cycle passed CDF/RQR layer comparisons on three datasets.

The allowed benchmark candidate is:

```stata
nbreg y x..., dispersion(mean)
```

with default log-link mean model; the no-weight route now includes tested no-offset, `offset()`, and `exposure()` cases. Direct `fweight` is validated in the separate fweight benchmark, not in this NB parametrization gate.

Allowed implementation scope:

- `nbreg y x..., dispersion(mean)`;
- unweighted plus tested direct `fweight` in separate weight benchmark;
- no-offset, `offset()`, and `exposure()` cases;
- default log-link mean model;
- CDF endpoints using `theta = 1/e(alpha)` and `p = theta/(theta+mu)`.

Still blocked:

- `dispersion(constant)`;
- `gnbreg`;
- NB weights beyond the tested direct `fweight` route;
- non-log links;
- `glm, family(nbinomial ml)` as a stable implementation route.

## 2. Sources Read

Local Stata sources:

- `C:\Program Files\StataNow19\ado\base\n\nbreg.ado`
- `C:\Program Files\StataNow19\ado\base\n\nbreg.sthlp`
- `C:\Program Files\StataNow19\ado\base\n\nbreg_postestimation.sthlp`
- `C:\Program Files\StataNow19\ado\base\n\nbreg_p.ado`
- `C:\Program Files\StataNow19\ado\base\g\glm.ado`
- `C:\Program Files\StataNow19\ado\base\g\glm.sthlp`

Local R sources/packages:

- R `4.5.2`
- `MASS 7.3-65`
- `statmod 1.5.1`
- `VGAM 1.1-14`
- `AER 1.2-16`

## 3. Stata `nbreg` Findings

`nbreg` supports two dispersion parameterizations:

| Stata option | Stored scalar | Stored coefficient | Meaning found in Stata help | Research status |
|---|---:|---|---|---|
| `dispersion(mean)` default | `e(alpha)` | `/lnalpha` | dispersion is `1 + alpha * exp(xb + offset)`, a function of expected mean | candidate NB2 benchmark |
| `dispersion(constant)` | `e(delta)` | `/lndelta` | dispersion is `1 + delta`, constant for all observations | blocked |

For `dispersion(mean)`, local probes showed:

- `e(cmd) = nbreg`
- `e(dispers) = mean`
- `e(alpha)` is stored as a scalar
- `e(b)` contains `/lnalpha`
- `predict, n` returns expected number of events, including offset/exposure when used
- `predict, xb` returns the linear predictor
- `predict, pr(n)` can produce event probabilities for fixed counts

Candidate mapping:

```text
Var(Y_i | mu_i) = mu_i + alpha * mu_i^2
theta = size = 1 / alpha
```

This is compatible with R/MASS negative binomial variance:

```text
Var(Y_i | mu_i) = mu_i + mu_i^2 / theta
```

## 4. CDF Endpoint Candidate

For nonnegative integer `y_i`, the candidate randomized quantile interval is:

```text
F_low_i  = P(Y_i <= y_i - 1)
F_high_i = P(Y_i <= y_i)
```

with R-equivalent computation:

```r
F_low  <- ifelse(y > 0, pnbinom(y - 1, size = theta, mu = mu), 0)
F_high <- pnbinom(y, size = theta, mu = mu)
```

This endpoint definition must be benchmarked against Stata layer outputs before implementation.

## 5. R Findings

`MASS::negative.binomial(theta)` defines:

```text
variance(mu) = mu + mu^2 / theta
```

and supports links:

- `log`
- `identity`
- `sqrt`

`MASS::glm.nb()` estimates `theta`, stores it as `fit$theta`, and uses `negative.binomial(theta, link = link)`.

`statmod::qresiduals()` dispatches negative binomial models to an internal NB residual method. Local source inspection showed the NB endpoint logic uses `glm.obj$theta` or the family theta and computes lower/upper randomized intervals from the NB CDF. This is compatible with using R NB CDF endpoints as the benchmark reference, but the project should implement explicit layer comparisons rather than rely only on final `qresiduals()`.

## 6. Stata `glm, family(nbinomial)` Findings

Stata `glm` supports:

```stata
glm y x..., family(nbinomial #|ml) link(log)
```

and stores:

- `e(cmd) = glm`
- `e(varfunc) = glim_v6`
- `e(varfunct) = Neg. Binomial`
- `e(link) = glim_l03` for log link
- `e(linkt) = Log`
- `e(nbml) = 1` when the NB parameter is estimated by ML
- `e(varfuncf)` as text like `u+(.5866)u^2`

Local probes showed that under `family(nbinomial ml)`, the estimated NB parameter does not appear as a separate coefficient in `e(b)`. It appears embedded in the variance-function text. That is not robust enough for `qresid` implementation.

Decision:

`glm, family(nbinomial ml)` is allowed for comparative research only. It is not the first implementation route.

## 7. Blocked Combinations

| combination | status | reason |
|---|---|---|
| `nbreg, dispersion(constant)` | blocked | R equivalent and CDF parameterization are not closed. |
| `gnbreg, lnalpha(varlist)` | blocked | Observation-varying alpha requires separate CDF endpoint rules and R benchmark strategy. |
| NB weights beyond tested direct `fweight` | blocked | Weight semantics are not closed by family x weight type. |
| NB with offset/exposure | allowed for `nbreg, dispersion(mean)` | Dedicated benchmark confirms `predict, n` includes exposure/offset and R endpoints match from the fitted mean. |
| NB non-log links | blocked | Stata/R link equivalence and convergence design not yet benchmarked. |
| `glm, family(nbinomial ml)` stable route | blocked | Estimated NB parameter extraction is not robustly available as scalar/matrix output. |

## 8. Recommended Datasets

| dataset_id | purpose | design |
|---|---|---|
| `NB_SYNTH_BASIC` | Basic NB2 equivalence | `n=300-500`, one normal covariate, log mean, moderate `theta`, no weights, no offset. |
| `NB_OVERDISP_MODERATE` | Distinguish NB from Poisson | Lower `theta`, wider `mu`, enough zeros and moderate counts, stable convergence. |
| `NB_ADV_SMALL_STABLE` | Edge behavior without nonconvergence | Small dataset with zeros and low counts, no extreme leverage, optionally controlled exposure for later offset/exposure benchmark. |

Datasets must be validated first as estimator benchmarks. A nonconvergent fit is not evidence against `qresid` until the model and dataset are checked independently.

## 9. Required Benchmark Layers

Before implementation can be reconsidered, compare:

1. estimation sample;
2. coefficients;
3. `mu` / predicted number of events;
4. `alpha`, `lnalpha`, `theta = 1/alpha`;
5. `F_low`;
6. `F_high`;
7. fixed `U` via `uvar()`;
8. final qres.

All comparisons must include tolerances and log files.

## 10. Recommendation

Keep NB variants beyond `nbreg, dispersion(mean)` blocked for implementation now.

Base `nbreg, dispersion(mean)` has passed the benchmark cycle for no-offset, `offset()`, and `exposure()` cases, using explicit R `pnbinom(size = 1 / alpha, mu = mu)` endpoints and `MASS::glm.nb()` as a reference estimator.

Next NB work should target only separately gated variants such as `dispersion(constant)`, `gnbreg`, or `glm nbinomial`.
