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
| `EXPERIMENTAL_VALIDATED_SEPARATE_BENCHMARK` | Works, but was validated in a different report. | Implemented/local-validated route whose evidence lives outside the current report being viewed. | Link to the active benchmark/audit that validates the route. | Treating the current report as the only evidence source. | GLM/link report, support matrix | registry, benchmark audits |
| `DIAGNOSTIC_ONLY` | Useful for diagnostics, not exact standard support. | The path is model-based or Stata-only and lacks exact R-equivalent validation. | Use as exploratory/diagnostic output when labelled. | Claiming exact R/Stata equivalence or survey-standard support. | pweight status, feature matrix | pweight research plan |
| `STATA_ONLY_DIAGNOSTIC` | Stata route passed Stata checks but has no exact R comparison. | Diagnostic evidence exists in Stata; R is not a pointwise benchmark authority. | Keep as diagnostic evidence. | Treating R benchmark as passed exact validation. | pweight checkers | weights matrix, pweight plan |
| `GATED_RESEARCH` | Not ready; research/benchmark gate first. | Candidate route needs parametrization, CDF, extraction or benchmark closure before implementation or public claim. | Plan research and benchmarks. | Implementing support or documenting active support. | extension plans | `AGENTS.md`, `10` |
| `GATED_VARIANT` | A specific variant is still blocked. | The main family/route may be validated, but a variant such as alias, weight type, offset, exposure or alternate parametrization is not. | Show exactly what remains missing without blocking the validated route. | Marking the whole family unsupported. | GLM/link report, support matrix | registry, extension audits |
| `REPORT_SCOPE_ONLY` | A status only describes this report. | The report covers a narrower matrix than the package support surface. | Explain why another active report may show more support. | Contradicting the support matrix. | GLM/link report, glossary | registry, sync rules |
| `evidence_scope` | Where the proof lives. | Field that separates status from evidence location: `THIS_REPORT`, `SEPARATE_BENCHMARK`, `GATED_VARIANT`, or `REPORT_SCOPE_ONLY`. | Read a scoped report without mistaking absent rows for absent package support. | Replacing the support matrix as the quick answer for what can be used. | GLM/link report, consistency check | registry, sync rules |
| `THIS_REPORT` | Evidence is in the report you are viewing. | The current report executed or directly validates the route. | Treat the report as direct evidence for that route. | Assuming all package support must be in this report. | GLM/link report | benchmark audits |
| `SEPARATE_BENCHMARK` | Evidence is in another active benchmark. | The route is validated elsewhere and should be linked rather than marked as absolutely gated. | Keep a route visible as supported/experimental while pointing to the correct evidence. | Claiming the current report ran that benchmark directly. | GLM/link report, support matrix | benchmark audits |
| `R_EXACT_BENCHMARK` | R can be used as the pointwise gold standard. | Same model, parameters, support, CDF endpoints, `U` and residuals can be aligned against R. | Promote a route after layer-by-layer benchmark passes. | Assuming all Stata options have an exact R equivalent. | unified extension matrix, benchmark plans | benchmark mapping |
| `R_APPROX_BENCHMARK` | R is comparable, but not identical. | R route is useful for sanity checks or approximate validation, but parametrization/support is not pointwise identical. | Use as secondary evidence with caveats. | Stable support claim without additional validation. | unified extension matrix | benchmark mapping |
| `R_CDF_REPLAY` | R checks the CDF math from Stata-exported parameters. | Stata is the estimator authority; R recomputes CDF endpoints, PIT `U`, and qres from exported `mu`, ancillary parameters and `V`. | Validate CDF/residual layers when estimator-level R equivalence is unavailable or route-specific. | Claiming R fitted the same estimator pointwise. | NB variants, ZIP/ZINB benchmarks | benchmark mapping, count extraction rules |
| `STATA_INTERNAL_VALIDATION` | Validate using official Stata plus mathematical invariants. | Official Stata route lacks exact R equivalent; validation relies on extraction, support, CDF endpoints, PIT and residual invariants. | Stata-only support planning when CDF is closed. | Pretending an R exact benchmark passed. | unified extension matrix, Stata-only routes | extraction and numerical rules |
| `STATA_EXTERNAL_ADO_VALIDATION` | External ado route needs pinned provenance. | User-written Stata estimator requires source/version/license pinning plus PMF/CDF and benchmark validation. | Research an external Hilbe-style model safely. | Copying external code or claiming support from an unpinned ado. | unified extension matrix, external research gates | `AGENTS.md`, source access rules |
| `GATED_MODEL_FAMILY` | The whole family is still research-only. | Estimator, source, CDF, parameter mapping or benchmark design is unresolved. | Keep the family visible as future work. | Implementing or documenting active support. | unified extension matrix | `AGENTS.md`, extension plans |
| `NO_OFFICIAL_STATA_COMMAND` | Stata has no built-in estimator for this family. | Any support would depend on external ado/source or a separate estimator policy. | Trigger source/version/license research. | Treating the feature as normal postestimation for official Stata. | unified extension matrix | package style/source rules |
| `NO_ACTION_REQUIRED` | The option does not change the residual target. | No new CDF/support/benchmark branch is needed for the current support claim. | Document and move on. | Skipping sync when support status actually changed. | sync checklist, extension matrix | post-change sync |
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
