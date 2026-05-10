Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before branch promotion or release policy decision

# QRESID_EXTENSION_PROMOTION_DECISION.md

Date: 2026-05-10

POST_CHANGE_SYNC_DONE: promotion decision updated after extension hardening and validation.

## Decision

`PROMOTION_DECISION: PROMOTE_TO_EXTENSION_PRERELEASE_READY`

The branch may be tagged as a local extension prerelease checkpoint. It should not be promoted to public RC without a human release-policy decision on direct `[pweight=]` diagnostic support.

## Rationale

The prior blocker was resolved. Experimental direct `fweight` and `[pweight=]` routes now have executable help examples and repo examples. Help now includes a concise methods section explaining PIT, Dunn-Smyth randomized quantile residuals, CDF endpoints, `uvar()`, approximate normality with estimated parameters, and references.

The latest extension cycle adds inverse Gaussian `glm, family(igaussian)` and expanded direct `fweight` routes after dedicated Stata/R endpoint and residual checks.

Validation passed after the hardening changes:

- install/help/examples smoke: `PASS`;
- Stata certification: `PASS_EXPERIMENTAL_EXTENSION_LOCAL_STATA_COMPONENTS`;
- Gamma, Phase 1, GLM/link, grouped binomial, NB and fweight R checks: `PASS`;
- inverse Gaussian and expanded fweight R checks: `PASS`;
- pweight direct R status: `STATA_ONLY_DIAGNOSTIC`.

## Current Release Boundary

Allowed in local extension prerelease:

- grouped binomial `glm`;
- unweighted `nbreg, dispersion(mean)`;
- inverse Gaussian `glm` for tested links;
- direct `fweight` Gaussian, Poisson, Bernoulli, grouped binomial, NB mean-dispersion, Gamma and inverse Gaussian;
- direct `[pweight=]` Gaussian/Poisson/Bernoulli as model-based diagnostic;
- expanded help theory and references.

Not allowed for public RC without human policy decision:

- direct `[pweight=]` as standard/survey-exact support;
- `svy:`;
- `aweight`, `iweight`;
- weighted routes outside direct `fweight`;
- Tweedie, ZIP/ZINB, hurdle, truncation, mixed/GLMM/GSEM.

## Next Prompt

```text
PLEASE IMPLEMENT THIS PLAN:
Create local annotated tags for the extension prerelease: v0.1.0-extension-prerelease.1 in qresid/ and qresid-v0.1.0-extension-prerelease.1 in the root repo. Do not push. Then prepare a public-RC policy brief focused on direct [pweight=] diagnostic support.
```
