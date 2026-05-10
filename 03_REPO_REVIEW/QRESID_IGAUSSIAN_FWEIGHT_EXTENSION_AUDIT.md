Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before inverse Gaussian or fweight extension decisions

# QRESID_IGAUSSIAN_FWEIGHT_EXTENSION_AUDIT.md

Date: 2026-05-10

POST_CHANGE_SYNC_DONE: inverse Gaussian and expanded fweight extension audit updated after promotion to extension-prerelease readiness.
SUPPORT_MATRIX_SYNC_DONE: current feature matrix and HTML updated for inverse Gaussian and expanded fweight readiness.

## Decision

`EXTENSION_DECISION: READY_FOR_EXTENSION_PRERELEASE`

The integrated experimental branch now includes inverse Gaussian support and expanded direct `fweight` support for tested routes. These routes are ready for local extension prerelease, but this is not a public RC decision.

## Implemented And Validated

| area | status | evidence |
|---|---|---|
| inverse Gaussian `glm` | `READY_FOR_EXTENSION_PRERELEASE` | `benchmark_igaussian_stata.do` + `benchmark_igaussian_r.R`; 3 datasets, links `power -2`, `log`, `identity`, `power -1`, none/fweight |
| inverse Gaussian CDF | `PASS` | closed-form CDF with stable log-CDF second term; R checker max diff about `3.7e-12` |
| `fweight` Bernoulli | `READY_FOR_EXTENSION_PRERELEASE` | `run_all_tests.do`, `benchmark_fweight_extended_*` |
| `fweight` grouped binomial | `READY_FOR_EXTENSION_PRERELEASE` | `run_all_tests.do`, `benchmark_fweight_extended_*`; trials remain separate from frequency weights |
| `fweight` NB `dispersion(mean)` | `READY_FOR_EXTENSION_PRERELEASE` | `run_all_tests.do`, `benchmark_fweight_extended_*`; only NB mean-dispersion route |
| `fweight` Gamma | `READY_FOR_EXTENSION_PRERELEASE` | `run_all_tests.do`, `benchmark_fweight_extended_*` |
| `fweight` inverse Gaussian | `READY_FOR_EXTENSION_PRERELEASE` | `run_all_tests.do`, `benchmark_igaussian_*`, `benchmark_fweight_extended_*` |

## Validation Evidence

- `QRESID_TEST_STATUS PASS`
- `QRESID_CERTIFICATION_STATUS PASS_EXPERIMENTAL_EXTENSION_LOCAL_STATA_COMPONENTS`
- `QRESID_IGAUSSIAN_BENCHMARK_R_STATUS PASS`
- `QRESID_FWEIGHT_EXTENDED_BENCHMARK_R_STATUS PASS`
- `QRESID_GLM_LINK_MATRIX_R_STATUS PASS` after GLM/link reconciliation; inverse Gaussian remains direct GLM/link evidence and the live support matrix now marks it `READY_FOR_EXTENSION_PRERELEASE`.
- GLM/link inventory harmonized after support-matrix review: grouped binomial, NB and tested `fweight` routes now point to separate benchmark evidence instead of appearing as absolute `GATED_FUTURE`.
- Existing Gamma, Phase 1, GLM/link, grouped binomial, NB, fweight and pweight diagnostics remain passing in the latest validation cycle.

## Remaining Gated Items

- `aweight`, `iweight`, `svy:` and weighted routes outside direct `fweight`.
- `pweight` remains `DIAGNOSTIC_ONLY`, not survey-exact support.
- Tweedie, ZIP/ZINB, hurdle, truncation and mixed/GLMM/GSEM remain future phase.

## Freeze Status

The package-side freeze has been created:

- `qresid/`: `feat: add inverse gaussian and expanded fweight support`
- `qresid/` commit: `872d098`
- `qresid/` tag: `v0.1.0-extension-ig-fweight.1`

The root checkpoint is created with this report sync:

- root: `chore: checkpoint inverse gaussian fweight extension`
- root tag: `qresid-extension-ig-fweight-freeze.1`
