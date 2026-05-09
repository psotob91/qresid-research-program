Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load by task for Gamma implementation/benchmark

# QRESID Gamma Technical Research Notes

Date: 2026-05-10

## Status

Gamma is implemented for `glm, family(gamma)` with unweighted estimation
results only.

Support status: `PHASE1_IMPLEMENTED_WITH_LOCAL_STATA_R_BENCHMARK`.

## Sources Inspected

- Local Stata: `C:\Program Files\StataNow19\ado\base\g\glm.ado`.
- Local Stata manuals: `C:\Program Files\StataNow19\docs\r.pdf`.
- Official Stata manual: <https://www.stata.com/manuals/rglm.pdf>.
- Local R source: `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/R/statmod/R/qres.R`.
- statmod documentation: <https://rdrr.io/cran/statmod/man/qresiduals.html>.

## Formula Used

For unweighted Gamma GLM:

- `mu_i = predict, mu`
- `phi = e(dispers)`
- `shape = 1 / phi`
- `scale_i = mu_i * phi`
- `F_i(y_i) = gammap(shape, y_i / scale_i)`
- `RQR_i = invnormal(clip(F_i(y_i)))`

This is equivalent to R's:

```r
qnorm(pgamma(y, shape = 1 / phi, scale = mu * phi))
```

For weighted Gamma models, `statmod` uses `shape = w / dispersion` and
`pgamma((w * y) / mu / dispersion, w / dispersion)`. Weighted residuals remain
blocked until the weights semantics gate is closed.

## Benchmarks

Scripts:

- `qresid/tests/benchmark_gamma_stata.do`
- `qresid/tests/benchmark_gamma_r.R`

Datasets:

- `synthetic_known_shape`
- `stata_auto_positive`
- `adversarial_small_positive`

Latest result:

- Stata log: `qresid/tests/logs/10_May_2026_054943_gamma_benchmark_stata.log`
- R log: `qresid/tests/logs/10_May_2026_054943_gamma_benchmark_r.log`
- R summary: `qresid/tests/logs/10_May_2026_054943_gamma_benchmark_r_check.csv`
- Status: `PASS`
- Max observed differences: `abs_diff_u <= 3.4e-15`, `abs_diff_qr <= 8.4e-15`

## Implementation Rules

- Require `y > 0`.
- Require `mu > 0`.
- Require positive `e(dispers)`.
- Do not randomize Gamma residuals.
- Do not apply `uvar()` semantics to continuous Gamma residuals.
- Do not support weighted Gamma until the weights research gate is closed.
