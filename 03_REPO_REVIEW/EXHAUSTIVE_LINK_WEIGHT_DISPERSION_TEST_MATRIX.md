Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before extension benchmark implementation

# EXHAUSTIVE_LINK_WEIGHT_DISPERSION_TEST_MATRIX.md

Date: 2026-05-10

Branch: `dev-qresid-nb-weights-grouped-binomial`

Status source: root `2e0e833`; qresid subrepo `388e595`; extension freeze tag `qresid-extension-research-freeze.1`.

POST_CHANGE_SYNC_DONE: registered in `04_RETRIEVAL_CONTEXT/DOCUMENT_STATUS_REGISTRY.md`.

## 1. Decision

`MATRIX_STATUS: ACTIVE_BENCHMARK_PLANNING`

`QRESID_CODE_CHANGES_ALLOWED: no`

This matrix defines benchmarkable and excluded combinations before any implementation. It does not authorize changes to `qresid.ado`, public help, tests, certification scripts or package support claims.

## 2. Benchmark Layer Definition

`ALL_REQUIRED_LAYERS` means every benchmark must compare:

1. estimation sample;
2. coefficients;
3. prediction quantity (`mu`, `pr`, `n`, `xb` or normalized probability);
4. ancillary parameter or dispersion/scale when applicable;
5. `F_low`;
6. `F_high`;
7. deterministic `U` using shared `uvar()`;
8. final quantile residual.

Matching convergence or coefficients alone is not sufficient.

## 3. Dataset Catalog

| dataset_id | purpose | design rule |
|---|---|---|
| `GBINOM_CONST_TRIALS` | Grouped binomial constant trials | Constant denominator, moderate probabilities, no separation. |
| `GBINOM_VAR_TRIALS` | Grouped binomial variable trials | Variable denominator, continuous predictor, mostly interior outcomes. |
| `GBINOM_EDGE_STABLE` | Grouped binomial endpoints | Includes some `y=0` and `y=m`, no perfect separation. |
| `NB_SYNTH_BASIC` | NB2 basic equivalence | Moderate theta, one covariate, stable log mean, no offset or weights. |
| `NB_OVERDISP_MODERATE` | NB overdispersion separation | Lower theta, wider mean range, enough zeros and moderate counts. |
| `NB_ADV_SMALL_STABLE` | NB endpoint stress | Small stable count dataset with zeros and low counts, no high leverage. |
| `NB_ADV_OFFSET_EXPOSURE` | NB offset/exposure research | Positive exposure, known offset/exposure construction, stable convergence. |
| `WEIGHT_FREQ_EXPANSION` | fweight replication check | Small integer weights with an expanded-data equivalent. |
| `WEIGHT_GLM_PRIOR` | GLM prior/analytic weight check | Positive noninteger weights with stable Gaussian/Poisson/Gamma fits. |
| `WEIGHT_GAMMA_DISPERSION` | Weighted Gamma CDF/dispersion | Positive response, positive weights, moderate dispersion. |
| `WEIGHT_REJECT_CASES` | Rejection behavior | iweight/pweight fits used only to verify future controlled rejection. |
| `SCALE_GAUSS_STABLE` | Gaussian scale modes | Stable Gaussian GLM with known residual scale behavior. |
| `SCALE_GAMMA_STABLE` | Gamma scale modes | Positive Gamma response with stable shape/scale estimates. |

If a model fails to converge, design an alternative dataset before blocking the feature.

## 4. Main Test Matrix

