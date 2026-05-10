Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before using DHARMa/glmmTMB as benchmark evidence

# QRESID_SIMULATED_PIT_BENCHMARK_AUDIT.md

Date: 2026-05-10

POST_CHANGE_SYNC_DONE: simulated PIT benchmark audit updated after local DHARMa installation and sanity check.
SUPPORT_MATRIX_SYNC_DONE: simulated PIT remains supplementary and does not expand support claims.

## Decision

`SIMULATED_PIT_STATUS: SIMULATION_SANITY_CHECK_ONLY`

DHARMa/glmmTMB-style simulation checks are useful as future sanity checks, but
they do not replace analytic CDF endpoint validation for `qresid`.

## Local Availability

- `glmmTMB`: available.
- `DHARMa`: installed locally, version 0.4.7.

## Evidence

- R script: `qresid/tests/benchmark_simulated_pit_sanity_r.R`
- Output after this update: `QRESID_SIMULATED_PIT_SANITY_R_STATUS PASS_SIMULATION_SANITY_CHECK_ONLY`.
- The script fits a non-correlated Poisson model with `stats::glm` and
  `glmmTMB::glmmTMB`, verifies fitted means agree to numerical tolerance, then
  checks that DHARMa scaled residuals are finite and within `[0,1]`.

## Release Interpretation

No support claim should cite simulated PIT as the gold standard. Analytic
`F_low`, `F_high`, `U` and qres checks remain controlling.

DHARMa is useful for learning and sanity-checking future models where an
analytic comparator is unavailable, including non-correlated parameterizations
fit through a GLMM-capable package. It is not a replacement for a closed CDF or
for route-specific Stata extraction.
