Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before workflow or release-stage decisions

# CURRENT_FLOWCHART_GAP_ANALYSIS.md

Date: 2026-05-10

Status source: hardening iteration evidence after local tests, smoke checks, certification and benchmarks.

## 1. Current Workflow Position

Current position: `prerelease preparation`

The project has moved past implementation and hardening blockers for the local
scope. The next step is release-policy and payload review before any public RC.

## 2. Steps Already Superados

- MCP/local execution setup for Stata/R.
- API Opcion A.
- Phase 0/1A structure and tests.
- Phase 1B API/core.
- Phase 1C Gaussian, Poisson, Bernoulli and unweighted Gamma.
- Gamma 3-dataset R/Stata benchmark.
- Hardening blockers: examples, install/help smoke, stale wording, release-style local certification, Gaussian/Poisson/Bernoulli benchmarks.

## 3. Steps Alterados

- Formal MCP-mediated execution remains non-blocking; local Stata/R execution is the approved protocol for this stage.
- Public RC readiness is separated from local prerelease readiness.

## 4. Steps Faltantes Antes De Public RC

- Decide final payload policy for `qresid.pkg`, README, LICENSE and changelog.
- Confirm clean git status after approved commits.
- Decide tag/version policy for public RC.
- Optional: run broader stress tests if SSC/SJ threshold requires it.

## 5. Steps Diferibles

- NB.
- Weights.
- Grouped binomial.
- ZIP/ZINB, hurdle, truncados, mixed/GLMM/GSEM.
- Formal MCP-mediated execution.
- Large casebank or SJ-scale stress testing.

## 6. Obsolete Current Blockers

The following blockers are no longer active after hardening:

- examples directory placeholder only;
- install smoke `NOT_VERIFIED`;
- help/example smoke `NOT_VERIFIED`;
- missing Gaussian/Poisson/Bernoulli R benchmarks;
- stale Phase 1B wording;
- development-only certification gate.

## 7. Recommendation

Recommendation: advance to prerelease preparation.

Do not implement new model families before payload/release-policy review.

## 8. Post-Change Sync

POST_CHANGE_SYNC_DONE
