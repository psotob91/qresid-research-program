Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before any pweight or survey-diagnostic benchmark work

# PWEIGHT_SURVEY_DIAGNOSTIC_RESEARCH_PLAN.md

Date: 2026-05-10

Branch: `dev-qresid-nb-weights-grouped-binomial`

Status source: root after `qresid-extension-matrix-freeze.1`; qresid subrepo `388e595`.

POST_CHANGE_SYNC_DONE: registry updated for pweight diagnostic research phase.

## 1. Decision

`PWEIGHT_IMPLEMENTATION_ALLOWED: partial_experimental_direct_only`

`PWEIGHT_DIAGNOSTIC_BENCHMARK_ALLOWED: yes`

`PWEIGHT_R_BASE_EXACT_EQUIVALENCE: no`

`PWEIGHT_SURVEY_DIAGNOSTIC_PHASE: open`

`PWEIGHT_DIRECT_STATA_EXPERIMENTAL_ALLOWED: yes`

Stata direct `[pweight=]` may be used in the integrated experimental branch as model-based diagnostic support for Gaussian, Poisson and Bernoulli. It is not standard RQR support, not `svy:` support, and not exactly equivalent to R base `glm(weights=)`.

## 2. Purpose

The pweight phase investigates whether `qresid` can provide defensible diagnostics for probability-weighted Stata fits. The goal is to characterize estimation, prediction and residual interpretation, not to force exact R/Stata residual equality where no individual CDF equivalent exists.

## 3. Allowed Work

Allowed:

- Fit Stata models using `pweight` for `regress`, `poisson`, `logit`, `logistic` and `glm` families already in scope.
- Compare Stata estimates and predictions against R `survey` package diagnostics when possible.
- Compare against unweighted/model-based references only as a diagnostic contrast, not as exact validation.
- Mark combinations `STATA_ONLY_DIAGNOSTIC` when no R equivalent is defensible.
- Create datasets with positive sampling weights and stable convergence.

Not allowed:

- changing `qresid.ado` to accept pweights as standard/survey-exact RQR;
- using R base `glm(weights=)` as exact pweight equivalent;
- multiplying final residuals by a weight;
- declaring pweight support in help/README;
- promoting pweight beyond direct experimental model-based diagnostics without human release-policy decision.

## 4. Candidate Commands

| command | pweight status | diagnostic target | implementation status |
|---|---|---|---|
| `regress` | Stata-supported | prediction and residual diagnostics against survey/model-based contrasts | blocked |
| `poisson` | Stata-supported | weighted-fit `mu`, count CDF diagnostic only | blocked |
| `logit` / `logistic` | Stata-supported | weighted-fit `pr`, Bernoulli diagnostic only | blocked |
| `glm, family(gaussian)` | Stata-supported | GLM prediction and scale diagnostic | blocked |
| `glm, family(poisson)` | Stata-supported | weighted-fit `mu`, Poisson diagnostic only | blocked |
| `glm, family(binomial)` | Stata-supported | survey/binomial diagnostic; grouped semantics must remain separate | blocked |
| `glm, family(gamma)` | Stata-supported | scale/dispersion diagnostic only | blocked |

## 5. Dataset Design

| dataset_id | purpose | design |
|---|---|---|
| `PWEIGHT_SURVEY_GAUSSIAN` | Gaussian/regress diagnostic | Positive sampling weights, stable continuous outcome, no extreme leverage. |
| `PWEIGHT_SURVEY_POISSON` | Poisson diagnostic | Positive sampling weights, moderate counts, stable log mean. |
| `PWEIGHT_SURVEY_BINOMIAL` | Bernoulli/binomial diagnostic | Positive sampling weights, no separation, probabilities away from 0/1. |
| `PWEIGHT_SURVEY_GAMMA` | Gamma diagnostic | Positive response and positive weights, moderate dispersion. |
| `PWEIGHT_STATA_ONLY_DIAGNOSTIC` | No R-equivalent audit | Same data run only as Stata diagnostic when R equivalence is not defensible. |

## 6. Diagnostic Layers

`PWEIGHT_DIAGNOSTIC_LAYERS`:

1. Stata estimation sample and `e(wtype)`/`e(wexp)`;
2. positive weight validation;
3. Stata coefficients and variance/covariance notes;
4. Stata fitted values (`xb`, `mu`, `pr`, `n`);
5. optional R `survey` comparison where a model-equivalent exists;
6. explicit note whether CDF endpoints are model-based diagnostics or exact individual CDF claims;
7. qres diagnostic status: `not implemented`, `diagnostic only`, or `human decision required`.

## 7. Promotion Rule

Pweight can move beyond diagnostics only if a later human decision accepts one of these policies:

- `PWEIGHT_MODEL_BASED_DIAGNOSTIC_ONLY`: compute residuals from weighted-fit predictions but label as model-based diagnostic, not survey-exact RQR.
- `PWEIGHT_SURVEY_SPECIFIC_METHOD`: define a survey-aware residual theory and benchmark it against survey-specific R tooling.
- `PWEIGHT_NO_SUPPORT`: keep pweights blocked permanently except for clear error messages.

Until that decision exists:

`PWEIGHT_IMPLEMENTATION_ALLOWED: no`
