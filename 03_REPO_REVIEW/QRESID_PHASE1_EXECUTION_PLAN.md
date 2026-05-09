Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before qresid Phase 1 implementation

# QRESID_PHASE1_EXECUTION_PLAN.md

Fecha: 2026-05-10

## 1. Proposito

Plan ejecutable para refactorizar `qresid` hacia la API Fase 1 final y activar familias permitidas con tests, benchmarks y documentacion sincronizada.

Este plan presupone que Phase 0 ya dejo una suite minima ejecutable. No iniciar Phase 1 si no existe barrera de tests.

## 2. Alcance

| class | alcance | regla |
|---|---|---|
| `PHASE1_IMPLEMENTATION` | API final, muestra, RNG, PIT/RQR, outputs, familias Fase 1 | permitido con tests |
| `PHASE1_TESTS` | unit, integration, benchmark y certificacion | obligatorio |
| `PHASE1_DOCS` | help, README, examples, changelog | solo despues de tests verdes |
| `DEFER_PHASE2` | ZIP/ZINB, hurdle, truncados, mixed/GLMM/GSEM | no implementar |
| `DO_NOT_DO` | NB estable y pesos globales | no activar sin investigacion |

## 3. Orden Exacto De Ejecucion

1. Ejecutar suite Phase 0 y guardar logs.
2. Refactor base de `qresid.ado`:
   - `program qresid, rclass`;
   - `version`;
   - `syntax newvarname [if] [in] [, seed(integer) uvar(varname numeric) savev(name) saveflo(name) savefhi(name) saveu(name) family(string)]`;
   - prohibir `generate()` e interfaz hibrida;
   - no exponer `replace`;
   - error claro si output principal o `save*()` ya existen.
3. Implementar validacion de entorno:
   - abortar si no hay `e(cmd)`;
   - dispatcher para comandos Fase 1;
   - error controlado para comandos fuera de fase.
4. Implementar muestra:
   - `marksample`;
   - cruce con `e(sample)`;
   - missings auditables;
   - fuera de muestra queda missing.
5. Implementar nucleo comun PIT/RQR:
   - variables internas `double`;
   - `F_low`, `F_high`, `V`, `U`;
   - validar `0 <= F_low <= F_high <= 1`;
   - abortar si `F_high + tol < F_low`;
   - clipping antes de `invnormal(U)`;
   - guardar `saveflo()`, `savefhi()`, `saveu()`, `savev()` si se solicitan.
6. Implementar RNG:
   - `seed()` controla reproducibilidad interna Stata;
   - `uvar()` valida uniformes externos en muestra;
   - no declarar igualdad exacta R-Stata sin `uvar()`.
7. Activar familias en este orden:
   - Gaussian: `regress`, `glm, family(gaussian)`;
   - Poisson: `poisson`, `glm, family(poisson)`;
   - Bernoulli/binomial: `logit`, `logistic`, `binreg`, `glm, family(binomial)`;
   - Gamma: `glm, family(gamma)` con gate tecnico.
8. Mantener fuera de soporte estable:
   - NB: error controlado o ruta bloqueada hasta parametrizacion;
   - pesos: detectar si aplica, pero no transformar residuo final ni prometer soporte;
   - ZIP/ZINB/hurdle/truncados/mixed: error controlado.
9. Implementar returned results:
   - comando/familia;
   - N usado;
   - flags de clipping;
   - nombres de outputs guardados;
   - estado de aleatorizacion.
10. Actualizar documentacion publica:
   - `qresid.sthlp`;
   - README;
   - examples;
   - changelog;
   - package metadata solo si se prepara release.

## 4. Familias Fase 1

| family | commands | extractor | CDF/PIT | tests required |
|---|---|---|---|---|
| Gaussian | `regress`, `glm gaussian` | `predict` y parametros de escala | continua, sin aleatorizacion | unit + integration |
| Poisson | `poisson`, `glm poisson` | `predict, n` o `predict, mu` | discreta con endpoints | unit + integration + R benchmark con `uvar()` |
| Bernoulli/binomial | `logit`, `logistic`, `binreg`, `glm binomial` | `predict, pr` o `predict, mu`, trials validos | discreta con endpoints | unit + integration + R benchmark con `uvar()` |
| Gamma | `glm gamma` | `predict, mu`, dispersion | continua con `shape = 1/phi`, `scale = mu*phi` | unit + integration + R benchmark |

## 5. Tests De Aceptacion

| area | minimo aceptable |
|---|---|
| API | opciones finales aceptadas; opciones prohibidas fallan con error claro |
| muestra | ninguna observacion fuera de `marksample & e(sample)` recibe residuo |
| RNG | `seed()` reproduce dentro de Stata; `uvar()` reproduce uniformes externos |
| endpoints | `F_low`, `F_high`, `U` guardables y validados |
| clipping | conteos auditables y sin infinitos silenciosos |
| familias | cada comando Fase 1 tiene integration test |
| benchmarks | comparacion por capas; discretas con `uvar()` |
| docs | help/examples coinciden con tests verdes |

## 6. Diferidos Y Prohibiciones

| topic | class | regla |
|---|---|---|
| NB estable | `DO_NOT_DO` | no activar hasta cerrar `alpha/theta/k`, NB1/NB2 y CDF exacta |
| weights | `DO_NOT_DO` | no aplicar `sqrt(w_i)` global ni prometer soporte ponderado |
| ZIP/ZINB | `DEFER_PHASE2` | error controlado, no calculo parcial |
| hurdle/truncados | `DEFER_PHASE2` | error controlado, no calculo parcial |
| mixed/GLMM/GSEM | `DEFER_PHASE2` | error controlado, no calculo parcial |
| generated docs/logs | `DO_NOT_DO` | no incluir logs grandes o material interno en paquete final |

## 7. Criterio De Salida

Phase 1 termina cuando:

- API final esta implementada;
- tests de API, muestra, RNG y endpoints pasan;
- Gaussian, Poisson, Bernoulli/binomial y Gamma tienen tests verdes;
- docs publicos no prometen soporte fuera de tests;
- NB, pesos y Phase 2 quedan bloqueados de forma explicita;
- post-change sync queda ejecutado.

## 8. Primer Prompt De Implementacion

```text
Actua como maintainer Stata/Mata. Con Phase 0 ya ejecutada, implementa el refactor base de qresid.ado para API final, marksample/e(sample), seed(), uvar(), outputs save*(), endpoints y errores controlados. Ejecuta la suite local Stata y no actives NB ni pesos.
```

Post-change documentation sync: `POST_CHANGE_SYNC_DONE`
