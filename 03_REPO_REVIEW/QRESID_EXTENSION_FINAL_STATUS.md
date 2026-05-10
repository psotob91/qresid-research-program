Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before extension branch continuation

# QRESID_EXTENSION_FINAL_STATUS.md

Date: 2026-05-10

POST_CHANGE_SYNC_DONE: final extension status registered for active retrieval.

## Final Status

`QRESID_EXTENSION_BRANCH_STATUS: READY_TO_FREEZE_EXPERIMENTAL`

## Passed And Implemented

| feature | status | notes |
|---|---|---|
| grouped binomial `glm` | `IMPLEMENTED_EXPERIMENTAL_TESTED` | unweighted, five links |
| NB `nbreg, dispersion(mean)` | `IMPLEMENTED_EXPERIMENTAL_TESTED` | unweighted NB2-style route |
| `fweight` Gaussian/Poisson | `IMPLEMENTED_EXPERIMENTAL_TESTED` | no final residual multiplier |
| direct `[pweight=]` | `IMPLEMENTED_EXPERIMENTAL_STATA_ONLY_DIAGNOSTIC` | no `svy:` claim |

## Still Deferred

- `binreg` grouped aliases.
- `aweight`, `iweight`, NB weights and grouped-binomial weights.
- NB `dispersion(constant)`, `gnbreg`, offset/exposure and non-log links.
- `svy:`.
- ZIP/ZINB, hurdle, truncation, mixed/GLMM/GSEM.

## Freeze Recommendation

Create a local experimental checkpoint commit and tag after confirming root and subrepo status. Do not push automatically.
