Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before changing `R_CDF_REPLAY`, `STATA_INTERNAL_VALIDATION`, CDF/PIT/RQR support claims, or evidence matrices

# QRESID_R_CDF_REPLAY_THEORY_AUDIT.md

Date: 2026-05-10

POST_CHANGE_SYNC_DONE: replay-theory audit created and registered.
SUPPORT_MATRIX_SYNC_DONE: validation-type promotions reconciled with the support matrix, unified matrix and GLM/link evidence report.
SUPPORT_EVIDENCE_INDEX_SYNC: evidence index normalizes promoted replay routes.
VISUAL_BADGE_SYNC: HTML reports retain status badges.

## Purpose

This audit separates two evidence levels:

- `STATA_INTERNAL_VALIDATION`: Stata-only invariants pass, but R has not independently recomputed the CDF/PIT/qres layer.
- `R_CDF_REPLAY`: R recomputes `F_low`, `F_high`, `U`, and qres from Stata-exported fitted distribution parameters. R does not need to estimate the same model, but the CDF formula, support and parameter extraction must be mathematically closed and cited.

The general RQR justification is Dunn and Smyth (1996): continuous residuals use `U_i = F_i(y_i)` and `r_i = Phi^{-1}(U_i)`; discrete residuals use `U_i = F_i(y_i-) + V_i [F_i(y_i)-F_i(y_i-)]`, with `V_i ~ Uniform(0,1)`. This is also the basis of `statmod::qresiduals` and `topmodels::qresiduals`/`proresiduals`.

## Replay Theory Matrix

