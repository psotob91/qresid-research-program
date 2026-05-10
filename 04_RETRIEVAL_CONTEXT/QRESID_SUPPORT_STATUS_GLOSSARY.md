Lifecycle: retrieval
Status: ACTIVE
Authority: normative
Superseded by: NONE
Retrieval policy: load for support, release, help or status questions

# QRESID_SUPPORT_STATUS_GLOSSARY.md

Date: 2026-05-10

POST_CHANGE_SYNC_DONE: glossary created and registered as a live support/status reference.
SUPPORT_MATRIX_SYNC_DONE: glossary and searchable HTML are synchronized with the current feature matrix.

## Purpose

This glossary defines the support and validity terms used by `qresid` release,
benchmark and help documentation. It is intended for quick human interpretation:
whether a feature is ready, experimental, diagnostic-only, missing but harmless,
or blocking.

Authoritative status still comes from `AGENTS.md`, `09`, `10`, benchmark rules,
release audits and the document registry. If this glossary conflicts with those
documents, update this glossary and the registry rather than silently changing a
support claim.

## Support Status Terms

| term | plain meaning | technical meaning | what it allows | what it does not allow | where used | authority |
|---|---|---|---|---|---|---|
| `SUPPORTED_TESTED` | Ready within the stated package scope. | Implemented, tested, benchmarked where needed, documented, and covered by examples or certification. | Use in prerelease docs and examples for the tested route. | Claiming public RC/SSC readiness without release policy review. | feature matrix, help, release audit | `AGENTS.md`, `09`, `10`, testing rules |
| `READY_FOR_EXTENSION_PRERELEASE` | Ready for local extension prerelease. | The route passed local Stata/R or diagnostic validation and public docs match evidence. | Tag/local prerelease use. | Public RC claim. | feature matrix, promotion decision | extension release audit |
| `EXPERIMENTAL_VALIDATED_LOCAL` | Works locally, but label it experimental. | Implemented and locally validated, but not yet stable/public RC support. | Use if docs clearly say experimental. | Presenting as stable, SSC-ready, or universally validated. | feature matrix, help, README | extension release audit, registry |
| `DIAGNOSTIC_ONLY` | Useful for diagnostics, not exact standard support. | The path is model-based or Stata-only and lacks exact R-equivalent validation. | Use as exploratory/diagnostic output when labelled. | Claiming exact R/Stata equivalence or survey-standard support. | pweight status, feature matrix | pweight research plan |
| `STATA_ONLY_DIAGNOSTIC` | Stata route passed Stata checks but has no exact R comparison. | Diagnostic evidence exists in Stata; R is not a pointwise benchmark authority. | Keep as diagnostic evidence. | Treating R benchmark as passed exact validation. | pweight checkers | weights matrix, pweight plan |
| `GATED_RESEARCH` | Not ready; research/benchmark gate first. | Candidate route needs parametrization, CDF, extraction or benchmark closure before implementation or public claim. | Plan research and benchmarks. | Implementing support or documenting active support. | extension plans | `AGENTS.md`, `10` |
| `EVIDENCE_PENDING` | Evidence is missing. | A needed CDF, extractor, parameter mapping, benchmark or source is unresolved. | Create research request or controlled error. | Support claim. | support matrix, registry | `AGENTS.md`, source log |
| `FUTURE_PHASE` | Out of current scope. | Feature belongs to a later phase or public release track. | Mention as deferred. | Blocking current package validity if not claimed. | feature matrix | `09`, registry |
| `MISSING_NOT_BLOCKING` | Missing, but harmless because it is not promised. | The package does not implement the route and docs do not claim it. | Proceed with current scope. | Treating absence as a package validity failure. | feature matrix | release blockers |
| `BLOCKS_PUBLIC_RC` | Fine for local prerelease, not for public release. | A policy, evidence or documentation issue must be resolved before public RC/SSC/SJ. | Continue local prerelease. | Public RC tag or public release claim. | release blockers | extension release blockers |
| `BLOCKS_CURRENT_VALIDITY` | Serious: promised behavior lacks evidence or fails. | A claimed supported route is untested, contradicted, or failing. | Stop promotion and re-audit. | Release/prerelease promotion. | feature matrix, audits | release audit |

