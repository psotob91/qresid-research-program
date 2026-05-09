# EXTERNAL_REPO_MANIFEST.md

## 0. Purpose

Curated manifest of external repositories relevant to `qresid` development.

This directory is a retrieval layer only. It is not vendored source, not an implementation dependency, and not permission to copy code into `qresid/`.

Rules:

- Do not copy external code into `qresid/`.
- Do not assume license compatibility; inspect license evidence before any reuse beyond reading.
- Do not load complete repositories into agent context.
- Use these repositories only as design references for architecture, tests, certification, benchmarking, and diagnostic semantics.
- Treat all external repositories as read-only context for future MCP indexing.

Clone policy:

- Existing clones were preserved; no reclone was performed during this curation pass.
- If a required `PRIORITY_HIGH` repo is missing, use shallow clone only: `git clone --depth 1 --filter=blob:none`.
- No forks, replacement repositories, external datasets, or binary assets should be downloaded.
- `topmodels` remains pending because no canonical GitHub repository was verified and local SVN tooling is unavailable.

---

## 1. Priority Classes

### PRIORITY_HIGH

Cloned locally when possible because they map directly to one or more core needs:

- Stata SSC/Stata Journal package architecture.
- ado/Mata programming style.
- postestimation and `e()`/`predict` patterns.
- certification and reproducible test scripts.
- R benchmark functions for CDF/PIT/quantile residuals.
- simulation diagnostics and residual tests.

### PRIORITY_OPTIONAL

Not cloned in this phase. Useful later for narrower comparisons, graph style, or additional model families, but not required before the first `qresid` implementation pass.

### FUTURE_PHASES

Not cloned in this phase. Useful only when `qresid` expands into zero-inflation, hurdle, COM-Poisson, Tweedie, GLMM/GSEM-like diagnostics, Bayesian diagnostics, or distributional regression frameworks.

---

## 2. PRIORITY_HIGH: Stata Repositories

### reghdfe

- repo_name: `reghdfe`
- github_url: `https://github.com/sergiocorreia/reghdfe.git`
- local_path: `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/STATA/reghdfe`
- package_type: Stata ado/Mata package; SSC-style public package.
- why_relevant: Mature Stata package with split source/build layout, help files, tests, benchmarks, versioning discipline, Mata-heavy architecture, and postestimation-adjacent programming patterns.
- relevant_files: `Readme.md`, `src/`, `current-code/`, `test/`, `interim-tests/`, `benchmark/`, `docs/`, `create_html_help.do`
- relevant_patterns: thin ado entry points; Mata/source modules; testing and benchmark directories; robust option parsing; public documentation separation.
- risks: different estimation target; large context footprint; architecture reference only; no code copying.
- recommended_phase: Fase 2 architecture; Fase 7 SSC/Stata Journal readiness.
- retrieval_priority: `PRIORITY_HIGH`
- clone_status: `CLONED`
- license_note: `LICENSE` inspected; indicates MIT.

### ftools

- repo_name: `ftools`
- github_url: `https://github.com/sergiocorreia/ftools.git`
- local_path: `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/STATA/ftools`
- package_type: Stata ado/Mata utility package.
- why_relevant: Compact reference for Stata/Mata modularization, Mata compilation helpers, helper ado routines, examples, and tests.
- relevant_files: `README.md`, `SYNTAX_README.md`, `src/ftools.ado`, `src/ftools.mata`, `src/ftools_common.mata`, `src/ms_compile_mata.ado`, `src/ftools.pkg`, `src/stata.toc`, `test/test_all.do`, `test/test_mata.do`
- relevant_patterns: small Stata wrappers around Mata internals; reusable helpers; concrete do-file tests.
- risks: optimized data manipulation patterns may be unnecessary for early `qresid`; do not copy helpers.
- recommended_phase: Fase 2 Mata/API design; Fase 5 stress/performance.
- retrieval_priority: `PRIORITY_HIGH`
- clone_status: `CLONED`
- license_note: `LICENSE` inspected; indicates MIT.

### gtools

