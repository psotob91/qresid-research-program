# EXTERNAL_REPO_NOTES.md

## 0. Retrieval Summary

Retrieval date: 2026-05-10

Workspace root: `C:/qresid-research-program`

Current tree:

```text
04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/
  EXTERNAL_REPO_MANIFEST.md
  EXTERNAL_REPO_RETRIEVAL_RULES.md
  EXTERNAL_REPO_NOTES.md
  STATA/
    binsreg/
    boottest/
    coefplot/
    estout/
    ftools/
    gtools/
    moremata/
    reghdfe/
  R/
    DHARMa/
    VGAM/
    gamlss/
    glmmTMB/
    statmod/
```

`qresid/` was not modified by this curation pass.

---

## 1. Repositories Downloaded

### 1.1 Stata

| repo_name | clone_status | local_path | approximate_size | file_count | license_note |
|---|---|---|---:|---:|---|
| `binsreg` | `CLONED` | `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/STATA/binsreg` | 5.87 MB | 261 | `LICENSE.md` indicates GPL-3.0 |
| `boottest` | `CLONED` | `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/STATA/boottest` | 24.43 MB | 54 | `NOT_FOUND_IN_CLONE` |
| `coefplot` | `CLONED` | `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/STATA/coefplot` | 0.28 MB | 40 | `LICENSE` indicates MIT |
| `estout` | `CLONED` | `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/STATA/estout` | 0.85 MB | 51 | `LICENSE` indicates MIT |
| `ftools` | `CLONED` | `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/STATA/ftools` | 1.07 MB | 142 | `LICENSE` indicates MIT |
| `gtools` | `CLONED` | `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/STATA/gtools` | 31.80 MB | 461 | `LICENSE` indicates MIT |
| `moremata` | `CLONED` | `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/STATA/moremata` | 3.25 MB | 208 | `LICENSE` indicates MIT |
| `reghdfe` | `CLONED` | `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/STATA/reghdfe` | 5.58 MB | 278 | `LICENSE` indicates MIT |

Approximate Stata retrieval size: 73.13 MB.

### 1.2 R

| repo_name | clone_status | local_path | approximate_size | file_count | license_note |
|---|---|---|---:|---:|---|
| `DHARMa` | `CLONED` | `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/R/DHARMa` | 9.51 MB | 339 | `DHARMa/DESCRIPTION` indicates GPL (>= 3) |
| `VGAM` | `CLONED` | `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/R/VGAM` | 9.49 MB | 768 | `DESCRIPTION` indicates GPL-3; `LICENCE.note` has copyright notes |
| `gamlss` | `CLONED` | `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/R/gamlss` | 1.67 MB | 198 | `DESCRIPTION` indicates GPL-2 or GPL-3 |
| `glmmTMB` | `CLONED` | `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/R/glmmTMB` | 130.75 MB | 470 | `glmmTMB/DESCRIPTION` indicates AGPL-3 |
| `statmod` | `CLONED` | `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/R/statmod` | 0.40 MB | 98 | `DESCRIPTION` indicates GPL-2 or GPL-3 |

Approximate R retrieval size: 151.82 MB.

Approximate total retrieval size: 224.95 MB.

---

## 2. Repositories Pending Or Failed

### topmodels

- intended_priority: `PRIORITY_HIGH`
- intended_local_path: `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/R/topmodels`
- attempted_git_urls:
  - `https://github.com/zeileis/topmodels.git`
  - `https://github.com/topmodels/topmodels.git`
- clone_status: `PENDING_SOURCE_TOOLING`
- failure_detail: GitHub returned repository not found for both attempted URLs.
- follow-up finding: Current public material indicates R-Forge/SVN source rather than canonical GitHub source.
- blocker: local `svn` command is not available.
- license_note: `NOT_INSPECTED`; source not retrieved.
- recommended_next_retrieval:
  - Install or expose SVN tooling.
  - Retrieve only package source from a verified R-Forge/SVN path.
  - Do not substitute unrelated `topmodel` or non-canonical GitHub repositories.

---

## 3. Priority Classification Snapshot

### PRIORITY_HIGH, cloned

- `reghdfe`
- `ftools`
- `gtools`
- `boottest`
- `binsreg`
- `coefplot`
- `estout`
- `moremata`
- `statmod`
- `DHARMa`
- `VGAM`
- `gamlss`
- `glmmTMB`

### PRIORITY_HIGH, pending

- `topmodels`

### PRIORITY_OPTIONAL, not cloned

- `ppmlhdfe`
- `ivreghdfe`
- `grstyle`
- `palettes`
- `egenmore`
- `pscl`
- `MASS`
- `distributions3`

### FUTURE_PHASES, not cloned

- `tweedie`
- `cplm`
- `COMPoissonReg`
- `lme4`
- `brms`
- `bamlss`
- `betareg`
- `countreg`

---

