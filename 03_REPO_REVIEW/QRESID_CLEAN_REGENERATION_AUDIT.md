Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load after clean regeneration or before rerunning all tests from clean artifacts

# QRESID_CLEAN_REGENERATION_AUDIT.md

Date: 2026-05-10

POST_CHANGE_SYNC_DONE: clean regeneration audit created before artifact cleanup; final evidence must be appended after the clean run.
SUPPORT_MATRIX_SYNC_PENDING_CLEAN_REGENERATION: support matrices are currently consistent, but clean-run evidence is pending until ignored regenerables are archived, removed and recreated.

## Initial State

`CLEAN_REGENERATION_STATUS: PENDING_EXECUTION`

`PRE_CLEAN_ROOT_STATUS: clean`

`PRE_CLEAN_QRESID_STATUS: clean`

`PRE_CLEAN_SUPPORT_CONSISTENCY: PASS`

`PRE_CLEAN_FREEZE_REQUIRED: yes_after_audit_reports`

## Intended Clean Test

The clean test must prove that active tests, certification, evidence index and
HTML reports do not rely on stale ignored logs or CSVs.

Tracked canonical HTML/CSV files are not deleted during the clean test unless
their generator is explicitly under test. Ignored logs and transient CSVs are
archived and deleted.

## Evidence To Fill After Clean Run

| gate | expected result | observed result |
|---|---|---|
| Archive created | `PASS` | `PENDING` |
| Ignored regenerables deleted | `PASS` | `PENDING` |
| `run_all_tests.do` | `QRESID_TEST_STATUS PASS` | `PENDING` |
| `hardening_smoke.do` | `QRESID_HARDENING_SMOKE_STATUS PASS` | `PENDING` |
| `certify_phase1.do` | `PASS_EXPERIMENTAL_EXTENSION_LOCAL_STATA_COMPONENTS` | `PENDING` |
| R benchmark checkers | `PASS` | `PENDING` |
| support evidence index rebuild | `PASS` | `PENDING` |
| support report consistency | `PASS` | `PENDING` |
| root git status | clean after final commit | `PENDING` |
| `qresid/` git status | clean after final commit | `PENDING` |

## Failure Policy

If any gate fails:

- do not tag clean regeneration;
- document the exact failed gate and latest log path;
- fix only the failing generator/test/sync path;
- rerun the smallest affected gate first;
- rerun full clean checks only after the focal gate is green.

