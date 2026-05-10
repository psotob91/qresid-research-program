Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before NB, weights, grouped binomial, link/dispersion extension work

# QRESID_EXTENSION_MATRIX_PLAN.md

Date: 2026-05-10

Branch: `dev-qresid-nb-weights-grouped-binomial`

Status source: root `ecd0140` / qresid `388e595`, prerelease tags `qresid-v0.1.0-prerelease.2` and `v0.1.0-prerelease.2`.

POST_CHANGE_SYNC_DONE: registry updated for this plan. No `qresid.ado`, tests or implementation files were modified by this planning step.

## 1. Purpose

Define the experimental research and benchmark matrix for possible extensions after local prerelease:

- negative binomial;
- grouped binomial;
- weights for already implemented models;
- exhaustive link x weights x dispersion/scale combinations.

This document is a planning and gatekeeping artifact. It does not authorize implementation by itself.

## 2. Non-Negotiable Rules

- Do not assume Stata/R equivalence without source evidence and benchmark evidence.
- Do not activate support from a green model fit alone; residual construction must pass CDF endpoint and PIT/RQR checks.
- Do not blame `qresid` for a nonconvergent model until the dataset, estimator and equivalent R/Stata specification are validated.
- Do not implement stable NB, grouped binomial or weights until the relevant research gate is closed.
- Do not change the public API unless a separate human decision updates `09`, `10`, help, examples and tests.
- Do not copy Stata, R or third-party source code into `qresid`.

## 3. Classification Tags

| tag | meaning |
|---|---|
| `TESTABLE_NOW` | Combination can be benchmarked against existing support or clearly equivalent estimators without changing public support. |
| `NEEDS_RESEARCH` | Combination may be supportable, but needs manual/source review, extraction rules or benchmark design. |
| `NO_R_EQUIVALENT` | Stata can estimate it, but no operational R equivalent is currently identified. |
| `STATA_NOT_SUPPORTED` | The requested estimator/link/weight/scale combination is not supported by Stata. |
| `CONVERGENCE_RISK` | The combination is theoretically estimable but dataset design must be especially careful. |
| `DO_NOT_TEST` | Out of scope, not meaningful, or likely to create misleading evidence. |

## 4. Active And Candidate Model Matrix

