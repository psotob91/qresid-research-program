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
| `WEIGHTS_IMPLEMENTATION_ALLOWED` | `no` |
| `WEIGHTS_BENCHMARK_ALLOWED` | `yes` |
| first recommended benchmark | `fweight` frequency expansion for Gaussian/Poisson |
| second recommended benchmark | Gamma `glm` weighted CDF/dispersion mapping |
| qresid code changes allowed now | `no` |

## 2. Decision Tags

| decision | meaning |
|---|---|
| `BENCHMARK_CANDIDATE` | May be benchmarked, but not implemented yet. |
| `IMPLEMENT_AFTER_BENCHMARK` | Reserved for later; not used until benchmarks pass. |
| `REJECT_FOR_NOW` | Do not implement in the current weights phase. |
| `NO_R_EQUIVALENT` | No defensible R/base-GLM equivalent identified. |
| `STATA_NOT_SUPPORTED` | Stata command rejects the weight type. |
| `HUMAN_DECISION_REQUIRED` | Needs explicit project decision before benchmark/implementation. |

## 3. Implementation Matrix

| family | command | link | weight_type | Stata_supported | R_equivalent | qresid_rule | benchmarkable | decision |
|---|---|---|---|---|---|---|---|---|
| Gaussian | `regress` | identity | fweight | yes | frequency expansion / `lm(weights=)` comparison | No final multiplier; compare expanded data semantics. | yes | `BENCHMARK_CANDIDATE` |
| Gaussian | `regress` | identity | aweight | yes | possible `lm(weights=)` prior/analytic comparison | Requires scale/dispersion mapping. | yes | `BENCHMARK_CANDIDATE` |
| Gaussian | `regress` | identity | iweight | yes | no clear residual distribution equivalent | Keep blocked. | no | `REJECT_FOR_NOW` |
| Gaussian | `regress` | identity | pweight | yes | no base R individual-CDF equivalent | Keep blocked. | no | `NO_R_EQUIVALENT` |
| Poisson | `poisson` | log | fweight | yes | frequency expansion / `glm(poisson, weights=)` comparison | CDF Poisson with weighted-fit `mu`; no final multiplier. | yes | `BENCHMARK_CANDIDATE` |
| Poisson | `poisson` | log | aweight | no | n/a | Stata rejects. | no | `STATA_NOT_SUPPORTED` |
| Poisson | `poisson` | log | iweight | yes | no clear residual distribution equivalent | Keep blocked. | no | `REJECT_FOR_NOW` |
| Poisson | `poisson` | log | pweight | yes | no base R survey-equivalent CDF | Keep blocked. | no | `NO_R_EQUIVALENT` |
| Bernoulli | `logit` | logit | fweight | yes | frequency/grouped-binomial candidate | Treat as grouped-binomial semantics, not generic weight. | yes, after grouped gate | `HUMAN_DECISION_REQUIRED` |
| Bernoulli | `logit` | logit | aweight | no | n/a | Stata rejects. | no | `STATA_NOT_SUPPORTED` |
| Bernoulli | `logit` | logit | iweight | yes | no clear residual distribution equivalent | Keep blocked. | no | `REJECT_FOR_NOW` |
| Bernoulli | `logit` | logit | pweight | yes | no base R survey-equivalent CDF | Keep blocked. | no | `NO_R_EQUIVALENT` |
| Bernoulli | `logistic` | logit | fweight | yes | frequency/grouped-binomial candidate | Same policy as `logit`. | yes, after grouped gate | `HUMAN_DECISION_REQUIRED` |
| Bernoulli | `logistic` | logit | aweight | no | n/a | Stata rejects. | no | `STATA_NOT_SUPPORTED` |
| Bernoulli | `logistic` | logit | iweight | yes | no clear residual distribution equivalent | Keep blocked. | no | `REJECT_FOR_NOW` |
| Bernoulli | `logistic` | logit | pweight | yes | no base R survey-equivalent CDF | Keep blocked. | no | `NO_R_EQUIVALENT` |
| Gaussian | `glm, family(gaussian)` | active links | fweight | yes | frequency expansion / `glm(weights=)` | Compare weighted-fit `mu` and dispersion. | yes | `BENCHMARK_CANDIDATE` |
| Gaussian | `glm, family(gaussian)` | active links | aweight | yes | possible R prior weights | Requires scale/dispersion mapping. | yes | `BENCHMARK_CANDIDATE` |
| Gaussian | `glm, family(gaussian)` | active links | iweight | yes | no clear residual distribution equivalent | Keep blocked. | no | `REJECT_FOR_NOW` |
| Gaussian | `glm, family(gaussian)` | active links | pweight | yes | no base R survey-equivalent CDF | Keep blocked. | no | `NO_R_EQUIVALENT` |
| Poisson | `glm, family(poisson)` | active links | fweight | yes | frequency expansion / `glm(weights=)` | CDF Poisson with weighted-fit `mu`; no final multiplier. | yes | `BENCHMARK_CANDIDATE` |
| Poisson | `glm, family(poisson)` | active links | aweight | yes | possible R prior weights | CDF Poisson with weighted-fit `mu`; semantics must be justified. | yes | `BENCHMARK_CANDIDATE` |
| Poisson | `glm, family(poisson)` | active links | iweight | yes | no clear residual distribution equivalent | Keep blocked. | no | `REJECT_FOR_NOW` |
| Poisson | `glm, family(poisson)` | active links | pweight | yes | no base R survey-equivalent CDF | Keep blocked. | no | `NO_R_EQUIVALENT` |
| Bernoulli/binomial | `glm, family(binomial)` | active links | fweight | yes | grouped-binomial/trials candidate | Route through grouped-binomial gate. | yes, after grouped gate | `HUMAN_DECISION_REQUIRED` |
| Bernoulli/binomial | `glm, family(binomial)` | active links | aweight | yes | R `prior.weights` as trials/weights, ambiguous | Route through grouped-binomial and prior-weight semantics. | yes, after grouped gate | `HUMAN_DECISION_REQUIRED` |
| Bernoulli/binomial | `glm, family(binomial)` | active links | iweight | yes | no clear residual distribution equivalent | Keep blocked. | no | `REJECT_FOR_NOW` |
| Bernoulli/binomial | `glm, family(binomial)` | active links | pweight | yes | no base R survey-equivalent CDF | Keep blocked. | no | `NO_R_EQUIVALENT` |
| Gamma | `glm, family(gamma)` | active links | fweight | yes | frequency/prior-weight benchmark candidate | CDF must use verified weighted shape/scale. | yes | `BENCHMARK_CANDIDATE` |
| Gamma | `glm, family(gamma)` | active links | aweight | yes | `statmod` weighted Gamma CDF candidate | Candidate if Stata scale/dispersion maps. | yes | `BENCHMARK_CANDIDATE` |
| Gamma | `glm, family(gamma)` | active links | iweight | yes | no clear residual distribution equivalent | Keep blocked. | no | `REJECT_FOR_NOW` |
| Gamma | `glm, family(gamma)` | active links | pweight | yes | no base R survey-equivalent CDF | Keep blocked. | no | `NO_R_EQUIVALENT` |

## 4. Dataset Design

| dataset_id | purpose | design |
|---|---|---|
| `WEIGHT_FREQ_EXPANSION` | Validate fweight as replication semantics | Small integer weights, expanded dataset equivalent, Gaussian and Poisson first. |
| `WEIGHT_GLM_PRIOR` | Compare Stata GLM weights to R `glm(weights=)` | Positive noninteger weights, stable covariate range, Gaussian/Poisson/Gamma candidates. |
| `WEIGHT_GAMMA_DISPERSION` | Validate Gamma CDF shape/scale under weights | Positive response, positive weights, moderate dispersion, no boundary values. |
| `WEIGHT_REJECT_CASES` | Ensure blocked weights remain blocked | Fit pweight/iweight models and verify future `qresid` should return controlled errors. |

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
- pweights and iweights remain explicitly blocked unless a later human decision changes policy.

Until then:

`WEIGHTS_IMPLEMENTATION_ALLOWED: no`
