Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before any weighted residual implementation or benchmark decision

# WEIGHTS_IMPLEMENTATION_MATRIX.md

Date: 2026-05-10

Branch: `dev-qresid-nb-weights-grouped-binomial`

Status source: local Stata/R inspection on root `b91e964`; qresid subrepo `388e595`.

POST_CHANGE_SYNC_DONE: registered in `DOCUMENT_STATUS_REGISTRY.md`.

## 1. Matrix Status

| item | result |
|---|---|
| `WEIGHTS_IMPLEMENTATION_ALLOWED` | `partial_experimental` |
| `WEIGHTS_BENCHMARK_ALLOWED` | `yes` |
| first recommended benchmark | `fweight` frequency expansion for Gaussian/Poisson passed |
| second recommended benchmark | Gamma `glm` weighted CDF/dispersion mapping |
| qresid code changes allowed now | `yes, only for passed narrow experimental combinations` |

## 2. Decision Tags

| decision | meaning |
|---|---|
| `BENCHMARK_CANDIDATE` | May be benchmarked, but not implemented yet. |
| `IMPLEMENT_AFTER_BENCHMARK` | Reserved for later; not used until benchmarks pass. |
| `REJECT_FOR_NOW` | Do not implement in the current weights phase. |
| `NO_R_EQUIVALENT` | No defensible R/base-GLM equivalent identified. |
| `STATA_NOT_SUPPORTED` | Stata command rejects the weight type. |
| `HUMAN_DECISION_REQUIRED` | Needs explicit project decision before benchmark/implementation. |
| `PWEIGHT_DIAGNOSTIC_ONLY` | May be studied as survey/model-based diagnostic evidence; no implementation authorization. |
| `STATA_ONLY_DIAGNOSTIC` | Stata-only diagnostic path; not exact R/Stata validation. |

## 3. Implementation Matrix

| family | command | link | weight_type | Stata_supported | R_equivalent | qresid_rule | benchmarkable | decision |
|---|---|---|---|---|---|---|---|---|
| Gaussian | `regress` | identity | fweight | yes | frequency expansion / model-based CDF check | No final multiplier; CDF uses weighted-fit prediction and Stata scale. | yes | `IMPLEMENT_AFTER_BENCHMARK` |
| Gaussian | `regress` | identity | aweight | yes | possible `lm(weights=)` prior/analytic comparison | Requires scale/dispersion mapping. | yes | `BENCHMARK_CANDIDATE` |
| Gaussian | `regress` | identity | iweight | yes | no clear residual distribution equivalent | Keep blocked. | no | `REJECT_FOR_NOW` |
| Gaussian | `regress` | identity | pweight | yes | R `survey` diagnostic candidate; no base R individual-CDF equivalent | Diagnostic only; no final multiplier. | yes, diagnostic only | `PWEIGHT_DIAGNOSTIC_ONLY` |
| Poisson | `poisson` | log | fweight | yes | frequency expansion / model-based CDF check | CDF Poisson with weighted-fit `mu`; no final multiplier. | yes | `IMPLEMENT_AFTER_BENCHMARK` |
| Poisson | `poisson` | log | aweight | no | n/a | Stata rejects. | no | `STATA_NOT_SUPPORTED` |
| Poisson | `poisson` | log | iweight | yes | no clear residual distribution equivalent | Keep blocked. | no | `REJECT_FOR_NOW` |
| Poisson | `poisson` | log | pweight | yes | R `survey` diagnostic candidate; no exact individual CDF equivalent | Diagnostic only with weighted-fit `mu`; no support claim. | yes, diagnostic only | `PWEIGHT_DIAGNOSTIC_ONLY` |
| Bernoulli | `logit` | logit | fweight | yes | frequency/grouped-binomial candidate | Treat as grouped-binomial semantics, not generic weight. | yes, after grouped gate | `HUMAN_DECISION_REQUIRED` |
| Bernoulli | `logit` | logit | aweight | no | n/a | Stata rejects. | no | `STATA_NOT_SUPPORTED` |
| Bernoulli | `logit` | logit | iweight | yes | no clear residual distribution equivalent | Keep blocked. | no | `REJECT_FOR_NOW` |
| Bernoulli | `logit` | logit | pweight | yes | R `survey` diagnostic candidate; no exact individual CDF equivalent | Diagnostic only; no support claim. | yes, diagnostic only | `PWEIGHT_DIAGNOSTIC_ONLY` |
| Bernoulli | `logistic` | logit | fweight | yes | frequency/grouped-binomial candidate | Same policy as `logit`. | yes, after grouped gate | `HUMAN_DECISION_REQUIRED` |
| Bernoulli | `logistic` | logit | aweight | no | n/a | Stata rejects. | no | `STATA_NOT_SUPPORTED` |
| Bernoulli | `logistic` | logit | iweight | yes | no clear residual distribution equivalent | Keep blocked. | no | `REJECT_FOR_NOW` |
| Bernoulli | `logistic` | logit | pweight | yes | R `survey` diagnostic candidate; no exact individual CDF equivalent | Diagnostic only; no support claim. | yes, diagnostic only | `PWEIGHT_DIAGNOSTIC_ONLY` |
| Gaussian | `glm, family(gaussian)` | active links | fweight | yes | frequency expansion / `glm(weights=)` | Compare weighted-fit `mu` and dispersion. | yes | `BENCHMARK_CANDIDATE` |
| Gaussian | `glm, family(gaussian)` | active links | aweight | yes | possible R prior weights | Requires scale/dispersion mapping. | yes | `BENCHMARK_CANDIDATE` |
| Gaussian | `glm, family(gaussian)` | active links | iweight | yes | no clear residual distribution equivalent | Keep blocked. | no | `REJECT_FOR_NOW` |
| Gaussian | `glm, family(gaussian)` | active links | pweight | yes | R `survey` diagnostic candidate; no exact individual CDF equivalent | Diagnostic only; no support claim. | yes, diagnostic only | `PWEIGHT_DIAGNOSTIC_ONLY` |
| Poisson | `glm, family(poisson)` | active links | fweight | yes | frequency expansion / `glm(weights=)` | CDF Poisson with weighted-fit `mu`; no final multiplier. | yes | `BENCHMARK_CANDIDATE` |
| Poisson | `glm, family(poisson)` | active links | aweight | yes | possible R prior weights | CDF Poisson with weighted-fit `mu`; semantics must be justified. | yes | `BENCHMARK_CANDIDATE` |
| Poisson | `glm, family(poisson)` | active links | iweight | yes | no clear residual distribution equivalent | Keep blocked. | no | `REJECT_FOR_NOW` |
| Poisson | `glm, family(poisson)` | active links | pweight | yes | R `survey` diagnostic candidate; no exact individual CDF equivalent | Diagnostic only; no support claim. | yes, diagnostic only | `PWEIGHT_DIAGNOSTIC_ONLY` |
| Bernoulli/binomial | `glm, family(binomial)` | active links | fweight | yes | grouped-binomial/trials candidate | Route through grouped-binomial gate. | yes, after grouped gate | `HUMAN_DECISION_REQUIRED` |
| Bernoulli/binomial | `glm, family(binomial)` | active links | aweight | yes | R `prior.weights` as trials/weights, ambiguous | Route through grouped-binomial and prior-weight semantics. | yes, after grouped gate | `HUMAN_DECISION_REQUIRED` |
| Bernoulli/binomial | `glm, family(binomial)` | active links | iweight | yes | no clear residual distribution equivalent | Keep blocked. | no | `REJECT_FOR_NOW` |
| Bernoulli/binomial | `glm, family(binomial)` | active links | pweight | yes | R `survey` diagnostic candidate; no exact individual CDF equivalent | Diagnostic only; grouped/trials semantics remain separate. | yes, diagnostic only | `PWEIGHT_DIAGNOSTIC_ONLY` |
| Gamma | `glm, family(gamma)` | active links | fweight | yes | frequency/prior-weight benchmark candidate | CDF must use verified weighted shape/scale. | yes | `BENCHMARK_CANDIDATE` |
| Gamma | `glm, family(gamma)` | active links | aweight | yes | `statmod` weighted Gamma CDF candidate | Candidate if Stata scale/dispersion maps. | yes | `BENCHMARK_CANDIDATE` |
| Gamma | `glm, family(gamma)` | active links | iweight | yes | no clear residual distribution equivalent | Keep blocked. | no | `REJECT_FOR_NOW` |
| Gamma | `glm, family(gamma)` | active links | pweight | yes | R `survey` diagnostic candidate if available; otherwise Stata-only diagnostic | Diagnostic only; scale/CDF not a support claim. | yes, diagnostic only | `PWEIGHT_DIAGNOSTIC_ONLY` |

