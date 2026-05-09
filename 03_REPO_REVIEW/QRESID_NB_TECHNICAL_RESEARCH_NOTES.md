Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load by task before any NB implementation

# QRESID Negative Binomial Technical Research Notes

Date: 2026-05-10

## Status

Negative binomial support is not implemented.

Support status: `BLOCKED_BY_PARAMETRIZATION_AND_BENCHMARK_GATE`.

## Sources Inspected

- Local Stata: `C:\Program Files\StataNow19\ado\base\n\nbreg.ado`.
- Local Stata manuals: `C:\Program Files\StataNow19\docs\r.pdf`.
- Official Stata manual: <https://www.stata.com/manuals/rnbreg.pdf>.
- Stata FAQ: <https://www.stata.com/support/faqs/statistics/nbreg-variance-function/>.
- Local R source: `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/R/statmod/R/qres.R`.

## Findings

- `nbreg` has `dispersion(mean)` as default and also supports
  `dispersion(constant)`.
- The official Stata manual identifies the default mean-dispersion model as
  NB2 and the constant-dispersion model as NB1.
- `nbreg` parameterizes the overdispersion through `lnalpha`; `gnbreg` can model
  `lnalpha_j`.
- The CDF equivalence must distinguish:
  - Stata `nbreg, dispersion(mean)` / NB2.
  - Stata `nbreg, dispersion(constant)` / NB1.
  - `glm, family(nbinomial #)` semantics.
  - R benchmark parameter names such as `size`, `theta`, `alpha`, and `mu`.

## Required Gate Before Implementation

NB can be implemented only after a benchmark note proves all of the following:

- How to extract Stata's active NB parametrization from `e()`.
- Exact mapping from Stata parameters to R `pnbinom()` arguments.
- Exact CDF endpoints for `F(y-)` and `F(y)`.
- Behavior with exposure/offset.
- Three benchmark datasets with layer-by-layer agreement:
  coefficients, `mu`, alpha/theta/k, CDF endpoints, `U`, and residuals.

## Current Runtime Rule

`qresid` must fail with a controlled error after `nbreg` until this gate closes.

No partial NB calculation is allowed.
