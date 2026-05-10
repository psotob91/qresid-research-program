Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load by GLM/link benchmark or certification tasks

# QRESID_GLM_LINK_MATRIX_ITERATION_LOG.md

Date: 2026-05-10

Status source: local implementation, Stata logs and R benchmark logs.

## Ten-Step Iteration Trace

| step | action | result |
|---:|---|---|
| 1 | Loaded `AGENTS.md`, `09`, `10`, benchmark/testing/extraction/sync rules. | Scope confirmed: Phase 1 safe only. |
| 2 | Inspected current `qresid.ado`, tests and benchmark scripts. | Coverage gap confirmed for GLM links, `binreg`, offset/exposure matrix. |
| 3 | Probed local Stata `glm binomial` and `binreg` metadata. | `e(varfunct)=Bernoulli`, `e(m)=1` for individual cases. |
| 4 | Added `glm binomial` and `binreg` individual gate in `qresid.ado`. | No API change; grouped binomial remains gated. |
| 5 | Added integration tests for `glm binomial` and individual `binreg`. | `run_all_tests.do` passed after adjusting invalid `binreg rr` fixture. |
| 6 | Created Stata GLM/link matrix producer. | 75 Phase 1 safe Stata groups exported. |
| 7 | Created R GLM/link matrix checker. | R checked CDF endpoints, PIT and residuals; matrix passed. |
| 8 | Generated HTML report. | `certification/reports/qresid_glm_link_matrix.html` created. |
| 9 | Integrated Stata matrix into `certify_phase1.do` and updated public docs/examples. | Certification Stata gate passed. |
| 10 | Re-audited release blockers/checklists and lifecycle status. | Recommendation remains advance; future families remain gated. |

## Iteration Outcome

Final status: `PASS_GLM_LINK_MATRIX_LOCAL_RECONCILED`

Evidence:

- `qresid/tests/logs/10_May_2026_121049_run_all_tests.log`: `QRESID_TEST_STATUS PASS`.
- `qresid/certification/logs/10_May_2026_122105_certify_phase1.log`: `PASS_PRERELEASE_LOCAL_STATA_COMPONENTS`.
- `qresid/tests/logs/10_May_2026_122110_glm_link_matrix_stata.log`: `QRESID_GLM_LINK_MATRIX_STATA_STATUS PASS`.
- `qresid/tests/logs/10_May_2026_122110_glm_link_matrix_r.log`: `QRESID_GLM_LINK_MATRIX_R_STATUS PASS`.
- `qresid/tests/logs/10_May_2026_154140_glm_link_matrix_stata.log`: reconciled matrix with inverse Gaussian, `QRESID_GLM_LINK_MATRIX_STATA_STATUS PASS`.
- `qresid/tests/logs/10_May_2026_154140_glm_link_matrix_r.log`: reconciled matrix with inverse Gaussian, `QRESID_GLM_LINK_MATRIX_R_STATUS PASS`.
- `qresid/tests/logs/10_May_2026_160031_glm_link_matrix_stata.log`: harmonized scoped-status matrix, `QRESID_GLM_LINK_MATRIX_STATA_STATUS PASS`.
- `qresid/tests/logs/10_May_2026_160031_glm_link_matrix_r.log`: harmonized scoped-status matrix, `QRESID_GLM_LINK_MATRIX_R_STATUS PASS`.
- `qresid/tests/logs/10_May_2026_160036_grouped_binomial_benchmark_r.log`: separate grouped-binomial evidence, `PASS`.
- `qresid/tests/logs/10_May_2026_160037_nb_benchmark_r.log`: separate NB evidence, `PASS`.
- `qresid/tests/logs/10_May_2026_160039_fweight_extended_benchmark_r.log`: separate fweight evidence, `PASS`.

## Findings Removed As False Blockers

- `glm binomial` individual was not inherently blocked by grouped-binomial
  uncertainty; `e(m)==1` allows a safe Bernoulli path.
- `binreg` individual was not grouped by default; `e(m)==1` allows a safe
  Bernoulli path.
- Noncanonical links do not require a new public API because `qresid` relies on
  final fitted means/probabilities and family CDFs.

## Findings Still Gated

- `binreg hr` was not promoted because local probe did not converge on the
  default test fixture; it remains inventory-only unless a stable benchmark is
  added.
- weighted routes outside tested direct `fweight` and direct `pweight`
  diagnostic remain gated.
- Phase 2 models remain deferred.

## Reconciliation Addendum

After inverse Gaussian reached `EXPERIMENTAL_VALIDATED_LOCAL`, the generated
GLM/link HTML report was stale because it still listed inverse Gaussian as
`GATED_FUTURE`. The matrix producer and R checker now include inverse Gaussian
`glm` links `power -2`, `log`, `identity`, and `power -1` across the same three
dataset classes. The HTML report also notes that expanded direct `fweight`
evidence is validated separately in `benchmark_fweight_extended_*`.

## Status Harmonization Addendum

Grouped binomial and NB were not actually unsupported; their validated routes
were evidenced in separate benchmark reports. The GLM/link inventory now uses
`EXPERIMENTAL_VALIDATED_SEPARATE_BENCHMARK` for those validated routes and
`GATED_VARIANT` for the specific variants that remain unclaimed. This prevents
the report from hiding support that is visible in the live support matrix.

## Post-Change Sync

POST_CHANGE_SYNC_DONE
SUPPORT_MATRIX_SYNC_DONE