| model_family | stata_command | r_equivalent | link | weight_type | exposure_offset | dispersion_option | dataset_id | convergence_expected | benchmark_layer | implementation_decision |
|---|---|---|---|---|---|---|---|---|---|---|
| grouped_binomial | `glm, family(binomial nvar)` | `glm(cbind(y,n-y), binomial("logit"))` and proportion/weights form | logit | none | none | default | `GBINOM_CONST_TRIALS` | yes | `ALL_REQUIRED_LAYERS` | `TESTABLE_NOW_BENCHMARK_FIRST` |
| grouped_binomial | `glm, family(binomial nvar)` | `glm(cbind(y,n-y), binomial("logit"))` and proportion/weights form | logit | none | none | default | `GBINOM_VAR_TRIALS` | yes | `ALL_REQUIRED_LAYERS` | `TESTABLE_NOW_BENCHMARK_FIRST` |
| grouped_binomial | `glm, family(binomial nvar)` | `glm(cbind(y,n-y), binomial("logit"))` and proportion/weights form | logit | none | none | default | `GBINOM_EDGE_STABLE` | yes | `ALL_REQUIRED_LAYERS` | `TESTABLE_NOW_BENCHMARK_FIRST` |
| grouped_binomial | `glm, family(binomial nvar)` | `glm(cbind(y,n-y), binomial("probit"))` | probit | none | none | default | `GBINOM_CONST_TRIALS` | yes | `ALL_REQUIRED_LAYERS` | `TESTABLE_NOW_BENCHMARK_FIRST` |
| grouped_binomial | `glm, family(binomial nvar)` | `glm(cbind(y,n-y), binomial("probit"))` | probit | none | none | default | `GBINOM_VAR_TRIALS` | yes | `ALL_REQUIRED_LAYERS` | `TESTABLE_NOW_BENCHMARK_FIRST` |
| grouped_binomial | `glm, family(binomial nvar)` | `glm(cbind(y,n-y), binomial("probit"))` | probit | none | none | default | `GBINOM_EDGE_STABLE` | yes | `ALL_REQUIRED_LAYERS` | `TESTABLE_NOW_BENCHMARK_FIRST` |
| grouped_binomial | `glm, family(binomial nvar)` | `glm(cbind(y,n-y), binomial("cloglog"))` | cloglog | none | none | default | `GBINOM_CONST_TRIALS` | yes | `ALL_REQUIRED_LAYERS` | `TESTABLE_NOW_BENCHMARK_FIRST` |
| grouped_binomial | `glm, family(binomial nvar)` | `glm(cbind(y,n-y), binomial("cloglog"))` | cloglog | none | none | default | `GBINOM_VAR_TRIALS` | yes | `ALL_REQUIRED_LAYERS` | `TESTABLE_NOW_BENCHMARK_FIRST` |
| grouped_binomial | `glm, family(binomial nvar)` | `glm(cbind(y,n-y), binomial("cloglog"))` | cloglog | none | none | default | `GBINOM_EDGE_STABLE` | yes | `ALL_REQUIRED_LAYERS` | `TESTABLE_NOW_BENCHMARK_FIRST` |
| grouped_binomial | `glm, family(binomial nvar)` | `glm(cbind(y,n-y), binomial("log"))` | log | none | none | default | `GBINOM_CONST_TRIALS` | yes | `ALL_REQUIRED_LAYERS` | `TESTABLE_NOW_BENCHMARK_FIRST` |
| grouped_binomial | `glm, family(binomial nvar)` | `glm(cbind(y,n-y), binomial("log"))` | log | none | none | default | `GBINOM_VAR_TRIALS` | yes | `ALL_REQUIRED_LAYERS` | `TESTABLE_NOW_BENCHMARK_FIRST` |
| grouped_binomial | `glm, family(binomial nvar)` | `glm(cbind(y,n-y), binomial("log"))` | log | none | none | default | `GBINOM_EDGE_STABLE` | yes | `ALL_REQUIRED_LAYERS` | `TESTABLE_NOW_BENCHMARK_FIRST` |
| grouped_binomial | `glm, family(binomial nvar)` | `glm(cbind(y,n-y), binomial("identity"))` | identity | none | none | default | `GBINOM_CONST_TRIALS` | yes | `ALL_REQUIRED_LAYERS` | `TESTABLE_NOW_BENCHMARK_FIRST` |
| grouped_binomial | `glm, family(binomial nvar)` | `glm(cbind(y,n-y), binomial("identity"))` | identity | none | none | default | `GBINOM_VAR_TRIALS` | yes | `ALL_REQUIRED_LAYERS` | `TESTABLE_NOW_BENCHMARK_FIRST` |
| grouped_binomial | `glm, family(binomial nvar)` | `glm(cbind(y,n-y), binomial("identity"))` | identity | none | none | default | `GBINOM_EDGE_STABLE` | yes | `ALL_REQUIRED_LAYERS` | `TESTABLE_NOW_BENCHMARK_FIRST` |
| negative_binomial | `nbreg, dispersion(mean)` | `MASS::glm.nb()` plus `pnbinom(size=theta,mu=mu)` | log | none | none | estimated alpha/NB2 | `NB_SYNTH_BASIC` | yes | `ALL_REQUIRED_LAYERS` | `TESTABLE_NOW_BENCHMARK_FIRST` |
| negative_binomial | `nbreg, dispersion(mean)` | `MASS::glm.nb()` plus `pnbinom(size=theta,mu=mu)` | log | none | none | estimated alpha/NB2 | `NB_OVERDISP_MODERATE` | yes | `ALL_REQUIRED_LAYERS` | `TESTABLE_NOW_BENCHMARK_FIRST` |
| negative_binomial | `nbreg, dispersion(mean)` | `MASS::glm.nb()` plus `pnbinom(size=theta,mu=mu)` | log | none | none | estimated alpha/NB2 | `NB_ADV_SMALL_STABLE` | yes | `ALL_REQUIRED_LAYERS` | `TESTABLE_NOW_BENCHMARK_FIRST` |
| gaussian | `regress` | expanded data and `lm(weights=)` comparison | identity | fweight | none | residual variance/default | `WEIGHT_FREQ_EXPANSION` | yes | `ALL_REQUIRED_LAYERS` | `TESTABLE_NOW_BENCHMARK_FIRST` |
| poisson | `poisson` | expanded data and `glm(poisson, weights=)` comparison | log | fweight | none | default | `WEIGHT_FREQ_EXPANSION` | yes | `ALL_REQUIRED_LAYERS` | `TESTABLE_NOW_BENCHMARK_FIRST` |
| gaussian | `glm, family(gaussian)` | `glm(gaussian, weights=)` | identity | fweight | none | default | `WEIGHT_FREQ_EXPANSION` | yes | `ALL_REQUIRED_LAYERS` | `TESTABLE_NOW_BENCHMARK_FIRST` |
| gaussian | `glm, family(gaussian)` | `glm(gaussian, weights=)` | log | fweight | none | default | `WEIGHT_GLM_PRIOR` | yes | `ALL_REQUIRED_LAYERS` | `TESTABLE_NOW_BENCHMARK_FIRST` |
| gaussian | `glm, family(gaussian)` | `glm(gaussian, weights=)` | inverse | fweight | none | default | `WEIGHT_GLM_PRIOR` | yes | `ALL_REQUIRED_LAYERS` | `TESTABLE_NOW_BENCHMARK_FIRST` |
| poisson | `glm, family(poisson)` | `glm(poisson, weights=)` | log | fweight | none | default | `WEIGHT_FREQ_EXPANSION` | yes | `ALL_REQUIRED_LAYERS` | `TESTABLE_NOW_BENCHMARK_FIRST` |
| poisson | `glm, family(poisson)` | `glm(poisson, weights=)` | identity | fweight | none | default | `WEIGHT_GLM_PRIOR` | yes | `ALL_REQUIRED_LAYERS` | `TESTABLE_NOW_BENCHMARK_FIRST` |
| poisson | `glm, family(poisson)` | `glm(poisson, weights=)` | sqrt | fweight | none | default | `WEIGHT_GLM_PRIOR` | yes | `ALL_REQUIRED_LAYERS` | `TESTABLE_NOW_BENCHMARK_FIRST` |
| gamma | `glm, family(gamma)` | `glm(Gamma, weights=)` plus statmod weighted CDF candidate | log | fweight | none | estimated/default scale | `WEIGHT_GAMMA_DISPERSION` | yes | `ALL_REQUIRED_LAYERS` | `TESTABLE_NOW_BENCHMARK_FIRST` |
| gamma | `glm, family(gamma)` | `glm(Gamma, weights=)` plus statmod weighted CDF candidate | identity | fweight | none | estimated/default scale | `WEIGHT_GAMMA_DISPERSION` | yes | `ALL_REQUIRED_LAYERS` | `TESTABLE_NOW_BENCHMARK_FIRST` |
| gamma | `glm, family(gamma)` | `glm(Gamma, weights=)` plus statmod weighted CDF candidate | inverse | fweight | none | estimated/default scale | `WEIGHT_GAMMA_DISPERSION` | yes | `ALL_REQUIRED_LAYERS` | `TESTABLE_NOW_BENCHMARK_FIRST` |
| gaussian | `glm, family(gaussian)` | `glm(gaussian, weights=)` | identity | aweight | none | default/fixed/estimated scale | `SCALE_GAUSS_STABLE` | yes | `ALL_REQUIRED_LAYERS` | `RESEARCH_BENCHMARK_ONLY` |
| gamma | `glm, family(gamma)` | `glm(Gamma, weights=)` plus statmod weighted CDF candidate | log | aweight | none | default/fixed/estimated scale | `SCALE_GAMMA_STABLE` | yes | `ALL_REQUIRED_LAYERS` | `RESEARCH_BENCHMARK_ONLY` |
| negative_binomial | `nbreg, dispersion(mean)` | `MASS::glm.nb(... + offset(offset))` | log | none | offset | estimated alpha/NB2 | `NB_ADV_OFFSET_EXPOSURE` | yes | `ALL_REQUIRED_LAYERS` | `RESEARCH_BENCHMARK_ONLY` |
| negative_binomial | `nbreg, dispersion(mean)` | `MASS::glm.nb(... + offset(log(exposure)))` | log | none | exposure | estimated alpha/NB2 | `NB_ADV_OFFSET_EXPOSURE` | yes | `ALL_REQUIRED_LAYERS` | `RESEARCH_BENCHMARK_ONLY` |
| negative_binomial | `glm, family(nbinomial #)` | `glm(..., family=MASS::negative.binomial(theta=#))` | log | none | none | fixed theta | `NB_SYNTH_BASIC` | yes | `ALL_REQUIRED_LAYERS` | `RESEARCH_BENCHMARK_ONLY` |
| grouped_binomial_alias | `binreg, n(nvar) or` | `glm(cbind(y,n-y), binomial("logit"))` | logit | none | none | default | `GBINOM_CONST_TRIALS` | yes, after grouped GLM logit passes | `ALL_REQUIRED_LAYERS` | `RESEARCH_BENCHMARK_ONLY` |
| grouped_binomial_alias | `binreg, n(nvar) rr` | `glm(cbind(y,n-y), binomial("log"))` | log | none | none | default | `GBINOM_CONST_TRIALS` | yes, after grouped GLM log passes | `ALL_REQUIRED_LAYERS` | `RESEARCH_BENCHMARK_ONLY` |
| grouped_binomial_alias | `binreg, n(nvar) rd` | `glm(cbind(y,n-y), binomial("identity"))` | identity | none | none | default | `GBINOM_CONST_TRIALS` | yes, after grouped GLM identity passes | `ALL_REQUIRED_LAYERS` | `RESEARCH_BENCHMARK_ONLY` |

