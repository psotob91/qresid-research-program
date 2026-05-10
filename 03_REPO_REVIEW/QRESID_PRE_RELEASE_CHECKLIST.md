Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before any release candidate checklist execution

# QRESID_PRE_RELEASE_CHECKLIST.md

Date: 2026-05-10

Status source: hardening iteration evidence after local tests, smoke checks, certification and benchmarks.

Current transition: `NOT_READY` -> `PRERELEASE_READY_LOCAL`.

## 1. Gate Checklist

| gate_id | gate | required_status_before_prerelease | current_status |
|---|---|---|---|
| PRC-001 | root git status clean or only approved release audit reports pending | pass | pending prerelease payload commit |
| PRC-002 | `qresid/` git status clean | pass | pending prerelease README/changelog commit |
| PRC-003 | install smoke from package metadata | pass | pass: `10_May_2026_114036_hardening_smoke.log` |
| PRC-004 | `help qresid` opens | pass | pass: `10_May_2026_114036_hardening_smoke.log` |
| PRC-005 | all public examples execute | pass | pass: `10_May_2026_114036_hardening_smoke.log` |
| PRC-006 | `examples/` contains executable `.do` files | pass | pass |
| PRC-007 | release/pre-release certification gate exists | pass | pass: `certify_phase1.do` local pre-release Stata components |
| PRC-008 | certification label is not development-only | pass | pass: `PASS_PRERELEASE_LOCAL_STATA_COMPONENTS` |
| PRC-009 | Gaussian benchmark recorded | pass | pass: `10_May_2026_114159_phase1_benchmark_r.log` |
| PRC-010 | Poisson benchmark recorded | pass | pass: `10_May_2026_114159_phase1_benchmark_r.log` |
| PRC-011 | Bernoulli benchmark recorded | pass | pass: `10_May_2026_114159_phase1_benchmark_r.log` |
| PRC-012 | Gamma benchmark recorded | pass | pass: `10_May_2026_114159_gamma_benchmark_r.log` |
| PRC-013 | unsupported families fail with controlled errors | pass | pass for NB/weights/family contradiction gates in current tests |
| PRC-014 | no prompts/internal traces in tracked package payload | pass | no issue found in public files touched |
| PRC-015 | raw logs are not tracked package payload | pass | pass; logs ignored |
| PRC-016 | README, `.sthlp`, `pkg`, `toc`, changelog synchronized | pass | pass for local prerelease scope |
| PRC-017 | prerelease payload policy decided | pass | pass: `PRERELEASE_PAYLOAD_MINIMAL_SSC_STYLE` |

## 2. Latest Commands Run

```stata
do "C:/qresid-research-program/qresid/tests/run_all_tests.do"
do "C:/qresid-research-program/qresid/tests/hardening_smoke.do"
do "C:/qresid-research-program/qresid/certification/certify_phase1.do"
```

```powershell
Rscript C:/qresid-research-program/qresid/tests/benchmark_gamma_r.R C:/qresid-research-program/qresid/tests/logs/10_May_2026_114159_gamma_benchmark.csv
Rscript C:/qresid-research-program/qresid/tests/benchmark_phase1_r.R C:/qresid-research-program/qresid/tests/logs/10_May_2026_114159_phase1_benchmark.csv
```

## 3. Public Package Hygiene Checklist

- [x] `qresid.ado` first executable line remains `version`.
- [x] `qresid.ado` public errors use release-neutral wording, not stale phase labels.
- [x] `qresid.sthlp` syntax matches implementation.
- [x] `qresid.sthlp` examples have executable `.do` equivalents.
- [x] `qresid.sthlp` does not claim NB/weights/Phase2 support.
- [x] `README.md` does not claim public release certification.
- [x] `qresid.pkg` installs required ado/help files.
- [x] `stata.toc` description is brief and public.
- [x] `examples/` is populated with executable `.do` examples.
- [x] Logs under `tests/logs/`, `examples/logs/` and `certification/logs/` remain ignored.
- [x] No prompts, agent notes, scratch text or internal plans appear in public package files touched.

## 4. Decision Rule

Set current readiness to `PRERELEASE_READY_LOCAL`.

Do not set public `RC_READY` until:

- prerelease payload policy is reviewed;
- git status is clean after commits;
- a human release threshold decision is made for public RC/tagging.

Set tag readiness to `READY_TO_TAG_PRERELEASE_LOCAL` after README/changelog
payload wording is committed and both root and `qresid/` are clean.

## 5. Post-Change Sync

POST_CHANGE_SYNC_DONE