## Statistical And Benchmark Terms

| term | plain meaning | technical meaning | what it allows | what it does not allow | where used | authority |
|---|---|---|---|---|---|---|
| `PIT` | Convert fitted CDF value to a uniform scale. | Probability integral transform, `U = F_i(y_i)` for continuous data; randomized within a CDF jump for discrete data. | Explain the uniformization step. | Treating PIT itself as the final normal residual. | help, formulas | `07`, numerical rules |
| `RQR` | Dunn-Smyth randomized quantile residual. | `invnormal(U)` after PIT/randomized PIT. | Normal-scale diagnostic residuals. | Exact finite-sample normality with estimated parameters. | help, tests | Dunn-Smyth theory, `07` |
| `Dunn-Smyth residual` | Another name for RQR. | Randomized quantile residual from Dunn and Smyth. | Use as synonym for RQR. | Using for residuals not based on fitted CDF/PIT. | help, glossary | theory master |
| `F_low` | Lower CDF endpoint. | `P(Y_i < y_i)` or `F_i(y_i-)`. | Audit discrete CDF jumps. | Replacing `F_high` in continuous PIT. | help, benchmarks | numerical rules |
| `F_high` | Upper CDF endpoint. | `P(Y_i <= y_i)` or `F_i(y_i)`. | Audit discrete/continuous CDF. | Ignoring the lower endpoint for discrete outcomes. | help, benchmarks | numerical rules |
| `U` | Final PIT uniform. | Value sent to `invnormal()`. | Save via `saveu()`. | Confuse with base random draw `V`. | help, ado returns | `09`, benchmark mapping |
| `V` | Base uniform draw for discrete randomization. | Uniform on `[0,1]` used in `U = F_low + V*(F_high-F_low)`. | Save via `savev()` or supply through `uvar()`. | Claim cross-language RNG equality. | help, benchmark | benchmark mapping |
| `uvar()` | User-supplied uniform values. | External `V` used for exact discrete R/Stata benchmark comparisons. | Exact pointwise discrete residual comparison. | Replacing statistical validation of CDF endpoints. | API, examples | `09`, `10` |
| `seed()` | Stata RNG seed. | Sets Stata RNG before drawing internal uniforms. | Reproducibility inside Stata. | Exact equality with R RNG. | API, examples | `09`, `10` |
| `R equivalent` | R route for comparison. | R package/function used as benchmark reference for fitted values, CDF endpoints or residuals. | R/Stata benchmark when parametrizations align. | Assuming all Stata options have exact R equivalent. | support matrix | benchmark mapping |
| `exact benchmark` | Pointwise comparison. | Same sample, parameters, CDF endpoints, `U`, and residuals within tolerance; discretes require shared `uvar()`. | Strong validation for supported routes. | Distribution-only validation. | tests, matrix | benchmark rules |
| `approximate benchmark` | Numeric tolerance comparison. | Comparison where small floating-point differences are expected. | Validate continuous CDF/residual and fitted values. | Ignoring large layer mismatches. | tests, matrix | benchmark mapping |
| `offset` | Additive model term. | Usually enters linear predictor directly, often log-exposure. | Use if `predict` carries it correctly. | Duplicating offset manually. | support matrix | extraction rules |
| `exposure` | Exposure denominator/time. | Stata `exposure()` generally becomes log-offset in count models. | Tested log-link count routes. | Assuming all non-log links have equivalent exposure semantics. | support matrix | extraction rules |
| `weights` | Weighted estimation metadata. | `e(wtype)`/`e(wexp)` from Stata estimation. Semantics depend on family and type. | Family/type-specific support after evidence. | Global `sqrt(w_i)` residual rule. | weights docs, matrix | weights research |

## Footnote

PIT transforms an observation through the fitted CDF to the uniform scale.
RQR/Dunn-Smyth residuals transform that PIT value to normal scale with
`invnormal()`. For discrete outcomes, the observation falls inside a CDF jump:
`F_low = P(Y < y)` and `F_high = P(Y <= y)`. `uvar()` supplies the same uniform
draws to Stata and R so randomized discrete residuals can be compared exactly.
A missing feature does not invalidate `qresid` if the package does not claim to
support it.
