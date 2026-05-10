Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before hurdle count implementation or benchmark work

# QRESID_HURDLE_STATA_ADO_PINNING_AUDIT.md

Date: 2026-05-10

POST_CHANGE_SYNC_DONE: hurdle count Stata external ado candidates pinned, audited and implemented for unweighted qresid postestimation.
SUPPORT_MATRIX_SYNC_DONE: support is claimed only for pinned unweighted hplogit/hnblogit; other hurdle routes remain gated.
SUPPORT_EVIDENCE_INDEX_SYNC: hurdle count benchmark evidence is indexed from `benchmark_hurdle_count_*` and `benchmark_hurdle_qresid_*`.

## Decision

`HURDLE_STATA_ADO_PINNING_STATUS: PASS`

`HURDLE_COUNT_IMPLEMENTATION_ALLOWED_IN_QRESID: yes_for_pinned_unweighted_hplogit_hnblogit`

`HURDLE_COUNT_BENCHMARK_GATE_STATUS: PASS_FOR_HILBE_HARDIN_LOGIT_ROUTES`

The SSC/RePEc Hilbe-Hardin hurdle-count commands are now pinned locally as
external estimator dependencies. The follow-up implementation cycle added
`qresid` support for the two narrow unweighted routes only.

## Pinned Files

Local directory:

`04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/STATA/hurdle_count_hilbe_hardin`

| file | source URL | SHA256 |
|---|---|---|
| `hplogit.ado` | `http://fmwww.bc.edu/repec/bocode/h/hplogit.ado` | `7E136E22EA34181E3513955E4498FAEC106C3FED838002851FF955D01EDF65C5` |
| `jhpoi_logit_ll.ado` | `http://fmwww.bc.edu/repec/bocode/j/jhpoi_logit_ll.ado` | `7EE7D60B4A481839EB06237250DC9C7244E1C3547BAA087805C89F54EF9DC4AC` |
| `hplogit.hlp` | `http://fmwww.bc.edu/repec/bocode/h/hplogit.hlp` | `A9009EB579575185AC8B2C8D45085D98543FEEEF6E109E2E39626C785AB508CB` |
| `hnblogit.ado` | `http://fmwww.bc.edu/repec/bocode/h/hnblogit.ado` | `F1E9187AFFBBE44116183836119B680314CE08B36CA24FBA78063BA69E53BC39` |
| `jhnb_logit_ll.ado` | `http://fmwww.bc.edu/repec/bocode/j/jhnb_logit_ll.ado` | `408D7CAC7CA9B484F6671A92FE90C6486EEE246FB64C2F99CF134E4D2289F6BA` |
| `hnblogit.hlp` | `http://fmwww.bc.edu/repec/bocode/h/hnblogit.hlp` | `1D77B09C289C9373A9BA9AD05D9CC88C14B4F8B611EC310F93611774C6879281` |

Source metadata:

- Authors: Joseph Hilbe and James Hardin.
- Distribution: SSC/RePEc Boston College Statistical Software Components.
- License note from RePEc pages: GPL v3.
- `hplogit`: RePEc handle `S456405`, revised 2018-03-25.
- `hnblogit`: RePEc handle `S456401`, revised 2018-03-25.

## Ado Scope

Accepted for benchmark gate:

- `hplogit`: Poisson-logit hurdle regression.
- `hnblogit`: negative-binomial-logit hurdle regression.

Not accepted in this cycle:

- weights, `pweight`, `svy`, robust/cluster as support claims;
- probit hurdle variants not covered by these ado files;
- `ztpnm` Poisson-lognormal hurdle;
- Stata `churdle` as count-hurdle support.

## Release Interpretation

The route is now a ready-to-prerelease external-estimator support target for
unweighted `hplogit` and `hnblogit`. Other hurdle routes remain gated.
