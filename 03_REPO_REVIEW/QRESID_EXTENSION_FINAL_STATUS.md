Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before extension branch continuation

# QRESID_EXTENSION_FINAL_STATUS.md

Date: 2026-05-10

POST_CHANGE_SYNC_DONE: final extension status registered for active retrieval.

## Final Status

`QRESID_EXTENSION_BRANCH_STATUS: IG_FWEIGHT_EXPERIMENTAL_FROZEN`

## Passed And Implemented

| feature | status | notes |
|---|---|---|
| grouped binomial `glm` | `IMPLEMENTED_EXPERIMENTAL_TESTED` | unweighted, five links |
| NB `nbreg, dispersion(mean)` | `IMPLEMENTED_EXPERIMENTAL_TESTED` | unweighted NB2-style route |
| inverse Gaussian `glm` | `IMPLEMENTED_EXPERIMENTAL_TESTED` | links `power -2`, `log`, `identity`, `power -1`; none/fweight |
| expanded direct `fweight` | `IMPLEMENTED_EXPERIMENTAL_TESTED` | Gaussian, Poisson, Bernoulli, grouped binomial, NB mean-dispersion, Gamma, inverse Gaussian; no final residual multiplier |
| direct `[pweight=]` | `IMPLEMENTED_EXPERIMENTAL_STATA_ONLY_DIAGNOSTIC` | no `svy:` claim |

## Still Deferred

- `binreg` grouped aliases.
- `aweight`, `iweight`, `svy:` and weighted routes outside direct `fweight`.
- NB `dispersion(constant)`, `gnbreg`, offset/exposure and non-log links.
- ZIP/ZINB, hurdle, truncation, mixed/GLMM/GSEM.

## Freeze Status

Package-side freeze:

- `qresid/` commit: `872d098 feat: add inverse gaussian and expanded fweight support`
- `qresid/` tag: `v0.1.0-extension-ig-fweight.1`

Root checkpoint:

- root commit message: `chore: checkpoint inverse gaussian fweight extension`
- root tag: `qresid-extension-ig-fweight-freeze.1`

No push is performed automatically.
