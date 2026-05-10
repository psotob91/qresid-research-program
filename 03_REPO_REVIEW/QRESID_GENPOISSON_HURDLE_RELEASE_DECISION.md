Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before generalized Poisson or hurdle release decisions

# QRESID_GENPOISSON_HURDLE_RELEASE_DECISION.md

Date: 2026-05-10

POST_CHANGE_SYNC_DONE: generalized Poisson and hurdle release decision recorded after estimator-equivalence audit; pinned hurdle count implementation status reconciled after qresid dispatcher and endpoint tests.
SUPPORT_MATRIX_SYNC_DONE: current support, unified extension, GLM/link, glossary and registry remain aligned with this decision.

## Decision

`GENERALIZED_POISSON_RELEASE_DECISION: READY_FOR_EXTENSION_PRERELEASE`

`HURDLE_COUNT_RELEASE_DECISION: READY_FOR_EXTENSION_PRERELEASE_FOR_PINNED_UNWEIGHTED_HILBE_HARDIN_ROUTES`

`QRESID_ADO_CHANGE_REQUIRED: implemented_for_pinned_hurdle_routes`

## Generalized Poisson

The pinned Stata Journal `st0279` / `gpoisson` route remains ready for local
extension prerelease under a narrow claim:

- unweighted only;
- pinned Stata Journal source only;
- default GP-0 documented route;
- Stata estimates the model;
- R validates CDF endpoints through `VGAM::pgenpois0` where applicable and
  manual analytic replay for the full accepted route;
- residuals are Dunn-Smyth randomized quantile residuals using `uvar()` for
  deterministic benchmark comparisons.

This is not a claim for `gp2`, weights, unrelated `gpoisson` commands,
correlated models, hurdle generalized Poisson, or public SSC stable support.

## Hurdle Count Poisson/NB

Pinned Hilbe/Hardin hurdle count models may be promoted for local extension
prerelease under a narrow claim:

- unweighted `hplogit` Poisson-logit hurdle;
- unweighted `hnblogit` NB-logit hurdle;
- external ado files must be installed or on `adopath`;
- `qresid` recognizes the fits through strict `e(user)`, `e(title)` and
  `e(b)` equation signatures because both commands leave `e(cmd)="ml"`;
- R validation uses sign-adjusted `pscl::hurdle` estimator comparison and
  manual CDF replay for Dunn-Smyth endpoints.

This is not a claim for `churdle`, probit hurdle, `ztpnm`, hurdle generalized
Poisson, weights, `svy:`, correlated models, or unpinned external routes.

## Required Future Gate For Additional Hurdle Promotion

Before any additional hurdle route can move to `READY_FOR_EXTENSION_PRERELEASE`,
the following must all pass:

1. Stata count-hurdle estimator route accepted or external ado pinned.
2. Extractor audit for zero part, positive count part, support and ancillary
   parameters.
3. Three datasets: synthetic controlled, real/offical or real-like, adversarial
   stable.
4. Benchmark layers: sample, `pi`, `mu`, `theta/alpha` when NB, support,
   `F_low`, `F_high`, `U`, and qres.
5. R exact benchmark, R CDF replay, or explicitly labeled Stata external ado
   validation.
6. Matrices, glossary, help/README claims, certification and registry synced.

## Freeze Interpretation

This decision freezes the current split:

- generalized Poisson: validated local extension-prerelease support for a
  pinned external estimator route;
- hurdle count: pinned unweighted `hplogit`/`hnblogit` routes ready for local
  extension prerelease; all other hurdle variants remain gated or missing not
  blocking.
