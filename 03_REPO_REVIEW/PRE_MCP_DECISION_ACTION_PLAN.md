Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load by pre-MCP task

# PRE_MCP_DECISION_ACTION_PLAN.md

Fecha: 2026-05-10

## 1. Action plan

| step | decision_id | action | blocking_level | modifies_files | requires_human | next_prompt |
|---:|---|---|---|---|---|---|
| 1 | API_01 | API publica final cerrada como Opcion A. | `RESOLVED_FOR_DOCUMENTATION` | Docs only | no | NONE |
| 2 | MCP_EXEC_01 | Ejecutar o completar verificacion MCP mediada; Stata/R local smoke ya fue ejecutado. | `BLOCKING_FOR_MCP` | Logs/readiness | no, salvo setup externo | `Actua como DevOps MCP para Stata/R. Ejecuta smoke tests MCP...` |
| 3 | REPO_AUDIT_01 | Poblar auditoria actual de `qresid/` en modo read-only. | `BLOCKING_FOR_CODE_CHANGES` | Audit report only | no | `Actua como auditor Stata/Mata. Pobla QRESID_CURRENT_REPO_AUDIT.md...` |
| 4 | NB_01 | Investigar parametrizacion NB antes de soporte estable. | `BLOCKING_FOR_PHASE1_ONLY` | Research notes later | yes | `Actua como investigador Stata/R. Cierra NB_PARAM_01...` |
| 5 | WEIGHTS_01 | Investigar pesos RQR por familia/tipo. | `BLOCKING_FOR_PHASE1_ONLY` | Research notes later | yes | `Actua como estadistico computacional. Cierra WEIGHTS_RQR_01...` |
| 6 | GAMMA_01 | Mantener Gamma en Fase 1 con gate CDF/tests/benchmark. | `BLOCKING_FOR_PHASE1_ONLY` | No immediate change | no | `Actua como auditor de benchmarks Gamma...` |
| 7 | SPLIT_01 | Diferir split de retrieval map/notas Stata hasta despues de MCP. | `DEFER_UNTIL_AFTER_MCP` | No immediate change | no | `Actua como arquitecto de retrieval. Planifica split post-MCP...` |

## 2. Current MCP blockers

- `MCP_EXEC_01`

## 3. Next prompts

### Verificar MCP/local execution

```text
Actua como DevOps MCP para Stata/R. Ejecuta los smoke tests documentados en 05_MCP_STATA_EXECUTION, guarda logs, actualiza MCP_SETUP_LOG.md y MCP_READINESS_CHECKLIST.md sin tocar qresid/ ni codigo.
```

### Auditar `qresid/` despues

```text
Actua como auditor Stata/Mata. Pobla QRESID_CURRENT_REPO_AUDIT.md revisando qresid/ en modo read-only, sin modificar codigo ni tests, y prepara cola de cambios antes de implementacion.
```
