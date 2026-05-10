Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before count-model extension, NB, grouped-binomial or support-status decisions

# QRESID_COUNT_MODEL_EXTENSION_EXECUTION_AUDIT.md

Date: 2026-05-10

Status source: local Stata/R execution on branch `dev-qresid-extension-integrated` after NB2 offset/exposure and grouped-binomial `binreg, n()` alias expansion.

POST_CHANGE_SYNC_DONE
SUPPORT_MATRIX_SYNC_DONE

## Decision

Decision: `COUNT_EXTENSION_PARTIAL_READY_FOR_EXTENSION_PRERELEASE`

The following count-model routes are now ready for the local extension prerelease scope:

- `nbreg, dispersion(mean)` NB2-style route, including tested `offset()` and `exposure()`.
- `glm, family(binomial trials)` grouped binomial links already validated.
- `binreg, n(trials)` aliases `or`, `rr`, and `rd`, validated against R grouped-binomial links.
- `binreg, n(trials) hr`, validated by Stata-internal endpoint/PIT checks only because base R does not provide the same standard link.

No correlated/panel/multilevel/mixture models were implemented.

## Evidence

| artifact | status |
|---|---|
| `qresid/tests/benchmark_nb_stata.do` | added `NB_OFFSET` and `NB_EXPOSURE` datasets |
| latest NB Stata log | `qresid/tests/logs/10_May_2026_173033_nb_benchmark_stata.log`: `QRESID_NB_BENCHMARK_STATUS PASS` |
| latest NB R checker | `qresid/tests/logs/*_nb_benchmark_r.log`: `QRESID_NB_R_STATUS PASS` |
| `qresid/tests/benchmark_grouped_binomial_stata.do` | added `binreg, n()` aliases `or`, `rr`, `rd`, and `hr` internal validation |
| latest grouped-binomial Stata log | `qresid/tests/logs/10_May_2026_173033_grouped_binomial_benchmark_stata.log`: `QRESID_GROUPED_BINOMIAL_BENCHMARK_STATUS PASS` |
| latest grouped-binomial R checker | `qresid/tests/logs/*_grouped_binomial_benchmark_r.log`: `QRESID_GROUPED_BINOMIAL_R_STATUS PASS` |

## Validation Type

| route | validation_type | notes |
|---|---|---|
| `nbreg, dispersion(mean)` no offset/exposure | `R_EXACT_BENCHMARK` | `theta = 1/e(alpha)` and R `pnbinom(size=theta, mu=mu)` endpoints match. |
| `nbreg, dispersion(mean), offset()` | `R_EXACT_BENCHMARK` | Stata `predict, n` includes offset; benchmark confirms qresid does not double-count. |
| `nbreg, dispersion(mean), exposure()` | `R_EXACT_BENCHMARK` | Stata `predict, n` includes exposure; benchmark confirms qresid does not double-count. |
| `glm, family(binomial trials)` | `R_EXACT_BENCHMARK` | R equivalent uses grouped binomial CDF. |
| `binreg, n(trials) or` | `R_EXACT_BENCHMARK` | Maps to logit grouped binomial. |
| `binreg, n(trials) rr` | `R_EXACT_BENCHMARK` | Maps to log grouped binomial. |
| `binreg, n(trials) rd` | `R_EXACT_BENCHMARK` | Maps to identity grouped binomial. |
| `binreg, n(trials) hr` | `STATA_INTERNAL_VALIDATION` | Endpoints, `U`, support and finite residual checks pass; no exact standard base-R link claim. |

## Still Gated

| route | status | reason |
|---|---|---|
| `nbreg, dispersion(constant)` | `GATED_VARIANT` | Alpha/theta/k and CDF mapping not closed. |
| `gnbreg` | `GATED_VARIANT` | Observation-specific `alpha_i` endpoint rule needs separate research and validation. |
| `glm, family(nbinomial #|ml)` | `GATED_VARIANT` | Parameter extraction and stable support claim still separate. |
| NB weights beyond already tested direct `fweight` route | `GATED_VARIANT` | Weight semantics and NB variants must not be conflated. |
| grouped-binomial weights beyond tested direct `fweight` route | `GATED_VARIANT` | Trials and weights must remain separately validated. |
| `zip`, `zinb`, truncated/censored/specialized count, external Hilbe models | `GATED_MODEL_FAMILY` or `MISSING_NOT_BLOCKING` | Not claimed by current package; require separate CDF/extraction gates. |
| correlated count models (`xt*`, `me*`, `gsem`, `fmm`) | `FUTURE_PHASE` | Excluded from this round. |

## Package Validity

`BLOCKS_CURRENT_VALIDITY`: none.

The current package remains valid for its claimed local extension-prerelease support. Missing count-model routes do not invalidate `qresid` because they are not claimed. Public RC still requires a human release-policy decision, especially for direct `[pweight=]` diagnostic wording.
