Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before normative, support-status, release-policy or extension-prerelease decisions

# QRESID_NORMATIVE_RECONCILIATION_AUDIT.md

Date: 2026-05-10

Status source: root `dde04ef` / qresid `bb77c15`, tags `qresid-count-extension-freeze.1` and `v0.1.0-extension-count.1`.

POST_CHANGE_SYNC_DONE
SUPPORT_MATRIX_SYNC_DONE

## Decision

Decision: `NORMATIVE_SCOPE_RECONCILED_FOR_EXTENSION_PRERELEASE`

The implementation is not reverted. The correct reconciliation is to distinguish:

- `Fase 1 base/estable`: core package routes with stable local evidence.
- `Extension prerelease experimental`: locally validated extension routes that are not public RC or SSC-stable claims.
- `Futuro/gated`: routes that still lack CDF/extraction/benchmark evidence or release-policy approval.

## What Was Reconciled

| area | previous ambiguity | reconciled rule |
|---|---|---|
| inverse Gaussian | older normatives listed it as future/evidence pending | allowed only as `extension prerelease experimental` for validated `glm, family(igaussian)` routes |
| grouped binomial | older planning docs still described grouped/binreg routes as blocked | `glm, family(binomial trials)` and `binreg, n()` aliases `or`/`rr`/`rd` are ready for local extension prerelease; `hr` is Stata-internal only |
| NB2 | older docs said offset/exposure was blocked | `nbreg, dispersion(mean)` with no-offset, `offset()`, and `exposure()` is ready for local extension prerelease |
| weights | older docs treated weights as generally blocked | direct `fweight` is allowed only for combinations validated in the live support matrix; no global `sqrt(w_i)` rule |
| pweight | older docs blocked implementation broadly | direct `[pweight=]` remains diagnostic/model-based/Stata-only, not `svy:` and not public RC without human policy |
| future count models | ZIP/ZINB/truncated/censored/Hilbe-style routes | remain `GATED_MODEL_FAMILY` or `MISSING_NOT_BLOCKING` unless separately validated |
| correlated models | `xt*`, `me*`, `gsem`, `fmm` | remain future/correlated-model scope, not touched by count-extension freeze |

## Files Reviewed And Updated

- `AGENTS.md`
- `02_IMPLEMENTATION_MASTERS/09_STATA_PACKAGE_ARCHITECTURE_MASTER.md`
- `02_IMPLEMENTATION_MASTERS/10_AGENT_RULES_FOR_QRESID.md`
- `03_REPO_REVIEW/QRESID_EXTENSION_MATRIX_PLAN.md`
- `04_RETRIEVAL_CONTEXT/DOCUMENT_STATUS_REGISTRY.md`

No package code, tests, help, examples, `qresid.pkg`, or Stata implementation files were modified by this reconciliation.

## Validation

Required post-change checks:

- root and `qresid/` git status after reconciliation;
- no `qresid.ado` diff;
- no `qresid.pkg` diff;
- support report consistency check;
- search for stale absolute blockers in active docs.

Expected outcome:

- `Rscript qresid/tests/check_support_report_consistency.R` passes.
- No active normative document describes already-validated extension-prerelease routes as absolutely blocked.
- Future/gated routes remain visible and do not block current package validity.

## Remaining Policy Gate

Public RC still requires human release-policy review, especially for direct `[pweight=]` diagnostic wording. This audit does not promote the package to public RC.
