# QRESID Self-Hosted CI Audit

Date: 2026-05-11

## Scope

This audit records the GitHub Actions self-hosted runner setup for the `qresid`
package repository. The CI workflow is repository infrastructure only and is
not part of the SSC payload.

## Changes Verified

- Added `.github/workflows/stata-tests.yml` for push checks on `main` and
  `dev-qresid-extension-integrated`, plus pull requests targeting `main`.
- Added `tools/ci/run_stata_tests.ps1` to locate Stata through `STATA_EXE`,
  PATH, or common local executable names, then run the quick Stata tests.
- Updated `tests/run_all_tests.do` and `tests/hardening_smoke.do` to run from
  the repository root without user-specific absolute paths.
- Updated test and certification README files with local and CI execution
  guidance, including the rule that Stata licenses/installers do not belong in
  the repository.

## Validation

Executed locally from `qresid/`:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tools\ci\run_stata_tests.ps1
```

Result:

```text
QRESID_CI_STATUS PASS
```

Additional checks:

- `QRESID_SUPPORT_REPORT_CONSISTENCY_STATUS PASS`
- `QRESID_CI_PUBLIC_TEXT_SCAN_STATUS PASS`
- `qresid.ado`, `qresid.pkg`, and `stata.toc` unchanged
- `qresid.pkg` lists only `qresid.ado` and `qresid.sthlp`
- SSC staging rebuilt with `QRESID_SSC_SUBMISSION_STATUS PASS`

YAML parsing with Python was not available because `PyYAML` is not installed
locally; the workflow was statically inspected for standard GitHub Actions
syntax.

## Runner Notes

The self-hosted runner must have Stata installed and licensed outside the
repository. If Stata is not discoverable on PATH, configure `STATA_EXE` on the
runner environment.

## Decision

`POST_CHANGE_SYNC_DONE`.

`SUPPORT_MATRIX_SYNC_NOT_REQUIRED`: CI infrastructure and portable test harness
changed, but no statistical support status, model claim, benchmark decision, or
matrix row changed.
