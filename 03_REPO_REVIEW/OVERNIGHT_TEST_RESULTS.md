Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before release or further Phase 1 implementation

# OVERNIGHT_TEST_RESULTS.md

Fecha: 2026-05-10

## 1. Resultado General

`PASS_PHASE1C_NOT_RELEASE`

No hubo fallos inesperados.

## 2. Logs

| log | purpose | status |
|---|---|---|
| `qresid/tests/logs/10_May_2026_055421_run_all_tests.log` | runner directo desde certification | `PASS` |
| `qresid/certification/logs/10_May_2026_055421_certify_phase1.log` | certification development gate | `PASS_PHASE1C_NOT_RELEASE` |
| `qresid/tests/logs/10_May_2026_055338_gamma_benchmark_stata.log` | Gamma Stata benchmark producer | `PASS` |
| `qresid/tests/logs/10_May_2026_055338_gamma_benchmark_r.log` | Gamma R benchmark checker | `PASS` |
| `qresid/tests/logs/10_May_2026_055338_gamma_benchmark_r_check.csv` | Gamma R summary | `PASS` |

## 3. Test Summary

| metric | value |
|---|---:|
| `PASS_CURRENT` | 16 |
| `EXPECTED_FAIL_BEFORE_PHASE1B` | 0 |
| `UNEXPECTED_FAIL_STOP` | 0 |

## 4. Coverage

| area | result |
|---|---|
| local command load | `PASS` |
| official API parser | `PASS` |
| `generate()` rejection | `PASS` |
| existing output rejection | `PASS` |
| `seed()` | `PASS` |
| `uvar()` | `PASS` |
| `savev()` | `PASS` |
| `saveflo()`/`savefhi()`/`saveu()` | `PASS` |
| `family()` contradiction rejection | `PASS` |
| `marksample`/`if` restriction | `PASS` |
| returned `r()` results | `PASS` |
| Gaussian `regress` | `PASS` |
| Poisson `poisson` | `PASS` |
| Bernoulli `logit` | `PASS` |
| Gamma `glm, family(gamma)` | `PASS` |
| weighted models | controlled error gate |

## 5. Gamma Benchmark

Datasets:

- `synthetic_known_shape`
- `stata_auto_positive`
- `adversarial_small_positive`

R checker status: `PASS`.

Maximum observed differences:

- `abs_diff_u <= 3.4e-15`
- `abs_diff_qr <= 8.4e-15`

## 6. Interpretation

The package now has a tested local development implementation for Gaussian,
Poisson, Bernoulli, and unweighted Gamma. This is not a release certification:
NB, weights, grouped binomial, ZIP/ZINB, hurdle, truncated, and mixed models
remain gated.

Post-change documentation sync: `POST_CHANGE_SYNC_DONE`
