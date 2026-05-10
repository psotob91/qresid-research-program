Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before any adjusted, studentized, scaled, or standardized-residual API change

# QRESID_STANDARDIZED_QUANTILE_RESIDUALS_GATE.md

Date: 2026-05-11

POST_CHANGE_SYNC_DONE: updated after Scudilio-Pereira source pinning, `prior.weights` microtests and expanded GLM studentized/adjusted benchmark.
SUPPORT_MATRIX_SYNC_DONE: studentized and adjusted residual support is route-limited and must remain visible in support matrices and help.

## Decision Summary

`qresid` already returns quantile residuals on the standard normal scale:

```text
U_i = F_i(y_i; theta_hat)                       continuous
U_i = F_low + V_i * (F_high - F_low)             discrete
r_i = Phi^{-1}(U_i)
```

This is the Dunn-Smyth randomized quantile residual construction and is the same normal-score scale used by `statmod::qresiduals`. In this sense, the current residual is already a standard-normal quantile residual.

A different object, such as an adjusted, studentized, leverage-adjusted, bias-adjusted, or otherwise rescaled quantile residual, must not be added by analogy. It requires a route-specific mathematical formula, an R package/source-code audit when available, and a benchmark or replay test. The promoted leverage-adjusted route uses one formula, `qres/sqrt(1-h)`. `type(adjusted)` is the canonical qresid name; `type(studentized)` is retained only as an exact compatibility alias on the same validated routes because R software and papers use both terms.

## Formula And Evidence Matrix

| residual_variant | formula_or_operational_rule | family_or_route_scope | primary_reference | R_package_function | R_source_status | mathematical_double_check | decision |
|---|---|---|---|---|---|---|---|
| normal_score_qresid | `r_i = Phi^{-1}(U_i)` after PIT/randomized PIT | all currently supported `qresid` routes with valid CDF endpoints | Dunn and Smyth (1996); Cox and Snell (1968); Warton et al. (2017) | `statmod::qresiduals`; route-specific manual CDF replay | local `statmod` 1.5.1 inspected | PIT gives uniform with true parameters; normal quantile maps to standard normal. With estimated parameters, normality is approximate/asymptotic. No leverage correction is implied. | `ALREADY_IMPLEMENTED` |
| adjusted quantile residual (`studentized` compatibility alias) | `r_i^* = r_i / sqrt(1-h_i)`, where `r_i = Phi^{-1}(U_i)` and `h_i` is the diagonal from `predict, hat` | unweighted `regress`, `glm gaussian`, `glm poisson`, individual `glm binomial`, `glm gamma`, `glm igaussian` | `glmtoolbox::residuals2` documentation/source; Scudilio and Pereira (2020) for Gamma/IG; GLM leverage convention | `glmtoolbox::residuals2(type="quantile", standardized=TRUE)` for Gaussian; R CDF replay with exported `U` for other tested families | local `glmtoolbox` 0.1.12 installed and source inspected; Scudilio-Pereira PDF/TeX pinned | This is one adjustment formula under multiple names in the literature/software. It rescales the already normal-score residual by the fitted-model leverage factor. Weighted and non-GLM routes remain gated. | `READY_FOR_EXTENSION_PRERELEASE` |
| DHARMa scaled residual | simulated PIT on uniform scale; optional `qnorm()` transform by user | simulation sanity checks, especially complex models | DHARMa documentation; Warton et al. PIT logic | `DHARMa::simulateResiduals`; `DHARMa::getQuantile` | local DHARMa 0.4.7 source inspected via `getAnywhere()` | This is Monte Carlo PIT, not analytic CDF replay. It can diagnose simulation-calibrated models but is not an exact Dunn-Smyth analytic residual. | `NOT_A_QRESID_API_TARGET` |
| adjusted quantile residual for other routes | no accepted route-specific formula | Gaussian, Poisson, binomial, NB, ZIP/ZINB, truncated, censored, generalized Poisson, hurdle, weights | not closed for qresid | none accepted | `topmodels` and DHARMa do not provide analytic leverage adjustment | Keep controlled error until formula and benchmark close. | `GATED_RESEARCH` |
| normalized residuals in GAMLSS | `object$residuals` / `object$rqres` z-scores using family CDFs | GAMLSS-style families, not Stata GLM postestimation | GAMLSS documentation/source | `gamlss::residuals(..., what="z-scores")`; `gamlss::get.rqres` | local `gamlss` 5.5.0 installed and source inspected | Confirms normal-score/RQR taxonomy and frequency-weight handling. It does not provide a universal adjusted/studentized formula for `qresid` Stata routes. | `REFERENCE_ONLY` |
| topmodels probabilistic residuals | PIT/proresidual infrastructure; quantile residuals use `qnorm(PIT)` | probabilistic model objects | `topmodels` documentation/source | `topmodels::proresiduals(type="quantile")` | local `topmodels` 0.3.0 installed from R-Forge and source inspected | Confirms generic PIT/randomized PIT design. It does not provide leverage/studentization for Stata postestimation routes. | `REFERENCE_ONLY` |

