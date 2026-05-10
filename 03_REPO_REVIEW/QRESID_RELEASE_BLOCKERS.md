Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before any pre-release or release candidate decision

# QRESID_RELEASE_BLOCKERS.md

Date: 2026-05-10

Status source: hardening iteration evidence after local tests, smoke checks, certification and benchmarks.

| blocker_id | severity | classification | area | problem | required_action | evidence | blocks_rc |
|---|---|---|---|---|---|---|---|
| RB-001 | resolved | RESOLVED_LOCAL_PRERELEASE | release certification | Current certification was development-only. | Pre-release local Stata certification gate added and run. | `certification/logs/10_May_2026_114154_certify_phase1.log`: `PASS_PRERELEASE_LOCAL_STATA_COMPONENTS`. | no |
| RB-002 | resolved | RESOLVED | examples | `examples/` had no executable `.do` examples. | Added executable examples for Gaussian, Poisson, Bernoulli and Gamma plus `run_examples.do`. | `tests/logs/10_May_2026_114036_hardening_smoke.log`: examples smoke pass. | no |
| RB-003 | resolved | RESOLVED | installability | Install smoke had not been run. | Ran local install smoke from package metadata using temporary PLUS. | `tests/logs/10_May_2026_114036_hardening_smoke.log`: `QRESID_INSTALL_SMOKE PASS`. | no |
| RB-004 | resolved | RESOLVED | help examples | Help examples had not been executed. | Executed equivalent public examples via `examples/run_examples.do`. | `tests/logs/10_May_2026_114036_hardening_smoke.log`: `QRESID_EXAMPLES_SMOKE PASS`. | no |
| RB-005 | resolved | RESOLVED | benchmarks | Gaussian, Poisson and Bernoulli lacked R/Stata benchmark evidence. | Added and ran layered R/Stata benchmark for Gaussian, Poisson and Bernoulli. | `tests/logs/10_May_2026_114159_phase1_benchmark_r.log`: `QRESID_PHASE1_BENCHMARK_R_STATUS PASS`. | no |
| RB-006 | resolved | RESOLVED | help wording | Help used stale Phase 1B wording. | Updated help to current tested release scope wording. | `qresid.sthlp` updated. | no |
| RB-007 | resolved | RESOLVED | ado error wording | Unsupported-command error used stale Phase 1B wording. | Updated public error to release-neutral wording. | `qresid.ado` updated. | no |
| RB-008 | resolved | RESOLVED | tests | Dedicated `logistic` test was missing. | Added and ran dedicated `logistic` integration test. | `tests/logs/10_May_2026_114014_run_all_tests.log`: 19 pass, 0 unexpected. | no |
| RB-009 | resolved | RESOLVED | tests | Dedicated `glm gaussian` and `glm poisson` tests were missing. | Added and ran dedicated GLM path tests. | `tests/logs/10_May_2026_114014_run_all_tests.log`: 19 pass, 0 unexpected. | no |
| RB-010 | resolved | RESOLVED_FOR_PRERELEASE_LOCAL | package payload | README/LICENSE/changelog payload decision was not finalized for prerelease. | Keep `qresid.pkg` minimal with ado/help only; keep README/LICENSE/changelog/examples/tests/certification as GitHub/repo payload. Review again before public RC. | `QRESID_PRERELEASE_PAYLOAD_DECISION.md`. | no |
| RB-011 | minor | CAN_DEFER | changelog policy | No root `CHANGELOG.md`; changelog is under `changelog/`. | Decide before public release whether nested changelog is sufficient. | `qresid/changelog/CHANGELOG.md` active. | no |
| RB-012 | minor | CAN_DEFER | MCP | Formal MCP-mediated execution is not verified. | Defer unless MCP becomes release workflow requirement. | Local Stata/R protocol is approved. | no |
| RB-013 | minor | CAN_DEFER | stress testing | Broader stress tests beyond local prerelease scope are not complete. | Defer to post-prerelease hardening or SJ track if needed. | Not part of local prerelease gate. | no |
| RB-014 | major | FUTURE_PHASE | NB | NB is not implemented. | Keep gated until parametrization/CDF/R benchmark decision. | Research gate remains open. | no |
| RB-015 | major | FUTURE_PHASE | weights | Weighted residual semantics are not implemented. | Keep gated until family x weight-type matrix is decided and benchmarked. | Controlled error gate exists. | no |
| RB-016 | major | FUTURE_PHASE | grouped binomial | Grouped binomial/trials support is not implemented. | Keep gated until trials semantics are implemented and tested. | Controlled gate exists for grouped binomial GLM. | no |
| RB-017 | major | FUTURE_PHASE | Phase 2 families | ZIP/ZINB, hurdle, truncated and mixed models are not implemented. | Keep deferred; do not include in public claims. | Help/README gate these families. | no |

## Current Blocking Summary

Readiness: `PRERELEASE_READY_LOCAL`

All prior `MUST_FIX_BEFORE_RC` blockers are closed for local prerelease readiness. Remaining items are public-RC policy, future-family or post-prerelease hardening items.

Next step: prerelease payload and release-policy review before any public RC tag.

## Post-Change Sync

POST_CHANGE_SYNC_DONE
