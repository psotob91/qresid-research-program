Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before Phase 1B implementation

# OVERNIGHT_TEST_RESULTS.md

Fecha: 2026-05-10

## 1. Resultado General

`PASS_WITH_EXPECTED_FAILURES`

No hubo fallos inesperados.

## 2. Logs

| log | purpose | status |
|---|---|---|
| `qresid/tests/logs/10_May_2026_052416_run_all_tests.log` | runner directo | `PASS_WITH_EXPECTED_FAILURES` |
| `qresid/tests/logs/10_May_2026_052419_run_all_tests.log` | runner llamado desde certification | `PASS_WITH_EXPECTED_FAILURES` |
| `qresid/certification/logs/10_May_2026_052419_certify_phase1.log` | certification scaffold | `PASS_WITH_EXPECTED_FAILURES` |
| `05_MCP_STATA_EXECUTION/logs/20260510_052414_overnight_run_all_process_output.txt` | Stata process output | empty, no shell stderr/stdout |
| `05_MCP_STATA_EXECUTION/logs/20260510_052416_overnight_certify_process_output.txt` | Stata process output | empty, no shell stderr/stdout |

## 3. Test Summary

| metric | value |
|---|---:|
| `PASS_CURRENT` | 6 |
| `EXPECTED_FAIL_BEFORE_PHASE1B` | 4 |
| `UNEXPECTED_FAIL_STOP` | 0 |

## 4. Tests Clasificados

| test_id | class | result |
|---|---|---|
| P0-LOAD-001 | load local command | `PASS_CURRENT` |
| P0-LOAD-002 | find `qresid.ado` | `PASS_CURRENT` |
| P0-LOAD-003 | find `qresid.sthlp` | `PASS_CURRENT` |
| P0-SMOKE-001 | `regress` + historical `qresid` | `PASS_CURRENT` |
| P0-API-001 | `seed()` option | `EXPECTED_FAIL_BEFORE_PHASE1B`, rc = 198 |
| P0-API-002 | `generate()` rejected | `PASS_CURRENT` |
| P0-API-003 | existing output rejected | `PASS_CURRENT` |
| P0-RNG-001 | `uvar()` option | `EXPECTED_FAIL_BEFORE_PHASE1B`, rc = 198 |
| P0-PIT-001 | `saveflo()`/`savefhi()`/`saveu()` | `EXPECTED_FAIL_BEFORE_PHASE1B`, rc = 198 |
| P0-RETURN-001 | `r()` returned results | `EXPECTED_FAIL_BEFORE_PHASE1B`, rc = 111 |

## 5. Interpretation

The current package loads and the historical `regress` path runs. The approved Phase 1 API, audit outputs and returned results are not implemented yet, as expected.

Post-change documentation sync: `POST_CHANGE_SYNC_DONE`
