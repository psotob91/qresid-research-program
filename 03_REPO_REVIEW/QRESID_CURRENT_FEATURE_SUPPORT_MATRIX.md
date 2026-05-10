Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load for support, release and feature-status questions

# QRESID_CURRENT_FEATURE_SUPPORT_MATRIX.md

Date: 2026-05-10

Status source: inverse Gaussian and expanded fweight validation cycle, 2026-05-10. See `QRESID_IGAUSSIAN_FWEIGHT_EXTENSION_AUDIT.md` for logs and freeze evidence.

POST_CHANGE_SYNC_DONE: feature support matrix created and registered as a live status reference.
SUPPORT_MATRIX_SYNC_DONE: matrix and searchable HTML are synchronized with the support glossary.

## Purpose

This matrix answers whether each feature is ready, experimental, diagnostic
only, missing but non-blocking, or blocking. It is designed to make package
validity easy to assess: missing inverse Gaussian, Tweedie or Phase 2 models do
not invalidate the current package because they are not claimed as supported.

Read this matrix together with the GLM/link evidence report. If the GLM/link
report says `EXPERIMENTAL_VALIDATED_SEPARATE_BENCHMARK`, the route is supported
or experimental in `qresid` but its detailed evidence lives in another active
benchmark report. `GATED_VARIANT` means a specific variant remains unclaimed; it
does not cancel a validated base route.

## Matrix