## 5. Excluded With Reason

| model_family | stata_command | link | weight_type | exposure_offset | dispersion_option | exclusion_status | reason | dataset_action |
|---|---|---|---|---|---|---|---|---|
| all | any supported command | any | pweight | any | any | `NO_R_EQUIVALENT` | Survey/design interpretation has no simple individual-CDF R base equivalent. | Use `WEIGHT_REJECT_CASES` only for future controlled rejection tests. |
| all | any supported command | any | iweight | any | any | `REJECT_FOR_NOW` | No clear individual distribution for RQR; estimation weight does not define residual CDF. | Use `WEIGHT_REJECT_CASES` only for future controlled rejection tests. |
| poisson | `poisson` | log | aweight | none | default | `STATA_NOT_SUPPORTED` | Stata rejects `aweight` for `poisson`. | Exclude. |
| bernoulli | `logit` | logit | aweight | none | default | `STATA_NOT_SUPPORTED` | Stata rejects `aweight` for `logit`. | Exclude. |
| bernoulli | `logistic` | logit | aweight | none | default | `STATA_NOT_SUPPORTED` | Stata rejects `aweight` for `logistic`. | Exclude. |
| negative_binomial | `nbreg, dispersion(constant)` | log | none | none | constant dispersion | `NEEDS_RESEARCH` | R equivalent and CDF parameterization are not closed. | Design later dataset only after parameterization note closes. |
| negative_binomial | `gnbreg` | log | none | any | observation-specific alpha | `NEEDS_RESEARCH` | Observation-specific CDF endpoint rule not closed. | Exclude from this matrix implementation order. |
| negative_binomial | `nbreg` | log | any weight | any | any | `NEEDS_RESEARCH` | Weighted NB depends on unresolved NB and weight gates. | Defer until NB unweighted and weights gates close. |
| grouped_binomial | `binreg, n(nvar) hr` | log-complement | none | none | default | `NEEDS_RESEARCH` | R base has no standard direct link; custom link decision required. | Do not include in initial benchmark. |
| grouped_binomial | `glm, family(binomial nvar)` | logc/loglog/power | none | none | default | `NEEDS_RESEARCH` | Custom or non-base R equivalence required. | Exclude until link equivalence is documented. |
| grouped_binomial | R `glm(..., binomial("cauchit"))` | cauchit | none | none | default | `R_ONLY` | No Stata equivalent identified for this gate. | Exclude. |
| grouped_binomial | any | any | any Stata weight | any | default | `NEEDS_RESEARCH` | Trials are denominators, not generic weights; weighted grouped binomial is separate. | Defer until grouped unweighted passes. |
| all | any | any | any | any | any | `NO_CONVERGENCE_DATASET` | No convergence-expected dataset identified. | Design alternative dataset before marking feature blocked. |

## 6. Benchmark Order

1. Grouped binomial `glm` unweighted links: logit, probit, cloglog, log, identity across the three grouped-binomial datasets.
2. NB `nbreg, dispersion(mean)` unweighted log link across the three NB datasets.
3. Frequency weights for Gaussian `regress` and Poisson `poisson`.
4. GLM Gaussian/Poisson/Gamma `fweight` and Gamma/Gaussian `aweight` scale/dispersion candidates.
5. NB offset/exposure and fixed-theta `glm, family(nbinomial #)` as research-only.
6. `binreg` aliases after the corresponding grouped `glm` links pass.

## 7. Promotion Rule

A row can move from benchmark-only to implementation planning only when:

- all layers pass in Stata and R;
- CDF endpoints match within documented tolerance;
- discrete-family `uvar()` comparison is deterministic;
- the relevant gate report changes `IMPLEMENTATION_ALLOWED: no` to `yes`;
- help, tests, examples and changelog are planned in a separate implementation cycle.

Until then, this matrix remains diagnostic and non-authorizing.
