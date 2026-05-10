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

| model_group | stata_route | qresid_status | evidence_scope | validation_type | r_estimator_package_function | r_quantile_residual_package_function | pit_rqr_method | blocks_current_validity | blocks_public_rc | next_action |
|---|---|---|---|---|---|---|---|---|---|---|
| Gaussian | `regress`; `glm, family(gaussian)` | READY_FOR_EXTENSION_PRERELEASE | THIS_REPORT | R_EXACT_BENCHMARK | `stats::lm`; `stats::glm(family=gaussian)` | `statmod::qresiduals`; manual_CDF_replay normal | continuous PIT, `qnorm(F(y))` | no | no | Maintain regression tests and docs. |
| Poisson | `poisson`; `glm, family(poisson)` | READY_FOR_EXTENSION_PRERELEASE | THIS_REPORT | R_EXACT_BENCHMARK | `stats::glm(family=poisson)` | `statmod::qresiduals`; manual `ppois` replay | discrete Dunn-Smyth with `uvar()` | no | no | Maintain offset/exposure tests. |
| Bernoulli individual | `logit`; `logistic`; individual `glm, family(binomial)`; individual `binreg` | READY_FOR_EXTENSION_PRERELEASE | THIS_REPORT | R_EXACT_BENCHMARK | `stats::glm(family=binomial)` | `statmod::qresiduals`; manual `pbinom` replay | discrete Dunn-Smyth with `uvar()` | no | no | Maintain individual Bernoulli tests. |
| Grouped binomial | `glm, family(binomial trials)`; `binreg, n(trials)` aliases | READY_FOR_EXTENSION_PRERELEASE | SEPARATE_BENCHMARK | R_EXACT_BENCHMARK; R_CDF_REPLAY for `binreg hr` | `stats::glm(cbind(success,failure), family=binomial)` | `statmod::qresiduals`; manual `pbinom` replay | grouped discrete Dunn-Smyth with `uvar()` | no | no | Keep weighted grouped-binomial variants gated. |
| Negative binomial | `nbreg` variants including `gnbreg`; fixed `glm, family(nbinomial #)` | READY_FOR_EXTENSION_PRERELEASE | SEPARATE_BENCHMARK | R_EXACT_BENCHMARK; R_CDF_REPLAY | `MASS::glm.nb`; `MASS::negative.binomial(theta)` | `statmod::qresiduals`; manual_CDF_replay `pnbinom` | discrete Dunn-Smyth with `uvar()` | no | no | Keep `glm nbinomial ml` and untested weights gated. |
| Gamma | `glm, family(gamma)` | READY_FOR_EXTENSION_PRERELEASE | THIS_REPORT | R_EXACT_BENCHMARK | `stats::glm(family=Gamma)` | `statmod::qresiduals`; manual `pgamma` replay | continuous PIT | no | no | Maintain tested links and fweight evidence separately. |
| inverse Gaussian | `glm, family(igaussian)` | READY_FOR_EXTENSION_PRERELEASE | THIS_REPORT | R_EXACT_BENCHMARK | `stats::glm(family=inverse.gaussian)` | `statmod::qresiduals`; manual inverse-Gaussian CDF replay | continuous PIT | no | no | Maintain tested links and fweight evidence separately. |
| fweight expanded families | tested direct `[fweight=]` routes | READY_FOR_EXTENSION_PRERELEASE | SEPARATE_BENCHMARK | expansion benchmark; R_CDF_REPLAY | family-specific R estimator or expanded-data equivalent | family-specific manual CDF replay; `statmod::qresiduals` where object-compatible | frequency expansion PIT/RQR, no final weight multiplier | no | no | Do not generalize to aweight/iweight/pweight/svy. |
| pweight direct Gaussian/Poisson/Bernoulli | direct `[pweight=]`, no `svy:` | DIAGNOSTIC_ONLY | SEPARATE_BENCHMARK | STATA_ONLY_DIAGNOSTIC | no exact R base equivalent | none exact; Stata-only diagnostic | model-based Stata PIT/RQR diagnostic | no | yes | Human public-RC policy decision. |
| Studentized quantile residuals | `type(studentized)` after unweighted `regress` and tested `glm` families | READY_FOR_EXTENSION_PRERELEASE | THIS_REPORT | R_EXACT_BENCHMARK; R_CDF_REPLAY | `stats::glm`; `glmtoolbox::residuals2`; manual R replay | `glmtoolbox::residuals2(type="quantile", standardized=TRUE)` for Gaussian; `qnorm(U)/sqrt(1-h)` replay for other tested GLM | leverage-standardized quantile residual `qres/sqrt(1-h)` | no | no | Keep restricted to unweighted regress/tested GLM; weights and non-GLM routes use controlled error. |
| Adjusted quantile residuals | `type(adjusted)` after unweighted `glm` Gamma and inverse Gaussian | READY_FOR_EXTENSION_PRERELEASE | THIS_REPORT | R_CDF_REPLAY | `stats::glm`; Scudilio-Pereira formula | `qnorm(U)/sqrt(1-h)` replay with R `hatvalues(glm)` | Scudilio-Pereira adjusted quantile residual for continuous Gamma/IG GLM | no | no | Keep restricted to unweighted Gamma and inverse Gaussian GLM; other adjusted routes remain gated. |
| Tweedie | not implemented | MISSING_NOT_BLOCKING | REPORT_SCOPE_ONLY | GATED_MODEL_FAMILY | `statmod`; `tweedie` candidates | `statmod::qresiduals` candidate | gated CDF/PIT approximation | no | no | Open Tweedie CDF benchmark gate. |
| Official zero-inflated count | `zip`; `zinb` | READY_FOR_EXTENSION_PRERELEASE | SEPARATE_BENCHMARK | R_CDF_REPLAY | `VGAM`; `glmmTMB`; custom mixture replay | manual mixture CDF replay; `topmodels::qresiduals` candidate | discrete mixture Dunn-Smyth with `uvar()` | no | no | Keep weights and correlated variants gated. |
| Official truncated count | `tpoisson`; `tnbreg`; `ztp`; `ztnb` | READY_FOR_EXTENSION_PRERELEASE | SEPARATE_BENCHMARK | R_CDF_REPLAY | `VGAM::pospoisson`; `VGAM::posnegbinomial`; base CDF replay | manual_CDF_replay truncated | conditional-support discrete Dunn-Smyth with `uvar()` | no | no | Keep weighted/untested truncation variants gated. |
| Official censored count | `cpoisson` | READY_FOR_EXTENSION_PRERELEASE | SEPARATE_BENCHMARK | R_CDF_REPLAY | `VGAM::cens.poisson` candidate; base CDF replay | manual interval PIT replay | censored interval PIT/RQR | no | no | Keep weighted and non-Poisson censored routes gated. |
| Generalized Poisson | pinned Stata Journal `st0279` / `gpoisson`; `gnpoisson` alias/reference tracked | READY_FOR_EXTENSION_PRERELEASE | SEPARATE_BENCHMARK | STATA_EXTERNAL_ADO_VALIDATION; R_CDF_REPLAY | `VGAM::pgenpois0`; analytic replay; `glmmTMB::genpois` approximate candidate | manual generalized-Poisson CDF replay | discrete Dunn-Smyth with `uvar()` | no | no | Keep weights, `gp2`, other GP ado routes and hurdle GP gated. |
| Specialized official count | `popoisson`; `xpopoisson`; `dspoisson`; `expoisson`; `etpoisson`; `heckpoisson`; `ivpoisson` | MISSING_NOT_BLOCKING | REPORT_SCOPE_ONLY | STATA_INTERNAL_VALIDATION pending | route-specific | none yet | route-specific, unresolved | no | no | Create extraction/CDF gates per estimator class. |
| Hurdle count Poisson/NB | pinned external `hplogit`; pinned external `hnblogit`; unweighted only | READY_FOR_EXTENSION_PRERELEASE | SEPARATE_BENCHMARK | STATA_EXTERNAL_ADO_VALIDATION; R_EXACT_BENCHMARK; R_CDF_REPLAY | `pscl::hurdle`; `glmmTMB`; `VGAM` candidates | `qresid` hurdle endpoints; manual hurdle CDF replay; `topmodels::qresiduals` candidate | hurdle discrete Dunn-Smyth with `uvar()` | no | no | Keep weights, probit hurdle, `churdle`, `ztpnm`, unpinned hurdle routes and correlated hurdle models gated. |
| Stata churdle Cragg bounded/continuous | official `churdle`, separate from count hurdle | GATED_MODEL_FAMILY | REPORT_SCOPE_ONLY | CHURDLE_CRAGG_GATE_OPEN | route-specific R Cragg/two-part candidates needed | none yet | continuous/interval PIT gate pending | no | no | Open separate Cragg continuous/bounded benchmark gate if needed. |
| External Hilbe-style counts still gated | NB-P; Waring; Sichel/PIG; COM-Poisson; double Poisson; beta-binomial variants | MISSING_NOT_BLOCKING | REPORT_SCOPE_ONLY | GATED_MODEL_FAMILY; STATA_EXTERNAL_ADO_VALIDATION if pinned | family-specific | package-specific or manual CDF replay if source closes | unresolved | no | no | Pin source/version/license and close PMF/CDF mapping. |
| Mixed/GLMM/GSEM | `xt*`; `me*`; `gsem`; `fmm:` count routes | MISSING_NOT_BLOCKING | REPORT_SCOPE_ONLY | FUTURE_PHASE | `lme4`; `glmmTMB`; mixture packages | `DHARMa::simulateResiduals` only as simulation sanity | conditional vs marginal PIT unresolved | no | no | Future residual-policy decision. |
| aweight/iweight | not claimed | MISSING_NOT_BLOCKING | REPORT_SCOPE_ONLY | GATED_RESEARCH | partial/no exact equivalent | none yet | weight semantics unresolved | no | no | Separate weights research. |
| svy | not implemented | MISSING_NOT_BLOCKING | REPORT_SCOPE_ONLY | FUTURE_PHASE | R `survey` candidates | none yet | survey/design PIT unresolved | no | no | Human design decision. |
| unsupported weighted routes | routes outside tested fweight and direct pweight diagnostic scope | MISSING_NOT_BLOCKING | REPORT_SCOPE_ONLY | GATED_VARIANT | not established | none yet | unresolved | no | no | Keep out of claims. |

## Validity Summary

- Current local extension prerelease validity: acceptable.
- `BLOCKS_CURRENT_VALIDITY`: none.
- `BLOCKS_PUBLIC_RC`: pweight public policy.
- Missing implemented hurdle count, Tweedie, specialized official count routes,
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






