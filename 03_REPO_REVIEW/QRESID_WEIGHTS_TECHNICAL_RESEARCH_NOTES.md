Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load by task before any weighted residual implementation

# QRESID Weights Technical Research Notes

Date: 2026-05-10

## Status

Weighted estimation results are not supported by `qresid` yet.

Support status: `BLOCKED_BY_WEIGHT_TYPE_AND_FAMILY_SEMANTICS_GATE`.

## Sources Inspected

- Local Stata: `C:\Program Files\StataNow19\ado\base\g\glm.ado`.
- Local Stata manuals: `C:\Program Files\StataNow19\docs\r.pdf`,
  `C:\Program Files\StataNow19\docs\st.pdf`.
- Official Stata GLM manual: <https://www.stata.com/manuals/rglm.pdf>.
- Local R source: `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/R/statmod/R/qres.R`.
- statmod documentation: <https://rdrr.io/cran/statmod/man/qresiduals.html>.

## Findings

- Stata estimation results expose weight metadata through `e(wtype)` and
  `e(wexp)` when a weighted model is fit.
- A global post-hoc multiplication such as `sqrt(w_i) * RQR_i` is not a
  valid universal RQR rule.
- In `statmod`:
  - binomial uses `prior.weights` as trial counts;
  - Gamma changes the CDF itself with `w / dispersion`;
  - Gaussian/default residuals include weights when estimating dispersion;
  - Poisson residuals are not handled by multiplying the final residual by
    `sqrt(w_i)`.

## Required Gate Before Implementation

Weights can be implemented only for explicit combinations:

- family x Stata weight type x estimation command.
- frequency/trials semantics separate from analytic/probability/importance
  weights.
- exact benchmark against R or an independently derived CDF formula.

Minimum benchmark requirement:

- three datasets per supported family/weight-type combination;
- layer checks for sample, weights, fitted means, dispersion/ancillary
  parameters, CDF endpoints, and residuals.

## Current Runtime Rule

If `e(wtype)` is nonempty, `qresid` exits with a controlled error:

`weighted estimation results require the documented weights semantics gate`

No weighted residuals are produced until this gate closes.
