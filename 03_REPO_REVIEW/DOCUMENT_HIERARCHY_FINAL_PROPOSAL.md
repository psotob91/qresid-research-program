Lifecycle: audit_snapshot
Status: PARTIALLY_ACTIVE
Authority: diagnostic
Superseded by: 04_RETRIEVAL_CONTEXT/DOCUMENT_STATUS_REGISTRY.md
Retrieval policy: load by task

# DOCUMENT_HIERARCHY_FINAL_PROPOSAL.md

Fecha: 2026-05-10  
Estado: propuesta final pre-MCP; no cambia documentos fuente.

## 1. Jerarquia propuesta

| nivel | documento/familia | autoridad | precedencia |
|---:|---|---|---|
| 1 | `AGENTS.md` | Router raiz, limites globales, prohibiciones, lectura previa | Domina en fronteras de trabajo y prohibiciones |
| 2 | `04_RETRIEVAL_CONTEXT/RETRIEVAL_MAP_FOR_QRESID.md` | Seleccion de contexto y orden de lectura | Domina en retrieval |
| 3 | `02_IMPLEMENTATION_MASTERS/09_STATA_PACKAGE_ARCHITECTURE_MASTER.md` | Arquitectura, API, fases, dispatcher, outputs | Domina en soporte y API |
| 4 | `02_IMPLEMENTATION_MASTERS/10_AGENT_RULES_FOR_QRESID.md` | Reglas operativas antes de codigo/tests/docs | Domina en conducta de agentes |
| 5 | Rules especializados de `04_RETRIEVAL_CONTEXT/` | Numerical, testing, benchmark, style, extraction | Dominan localmente si no contradicen `09` |
| 6 | `02_IMPLEMENTATION_MASTERS/07_*` y `08_*` | Pseudocodigo y testing inicial | Subordinados a `09`, `10` y rules especializados |
| 7 | `03_REPO_REVIEW/DOCUMENT_*` y reportes pre-MCP | Diagnostico y cola de riesgos | Informan; no sustituyen reglas fuente |
| 8 | `03_REPO_REVIEW/WEIGHTS_RQR_EVIDENCE_REVIEW.md` | Evidencia sobre pesos | Obligatorio para pesos; no autoriza implementacion |
| 9 | `01_DEEP_RESEARCH/*.md` | Evidencia y literatura | Informan; no autorizan soporte activo |
| 10 | `00_PROJECT_CONTEXT/PROJECT_BRIEF_QRESID.md` | Vision y alcance amplio | Subordinado a reglas tecnicas concretadas |
| 11 | `PROJECT_VERSION_LOCK.md` | Freeze/versionado | Domina solo en estado git/submodulos |
| 12 | `qresid_plan_rearmado_retrieval_mcp.md` | Plan/prompt historico | Superseded para operacion actual |
| 13 | Placeholders vacios | Ninguna | Sin autoridad |

## 2. Reglas de precedencia

1. Si el conflicto es fase/API/soporte, domina `09`, salvo prohibicion mas estricta en `AGENTS.md`.
2. Si el conflicto es que leer o que ignorar, domina retrieval map.
3. Si el conflicto es conducta de agente, domina `10`.
4. Si el conflicto es CDF/PIT/clipping/tolerancia, domina numerical rules siempre que la familia este autorizada por `09`.
5. Si el conflicto es benchmark R-Stata, dominan benchmark mapping y testing rules.
6. Si el conflicto es help/examples/release, domina package style.
7. Si dos documentos normativos del mismo nivel difieren, marcar `HUMAN_DECISION_REQUIRED`.
8. Reportes de auditoria no resuelven automaticamente conflictos; registran cola.
9. Deep research y prompts historicos no deben cargarse como instrucciones ejecutables.

## 3. Documentos que deben leerse completos por defecto

- `AGENTS.md`
- `RETRIEVAL_MAP_FOR_QRESID.md`
- `09_STATA_PACKAGE_ARCHITECTURE_MASTER.md`
- `10_AGENT_RULES_FOR_QRESID.md`
- Rule especializado directamente vinculado a la tarea.

## 4. Documentos que deben leerse parcialmente

- Deep research: solo evidencia/familia involucrada.
- `07`: algoritmo, endpoints o pseudocodigo; no API publica.
- `08`: testing historico; no reemplaza testing rules.
- `PROJECT_VERSION_LOCK.md`: solo si la tarea toca git, submodulos o caches.
- `qresid_plan_rearmado_retrieval_mcp.md`: solo auditoria historica, nunca ejecucion directa.

## 5. Documentos sin autoridad actual

- `00_PROJECT_CONTEXT/SOURCE_ACCESS_LOG.md`
- `00_PROJECT_CONTEXT/TERMINOLOGY_MASTER.md`
- `03_REPO_REVIEW/QRESID_CURRENT_REPO_AUDIT.md`
- `03_REPO_REVIEW/QRESID_ROADMAP_PHASED_UPDATES.md`
- `05_MCP_STATA_EXECUTION/*.md`

## 6. Documentos que deben permanecer intactos

- `AGENTS.md`
- `09_STATA_PACKAGE_ARCHITECTURE_MASTER.md`
- `10_AGENT_RULES_FOR_QRESID.md`
- `RETRIEVAL_MAP_FOR_QRESID.md`

Estos son el esqueleto normativo actual. Cualquier correccion debe pasar por una tarea explicita de limpieza documental.

