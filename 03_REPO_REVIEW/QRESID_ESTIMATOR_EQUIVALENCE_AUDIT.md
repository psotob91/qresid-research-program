Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before external/count estimator benchmarks or CDF replay claims

# QRESID_ESTIMATOR_EQUIVALENCE_AUDIT.md

Date: 2026-05-10

POST_CHANGE_SYNC_DONE: estimator equivalence gate created for generalized Poisson and hurdle count decisions.
SUPPORT_MATRIX_SYNC_DONE: no support claim changed; this audit explains the evidence threshold behind current generalized Poisson readiness and hurdle gating.
SUPPORT_EVIDENCE_INDEX_SYNC: existing evidence index remains the execution source; this audit adds interpretation and prerequisites.

## Purpose

Before `qresid` treats an external or route-specific estimator as ready for
extension prerelease, the estimator must pass one of two evidence paths:

1. `ESTIMATOR_EQUIVALENT`: Stata and R estimate the same model under a closed
   parameterization, so coefficients and fitted distribution layers can be
   compared directly.
2. `CDF_REPLAY_ONLY`: the R estimator is not pointwise equivalent or is not
   available, but Stata exports all fitted-distribution parameters and R can
   replay `F_low`, `F_high`, `U`, and qres from cited mathematical formulas.

If neither path closes, the route stays `GATED_MODEL_FAMILY` or
`GATED_VARIANT`. A simulation diagnostic such as DHARMa can be a sanity check,
but it is not a substitute for analytic CDF endpoint validation.

## Equivalence Decisions

| route | stata_command_or_source | r_estimator_package_function | r_pit_rqr_package_function | estimator_equivalence | cdf_replay_possible | decision | notes |
|---|---|---|---|---|---|---|---|
| generalized Poisson GP-0 | pinned Stata Journal `st0279` / `gpoisson` (`gpoisson.ado` 1.1.0, `gpois_lf.ado` 1.0.0) | `VGAM::genpoisson0` / `VGAM::pgenpois0`; `glmmTMB::genpois` approximate candidate | manual generalized-Poisson CDF replay; Dunn-Smyth with `uvar()` | `PARTIAL`: positive-delta CDF matches `VGAM::pgenpois0`; estimator-level equality is not claimed for all routes | yes | `READY_FOR_EXTENSION_PRERELEASE` for pinned unweighted route | Stata estimates `mu` and `delta`; R recomputes endpoints from pinned PMF/CDF. |
| generalized Poisson weights / `gp2` / other GP ado routes | unpinned or unvalidated Stata routes | route-specific | none established | no | not closed | `GATED_VARIANT` | Requires separate source, license, PMF/CDF and extraction audit. |
| hurdle count Poisson | no accepted Stata count-hurdle route yet | `pscl::hurdle(..., dist="poisson")`; `glmmTMB(..., family=truncated_poisson, ziformula=...)`; `VGAM` zero-altered/positive Poisson candidates | `topmodels::qresiduals` candidate; manual hurdle CDF replay after Stata route closes | not testable yet | mathematically yes after `pi` and positive-count parameters are extracted | `GATED_MODEL_FAMILY` | Theory is sufficient, but Stata estimator/source and extractor are not closed. |
| hurdle count negative binomial | no accepted Stata count-hurdle route yet | `pscl::hurdle(..., dist="negbin")`; `glmmTMB(..., family=truncated_nbinom2, ziformula=...)`; `VGAM` zero-altered/positive NB candidates | `topmodels::qresiduals` candidate; manual hurdle CDF replay after Stata route closes | not testable yet | mathematically yes after `pi`, `mu`, and `theta/alpha` are extracted | `GATED_MODEL_FAMILY` | Theory is sufficient, but Stata estimator/source and extractor are not closed. |
| Stata `churdle` Cragg | official Stata `churdle` | route-specific Cragg/two-part R candidates needed | manual continuous/interval PIT only after route closure | separate model class | route-specific | `GATED_MODEL_FAMILY` | `churdle` is not count hurdle Poisson/NB support. |

## Generalized Poisson Parameterization

The accepted route is the pinned Stata Journal `st0279` generalized Poisson
command. The pinned likelihood uses

`P(Y=y) = (1-delta)*mu * ((1-delta)*mu + delta*y)^(y-1) * exp(-((1-delta)*mu + delta*y)) / y!`

where `mu = predict, n` and `delta = e(delta)`. Equivalently, this maps to the
original GP-0 notation with

- `theta = (1-delta)*mu`;
- `lambda = delta`;
- `E(Y)=mu`.

For positive `delta`, `VGAM::pgenpois0(q, theta=(1-delta)*mu, lambda=delta)`
has already matched the replayed CDF to machine precision in the existing
benchmark. For negative `delta`, the route remains valid through analytic
R CDF replay from the same PMF, because the required finite-support endpoint
calculation is closed and exported Stata parameters are sufficient.

## Hurdle Count Theory

The hurdle-count RQR target is mathematically closed once a fitted Stata route
provides the zero-process probability and positive-count distribution
parameters:

- `P(Y=0)=pi_i`;
- if `y>0`, `F_i(y)=pi_i+(1-pi_i)*F_plus_i(y)`;
- if `y=0`, `F_low=0`, `F_high=pi_i`;
- if `y>0`, `F_low=pi_i+(1-pi_i)*F_plus_i(y-1)`;
- if `y>0`, `F_high=pi_i+(1-pi_i)*F_plus_i(y)`;
- `U_i=F_low+V_i*(F_high-F_low)`, with `V_i ~ Uniform(0,1)`.

This is a direct Dunn-Smyth randomized PIT construction for a discrete
distribution with an atom at zero. It is not enough by itself for `qresid`
support: the Stata estimator route must still be accepted or pinned.

## Evidence Sources

- Harris, T., Z. Yang, and J. W. Hardin. 2012. Modeling underdispersed count data with generalized Poisson regression. Stata Journal 12(4): 736-747. https://doi.org/10.1177/1536867X1201200412
- `VGAM::genpois0UC`: https://rdrr.io/cran/VGAM/man/genpois0UC.html
- `pscl::hurdle`: https://search.r-project.org/CRAN/refmans/pscl/html/hurdle.html
- Zeileis, A., C. Kleiber, and S. Jackman. Regression Models for Count Data in R. https://rdrr.io/cran/pscl/f/inst/doc/countreg.pdf
- `glmmTMB`: https://glmmtmb.github.io/glmmTMB/reference/glmmTMB.html
- Dunn, P. K., and G. K. Smyth. 1996. Randomized quantile residuals.
- `topmodels::qresiduals`: https://rdrr.io/rforge/topmodels/man/qresiduals.html

## Release Interpretation

Generalized Poisson is ready only for the pinned, unweighted `st0279/gpoisson`
postestimation route and must keep its external-estimator dependency notice.
Hurdle count remains `MISSING_NOT_BLOCKING` and `GATED_MODEL_FAMILY`: the
residual theory is not the blocker; the missing Stata estimator/source and
extractor closure are.

