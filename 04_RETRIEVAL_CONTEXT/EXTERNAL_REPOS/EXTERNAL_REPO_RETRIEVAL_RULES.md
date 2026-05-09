# EXTERNAL_REPO_RETRIEVAL_RULES.md

## 0. Purpose

Operational rules for using `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/` as a curated retrieval layer for `qresid`.

This layer exists to inform architecture, testing, benchmarking, documentation, and audit decisions. It is not part of the `qresid` package and must be treated as read-only context.

---

## 1. Hard Rules

- Do not modify `qresid/` based only on external repository inspection.
- Do not copy code from external repositories into `qresid/`.
- Do not assume license compatibility.
- Do not load complete repositories into context.
- Do not load binary assets, compiled libraries, generated docs, large datasets, benchmark outputs, logs, images, or PDFs automatically.
- Do not use external package behavior as evidence for `qresid` support unless it is mapped in a project document and verified by tests.
- If a repo, file, distribution, command, CDF, or parameterization is ambiguous, mark it as `EVIDENCIA PENDIENTE`.
- If an external source contradicts project masters, stop and report the conflict; do not silently prefer the external source.

---

## 2. Directory Structure

```text
04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/
  EXTERNAL_REPO_MANIFEST.md
  EXTERNAL_REPO_RETRIEVAL_RULES.md
  EXTERNAL_REPO_NOTES.md
  STATA/
    reghdfe/
    ftools/
    gtools/
    boottest/
    binsreg/
    coefplot/
    estout/
    moremata/
  R/
    statmod/
    DHARMa/
    VGAM/
    gamlss/
    glmmTMB/
    topmodels/   # pending; do not substitute non-canonical GitHub repos
```

---

## 3. Project Files To Read First

Before any external repo inspection, read the local governance documents required by the active task:

1. `AGENTS.md`
2. `04_RETRIEVAL_CONTEXT/RETRIEVAL_MAP_FOR_QRESID.md`
3. `02_IMPLEMENTATION_MASTERS/10_AGENT_RULES_FOR_QRESID.md`
4. `02_IMPLEMENTATION_MASTERS/09_STATA_PACKAGE_ARCHITECTURE_MASTER.md` if architecture, API, dispatcher, outputs, or returned results are involved
5. `04_RETRIEVAL_CONTEXT/STATA_PACKAGE_STYLE_RULES.md` for package style or public documentation
6. `04_RETRIEVAL_CONTEXT/STATA_R_BENCHMARK_MAPPING.md` for R-Stata comparisons
7. `04_RETRIEVAL_CONTEXT/STATA_TESTING_CERTIFICATION_RULES.md` for tests and certification

For implementation later, also load only the family/model extraction files required by `RETRIEVAL_MAP_FOR_QRESID.md`.

---

## 4. Files To Read First Inside External Repos

### 4.1 Stata Repositories

Read in this order:

1. `README.md` or `Readme.md`
2. `*.pkg`
3. `stata.toc`
4. main `*.ado`
5. main `*.sthlp` or `*.hlp`
6. main `*.mata`
7. specific `test/*.do` or `tests/*.do`
8. benchmark scripts only if the task is explicitly about benchmarking

Preferred files by purpose:

| Purpose | Read First |
|---|---|
| SSC-style package surface | `coefplot/*.pkg`, `coefplot/stata.toc`, `estout/*.pkg`, `binsreg/stata/*.pkg` |
| Postestimation checks | `boottest/boottest.ado`, `estout/estadd.ado`, `estout/estpost.ado` |
| ado/Mata boundary | `boottest/boottest.ado`, `boottest/boottest.mata`, `ftools/src/ftools.ado`, `ftools/src/ftools.mata` |
| Mata API design | `moremata/source/`, `ftools/src/*.mata` |
| Tests/certification | `boottest/test/unit tests.do`, `ftools/test/test_all.do`, `gtools/build/gtools_tests.do` |
| Graph command style | `coefplot/coefplot.ado`, `coefplot/coefplot.sthlp` |
| R-Stata multi-language packaging | `binsreg/README.md`, `binsreg/stata/`, `binsreg/R/` |

### 4.2 R Repositories

Read in this order:

1. `DESCRIPTION`
2. `NAMESPACE`
3. specific `R/*.R` file listed in the manifest
4. specific `tests/testthat/*.R` file listed in the manifest
5. specific `src/*` file only if the CDF or distribution implementation requires it
6. man pages or vignettes only after source files identify the relevant function

Preferred files by purpose:

| Purpose | Read First |
|---|---|
| Analytic R benchmark for GLM families | `statmod/DESCRIPTION`, `statmod/R/`, `statmod/tests/` |
| Simulation residual architecture | `DHARMa/DHARMa/R/simulateResiduals.R`, `DHARMa/DHARMa/R/transformQuantiles.R`, `DHARMa/DHARMa/R/random.R` |
| Diagnostic tests | `DHARMa/DHARMa/R/tests.R`, `DHARMa/DHARMa/tests/testthat/testTests.R` |
| Randomized quantile residuals | `gamlss/R/rqres.R`, `gamlss/R/rqresplot_new.R`, `gamlss/R/wp.R` |
| Worm plots | `gamlss/R/wp.R`, `gamlss/R/rqresplot_new.R` |
| NB/ZI/future families | `VGAM/R/`, `glmmTMB/glmmTMB/R/family.R`, `glmmTMB/glmmTMB/src/distrib.h` |
| Prediction-layer mapping | `glmmTMB/glmmTMB/R/predict.R`, `glmmTMB/glmmTMB/R/methods.R` |

