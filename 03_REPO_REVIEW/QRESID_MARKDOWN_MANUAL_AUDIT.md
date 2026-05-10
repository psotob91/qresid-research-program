# QRESID_MARKDOWN_MANUAL_AUDIT.md

Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before changing the GitHub Markdown manual

## Summary

This audit records the GitHub Markdown manual added after the 1.0.0 core-stable
package pass. The manual is repository documentation, not part of the installed
Stata payload.

## Files Added Or Updated

- `qresid/docs/README.md`
- `qresid/docs/validation.md`
- `qresid/docs/continuous.md`
- `qresid/docs/binary-binomial.md`
- `qresid/docs/counts.md`
- `qresid/docs/special-counts.md`
- `qresid/docs/hurdle.md`
- `qresid/docs/weights-dispersion.md`
- `qresid/docs/scripts/build_manual_assets.do`
- `qresid/docs/assets/img/*.png`
- `qresid/docs/assets/output/*.txt`
- `qresid/README.md`
- `qresid/changelog/CHANGELOG.md`

## Scope Decision

- `qresid.ado` was not changed.
- `qresid.pkg` was not changed.
- `stata.toc` was not changed.
- No new model support, API option, weight semantics, or validation status was
  introduced.
- The support matrix does not require status changes because the manual links to
  existing evidence rather than creating new support claims.

## Generation Evidence

Manual figures and output excerpts were generated with:

```stata
do docs/scripts/build_manual_assets.do
```

The Stata run reported:

```text
QRESID_MANUAL_ASSETS_STATUS PASS
```

## Sync Notes

POST_CHANGE_SYNC_DONE.

SUPPORT_MATRIX_SYNC_NOT_REQUIRED: documentation changed, but support states,
benchmark states, CDF formulas, and public support scope did not change.

