Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before inverse Gaussian or fweight extension decisions

# QRESID_IGAUSSIAN_FWEIGHT_EXTENSION_AUDIT.md

Date: 2026-05-10

POST_CHANGE_SYNC_DONE: inverse Gaussian and expanded fweight extension audit created after implementation and validation.
SUPPORT_MATRIX_SYNC_DONE: current feature matrix and HTML updated for inverse Gaussian and expanded fweight status.

## Decision

`EXTENSION_DECISION: EXPERIMENTAL_VALIDATED_LOCAL`

The integrated experimental branch now includes inverse Gaussian support and expanded direct `fweight` support for tested routes. This is not a public RC decision.

## Implemented And Validated

| area | status | evidence |
|---|---|---|
| inverse Gaussian `glm` | `EXPERIMENTAL_VALIDATED_LOCAL` | `benchmark_igaussian_stata.do` + `benchmark_igaussian_r.R`; 3 datasets, links `power -2`, `log`, `identity`, `power -1`, none/fweight |
| inverse Gaussian CDF | `PASS` | closed-form CDF with stable log-CDF second term; R checker max diff about `3.7e-12` |
| `fweight` Bernoulli | `EXPERIMENTAL_VALIDATED_LOCAL` | `run_all_tests.do`, `benchmark_fweight_extended_*` |
| `fweight` grouped binomial | `EXPERIMENTAL_VALIDATED_LOCAL` | `run_all_tests.do`, `benchmark_fweight_extended_*`; trials remain separate from frequency weights |
| `fweight` NB `dispersion(mean)` | `EXPERIMENTAL_VALIDATED_LOCAL` | `run_all_tests.do`, `benchmark_fweight_extended_*`; only NB mean-dispersion route |
| `fweight` Gamma | `EXPERIMENTAL_VALIDATED_LOCAL` | `run_all_tests.do`, `benchmark_fweight_extended_*` |
| `fweight` inverse Gaussian | `EXPERIMENTAL_VALIDATED_LOCAL` | `run_all_tests.do`, `benchmark_igaussian_*`, `benchmark_fweight_extended_*` |

## Validation Evidence

- `QRESID_TEST_STATUS PASS`
- `QRESID_CERTIFICATION_STATUS PASS_EXPERIMENTAL_EXTENSION_LOCAL_STATA_COMPONENTS`
- `QRESID_IGAUSSIAN_BENCHMARK_R_STATUS PASS`
- `QRESID_FWEIGHT_EXTENDED_BENCHMARK_R_STATUS PASS`
- `QRESID_GLM_LINK_MATRIX_R_STATUS PASS` after GLM/link reconciliation; inverse Gaussian now appears in the generated HTML as `EXPERIMENTAL_VALIDATED_LOCAL`.
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
