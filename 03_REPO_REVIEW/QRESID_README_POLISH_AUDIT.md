# QRESID_README_POLISH_AUDIT.md

Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before changing the GitHub README or Markdown reference pages

## Summary

This audit records the GitHub README and Markdown reference polish after the
1.0.0 package pass. The change is documentation-only.

## Public Documentation Changes

- Rewrote `qresid/README.md` as the public GitHub landing page.
- Moved detailed support scope to `qresid/docs/supported-specifications.md`.
- Added `qresid/docs/reference.md` as a GitHub-readable companion to
  `help qresid`.
- Updated `qresid/docs/README.md` and `qresid/changelog/CHANGELOG.md` with the
  new documentation links.

## Scope Decision

- `qresid.ado` was not changed.
- `qresid.pkg` was not changed.
- `stata.toc` was not changed.
- No new model family, option, weight semantics, benchmark status, or support
  claim was introduced.
- `CHANGELOG.md` remains a GitHub/release document and is not part of the
  installed Stata package unless explicitly listed in `qresid.pkg`, which it is
  not.

## Sync Notes

POST_CHANGE_SYNC_DONE.

SUPPORT_MATRIX_SYNC_NOT_REQUIRED: the support matrix and evidence index remain
the support authority; this pass reorganized public prose and links only.

