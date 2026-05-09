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

## 3. Diferidos No Bloqueantes Para Phase 0/1A

| topic | status | rule |
|---|---|---|
| NB estable | `RESEARCH_GATE_REQUIRED` | requiere `alpha/theta/k`, NB1/NB2, CDF exacta y 3 benchmarks |
| weights | `RESEARCH_GATE_REQUIRED` | requiere regla por familia/tipo de peso y 3 benchmarks por combinacion activada |
| Gamma | `RESEARCH_GATE_REQUIRED` | Fase 1 aprobada; requiere parametrizacion y 3 benchmarks antes de claim estable |
| ZIP/ZINB/hurdle/truncados | `DEFER_PHASE2` | no tocar |
| mixed/GLMM/GSEM | `DEFER_PHASE2` | no tocar |

## 4. Prompt Recomendado Para Continuar

```text
Actua como maintainer Stata/Mata. Con Phase 0/1A ya ejecutadas, implementa Phase 1B usando la API oficial completa de 09: seed(), uvar(), savev(), saveflo(), savefhi(), saveu(), family(). No implementes NB, pesos ni Gamma hasta completar sus research gates y 3 benchmarks. Ejecuta la suite local y actualiza docs.
```

Post-change documentation sync: `POST_CHANGE_SYNC_DONE`
