Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before any adjusted, studentized, scaled, or standardized-residual API change

# QRESID_STANDARDIZED_QUANTILE_RESIDUALS_GATE.md

Date: 2026-05-10

POST_CHANGE_SYNC_DONE: created as the live gate for standardized/adjusted quantile residual terminology and implementation decisions.
SUPPORT_MATRIX_SYNC_NOT_REQUIRED: no support status changed; this gate blocks new API until formulas and benchmarks close.

## Decision Summary

`qresid` already returns quantile residuals on the standard normal scale:

```text
U_i = F_i(y_i; theta_hat)                       continuous
U_i = F_low + V_i * (F_high - F_low)             discrete
r_i = Phi^{-1}(U_i)
```

This is the Dunn-Smyth randomized quantile residual construction and is the same normal-score scale used by `statmod::qresiduals`. In this sense, the current residual is already a standard-normal quantile residual.

A different object, such as an adjusted, studentized, leverage-adjusted, bias-adjusted, or otherwise rescaled quantile residual, is not currently implemented. It must not be added by analogy. It requires a route-specific mathematical formula, an R package/source-code audit when available, and a benchmark or replay test.

## Formula And Evidence Matrix

| residual_variant | formula_or_operational_rule | family_or_route_scope | primary_reference | R_package_function | R_source_status | mathematical_double_check | decision |
|---|---|---|---|---|---|---|---|
| normal_score_qresid | `r_i = Phi^{-1}(U_i)` after PIT/randomized PIT | all currently supported `qresid` routes with valid CDF endpoints | Dunn and Smyth (1996); Cox and Snell (1968); Warton et al. (2017) | `statmod::qresiduals`; route-specific manual CDF replay | local `statmod` 1.5.1 inspected | PIT gives uniform with true parameters; normal quantile maps to standard normal. With estimated parameters, normality is approximate/asymptotic. No leverage correction is implied. | `ALREADY_IMPLEMENTED` |
| DHARMa scaled residual | simulated PIT on uniform scale; optional `qnorm()` transform by user | simulation sanity checks, especially complex models | DHARMa documentation; Warton et al. PIT logic | `DHARMa::simulateResiduals`; `DHARMa::getQuantile` | local DHARMa 0.4.7 source inspected via `getAnywhere()` | This is Monte Carlo PIT, not analytic CDF replay. It can diagnose simulation-calibrated models but is not an exact Dunn-Smyth analytic residual. | `NOT_A_QRESID_API_TARGET` |
| adjusted quantile residual | candidate adjustment to reduce finite-sample bias or improve GLM diagnostics | GLM routes only until proven otherwise | Scudilio and Pereira (2020), metadata known; full formulas not yet audited locally | candidate packages: `glmtoolbox::residuals2` if installed/audited | package not installed locally at gate creation | No implementation until paper formulas and R function code are both inspected. Need prove whether adjustment changes location, variance, leverage, or bias and whether it preserves intended null behavior. | `GATED_RESEARCH` |
| studentized/leverage-adjusted qresid | candidate form such as `r_i / sqrt(1-h_i)` only if derived for qresid, not borrowed from Pearson/deviance residuals | potentially Gaussian/GLM; not mixtures, hurdle, censored, external ML without route-specific hat values | no active qresid-specific reference in current masters | no accepted R reference yet | not found locally | Borrowing GLM Pearson/deviance standardization is mathematically insufficient for RQR. Requires route-specific derivation of variance of `Phi^{-1}(F_i(Y_i; theta_hat))` under estimated parameters. | `GATED_RESEARCH` |
| normalized residuals in GAMLSS | often randomized quantile residuals in standard normal scale, possibly with family-specific distribution functions | GAMLSS-style families | GAMLSS documentation to be audited if installed | `gamlss` residual functions | package not installed locally at gate creation | Treat as a candidate source for formulas and examples only after source-code and paper audit. | `GATED_RESEARCH` |
| topmodels probabilistic residuals | PIT/probability-scale residual infrastructure, with quantile residual variants | probabilistic model objects | `topmodels` documentation | `topmodels::qresiduals`; `topmodels::proresiduals` | package not installed locally at gate creation | Candidate for residual taxonomy and model-object design, not automatic proof of studentization. | `GATED_RESEARCH` |

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
- If a future adjusted variant is validated, use an explicit option name such as `adjusted` or `studentized`.
- Do not support adjusted/studentized variants for external, mixture, truncated, censored, hurdle, or weighted routes until a route-specific derivation and benchmark exist.
- Keep this gate synchronized with help, glossary, API docs, and changelog before any implementation.

## References And Sources To Audit

- Cox, D. R., and E. J. Snell. 1968. A general definition of residuals. *Journal of the Royal Statistical Society, Series B* 30: 248-275.
- Dunn, P. K., and G. K. Smyth. 1996. Randomized quantile residuals. *Journal of Computational and Graphical Statistics* 5(3): 236-244.
- Scudilio, J., and G. H. A. Pereira. 2020. Adjusted quantile residual for generalized linear models. *Computational Statistics* 35: 399-421.
- Warton, D. I., L. Thibaut, and Y. A. Wang. 2017. The PIT-trap. *PLOS ONE* 12(7): e0181790.
- `statmod::qresiduals`, local package version 1.5.1.
- `DHARMa::simulateResiduals` and `DHARMa::getQuantile`, local package version 0.4.7.
- `topmodels`, `glmtoolbox`, and `gamlss` are candidates for later local installation/source audit.
