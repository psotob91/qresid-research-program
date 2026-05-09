Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before MCP enablement

# MCP_GATE_ACTIONS.md

Fecha: 2026-05-10

## 1. Acciones De Cierre

| order | item_id | action | can_codex_do_now | requires_human | expected_readiness_effect |
|---:|---|---|---|---|---|
| 1 | MCP_EXEC_01 | Verificar si existe una herramienta/servidor MCP Stata/R invocable desde esta sesion. | yes | no | Si existe, pasar a smoke MCP; si no existe, mantener `MCP_SETUP_READY_EXECUTION_NOT_VERIFIED`. |
| 2 | MCP_EXEC_01 | Ejecutar smoke command mediado por MCP para R y Stata, o registrar explicitamente que no hay MCP Stata/R disponible. | conditional | yes, solo si requiere setup externo | Si pasa, permite subir de `READY_FOR_MCP_SETUP_NOT_EXECUTION_VERIFIED` a readiness MCP verificable; si falla, `NOT_READY_MCP_TOOLING`. |
| 3 | MCP_EXEC_01 | Actualizar `05_MCP_STATA_EXECUTION/MCP_SETUP_LOG.md`, `03_REPO_REVIEW/MCP_READINESS_CHECKLIST.md` y `03_REPO_REVIEW/PRE_MCP_RESOLUTION_STATUS.md` con logs MCP. | yes | no | Documenta evidencia real; nunca marcar `READY` sin logs revisados. |
| 4 | REPO_AUDIT_01 | Cargar `QRESID_CURRENT_REPO_AUDIT.md` y `QRESID_IMPLEMENTATION_CHANGE_QUEUE.md` antes de cualquier cambio en `qresid/`. | yes | no | No cambia MCP; habilita planificacion de codigo posterior. |
| 5 | NB_01 | Planificar investigacion NB oficial Stata/R antes de soporte estable. | yes | yes | No cambia MCP; desbloquea Fase 1 NB futura. |
| 6 | WEIGHTS_01 | Planificar investigacion de pesos por familia/tipo. | yes | yes | No cambia MCP; desbloquea soporte ponderado futuro. |
| 7 | GAMMA_01 | Planificar implementacion Gamma con CDF/tests/benchmark. | yes | no | No cambia MCP; desbloquea Fase 1 Gamma. |
| 8 | SPLIT_01 | Diferir split fino de retrieval/notas hasta despues de MCP. | yes | no | Reduce riesgo de drift luego; no debe bloquear gate actual. |

## 2. Parches Seguros Despues De Aprobacion

- Actualizar readiness solo si se ejecuta MCP-mediated smoke y los logs existen.
- Registrar cualquier fallo como `NOT_READY_MCP_TOOLING`, no como exito parcial.
- Si no hay herramienta MCP Stata/R disponible, registrar `MCP_SETUP_READY_EXECUTION_NOT_VERIFIED`.
- Mantener NB, pesos y Gamma fuera del gate MCP.
- Mantener snapshots historicos como no normativos mediante `DOCUMENT_STATUS_REGISTRY.md`.

## 3. Proximo Prompt Recomendado

```text
Actua como DevOps MCP para Stata/R. Verifica si hay herramienta MCP Stata/R invocable; si existe, ejecuta smoke tests MCP-mediated para R y Stata, guarda logs y actualiza MCP_SETUP_LOG.md, MCP_READINESS_CHECKLIST.md y PRE_MCP_RESOLUTION_STATUS.md. No modifiques qresid/ ni codigo.
```

Post-change documentation sync: `POST_CHANGE_SYNC_DONE`
