Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before any Stata churdle support decision

# QRESID_CHURDLE_CRAGG_GATE_AUDIT.md

Date: 2026-05-10

POST_CHANGE_SYNC_DONE: `churdle` separated from count-hurdle Poisson/NB gate.
SUPPORT_MATRIX_SYNC_DONE: no `churdle` support claim added.

## Decision

`CHURDLE_IMPLEMENTATION_ALLOWED: no`

`CHURDLE_IS_COUNT_HURDLE: no`

`CHURDLE_BENCHMARK_ALLOWED: yes_after_continuous_cragg_gate`

Stata `churdle` is official, but it is not the count-hurdle Poisson/NB route
requested for the current count-model extension. It models bounded/continuous
outcomes using Cragg hurdle regression with linear or exponential outcome
equations. Therefore, it cannot be used to justify count hurdle support in
`qresid`.

## Local Stata Evidence

Local Stata files are present:

- `C:\Program Files\StataNow19\ado\base\c\churdle.ado`
- `C:\Program Files\StataNow19\ado\base\c\churdle_p.ado`
- `C:\Program Files\StataNow19\ado\base\c\churdle.sthlp`
- `C:\Program Files\StataNow19\ado\base\c\churdle_postestimation.sthlp`

These files should be audited before any future `churdle` support. They were
not used to implement or claim support in this gate.

## Theory Note

For continuous or mixed continuous-boundary hurdle models, an interval-PIT
idea can be used:

- continuous interior observations use `U=F(y)`;
- mass at a boundary uses a randomized interval between the CDF just before
  and just after the boundary;
- censored or bounded intervals use `U ~ Uniform(F(L), F(U))`.

This theory is useful, but it does not authorize support without route-specific
extraction, CDF, examples and tests.

## Required Future Gate

Before any `churdle` implementation:

- identify supported estimator variants: `linear`, `exponential`, lower/upper
  bounds;
- extract selection probabilities and outcome CDF components;
- define boundary mass and continuous interior CDF endpoints;
- find an R equivalent or declare `STATA_INTERNAL_VALIDATION`;
- build three convergent datasets;
- add examples/help without implying count-hurdle support.

## Release Interpretation

Missing `churdle` support is `MISSING_NOT_BLOCKING`. It remains a separate
future gate and does not affect current count-model support.
