Lifecycle: review_snapshot
Status: PARTIALLY_SUPERSEDED
Authority: diagnostic
Superseded by: 03_REPO_REVIEW/DOCUMENT_CONFLICT_MATRIX.md
Retrieval policy: load by task

# DOCUMENT_CONFLICT_RESOLUTION_QUEUE.md

## Active Conflict Queue

| conflict_id | severity | topic | file_A | file_B | contradiction_summary | recommended_action | human_decision_required |
|---|---|---|---|---|---|---|---|
| DOC-C002 | MAJOR | Inverse Gaussian phase | `01_DEEP_RESEARCH/01_THEORY_RQR_MASTER.md` | `AGENTS.md`; `09`; `10`; numerical rules | Deep research la propone para ruta inicial; governance actual la marca pendiente/prohibida sin CDF validada. | hierarchy | no |
| DOC-C003 | MAJOR | Weights transformation | `07_ALGORITHM_PSEUDOCODE_MASTER.md`; `STATA_MODEL_EXTRACTION_RULES.md`; `03_REPO_REVIEW/WEIGHTS_RQR_EVIDENCE_REVIEW.md` | `09_STATA_PACKAGE_ARCHITECTURE_MASTER.md`; `10_AGENT_RULES_FOR_QRESID.md` | Documentos antiguos sugerian `sqrt(w_i)` global; evidencia R/teorica no apoya una regla universal. Pesos pasan a `EVIDENCE_REVIEW_REQUIRED` por familia/tipo de peso. | human_decision | yes |
| DOC-C004 | MAJOR | Public API | `07_ALGORITHM_PSEUDOCODE_MASTER.md` | `09_STATA_PACKAGE_ARCHITECTURE_MASTER.md` | Pseudocodigo usa `generate()`/`distribution()`; arquitectura propone `newvarname`, `seed()`, `uvar()`, `save*()`, `family()`. | hierarchy | no |
| DOC-C007 | MODERATE | Empty duplicate source log | `00_PROJECT_CONTEXT/SOURCE_ACCESS_LOG.md` | `04_RETRIEVAL_CONTEXT/SOURCE_ACCESS_LOG.md` | Hay dos source logs por nombre; uno esta vacio y otro activo. | clarify | no |
| DOC-C008 | MODERATE | Empty terminology master | `00_PROJECT_CONTEXT/TERMINOLOGY_MASTER.md` | retrieval map / project brief | Archivo reservado pero vacio; no puede gobernar terminologia. | clarify | no |
| DOC-C009 | MODERATE | Review placeholders | `03_REPO_REVIEW/QRESID_CURRENT_REPO_AUDIT.md`; `QRESID_ROADMAP_PHASED_UPDATES.md` | retrieval workflow | Placeholders vacios pueden confundirse con auditorias realizadas. | clarify | no |
| DOC-C010 | MODERATE | MCP placeholders | `05_MCP_STATA_EXECUTION/*.md` | MCP workflow | Cuatro archivos MCP vacios no deben usarse como instrucciones. | clarify | no |
| DOC-C012 | MODERATE | Deep research as normative source | `01_DEEP_RESEARCH/*.md` | `AGENTS.md`; `09`; `10` | Deep research contiene recomendaciones amplias que pueden leerse como soporte activo. | hierarchy | no |
| DOC-C013 | MINOR | Duplicated Stata style rules | `AGENTS.md`; `10`; style rules; minimal notes | same | Repeticion de `version`, `syntax`, `marksample`, `tempvar`, `double`. Es duplicacion aceptable. | merge | no |
| DOC-C014 | MINOR | Duplicated RNG rules | `AGENTS.md`; numerical rules; benchmark mapping; testing rules | same | Repeticion de `seed()` y `uvar()`. Es solapamiento util. | merge | no |

## Resolved By 2026-05-10 Decision

| conflict_id | prior_status | topic | resolution |
|---|---|---|---|
| DOC-C001 | RESOLVED | Gamma phase | Resuelto por decision humana: Gamma es Fase 1 activa, con gate tecnico de `y > 0`, `mu > 0`, `phi > 0`, `shape = 1/phi`, `scale = mu*phi`, CDF y benchmark R. |
| DOC-C005 | RESOLVED | Offset/exposure extraction | Resuelto por jerarquia: regla dominante `predict`-first. Reconstruir `xb + offset` solo como fallback auditado y con tests de no duplicacion. |
| DOC-C006 | RESOLVED | Broken internal source path | Resuelto: `SOURCE_ACCESS_LOG.md` apunta a `00_PROJECT_CONTEXT/PROJECT_BRIEF_QRESID.md`. |
| DOC-C011 | RESOLVED | Retrieval map lacks audit reports | Resuelto: `RETRIEVAL_MAP_FOR_QRESID.md` referencia reportes `DOCUMENT_*` y `WEIGHTS_RQR_EVIDENCE_REVIEW.md` antes de auditoria de `qresid/`. |
| DOC-C015 | RESOLVED | SOURCE_ACCESS_LOG stale note | Resuelto: nota actualizada para reflejar router/09/10 y reportes de auditoria. |

## Next Actions

1. Resolver `DOC-C003` antes de activar pesos en Fase 1.
2. Resolver o cerrar por jerarquia `DOC-C004` antes de implementar parser publico.
3. Mantener Gamma en Fase 1, pero no publicar claim estable sin tests CDF y benchmark R.
4. Marcar placeholders vacios como `RESERVED` o poblarlos antes de MCP.

