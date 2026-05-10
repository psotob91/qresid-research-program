Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before support/report matrix updates

# QRESID_SUPPORT_REPORT_CANONICAL_ROWS.md

Date: 2026-05-10

POST_CHANGE_SYNC_DONE: canonical support-report rows created to synchronize support matrix, unified extension matrix and GLM/link report.
SUPPORT_MATRIX_SYNC_DONE: this table is the row contract for active support/status reports.

## Purpose

This table defines the minimum rows that must appear in the live support
matrix, unified extension matrix and GLM/link report inventory. It is a
diagnostic contract, not a public support claim by itself.

Any new family, split gate, external estimator route, weight type or public
claim must add or update a row here, then regenerate/reconcile the three
report views and run `qresid/tests/check_support_report_consistency.R`.

## Canonical Rows

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
| Adjusted/studentized quantile residual variants | future option only; current `qresid` output is already `invnormal(U)` | MISSING_NOT_BLOCKING | REPORT_SCOPE_ONLY | GATED_RESEARCH | candidate packages: `glmtoolbox`, `gamlss`, `topmodels`, family-specific residual methods | `statmod::qresiduals` confirms normal-score qresid; adjusted/studentized functions pending source audit | current default is standard-normal quantile scale; adjusted/studentized formula unresolved | no | no | Close `QRESID_STANDARDIZED_QUANTILE_RESIDUALS_GATE.md` before any API change. |
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





