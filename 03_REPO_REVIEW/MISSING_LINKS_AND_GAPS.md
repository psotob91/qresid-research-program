Lifecycle: audit_snapshot
Status: PARTIALLY_ACTIVE
Authority: diagnostic
Superseded by: 03_REPO_REVIEW/PRE_MCP_RESOLUTION_LOG.md
Retrieval policy: load by task

# MISSING_LINKS_AND_GAPS.md

Fecha: 2026-05-10

## 1. Pasos faltantes entre fases

| tramo | gap | severidad | accion recomendada |
|---|---|---|---|
| retrieval -> MCP | No existe protocolo MCP poblado | CRITICAL | Poblar `05_MCP_STATA_EXECUTION/` |
| document audit -> repo audit | Reportes pre-MCP aun no estan integrados en retrieval map | MODERATE | Agregar ruta de lectura pre-MCP |
| repo audit -> implementation | `QRESID_CURRENT_REPO_AUDIT.md` esta vacio | MODERATE | Poblar antes de cambios en `qresid/` |
| implementation -> testing | API final y NB/pesos no cerrados | MAJOR | Resolver cola antes de codigo estable |
| testing -> release | Certification real no ejecutada | MAJOR | Crear/ejecutar scripts y logs |
| release -> publication | Help/examples no auditados contra API final | MAJOR | Auditoria SSC/SJ posterior |

## 2. Referencias faltantes o rotas

| origen | referencia | estado | accion |
|---|---|---|---|
| `SOURCE_ACCESS_LOG.md` | `04_RETRIEVAL_CONTEXT/07_ALGORITHM_PSEUDOCODE_MASTER.md` | rota | Cambiar a `02_IMPLEMENTATION_MASTERS/...` |
| `SOURCE_ACCESS_LOG.md` | `04_RETRIEVAL_CONTEXT/08_TESTING_QC_BENCHMARK_MASTER.md` | rota | Cambiar a `02_IMPLEMENTATION_MASTERS/...` |
| `qresid_plan_rearmado_retrieval_mcp.md` | `05_MCP_STATA_EXECUTION/STATA_EXECUTION_PROTOCOL.md` | no existe | Supersede o crear protocolo aprobado |
| `qresid_plan_rearmado_retrieval_mcp.md` | `README_MCP_STATA.md`, `MCP_SETUP_LOG.md` | no existen | No ejecutar plan historico sin revision |

## 3. Retrieval gaps

- Falta ruta explicita "pre-MCP readiness".
- Falta decision sobre si `qresid_plan_rearmado_retrieval_mcp.md` se excluye por defecto.
- Falta puente entre reportes pre-MCP y auditoria de `qresid/`.
- Falta regla de no cargar `05_MCP_STATA_EXECUTION/*.md` hasta que no esten poblados.
- Falta regla para limitar deep research a evidencia parcial por familia.

## 4. Arquitectura incompleta

- API publica final conserva gaps: `family()`, `replace`, `savev()`/`saveu()` y aliases.
- NB requiere decision `alpha/theta/k`, NB1/NB2 y CDF.
- Pesos requieren matriz familia x tipo de peso x regla CDF/residuo.
- Gamma esta en Fase 1, pero requiere validacion tecnica antes de claim estable.
- Mata/.mlib sigue postergado hasta estabilizar tests/API.

## 5. Decisiones implicitas no documentadas

- Que significa "MCP listo" para este proyecto.
- Que archivos MCP son obligatorios y que logs se esperan.
- Si placeholders vacios deben marcarse `RESERVED`.
- Si `qresid_plan_rearmado_retrieval_mcp.md` queda `SUPERSEDED`.
- Si `TERMINOLOGY_MASTER.md` debe poblarse o retirarse.

## 6. Gaps semanticos

- `supported` vs `allowed` vs `implemented` vs `stable`.
- `benchmark exacto` vs `benchmark aproximado`.
- `family` Stata (`e(family)`) vs familia conceptual.
- `weights` como tipo estadistico vs macro Stata `e(wtype)`.
- `U`, `V`, PIT y uniformes externos.

## 7. Acciones minimas antes de MCP

1. Corregir rutas de `07` y `08` en source log.
2. Poblar MCP setup/checklist/test commands/local execution.
3. Crear terminologia canonica minima.
4. Excluir o marcar superseded el plan historico MCP.
5. Actualizar retrieval map con ruta pre-MCP y estos reportes.

