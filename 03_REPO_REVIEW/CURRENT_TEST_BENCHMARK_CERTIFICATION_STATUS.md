Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before release, certification or benchmark decisions

# CURRENT_TEST_BENCHMARK_CERTIFICATION_STATUS.md

Date: 2026-05-10

Status source: extension count-model evidence after local tests, smoke checks, certification and benchmarks.

## 1. Status

Overall status: `EXTENSION_PRERELEASE_READY_LOCAL`

This is local Stata/R evidence, not public SSC release certification.

## 2. Tests Existing

| artifact | status |
|---|---|
| `tests/run_all_tests.do` | present; latest run passed |
| `tests/hardening_smoke.do` | present; install/help/examples smoke passed |
| `tests/benchmark_gamma_stata.do` | present; latest Stata producer passed |
| `tests/benchmark_gamma_r.R` | present; latest R checker passed |
| `tests/benchmark_phase1_stata.do` | present; Gaussian/Poisson/Bernoulli producer passed |
| `tests/benchmark_phase1_r.R` | present; Gaussian/Poisson/Bernoulli checker passed |
| `tests/benchmark_glm_link_matrix_stata.do` | present; GLM/link matrix producer passed |
| `tests/benchmark_glm_link_matrix_r.R` | present; GLM/link matrix R checker and HTML report passed |
| `tests/benchmark_grouped_binomial_stata.do` | present; grouped-binomial and `binreg, n()` producer passed |
| `tests/benchmark_grouped_binomial_r.R` | present; grouped-binomial and `binreg, n()` checker passed |
| `tests/benchmark_nb_stata.do` | present; NB2 no-offset, `offset()`, and `exposure()` producer passed |
| `tests/benchmark_nb_r.R` | present; NB2 no-offset, `offset()`, and `exposure()` checker passed |
| `tests/benchmark_fweight_extended_stata.do` | present; expanded fweight producer passed |
| `tests/benchmark_fweight_extended_r.R` | present; expanded fweight checker passed |
| `certification/certify_phase1.do` | present; local pre-release Stata components passed |

## 3. Latest Evidence

| evidence | log | status |
|---|---|---|
| main test runner | `qresid/tests/logs/10_May_2026_173614_run_all_tests.log` | `QRESID_TEST_STATUS PASS` |
| install/help/examples smoke | `qresid/tests/logs/10_May_2026_173614_hardening_smoke.log` | `QRESID_HARDENING_SMOKE_STATUS PASS` |
| local certification | `qresid/certification/logs/10_May_2026_173636_certify_phase1.log` | `PASS_EXPERIMENTAL_EXTENSION_LOCAL_STATA_COMPONENTS` |
| Gamma R benchmark | `qresid/tests/logs/10_May_2026_173641_gamma_benchmark_r_check.csv` | `QRESID_GAMMA_BENCHMARK_R_STATUS PASS` |
| Phase 1 R benchmark | `qresid/tests/logs/10_May_2026_173642_phase1_benchmark_r_check.csv` | `QRESID_PHASE1_BENCHMARK_R_STATUS PASS` |
| GLM/link matrix R benchmark | latest regenerated HTML/check | `QRESID_GLM_LINK_MATRIX_R_STATUS PASS` |
| grouped-binomial Stata/R benchmark | `qresid/tests/logs/10_May_2026_173647_grouped_binomial_benchmark_stata.log`; latest R checker | `QRESID_GROUPED_BINOMIAL_BENCHMARK_STATUS PASS`; `QRESID_GROUPED_BINOMIAL_R_STATUS PASS` |
| NB Stata/R benchmark | `qresid/tests/logs/10_May_2026_173648_nb_benchmark_stata.log`; latest R checker | `QRESID_NB_BENCHMARK_STATUS PASS`; `QRESID_NB_R_STATUS PASS` |
| expanded fweight R benchmark | `qresid/tests/logs/10_May_2026_173650_fweight_extended_benchmark.csv` | `QRESID_FWEIGHT_EXTENDED_BENCHMARK_R_STATUS PASS` |
| GLM/link matrix HTML | `qresid/certification/reports/qresid_glm_link_matrix.html` | generated |

## 4. Family Certification Status

| family/command | status | evidence |
|---|---|---|
| Gaussian `regress` | `IMPLEMENTED_LOCAL_TESTED` | tests + R benchmark |
| Gaussian `glm` path | `IMPLEMENTED_LOCAL_TESTED` | dedicated integration test |
| Poisson `poisson` | `IMPLEMENTED_LOCAL_TESTED` | tests + R benchmark |
| Poisson `glm` path | `IMPLEMENTED_LOCAL_TESTED` | dedicated integration test |
| Bernoulli `logit` | `IMPLEMENTED_LOCAL_TESTED` | tests + R benchmark |
| Bernoulli `logistic` | `IMPLEMENTED_LOCAL_TESTED` | dedicated integration test |
| Bernoulli individual `glm, family(binomial)` | `IMPLEMENTED_LOCAL_TESTED` | GLM/link matrix + integration test |
| Bernoulli individual `binreg` | `IMPLEMENTED_LOCAL_TESTED` | GLM/link matrix + integration test |
| Gamma `glm, family(gamma)` | `IMPLEMENTED_LOCAL_TESTED` | 3-dataset R/Stata benchmark |
| NB2 `nbreg, dispersion(mean)` | `READY_FOR_EXTENSION_PRERELEASE` | no-offset, `offset()`, and `exposure()` Stata/R benchmark |
| NB variants | `GATED_VARIANT` | `dispersion(constant)`, `gnbreg`, `glm nbinomial`, and untested routes |
| direct `fweight` tested routes | `IMPLEMENTED_LOCAL_TESTED` | family-specific fweight benchmarks; no final weight multiplier |
| grouped binomial | `READY_FOR_EXTENSION_PRERELEASE` | GLM grouped binomial and `binreg, n()` aliases `or`/`rr`/`rd`; `hr` Stata-internal |
| ZIP/ZINB/hurdle/truncated/mixed | `DEFERRED_PHASE2` | out of current release scope |

## 5. Remaining Before Public Release

- final payload/tag/version policy;
- optional broader stress testing;
- public release decision by maintainer.

## 6. Post-Change Sync

POST_CHANGE_SYNC_DONE
SUPPORT_MATRIX_SYNC_DONE
