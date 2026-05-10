Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before branch promotion or release policy decision

# QRESID_EXTENSION_PROMOTION_DECISION.md

Date: 2026-05-10

POST_CHANGE_SYNC_DONE: promotion decision registered after release audit.

## Decision

`PROMOTION_DECISION: ITERATE_EXTENSION_HARDENING`

The branch should stay frozen as an experimental checkpoint and should not yet be promoted to an extension prerelease tag.

## Rationale

All critical computation and benchmark gates passed, including install/help smoke, examples smoke, Stata certification, R checks for grouped binomial/NB/fweight, and pweight direct diagnostic. However, extension prerelease promotion requires public help examples for every claimed support path. The current `.sthlp` has grouped binomial and NB examples, but not examples for the newly claimed experimental `fweight` and direct `[pweight=]` routes.

## Promotion Criteria For Next Iteration

Move to `PROMOTE_TO_EXTENSION_PRERELEASE_READY` only after:

- `fweight` and direct `[pweight=]` have executable help examples or the public claims are narrowed.
- examples smoke confirms those examples run.
- `qresid.pkg` / `stata.toc` wording is reviewed for extension prerelease accuracy.
- certification and R checks remain green.

## Current Release Boundary

Allowed to keep as experimental:

- grouped binomial `glm`;
- unweighted `nbreg, dispersion(mean)`;
- `fweight` Gaussian/Poisson;
- direct `[pweight=]` Gaussian/Poisson/Bernoulli as model-based diagnostic.

Not allowed for public RC without human policy decision:

- direct `[pweight=]` as standard/survey-exact support;
- `svy:`;
- `aweight`, `iweight`;
- NB weights or grouped-binomial weights;
- Phase 2 families.

## Next Prompt

```text
PLEASE IMPLEMENT THIS PLAN:
Run one extension hardening iteration: add executable help/examples for fweight Gaussian/Poisson and direct [pweight=] Gaussian/Poisson/Bernoulli, review qresid.pkg/stata.toc wording for extension prerelease, rerun install/help/examples smoke, certification and R checkers, then update QRESID_EXTENSION_RELEASE_AUDIT.md, QRESID_EXTENSION_RELEASE_BLOCKERS.md and QRESID_EXTENSION_PROMOTION_DECISION.md. Do not implement new families.
```

