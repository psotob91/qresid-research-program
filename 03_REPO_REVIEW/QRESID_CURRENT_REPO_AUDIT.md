Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before qresid code changes

# QRESID_CURRENT_REPO_AUDIT.md

Fecha: 2026-05-10

## 1. Alcance

Auditoria estatica y smoke test read-only del submodulo `qresid/` antes de cualquier cambio de codigo.

Se ejecuto un smoke test Stata no destructivo con logs fuera de `qresid/`. No se modificaron archivos dentro de `qresid/`, no se editaron tests y no se agregaron archivos al submodulo.

Fuentes normativas usadas:

- `AGENTS.md`
- `02_IMPLEMENTATION_MASTERS/09_STATA_PACKAGE_ARCHITECTURE_MASTER.md`
- `02_IMPLEMENTATION_MASTERS/10_AGENT_RULES_FOR_QRESID.md`
- `04_RETRIEVAL_CONTEXT/STATA_PACKAGE_STYLE_RULES.md`
- `04_RETRIEVAL_CONTEXT/STATA_NUMERICAL_STABILITY_RULES.md`
- `04_RETRIEVAL_CONTEXT/STATA_TESTING_CERTIFICATION_RULES.md`
- `04_RETRIEVAL_CONTEXT/STATA_R_BENCHMARK_MAPPING.md`

## 2. Estado Git Del Submodulo

| item | valor |
|---|---|
| path | `qresid/` |
| branch | `dev-qresid-v2` |
| commit | `785732f` |
| audit_mode | read-only |
| code_modified | no |
| tests_modified | no |
| stata_smoke | executed outside submodule |

Archivos internos no trackeados detectados, no tocados:

| path | estado |
|---|---|
| `qresid/certification/certify_phase1.do` | untracked, length 0 |
| `qresid/changelog/` | untracked directory |
| `qresid/tests/run_all_tests.do` | untracked, length 0 |

## 3. Inventario Del Paquete

| path | size_bytes | estado |
|---|---:|---|
| `qresid/qresid.ado` | 13588 | existe |
| `qresid/qresid.sthlp` | 4894 | existe |
| `qresid/qresid.pkg` | 294 | existe |
| `qresid/stata.toc` | 275 | existe |
| `qresid/README.md` | 483 | existe |
| `qresid/make.do` | 1195 | existe |
| `qresid/1_Check_with_Simulations.do` | 2970 | existe, script exploratorio |
| `qresid/examples/README.md` | 0 | placeholder vacio |
| `qresid/tests/README.md` | 0 | placeholder vacio |
| `qresid/tests/run_all_tests.do` | 0 | placeholder vacio, untracked |
| `qresid/certification/README.md` | 0 | placeholder vacio |
| `qresid/certification/certify_phase1.do` | 0 | placeholder vacio, untracked |
| `qresid/changelog/CHANGELOG.md` | 0 | placeholder vacio, untracked |
| `qresid/LICENSE` | 1096 | existe |

## 4. Smoke Test Local Stata

| item | valor |
|---|---|
| do_file | `05_MCP_STATA_EXECUTION/logs/20260510_051235_qresid_package_smoke.do` |
| log_file | `05_MCP_STATA_EXECUTION/logs/20260510_051235_qresid_package_smoke.log` |
| process_output | `05_MCP_STATA_EXECUTION/logs/20260510_051235_qresid_package_smoke_process_output.txt` |
| package_load | `which qresid` encontro `C:/qresid-research-program/qresid/qresid.ado` |
| help_file | `findfile qresid.sthlp` encontro el help local |
| smoke_model | `sysuse auto`, `regress price mpg`, `qresid qr_smoke` |
| smoke_result | `qr_smoke` creado; 74 observaciones; media aproximada `-4.53e-10`; sd aproximada `.9931271` |
| API_final_test | `qresid qr_seed, seed(123)` falla con `_rc=198` y mensaje `option seed() not allowed` |
| interpretation | el paquete carga y ejecuta la API antigua; no implementa la API final Fase 1 |

Este smoke no certifica Fase 1. Solo confirma carga local del paquete actual y documenta la brecha API.

## 5. Comparacion Contra Arquitectura Oficial

| area | estandar oficial | estado observado | evaluacion |
|---|---|---|---|
| API publica | `qresid newvarname [if] [in] [, seed() uvar() savev() saveflo() savefhi() saveu() family()]` | `syntax newvarname(max=1) [if] [in] [, standardized nqres(int 4)]` | no conforme |
| `replace` | no exponer en Fase 1; error si output existe | no hay regla explicita de contrato; `newvarname` impide variable existente para output principal | parcial |
| `generate()` | prohibido en Fase 1 | no aparece como API | conforme |
| `version` | obligatorio | `version 15.0` presente | conforme |
| `marksample` | obligatorio para `if/in` y `e(sample)` | no se encontro `marksample` | no conforme |
| `e(sample)` | debe restringir muestra de estimacion | no se encontro validacion explicita | no conforme |
| `predict` | preferido para extraccion | presente en ramas principales | parcial |
| `double` | obligatorio para CDF/PIT/residuo | temporales principales usan `double`, pero output final usa `gen \`typlist'` | parcial |
| RNG | `seed()` y `uvar()` para reproducibilidad y benchmark exacto | usa `runiform()` directo; smoke confirma que `seed()` no es opcion aceptada | no conforme |
| endpoints | validar `F_low <= F_high` | no se encontro validacion explicita | no conforme |
| clipping | clipping documentado antes de `invnormal()` | no se encontro clipping | no conforme |
| returned results | `r()` con conteos/flags | no se encontro `rclass` ni `return` | no conforme |
| errores | `display as err` y `exit` | rama final usa `display "It is not a valid GLM"` sin `exit` | no conforme |

