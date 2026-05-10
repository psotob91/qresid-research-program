Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load during iterative release-management decisions

# CURRENT_BLOCKERS_AND_DEFERRED.md

Date: 2026-05-10

Status source: hardening iteration evidence after local tests, smoke checks, certification and benchmarks.

| item | severity | blocks_current_stage | blocks_release | defer_recommended | target_phase |
|---|---|---|---|---|---|
| executable `.do` examples missing | IGNORE_FOR_NOW | no | no | no | resolved in hardening |
| install smoke not verified | IGNORE_FOR_NOW | no | no | no | resolved in hardening |
| help examples smoke not verified | IGNORE_FOR_NOW | no | no | no | resolved in hardening |
| release/pre-release certification missing | IGNORE_FOR_NOW | no | no | no | resolved for local prerelease |
| Gaussian benchmark missing | IGNORE_FOR_NOW | no | no | no | resolved in hardening |
| Poisson benchmark missing | IGNORE_FOR_NOW | no | no | no | resolved in hardening |
| Bernoulli benchmark missing | IGNORE_FOR_NOW | no | no | no | resolved in hardening |
| stale Phase 1B wording in help | IGNORE_FOR_NOW | no | no | no | resolved in hardening |
| stale Phase 1B wording in public ado error | IGNORE_FOR_NOW | no | no | no | resolved in hardening |
| dedicated `logistic` test missing | IGNORE_FOR_NOW | no | no | no | resolved in hardening |
| dedicated `glm gaussian` test missing | IGNORE_FOR_NOW | no | no | no | resolved in hardening |
| dedicated `glm poisson` test missing | IGNORE_FOR_NOW | no | no | no | resolved in hardening |
| package payload decision for README/LICENSE/changelog | HIGH_PRIORITY | no | no | no | prerelease packaging |
| root changelog policy | NICE_TO_HAVE | no | no | yes | docs/release policy |
| broader stress testing beyond local prerelease gate | NICE_TO_HAVE | no | no | yes | post-prerelease hardening |
| formal MCP-mediated execution | IGNORE_FOR_NOW | no | no | yes | infrastructure |
| NB stable support | FUTURE_PHASE | no | no | yes | research-gated future phase |
| weights support | FUTURE_PHASE | no | no | yes | research-gated future phase |
| grouped binomial support | FUTURE_PHASE | no | no | yes | future Phase 1 extension |
| ZIP/ZINB support | FUTURE_PHASE | no | no | yes | Phase 2 |
| hurdle models | FUTURE_PHASE | no | no | yes | Phase 2 |
| truncated models | FUTURE_PHASE | no | no | yes | Phase 2 |
| mixed/GLMM/GSEM models | FUTURE_PHASE | no | no | yes | Phase 2/3 |

## Current Decision

Decision: `ADVANCE_TO_NEXT_STAGE`

The current hardening blockers are resolved for local prerelease readiness. The next stage should focus on prerelease payload and release-policy review, not on expanding model support.

## Post-Change Sync

POST_CHANGE_SYNC_DONE

Active decision reports were updated. Historical snapshots and pre-MCP reports were not rewritten.
