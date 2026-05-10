Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before censored count support, release or benchmark decisions

# QRESID_CENSORED_COUNT_RESEARCH.md

Date: 2026-05-10

POST_CHANGE_SYNC_DONE: censored count research and implementation audit created.
SUPPORT_MATRIX_SYNC_DONE: `cpoisson` promoted to `READY_FOR_EXTENSION_PRERELEASE`.

## Decision

`CENSORED_COUNT_IMPLEMENTATION_ALLOWED: yes`

Accepted route:

- `cpoisson`, unweighted, with tested left, right and two-sided censoring
  intervals.

Blocked variants:

- weighted censored routes;
- non-Poisson censored count routes;
- correlated, panel or mixture censored routes.

## PIT Interval Rule

For the fitted Poisson CDF `F`:

- uncensored count `y`: `F_low=F(y-1)`, `F_high=F(y)`;
- left-censored at `L`: `F_low=0`, `F_high=F(L)`;
- right-censored at `U`: `F_low=F(U-1)`, `F_high=1`.

The final randomized PIT is `U = F_low + V*(F_high-F_low)`.

## Evidence

- Stata benchmark: `qresid/tests/benchmark_censored_count_stata.do`
- R CDF replay: `qresid/tests/benchmark_censored_count_r.R`
- Three datasets: left/right, left-only and right-only.
- Layers: fitted mean, censoring limits, endpoints, `U` and final qres.

## Status

`READY_FOR_EXTENSION_PRERELEASE`