## Mandatory Reverse-Engineering Protocol

Before any new residual option is implemented:

1. Identify the paper formula and the exact R package/function that implements it, when available.
2. Inspect the R documentation and source code, recording package version or commit.
3. Extract the operational formula, including defaults, weights, dispersion, leverage, hat values, clipping, and treatment of discrete randomization.
4. Compare the R implementation with the paper formula.
5. Add a maintainer mathematical check:
   - prove what target distribution is claimed;
   - state whether the formula preserves the standard-normal quantile-residual scale;
   - state whether it corrects leverage, bias, variance, or only rescales heuristically;
   - identify the assumptions needed for the proof.
6. Benchmark Stata/R for every route promoted to implementation.

## Mathematical Double-Check By qresid Maintainer

The existing `qresid` residual is not a raw residual needing standardization. It is already a probability-scale residual transformed to normal scale. If the fitted CDF is the true CDF and the response is independent, `U_i` is uniform and `Phi^{-1}(U_i)` is standard normal. For discrete responses, randomization inside `[F_low,F_high]` is what restores a continuous uniform PIT.

When parameters are estimated, `F_i(y_i; theta_hat)` is a plug-in CDF. The residuals share the same estimated parameters, so finite-sample independence and exact standard normality no longer hold. A leverage or studentization adjustment would need an approximation to the variance of the plug-in transformed residual, not just the usual GLM hat-matrix correction for Pearson or deviance residuals. That variance can depend on the score, information matrix, link, dispersion, and ancillary parameters. Therefore a universal `standardized` option would be misleading.

## Implementation Policy

- Do not add `standardized` as a public option for the current residual; document that the default is already on the standard normal scale.
- Public API is `type(quantile|adjusted|studentized)`. `type(quantile)` is default. `type(adjusted)` is the canonical name for the single validated leverage adjustment `qres/sqrt(1-h)`. `type(studentized)` is a compatibility alias on validated routes and must not be documented as a different method.
- `dispersion(#)` is validated only for Gamma and inverse Gaussian GLM. It replays the fitted CDF with a user-fixed positive dispersion, analogous to `statmod::qresiduals(..., dispersion=...)`; it does not refit the model.
- Do not support adjusted/studentized variants for external, mixture, truncated, censored, hurdle, weighted, survey, or non-`glm` routes until a route-specific derivation and benchmark exist.
- Keep this gate synchronized with help, glossary, API docs, and changelog before any implementation.

## References And Sources To Audit

- Cox, D. R., and E. J. Snell. 1968. A general definition of residuals. *Journal of the Royal Statistical Society, Series B* 30: 248-275.
- Dunn, P. K., and G. K. Smyth. 1996. Randomized quantile residuals. *Journal of Computational and Graphical Statistics* 5(3): 236-244.
- Scudilio, J., and G. H. A. Pereira. 2020. Adjusted quantile residual for generalized linear models. *Computational Statistics* 35: 399-421.
- Warton, D. I., L. Thibaut, and Y. A. Wang. 2017. The PIT-trap. *PLOS ONE* 12(7): e0181790.
- `statmod::qresiduals`, local package version 1.5.1.
- `DHARMa::simulateResiduals` and `DHARMa::getQuantile`, local package version 0.4.7.
- `topmodels`, `glmtoolbox`, and `gamlss` are candidates for later local installation/source audit.
