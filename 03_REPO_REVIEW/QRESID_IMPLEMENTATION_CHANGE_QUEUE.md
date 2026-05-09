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
| QIC-001 | P0 | MUST_FIX_BEFORE_PHASE1 | API | `qresid.ado` usa API antigua `standardized`/`nqres()` | reemplazar parser por API Fase 1 final: `newvarname`, `seed()`, `uvar()`, `savev()`, `saveflo()`, `savefhi()`, `saveu()`, `family()` | `09`, `10`, `STATA_PACKAGE_STYLE_RULES.md` | parser tests, help examples, variable collision tests | all implementation | no |
| QIC-002 | P0 | MUST_FIX_BEFORE_PHASE1 | sample | falta `marksample` y uso obligatorio de `e(sample)` | aplicar muestra estimada + `if/in`; excluir missings de forma auditable | `10`, `STATA_MODEL_EXTRACTION_RULES.md`, testing rules | sample restriction tests, missing tests | valid residuals | no |
| QIC-003 | P0 | MUST_FIX_BEFORE_PHASE1 | RNG | no hay `seed()` ni `uvar()` | implementar RNG reproducible y uniformes externos para discretas | `09`, `10`, benchmark mapping, numerical rules | deterministic seed tests, shared `uvar()` R-Stata tests | exact discrete benchmark | no |
| QIC-004 | P0 | MUST_FIX_BEFORE_PHASE1 | CDF/PIT | falta validacion endpoints y clipping | generar/guardar `F_low`, `F_high`, `U`; validar orden y clipping antes de `invnormal()` | numerical rules, `07`, `09` | endpoint, clipping and boundary tests | all RQR correctness | no |
| QIC-005 | P0 | MUST_FIX_BEFORE_PHASE1 | Bernoulli/binomial | ramas `logit/logistic` parecen usar fitted mean como outcome | usar depvar observado, ensayos validos y `predict, pr`/`predict, mu` segun comando | GLM rules, model extraction rules, `09` | Bernoulli, binomial trials, support tests | Bernoulli/binomial Fase 1 | no |
| QIC-006 | P1 | RESEARCH_GATE_REQUIRED | NB | parametrizacion `alpha/theta/k`, NB1/NB2 y CDF no cerradas | investigar manuales/ado Stata, R source y pasar 3 benchmarks antes de soporte estable; si no cierra, error controlado | `QRESID_NB_TECHNICAL_RESEARCH_PLAN.md`, external research queue, count extraction rules | parametrization benchmark before activation; 3 datasets | NB stable support | no |
| QIC-007 | P1 | MUST_FIX_BEFORE_PHASE1 | Gamma | Gamma es Fase 1 pero no esta implementada | implementar solo con gate: `y > 0`, `mu > 0`, `phi > 0`, `shape = 1/phi`, `scale = mu*phi` | `09`, GLM rules, benchmark mapping | Stata/R Gamma CDF benchmark, support tests | Gamma Fase 1 | no |
| QIC-008 | P1 | MUST_FIX_BEFORE_PHASE1 | outputs | outputs actuales crean multiples variables por `nqres()` | ajustar a residuo principal y outputs auditables `savev`, `saveflo`, `savefhi`, `saveu` | `09`, `10`, style rules | output naming/collision tests | public API | no |
| QIC-009 | P1 | SHOULD_FIX_BEFORE_PHASE1 | returned results | no hay `rclass`/`return` | devolver familia, comando, muestra, conteos, clipping y flags | `09`, `10` | returned-results tests | auditability | no |
| QIC-010 | P1 | SHOULD_FIX_BEFORE_PHASE1 | errors | errores sin `display as err` ni `exit` | usar errores Stata controlados para modelos fuera de fase y validaciones | style rules, `10` | unsupported command tests | safe failure | no |
| QIC-011 | P1 | MUST_FIX_BEFORE_PHASE1 | tests | tests estan vacios | crear suite minima antes de tocar codigo funcional | testing rules, benchmark mapping, MCP protocols, `QRESID_TEST_PLAN_BEFORE_CODE_CHANGES.md` | unit + integration smoke tests | code changes | no |
| QIC-012 | P1 | SHOULD_FIX_BEFORE_PHASE1 | certification | certificacion vacia | crear certification script reproducible por Fase 1 | certification rules, MCP protocols | certification run log | release readiness | no |
| QIC-013 | P2 | SHOULD_FIX_BEFORE_PHASE1 | help/docs | help/README documentan API antigua y claims amplios | actualizar despues del parser y tests; no prometer familias pendientes | style rules, `09`, `10` | help examples execute | public docs | no |
| QIC-014 | P2 | CAN_DEFER | packaging | version/package metadata antigua | sincronizar version, pkg, toc, changelog al preparar release | style rules, version lock | package install smoke | release | no |
| QIC-015 | P2 | RESEARCH_GATE_REQUIRED | weights | semantica de pesos no cerrada | investigar Stata `e(wtype)`/`e(wexp)`, R/statmod y matriz familia x tipo de peso; no usar `sqrt(w_i)` global | `QRESID_WEIGHTS_TECHNICAL_RESEARCH_PLAN.md`, weights evidence review, benchmark mapping | family x weight-type tests; 3 datasets por combinacion activada | weighted support | no |

## 3. Secuencia Recomendada

1. Phase 0/1A ejecutada: se crearon estructura minima, runner, certification scaffold y expected-failure tests.
2. Crear plan de implementacion para QIC-001 a QIC-004 como refactor base.
3. Implementar Bernoulli/binomial, Poisson, Gaussian y Gamma con benchmarks por capas.
4. Mantener NB y pesos con error controlado o soporte experimental bloqueado hasta cerrar investigacion.
5. Actualizar help/README/changelog solo despues de que los tests pasen.

Investigacion extendida aprobada:

- Gamma: implementar solo despues de `QRESID_GAMMA_TECHNICAL_RESEARCH_PLAN.md` y 3 benchmarks.
- NB: pasa a `RESEARCH_GATE_REQUIRED`; no estable sin parametrizacion cerrada.
- Weights: pasa a `RESEARCH_GATE_REQUIRED`; no soporte ponderado global.

## 4. Estado Overnight 2026-05-10

| change_id | overnight_status | evidence |
|---|---|---|
| QIC-001 | pending Phase 1B | `P0-API-001` expected failure, rc = 198 |
| QIC-002 | pending Phase 1B | no implementation change; sample contract remains future test area |
| QIC-003 | pending Phase 1B | `P0-RNG-001` expected failure, rc = 198 |
| QIC-004 | pending Phase 1B | `P0-PIT-001` expected failure, rc = 198 |
| QIC-009 | pending Phase 1B | `P0-RETURN-001` expected failure, rc = 111 |
| QIC-011 | partially completed | runner created; `PASS_WITH_EXPECTED_FAILURES`, unexpected failures = 0 |
| QIC-012 | scaffold completed | `certify_phase1.do` created; not release certification |

## 5. Reglas De Entrada Para Cualquier Cambio

- Leer `AGENTS.md`, `09`, `10`, retrieval map y esta cola.
- No modificar codigo sin tests asociados.
- No copiar codigo externo.
- No declarar `READY` sin ejecucion real.
- Ejecutar post-change documentation sync al cierre.

Post-change documentation sync: `POST_CHANGE_SYNC_DONE`
