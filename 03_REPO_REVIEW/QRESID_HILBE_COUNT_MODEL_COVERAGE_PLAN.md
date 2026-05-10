Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before count-model extension planning

# QRESID_HILBE_COUNT_MODEL_COVERAGE_PLAN.md

Date: 2026-05-10

POST_CHANGE_SYNC_DONE: count-model coverage plan updated after hurdle RQR theory gate creation; hurdle count remains gated because no Stata count-hurdle estimator route is accepted yet.
SUPPORT_MATRIX_SYNC_DONE: unified extension matrix, support matrix, glossary and registry were reconciled for count-model coverage terminology.

## Purpose

This plan defines how `qresid` should expand across count-data models discussed
in Stata, Stata Journal/SSC and Hilbe-style count-model workflows.

The controlling rule is simple:

- If Stata has an official estimator, `qresid` should support it as a
  postestimation residual tool only after extraction, support, CDF endpoints,
  PIT/RQR and benchmark or internal validation close.
- If Stata does not have an official estimator, `qresid` must not copy or
  replace the estimator. It may investigate a pinned external ado/source,
  license, PMF/CDF, parameters and benchmarks before any support claim.

Missing count families do not invalidate the current package unless `qresid`
claims to support them. Current public claims remain limited to the support
matrix.

## Validation Types

| validation_type | meaning | when acceptable |
|---|---|---|
| `R_EXACT_BENCHMARK` | Same model, parameters, support and CDF can be compared pointwise against R. | Gold standard for routes with a clear R equivalent. |
| `R_APPROX_BENCHMARK` | R has a comparable estimator/distribution but not an exact parameterization match. | Planning or secondary evidence only; requires caveats. |
| `STATA_INTERNAL_VALIDATION` | Official Stata route has no exact R equivalent; validate Stata extraction, CDF endpoints, PIT and residual invariants internally. | Acceptable for Stata-only variants if mathematically closed and labelled. |
| `STATA_EXTERNAL_ADO_VALIDATION` | User-written ado route; requires pinned source/version/license plus internal/external validation. | Only after source provenance and CDF are closed. |
| `GATED_MODEL_FAMILY` | Candidate family is not ready for implementation. | Default for unresolved count models. |
| `NO_OFFICIAL_STATA_COMMAND` | Stata has no official estimator for the family. | Research only unless an external route is pinned. |
| `NO_ACTION_REQUIRED` | Option does not change the residual distribution or support status. | Document only; no implementation work. |

## Official Stata Count Inventory

| model_group | stata_route | official_stata_command | qresid_current_status | validation_target | R_candidate | priority | action |
|---|---|---|---|---|---|---|---|
| Base count | `poisson`; `glm, family(poisson)` | yes | supported | `R_EXACT_BENCHMARK` | `stats::glm(family=poisson)` | maintain | Keep in prerelease and regression tests. |
| Negative binomial | `nbreg, dispersion(mean)` | yes | extension prerelease ready | `R_EXACT_BENCHMARK` | `MASS::glm.nb`, `pnbinom` | maintain | Maintain mean-dispersion, offset and exposure regression tests. |
| Negative binomial variants | `nbreg, dispersion(constant)` | yes | extension prerelease ready | `STATA_INTERNAL_VALIDATION` plus R CDF replay | `pnbinom` with row-specific size | maintain | Maintain `delta`, row-specific `theta=mu/delta`, endpoint and qres checks. |
| Generalized negative binomial | `gnbreg` | yes | extension prerelease ready | `STATA_INTERNAL_VALIDATION` plus R CDF replay | `pnbinom` with row-specific `theta_i=1/alpha_i` | maintain | Maintain observation-specific `alpha_i` extraction and CDF checks. |
| GLM negative binomial | `glm, family(nbinomial #)`; `glm, family(nbinomial ml)` | yes | fixed-parameter route ready; ML route gated variant | `R_EXACT_BENCHMARK` for fixed theta; research for ML | `MASS::negative.binomial(theta)` | high | Keep fixed theta supported; keep ML gated until robust estimated-parameter extraction is closed. |
| Zero-inflated count | `zip`; `zinb` | yes | extension prerelease ready | `STATA_INTERNAL_VALIDATION` plus R CDF replay | `VGAM`, `glmmTMB`, custom mixture CDF replay | maintain | Maintain mixture CDF extraction for `pi`, `mu`, `alpha/theta`, offset and exposure. |
| Truncated count | `tpoisson`; `tnbreg`; `ztp`; `ztnb` | yes | extension prerelease ready | `R_CDF_REPLAY` with official Stata extraction; `VGAM` estimator candidates documented | `VGAM::pospoisson`; `VGAM::posnegbinomial`; base R CDF replay | maintain | Maintain lower-truncation and tested upper-truncation endpoint checks. |
| Censored count | `cpoisson` | yes | extension prerelease ready | `STATA_INTERNAL_VALIDATION` plus R CDF replay | `VGAM::cens.poisson` candidate; base R CDF replay | maintain | Maintain left, right and two-sided censored interval PIT checks. |
| Population-averaged/panel | `popoisson`; `xpopoisson`; `xtpoisson`; `xtnbreg` | yes | future phase | `STATA_INTERNAL_VALIDATION` | route-specific | future | Requires panel/dependence design; do not mix with current IID-style claims. |
| Specialized official Poisson | `dspoisson`; `expoisson`; `etpoisson`; `heckpoisson`; `ivpoisson` | yes | future phase | `STATA_INTERNAL_VALIDATION` | route-specific | future | Treatment/selection/endogeneity structure needs separate residual policy. |
| Multilevel and mixtures | `mepoisson`; `menbreg`; `fmm: poisson`; `fmm: nbreg`; `fmm: tpoisson` | yes | future phase | `STATA_INTERNAL_VALIDATION` | `lme4`, `glmmTMB`, mixture packages | future | Conditional vs marginal CDF decision required before support. |

