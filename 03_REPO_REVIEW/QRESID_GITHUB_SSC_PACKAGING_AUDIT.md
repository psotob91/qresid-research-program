# QRESID GitHub/SSC Packaging Audit

Date: 2026-05-11

## Scope

This audit records the packaging split added for the 1.0.0 public-preparation
cycle. The GitHub repository remains the complete public project home; the SSC
submission payload is generated as a minimal derived artifact.

## Changes Verified

- `qresid.sthlp` now includes a compact SMCL section linking to:
  - README and overview;
  - extended Markdown manual;
  - supported specifications;
  - validation evidence;
  - news and changelog.
- `qresid/scripts/build_ssc_submission.ps1` builds the SSC staging directory
  and ZIP from the repository source.
- `qresid/release/SSC_SUBMISSION_MANIFEST.md` states what to email to SSC and
  what remains GitHub-only.
- `qresid/.gitignore` ignores generated `release/ssc/` artifacts.
- Normative release rules now require GitHub/SSC payload separation before
  public release or SSC email submission.

## Generated SSC Artifact

Command executed:

```powershell
powershell -ExecutionPolicy Bypass -File scripts\build_ssc_submission.ps1
```

Result:

```text
QRESID_SSC_SUBMISSION_STATUS PASS
QRESID_SSC_STAGE C:\qresid-research-program\qresid\release\ssc\qresid-1.0.0-ssc
QRESID_SSC_ZIP C:\qresid-research-program\qresid\release\ssc\qresid-1.0.0-ssc.zip
```

ZIP contents:

| file | status |
|---|---|
| `qresid.ado` | included |
| `qresid.sthlp` | included |
| `qresid_ssc_cover_note.txt` | included |

No README, Markdown docs, tests, certification, benchmark files, assets, logs,
`qresid.pkg`, or `stata.toc` were included.

## Install And Smoke Checks

- Haghish `github` command availability:
  `QRESID_GITHUB_COMMAND_STATUS PASS`.
- Full GitHub installation from `psotob91/qresid`:
  `GITHUB_INSTALL_TEST_PENDING_PUSH`, because the current local commit has not
  been pushed.
- SSC staging smoke from the generated folder:
  `QRESID_SSC_STAGING_SMOKE PASS`.
  The smoke ran `which qresid`, `help qresid`, `sysuse auto`, `regress`,
  `qresid`, `summarize`, and `qnorm`.
- Support report consistency:
  `QRESID_SUPPORT_REPORT_CONSISTENCY_STATUS PASS`.

## Hygiene

- Public text scan over README, help, package metadata, manual Markdown,
  changelog, packaging manifest, and release script:
  `QRESID_PUBLIC_TEXT_TRACE_SCAN_STATUS PASS`.
- SSC staging scan:
  `QRESID_PUBLIC_TRACE_SCAN_STATUS PASS`.
- `qresid.ado`, `qresid.pkg`, and `stata.toc` were not changed in this cycle.

## Decision

`POST_CHANGE_SYNC_DONE`.

`SUPPORT_MATRIX_SYNC_NOT_REQUIRED`: packaging and help links changed, but no
support status, model claim, benchmark result, or matrix row changed.