- repo_name: `gtools`
- github_url: `https://github.com/mcaceresb/stata-gtools.git`
- local_path: `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/STATA/gtools`
- package_type: Stata package with ado, Mata, plugin/C source, build artifacts, tests.
- why_relevant: Strong reference for high-performance Stata package organization, generated build directory, help files, smoke tests, benchmarks, and plugin boundary management.
- relevant_files: `README.md`, `build/gtools.ado`, `build/gtools.sthlp`, `build/gtools_tests.do`, `build/gpoisson.ado`, `build/gpoisson.sthlp`, `build/_gtools_internal.ado`, `build/_gtools_internal.mata`, `src/`, `docs/examples/`, `docs/benchmarks/`
- relevant_patterns: public build artifacts separated from source; benchmark conventions; GLM-like wrapper examples.
- risks: contains binaries/build outputs and plugin machinery; do not load `lib/` or generated artifacts automatically; performance architecture should not drive Fase 1.
- recommended_phase: Fase 2 architecture; Fase 5 performance/stress testing.
- retrieval_priority: `PRIORITY_HIGH`
- clone_status: `CLONED`
- license_note: `LICENSE` inspected; indicates MIT.

### boottest

- repo_name: `boottest`
- github_url: `https://github.com/droodman/boottest.git`
- local_path: `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/STATA/boottest`
- package_type: Stata ado/Mata postestimation/inference package.
- why_relevant: Compact Stata package with ado/Mata boundary, postestimation behavior, help/pkg/toc files, and unit tests.
- relevant_files: `boottest.ado`, `boottest.mata`, `boottest.sthlp`, `boottest.pkg`, `stata.toc`, `test/unit tests.do`, `README.md`
- relevant_patterns: postestimation checks; user-facing error handling; Mata routines backing Stata command behavior; certification-like unit testing style.
- risks: bootstrap inference is not quantile residual logic; includes generated log and compiled `.mlib`; license not found in clone.
- recommended_phase: Fase 2 postestimation architecture; Fase 5 certification style.
- retrieval_priority: `PRIORITY_HIGH`
- clone_status: `CLONED`
- license_note: `NOT_FOUND_IN_CLONE`; no license file was found in the cloned tree.

### binsreg

- repo_name: `binsreg`
- github_url: `https://github.com/nppackages/binsreg.git`
- local_path: `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/STATA/binsreg`
- package_type: Multi-language statistical package with Stata, R, and Python implementations.
- why_relevant: Useful cross-language package reference for Stata/R alignment, help files, package files, examples, and benchmark-oriented structure.
- relevant_files: `README.md`, `stata/binsreg.ado`, `stata/binsreg.sthlp`, `stata/binsreg.pkg`, `stata/stata.toc`, `stata/binsreg_functions.do`, `stata/binsreg_illustration.do`, `R/`
- relevant_patterns: parallel Stata/R/Python package surfaces; public examples; package metadata across languages.
- risks: includes non-Stata language trees; methodology differs from residual diagnostics; do not broad-load `Python/`.
- recommended_phase: Fase 3 R-Stata benchmark structure; Fase 7 public package organization.
- retrieval_priority: `PRIORITY_HIGH`
- clone_status: `CLONED`
- license_note: `LICENSE.md` inspected; indicates GPL-3.0.

### coefplot

- repo_name: `coefplot`
- github_url: `https://github.com/benjann/coefplot.git`
- local_path: `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/STATA/coefplot`
- package_type: Stata graph/postestimation package.
- why_relevant: Small, clean SSC-style package with ado, help, pkg, toc, README, and graph/postestimation user interface.
- relevant_files: `coefplot.ado`, `coefplot.sthlp`, `coefplot.pkg`, `stata.toc`, `README.md`
- relevant_patterns: concise public Stata package surface; graph command syntax; help documentation.
- risks: graph patterns inform diagnostics UI only, not mathematical implementation.
- recommended_phase: Fase 4 diagnostic graphics; Fase 7 SSC packaging.
- retrieval_priority: `PRIORITY_HIGH`
- clone_status: `CLONED`
- license_note: `LICENSE` inspected; indicates MIT.

### estout

