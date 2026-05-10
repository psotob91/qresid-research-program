Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before any weighted residual implementation or benchmark decision

# WEIGHTS_SEMANTICS_RESEARCH.md

Date: 2026-05-10

Branch: `dev-qresid-nb-weights-grouped-binomial`

Status source: local Stata/R inspection on root `b91e964`; qresid subrepo `388e595`.

POST_CHANGE_SYNC_DONE: registered in `DOCUMENT_STATUS_REGISTRY.md`.

## 1. Decision

`WEIGHTS_IMPLEMENTATION_ALLOWED: no`

`WEIGHTS_BENCHMARK_ALLOWED: yes`

Weighted support remains blocked in `qresid.ado` until family x command x weight-type benchmarks close CDF and residual semantics.

Current runtime rule in `qresid.ado`:

```stata
if "`e(wtype)'" != "" {
    display as err "weighted estimation results require the documented weights semantics gate"
    exit 198
}
```

This rule must remain in place until a later implementation plan explicitly narrows and tests supported weighted cases.

## 2. Sources Inspected

Local project sources:

- `qresid/qresid.ado`
- `03_REPO_REVIEW/WEIGHTS_RQR_EVIDENCE_REVIEW.md`
- `03_REPO_REVIEW/QRESID_WEIGHTS_TECHNICAL_RESEARCH_NOTES.md`
- `03_REPO_REVIEW/QRESID_EXTENSION_MATRIX_PLAN.md`

Local Stata sources/help:

- `C:\Program Files\StataNow19\ado\base\r\regress.ado`
- `C:\Program Files\StataNow19\ado\base\r\regress.sthlp`
- `C:\Program Files\StataNow19\ado\base\p\poisson.ado`
- `C:\Program Files\StataNow19\ado\base\p\poisson.sthlp`
- `C:\Program Files\StataNow19\ado\base\l\logit.ado`
- `C:\Program Files\StataNow19\ado\base\l\logit.sthlp`
- `C:\Program Files\StataNow19\ado\base\l\logistic.ado`
- `C:\Program Files\StataNow19\ado\base\l\logistic.sthlp`
- `C:\Program Files\StataNow19\ado\base\g\glm.ado`
- `C:\Program Files\StataNow19\ado\base\g\glm.sthlp`

Local R sources:

- R `stats::glm`, `stats::glm.fit`, `stats::lm`
- `statmod::qresiduals()` internals for Gaussian/default, binomial, Poisson and Gamma.

## 3. Core Semantic Rule

There is no valid universal weighted RQR rule of the form:

```text
weighted_qres_i = sqrt(w_i) * qres_i
```

Weights may affect:

- the fitted model and parameters;
- predictions such as `mu`, `pr`, or fitted linear predictors;
- scale/dispersion estimates;
- the individual CDF used for PIT/RQR construction in some families;
- the diagnostic interpretation of each residual.

The final normal quantile residual must not be post-multiplied by a weight unless a family-specific derivation and benchmark explicitly require it.

## 4. Stata Support Observed

Local Stata probes confirmed:

| command/family | fweight | aweight | iweight | pweight |
|---|---:|---:|---:|---:|
| `regress` | yes | yes | yes | yes |
| `poisson` | yes | no | yes | yes |
| `logit` | yes | no | yes | yes |
| `logistic` | yes | no | yes | yes |
| `glm, family(gaussian)` | yes | yes | yes | yes |
| `glm, family(poisson)` | yes | yes | yes | yes |
| `glm, family(binomial)` | yes | yes | yes | yes |
| `glm, family(gamma)` | yes | yes | yes | yes |

Stata acceptance is not enough to activate `qresid` support.

## 5. R / statmod Semantics Observed

`statmod::qresiduals()` shows family-dependent treatment:

| family | observed R/statmod behavior | implication for qresid |
|---|---|---|
| Gaussian/default | Uses deviance residuals and estimates dispersion with weighted residual sum if dispersion not supplied. | Weights affect scale/dispersion, not a universal final multiplier. |
| Binomial | Uses `prior.weights` as trial counts: `y <- n * y`, endpoints via `pbinom`. | Weighted Bernoulli may become grouped-binomial semantics, not generic weights. |
| Poisson | Uses fitted `mu` and Poisson CDF endpoints; no final `sqrt(w)` multiplier. | Weights affect estimation/fitted `mu`; individual CDF remains Poisson with weighted-fit `mu` unless a different rule is proven. |
| Gamma | Uses `w/dispersion` as shape and scales CDF by `(w*y)/(mu*dispersion)`. | Candidate, but requires Stata scale/dispersion mapping before support. |

R `glm(weights=)` is not a one-to-one equivalent for Stata `pweight`/survey interpretation.

## 6. Effect Dimensions

| dimension | rule |
|---|---|
| estimation | Weight may affect coefficient estimates and ancillary/dispersion quantities. |
| predict | Predictions reflect the fitted weighted model; `predict` generally does not attach a residual weight afterward. |
| CDF individual | Must be defined per family; Poisson/Bernoulli/Gamma differ. |
| final qres | No global weight multiplier. |
| diagnostic interpretation | Weighted residuals may represent replicated rows, prior precision, analytic scaling or survey design; these are not interchangeable. |

## 7. Weight Type Decisions

| weight_type | decision | rationale |
|---|---|---|
| `fweight` | benchmark candidate | Possible frequency/replication semantics; must decide whether output residual represents collapsed row or expanded observations. |
| `aweight` | benchmark candidate only for `regress`/`glm` | Can map to prior/analytic weighting in some GLM contexts; dispersion/CDF effects must be family-specific. |
| `iweight` | reject for now | Affects estimation but does not define a clear individual distribution for RQR. |
| `pweight` | reject for now | Probability/survey design weights do not map to simple individual CDF residuals in R base GLM. |

## 8. Family-Specific Initial Recommendations

| family | recommended initial policy |
|---|---|
| Gaussian `regress` | Benchmark `fweight` expanded-data equivalence first; `aweight` only after scale/dispersion mapping. |
| Gaussian `glm` | Benchmark `fweight` and `aweight` separately against R `glm/lm`, with dispersion layer checks. |
| Poisson `poisson`/`glm` | Benchmark `fweight`; possibly `aweight` for `glm` only; CDF should use weighted-fit `mu`, no final multiplier. |
| Bernoulli/binomial | Treat `fweight`/prior weights as grouped-binomial/trials problem, not generic weights. |
| Gamma `glm` | Candidate because `statmod` defines weighted Gamma CDF; must close Stata scale/dispersion equivalence. |

## 9. Rejected Or Deferred

Reject for Fase weights:

- `pweight` support;
- `iweight` support;
- any public claim that all Stata weight types are supported;
- any rule that multiplies the final residual by `sqrt(w_i)` globally.

Defer:

- survey-style diagnostics;
- weighted NB;
- weighted grouped binomial until grouped binomial itself is closed.

## 10. Implementation Recommendation

Do not implement weights now.

Next step should be benchmark-only:

1. `fweight` frequency expansion for Gaussian/Poisson.
2. `glm gamma` analytic/prior-weight candidate, if scale mapping closes.
3. grouped-binomial semantics for binomial weights/trials.

Only after those pass should a narrow implementation plan be created.
