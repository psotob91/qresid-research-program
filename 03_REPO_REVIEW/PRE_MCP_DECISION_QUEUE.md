Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load by pre-MCP task

# PRE_MCP_DECISION_QUEUE.md

Fecha: 2026-05-10

| decision_id | severity | topic | problem | recommendation | resolution_type | blocking_mcp | human_required | reclassification | status_note |
|---|---|---|---|---|---|---|---|---|---|
| API_01 | MAJOR | API publica | `family()`, `replace`, `savev()`/`saveu()` y aliases no estan cerrados. | API Fase 1 cerrada como Opcion A: `qresid newvarname [if] [in], options`; sin `generate()`, sin hibrido, sin `replace`; `family()` condicional; `savev()` separado de `saveu()`. | clarify | no | no | `RESOLVED_FOR_DOCUMENTATION` | Resuelto por `PRE_MCP_API_DECISION_LOG.md`; no bloquea MCP. |
| NB_01 | MAJOR | Negative binomial | Falta mapping estable `alpha/theta/k`, NB1/NB2 y CDF exacta Stata-R. | Investigar manual oficial Stata y benchmark R antes de activar soporte estable. | external_research | no | yes | `BLOCKING_FOR_PHASE1_ONLY` | No bloquea infraestructura MCP; bloquea soporte NB estable. |
| WEIGHTS_01 | MAJOR | Pesos | No existe regla universal segura para RQR ponderados. | Crear matriz familia x tipo de peso x paquete R x regla CDF/residuo. | external_research | no | yes | `BLOCKING_FOR_PHASE1_ONLY` | No bloquea infraestructura MCP; bloquea soporte ponderado. |
| MCP_EXEC_01 | MAJOR | Ejecucion MCP | Stata/R smoke tests locales ejecutados; MCP-mediated execution sigue `NOT_VERIFIED`. | Mantener ejecucion MCP bloqueada hasta smoke test mediado por MCP o registro de tooling no disponible. | auto_patch | no | no | `MUST_CLOSE_BEFORE_MCP_EXECUTION` | Setup documental MCP listo; ejecucion MCP real sigue `NOT_VERIFIED`. |
| REPO_AUDIT_01 | MAJOR | Auditoria `qresid/` | `QRESID_CURRENT_REPO_AUDIT.md` fue poblado en modo read-only. | Cargar auditoria y cola antes de modificar codigo. | clarify | no | no | `RESOLVED_READ_ONLY_FOR_SETUP` | No bloquea setup MCP; bloquea solo cambios de codigo si no se consulta. |
| RETRIEVAL_01 | MODERATE | Snapshots antiguos | El retrieval map ya usa registry y reportes finales activos. | Mantener regla de no cargar `PARTIALLY_SUPERSEDED` por defecto. | retrieval_update | no | no | `RESOLVED` | Resuelto documentalmente. |
| GAMMA_01 | MODERATE | Gamma Fase 1 | Gamma esta permitida, pero no estable sin CDF/tests/benchmark. | Mantener Fase 1 con gate tecnico obligatorio. | clarify | no | no | `BLOCKING_FOR_PHASE1_ONLY` | No bloquea MCP. |
| SPLIT_01 | MINOR | Retrieval centralizado | Retrieval map y notas Stata/Mata son densos para MCP fino. | Planificar split posterior sin bloquear pre-MCP. | split | no | no | `DEFER_UNTIL_AFTER_MCP` | Diferido. |

## Reclassification note

Fecha: 2026-05-10.

Solo `MCP_EXEC_01` bloquea ejecucion MCP real. El setup documental MCP queda listo como `READY_FOR_MCP_SETUP_NOT_EXECUTION_VERIFIED`. `API_01` esta resuelto documentalmente. `NB_01`, `WEIGHTS_01` y `GAMMA_01` bloquean Fase 1/soporte estable. `REPO_AUDIT_01` no bloquea setup MCP; la auditoria debe cargarse antes de cambios de codigo.
