Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before release, packaging or repo-state decisions

# CURRENT_QRESID_PACKAGE_INVENTORY.md

Date: 2026-05-10

Status source: root working tree after qresid hardening commit; root base `91af3a6`, qresid `b236630`.

## 1. Git State

| repo | state |
|---|---|
| root | updated `qresid` gitlink and review reports are part of the hardening checkpoint |
| `qresid/` | clean at `b236630 chore: harden qresid prerelease gate` |
| recent qresid commits | `b236630`, `fc0529f`, `9816dad` |
| local tag context | `checkpoint-phase1c-core-gamma` predates the hardening commit |

## 2. Current Package Tree

```text
qresid/
  qresid.ado
  qresid.sthlp
  qresid.pkg
  stata.toc
  README.md
  LICENSE
  changelog/CHANGELOG.md
  examples/
    README.md
    example_gaussian.do
    example_poisson.do
    example_bernoulli.do
    example_gamma.do
    run_examples.do
    logs/                 (ignored)
  tests/
    README.md
    run_all_tests.do
    hardening_smoke.do
    benchmark_gamma_stata.do
    benchmark_gamma_r.R
    benchmark_phase1_stata.do
    benchmark_phase1_r.R
    logs/                 (ignored)
  certification/
    README.md
    certify_phase1.do
    logs/                 (ignored)
```

## 3. Implemented Families

| family/command | status |
|---|---|
| Gaussian `regress` | `IMPLEMENTED_LOCAL_TESTED` |
| Gaussian `glm` path | `IMPLEMENTED_LOCAL_TESTED` |
| Poisson `poisson` | `IMPLEMENTED_LOCAL_TESTED` |
| Poisson `glm` path | `IMPLEMENTED_LOCAL_TESTED` |
| Bernoulli `logit` | `IMPLEMENTED_LOCAL_TESTED` |
| Bernoulli `logistic` | `IMPLEMENTED_LOCAL_TESTED` |
| Gamma `glm, family(gamma)` | `IMPLEMENTED_LOCAL_TESTED` |

## 4. Not Implemented / Deferred

| family/topic | status |
|---|---|
| NB | `NOT_IMPLEMENTED_GATED` |
| weights | `NOT_IMPLEMENTED_GATED` |
| grouped binomial | `NOT_IMPLEMENTED_GATED` |
| ZIP/ZINB, hurdle, truncados | `DEFERRED_PHASE2` |
| mixed/GLMM/GSEM | `DEFERRED_PHASE2` |

## 5. Release State

Current package state: `PRERELEASE_READY_LOCAL`.

This means local hardening gates passed. It does not mean public RC/tag policy
has been decided.

## 6. Post-Change Sync

POST_CHANGE_SYNC_DONE
