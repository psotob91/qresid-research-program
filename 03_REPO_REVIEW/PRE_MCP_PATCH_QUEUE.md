Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load by pre-MCP task

# PRE_MCP_PATCH_QUEUE.md

Fecha: 2026-05-10

## 1. Cambios seguros aplicados

| patch_id | change | files | retrieval_impact | lifecycle_impact |
|---|---|---|---|---|
| PATCH-001 | Crear reportes finales pre-MCP. | `PRE_MCP_FINAL_AUDIT.md`, `PRE_MCP_DECISION_QUEUE.md`, `PRE_MCP_EXTERNAL_RESEARCH_REQUESTS.md`, `PRE_MCP_PATCH_QUEUE.md`, `PRE_MCP_RESOLUTION_STATUS.md` | Punto unico para auditoria final. | Nuevos snapshots activos/diagnosticos. |
| PATCH-002 | Registrar reportes finales en lifecycle registry. | `DOCUMENT_STATUS_REGISTRY.md` | Permite cargar reportes finales sin snapshots antiguos. | Reportes anteriores pasan a subordinados/superseded para readiness. |
| PATCH-003 | Reemplazar nota superior que cargaba snapshots antiguos directos. | `RETRIEVAL_MAP_FOR_QRESID.md` | Prioriza registry y reportes finales activos. | Reduce riesgo anti-loop. |
| PATCH-004 | Mantener readiness sin `READY`. | `MCP_READINESS_CHECKLIST.md` | Evidencia incompleta queda visible. | Stata/R/MCP siguen `NOT_VERIFIED`. |

## 2. Cambios minimos recomendados pendientes

| patch_id | change | files | reason | blocking |
|---|---|---|---|---|
| PATCH-FUTURE-001 | Poblar auditoria actual de `qresid/`. | `QRESID_CURRENT_REPO_AUDIT.md` | Requisito antes de modificar codigo. | yes |
| PATCH-FUTURE-002 | Split de retrieval map en indice + rutas por tarea. | `RETRIEVAL_MAP_FOR_QRESID.md` | Reducir sobrecarga MCP. | no |
| PATCH-FUTURE-003 | Split de notas minimas Stata/Mata. | `STATA_MINIMAL_PROGRAMMING_NOTES.md` | Reducir carga para tareas no coding. | no |
| PATCH-FUTURE-004 | Crear notas externas NB/Gamma/pesos tras investigacion. | `04_RETRIEVAL_CONTEXT/*.md` | Cerrar evidencia de Fase 1. | yes for implementation |

## 3. Regla anti-loop

No aplicar nuevos parches automaticos si solo cambian registry/retrieval/sync y no aparece inconsistencia directa. Crear entrada `HUMAN_DECISION_REQUIRED` si una correccion cambia la jerarquia documental.
