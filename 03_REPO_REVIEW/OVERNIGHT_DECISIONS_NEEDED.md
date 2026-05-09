Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before Phase 1B implementation

# OVERNIGHT_DECISIONS_NEEDED.md

Fecha: 2026-05-10

## 1. Decision De Parada

La decision de API Phase 1B queda resuelta por instruccion humana posterior: usar la API oficial completa de `09`, incluyendo `savev()` y `family()`.

## 2. Bloqueo Phase 1B

| decision_id | severity | topic | issue | recommended_action |
|---|---|---|---|---|
| OVERNIGHT_API_01 | RESOLVED | API base Phase 1B | El prompt nocturno parcial quedo subordinado a `09`. | Implementar la API oficial completa: `seed()`, `uvar()`, `savev()`, `saveflo()`, `savefhi()`, `saveu()`, `family()`. |

Current status: implemented and tested in the overnight Phase 1B/1C cycle.

## 3. Diferidos No Bloqueantes Para Phase 0/1A

| topic | status | rule |
|---|---|---|
| NB estable | `RESEARCH_GATE_REQUIRED` | requiere `alpha/theta/k`, NB1/NB2, CDF exacta y 3 benchmarks |
| weights | `RESEARCH_GATE_REQUIRED` | requiere regla por familia/tipo de peso y 3 benchmarks por combinacion activada |
| Gamma | `RESOLVED_FOR_UNWEIGHTED_GLM_GAMMA` | implemented with 3-dataset Stata/R benchmark |
| ZIP/ZINB/hurdle/truncados | `DEFER_PHASE2` | no tocar |
| mixed/GLMM/GSEM | `DEFER_PHASE2` | no tocar |

## 4. Decisiones Pendientes

| decision_id | status | note |
|---|---|---|
| NB_PARAM_01 | `HUMAN_DECISION_REQUIRED_AFTER_RESEARCH` | decide exact supported NB parametrization only after benchmark note |
| WEIGHTS_SEMANTICS_01 | `HUMAN_DECISION_REQUIRED_AFTER_RESEARCH` | decide family x weight-type support matrix |
| RELEASE_01 | `HUMAN_DECISION_REQUIRED` | decide whether Phase 1C local state is enough for a pre-release tag |

## 5. Prompt Recomendado Para Continuar

```text
Actua como release auditor Stata/Mata. Revisa el checkpoint Phase 1C de qresid: API oficial, Gaussian, Poisson, Bernoulli y Gamma unweighted. Ejecuta tests/certification y benchmarks R/Stata, revisa help/pkg/toc/README, y decide si crear tag pre-release o pedir ajustes antes de release.
```

Post-change documentation sync: `POST_CHANGE_SYNC_DONE`
