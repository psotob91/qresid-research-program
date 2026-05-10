Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before extension implementation, benchmark or support-status decisions

# QRESID_MATH_SOFTWARE_EVIDENCE_MATRIX.md

Date: 2026-05-10

POST_CHANGE_SYNC_DONE: math/software evidence matrix updated after hurdle RQR theory gate creation and estimator-equivalence audit; hurdle count has closed distribution-level PIT/CDF formulas but no accepted Stata estimator route.
SUPPORT_MATRIX_SYNC_DONE: support matrix, unified extension matrix, glossary and registry were reconciled with this evidence layer.

## Purpose

This matrix records whether a candidate route has mathematical CDF/PIT support,
Stata extraction support, R estimator support, RQR/PIT tooling, paper/code
evidence, and enough benchmark evidence for local extension prerelease.

It separates three different ideas:

- an estimator may exist in Stata;
- a comparable estimator or CDF replay route may exist in R;
- an analytic RQR/PIT target may be closed for `qresid`.

## Evidence Matrix

| route | math_reference | cdf_formula_status | estimation_R_package_function | pit_rqr_R_package_function | paper_code_or_supplement | benchmark_type | simulation_benchmark_possible | blocks_prerelease |
|---|---|---|---|---|---|---|---|---|
| `glm, family(nbinomial ml)` | NB2 CDF theory; Stata GLM uses internal NB ML fit | `NO_RELIABLE_PARAMETER_EXTRACTION` because exact estimated alpha is not exposed in `e()` | `MASS::glm.nb`; `MASS::negative.binomial(theta)` only after theta is known | `statmod::qresiduals` for compatible NB GLM objects; manual `pnbinom` replay if theta is known | no package code copied; local Stata `glm.ado` shows alpha is only retained internally and rounded in `e(varfuncf)` | `STATA_INTERNAL_VALIDATION` for gate; no support claim | `DHARMA_SIMULATION_ONLY` possible as sanity check, not gold standard | no, because route remains gated and alternatives exist |
| `tpoisson`; `ztp` | Truncated discrete distribution: conditional CDF over observed support | `ANALYTIC_CDF_CLOSED` for lower truncation and tested constant upper truncation | `VGAM::pospoisson` candidate; base R `ppois` CDF replay used | manual PIT/RQR via `ppois`; `VGAM` has residual tooling but qresid endpoint replay is authority here | no supplementary code required | `R_CDF_REPLAY` with official Stata extraction | possible, but not needed for analytic support | no; now ready for extension prerelease |
| `tnbreg`; `ztnb` | Truncated NB CDF with Stata NB mean-dispersion extraction | `ANALYTIC_CDF_CLOSED` for lower truncation | `VGAM::posnegbinomial` candidate; base R `pnbinom` CDF replay used | manual PIT/RQR via `pnbinom` | no supplementary code required | `R_CDF_REPLAY` with official Stata extraction | possible, but not needed for analytic support | no; now ready for extension prerelease |
| `cpoisson` | Censored discrete PIT interval: left, right and uncensored intervals | `ANALYTIC_CDF_CLOSED` for tested left, right and two-sided censoring | `VGAM::cens.poisson` candidate; base R `ppois` CDF replay used | manual interval PIT/RQR via `ppois` | no supplementary code required | `STATA_INTERNAL_VALIDATION` plus `R_CDF_REPLAY` | possible, but not needed for analytic support | no; now ready for extension prerelease |
| generalized Poisson | Generalized Poisson GP-0 PMF/CDF from pinned Stata Journal `gpoisson`/`st0279` | `ANALYTIC_CDF_CLOSED` for pinned unweighted route | `VGAM::pgenpois0` for positive delta; `glmmTMB::genpois` future approximate candidate | manual PIT/RQR from analytic CDF replay; no separate RQR package authority needed for accepted route | Stata Journal source pinned locally; no external code copied into `qresid` | `STATA_EXTERNAL_ADO_VALIDATION`; `R_CDF_REPLAY`; positive-delta `R_EXACT_BENCHMARK` | yes for local extension prerelease | no; accepted route is claimed with external-estimator dependency |
| estimator-equivalence gate | Route-level check that Stata and R estimate the same fitted distribution before residual benchmarking, or else R only replays CDF endpoints from Stata-exported parameters | `AUDIT_LAYER_CLOSED` | route-specific; see `QRESID_ESTIMATOR_EQUIVALENCE_AUDIT.md` | route-specific `statmod`, `topmodels`, package-native RQR or manual CDF replay | no code copied | `ESTIMATOR_EQUIVALENT`, `CDF_REPLAY_ONLY`, `APPROX_ESTIMATOR_BENCHMARK`, or gated | yes | no; this is an evidence rule |
| hurdle count Poisson/NB | Dunn-Smyth randomized PIT for discrete distributions with atoms; hurdle CDF `P(Y=0)=pi`, `F(y)=pi+(1-pi)F_plus(y)` for `y>0` | `ANALYTIC_CDF_CLOSED_FOR_DISTRIBUTION`; `EVIDENCE_PENDING` for Stata estimator/source and parameter extraction | `pscl::hurdle` documented candidate; `glmmTMB` truncated families plus zero component; `VGAM::zapoisson`, `VGAM::zanegbinomial`, `VGAM::pospoisson`, `VGAM::posnegbinomial` candidates | manual PIT/RQR after Stata estimator closure; `topmodels::qresiduals` documents general PIT/RQR infrastructure; DHARMa simulation only as sanity | no Stata estimator source accepted yet; `churdle` is a separate Cragg continuous/bounded model, not count-hurdle support | `NO_OFFICIAL_STATA_COMMAND` until route closes; possible `STATA_EXTERNAL_ADO_VALIDATION` | possible as sanity only | no, because route is not claimed |
| Stata `churdle` Cragg hurdle | interval PIT for bounded/continuous hurdle models can be defined route-specifically | `CHURDLE_CRAGG_GATE_OPEN`; not a count-hurdle Poisson/NB route | route-specific R Cragg/two-part candidates needed | manual continuous/interval PIT only after extraction/CDF closure | official Stata `churdle` files exist locally; no support claim or benchmark yet | `STATA_INTERNAL_VALIDATION` only after separate Cragg gate | possible as sanity only | no, because route is not claimed |
| DHARMa/glmmTMB sanity | Simulated PIT residuals for fitted count models | `DHARMA_SIMULATION_ONLY` | `glmmTMB` installed; DHARMa 0.4.7 installed locally | DHARMa simulation-based scaled residuals | no supplementary code copied | `SIMULATION_SANITY_CHECK` only | yes; latest script status `PASS_SIMULATION_SANITY_CHECK_ONLY` | no; not used for analytic claims |

## Interpretation

- `glm, family(nbinomial ml)` remains a controlled-error route. The user should
  use `nbreg` or fixed-parameter `glm, family(nbinomial #)` when `qresid`
  residuals are needed.
- Truncated and censored official count routes are now analytic CDF/PIT routes
  with local extension-prerelease evidence.
- Generalized Poisson is ready only for the pinned unweighted `st0279`
  postestimation route.
- Hurdle count now has distribution-level PIT/RQR formulas documented, but
  remains an open research gate because no Stata count-hurdle estimator route is
  accepted or pinned.
- Stata `churdle` is an official Cragg continuous/bounded hurdle route and must
  not be treated as count-hurdle Poisson/NB support.
- DHARMa/glmmTMB can help future simulation sanity checks, but cannot replace
  exact CDF endpoint validation for this package.