| family_scope | Stata command | current qresid status | links to inventory | weights to inventory | dispersion/scale to inventory | initial classification |
|---|---|---|---|---|---|---|
| Gaussian | `regress` | supported unweighted | identity | none, fweight, aweight, iweight, pweight if Stata permits | residual variance/default | unweighted `TESTABLE_NOW`; weights `NEEDS_RESEARCH` |
| Gaussian | `glm, family(gaussian)` | supported unweighted | identity, log, inverse/reciprocal when convergent | none, fweight, aweight, iweight, pweight if Stata permits | default, fixed, estimated if Stata/R map | unweighted links `TESTABLE_NOW`; scale/weights `NEEDS_RESEARCH` |
| Poisson | `poisson` | supported unweighted | log | none, fweight, iweight, pweight if Stata permits | default | unweighted `TESTABLE_NOW`; weights `NEEDS_RESEARCH` |
| Poisson | `glm, family(poisson)` | supported unweighted | log, identity, sqrt when convergent | none, fweight, aweight, iweight, pweight if Stata permits | default/fixed if meaningful | unweighted links `TESTABLE_NOW`; weights/scale `NEEDS_RESEARCH` |
| Bernoulli | `logit` | supported unweighted | logit | none, fweight, iweight, pweight if Stata permits | default | unweighted `TESTABLE_NOW`; weights `NEEDS_RESEARCH` |
| Bernoulli | `logistic` | supported unweighted | logit/or reporting | none, fweight, iweight, pweight if Stata permits | default | unweighted `TESTABLE_NOW`; weights `NEEDS_RESEARCH` |
| Bernoulli | `glm, family(binomial)` | supported only individual Bernoulli (`e(m)==1`) | logit, probit, cloglog, log, identity when convergent | none, fweight, aweight, iweight, pweight if Stata permits | default/fixed if meaningful | individual unweighted `TESTABLE_NOW`; grouped/weights `NEEDS_RESEARCH` |
| Bernoulli/binomial | `binreg` | supported only individual Bernoulli (`e(m)==1`) | logit/or, log/rr, identity/rd, hazard link if mappable | none, supported Stata weights by command | default | individual unweighted `TESTABLE_NOW`; grouped/weights `NEEDS_RESEARCH` |
| Gamma | `glm, family(gamma)` | supported unweighted | log, inverse, identity when convergent | none, fweight, aweight, iweight, pweight if Stata permits | default, fixed, estimated | unweighted links `TESTABLE_NOW`; scale/weights `NEEDS_RESEARCH` |
| Negative binomial | `nbreg` | not implemented | Stata-supported NB links/options | none, supported Stata weights by command | alpha/theta/k, NB1/NB2, default/fixed if available | `NEEDS_RESEARCH` |
| Negative binomial | `glm, family(nbinomial)` | not implemented | only if Stata supports and R equivalent exists | none, supported Stata weights by command | NB parameterization and scale | `NEEDS_RESEARCH` or `STATA_NOT_SUPPORTED` after inspection |
| Grouped binomial | `glm, family(binomial)` | blocked by current qresid gate | logit, probit, cloglog, log, identity when convergent | none first; weights later | trials/denominator extraction | `NEEDS_RESEARCH` |
| Grouped binomial | `binreg` | blocked by current qresid gate | logit/or, log/rr, identity/rd, hazard link if mappable | none first; weights later | trials/denominator extraction | `NEEDS_RESEARCH` |

## 5. Link Matrix To Inventory

| family | links | first action |
|---|---|---|
| Gaussian | identity, log, inverse/reciprocal if Stata/R converge | Keep unweighted matrix as baseline; research scale and weights separately. |
| Poisson | log, identity, sqrt | Add offset/exposure submatrix before weights. |
| Binomial/Bernoulli | logit, probit, cloglog, log, identity | Separate individual Bernoulli from grouped binomial before any support claim. |
| Gamma | log, inverse, identity | Verify shape/scale/dispersion mapping for each link. |
| NB | Stata-supported links and R equivalents | Research before any benchmark is treated as support evidence. |

## 6. Weights Matrix To Inventory

| weight_type | default policy | R equivalence policy |
|---|---|---|
| none | baseline for all models | Required for every support claim. |
| fweight | `NEEDS_RESEARCH` | Candidate frequency-equivalence tests; validate by expanded data where feasible. |
| aweight | `NEEDS_RESEARCH` | Do not assume GLM prior-weight equivalence without source evidence. |
| iweight | `NEEDS_RESEARCH` | Likely no general RQR equivalence; classify per family. |
| pweight | `NEEDS_RESEARCH` | Survey/design interpretation may be out of scope; likely `NO_R_EQUIVALENT` for residual CDF evidence. |

No global rule such as multiplying residuals by `sqrt(w_i)` is allowed.

## 7. Dispersion And Scale Matrix To Inventory

| area | combinations | first action |
|---|---|---|
| Gaussian `glm` | default scale, fixed scale, estimated scale | Map Stata `scale()` and stored results to R `summary.glm()` dispersion. |
| Gamma `glm` | default scale, fixed scale, estimated scale | Confirm shape `1/phi`, scale `mu*phi` remains correct under every scale mode. |
| Poisson/binomial | default and any allowed scale options | Treat noncanonical scale options as research-only until CDF implications are clear. |
| NB | alpha/theta/k plus scale if applicable | Close NB parameterization before any residual calculation. |

## 8. Research Gates

### NB_GATE

Required before stable NB support:

- Inspect local Stata ado/manuals for `nbreg` and any GLM NB support.
- Identify whether Stata is using NB1, NB2 or another variance form.
- Map Stata ancillary parameters to R parameters (`theta`, `size`, `alpha`, `k`) with formulas.
- Confirm exact CDF and endpoint construction for observed counts.
- Pass at least three datasets by layers: sample, predictions, ancillary parameter, CDF endpoints, `U`, residual.

### GROUPED_BINOMIAL_GATE

Required before grouped binomial support:

- Prove how trials are represented/extracted from Stata estimation results.
- Separate individual Bernoulli (`e(m)==1`) from grouped binomial.
- Match R `glm(cbind(success, failure), family=binomial(link=...))` or an explicitly equivalent form.
- Pass at least three datasets per supported link before support claims.

### WEIGHTS_GATE

Required before any weighted RQR support:

- Read Stata command-specific weight support and stored `e(wtype)`/`e(wexp)`.
- Define family x weight-type semantics.
- Identify R equivalence or mark `NO_R_EQUIVALENT`.
- Compare weighted fit inputs, fitted values and CDF parameters before residuals.
- Do not combine all weight types under one rule.

### SCALE_GATE

Required before scale/dispersion support:

- Document Stata stored scale/dispersion quantities.
- Map to R scale/dispersion outputs.
- Verify whether scale affects CDF parameters, not just standard errors.
- Pass three datasets for Gaussian/Gamma before expanding.

### LINK_GATE

Required before new link claims:

- Confirm Stata and R define the same inverse link.
- Use datasets designed to converge and stay inside response support.
- Mark nonconvergent or boundary-heavy cases as dataset/model issues until isolated.

## 9. Dataset Design

Every candidate support combination needs three datasets:

| dataset_type | purpose |
|---|---|
| synthetic controlled | Known parameters and clean convergence. |
| real/manual/literature | Realistic estimation behavior from Stata/R examples or project casebank. |
| adversarial small | Boundary and numerical checks while still designed to converge. |

Dataset logs must record:

- source;
- transformation;
- model formula;
- seed if simulated;
- convergence status in Stata and R;
- reason for exclusion if not used.

## 10. Benchmark Layers

Do not compare only final residuals. Compare:

1. estimation sample;
2. coefficients where applicable;
3. prediction quantity (`mu`, `pr`, `n`, `xb` or equivalent);
4. ancillary parameters;
5. CDF lower endpoint;
6. CDF upper endpoint;
7. supplied or generated `U`;
8. final quantile residual.

Discrete families must use `uvar()` for exact Stata/R residual comparison.

## 11. Initial Priority Queue

| priority | topic | reason | allowed next step |
|---|---|---|---|
| P1 | grouped binomial unweighted | Closest extension from current Bernoulli/binomial support. | Research extraction and R equivalence; no `qresid.ado` change until gate closes. |
| P1 | NB unweighted | Phase 1 eligible but historically blocked by parameterization. | Research NB1/NB2 and CDF mapping first. |
| P2 | weights for current families | High user value, high semantic risk. | Build weight semantics matrix; no implementation until per-family evidence exists. |
| P2 | scale/dispersion for Gaussian/Gamma | Needed for exhaustive GLM confidence. | Research Stata/R scale mapping and benchmark effect on CDF. |
| P3 | additional noncanonical links | Mostly benchmark hardening. | Extend only if convergence and equivalence are stable. |

## 12. Stop Rules

Stop and request human review if:

- R and Stata parameterizations do not align;
- a weight type has no defensible residual interpretation;
- grouped binomial trials cannot be extracted unambiguously;
- NB CDF endpoint construction is unclear;
- a proposed change would alter public API;
- a support claim would require documenting an unbenchmarked family/link/weight combination.

## 13. Deliverables For Later Implementation

Future implementation cycles may create:

- `qresid/tests/extension_matrix_*.do`;
- `qresid/tests/extension_matrix_*.R`;
- `qresid/certification/reports/qresid_extension_matrix.html`;
- technical notes for NB, grouped binomial, weights and scale.

Those are not created by this planning step.
