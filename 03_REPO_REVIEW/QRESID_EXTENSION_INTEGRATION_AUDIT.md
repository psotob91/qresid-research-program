Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before extension freeze or next implementation decision

# QRESID_EXTENSION_INTEGRATION_AUDIT.md

Date: 2026-05-10

Status source: `dev-qresid-extension-integrated`; local Stata/R tests and benchmarks.

POST_CHANGE_SYNC_DONE: registry and active gate reports updated.

## Decision

`EXTENSION_INTEGRATION_STATUS: PASS_EXPERIMENTAL`

The integrated experimental branch can be frozen as a development checkpoint. It is not a public RC and does not replace the prerelease tag.

## Integrated Support

- Grouped binomial: `glm, family(binomial trials)` with links `logit`, `probit`, `cloglog`, `log`, `identity`.
- NB: unweighted `nbreg, dispersion(mean)` using `theta = 1/e(alpha)`.
- Weights: direct `fweight` for Gaussian `regress` and Poisson `poisson`.
- Pweight: direct `[pweight=]` experimental model-based diagnostics for Gaussian, Poisson and Bernoulli; not `svy:`.

## Evidence

The local certification gate passed with `QRESID_CERTIFICATION_STATUS PASS_EXPERIMENTAL_EXTENSION_LOCAL_STATA_COMPONENTS`.

R-side checks passed for grouped binomial, NB and fweight. Pweight remains `STATA_ONLY_DIAGNOSTIC`, which is expected and does not claim exact R/base equivalence.

## Residual Risks

- NB estimator equivalence is narrower than full MASS/Stata ML equivalence; implementation uses Stata postestimation parameters and R CDF endpoint checks.
- Pweight is experimental and diagnostic-only.
- `aweight`, `iweight`, `svy:`, grouped-binomial weights and NB weights remain blocked.

