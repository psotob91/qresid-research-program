Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before qresid code changes

# QRESID_TEST_PLAN_BEFORE_CODE_CHANGES.md

Fecha: 2026-05-10

## 1. Proposito

Plan minimo de pruebas que debe existir antes de modificar codigo funcional en `qresid/`.

Este documento no autoriza cambios por si solo. Antes de implementar, leer `AGENTS.md`, `09_STATA_PACKAGE_ARCHITECTURE_MASTER.md`, `10_AGENT_RULES_FOR_QRESID.md`, `STATA_TESTING_CERTIFICATION_RULES.md`, `STATA_R_BENCHMARK_MAPPING.md`, `QRESID_CURRENT_REPO_AUDIT.md` y `QRESID_IMPLEMENTATION_CHANGE_QUEUE.md`.

## 2. Regla De Entrada

No modificar `qresid.ado` sin una suite minima que pueda fallar antes del cambio y pasar despues del cambio.

Los tests deben ejecutarse con Stata local verificado y guardar logs reproducibles. Si R se usa para benchmark, guardar tambien script, version de R y salida.

## 3. Tests Obligatorios Antes Del Refactor Base

| test_id | area | scenario | expected_result | blocks |
|---|---|---|---|---|
| QTP-001 | carga local | `adopath ++ qresid`, `which qresid`, `findfile qresid.sthlp` | paquete y help local encontrados | implementacion |
| QTP-002 | API final | `qresid newvar, seed(123) saveflo(flo) savefhi(fhi) saveu(u)` despues de modelo discreto | sintaxis aceptada cuando se implemente | QIC-001/QIC-003/QIC-008 |
| QTP-003 | API prohibida | `qresid, generate(x)` y API hibrida | error controlado | QIC-001 |
| QTP-004 | variable existente | output principal ya existe | error claro; no `replace` en Fase 1 | QIC-001/QIC-008 |
| QTP-005 | muestra | `if/in`, missings y `e(sample)` | residuos solo en muestra permitida | QIC-002 |
| QTP-006 | RNG seed | misma semilla y mismos datos | mismos residuos aleatorizados dentro de Stata | QIC-003 |
| QTP-007 | RNG uvar | `uvar()` compartido | residuos reproducibles sin depender de RNG nativo | QIC-003 |
| QTP-008 | endpoints | discreta con `F_low`, `F_high`, `U` guardados | `F_low <= F_high`, `U` dentro del intervalo | QIC-004 |
| QTP-009 | clipping | endpoints en 0/1 o cerca de frontera | no `+/-inf` silencioso; clipping auditable | QIC-004 |
| QTP-010 | errores | sin modelo estimado o comando fuera de fase | `display as err` y `exit` no cero | QIC-010 |
| QTP-011 | returned results | ejecucion exitosa | `r()` contiene comando, familia, N, flags y conteos | QIC-009 |

## 4. Tests Por Familia Fase 1

| family | commands | required_checks | benchmark |
|---|---|---|---|
| Gaussian | `regress`, `glm, family(gaussian)` | muestra, prediccion, escala, residuo principal | Stata internal + R/statmod cuando aplique |
| Bernoulli/binomial | `logit`, `logistic`, `glm, family(binomial)` | outcome observado, ensayos validos, `predict, pr`/`predict, mu`, endpoints discretos | R/statmod con `uvar()` |
| Poisson | `poisson`, `glm, family(poisson)` | `predict, n` o `predict, mu`, soporte entero no negativo, endpoints | R/statmod con `uvar()` |
| Gamma | `glm, family(gamma)` | `y > 0`, `mu > 0`, `phi > 0`, `shape = 1/phi`, `scale = mu*phi`, CDF Gamma | R/statmod/R base CDF audit |

## 5. Bloqueos Explicitos

| topic | rule |
|---|---|
| NB | no declarar soporte estable hasta cerrar `alpha/theta/k`, NB1/NB2 y benchmark exacto |
| weights | no activar soporte ponderado global; requiere matriz familia x tipo de peso |
| ZIP/ZINB/hurdle/truncados | no implementar en Fase 1 |
| mixed/GLMM/GSEM | no implementar en Fase 1 |
| MCP-mediated execution | no declarar verificado; solo ejecucion local Stata/R esta verificada |

## 6. Logs Minimos

Cada corrida debe registrar:

- fecha/hora;
- version de Stata;
- ruta de `qresid.ado`;
- comandos ejecutados;
- resultado de cada assert;
- archivo de log;
- si hubo benchmark R, version de R y script usado.

## 7. Secuencia Recomendada

1. Crear `tests/run_all_tests.do` y un smoke suite minimo.
2. Agregar tests API/muestra/RNG/endpoints que fallen contra la implementacion actual.
3. Refactorizar API base y utilidades de CDF/PIT.
4. Activar familias Fase 1 una por una con benchmarks.
5. Actualizar help/README/changelog despues de pasar tests.

Post-change documentation sync: `POST_CHANGE_SYNC_DONE`
