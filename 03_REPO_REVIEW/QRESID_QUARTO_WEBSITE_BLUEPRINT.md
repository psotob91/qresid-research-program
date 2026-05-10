Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before editing the Quarto teaching website

# QRESID_QUARTO_WEBSITE_BLUEPRINT.md

Date: 2026-05-10

POST_CHANGE_SYNC_DONE: blueprint created for the first qresid Quarto teaching/manual prototype.

## Goal

Create a teaching website in the spirit of clear, example-first package documentation such as `ggeffects`: short explanations, reproducible code, visible diagnostic plots, and a practical path from model fit to residual interpretation.

The website is not SSC payload and not a support authority. It is a user manual and casebook built from the active support matrices and examples.

## Page Structure

| page | audience question | models/examples | required visuals |
|---|---|---|---|
| Home / interpretation | Why use quantile residuals? | one Gaussian and one count example | QQ normal, residual vs fitted |
| Continuous uncorrelated | How do I diagnose positive and normal outcomes? | Gaussian, Gamma, inverse Gaussian | QQ normal; residual vs fitted; residual vs covariate |
| Count uncorrelated | How do I distinguish Poisson, NB, ZIP/ZINB, truncated/censored, generalized Poisson and hurdle? | simulated and health count examples | side-by-side QQ normal and residual vs fitted across wrong/correct models |
| Binomial outcomes | How do Bernoulli and grouped binomial residuals work? | `esoph` or simulated grouped binomial | QQ normal; residual vs fitted/probability |
| Weights and diagnostics | What do `fweight` and direct `pweight` mean? | tested routes only | QQ normal plus notes about diagnostics vs exact benchmarks |
| Real health case studies | How does this work on real data? | `NMES1988`, `bioChemists` if used as publication count, `esoph`, possible `Contraception` as future correlated bridge | compare incorrect and improved models |
| Future correlated models | What is not supported yet? | GLMM/panel/GSEM/DHARMa explanation | no support claims; conceptual diagrams only |

## Dataset Priorities

Prefer script-based access to open datasets rather than bundling them in the Stata package. Health-oriented priorities from the casebank:

- `NMES1988` from `AER`: medical visits; Poisson vs NB vs ZIP/ZINB/hurdle-style comparisons.
- `esoph` from base R datasets: grouped binomial cancer case-control strata.
- `Contraception` from `mlmRev`: bridge to future correlated models; use only marginal examples unless the page is explicitly future/simulation.
- `bioChemists` from `pscl`: useful count example, not health but excellent for zero/sobredispersion teaching.

## Standard Teaching Pattern

Each model page should use:

1. Short setup: what outcome/support is being modeled.
2. Fit a plausible model and one deliberately imperfect model.
3. Run `qresid`, saving endpoints when useful.
4. Plot `qnorm rq` as the basic normality graph.
5. Plot residual vs fitted and residual vs key covariate.
6. Explain the pattern in plain language.
7. Link to the support matrix for current status.

## Quarto Prototype Rules

- Keep code chunks small and executable.
- Do not include private data or generated heavy outputs.
- Do not claim public RC readiness.
- Use badges/links to the support matrix and glossary.
- If a page uses external Stata estimators, state that they must be installed separately and are not in `qresid.pkg`.