- repo_name: `estout`
- github_url: `https://github.com/benjann/estout.git`
- local_path: `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/STATA/estout`
- package_type: Stata estimation results/reporting package.
- why_relevant: Mature Stata ecosystem package for stored results, postestimation/reporting conventions, multiple ado entry points, help files, pkg, and toc.
- relevant_files: `estout.ado`, `eststo.ado`, `estadd.ado`, `estpost.ado`, `esttab.ado`, `estout.pkg`, `stata.toc`, `README.md`
- relevant_patterns: stored-results handling; multi-command package organization; backward-compatible interface conventions.
- risks: reporting package, not residual computation; do not emulate extensive option surface in Fase 1.
- recommended_phase: Fase 2 postestimation interface; Fase 7 public API discipline.
- retrieval_priority: `PRIORITY_HIGH`
- clone_status: `CLONED`
- license_note: `LICENSE` inspected; indicates MIT.

### moremata

- repo_name: `moremata`
- github_url: `https://github.com/benjann/moremata.git`
- local_path: `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/STATA/moremata`
- package_type: Mata function library with help files and compiled libraries.
- why_relevant: Reference for Mata library packaging, Mata help files, numeric utility naming, and public Mata API documentation.
- relevant_files: `source/`, `mf_*.hlp`, `mf_*.sthlp`, `lmoremata*.mlib` only as packaging artifact, `LICENSE`
- relevant_patterns: Mata library source/help organization; function-level documentation; numeric utility API conventions.
- risks: do not depend on `moremata` for core `qresid` unless explicitly chosen later; `.mlib` files are not source for retrieval.
- recommended_phase: Fase 2 Mata API design; Fase 7 help documentation for Mata internals if exposed.
- retrieval_priority: `PRIORITY_HIGH`
- clone_status: `CLONED`
- license_note: `LICENSE` inspected; indicates MIT.

---

## 3. PRIORITY_HIGH: R Repositories

### statmod

- repo_name: `statmod`
- github_url: `https://github.com/cran/statmod.git`
- local_path: `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/R/statmod`
- package_type: R statistical modeling package; CRAN mirror.
- why_relevant: Primary R benchmark source named in `STATA_R_BENCHMARK_MAPPING.md` for GLM-related residuals and distributions.
- relevant_files: `DESCRIPTION`, `NAMESPACE`, `R/`, `src/`, `tests/`, `man/`
- relevant_patterns: distribution and GLM helper functions; small tests; R-side reference for deterministic CDF/quantile calculations.
- risks: CRAN mirror may not be the development repository; R implementation choices may not map to Stata parameterization.
- recommended_phase: Fase 3 Fase 1 benchmarks; Fase 5 certification.
- retrieval_priority: `PRIORITY_HIGH`
- clone_status: `CLONED`
- license_note: `DESCRIPTION` inspected; indicates GPL-2 | GPL-3.

### DHARMa

- repo_name: `DHARMa`
- github_url: `https://github.com/florianhartig/DHARMa.git`
- local_path: `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/R/DHARMa`
- package_type: R simulation-based residual diagnostics package.
- why_relevant: Conceptual reference for simulation-based residuals, PIT-like diagnostics, quantile transforms, reproducibility tests, and model compatibility wrappers.
- relevant_files: `README.md`, `DHARMa/DESCRIPTION`, `DHARMa/R/simulateResiduals.R`, `DHARMa/R/transformQuantiles.R`, `DHARMa/R/random.R`, `DHARMa/R/tests.R`, `DHARMa/R/plots.R`, `DHARMa/tests/testthat/testNumericReproducibility.R`, `DHARMa/tests/testthat/testSimulateResiduals.R`, `DHARMa/tests/testthat/testTests.R`, `Code/DHARMaDevelopment/PIT.R`
- relevant_patterns: separation between fitted models, simulated responses, transformed residuals, and diagnostic tests; stochastic reproducibility tests; explicit model wrappers.
- risks: simulation diagnostics are Fase 2/3 for `qresid`, not Fase 1 analytic residuals; many issue-specific scripts must not be loaded automatically.
- recommended_phase: Fase 1 conceptual review; Fase 4 diagnostics; Fase 6 simulation extensions.
- retrieval_priority: `PRIORITY_HIGH`
- clone_status: `CLONED`
- license_note: `DHARMa/DESCRIPTION` inspected; indicates GPL (>= 3).

### VGAM