| feature_group | stata_command | link_function | weights | offset_exposure | dispersion_parameters | implemented_in_qresid | stata_tests | r_equivalent | r_benchmark_status | public_claim_status | validity_for_current_package | plain_language_summary | next_action |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Gaussian | `regress`; `glm, family(gaussian)` | identity; GLM identity/log/inverse where estimable | none | not central | sigma/scale from fitted model | yes | PASS | `lm`, `glm(gaussian)`, `statmod` | PASS | claimed | READY_FOR_EXTENSION_PRERELEASE | You can use this now within the current prerelease scope. | Public RC audit only. |
| Poisson | `poisson`; `glm, family(poisson)` | log; GLM log/identity/sqrt where estimable | none | log-link offset/exposure tested | none | yes | PASS | `glm(poisson)`, `statmod` | PASS | claimed | READY_FOR_EXTENSION_PRERELEASE | You can use this now; offset/exposure has tested log-link coverage. | Public RC audit only. |
| Bernoulli individual | `logit`; `logistic`; individual `glm, family(binomial)`; individual `binreg` | logit/probit/cloglog/log/identity where supported | none | not central | none | yes | PASS | `glm(binomial)`, `statmod` | PASS | claimed | READY_FOR_EXTENSION_PRERELEASE | You can use individual Bernoulli routes now. | Public RC audit only. |
| Grouped binomial | `glm, family(binomial trials)` | logit/probit/cloglog/log/identity | none | not central | trials from `e(m)` | yes | PASS | `glm(cbind(success,failure), binomial)` | PASS | claimed experimental | EXPERIMENTAL_VALIDATED_LOCAL | Works locally and is documented as an experimental extension. | Keep experimental label until public RC policy. |
| Negative binomial | `nbreg, dispersion(mean)` | default/log | none | not yet | `alpha`; `theta=1/alpha` | yes | PASS | `MASS::glm.nb`, `pnbinom` CDF check | PASS | claimed experimental | EXPERIMENTAL_VALIDATED_LOCAL | NB mean-dispersion route works locally; other NB routes are not claimed. | Research offset/exposure and other NB variants separately. |
| Gamma | `glm, family(gamma)` | log/inverse/identity where estimable | none; `fweight` experimental | not central | phi/shape/scale from GLM | yes | PASS | `glm(Gamma)`, `statmod` | PASS | claimed | READY_FOR_EXTENSION_PRERELEASE | You can use unweighted Gamma routes; direct fweight Gamma is experimental validated local. | Public RC audit only. |
| inverse Gaussian | `glm, family(igaussian)` | `power -2`; log; identity; `power -1` where estimable | none; `fweight` experimental | not central | phi/lambda from GLM; lambda = 1/phi | yes | PASS | `glm(inverse.gaussian)`, closed-form CDF check | PASS | claimed experimental | EXPERIMENTAL_VALIDATED_LOCAL | You can use tested inverse Gaussian routes in local experimental prerelease. | Keep experimental label until public RC policy. |
| fweight expanded families | `regress`; `poisson`; Bernoulli; grouped binomial; `nbreg`; Gamma; inverse Gaussian | tested links by family | `fweight` | Poisson log-link as tested | family-specific fitted distribution | yes | PASS | expansion/R CDF checks for tested routes | PASS | claimed experimental | EXPERIMENTAL_VALIDATED_LOCAL | Direct fweight now works for tested listed routes; no final weight multiplier is applied. | Do not generalize to aweight/iweight/pweight or unsupported weighted routes. |
| pweight direct Gaussian/Poisson/Bernoulli | direct `[pweight=]` fits, no `svy:` | model links above | `pweight` | not central | model-based fitted distribution | partial | PASS | no exact R base equivalent | STATA_ONLY_DIAGNOSTIC | claimed experimental diagnostic | DIAGNOSTIC_ONLY | Useful as Stata model-based diagnostic; not survey-exact support. | Human policy decision before public RC. |
| Tweedie | not implemented | future GLM links | none | not claimed | power/dispersion and CDF approximation pending | no | N/A | `statmod`, `tweedie` | NOT_RUN | not_claimed | MISSING_NOT_BLOCKING | R has routes, but qresid does not claim Tweedie yet; package validity is not affected. | Open Tweedie CDF benchmark gate. |
| ZIP/ZINB | not implemented | future count models | none | not claimed | zero-inflation + count CDF pending | no | N/A | `pscl`, `VGAM`, `glmmTMB`, `topmodels` | NOT_RUN | not_claimed | MISSING_NOT_BLOCKING | Missing by design; this is Phase 2 and does not invalidate current support. | Future Phase 2 research. |
| Hurdle/truncated counts | not implemented | future count models | none | not claimed | truncated/hurdle CDF pending | no | N/A | `pscl`, `VGAM`, `topmodels` | NOT_RUN | not_claimed | MISSING_NOT_BLOCKING | Missing by design; not promised. | Future Phase 2 research. |
| Mixed/GLMM/GSEM | not implemented | future conditional/simulated residuals | none | not claimed | conditional or simulated PIT unresolved | no | N/A | `lme4`, `glmmTMB`, `DHARMa` | NOT_RUN | not_claimed | MISSING_NOT_BLOCKING | Complex dependent models are outside the current package claims. | Future simulation/conditional CDF design. |
| aweight/iweight | tested as gated | not applicable | `aweight`, `iweight` | not claimed | semantics unresolved | no | gated | partial/no exact equivalent by route | NOT_RUN | gated | MISSING_NOT_BLOCKING | These weights are not supported; absence is not a validity problem. | Separate weights research if desired. |
| svy | not implemented | survey framework | survey weights/design | not claimed | design-based diagnostics unresolved | no | N/A | R `survey` diagnostics possible | NOT_RUN | not_claimed | MISSING_NOT_BLOCKING | `svy:` is not supported and not promised. | Human design decision before any support. |
| unsupported weighted routes | routes outside tested fweight and direct pweight diagnostic scope | route-specific | `aweight`, `iweight`, `svy:`, NB p/a/iweight, grouped-binomial p/a/iweight | not claimed | unresolved | no | gated | not established | NOT_RUN | not_claimed | MISSING_NOT_BLOCKING | Missing but not promised; tested fweight routes are listed separately. | Separate weights research if desired. |
| pweight public policy | `[pweight=]` diagnostic routes | model links above | `pweight` | not `svy:` | model-based only | partial | PASS | STATA_ONLY_DIAGNOSTIC | STATA_ONLY_DIAGNOSTIC | claimed experimental diagnostic | BLOCKS_PUBLIC_RC | This does not block local prerelease, but public RC needs a human policy decision. | Decide include/hide/split pweight diagnostic. |

## Validity Summary

- Current local extension prerelease validity: acceptable.
- `BLOCKS_CURRENT_VALIDITY`: none.
- `BLOCKS_PUBLIC_RC`: pweight public policy.
- Missing Tweedie, ZIP/ZINB, hurdle, truncation, mixed models, `svy:`,
  `aweight`, `iweight`, and unsupported weighted routes do not invalidate the
  package because current public docs do not claim support for them.

## Footnote

PIT transforms an observation through the fitted CDF to the uniform scale.
RQR/Dunn-Smyth residuals transform that PIT value to normal scale with
`invnormal()`. For discrete outcomes, `F_low` and `F_high` define the CDF jump
around the observed value. `uvar()` supplies the same uniform draws to Stata and
R for exact discrete residual benchmarking. Missing functionality is a validity
problem only if `qresid` claims to support it or if a critical benchmark for a
claimed route fails.
