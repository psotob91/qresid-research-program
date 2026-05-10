Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before extension prerelease promotion

# QRESID_EXTENSION_RELEASE_BLOCKERS.md

Date: 2026-05-10

POST_CHANGE_SYNC_DONE: blocker queue created after extension release audit.

| blocker_id | classification | severity | area | problem | required_action | evidence | blocks_experimental_freeze | blocks_prerelease_promotion | blocks_public_rc |
|---|---|---|---|---|---|---|---|---|---|
| ERB-001 | `BLOCKS_PRERELEASE_PROMOTION` | HIGH | help/examples | `.sthlp` claims experimental `fweight` and direct `[pweight=]` support but lacks dedicated executable examples. | Add help examples and run help/examples smoke. | `qresid.sthlp` support section; style rules require examples for supported paths. | no | yes | yes |
| ERB-002 | `SHOULD_FIX` | MEDIUM | package metadata | `qresid.pkg` and `stata.toc` still use generic "tested Phase 1 families" wording. | Review wording before extension prerelease so metadata reflects experimental extension scope without overclaiming. | `qresid.pkg`, `stata.toc`. | no | no | yes |
| ERB-003 | `BLOCKS_PUBLIC_RC` | HIGH | pweight policy | Direct `[pweight=]` is `STATA_ONLY_DIAGNOSTIC`, not R/base exact and not `svy:`. | Human release-policy decision before public RC: include as experimental diagnostic, hide from public docs, or split branch. | pweight diagnostic R log and `PWEIGHT_SURVEY_DIAGNOSTIC_RESEARCH_PLAN.md`. | no | no | yes |
| ERB-004 | `CAN_DEFER` | LOW | benchmarks | NB offset/exposure, NB non-log links, grouped `binreg`, `aweight`, `iweight`, and weighted grouped/NB remain unimplemented. | Keep deferred; do not block extension prerelease if unsupported routes remain clearly gated. | `QRESID_EXTENSION_FINAL_STATUS.md`. | no | no | no |
| ERB-005 | `FUTURE_PHASE` | LOW | phase scope | ZIP/ZINB, hurdle, truncation, mixed/GLMM/GSEM remain out of scope. | Keep excluded from release claims. | `AGENTS.md`, `09`, registry. | no | no | no |

## Current Blocking Summary

- `BLOCKS_EXPERIMENTAL_FREEZE`: none.
- `BLOCKS_PRERELEASE_PROMOTION`: ERB-001.
- `BLOCKS_PUBLIC_RC`: ERB-001, ERB-002, ERB-003.

