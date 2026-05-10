Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load for support, release and feature-status questions

# QRESID_CURRENT_FEATURE_SUPPORT_MATRIX.md

Date: 2026-05-10

Status source: inverse Gaussian, expanded fweight, NB2 offset/exposure, NB variants, zero-inflated count, truncated count, censored count, grouped-binomial/binreg validation cycle plus Hilbe/count model coverage reconciliation and pinned `st0279` generalized Poisson validation, 2026-05-10. See `QRESID_IGAUSSIAN_FWEIGHT_EXTENSION_AUDIT.md` for IG/fweight logs, `QRESID_COUNT_MODEL_EXTENSION_EXECUTION_AUDIT.md` for NB/grouped-binomial logs, `QRESID_NB_ZEROINFLATED_EXTENSION_AUDIT.md` for NB variants and ZIP/ZINB logs, `QRESID_TRUNCATED_COUNT_RESEARCH.md` and `QRESID_CENSORED_COUNT_RESEARCH.md` for truncated/censored count logs, `QRESID_GENPOISSON_EXTENSION_AUDIT.md` for generalized Poisson logs, and `QRESID_HILBE_COUNT_MODEL_COVERAGE_PLAN.md` for count-model roadmap scope.

POST_CHANGE_SYNC_DONE: feature support matrix created and registered as a live status reference.
SUPPORT_MATRIX_SYNC_DONE: matrix and searchable HTML are synchronized with the support glossary.

## Purpose

This matrix answers whether each feature is ready, experimental, diagnostic
only, missing but non-blocking, or blocking. It is designed to make package
validity easy to assess: missing inverse Gaussian, Tweedie or Phase 2 models do
not invalidate the current package because they are not claimed as supported.

Read this matrix together with the GLM/link evidence report. If the GLM/link
report says `EXPERIMENTAL_VALIDATED_SEPARATE_BENCHMARK`, the route is supported
or experimental in `qresid` but its detailed evidence lives in another active
benchmark report. `GATED_VARIANT` means a specific variant remains unclaimed; it
does not cancel a validated base route.

Cross-report rule: the support matrix is the quick answer to "what can I use?";
the GLM/link report now exposes `evidence_scope` and `evidence_artifact` so a
viewer can see whether evidence was generated in that report (`THIS_REPORT`) or
validated in a separate benchmark (`SEPARATE_BENCHMARK`). The two reports are
complementary, not competing authorities.

Count-model roadmap rule: the unified extension matrix
`qresid_unified_extension_matrix.html` is the quick answer to "what exists in
Stata/R or Hilbe-style count workflows, and what validation would be required
next?" It does not expand support claims by itself. Missing official or
external count-model routes remain `MISSING_NOT_BLOCKING` or
`GATED_MODEL_FAMILY` unless a support row below says otherwise.

## Matrix

