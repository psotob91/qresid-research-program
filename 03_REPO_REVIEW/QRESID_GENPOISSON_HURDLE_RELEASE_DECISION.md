Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before generalized Poisson or hurdle release decisions

# QRESID_GENPOISSON_HURDLE_RELEASE_DECISION.md

Date: 2026-05-10

POST_CHANGE_SYNC_DONE: generalized Poisson and hurdle release decision recorded after estimator-equivalence audit.
SUPPORT_MATRIX_SYNC_DONE: current support, unified extension, GLM/link, glossary and registry remain aligned with this decision.

## Decision

`GENERALIZED_POISSON_RELEASE_DECISION: READY_FOR_EXTENSION_PRERELEASE`

`HURDLE_COUNT_RELEASE_DECISION: KEEP_GATED_MISSING_NOT_BLOCKING`

`QRESID_ADO_CHANGE_REQUIRED: no`

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

Hurdle count models should not be promoted yet. The distribution-level
mathematics is adequate for PIT/RQR, and R packages provide useful estimator
and CDF references, but `qresid` is a Stata postestimation command and still
needs a Stata estimator route:

- `pscl::hurdle` is an R estimator/reference, not a Stata route;
- `glmmTMB` can fit hurdle-like non-correlated models and support simulation
  sanity checks, but it does not authorize Stata support;
- `VGAM` provides useful distribution/CDF pieces;
- `churdle` is a different Cragg bounded/continuous model and must stay in a
  separate gate.

The next implementation step for hurdle is therefore not `qresid.ado`; it is
source/version/license pinning or official proof of a Stata count-hurdle
estimator plus extraction of `pi`, positive-count `mu`, and ancillary
parameters.

## Required Future Gate For Hurdle Promotion

Before hurdle can move to `READY_FOR_EXTENSION_PRERELEASE`, the following must
all pass:

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
- hurdle count: theory documented and benchmark design ready, but support not
  claimed.

