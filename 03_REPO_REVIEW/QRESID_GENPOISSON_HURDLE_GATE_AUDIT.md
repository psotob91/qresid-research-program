Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before generalized Poisson or hurdle count work

# QRESID_GENPOISSON_HURDLE_GATE_AUDIT.md

Date: 2026-05-10

POST_CHANGE_SYNC_DONE: generalized Poisson and hurdle research gates opened.
SUPPORT_MATRIX_SYNC_DONE: support matrix, unified extension matrix and math/software evidence matrix reviewed; no support claim added.

## Decision

`GENERALIZED_POISSON_IMPLEMENTATION_ALLOWED: no`

`HURDLE_COUNT_IMPLEMENTATION_ALLOWED: no`

`BENCHMARK_RESEARCH_ALLOWED: yes`

This audit opens a separate benchmark-first cycle. It does not authorize changes
to `qresid.ado`.

## Generalized Poisson Gate

Candidate Stata route:

- Stata Journal `gpoisson` / `st0279` from Harris, Yang and Hardin (2012).
- Any SSC route must be source/version/license pinned before use.
- Do not confuse SJ `gpoisson` with unrelated local `gtools/gpoisson.ado`.

Candidate R routes:

- `VGAM::genpoisson0`, `VGAM::genpoisson1`, `VGAM::genpoisson2`.
- `glmmTMB::genpois`.

Required closure before implementation:

- PMF/CDF and support documented.
- Stata parameter extraction closed from postestimation results.
- R parameterization mapped or explicitly downgraded to `R_APPROX_BENCHMARK`.
- Three datasets: underdispersed, overdispersed/moderate, adversarial stable.
- Layers: sample, coefficients where comparable, fitted mean, ancillary
  parameters, `F_low`, `F_high`, `U`, qres.

## Hurdle Count Gate

Candidate Stata route:

- No official count-hurdle estimator is claimed in this audit.
- `churdle` exists officially, but it is not accepted as a count-hurdle route
  without a separate proof of support, extraction and discrete CDF semantics.
- External Stata routes require source/version/license pinning.

Candidate R routes:

- `glmmTMB` hurdle-style count models through truncated count families and a
  zero component.
- `VGAM` zero-altered and positive-count families such as `zapoisson`,
  `zanegbinomial`, `pospoisson`, and `posnegbinomial`.

Mathematical target:

- `P(Y=0)=pi`.
- For `y > 0`, `F(y)=pi+(1-pi)*F_plus(y)`, where `F_plus` is the positive
  truncated count CDF.

Required closure before implementation:

- Stata estimator route identified and pinned or official support proven.
- Zero process and positive-count process parameters extracted robustly.
- CDF endpoints reproduce the hurdle mass at zero and positive support.
- Three convergent datasets for Poisson and NB hurdle candidates.

## Censored PIT Note

The interval-PIT idea generalizes beyond discrete censored counts. For a
continuous censored observation, use the fitted CDF interval implied by the
censoring bounds and draw `U` uniformly within that interval. For discrete
counts, the same principle uses inclusive/exclusive CDF endpoints that respect
Stata's censoring convention. This theory does not authorize any family by
itself; each route still needs extraction, CDF and benchmark evidence.

## Release Interpretation

Missing generalized Poisson and hurdle support remains `MISSING_NOT_BLOCKING`
for current package validity. They must stay out of help/README claims until
the gate closes and tests/certification pass.
