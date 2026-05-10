Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before grouped binomial benchmark or implementation decisions

# Grouped Binomial Link Matrix

Date: 2026-05-10

Status source: extension branch `dev-qresid-nb-weights-grouped-binomial`; local Stata/R documentation inspection; no changes to `qresid.ado`.

POST_CHANGE_SYNC_DONE: grouped binomial link matrix registered in `04_RETRIEVAL_CONTEXT/DOCUMENT_STATUS_REGISTRY.md`.

## Decision Summary

`GROUPED_BINOMIAL_IMPLEMENTATION_ALLOWED: yes`, limited to tested GLM links and `binreg, n()` aliases.

`GROUPED_BINOMIAL_BENCHMARK_ALLOWED: yes`

The benchmark candidate `glm, family(binomial trials)` passed with exact binomial CDF endpoints. `binreg` aliases `or`, `rr`, and `rd` also passed as aliases after the GLM layers. `binreg hr` has Stata-internal validation only.

## Link Matrix

| command | Stata syntax | link | R equivalent | trials source | status | benchmark_required |
|---|---|---|---|---|---|---|
| `glm` | `glm y x, family(binomial nvar) link(logit)` | logit | `glm(cbind(y, n-y) ~ x, family=binomial("logit"))` and proportion/weights form | `e(m)=nvar` | `BENCHMARK_CANDIDATE` | yes |
| `glm` | `glm y x, family(binomial nvar) link(probit)` | probit | `glm(cbind(y, n-y) ~ x, family=binomial("probit"))` | `e(m)=nvar` | `BENCHMARK_CANDIDATE` | yes |
| `glm` | `glm y x, family(binomial nvar) link(cloglog)` | cloglog | `glm(cbind(y, n-y) ~ x, family=binomial("cloglog"))` | `e(m)=nvar` | `BENCHMARK_CANDIDATE` | yes |
| `glm` | `glm y x, family(binomial nvar) link(log)` | log | `glm(cbind(y, n-y) ~ x, family=binomial("log"))` | `e(m)=nvar` | `BENCHMARK_CANDIDATE` | yes |
| `glm` | `glm y x, family(binomial nvar) link(identity)` | identity | `glm(cbind(y, n-y) ~ x, family=binomial("identity"))` | `e(m)=nvar` | `BENCHMARK_CANDIDATE` | yes |
| `glm` | Stata cauchit equivalent not identified | cauchit | `glm(..., family=binomial("cauchit"))` | R trials | `R_ONLY` | no for grouped gate |
| `glm` | `glm y x, family(binomial nvar) link(logc)` | log-complement | custom R link required | `e(m)=nvar` | `NEEDS_RESEARCH` | yes, after custom-link decision |
| `glm` | `glm y x, family(binomial nvar) link(loglog)` | loglog | custom or non-base R equivalent required | `e(m)=nvar` | `NEEDS_RESEARCH` | yes, after equivalence decision |
| `glm` | `glm y x, family(binomial nvar) link(power #)` | power | custom R link required | `e(m)=nvar` | `NEEDS_RESEARCH` | yes, after equivalence decision |
| `binreg` | `binreg y x, n(nvar) or` | logit | same as R binomial logit | `e(m)=nvar` | `TESTED_READY` | yes |
| `binreg` | `binreg y x, n(nvar) rr` | log | same as R binomial log | `e(m)=nvar` | `TESTED_READY` | yes |
| `binreg` | `binreg y x, n(nvar) rd` | identity | same as R binomial identity | `e(m)=nvar` | `TESTED_READY` | yes |
| `binreg` | `binreg y x, n(nvar) hr` | log-complement | custom R link required | `e(m)=nvar` | `STATA_INTERNAL_VALIDATION` | yes, but not an R-exact support claim |

## Dataset Matrix

| dataset_id | purpose | design | required links |
|---|---|---|---|
| `GBINOM_CONST_TRIALS` | constant-denominator sanity benchmark | `n` constant, probabilities moderate, no separation | logit, probit, cloglog, log, identity |
| `GBINOM_VAR_TRIALS` | denominator extraction benchmark | variable `n`, continuous predictor, outcomes mostly interior | logit, probit, cloglog, log, identity |
| `GBINOM_EDGE_STABLE` | endpoint benchmark | includes some `y=0` and `y=n`, avoids perfect separation | logit first, then other links if convergent |

## Required Benchmark Layers

Each candidate row must compare Stata and R by layers:

1. convergence status and model sample;
2. denominator/trials source;
3. coefficients;
4. prediction layer from Stata `predict, mu`;
5. normalized probability `p`;
6. exact binomial `F_low`;
7. exact binomial `F_high`;
8. deterministic `U` through `uvar()`;
9. final randomized quantile residual.

The benchmark must determine whether Stata `predict, mu` returns expected successes or probability for each route. Implementation is not allowed until this is resolved.

## Candidate R Encodings

Both R encodings may be used only if they agree:

```r
fit_cbind <- glm(cbind(success, trials - success) ~ x,
                 family = binomial(link = link_name),
                 data = d)

fit_prop <- glm(success / trials ~ x,
                weights = trials,
                family = binomial(link = link_name),
                data = d)
```

If the two R encodings disagree beyond tolerance, the combination becomes `NEEDS_RESEARCH`.

## Implementation Preconditions

Before `qresid.ado` changes:

- `GROUPED_BINOMIAL_IMPLEMENTATION_ALLOWED` is `yes` only for tested GLM and `binreg` alias routes;
- all five base candidate links must be benchmarked or explicitly narrowed;
- the implementation must define how `p_i` is extracted from Stata predictions;
- `binreg` remains an alias/dispatcher path, not an independent formula path;
- `binreg hr` remains Stata-internal, while custom links, weights, and offset-like variants stay outside the initial implementation.