| route | current_validation_type | candidate_validation_type | cdf_formula | pit_rqr_formula | stata_parameters_needed | r_replay_function | math_reference | software_reference | decision |
|---|---|---|---|---|---|---|---|---|---|
| `binreg_hr` grouped binomial | `STATA_INTERNAL_VALIDATION` / historical `STATA_INTERNAL_VALID` | `R_CDF_REPLAY` | `Y_i ~ Binomial(m_i,p_i)`; `F_low=pbinom(y_i-1,m_i,p_i)`, `F_high=pbinom(y_i,m_i,p_i)` | Dunn-Smyth discrete interval with shared `uvar()` | `y_i`, `m_i=e(m)`, Stata `predict, mu` normalized to `p_i`, `V_i` | R `pbinom()` replay | Dunn and Smyth 1996; grouped-binomial GLM likelihood; qresid grouped-binomial research | Stata `binreg, n()`/`glm binomial`; R `stats::glm(..., family=binomial)` for comparable links; `statmod::qresiduals` convention | Promote to `R_CDF_REPLAY`; no R estimator-equivalence claim for HR link, only endpoint replay from Stata `p_i`. |
| `gnbreg` | `STATA_INTERNAL_VALIDATION` | `R_CDF_REPLAY` | Observation-specific NB2: `Y_i ~ NB(mu_i, theta_i)`, `theta_i=1/alpha_i`; endpoints via `pnbinom(size=theta_i, mu=mu_i)` | Dunn-Smyth discrete interval with shared `uvar()` | `y_i`, `mu_i=predict n`, `alpha_i=predict alpha`, `theta_i=1/alpha_i`, `V_i` | R `pnbinom()` replay | Dunn and Smyth 1996; Stata `gnbreg` variance model; NB PMF/CDF | Stata `gnbreg`; R `stats::pnbinom`; `MASS::negative.binomial` family convention | Promote to `R_CDF_REPLAY`; no R estimator-equivalence claim for observation-specific alpha. |
| `nbreg, dispersion(constant)` | `STATA_INTERNAL_VALIDATION` | `R_CDF_REPLAY` | NB1-style constant dispersion: benchmark exports route-specific `theta_i`; endpoints via `pnbinom(size=theta_i, mu=mu_i)` | Dunn-Smyth discrete interval with shared `uvar()` | `y_i`, `mu_i=predict n`, route-specific `alpha/delta`, `theta_i`, `V_i` | R `pnbinom()` replay | Dunn and Smyth 1996; Stata `nbreg, dispersion(constant)` documentation; NB PMF/CDF | Stata `nbreg`; R `stats::pnbinom`; `MASS` NB conventions | Promote to `R_CDF_REPLAY` for endpoint replay only; keep estimator-level R exact benchmark unclaimed. |
| `cpoisson` | `STATA_INTERNAL_VALIDATION` | `R_CDF_REPLAY` | Uncensored: Poisson endpoints. Left-censored at `L`: `[0,F(L)]`; right-censored at `U`: `[F(U-1),1]`; interval-censored uses `[F(L),F(U)]`/route-specific Stata interval | Interval PIT: sample uniformly inside the censoring CDF interval, then `qnorm(U)` | `y_i`, `mu_i=predict n`, `ll()`, `ul()`, censoring side, `V_i` | R `ppois()` interval replay | Dunn and Smyth 1996 interval-PIT logic; censored-data PIT/Cox-Snell residual logic; Stata `cpoisson` docs | Stata `cpoisson`; VGAM `cens.poisson` as software reference; R `stats::ppois` | Promote to `R_CDF_REPLAY`; exact estimator benchmark remains unclaimed. |
| ZIP/ZINB | `R_CDF_REPLAY` | `R_CDF_REPLAY` | `F(y)=pi_i+(1-pi_i)F_count(y;mu_i,theta_i)` for `y>=0`, with `F_low(0)=0` | Dunn-Smyth discrete interval with shared `uvar()` | `pi_i`, `mu_i`, `theta_i` for ZINB, `V_i` | R mixture replay using `ppois()`/`pnbinom()` | Dunn and Smyth 1996; mixture-distribution CDF; Stata ZIP/ZINB docs | Stata `zip`/`zinb`; VGAM/glmmTMB/topmodels candidates | Keep `R_CDF_REPLAY`; theory closed for unweighted accepted routes. |
| Truncated count | `R_CDF_REPLAY` | `R_CDF_REPLAY` | Conditional CDF on truncated support: `(F(y)-F(L))/(F(U)-F(L))` with zero-truncation as a special case | Dunn-Smyth discrete interval on conditional support with shared `uvar()` | support limits, `mu_i`, `theta_i` where NB, `V_i` | R conditional replay using `ppois()`/`pnbinom()` | Dunn and Smyth 1996; conditional distribution theory; Stata truncation docs | Stata `tpoisson`/`tnbreg`/`ztp`/`ztnb`; VGAM positive-count families | Keep `R_CDF_REPLAY`; route-specific weights/variants remain gated. |
| Generalized Poisson `st0279/gpoisson` | `R_CDF_REPLAY` | `R_CDF_REPLAY` | Pinned Stata Journal generalized Poisson PMF/CDF, replayed by cumulative PMF over support | Dunn-Smyth discrete interval with shared `uvar()` | `mu_i`, dispersion parameter, support, `V_i` | R analytic cumulative PMF replay; VGAM `pgenpois0` reference where aligned | Dunn and Smyth 1996; Stata Journal st0279 generalized Poisson source | Pinned `st0279/gpoisson`; VGAM generalized-Poisson functions | Keep `R_CDF_REPLAY`; external source/version/license pinning remains required. |
| `fweight` expanded families | `R_CDF_REPLAY; frequency expansion benchmark` | `R_CDF_REPLAY` | Same family CDF as unweighted fit, evaluated at weighted-fit parameters; fweight interpreted as row frequency/replication | Family-specific PIT/RQR; no final residual multiplier | weighted-fit fitted distribution parameters, `V_i` where discrete | family-specific replay (`pbinom`, `pnbinom`, `pgamma`, inverse Gaussian CDF) | Dunn and Smyth 1996; frequency-weight equivalence by row expansion | Stata fweight semantics; R expanded-data/family CDF replay | Keep `R_CDF_REPLAY`; do not generalize to pweight/aweight/iweight. |
| Direct `[pweight=]` diagnostic | `STATA_ONLY_DIAGNOSTIC` | `STATA_ONLY_DIAGNOSTIC` | Model-based fitted CDF can be computed, but design weights do not define a simple individual sampling distribution for exact RQR | Diagnostic PIT/RQR only | Stata weighted fit and predicted distribution | none exact | survey/design-weight theory requires separate policy | Stata direct pweight; R `survey` future gate | Do not promote; blocks public RC policy if claimed publicly. |

## Decisions

- Promoted to `R_CDF_REPLAY`: `binreg_hr`, `gnbreg`, `nbreg, dispersion(constant)`, `cpoisson`.
- Kept as `R_CDF_REPLAY`: ZIP/ZINB, truncated count, generalized Poisson, fweight expanded routes, NB mean/fixed routes.
- Kept as diagnostic only: direct `[pweight=]`.
- No route in the current evidence index remains `STATA_INTERNAL_VALIDATION` for a ready/prerelease route after this audit.

## References

- Dunn, P. K., and G. K. Smyth. 1996. Randomized Quantile Residuals. Journal of Computational and Graphical Statistics 5(3): 236-244. https://gksmyth.github.io/pubs/residual.pdf
- `statmod::qresiduals`, R documentation. https://search.r-project.org/CRAN/refmans/statmod/html/qresiduals.html
- `topmodels::qresiduals`, R documentation. https://rdrr.io/rforge/topmodels/man/qresiduals.html
- `topmodels::proresiduals`, R documentation. https://topmodels.r-forge.r-project.org/reference/proresiduals.html
- `VGAM::cens.poisson`, R documentation. https://rdrr.io/cran/VGAM/man/cens.poisson.html
- Stata local manuals/help for `binreg`, `nbreg`, `gnbreg`, `cpoisson`, `zip`, `zinb`, `tpoisson`, `tnbreg`, `ztp`, and `ztnb`.

