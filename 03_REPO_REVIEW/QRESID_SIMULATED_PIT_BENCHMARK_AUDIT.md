Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before using DHARMa/glmmTMB as benchmark evidence

# QRESID_SIMULATED_PIT_BENCHMARK_AUDIT.md

Date: 2026-05-10

POST_CHANGE_SYNC_DONE: simulated PIT benchmark audit created.
SUPPORT_MATRIX_SYNC_DONE: simulated PIT remains supplementary and does not expand support claims.

## Decision

`SIMULATED_PIT_STATUS: SIMULATION_SANITY_CHECK_ONLY`

DHARMa/glmmTMB-style simulation checks are useful as future sanity checks, but
they do not replace analytic CDF endpoint validation for `qresid`.

## Local Availability

- `glmmTMB`: available.
- `DHARMa`: not installed in this session.

## Evidence

- R script: `qresid/tests/benchmark_simulated_pit_sanity_r.R`
- Output: `QRESID_SIMULATED_PIT_SANITY_R_STATUS SIMULATION_SANITY_CHECK_ONLY`

## Release Interpretation

No support claim should cite simulated PIT as the gold standard. Analytic
`F_low`, `F_high`, `U` and qres checks remain controlling.
