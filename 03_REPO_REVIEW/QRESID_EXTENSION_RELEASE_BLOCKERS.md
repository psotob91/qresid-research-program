Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before extension prerelease promotion

# QRESID_EXTENSION_RELEASE_BLOCKERS.md

Date: 2026-05-10

POST_CHANGE_SYNC_DONE: blocker queue updated after extension hardening validation.

| blocker_id | classification | severity | area | problem | required_action | evidence | blocks_experimental_freeze | blocks_prerelease_promotion | blocks_public_rc |
|---|---|---|---|---|---|---|---|---|---|
| ERB-001 | `RESOLVED_FOR_EXTENSION_PRERELEASE` | NONE | help/examples | `.sthlp` previously claimed experimental `fweight` and direct `[pweight=]` support without dedicated executable examples. | Closed: help examples and repo examples added; examples smoke passed. | `qresid.sthlp`; `examples/example_fweight_*.do`; `examples/example_pweight_*.do`; `10_May_2026_144247_hardening_smoke.log`. | no | no | no |
| ERB-002 | `RESOLVED_FOR_EXTENSION_PRERELEASE` | NONE | package metadata | `qresid.pkg` and `stata.toc` previously used generic "tested Phase 1 families" wording. | Closed for extension prerelease: wording now says tested families and experimental extension routes without expanding install payload. | `qresid.pkg`, `stata.toc`. | no | no | no |
| ERB-003 | `BLOCKS_PUBLIC_RC` | HIGH | pweight policy | Direct `[pweight=]` is `STATA_ONLY_DIAGNOSTIC`, not R/base exact and not `svy:`. | Human release-policy decision before public RC: include as experimental diagnostic, hide from public docs, or split branch. | pweight diagnostic R log and `PWEIGHT_SURVEY_DIAGNOSTIC_RESEARCH_PLAN.md`. | no | no | yes |
| ERB-004 | `CAN_DEFER` | LOW | benchmarks | NB offset/exposure, NB non-log links, grouped `binreg`, `aweight`, `iweight`, and weighted grouped/NB remain unimplemented. | Keep deferred; unsupported routes remain clearly gated. | `QRESID_EXTENSION_FINAL_STATUS.md`. | no | no | no |
| ERB-005 | `FUTURE_PHASE` | LOW | phase scope | ZIP/ZINB, hurdle, truncation, mixed/GLMM/GSEM, inverse Gaussian and Tweedie remain out of scope. | Keep excluded from release claims; require separate research gates. | `AGENTS.md`, `09`, registry. | no | no | no |

## Current Blocking Summary

- `BLOCKS_EXPERIMENTAL_FREEZE`: none.
- `BLOCKS_PRERELEASE_PROMOTION`: none.
- `BLOCKS_PUBLIC_RC`: ERB-003.
