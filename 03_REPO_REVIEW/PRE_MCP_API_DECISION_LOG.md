Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load by API/readiness task

# PRE_MCP_API_DECISION_LOG.md

Fecha: 2026-05-10

## 1. Decision

`API_01` queda resuelto para Fase 1.

API publica final:

```stata
qresid newvarname [if] [in] [, seed(integer) uvar(varname numeric) ///
    savev(name) saveflo(name) savefhi(name) saveu(name) family(string) ]
```

## 2. Reglas cerradas

- `ESTANDAR OFICIAL`: usar `newvarname` como argumento principal.
- `ESTANDAR OFICIAL`: no exponer `generate()` en Fase 1.
- `ESTANDAR OFICIAL`: no crear interfaz hibrida en Fase 1.
- `ESTANDAR OFICIAL`: mantener `savev()` separado de `saveu()`.
- `ESTANDAR OFICIAL`: mantener `family(string)` como opcion publica condicional; no puede contradecir `e(family)`.
- `ESTANDAR OFICIAL`: no exponer `replace` en Fase 1; si una variable de salida ya existe, fallar con error claro.

## 3. Impacto Pre-MCP

- `API_01` deja de bloquear MCP.
- El unico bloqueo MCP restante es `MCP_EXEC_01`.
- NB, pesos y Gamma siguen bloqueando Fase 1/soporte estable, no infraestructura MCP.

## 4. Post-change sync

`POST_CHANGE_SYNC_DONE`
