Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before extension integration or freeze decisions

# EXTENSION_WORKTREE_EXECUTION_STATUS.md

Date: 2026-05-10

Status source: integrated branch `dev-qresid-extension-integrated`; local Stata/R execution.

POST_CHANGE_SYNC_DONE: active gate reports and registry updated after extension integration.

## Summary

All four extension worktree scopes were executed and reconciled into the integrated experimental branch.

| worktree_scope | outcome | implementation_status | evidence |
|---|---|---|---|
| grouped binomial | PASS | implemented experimental `glm, family(binomial trials)` | Stata benchmark PASS; R checker PASS |
| NB | PASS | implemented experimental `nbreg, dispersion(mean)` | Stata benchmark PASS; R CDF/RQR checker PASS |
| conventional weights | PASS | implemented experimental `fweight` for Gaussian/Poisson | Stata benchmark PASS; R checker PASS |
| pweight direct | PASS_DIAGNOSTIC | implemented experimental direct `[pweight=]` for Gaussian/Poisson/Bernoulli | Stata diagnostic PASS; R status `STATA_ONLY_DIAGNOSTIC` |

## Not Implemented

- `binreg` grouped aliases.
- NB `dispersion(constant)`, `gnbreg`, NB weights, NB offset/exposure, non-log NB links.
- `aweight`, `iweight`, grouped-binomial weights.
- `svy:` and survey-exact pweight residuals.
- ZIP/ZINB, hurdle, truncation, mixed/GLMM/GSEM.

## Latest Local Evidence

- `QRESID_TEST_STATUS PASS`
- `QRESID_HARDENING_SMOKE_STATUS PASS`
- `QRESID_CERTIFICATION_STATUS PASS_EXPERIMENTAL_EXTENSION_LOCAL_STATA_COMPONENTS`
- `QRESID_GROUPED_BINOMIAL_R_STATUS PASS`
- `QRESID_NB_R_STATUS PASS`
- `QRESID_FWEIGHT_R_STATUS PASS`
- `PWEIGHT_R_STATUS STATA_ONLY_DIAGNOSTIC`