## 6. Dispatcher Y Familias

| familia/comando | estado observado | evaluacion |
|---|---|---|
| `regress` | rama especifica; usa `predict, residuals` y `e(rmse)` | existe, requiere `marksample/e(sample)` y tests |
| `glm` Gaussian | rama especifica; usa `predict, deviance` y `e(dispers)` | existe, debe auditar formula contra CDF normal oficial |
| `logit`/`logistic` | rama especifica; usa `predict, pr` | existe, pero calcula `y = n*p`, no observa depvar; requiere correccion |
| `glm` Bernoulli/binomial | rama especifica; usa `e(m)` y `predict, mu` | existe, requiere validar ensayos/soporte |
| `poisson` | rama especifica; usa `predict, n` | existe, alineada parcialmente con predict-first |
| `glm` Poisson | rama especifica; usa `predict, mu` | existe, alineada parcialmente con predict-first |
| `nbreg` | rama especifica; usa `e(alpha)`, `predict, n`, `ibeta()` | existe, pero NB sigue bloqueada por parametrizacion exacta |
| `glm` nbinomial | rama especifica; reestima `nbreg` desde `e(cmdline)` | alto riesgo; no debe considerarse estable |
| Gamma | no se encontro implementacion activa en `qresid.ado`; script de simulacion contiene seccion Gamma vacia | faltante para Fase 1 |
| ZIP/ZINB/hurdle/truncados/mixed | no se encontraron ramas activas | conforme como no implementados |

## 7. Hallazgos

| finding_id | severity | area | evidencia | impacto | queue_item |
|---|---|---|---|---|---|
| QA-001 | CRITICAL | API | `qresid.ado` acepta `standardized`/`nqres()` y no acepta `seed()`/`uvar()`/`save*()`/`family()` | no se puede implementar Fase 1 con contrato vigente sin reescribir parser/API | QIC-001 |
| QA-002 | CRITICAL | muestra | no se encontro `marksample` ni validacion `e(sample)` | riesgo de calcular residuos fuera de muestra estimada o con missings inconsistentes | QIC-002 |
| QA-003 | CRITICAL | RNG | usa `runiform()` directo; smoke confirma `option seed() not allowed` | benchmarks exactos R-Stata imposibles para discretas | QIC-003 |
| QA-004 | CRITICAL | PIT | no se encontro clipping ni validacion `F_low <= F_high` antes de `invnormal()` | riesgo de missing/infinitos silenciosos y resultados no auditables | QIC-004 |
| QA-005 | MAJOR | logit/logistic | rama genera `y = n*p` en vez de usar depvar observado | CDF discreta queda conceptualmente incorrecta | QIC-005 |
| QA-006 | MAJOR | NB | NB implementa `alpha`, `size`, `ibeta()` sin evidencia cerrada NB1/NB2/Stata-R | no declarar soporte estable hasta investigacion y benchmark | QIC-006 |
| QA-007 | MAJOR | Gamma | Gamma esta decidida para Fase 1 pero no esta implementada | bloquea Fase 1 completa | QIC-007 |
| QA-008 | MAJOR | outputs | outputs discretos generan multiples variables por `nqres()`; arquitectura final pide output principal y `save*()` auditables | contrato de outputs no conforme | QIC-008 |
| QA-009 | MAJOR | returned results | no se encontro `rclass` ni `return` | no hay auditoria programatica de familia, clipping, muestra o conteos | QIC-009 |
| QA-010 | MAJOR | errores | comando no soportado muestra texto sin `display as err` ni `exit` | fallos pueden pasar como ejecucion exitosa | QIC-010 |
| QA-011 | MAJOR | tests | `tests/README.md` y `tests/run_all_tests.do` estan vacios | no hay barrera antes de cambios de codigo | QIC-011 |
| QA-012 | MAJOR | certification | `certification/README.md` y `certify_phase1.do` estan vacios | falta certificacion reproducible SSC/SJ | QIC-012 |
| QA-013 | MODERATE | help/README | help documenta `standardized`/`nqres()` y claims GLM amplios | documentacion publica desalineada con API final | QIC-013 |
| QA-014 | MODERATE | packaging | `make.do` versiona `0.0.5` y README declara prerelease antiguo | release metadata requiere sincronizacion antes de publicar | QIC-014 |

## 8. Riesgos Antes De Implementacion

- No modificar `qresid/` hasta que exista un plan de cambio que actualice codigo, tests, help y changelog en el mismo lote o en lotes coordinados.
- No activar NB estable sin resolver parametrizacion y benchmark.
- No activar pesos sin decision por tipo de peso y familia.
- No declarar Gamma estable aunque sea Fase 1 hasta implementar CDF, tests y benchmark R-Stata.
- No comparar residuos aleatorizados entre R y Stata sin `uvar()` compartido.

## 9. Estado De Auditoria

`QRESID_REPO_AUDIT_COMPLETED_READ_ONLY`

La cola operativa asociada esta en `03_REPO_REVIEW/QRESID_IMPLEMENTATION_CHANGE_QUEUE.md`.

Post-change documentation sync: `POST_CHANGE_SYNC_DONE`