## 4. Dataset Design

| dataset_id | purpose | design |
|---|---|---|
| `WEIGHT_FREQ_EXPANSION` | Validate fweight as replication semantics | Small integer weights, expanded dataset equivalent, Gaussian and Poisson first. |
| `WEIGHT_GLM_PRIOR` | Compare Stata GLM weights to R `glm(weights=)` | Positive noninteger weights, stable covariate range, Gaussian/Poisson/Gamma candidates. |
| `WEIGHT_GAMMA_DISPERSION` | Validate Gamma CDF shape/scale under weights | Positive response, positive weights, moderate dispersion, no boundary values. |
| `WEIGHT_REJECT_CASES` | Ensure blocked weights remain blocked | Fit pweight/iweight models and verify future `qresid` should return controlled errors. |
| `PWEIGHT_SURVEY_DIAGNOSTIC` | Experimental pweight diagnostics | Positive sampling weights, stable convergence, compare to R `survey` where defensible. |
| `PWEIGHT_STATA_ONLY_DIAGNOSTIC` | Stata-only pweight diagnostics | Used when no defensible R equivalent exists; not exact R/Stata validation. |

## 5. Benchmark Layers

Before any `IMPLEMENT_AFTER_BENCHMARK` decision, compare:

1. Stata `e(sample)` vs R model frame;
2. `e(wtype)` and `e(wexp)` vs R weight vector;
3. coefficients;
4. fitted `mu` / probabilities;
5. scale/dispersion where applicable;
6. CDF lower endpoint;
7. CDF upper endpoint;
8. fixed `U` via `uvar()`;
9. final qres.

Matching coefficients alone is not sufficient.

## 6. Implementation Preconditions

Weights may be implemented only after:

- a single narrow combination is selected;
- all benchmark layers pass on at least three datasets;
- help/tests/examples are updated in a separate implementation plan;
- no public API changes are required;
- iweights remain explicitly blocked unless a later human decision changes policy;
- pweights remain blocked for standard RQR implementation; direct `[pweight=]` is tracked separately as experimental model-based diagnostic support.

Current status:

`WEIGHTS_IMPLEMENTATION_ALLOWED: partial_experimental`