## External Or Hilbe-Style Count Families

| family | possible_stata_route | official_stata_command | R_candidate | current_status | validation_type | required_gate |
|---|---|---|---|---|---|---|
| Generalized Poisson | Stata Journal `gpoisson` / `st0279` pinned route; any other SSC/user route must be pinned separately | no | `VGAM::genpoisson0` positive-delta CDF check; analytic R CDF replay for all accepted routes; `glmmTMB::genpois` future approximate route | extension prerelease ready for pinned unweighted `st0279` route | `STATA_EXTERNAL_ADO_VALIDATION`; `R_CDF_REPLAY`; positive-delta `R_EXACT_BENCHMARK` against `VGAM::pgenpois0` | Maintain pinned-source notice; keep weights, `gp2`, unrelated GP ado routes and hurdle GP gated. |
| NB-P / alternative NB variants | `nbregp` or Stata Journal/user-written source if found | no | route-specific | gated model family | `STATA_EXTERNAL_ADO_VALIDATION` | Identify estimator, parameterization and CDF. |
| Hurdle Poisson/NB | external research if no official Stata count-hurdle estimator is identified; `churdle` is a separate Cragg continuous/bounded gate, not count-hurdle support | no official count route confirmed | `pscl::hurdle`; `glmmTMB` truncated count families plus zero component; `VGAM::zapoisson`, `VGAM::zanegbinomial`, positive-count families | gated model family with distribution-level CDF/PIT formulas documented | `NO_OFFICIAL_STATA_COMMAND` until source closes; possible `STATA_EXTERNAL_ADO_VALIDATION` | Pin/accept a Stata estimator route, then benchmark hurdle mass at zero and positive-count CDF before code. |
| Generalized Waring | external research | no | specialist packages/research code | gated model family | `NO_OFFICIAL_STATA_COMMAND` | Establish estimator and CDF source first. |
| Sichel / Poisson-inverse Gaussian | external research | no official route confirmed | R specialist packages | gated model family | `NO_OFFICIAL_STATA_COMMAND` | Pin source and PMF/CDF; avoid confusing with inverse Gaussian GLM. |
| COM-Poisson | external research | no | `COMPoissonReg`/other packages | gated model family | `NO_OFFICIAL_STATA_COMMAND` | Normalizing constant and CDF strategy required. |
| Double Poisson | external research | no | specialist packages/research code | gated model family | `NO_OFFICIAL_STATA_COMMAND` | PMF/CDF and validation design required. |
| Beta-binomial/count-binomial variants | external or official route audit needed | not claimed | `VGAM`, `aod`, other packages | gated model family | `NO_OFFICIAL_STATA_COMMAND` until source closes | Separate grouped-binomial semantics from beta-binomial overdispersion. |

## Workstreams

1. Official Stata count support:
   maintain `zip`, `zinb`, `tpoisson`, `tnbreg`, `ztnb`, `ztp`, `cpoisson`,
   and `gnbreg`. For each route inspect `e(cmd)`, `e()`, `predict`, support,
   offset/exposure, weights, ancillary parameters and CDF feasibility.

2. NB full expansion:
   maintain `nbreg, dispersion(mean)` offset/exposure; maintain accepted
   `dispersion(constant)`, `gnbreg`, and fixed-parameter
   `glm, family(nbinomial #)` routes; keep `glm, family(nbinomial ml)` and
   unsupported weighted NB variants as `GATED_VARIANT`.

3. Binreg/grouped binomial completion:
   complete `binreg, n()` aliases `or`, `rr`, `rd`; evaluate `hr` as Stata-only
   if no R link equivalent exists; keep grouped-binomial weights separate.

4. Generalized Poisson chapter:
   maintain Stata Journal `gpoisson` / `st0279` as the only validated external
   route; do not confuse it with unrelated local `gtools/gpoisson.ado`. The
   validated route uses the pinned GP-0 PMF/CDF, `mu = predict, n`, and
   `delta=e(delta)`. Other GP routes require a fresh source/version/license
   and CDF benchmark gate.

5. Hurdle count chapter:
   do not treat official `churdle` as count-hurdle support. The distribution
   formula is closed (`P(Y=0)=pi`, positive truncated CDF above zero), but
   implementation requires a Stata count-hurdle estimator route or pinned
   external ado, then benchmarks against `pscl`, `glmmTMB` or `VGAM` candidates.

6. Hilbe external models:
   create one research report per family and do not touch `qresid.ado` until
   source, CDF, metadata and benchmark strategy are closed.

## Required Datasets And Layers

Each supported route needs three datasets:

- synthetic controlled;
- official/Stata/Hilbe example or real-like;
- adversarial stable.

Each validation must compare:

- estimation sample;
- coefficients;
- fitted mean/probability;
- ancillary parameters;
- support validation;
- `F_low`;
- `F_high`;
- `U`;
- final qres.

## Release Interpretation

- Current package validity is not harmed by missing Hilbe/count models because
  they are not claimed.
- Public RC should not claim generalized Poisson, panel,
  mixture, multilevel or Hilbe external models until their gates close.
  Unweighted ZIP/ZINB is locally validated for extension prerelease only, not a
  public RC claim.
- The support matrix answers "what can I use now"; the unified extension matrix
  answers "what exists in Stata/R and what would be needed next."
