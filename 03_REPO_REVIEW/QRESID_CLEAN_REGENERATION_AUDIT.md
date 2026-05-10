Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load after clean regeneration or before rerunning all tests from clean artifacts

# QRESID_CLEAN_REGENERATION_AUDIT.md

Date: 2026-05-10

POST_CHANGE_SYNC_DONE: clean regeneration audit updated after ignored regenerables were removed and all clean-run gates passed.
SUPPORT_MATRIX_SYNC_DONE: support evidence index and GLM/link report were regenerated from clean-run artifacts and `check_support_report_consistency.R` passed.

## Initial State

`CLEAN_REGENERATION_STATUS: PASS_CLEAN_REGENERATION_VERIFIED`

`PRE_CLEAN_ROOT_STATUS: clean`

`PRE_CLEAN_QRESID_STATUS: clean`

`PRE_CLEAN_SUPPORT_CONSISTENCY: PASS`

`PRE_CLEAN_FREEZE_REQUIRED: completed_at_root_0d96e83`

## Intended Clean Test

The clean test must prove that active tests, certification, evidence index and
HTML reports do not rely on stale ignored logs or CSVs.

Tracked canonical HTML/CSV files are not deleted during the clean test unless
their generator is explicitly under test. Ignored logs and transient CSVs are
archived and deleted.

## Cleanup Incident And Correction

The first archive attempt included `.Rproj.user`, which contained an active IDE
lock file. PowerShell `Compress-Archive` failed before creating the zip. During
that same cleanup pass, some tracked MCP seed files were accidentally marked
deleted because their parent folders were included too broadly.

Correction:

- tracked MCP deletions were immediately restored with `git restore`;
- no tracked package, report, source, external pin, `qresid.pkg`, or `stata.toc`
  file remained deleted;
- ignored root logs and ignored `qresid` logs were removed, creating the desired
  clean-regeneration condition;
- because the zip was not created, this run is recorded as
  `ARCHIVE_ATTEMPT_FAILED_LOCKED_IDE_CACHE`, not as a completed evidence
  archive.

This is a process warning, not a package blocker. Future cleanup should archive
only enumerated ignored files, not broad parent folders containing tracked
seeds.

## Evidence After Clean Run

| gate | expected result | observed result |
|---|---|---|
| Archive created | `PASS` | `ARCHIVE_ATTEMPT_FAILED_LOCKED_IDE_CACHE`; see incident note |
| Ignored regenerables deleted | `PASS` | `PASS`; root logs removed and `qresid` logs regenerated from zero |
| `run_all_tests.do` | `QRESID_TEST_STATUS PASS` | `PASS`; `10_May_2026_220241_348871_run_all_tests.log` |
| `hardening_smoke.do` | `QRESID_HARDENING_SMOKE_STATUS PASS` | `PASS`; `10_May_2026_220241_348871_hardening_smoke.log` |
| `certify_phase1.do` | `PASS_EXPERIMENTAL_EXTENSION_LOCAL_STATA_COMPONENTS` | `PASS`; `10_May_2026_220305_348871_certify_phase1.log` |
| R benchmark checkers | `PASS` | `PASS`; Gamma, Phase1, GLM/link, grouped binomial, NB, NB variants, zero-inflated, GLM NB ML gated check, truncated, censored, generalized Poisson, hurdle, fweight, pweight diagnostic, inverse Gaussian, fweight extended, simulated PIT sanity |
| support evidence index rebuild | `PASS` | `PASS`; `QRESID_SUPPORT_EVIDENCE_INDEX_ROWS 160` |
| support report consistency | `PASS` | `PASS`; `QRESID_SUPPORT_REPORT_CONSISTENCY_STATUS PASS` |
| root git status | clean after final commit | `PENDING_FINAL_COMMIT` |
| `qresid/` git status | clean after final commit | `PENDING_FINAL_COMMIT` |

## Regenerated Tracked Artifacts

The clean run regenerated two tracked canonical artifacts in `qresid/`:

- `qresid/certification/reports/qresid_support_evidence_index.csv`;
- `qresid/certification/reports/qresid_glm_link_matrix.html`.

Both changed only because timestamps/evidence rows were regenerated from the
clean logs. The consistency checker passed after regeneration.

## Failure Policy

If any gate fails:

- do not tag clean regeneration;
- document the exact failed gate and latest log path;
- fix only the failing generator/test/sync path;
- rerun the smallest affected gate first;
- rerun full clean checks only after the focal gate is green.

## Decision

`CLEAN_REGENERATION_FREEZE_READY: yes`

Required closeout:

1. Commit regenerated canonical report artifacts in `qresid/`.
2. Tag `qresid/` with `v0.1.0-extension-cleanregen.1`.
3. Commit this audit and the `qresid` gitlink in root.
4. Tag root with `qresid-clean-regeneration-freeze.1`.
