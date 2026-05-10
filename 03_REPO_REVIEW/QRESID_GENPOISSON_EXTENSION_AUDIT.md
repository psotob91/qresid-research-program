Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before generalized Poisson support, release, or benchmark changes

# QRESID_GENPOISSON_EXTENSION_AUDIT.md

Date: 2026-05-10

POST_CHANGE_SYNC_DONE: generalized Poisson source, support, benchmark and matrices reconciled.
SUPPORT_MATRIX_SYNC_DONE: support matrix, unified extension matrix, registry and source log updated.

## Decision

`GENERALIZED_POISSON_IMPLEMENTATION_ALLOWED: yes`

`GENERALIZED_POISSON_READY_STATUS: READY_FOR_EXTENSION_PRERELEASE`

Scope is intentionally narrow:

- Stata estimator: pinned Stata Journal `st0279` / `gpoisson`.
- Weight scope: unweighted only.
- Route: default documented generalized Poisson (`e(gptype)=1` / `e(delta)`).
- `qresid` role: postestimation residual command only; it does not include,
  copy, replace or redistribute the external estimator.

## Pinned Source

Local pinned source:

- `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/STATA/st0279/g/gpoisson.ado`
- `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/STATA/st0279/g/gpois_lf.ado`
- `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/STATA/st0279/g/gpoisson.sthlp`
- `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/STATA/st0279/jaggia.dta`

Observed versions:

- `gpoisson.ado`: `*! version 1.1.0  11jun2011`
- `gpois_lf.ado`: `*! version 1.0.0  31oct2006`

External article/source:

- Harris, Yang and Hardin (2012), Stata Journal `st0279`,
  https://doi.org/10.1177/1536867X1201200412

## Parameterization

The pinned likelihood uses the generalized Poisson PMF

`P(Y=y) = (1-delta)*mu * ((1-delta)*mu + delta*y)^(y-1) * exp(-((1-delta)*mu + delta*y)) / y!`

with `mu = predict, n` and `delta = e(delta)`.

Equivalently, this is the original GP-0 form with

- `theta = (1-delta)*mu`
- `lambda = delta`
- `E(Y)=mu`

The CDF endpoints are computed by finite summation:

- `F_low = P(Y <= y-1)`
- `F_high = P(Y <= y)`

For negative `delta`, the support is finite and the benchmark uses analytic
CDF replay from the pinned formula because modern `VGAM` does not fit the
negative-lambda GP-0 route.

## R Mapping

R packages checked:

- `VGAM` 1.1.14
- `glmmTMB` 1.1.14

Mapping used:

- Positive `delta`: `VGAM::pgenpois0(q, theta=(1-delta)*mu, lambda=delta)`
  matches the pinned PMF/CDF to machine precision.
- Negative `delta`: `R_CDF_REPLAY` from the same analytic PMF/CDF is used.
- `glmmTMB::genpois` is retained as secondary evidence for future approximate
  work because its documented variance parameterization differs from the
  pinned `st0279` route.

## Benchmarks

Scripts:

- `qresid/tests/benchmark_genpoisson_stata.do`
- `qresid/tests/benchmark_genpoisson_r.R`

Datasets:

- `jaggia_official`: Stata Journal `jaggia.dta` example data.
- `poisson_like_stable`: synthetic stable count data.
- `nb_like_overdispersed`: synthetic overdispersed count data.

Layers:

- estimator convergence;
- `mu = predict, n`;
- `delta = e(delta)`;
- support check for `theta + delta*y > 0`;
- `F_low`;
- `F_high`;
- `U` with `uvar()`;
- final qres.

Latest status:

- Stata benchmark: `QRESID_GENPOISSON_BENCHMARK_STATUS PASS`.
- R checker: `QRESID_GENPOISSON_R_STATUS PASS`.
- Positive-delta VGAM GP-0 check: max CDF difference `2.220446e-16`.

## Remaining Gated Variants

- `gpoisson` weights.
- `gpoisson` `gp2` or undocumented/internal variants.
- Other generalized Poisson estimators such as unrelated `gtools/gpoisson.ado`
  or any SSC route not separately pinned.
- Hurdle generalized Poisson.
- Correlated, panel, multilevel or finite-mixture generalized Poisson.

## Release Interpretation

This is local extension-prerelease readiness, not public RC or SSC stable
support. Public documentation may mention the route only with its external
estimator dependency and the unweighted/pinned-source limitation.
