Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before count-model extension planning

# QRESID_HILBE_COUNT_MODEL_COVERAGE_PLAN.md

Date: 2026-05-10

POST_CHANGE_SYNC_DONE: count-model coverage plan created and registered as a live extension-planning reference.
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
| Negative binomial | `nbreg, dispersion(mean)` | yes | experimental validated local | `R_EXACT_BENCHMARK` | `MASS::glm.nb`, `pnbinom` | high | Complete offset/exposure and variant audit before stable claim. |
| Negative binomial variants | `nbreg, dispersion(constant)` | yes | gated variant | `STATA_INTERNAL_VALIDATION` or `R_APPROX_BENCHMARK` | no exact default identified | high | Close alpha/theta/k and CDF semantics before implementation. |
| Generalized negative binomial | `gnbreg` | yes | gated variant | `STATA_INTERNAL_VALIDATION` | custom/VGAM-style research only | high | Evaluate observation-specific `alpha_i` and CDF feasibility. |
| GLM negative binomial | `glm, family(nbinomial #|ml)` | yes | gated variant | `R_EXACT_BENCHMARK` for fixed theta; research for ML | `MASS::negative.binomial(theta)` | high | Map parameter extraction and fitted CDF before support. |
| Zero-inflated count | `zip`; `zinb` | yes | missing not blocking | `R_EXACT_BENCHMARK` or `R_APPROX_BENCHMARK` | `pscl`, `VGAM`, `glmmTMB` | future | Derive mixture CDF and extraction gate. |
| Truncated count | `tpoisson`; `tnbreg`; `ztp`; `ztnb` | yes | missing not blocking | `R_EXACT_BENCHMARK` or `STATA_INTERNAL_VALIDATION` | `VGAM`, `countreg`, custom CDF | future | Validate truncated support and endpoints. |
| Censored count | `cpoisson` | yes | missing not blocking | `STATA_INTERNAL_VALIDATION` | no exact base R equivalent identified | future | Define censored CDF interval semantics before support. |
| Population-averaged/panel | `popoisson`; `xpopoisson`; `xtpoisson`; `xtnbreg` | yes | future phase | `STATA_INTERNAL_VALIDATION` | route-specific | future | Requires panel/dependence design; do not mix with current IID-style claims. |
| Specialized official Poisson | `dspoisson`; `expoisson`; `etpoisson`; `heckpoisson`; `ivpoisson` | yes | future phase | `STATA_INTERNAL_VALIDATION` | route-specific | future | Treatment/selection/endogeneity structure needs separate residual policy. |
| Multilevel and mixtures | `mepoisson`; `menbreg`; `fmm: poisson`; `fmm: nbreg`; `fmm: tpoisson` | yes | future phase | `STATA_INTERNAL_VALIDATION` | `lme4`, `glmmTMB`, mixture packages | future | Conditional vs marginal CDF decision required before support. |

## External Or Hilbe-Style Count Families

| family | possible_stata_route | official_stata_command | R_candidate | current_status | validation_type | required_gate |
|---|---|---|---|---|---|---|
| Generalized Poisson | `gnpoisson` SSC/Stata Journal candidate | no | `VGAM::genpoisson` | gated model family | `STATA_EXTERNAL_ADO_VALIDATION`; possible `R_EXACT_BENCHMARK` | Pin source/version/license; verify PMF/CDF/support. |
| NB-P / alternative NB variants | `nbregp` or Stata Journal/user-written source if found | no | route-specific | gated model family | `STATA_EXTERNAL_ADO_VALIDATION` | Identify estimator, parameterization and CDF. |
| Hurdle Poisson/NB | external research if no official Stata estimator is identified | no official route confirmed | `pscl`, `VGAM`, `countreg`/other packages | gated model family | `NO_OFFICIAL_STATA_COMMAND` until source closes | Separate hurdle mass at zero from positive-count CDF before support. |
| Generalized Waring | external research | no | specialist packages/research code | gated model family | `NO_OFFICIAL_STATA_COMMAND` | Establish estimator and CDF source first. |
| Sichel / Poisson-inverse Gaussian | external research | no official route confirmed | R specialist packages | gated model family | `NO_OFFICIAL_STATA_COMMAND` | Pin source and PMF/CDF; avoid confusing with inverse Gaussian GLM. |
| COM-Poisson | external research | no | `COMPoissonReg`/other packages | gated model family | `NO_OFFICIAL_STATA_COMMAND` | Normalizing constant and CDF strategy required. |
| Double Poisson | external research | no | specialist packages/research code | gated model family | `NO_OFFICIAL_STATA_COMMAND` | PMF/CDF and validation design required. |
| Beta-binomial/count-binomial variants | external or official route audit needed | not claimed | `VGAM`, `aod`, other packages | gated model family | `NO_OFFICIAL_STATA_COMMAND` until source closes | Separate grouped-binomial semantics from beta-binomial overdispersion. |

## Workstreams

1. Official Stata count support:
   prioritize `zip`, `zinb`, `tpoisson`, `tnbreg`, `ztnb`, `ztp`, `cpoisson`,
   then `gnbreg`. For each route inspect `e(cmd)`, `e()`, `predict`, support,
   offset/exposure, weights, ancillary parameters and CDF feasibility.

2. NB full expansion:
   complete `nbreg, dispersion(mean)` offset/exposure; investigate
   `dispersion(constant)`; evaluate `gnbreg`; evaluate `glm, family(nbinomial
   #|ml)`; keep unsupported variants as `GATED_VARIANT`.

3. Binreg/grouped binomial completion:
   complete `binreg, n()` aliases `or`, `rr`, `rd`; evaluate `hr` as Stata-only
   if no R link equivalent exists; keep grouped-binomial weights separate.

4. Generalized Poisson chapter:
   verify `gnpoisson` source through SSC/Stata Journal or official archive; do
   not confuse it with unrelated local `gtools/gpoisson.ado`; map to
   `VGAM::genpoisson` only after PMF/CDF/support match.

5. Hilbe external models:
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
- Public RC should not claim generalized Poisson, zero-inflated, truncated,
  censored, panel, mixture, multilevel or Hilbe external models until their
  gates close.
- The support matrix answers "what can I use now"; the unified extension matrix
  answers "what exists in Stata/R and what would be needed next."