- repo_name: `VGAM`
- github_url: `https://github.com/cran/VGAM.git`
- local_path: `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/R/VGAM`
- package_type: R modeling/distribution package; CRAN mirror.
- why_relevant: Benchmark reference for negative binomial variants, zero-inflated models, generalized Poisson, COM-Poisson-adjacent families, and distribution parameterization checks.
- relevant_files: `DESCRIPTION`, `NAMESPACE`, `R/family.*.R`, `R/`, `src/`, `man/`, `tests/` if present
- relevant_patterns: family objects; parameterization conventions; distribution functions for nonstandard count models.
- risks: large and broad; inspect only files for the active family; CRAN mirror may lag development; parameterizations may differ from Stata.
- recommended_phase: Fase 3 NB benchmarks; Fase 6 generalized/future count models.
- retrieval_priority: `PRIORITY_HIGH`
- clone_status: `CLONED`
- license_note: `DESCRIPTION` inspected; indicates GPL-3; `LICENCE.note` contains additional copyright notes.

### topmodels

- repo_name: `topmodels`
- github_url: `NOT_VERIFIED`
- upstream_source: `https://topmodels.r-forge.r-project.org/` and R-Forge/SVN package source.
- local_path: `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/R/topmodels`
- package_type: R probabilistic model assessment infrastructure.
- why_relevant: Relevant for rootograms, PIT/residual diagnostic displays, and probabilistic model evaluation across model classes.
- relevant_files: pending retrieval from R-Forge/SVN: `R/`, `man/`, vignettes, tests.
- relevant_patterns: rootograms; probabilistic model assessment; model-class abstractions for distributions, probabilities, densities, quantiles, and residual diagnostics.
- risks: no canonical GitHub repository verified; `git ls-remote` failed for `https://github.com/zeileis/topmodels.git` and `https://github.com/topmodels/topmodels.git`; local `svn` command unavailable; do not substitute unrelated GitHub repos.
- recommended_phase: Fase 4 diagnostic graphics; Fase 6 probabilistic-model infrastructure.
- retrieval_priority: `PRIORITY_HIGH`
- clone_status: `PENDING_SOURCE_TOOLING`
- license_note: `NOT_INSPECTED`; source not retrieved.

### gamlss

- repo_name: `gamlss`
- github_url: `https://github.com/gamlss-dev/gamlss.git`
- local_path: `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/R/gamlss`
- package_type: R GAMLSS modeling package.
- why_relevant: Direct reference for randomized quantile residuals, worm plots, distributional residual diagnostics, and multi-parameter distribution model extraction.
- relevant_files: `DESCRIPTION`, `NAMESPACE`, `R/rqres.R`, `R/rqresplot_new.R`, `R/wp.R`, `R/prodist.R`, `R/getQuantile.R`, `R/predictAll_22_08_22.R`, `man/`
- relevant_patterns: randomized quantile residual semantics; worm plot diagnostic workflow; parameter extraction for distributional regression.
- risks: broader than Fase 1 Stata GLM/count scope; distribution parameterizations must be mapped explicitly before benchmark claims.
- recommended_phase: Fase 1 conceptual validation; Fase 4 worm plots; Fase 6 distributional extensions.
- retrieval_priority: `PRIORITY_HIGH`
- clone_status: `CLONED`
- license_note: `DESCRIPTION` inspected; indicates GPL-2 | GPL-3.

### glmmTMB

- repo_name: `glmmTMB`
- github_url: `https://github.com/glmmTMB/glmmTMB.git`
- local_path: `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/R/glmmTMB`
- package_type: R GLMM/TMB package with count, zero-inflated, hurdle/truncated families.
- why_relevant: Benchmark and architecture reference for NB variants, zero inflation, truncated families, model prediction layers, and future mixed-model simulation diagnostics.
- relevant_files: `README.md`, `glmmTMB/DESCRIPTION`, `glmmTMB/R/family.R`, `glmmTMB/R/glmmTMB.R`, `glmmTMB/R/predict.R`, `glmmTMB/R/methods.R`, `glmmTMB/R/diagnose.R`, `glmmTMB/src/glmmTMB.cpp`, `glmmTMB/src/distrib.h`, `glmmTMB/tests/testthat/`
- relevant_patterns: explicit family definitions; prediction paths; count-model parameterization handling; fitting/prediction tests.
- risks: largest clone; mixed/zero-inflated logic is outside Fase 1; avoid broad loading of `src/` until a specific family requires it.
- recommended_phase: Fase 3 NB caution; Fase 6 ZIP/ZINB/hurdle/GLMM planning.
- retrieval_priority: `PRIORITY_HIGH`
- clone_status: `CLONED`
- license_note: `glmmTMB/DESCRIPTION` inspected; indicates AGPL-3.

