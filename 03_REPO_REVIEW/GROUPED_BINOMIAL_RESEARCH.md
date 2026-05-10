Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before grouped binomial benchmark or implementation decisions

# Grouped Binomial Semantics Research

Date: 2026-05-10

Status source: extension branch `dev-qresid-nb-weights-grouped-binomial`; local Stata/R documentation inspection; no changes to `qresid.ado`.

POST_CHANGE_SYNC_DONE: grouped binomial research reports registered in `04_RETRIEVAL_CONTEXT/DOCUMENT_STATUS_REGISTRY.md`.

## Decision

`GROUPED_BINOMIAL_IMPLEMENTATION_ALLOWED: yes`

`GROUPED_BINOMIAL_BENCHMARK_ALLOWED: yes`

Grouped binomial support is now allowed for the narrow integrated experimental scope after Stata/R benchmark evidence passed for `glm, family(binomial trials)` across three datasets and five links.

Allowed implementation scope:

- `glm, family(binomial trials)` / `glm, family(binomial #)`;
- links `logit`, `probit`, `cloglog`, `log`, `identity`;
- unweighted grouped binomial only.

Still blocked:

- `binreg` aliases until a separate alias benchmark confirms identical layers;
- grouped binomial with weights;
- `binreg hr` / log-complement links.

## Current Package Gate

The current `qresid.ado` intentionally blocks grouped binomial models:

- `glm, family(binomial ...)` with `e(m) != 1` exits through the grouped-binomial gate.
- `binreg` with `e(m) != 1` exits through the same gate.
- Existing Bernoulli support remains limited to individual 0/1 outcomes.

This is correct until grouped binomial benchmarks close.

## Stata Semantics

### `glm, family(binomial nvar/#)`

Candidate syntax:

```stata
glm y x, family(binomial nvar) link(logit)
glm y x, family(binomial #) link(logit)
```

Relevant stored results to inspect before implementation:

- `e(cmd)`: `glm`
- `e(varfunct)`: `Binomial`
- `e(m)`: binomial denominator, either a variable name or scalar count
- `e(linkt)`: display name of link
- `e(linkf)`: link expression
- `predict, mu`: prediction layer that must be benchmarked

Implementation must not assume whether `predict, mu` returns expected successes or a probability in every path. The RQR layer needs `p_i`; if Stata returns expected successes, `p_i = mu_i / m_i`. If Stata returns a probability, use `p_i = mu_i`. This must be resolved empirically in the benchmark before code changes.

### `binreg, n(nvar/#)`

`binreg` is a wrapper around `glm, family(binomial m)`. Candidate mappings:

| binreg option | Stata link | R base equivalent |
|---|---|---|
| `or` | logit | `binomial(link = "logit")` |
| `rr` | log | `binomial(link = "log")` |
| `rd` | identity | `binomial(link = "identity")` |
| `hr` | log-complement | needs research / custom link |

`binreg hr` is not enabled for implementation planning because R base does not expose a standard matching link by name.

## R Equivalents

Two R encodings are acceptable only if they produce matching layers:

```r
glm(cbind(success, trials - success) ~ x, family = binomial(link = L), data = d)
glm(success / trials ~ x, weights = trials, family = binomial(link = L), data = d)
```

Both forms must be compared for effective sample, coefficients, fitted probability, binomial denominator, CDF endpoints, and randomized quantile residual.

## CDF Definition

For each row:

```text
Y_i ~ Binomial(m_i, p_i)
F_low_i  = P(Y_i <= y_i - 1)
F_high_i = P(Y_i <= y_i)
```

Boundary behavior:

- if `y_i = 0`, `F_low_i = 0`;
- if `y_i = m_i`, `F_high_i = 1`;
- all endpoint values must satisfy `0 <= F_low_i <= F_high_i <= 1`.

For R benchmarks, use exact binomial CDF endpoints:

```r
F_low  <- ifelse(y == 0, 0, pbinom(y - 1, size = m, prob = p))
F_high <- pbinom(y, size = m, prob = p)
```

## Required Validations

Before any implementation:

- outcome `y` must be integer;
- denominator `m` must be integer and strictly positive;
- `0 <= y <= m`;
- predicted probability `p` must satisfy `0 <= p <= 1`;
- rows with missing outcome, denominator, fitted probability, or sample exclusion must be handled consistently with `marksample` and `e(sample)`;
- `F_low <= F_high`;
- randomized `U` must satisfy `F_low <= U <= F_high`;
- final residual must be finite except where a documented endpoint limit is intentionally clipped.

## Implementation Boundary

Allowed for benchmark only:

- `glm, family(binomial nvar/#)` with links `logit`, `probit`, `cloglog`, `log`, `identity`;
- `binreg or`, `binreg rr`, `binreg rd` after confirming they match the corresponding `glm` layers.

Blocked until separate research:

- `binreg hr`;
- grouped binomial with Stata weights;
- grouped binomial with offset/exposure-like adjustments;
- R-only links such as `cauchit`;
- custom or Stata-only link functions without a documented R equivalent;
- grouped binomial public support in `qresid.ado`.

## Dataset Design

| dataset_id | purpose | design |
|---|---|---|
| `GBINOM_CONST_TRIALS` | basic link/CDF equivalence | constant denominator, moderate probabilities, no separation |
| `GBINOM_VAR_TRIALS` | denominator extraction | variable denominator, continuous predictor, mostly interior outcomes |
| `GBINOM_EDGE_STABLE` | endpoint handling | some `y=0` and `y=m`, no perfect separation |

## Benchmark Layers

Grouped binomial is not cleared by model convergence alone. Benchmarks must compare:

1. effective sample;
2. `m` / trials extraction;
3. coefficients;
4. fitted probability `p` or normalized `mu`;
5. `F_low`;
6. `F_high`;
7. fixed `U` via `uvar()`;
8. final qresid.

## Recommendation

Proceed to benchmark design for `glm, family(binomial nvar/#)` first. Treat `binreg` as a dispatcher/alias candidate only after the `glm` layers pass. Keep implementation blocked until the benchmark matrix is green.
