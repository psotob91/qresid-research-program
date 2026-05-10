Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before NB benchmark or implementation work

# NB_BENCHMARK_FEASIBILITY_MATRIX.md

Date: 2026-05-10

Branch: `dev-qresid-nb-weights-grouped-binomial`

Status source: local Stata/R inspection on root `b91e964`; qresid subrepo `388e595`.

POST_CHANGE_SYNC_DONE: registered in `DOCUMENT_STATUS_REGISTRY.md`.

## 1. Feasibility Summary

| item | result |
|---|---|
| `NB_IMPLEMENTATION_ALLOWED` | `no` |
| `NB_BENCHMARK_ALLOWED` | `yes` |
| first candidate | `nbreg, dispersion(mean)` unweighted log-link |
| first R reference | `MASS::glm.nb()` plus explicit `pnbinom(size = theta, mu = mu)` endpoints |
| qresid code changes allowed now | `no` |

## 2. Combination Matrix

| Stata estimator | dispersion/link | offset/exposure | weights | R equivalent | parameter extraction | CDF source | status | notes |
|---|---|---|---|---|---|---|---|---|
| `nbreg` | `dispersion(mean)`, default log mean | no | none | `MASS::glm.nb(..., link=log)` candidate | `e(alpha)`, `/lnalpha`, `theta=1/e(alpha)` | R `pnbinom(size=theta, mu=mu)` | `TESTABLE_NOW` | First benchmark route; no implementation until three datasets pass. |
| `nbreg` | `dispersion(mean)`, default log mean | offset | none | `MASS::glm.nb(... + offset(offset))` candidate | `e(alpha)`, `predict, n`, `predict, xb` | R `pnbinom(size=theta, mu=mu)` | `NEEDS_RESEARCH` | Must verify Stata `predict, n` and R `mu` include offset identically. |
| `nbreg` | `dispersion(mean)`, default log mean | exposure | none | R `offset(log(exposure))` candidate | `e(alpha)`, `predict, n`, exposure handling | R `pnbinom(size=theta, mu=mu)` | `NEEDS_RESEARCH` | Requires strict exposure > 0 validation and equivalence logs. |
| `nbreg` | `dispersion(mean)` | any | fweight | possible expanded-data check | `e(wtype)`, `e(wexp)`, `e(alpha)` | unresolved | `NEEDS_RESEARCH` | Do not benchmark residuals until weight semantics are closed. |
| `nbreg` | `dispersion(mean)` | any | aweight/iweight/pweight | no general equivalent established | `e(wtype)`, `e(wexp)`, `e(alpha)` | unresolved | `NO_R_EQUIVALENT` | Treat as blocked unless a family-specific interpretation is approved. |
| `nbreg` | `dispersion(constant)` | no | none | not established | `e(delta)`, `/lndelta` | unresolved | `NEEDS_RESEARCH` | Stata variance/dispersion form is not the same as NB2 mapping. |
| `gnbreg` | `lnalpha(varlist)` | any | none | not established | `predict, alpha` after `gnbreg` | observation-specific CDF needed | `NEEDS_RESEARCH` | Requires separate model and endpoint derivation. |
| `glm` | `family(nbinomial ml) link(log)` | no | none | `MASS::glm.nb()` candidate | parameter appears in `e(varfuncf)` text; `e(nbml)=1` | R `pnbinom` candidate | `NEEDS_RESEARCH` | Useful for comparison; not robust implementation route. |
| `glm` | `family(nbinomial #) link(log)` | no | none | `glm(..., family=MASS::negative.binomial(theta=#))` | fixed `#` from command, not estimated | R `pnbinom(size=#, mu=mu)` | `TESTABLE_NOW` | Benchmarkable as fixed-theta GLM, but not first support target. |
| `glm` | `family(nbinomial) link(identity/sqrt/nbinomial)` | no | none | possible with `MASS::negative.binomial(theta, link=...)` for identity/sqrt only | fixed/ML theta unresolved by link | R `pnbinom` | `CONVERGENCE_RISK` | Non-log links need convergent dataset design and link equivalence checks. |
| `nbreg` / `glm nbinomial` | any | any | any unsupported/ambiguous | none | none | none | `DO_NOT_TEST` | Skip combinations that cannot define a defensible estimator benchmark first. |

## 3. Dataset Feasibility Matrix

| dataset_id | Stata generation/source | R generation/source | expected behavior | first combinations |
|---|---|---|---|---|
| `NB_SYNTH_BASIC` | Simulate `x`, `mu=exp(b0+b1*x)`, `y=rnbinomial(theta, theta/(theta+mu))` if Stata RNG function available; otherwise import R-generated CSV | R `rnbinom(n, size=theta, mu=mu)` | Clean convergence and moderate overdispersion | `nbreg dispersion(mean)` no offset |
| `NB_OVERDISP_MODERATE` | Wider `mu` range and smaller `theta` | R `rnbinom` with fixed seed | Clear NB over Poisson, no extreme counts | `nbreg dispersion(mean)` no offset |
| `NB_ADV_SMALL_STABLE` | Hand-built or simulated small count dataset with zeros and low counts | Same CSV used in both Stata/R | Endpoint and clipping behavior without nonconvergence | `nbreg dispersion(mean)` no offset; later offset/exposure |

Dataset validation rules:

- Fit `nbreg` and R reference before testing `qresid`.
- Record convergence status.
- Record whether `alpha > 0`, `theta > 0`, `mu > 0`.
- Reject datasets with separation-like pathologies, all-zero outcomes, excessive leverage or unstable estimates.

## 4. Layer Comparison Matrix

| layer | Stata source | R source | pass condition |
|---|---|---|---|
| estimation sample | `e(sample)` | complete-case model frame | identical row set |
| coefficients | `e(b)` excluding `/lnalpha` | `coef(glm.nb_fit)` | tolerance set per dataset |
| `mu` | `predict double mu, n` | `fitted(glm.nb_fit)` | close within tolerance |
| `alpha` | `e(alpha)` | `1 / fit$theta` | close within tolerance |
| `lnalpha` | `/lnalpha` in `e(b)` | `log(1 / fit$theta)` | close within tolerance |
| `theta` | `1 / e(alpha)` | `fit$theta` | close within tolerance |
| `F_low` | formula or Stata-side CDF implementation candidate | `pnbinom(y - 1, size=theta, mu=mu)` with zero guard | close within tolerance |
| `F_high` | formula or Stata-side CDF implementation candidate | `pnbinom(y, size=theta, mu=mu)` | close within tolerance |
| `U` | `uvar()` supplied values | same fixed vector | exactly identical input |
| qres | `invnormal(U)` after PIT interval | R computed residual | close within tolerance |

## 5. Required Tests Before Implementation

Minimum benchmark suite before `NB_IMPLEMENTATION_ALLOWED` can become `yes`:

- `NB_SYNTH_BASIC`: all layers pass.
- `NB_OVERDISP_MODERATE`: all layers pass.
- `NB_ADV_SMALL_STABLE`: all layers pass.
- Explicit failure test: NB remains blocked in `qresid` until implementation branch starts.
- Error policy test plan: unsupported `dispersion(constant)`, weights, `gnbreg`, and ambiguous GLM NB paths must fail with controlled errors in any future implementation.

## 6. Implementation Preconditions

Implementation may be proposed only after:

- all three unweighted `nbreg dispersion(mean)` datasets pass;
- endpoint formulas are reproduced independently in Stata and R;
- `uvar()` gives deterministic R/Stata residual equality;
- help/examples/test scope is updated in a separate plan;
- no public API changes are required.

Until then:

`NB_IMPLEMENTATION_ALLOWED: no`
