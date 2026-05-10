Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before truncated count support, release or benchmark decisions

# QRESID_TRUNCATED_COUNT_RESEARCH.md

Date: 2026-05-10

POST_CHANGE_SYNC_DONE: truncated count research and implementation audit created.
SUPPORT_MATRIX_SYNC_DONE: truncated count routes promoted to `READY_FOR_EXTENSION_PRERELEASE`.

## Decision

`TRUNCATED_COUNT_IMPLEMENTATION_ALLOWED: yes`

Accepted routes:

- `tpoisson`, unweighted, lower truncation and tested constant upper truncation.
- `ztp`, unweighted, zero truncation.
- `tnbreg`, unweighted, lower truncation.
- `ztnb`, unweighted, zero truncation.

Blocked variants:

- weighted truncated routes;
- untested nonconstant upper truncation combinations beyond benchmarked scope;
- correlated, panel or mixture truncation routes.

## CDF Rule

For a lower truncation point `L` and optional upper truncation point `U`, the
conditional CDF uses the denominator `F(U-1)-F(L)` when `U` exists and
`1-F(L)` otherwise. Endpoints are:

- `F_low = (F(y-1)-F(L)) / denominator`
- `F_high = (F(y)-F(L)) / denominator`

NB routes use the corresponding NB CDF with extracted `alpha/theta`.

## Evidence

- Stata benchmark: `qresid/tests/benchmark_truncated_count_stata.do`
- R CDF replay: `qresid/tests/benchmark_truncated_count_r.R`
- Three datasets per route: synthetic basic, real-like and adversarial stable.
- Layers: fitted mean, ancillary parameter for NB, support, endpoints, `U` and
  final qres.

## Status

`READY_FOR_EXTENSION_PRERELEASE`