---

## 5. Paths To Ignore By Default

Ignore these unless a task explicitly requires a named file:

- `.git/`
- `.github/`
- `.Rproj.user/`
- generated websites and generated docs
- `docs/` when it is a generated website
- `build/` generated artifacts, except selected Stata package files listed in the manifest
- `lib/`
- `revdep/`
- `inst/doc/`
- `inst/vignette_data/`
- `inst/test_data/` unless a test requires a named file
- `Publications/`
- `Code/DHARMaIssues/`
- `Code/DHARMaTeaching/`
- `man/` until source files identify the exact topic
- `*.mlib`
- `*.dll`
- `*.exe`
- `*.o`
- `*.so`
- `*.dylib`
- `*.rda`
- `*.RData`
- `*.dta`
- `*.csv` unless a benchmark task names the file
- `*.pdf`
- `*.png`
- `*.jpg`
- `*.jpeg`
- `*.gif`
- `*.log`
- `*.zip`
- `*.tar.gz`

Repository-specific cautions:

- `gtools/lib/`: compiled/plugin material; do not load automatically.
- `gtools/build/`: generated package surface; read selected `.ado`, `.sthlp`, `.pkg`, `stata.toc`, and tests only.
- `boottest/*.mlib`: compiled Mata library; do not treat as source.
- `moremata/lmoremata*.mlib`: packaging artifact; source is under `source/`.
- `DHARMa/Code/DHARMaIssues/`: issue reproductions; do not load unless auditing a matching issue.
- `DHARMa/Code/DHARMaData/raw-data/`: raw data; do not load automatically.
- `glmmTMB/models.rda`: data object; do not load automatically.
- `glmmTMB/glmmTMB/src/`: do not broad-load; open only named files such as `distrib.h`.
- `VGAM/R/`: large family surface; inspect only files matching the active family.

---

## 6. Automatic Retrieval Limits

When an agent needs external context, use this budget:

- First pass: manifest entry plus at most 3 source files.
- Second pass: at most 3 more files if a concrete symbol, option, family, or test requires it.
- Never load more than one large R package subtree in a single pass.
- Never load all help/man pages; open only the page for the active command or function.
- Never load all tests; open only tests matching the active family or behavior.
- Never use external repo context as a reason to skip project-local tests.

---

## 7. How To Use These Repos For Future Audit

### 7.1 Architecture Audit

Use Stata repositories to compare package shape only:

- thin public ado wrapper;
- clean separation of parsing, postestimation checks, and Mata routines;
- package files limited to installable public artifacts;
- small, reproducible examples;
- unsupported families rejected with clear Stata errors.

Primary retrieval:

- `boottest/boottest.ado`
- `boottest/boottest.mata`
- `ftools/src/ftools.ado`
- `ftools/src/ftools.mata`
- `coefplot/coefplot.pkg`
- `estout/estout.pkg`
- `binsreg/stata/binsreg.pkg`

### 7.2 CDF/PIT Benchmark Audit

Use R repositories only after `STATA_R_BENCHMARK_MAPPING.md` identifies the family/model.

Audit order:

1. Confirm identical data, formula, sample, weights, offset/exposure.
2. Compare coefficients, `xb`, fitted mean/probability/trials.
3. Compare family parameters.
4. Compare `F(y-)` and `F(y)`.
5. Compare final residuals only with shared external uniforms via `uvar()`.

Primary retrieval:

- `statmod/R/`
- `VGAM/R/`
- `gamlss/R/rqres.R`
- `glmmTMB/glmmTMB/R/family.R`
- `glmmTMB/glmmTMB/R/predict.R`

### 7.3 Simulation-Diagnostic Audit

Use only after Fase 1 analytic residuals are stable.

Primary retrieval:

- `DHARMa/DHARMa/R/simulateResiduals.R`
- `DHARMa/DHARMa/R/transformQuantiles.R`
- `DHARMa/DHARMa/R/random.R`
- `DHARMa/DHARMa/R/tests.R`
- `DHARMa/DHARMa/tests/testthat/testNumericReproducibility.R`

Audit questions:

- What is simulated: response, residual, rank, PIT, or quantile?
- Is conditioning marginal or conditional?
- How is RNG isolated and tested?
- Are tests pointwise, distributional, or visual?
- Does the diagnostic require model classes outside Fase 1?

### 7.4 Certification Script Audit

Use external test scripts only as style references.

Primary retrieval:

- `boottest/test/unit tests.do`
- `ftools/test/test_all.do`
- `ftools/test/test_mata.do`
- `gtools/build/gtools_tests.do`
- `DHARMa/DHARMa/tests/testthat/testNumericReproducibility.R`
- `DHARMa/DHARMa/tests/testthat/testSimulateResiduals.R`

Check for:

- session-clean master scripts;
- explicit assertions;
- seed control;
- separation of generated outputs from source;
- family-specific tests rather than one monolithic smoke test.

---

## 8. What These Repos Are Not Evidence For

External repository presence alone does not establish:

- Stata support for a model family;
- a validated CDF endpoint implementation;
- compatibility of R and Stata parameterizations;
- permission to reuse code;
- correctness of `qresid`;
- SSC/Stata Journal readiness.

Every support claim still requires:

- project-local rule file alignment;
- mathematical definition;
- Stata extraction rule;
- CDF endpoint test;
- R benchmark with `uvar()` when applicable;
- certification script.
