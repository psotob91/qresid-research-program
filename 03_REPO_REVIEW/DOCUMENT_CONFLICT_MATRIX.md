Lifecycle: audit_snapshot
Status: PARTIALLY_ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load by task

# DOCUMENT_CONFLICT_MATRIX.md

Fecha: 2026-05-10

| conflict_id | severity | topic | file_A | file_B | contradiction_or_ambiguity | recommended_action | human_decision_required |
|---|---|---|---|---|---|---|---|
| PREMCP-C001 | CRITICAL | MCP execution docs empty | `05_MCP_STATA_EXECUTION/*.md` | `qresid_plan_rearmado_retrieval_mcp.md` | El plan historico espera protocolo MCP, comandos y checklist, pero los archivos MCP actuales estan vacios. | clarify | yes |
| PREMCP-C002 | MAJOR | Source log broken paths | `04_RETRIEVAL_CONTEXT/SOURCE_ACCESS_LOG.md` | filesystem | `07` y `08` figuran bajo `04_RETRIEVAL_CONTEXT/`, pero viven en `02_IMPLEMENTATION_MASTERS/`. | update_retrieval | no |
| PREMCP-C003 | MAJOR | Weights/RQR semantics | `07`, extraction rules, weights review | `09`, `10`, benchmark rules | No existe regla universal para pesos; soporte queda bloqueado por familia/tipo de peso. | human_decision | yes |
| PREMCP-C004 | MAJOR | Public API shadow rule | `07_ALGORITHM_PSEUDOCODE_MASTER.md` | `09_STATA_PACKAGE_ARCHITECTURE_MASTER.md` | `07` conserva `generate()`/`distribution()`; `09` gobierna `newvarname`, `seed()`, `uvar()`, `save*()`, `family()`. | hierarchy | no |
| PREMCP-C005 | MAJOR | NB parametrization | count rules, numerical rules, benchmark mapping | `09`, `10` | `alpha/theta/k`, NB1/NB2 y CDF exacta siguen pendientes antes de soporte estable. | human_decision | yes |
| PREMCP-C006 | MAJOR | Terminology authority missing | `00_PROJECT_CONTEXT/TERMINOLOGY_MASTER.md` | all normative docs | Terminos centrales se usan sin fuente canonica activa. | clarify | yes |
| PREMCP-C007 | MAJOR | Historical prompt as possible instruction | `qresid_plan_rearmado_retrieval_mcp.md` | `AGENTS.md`, retrieval map, `09`, `10` | Contiene prompts y rutas antiguas; puede inducir ejecucion fuera de jerarquia. | deprecate | no |
| PREMCP-C008 | MODERATE | Duplicate source logs | `00_PROJECT_CONTEXT/SOURCE_ACCESS_LOG.md` | `04_RETRIEVAL_CONTEXT/SOURCE_ACCESS_LOG.md` | Un source log vacio duplica por nombre al activo. | clarify | no |
| PREMCP-C009 | MODERATE | Empty repo audit placeholders | `QRESID_CURRENT_REPO_AUDIT.md`, `QRESID_ROADMAP_PHASED_UPDATES.md` | retrieval workflow | Nombres sugieren auditorias/roadmap existentes, pero estan vacios. | clarify | no |
| PREMCP-C010 | MODERATE | Gamma wording residual | `09`, `10`, reports | testing/benchmark docs | Gamma esta resuelto como Fase 1, pero debe evitarse claim estable sin CDF/benchmark. | clarify | no |
| PREMCP-C011 | MODERATE | Retrieval map over-centralization | `RETRIEVAL_MAP_FOR_QRESID.md` | all docs | Alta densidad de referencias puede sobredimensionar contexto para tareas simples. | split | no |
| PREMCP-C012 | MODERATE | Deep research scope creep | `01_DEEP_RESEARCH/*.md` | `09`, `10` | Deep research lista familias futuras que no son soporte activo. | hierarchy | no |
| PREMCP-C013 | MODERATE | Supported vs validated | `AGENTS.md`, `09`, testing rules | reports | "Soportado", "validado", "Fase 1" y "claim publico" requieren puente semantico. | clarify | yes |
| PREMCP-C014 | MINOR | Duplicated Stata idioms | `AGENTS.md`, `10`, style, minimal notes | same | Repeticion de `version`, `syntax`, `marksample`, `tempvar`, `double`; util pero redundante. | merge | no |
| PREMCP-C015 | MINOR | RNG duplication | numerical, benchmark, testing, agents | same | Repeticion de `seed()` y `uvar()` consistente. | keep | no |

## Resueltos y no activos

- Gamma fase: resuelto como Fase 1.
- Offset/exposure: resuelto por `predict`-first.
- Ruta de `PROJECT_BRIEF_QRESID.md`: corregida.
- Inclusion de reportes `DOCUMENT_*` en retrieval: parcialmente resuelta.

