Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before qresid implementation

# QRESID_IMPLEMENTATION_CHANGE_QUEUE.md

Fecha: 2026-05-10

## 1. Proposito

Cola de cambios propuesta antes de modificar `qresid/`. Esta cola no autoriza implementacion por si sola; cada cambio requiere plan, tests y sincronizacion documental.

## 2. Cola Priorizada

| change_id | priority | phase_class | area | problem | required_action | docs_to_read | tests_required | blocks | code_allowed_now |
|---|---|---|---|---|---|---|---|---|---|
| QIC-001 | P0 | COMPLETED_PHASE1B | API | API antigua reemplazada | API oficial implementada; no `generate()`, no `replace` | `09`, `10`, `STATA_PACKAGE_STYLE_RULES.md` | parser tests, help examples, variable collision tests | none for local Phase 1C | no |
| QIC-002 | P0 | COMPLETED_PHASE1B | sample | `marksample`/`e(sample)` aplicado | usa `marksample, novarlist` + `e(sample)` | `10`, `STATA_MODEL_EXTRACTION_RULES.md`, testing rules | sample restriction tests | none for local Phase 1C | no |
| QIC-003 | P0 | COMPLETED_PHASE1B | RNG | `seed()` y `uvar()` implementados | mantener benchmarks exactos con `uvar()` | `09`, `10`, benchmark mapping, numerical rules | deterministic seed tests, shared `uvar()` R-Stata tests | broader R benchmarks | no |
| QIC-004 | P0 | COMPLETED_PHASE1B | CDF/PIT | endpoints y clipping implementados | mantener pruebas por familia | numerical rules, `07`, `09` | endpoint, clipping and boundary tests | broader R benchmarks | no |
| QIC-005 | P0 | PARTIAL_COMPLETED_PHASE1C | Bernoulli/binomial | Bernoulli `logit/logistic` corregido; grouped binomial sigue gated | mantener grouped binomial fuera hasta trials gate | GLM rules, model extraction rules, `09` | Bernoulli support tests; grouped binomial future tests | grouped binomial only | no |
| QIC-006 | P1 | RESEARCH_GATE_REQUIRED | NB | parametrizacion `alpha/theta/k`, NB1/NB2 y CDF no cerradas | investigar manuales/ado Stata, R source y pasar 3 benchmarks antes de soporte estable; si no cierra, error controlado | `QRESID_NB_TECHNICAL_RESEARCH_PLAN.md`, external research queue, count extraction rules | parametrization benchmark before activation; 3 datasets | NB stable support | no |
| QIC-007 | P1 | COMPLETED_PHASE1C_UNWEIGHTED | Gamma | Gamma Fase 1 implementada unweighted | mantener weights-gate; use Gamma benchmark notes | `09`, GLM rules, benchmark mapping | Stata/R Gamma CDF benchmark, support tests | weighted Gamma only | no |
| QIC-008 | P1 | COMPLETED_PHASE1B | outputs | outputs auditables implementados | mantener collision tests | `09`, `10`, style rules | output naming/collision tests | none for local Phase 1C | no |
| QIC-009 | P1 | COMPLETED_PHASE1B | returned results | `rclass`/`return` implementado | expand returned-result tests before release | `09`, `10` | returned-results tests | release hardening | no |
| QIC-010 | P1 | PARTIAL_COMPLETED_PHASE1B | errors | controlled errors added for key gates | broaden unsupported-command tests | style rules, `10` | unsupported command tests | release hardening | no |
| QIC-011 | P1 | COMPLETED_PHASE1C_LOCAL | tests | suite local activa | broaden R/Stata benchmarks before release | testing rules, benchmark mapping, MCP protocols, `QRESID_TEST_PLAN_BEFORE_CODE_CHANGES.md` | unit + integration smoke tests | release hardening | no |
| QIC-012 | P1 | COMPLETED_PHASE1C_LOCAL | certification | certification development gate active | not public release certification | certification rules, MCP protocols | certification run log | release readiness | no |
| QIC-013 | P2 | COMPLETED_MINIMAL_PHASE1D | help/docs | help/README updated for implemented support | audit before release | style rules, `09`, `10` | help examples execute | release hardening | no |
| QIC-014 | P2 | COMPLETED_MINIMAL_PHASE1D | packaging | version/package metadata updated to 0.1.0 | audit before release | style rules, version lock | package install smoke | release | no |
| QIC-015 | P2 | RESEARCH_GATE_REQUIRED | weights | semantica de pesos no cerrada | investigar Stata `e(wtype)`/`e(wexp)`, R/statmod y matriz familia x tipo de peso; no usar `sqrt(w_i)` global | `QRESID_WEIGHTS_TECHNICAL_RESEARCH_PLAN.md`, weights evidence review, benchmark mapping | family x weight-type tests; 3 datasets por combinacion activada | weighted support | no |

## 3. Secuencia Recomendada

1. Phase 0/1A ejecutada.
2. Phase 1B ejecutada: API oficial, muestra, RNG, endpoints, outputs y returned results.
3. Phase 1C ejecutada localmente: Gaussian, Poisson, Bernoulli y Gamma unweighted.
4. Mantener NB y pesos con error controlado hasta cerrar investigacion.
5. Ejecutar auditoria release/hardening antes de tag publico.

Investigacion extendida aprobada:

- Gamma: implementado para unweighted `glm, family(gamma)` con `QRESID_GAMMA_TECHNICAL_RESEARCH_NOTES.md` y 3 benchmarks.
- NB: pasa a `RESEARCH_GATE_REQUIRED`; no estable sin parametrizacion cerrada.
- Weights: pasa a `RESEARCH_GATE_REQUIRED`; no soporte ponderado global.

## 4. Estado Overnight 2026-05-10

| change_id | overnight_status | evidence |
|---|---|---|
| QIC-001 | completed | API tests pass |
| QIC-002 | completed | `P1B-SAMPLE-001` pass |
| QIC-003 | completed | `P1B-API-001`, `P1B-RNG-001` pass |
| QIC-004 | completed | `P1B-PIT-001` pass |
| QIC-007 | completed unweighted | Gamma Stata/R 3-dataset benchmark pass |
| QIC-009 | completed | `P1B-RETURN-001` pass |
| QIC-011 | completed local | runner `PASS`, unexpected failures = 0 |
| QIC-012 | completed local | `PASS_PHASE1C_NOT_RELEASE` |

## 5. Reglas De Entrada Para Cualquier Cambio

- Leer `AGENTS.md`, `09`, `10`, retrieval map y esta cola.
- No modificar codigo sin tests asociados.
- No copiar codigo externo.
- No declarar `READY` sin ejecucion real.
- Ejecutar post-change documentation sync al cierre.

Post-change documentation sync: `POST_CHANGE_SYNC_DONE`