| feature_group | stata_command | link_function | weights | offset_exposure | dispersion_parameters | implemented_in_qresid | stata_tests | r_equivalent | r_benchmark_status | public_claim_status | validity_for_current_package | plain_language_summary | next_action |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Gaussian | `regress`; `glm, family(gaussian)` | identity; GLM identity/log/inverse where estimable | none | not central | sigma/scale from fitted model | yes | PASS | `lm`, `glm(gaussian)`, `statmod` | PASS | claimed | READY_FOR_EXTENSION_PRERELEASE | You can use this now within the current prerelease scope. | Public RC audit only. |
| Poisson | `poisson`; `glm, family(poisson)` | log; GLM log/identity/sqrt where estimable | none | log-link offset/exposure tested | none | yes | PASS | `glm(poisson)`, `statmod` | PASS | claimed | READY_FOR_EXTENSION_PRERELEASE | You can use this now; offset/exposure has tested log-link coverage. | Public RC audit only. |
| Bernoulli individual | `logit`; `logistic`; individual `glm, family(binomial)`; individual `binreg` | logit/probit/cloglog/log/identity where supported | none | not central | none | yes | PASS | `glm(binomial)`, `statmod` | PASS | claimed | READY_FOR_EXTENSION_PRERELEASE | You can use individual Bernoulli routes now. | Public RC audit only. |
| Grouped binomial | `glm, family(binomial trials)`; `binreg, n(trials)` aliases `or`/`rr`/`rd`; `binreg hr` Stata-internal | GLM logit/probit/cloglog/log/identity; binreg logit/log/identity; hr log-complement internal | none | not central | trials from `e(m)` | yes | PASS | `glm(cbind(success,failure), binomial)` for GLM and `or`/`rr`/`rd`; no base-R exact link for `hr` | PASS; `hr` STATA_INTERNAL_VALIDATION | claimed experimental | READY_FOR_EXTENSION_PRERELEASE | Grouped binomial GLM and main binreg aliases are ready for local extension prerelease; `hr` is Stata-internal only. | Keep weighted grouped-binomial variants gated until separate weight benchmark. |
| Negative binomial | `nbreg, dispersion(mean)`; `nbreg, dispersion(constant)`; `gnbreg`; fixed-parameter `glm, family(nbinomial #)` | default/log for official count estimators | none; tested direct `fweight` separately for supported routes | `nbreg mean`, `zip`, and `zinb` count-component offset/exposure tested; NB variant offset/exposure beyond tested routes remains gated | `alpha`; `delta`; observation-specific `alpha_i`; fixed GLM alpha; `theta=1/alpha` where applicable | yes | PASS | `MASS::glm.nb`, `MASS::negative.binomial(theta)`, `pnbinom` CDF replay; Stata-internal validation for route-specific variants | PASS | claimed experimental | READY_FOR_EXTENSION_PRERELEASE | NB mean, constant-dispersion, generalized NB, and fixed-parameter GLM NB routes are ready for local extension prerelease. | Keep `glm nbinomial ml`, NB weights beyond tested fweight, and untested NB variants gated. |
| Gamma | `glm, family(gamma)` | log/inverse/identity where estimable | none; `fweight` experimental | not central | phi/shape/scale from GLM | yes | PASS | `glm(Gamma)`, `statmod` | PASS | claimed | READY_FOR_EXTENSION_PRERELEASE | You can use unweighted Gamma routes; direct fweight Gamma is experimental validated local. | Public RC audit only. |
| inverse Gaussian | `glm, family(igaussian)` | `power -2`; log; identity; `power -1` where estimable | none; tested `fweight` routes separately | not central | phi/lambda from GLM; lambda = 1/phi | yes | PASS | `glm(inverse.gaussian)`, closed-form CDF check | PASS | claimed extension prerelease | READY_FOR_EXTENSION_PRERELEASE | You can use tested inverse Gaussian routes in the local extension prerelease. | Public RC audit only; keep untested links/weights gated. |
| fweight expanded families | `regress`; `poisson`; Bernoulli; grouped binomial; `nbreg`; Gamma; inverse Gaussian | tested links by family | `fweight` | Poisson log-link as tested | family-specific fitted distribution | yes | PASS | expansion/R CDF checks for tested routes | PASS | claimed extension prerelease | READY_FOR_EXTENSION_PRERELEASE | Direct fweight works for tested listed routes; no final weight multiplier is applied. | Do not generalize to aweight/iweight/pweight/svy or unsupported weighted routes. |
| pweight direct Gaussian/Poisson/Bernoulli | direct `[pweight=]` fits, no `svy:` | model links above | `pweight` | not central | model-based fitted distribution | partial | PASS | no exact R base equivalent | STATA_ONLY_DIAGNOSTIC | claimed experimental diagnostic | DIAGNOSTIC_ONLY | Useful as Stata model-based diagnostic; not survey-exact support. | Human policy decision before public RC. |
| Tweedie | not implemented | future GLM links | none | not claimed | power/dispersion and CDF approximation pending | no | N/A | `statmod`, `tweedie` | NOT_RUN | not_claimed | MISSING_NOT_BLOCKING | R has routes, but qresid does not claim Tweedie yet; package validity is not affected. | Open Tweedie CDF benchmark gate. |
| Official zero-inflated count | `zip`; `zinb` | official log count route with logit/probit inflation as estimated by Stata | none | count-component `offset()` and `exposure()` tested | mixture CDF; `pi`; Poisson mean; ZINB `alpha/theta` | yes | PASS | `VGAM`/`glmmTMB` route candidates; exact CDF replay with exported Stata parameters | PASS | claimed experimental | READY_FOR_EXTENSION_PRERELEASE | You can use unweighted `zip` and `zinb` in the local extension prerelease; CDF endpoints include the zero-inflation mass. | Keep zero-inflated weights, hurdle, truncated, censored and correlated/mixture extensions gated. |
| Official truncated count | `tpoisson`; `tnbreg`; `ztp`; `ztnb` | count links by official estimator | none | unweighted routes only; no weights | lower truncation CDF endpoints; `tpoisson` constant upper truncation tested | yes | PASS | `VGAM` route candidates; exact R CDF replay with exported Stata parameters | PASS | claimed experimental | READY_FOR_EXTENSION_PRERELEASE | You can use unweighted official truncated count routes in the local extension prerelease; endpoints are conditional on the observed truncation support. | Keep weighted truncated routes and untested truncation variants gated. |
| Official censored count | `cpoisson` | count route by official estimator | none | unweighted routes only; no weights | censored interval PIT endpoints for left, right and two-sided censoring | yes | PASS | `VGAM::cens.poisson` candidate; exact R CDF replay with exported Stata parameters | PASS | claimed experimental | READY_FOR_EXTENSION_PRERELEASE | You can use unweighted `cpoisson` in the local extension prerelease; censored observations use interval PIT endpoints. | Keep weighted censored routes and non-Poisson censored counts gated. |
| Generalized Poisson | pinned Stata Journal `st0279` / `gpoisson` | log mean route from external estimator | none | external estimator `offset()`/`exposure()` accepted by `gpoisson`, but only no-offset benchmark is ready | `delta=e(delta)`; GP-0 PMF/CDF with `theta=(1-delta)*mu` | yes | PASS | `VGAM::pgenpois0` for positive delta; analytic R CDF replay for all accepted routes | PASS | claimed extension prerelease with external-estimator dependency | READY_FOR_EXTENSION_PRERELEASE | You can use `qresid` after unweighted pinned `gpoisson` fits if `st0279` is installed; qresid does not include the estimator. | Keep `gpoisson` weights, `gp2`, other GP ado routes, and hurdle GP gated. |
| Specialized official count | `popoisson`; `xpopoisson`; `dspoisson`; `expoisson`; `etpoisson`; `heckpoisson`; `ivpoisson`; `xtpoisson`; `xtnbreg`; `mepoisson`; `menbreg`; `fmm:` count routes | route-specific | none | not claimed | conditional/marginal/treatment/selection/mixture CDF unresolved | no | N/A | route-specific R candidates | NOT_RUN | not_claimed | MISSING_NOT_BLOCKING | These official Stata commands are not current qresid support. Their absence is not a validity problem. | Create separate residual-policy gates per estimator class. |
| External Hilbe-style counts still gated | hurdle Poisson/NB; NB-P; generalized Waring; Sichel/PIG; COM-Poisson; double Poisson; beta-binomial variants; non-pinned generalized Poisson routes | route-specific | none | not claimed | external source, license, PMF/CDF and metadata pending | no | N/A | `glmmTMB`/`VGAM` hurdle candidates, `glmmTMB::genpois` for future approximate GP work, and family-specific packages where available | NOT_RUN | not_claimed | MISSING_NOT_BLOCKING | These remain research candidates only; qresid should not copy or replace external estimators. | Pin source/version/license and close PMF/CDF/R mapping gates before code. |
| Mixed/GLMM/GSEM | not implemented | future conditional/simulated residuals | none | not claimed | conditional or simulated PIT unresolved | no | N/A | `lme4`, `glmmTMB`, `DHARMa` | NOT_RUN | not_claimed | MISSING_NOT_BLOCKING | Complex dependent models are outside the current package claims. | Future simulation/conditional CDF design. |
| aweight/iweight | tested as gated | not applicable | `aweight`, `iweight` | not claimed | semantics unresolved | no | gated | partial/no exact equivalent by route | NOT_RUN | gated | MISSING_NOT_BLOCKING | These weights are not supported; absence is not a validity problem. | Separate weights research if desired. |
| svy | not implemented | survey framework | survey weights/design | not claimed | design-based diagnostics unresolved | no | N/A | R `survey` diagnostics possible | NOT_RUN | not_claimed | MISSING_NOT_BLOCKING | `svy:` is not supported and not promised. | Human design decision before any support. |
| unsupported weighted routes | routes outside tested fweight and direct pweight diagnostic scope | route-specific | `aweight`, `iweight`, `svy:`, NB p/a/iweight, grouped-binomial p/a/iweight | not claimed | unresolved | no | gated | not established | NOT_RUN | not_claimed | MISSING_NOT_BLOCKING | Missing but not promised; tested fweight routes are listed separately. | Separate weights research if desired. |
| pweight public policy | `[pweight=]` diagnostic routes | model links above | `pweight` | not `svy:` | model-based only | partial | PASS | STATA_ONLY_DIAGNOSTIC | STATA_ONLY_DIAGNOSTIC | claimed experimental diagnostic | BLOCKS_PUBLIC_RC | This does not block local prerelease, but public RC needs a human policy decision. | Decide include/hide/split pweight diagnostic. |

## Validity Summary

- Current local extension prerelease validity: acceptable.
- `BLOCKS_CURRENT_VALIDITY`: none.
- `BLOCKS_PUBLIC_RC`: pweight public policy.
- Missing Tweedie, specialized official count routes,
  external Hilbe-style count models, mixed models, `svy:`, `aweight`,
  `iweight`, `glm nbinomial ml`, and unsupported weighted routes do not invalidate the package
  because current public docs do not claim support for them.

## Footnote

PIT transforms an observation through the fitted CDF to the uniform scale.
RQR/Dunn-Smyth residuals transform that PIT value to normal scale with
`invnormal()`. For discrete outcomes, `F_low` and `F_high` define the CDF jump
around the observed value. `uvar()` supplies the same uniform draws to Stata and
R for exact discrete residual benchmarking. Missing functionality is a validity
problem only if `qresid` claims to support it or if a critical benchmark for a
claimed route fails.
