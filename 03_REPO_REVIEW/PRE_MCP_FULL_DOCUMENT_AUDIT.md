Lifecycle: audit_snapshot
Status: PARTIALLY_SUPERSEDED
Authority: diagnostic
Superseded by: 03_REPO_REVIEW/PRE_MCP_RESOLUTION_LOG.md
Retrieval policy: load by task

# PRE_MCP_FULL_DOCUMENT_AUDIT.md

Fecha: 2026-05-10  
Alcance: auditoria documental pre-MCP de `qresid-research-program/`.  
Estado: no modifica `qresid/`, codigo, tests ni documentos fuente.

## 1. Resumen ejecutivo

Se auditaron 40 Markdown fuera de `qresid/` y fuera de `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/`.

Resultado principal: `NOT_READY_FOR_MCP`.

Motivo: no hay conflicto `CRITICAL` sobre la teoria RQR o la arquitectura de Fase 1, pero si hay bloqueos operativos para MCP automatizado:

- `05_MCP_STATA_EXECUTION/*.md` esta vacio.
- `SOURCE_ACCESS_LOG.md` conserva rutas rotas para `07_ALGORITHM_PSEUDOCODE_MASTER.md` y `08_TESTING_QC_BENCHMARK_MASTER.md`.
- `qresid_plan_rearmado_retrieval_mcp.md` es un plan/prompt historico extenso y no debe ser cargado como fuente normativa.
- `TERMINOLOGY_MASTER.md` esta vacio, aunque ya hay drift semantico en terminos como `supported`, `Fase 1`, `exacto`, `benchmark` y `EVIDENCIA PENDIENTE`.
- La regla de pesos sigue `MAJOR`: no activar soporte ponderado sin subauditoria por familia/tipo de peso.

Gamma y offset/exposure estan resueltos documentalmente:

- Gamma es Fase 1 con gate tecnico de CDF, forma/escala y benchmark R.
- Offset/exposure usa regla `predict`-first; reconstruccion manual solo como fallback auditado.

## 2. Documentos cargados

Lectura completa o funcional:

- `AGENTS.md`
- `00_PROJECT_CONTEXT/PROJECT_BRIEF_QRESID.md`
- `02_IMPLEMENTATION_MASTERS/07_ALGORITHM_PSEUDOCODE_MASTER.md`
- `02_IMPLEMENTATION_MASTERS/08_TESTING_QC_BENCHMARK_MASTER.md`
- `02_IMPLEMENTATION_MASTERS/09_STATA_PACKAGE_ARCHITECTURE_MASTER.md`
- `02_IMPLEMENTATION_MASTERS/10_AGENT_RULES_FOR_QRESID.md`
- `03_REPO_REVIEW/DOCUMENT_*`
- `03_REPO_REVIEW/WEIGHTS_RQR_EVIDENCE_REVIEW.md`
- `04_RETRIEVAL_CONTEXT/*.md`

Lectura parcial/patrones:

- `01_DEEP_RESEARCH/*.md`: familias, fases, RQR/PIT, paquetes R/Stata, diagnostics, SJ/SSC.
- `PROJECT_VERSION_LOCK.md`: freeze, submodulo `qresid/`, caches externos.
- `qresid_plan_rearmado_retrieval_mcp.md`: prompts obsoletos, rutas antiguas, MCP previo.

## 3. Documentos ignorados

- `qresid/`: excluido por regla.
- `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/`: excluido por regla; usar solo manifiestos cuando proceda.
- Imagenes, binarios, logs, datasets, backups: fuera de alcance.

## 4. Iteracion 1

Acciones:

- Inventario de 40 MD.
- Metricas: lineas, palabras, headings, tablas, referencias `.md`.
- Busqueda de reglas normativas, fases, familias, API, RNG, extraction, benchmarks, release.
- Busqueda de rutas rotas y documentos no conectados.
- Primer mapa semantico/ontologico.

Hallazgos brutos:

- 8 placeholders vacios.
- `RETRIEVAL_MAP_FOR_QRESID.md` tiene alta centralidad y 279 referencias `.md`.
- `STATA_MINIMAL_PROGRAMMING_NOTES.md` y `PROJECT_BRIEF_QRESID.md` son largos pero aun manejables.
- `qresid_plan_rearmado_retrieval_mcp.md` contiene prompts y rutas historicas que pueden inducir acciones obsoletas.
- `SOURCE_ACCESS_LOG.md` mezcla fuentes internas activas, pendientes y rutas rotas.

## 5. Iteracion 2

Se redujeron falsos positivos:

- Duplicacion de `version`, `syntax`, `marksample`, `tempvar`, `double`: aceptable.
- Duplicacion de `seed()` y `uvar()`: aceptable y consistente.
- Gamma no es conflicto activo: queda resuelto como Fase 1.
- Offset/exposure no es conflicto activo: queda resuelto por `predict`-first.
- Deep research no contradice automaticamente si se mantiene como evidencia no normativa.

Conflictos reales activos:

- MCP vacio: `CRITICAL` para habilitar ejecucion automatizada.
- Rutas rotas en source log: `MAJOR`.
- Pesos/RQR: `MAJOR`.
- API antigua de `07`: `MAJOR` si se usa para parser.
- NB parametrizacion/CDF: `MAJOR`.
- Terminologia sin master activo: `MAJOR` para ontologia pre-MCP.

## 6. Riesgos de sobrecarga contextual

- Cargar `qresid_plan_rearmado_retrieval_mcp.md` junto con `AGENTS.md`, `09` y `10` puede reintroducir prompts obsoletos.
- Cargar todos los deep research para tareas de Fase 1 produce scope creep hacia inverse Gaussian, Tweedie, GLMM y modelos inflados.
- Cargar todo `04_RETRIEVAL_CONTEXT/` para cambios pequenos puede mezclar reglas generales, reglas por familia y notas de fuentes pendientes.
- Los reportes `DOCUMENT_*` son utiles para auditoria, pero no deben reemplazar la jerarquia normativa.

## 7. Riesgos de retrieval defectuoso

- Rutas `04_RETRIEVAL_CONTEXT/07_ALGORITHM_PSEUDOCODE_MASTER.md` y `04_RETRIEVAL_CONTEXT/08_TESTING_QC_BENCHMARK_MASTER.md` no existen.
- `00_PROJECT_CONTEXT/SOURCE_ACCESS_LOG.md` duplica por nombre al source log activo pero esta vacio.
- `TERMINOLOGY_MASTER.md` esta vacio, aunque el proyecto ya usa terminos con carga normativa.
- `05_MCP_STATA_EXECUTION` no tiene protocolo ejecutable.
- `RETRIEVAL_MAP_FOR_QRESID.md` referencia reportes `DOCUMENT_*` mediante nota operativa, pero no integra aun los nuevos reportes pre-MCP.

## 8. Recomendacion

No habilitar MCP todavia. Primero:

1. Poblar `05_MCP_STATA_EXECUTION/` con protocolo minimo.
2. Corregir rutas internas de `SOURCE_ACCESS_LOG.md`.
3. Marcar `qresid_plan_rearmado_retrieval_mcp.md` como historico/superseded o excluirlo del retrieval por defecto.
4. Crear o poblar terminologia canonica.
5. Mantener pesos, NB y API final en cola `MAJOR`.

