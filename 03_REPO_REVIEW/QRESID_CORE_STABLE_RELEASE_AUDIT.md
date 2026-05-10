# QRESID_CORE_STABLE_RELEASE_AUDIT

Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before public release or SSC/GitHub packaging decisions

## Summary

This audit records the documentation and package-metadata pass for the
`qresid` 1.0.0 core stable release. The pass prepares public-facing files for
GitHub installation and SSC-style packaging review.

The release scope is core stable. Extension specifications remain described
only where the help documents the fitted CDF and postestimation requirements;
diagnostic `pweight` support is not presented as `svy:` or survey-design
support.

POST_CHANGE_SYNC_DONE
SUPPORT_MATRIX_SYNC_NOT_REQUIRED

## Files reviewed or updated

- `qresid/qresid.sthlp`
- `qresid/README.md`
- `qresid/changelog/CHANGELOG.md`
- `qresid/qresid.pkg`
- `qresid/stata.toc`
- `qresid/qresid.ado` user-visible version and error-message wording only

## Public release decisions

- Package version metadata updated to `1.0.0`.
- GitHub installation target set to `https://github.com/psotob91/qresid`.
- Author signature set to Percy Soto-Becerra, MD, MSc, PhD(c), Universidad
  Privada del Norte, Lima, Peru.
- Public email addresses set to `percy.soto@upn.edu.pe` and
  `percys1991@gmail.com`.
- `qresid.pkg` remains minimal: `qresid.ado` and `qresid.sthlp`.

## Sync decision

No support row was added, removed, or promoted in this pass. The support matrix
therefore does not require regeneration. Public wording was tightened to avoid
claims beyond the current matrices and tests.
