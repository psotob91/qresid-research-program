Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load after overnight run

# OVERNIGHT_CHANGE_LOG.md

Fecha: 2026-05-10

## 1. Cambios Aplicados

| file | change_type | classification |
|---|---|---|
| `qresid/qresid.ado` | refactor API/core and family dispatcher | `PHASE1_IMPLEMENTATION` |
| `qresid/qresid.sthlp` | replace stale public help | `PHASE1_DOCS` |
| `qresid/README.md` | update tested support and syntax | `PHASE1_DOCS` |
| `qresid/qresid.pkg` | update package metadata | `PHASE1_DOCS` |
| `qresid/stata.toc` | update package table of contents metadata | `PHASE1_DOCS` |
| `qresid/tests/run_all_tests.do` | expand API/core/family tests | `PHASE1_TESTS` |
| `qresid/tests/benchmark_gamma_stata.do` | add Gamma Stata benchmark producer | `PHASE1_TESTS` |
| `qresid/tests/benchmark_gamma_r.R` | add Gamma R benchmark checker | `PHASE1_TESTS` |
| `qresid/certification/certify_phase1.do` | update development gate status | `PHASE0_STRUCTURE` |
| `qresid/changelog/CHANGELOG.md` | record Phase 1B/1C work | `PHASE1_DOCS` |

## 2. Cambios De Implementacion

- Implemented official API options:
  `seed()`, `uvar()`, `savev()`, `saveflo()`, `savefhi()`, `saveu()`,
  `family()`.
- Added `program qresid, rclass`.
- Added `marksample, novarlist` and `e(sample)` filtering.
- Added controlled error gate for weighted estimation.
- Added controlled error gate for NB and grouped binomial.
- Added PIT endpoint validation and clipping before `invnormal()`.
- Added Gaussian, Poisson, Bernoulli and Gamma unweighted paths.

## 3. Cambios No Aplicados

| area | reason |
|---|---|
| NB stable support | parametrization/CDF/R benchmark gate still open |
| weights | family x weight-type semantics gate still open |
| grouped binomial | trials semantics gate still open |
| ZIP/ZINB/hurdle/truncados/mixed | deferred Phase 2+ |

## 4. Git Notes

Recommended checkpoint names:

- `checkpoint-phase1c-core-gamma` for `qresid/`.
- root checkpoint with updated gitlink and reports.

Post-change documentation sync: `POST_CHANGE_SYNC_DONE`
