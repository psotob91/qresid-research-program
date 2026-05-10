Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before any `glm, family(nbinomial ml)` support decision

# QRESID_GLM_NBINOMIAL_ML_EXTRACTION_AUDIT.md

Date: 2026-05-10

POST_CHANGE_SYNC_DONE: GLM NB ML extraction audit created and linked to support matrices.
SUPPORT_MATRIX_SYNC_DONE: `glm nbinomial ml` remains a gated variant with a clearer controlled error.

## Decision

`GLM_NBINOMIAL_ML_IMPLEMENTATION_ALLOWED: no`

`GLM_NBINOMIAL_ML_BENCHMARK_ALLOWED: gate-only`

## Evidence

- Stata `glm, family(nbinomial ml)` estimates the NB parameter internally.
- Local inspection of `glm.ado` and probes show the exact alpha is not left in
  a robust public `e(alpha)` scalar.
- `e(varfuncf)` contains a display string such as `u+(.4307)u^2`, but that is
  rounded and unsuitable for exact CDF endpoints.
- The route now fails in `qresid` with a clear message recommending `nbreg` or
  fixed-parameter `glm, family(nbinomial #)`.

## Logs

- Stata: `qresid/tests/logs/*_glm_nbinomial_ml_extraction_stata.log`
- R gate checker: `qresid/tests/logs/*_glm_nbinomial_ml_extraction_r.log`

## Next Action

Do not claim support until Stata exposes the exact estimated parameter through
postestimation metadata or a formally accepted refit equivalence is approved.