---

## 4. PRIORITY_OPTIONAL: Not Cloned

| repo_name | likely_source | package_type | why_relevant | recommended_phase | retrieval_priority | clone_status | license_note |
|---|---|---|---|---|---|---|---|
| `ppmlhdfe` | Sergio Correia ecosystem | Stata Poisson/HDFE estimation | Poisson postestimation around exposure/offset and large models | Fase 3/5 | `PRIORITY_OPTIONAL` | `NOT_CLONED` | `NOT_INSPECTED` |
| `ivreghdfe` | Sergio Correia ecosystem | Stata estimation wrapper | Package architecture and postestimation wrapper patterns | Fase 7 | `PRIORITY_OPTIONAL` | `NOT_CLONED` | `NOT_INSPECTED` |
| `grstyle` | Ben Jann Stata graph ecosystem | Stata graphics | Diagnostic graph style reference | Fase 4 | `PRIORITY_OPTIONAL` | `NOT_CLONED` | `NOT_INSPECTED` |
| `palettes` | Ben Jann Stata graph ecosystem | Stata graphics | QQ/worm/histogram plot aesthetics | Fase 4 | `PRIORITY_OPTIONAL` | `NOT_CLONED` | `NOT_INSPECTED` |
| `egenmore` | Stata utilities | SSC utility package | Historical SSC packaging style | Fase 7 | `PRIORITY_OPTIONAL` | `NOT_CLONED` | `NOT_INSPECTED` |
| `pscl` | CRAN/GitHub mirror | R count models | ZIP/hurdle benchmark reference | Fase 6 | `PRIORITY_OPTIONAL` | `NOT_CLONED` | `NOT_INSPECTED` |
| `MASS` | R recommended package source | R statistical modeling | `glm.nb` benchmark for NB2 | Fase 3 | `PRIORITY_OPTIONAL` | `NOT_CLONED` | `NOT_INSPECTED` |
| `distributions3` | R package | R distribution abstraction | CDF/quantile abstraction for probabilistic models | Fase 6 | `PRIORITY_OPTIONAL` | `NOT_CLONED` | `NOT_INSPECTED` |

---

## 5. FUTURE_PHASES: Not Cloned

| repo_name | package_type | why_relevant | phase_gate | retrieval_priority | clone_status | license_note |
|---|---|---|---|---|---|---|
| `tweedie` | R Tweedie distribution/model package | Tweedie CDF and benchmarks | Only after Tweedie `EVIDENCIA PENDIENTE` is resolved | `FUTURE_PHASES` | `NOT_CLONED` | `NOT_INSPECTED` |
| `cplm` | R compound Poisson linear models | Tweedie/compound Poisson alternatives | Fase 6 only | `FUTURE_PHASES` | `NOT_CLONED` | `NOT_INSPECTED` |
| `COMPoissonReg` | R COM-Poisson package | COM-Poisson benchmark | Only after CDF strategy is documented | `FUTURE_PHASES` | `NOT_CLONED` | `NOT_INSPECTED` |
| `lme4` | R GLMM package | GLMM simulation diagnostics and NB mixed models | Fase 6 mixed-model plan | `FUTURE_PHASES` | `NOT_CLONED` | `NOT_INSPECTED` |
| `brms` | R Bayesian modeling | Bayesian residual diagnostics | Future Bayesian phase only | `FUTURE_PHASES` | `NOT_CLONED` | `NOT_INSPECTED` |
| `bamlss` | R Bayesian additive distributional models | Distributional regression diagnostics | Future distributional/Bayesian phase only | `FUTURE_PHASES` | `NOT_CLONED` | `NOT_INSPECTED` |
| `betareg` | R beta regression package | Continuous bounded outcomes and quantile residuals | Not Fase 1 unless beta family is added | `FUTURE_PHASES` | `NOT_CLONED` | `NOT_INSPECTED` |
| `countreg` | R-Forge count models | Count diagnostic ecosystem and rootograms | Retrieve only if topmodels/countreg integration becomes active | `FUTURE_PHASES` | `NOT_CLONED` | `NOT_INSPECTED` |
