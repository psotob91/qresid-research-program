Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before qresid Phase 0 implementation

# QRESID_PHASE0_EXECUTION_PLAN.md

Fecha: 2026-05-10

## 1. Proposito

Plan ejecutable para preparar estructura, tests minimos y certificacion inicial antes de modificar logica funcional en `qresid.ado`.

Este plan no autoriza por si solo cambios de codigo. Antes de ejecutarlo, leer:

- `AGENTS.md`
- `03_REPO_REVIEW/QRESID_CURRENT_REPO_AUDIT.md`
- `03_REPO_REVIEW/QRESID_IMPLEMENTATION_CHANGE_QUEUE.md`
- `03_REPO_REVIEW/QRESID_TEST_PLAN_BEFORE_CODE_CHANGES.md`
- `02_IMPLEMENTATION_MASTERS/09_STATA_PACKAGE_ARCHITECTURE_MASTER.md`
- `02_IMPLEMENTATION_MASTERS/10_AGENT_RULES_FOR_QRESID.md`
- `04_RETRIEVAL_CONTEXT/POST_CHANGE_DOCUMENTATION_SYNC.md`

## 2. Alcance

| item | regla |
|---|---|
| Objetivo | crear barrera minima de tests y estructura antes del refactor funcional |
| Modificar codigo funcional | no |
| Modificar `qresid.ado` | no |
| Modificar help publico | no, salvo que se cree nota interna de tests; help publico espera Phase 1 |
| Activar soporte nuevo | no |
| Declarar Fase 1 estable | no |

## 3. Clasificacion De Cambios

| change_class | aplica a | regla |
|---|---|---|
| `PHASE0_STRUCTURE` | estructura de carpetas, runners, logs, README internos | permitido en Phase 0 |
| `PHASE1_TESTS` | tests que documentan fallos actuales y contratos futuros | permitido en Phase 0 si no cambian logica |
| `PHASE1_IMPLEMENTATION` | cambios funcionales en ado/Mata | no ejecutar en Phase 0 |
| `PHASE1_DOCS` | help/examples/changelog publicos sincronizados con implementacion | diferir hasta tests verdes |
| `DEFER_PHASE2` | ZIP/ZINB, hurdle, truncados, mixed/GLMM/GSEM | no tocar |
| `DO_NOT_DO` | NB estable, pesos ponderados globales | no tocar |

## 4. Orden Exacto De Ejecucion

1. Confirmar estado git:
   - `git status --short`
   - `git -C qresid status --short --branch`
   - documentar untracked preexistentes sin borrarlos.
2. Normalizar estructura minima dentro de `qresid/` sin cambiar logica:
   - `tests/`
   - `certification/`
   - `examples/`
   - `changelog/`
3. Crear o completar `tests/run_all_tests.do`:
   - `version`
   - `set more off`
   - `adopath ++` hacia el repo local
   - `which qresid`
   - apertura/cierre de log
   - asserts basicos
   - salida no cero ante fallo.
4. Crear tests de carga:
   - `which qresid`
   - `findfile qresid.ado`
   - `findfile qresid.sthlp`
   - smoke antiguo `regress price mpg` + `qresid qr_smoke`.
5. Crear tests de contrato API que fallen o documenten brecha actual:
   - `qresid qr, seed(123)` debe fallar hoy con `option seed() not allowed`.
   - `qresid, generate(qr)` debe ser rechazado.
   - output existente debe fallar; no existe `replace`.
6. Crear tests base para contratos futuros:
   - `marksample`/`e(sample)`
   - `uvar()`
   - `saveflo()`, `savefhi()`, `saveu()`, `savev()`
   - clipping y endpoints
   - returned results `r()`.
7. Crear certificacion minima:
   - script maestro que ejecute la suite;
   - logs reproducibles;
   - estado explicito: no certifica soporte Fase 1.
8. Actualizar solo documentacion de review/lifecycle requerida:
   - `QRESID_IMPLEMENTATION_CHANGE_QUEUE.md` si algun item cambia de estado;
   - `DOCUMENT_STATUS_REGISTRY.md` si se crean nuevos artefactos de plan/review;
   - post-change sync.

## 5. Tests Minimos De Phase 0

| test_id | class | objetivo | estado esperado antes del refactor |
|---|---|---|---|
| P0-LOAD-001 | `PHASE0_STRUCTURE` | Stata encuentra `qresid.ado` local | pass |
| P0-LOAD-002 | `PHASE0_STRUCTURE` | Stata encuentra `qresid.sthlp` local | pass |
| P0-SMOKE-001 | `PHASE1_TESTS` | `regress` + API antigua produce residuo | pass documentado |
| P0-API-001 | `PHASE1_TESTS` | `seed()` no existe aun | fail esperado con `_rc=198` |
| P0-API-002 | `PHASE1_TESTS` | `generate()` no forma parte de API final | error controlado esperado tras refactor |
| P0-SAMPLE-001 | `PHASE1_TESTS` | fuera de `e(sample)` no debe calcular residuo | fail esperado hasta QIC-002 |
| P0-RNG-001 | `PHASE1_TESTS` | `uvar()` permite uniformes externos | fail esperado hasta QIC-003 |
| P0-PIT-001 | `PHASE1_TESTS` | endpoints y clipping son auditables | fail esperado hasta QIC-004 |

## 6. Criterio De Salida

Phase 0 termina cuando:

- existe runner minimo;
- hay logs reproducibles;
- los fallos esperados estan separados de fallos inesperados;
- no se modifico `qresid.ado`;
- no se declaro soporte nuevo;
- la cola de cambios sigue apuntando a Phase 1 para implementacion funcional.

## 7. Riesgos

- Tests que solo imprimen resultados sin `assert` no sirven como barrera.
- No convertir el smoke antiguo en claim de soporte.
- No usar `qresid/certification/` como evidencia release hasta que la suite sea deterministica.
- No resolver NB, pesos ni Gamma durante Phase 0.

## 8. Primer Prompt De Implementacion

```text
Actua como maintainer Stata/Mata. Implementa Phase 0: crea o completa la estructura minima de tests/certification en qresid/ sin modificar qresid.ado, ejecuta tests locales con Stata, guarda logs y actualiza la cola de cambios. No implementes familias ni API funcional todavia.
```

Post-change documentation sync: `POST_CHANGE_SYNC_DONE`