## 4. Main Risks

### 4.1 Licensing

License evidence was inspected only at file/metadata level. This does not certify compatibility for reuse.

Rule: read external code for architecture and benchmark understanding only. Do not copy implementation into `qresid`.

### 4.2 Parameterization Drift

R packages and Stata commands may parameterize the same family differently.

High-risk areas:

- NB1 vs NB2.
- `alpha` vs `theta` for negative binomial models.
- Gamma shape/scale/rate.
- Binomial trials and grouped outcomes.
- Zero-inflated probability component.
- Truncation and hurdle normalization.
- Conditional vs marginal GLMM residuals.

### 4.3 Context Overload

Some repos are broad and should not be loaded recursively.

High-risk repos:

- `glmmTMB`: largest clone; read only specific family/predict/test files.
- `VGAM`: many families; inspect only the family under audit.
- `gtools`: contains source, build, docs, plugin/library material.
- `DHARMa`: contains package source plus exploratory issue scripts.

### 4.4 Scope Creep

The presence of `DHARMa`, `VGAM`, `gamlss`, and `glmmTMB` does not move `qresid` Fase 1 into simulation diagnostics, zero inflation, hurdle models, COM-Poisson, Tweedie, GLMMs, or GSEM.

Fase 1 remains governed by project-local masters:

- Gaussian.
- Poisson.
- Binomial/Bernoulli.
- Negative binomial with documented parameterization.
- Gamma only with its explicit gate.
- R benchmarks by layers.

### 4.5 Binary, Generated, And Data Material

The retrieval includes compiled/generated/data artifacts already present in upstream repositories.

Do not load automatically:

- `.mlib`
- `lib/`
- `.rda`
- `.RData`
- `.dta`
- `.csv` unless a named benchmark requires it
- logs
- generated docs
- images
- binary assets

---

## 5. What Codex Should Read Before Modifying `qresid`

Before any future code changes, read project-local files first:

1. `AGENTS.md`
2. `04_RETRIEVAL_CONTEXT/RETRIEVAL_MAP_FOR_QRESID.md`
3. `02_IMPLEMENTATION_MASTERS/10_AGENT_RULES_FOR_QRESID.md`
4. `02_IMPLEMENTATION_MASTERS/09_STATA_PACKAGE_ARCHITECTURE_MASTER.md`
5. `04_RETRIEVAL_CONTEXT/STATA_MINIMAL_PROGRAMMING_NOTES.md`
6. `04_RETRIEVAL_CONTEXT/STATA_MODEL_EXTRACTION_RULES.md` if touching `e()`, `predict`, sample restrictions, offsets, exposure, or weights
7. The family-specific file:
   - `04_RETRIEVAL_CONTEXT/GLM_POSTESTIMATION_RULES.md`
   - `04_RETRIEVAL_CONTEXT/COUNT_MODELS_EXTRACTION_RULES.md`
   - `04_RETRIEVAL_CONTEXT/MIXED_MODELS_EXTRACTION_RULES.md` only for mixed/panel/GSEM tasks
8. `04_RETRIEVAL_CONTEXT/STATA_NUMERICAL_STABILITY_RULES.md` if touching CDF, PIT, clipping, RNG, or `invnormal()`
9. `04_RETRIEVAL_CONTEXT/STATA_R_BENCHMARK_MAPPING.md` before R-Stata comparisons
10. `04_RETRIEVAL_CONTEXT/STATA_TESTING_CERTIFICATION_RULES.md` before tests/certification
11. `04_RETRIEVAL_CONTEXT/STATA_PACKAGE_STYLE_RULES.md` before public API/help/pkg/release work

Then, and only then, use external repos narrowly:

- Package architecture: `boottest`, `ftools`, `coefplot`, `estout`.
- Mata organization: `ftools`, `moremata`, `boottest`.
- SSC metadata: `coefplot`, `estout`, `binsreg`, `boottest`.
- Tests/certification style: `boottest/test`, `ftools/test`, `gtools/build/gtools_tests.do`.
- R benchmark mapping: `statmod`, `VGAM`, `gamlss`, `glmmTMB`.
- Simulation diagnostics: `DHARMa`, after analytic Fase 1 is stable.

---

## 6. Recommended Next Steps Before MCP

1. Treat `EXTERNAL_REPOS/` as read-only retrieval context.
2. Add the three external repo manifest/rule/notes files to the MCP seed set.
3. Add explicit deny patterns for `.git/`, binaries, logs, datasets, generated docs, images, PDFs, and large R package subtrees.
4. Index only selected Stata package files and selected R benchmark/residual files.
5. Keep `qresid/` excluded from automatic writes during retrieval/indexing.
6. Retrieve `topmodels` later only through verified R-Forge/SVN source when SVN tooling is available.
7. Before implementation, create a project-local design note mapping selected external patterns to `qresid` decisions without copying external code.
