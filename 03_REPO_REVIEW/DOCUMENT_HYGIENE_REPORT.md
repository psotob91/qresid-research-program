Lifecycle: audit_snapshot
Status: PARTIALLY_ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load by task

# DOCUMENT_HYGIENE_REPORT.md

Fecha: 2026-05-10

## 1. Criterios

- `KEEP_AS_IS`: rol claro, menos de 800 lineas, uso completo razonable.
- `SPLIT_RECOMMENDED`: dos responsabilidades o riesgo de retrieval parcial.
- `SPLIT_REQUIRED`: mas de 1200 lineas, mas de 18000 palabras o mezcla critica.
- `INDEX_ONLY_RECOMMENDED`: deberia ser indice y delegar contenido.
- `REVIEW_MANUALLY`: vacio, historico, ambiguo o requiere decision humana.

## 2. Tabla de higiene

| file | path | lines | approx_words | headings_count | tables_count | role | split_status | reason |
|---|---|---:|---:|---:|---:|---|---|---|
| `PROJECT_BRIEF_QRESID.md` | `00_PROJECT_CONTEXT/` | 593 | 1599 | 59 | 0 | brief/alcance | KEEP_AS_IS | Largo pero central y legible |
| `SOURCE_ACCESS_LOG.md` | `00_PROJECT_CONTEXT/` | 0 | 0 | 0 | 0 | placeholder | REVIEW_MANUALLY | Duplicado vacio |
| `TERMINOLOGY_MASTER.md` | `00_PROJECT_CONTEXT/` | 0 | 0 | 0 | 0 | terminologia | REVIEW_MANUALLY | Vacio; bloquea ontologia canonica |
| `01_THEORY_RQR_MASTER.md` | `01_DEEP_RESEARCH/` | 265 | 5590 | 25 | 35 | teoria | KEEP_AS_IS | Evidencia, no normativa |
| `02_R_PACKAGES_RQR_MASTER.md` | `01_DEEP_RESEARCH/` | 145 | 4030 | 22 | 49 | evidencia R | KEEP_AS_IS | Usar parcial |
| `03_STATA_PACKAGES_RQR_MASTER.md` | `01_DEEP_RESEARCH/` | 91 | 3153 | 11 | 37 | evidencia Stata | KEEP_AS_IS | Usar parcial |
| `04_GRAPHICS_TESTS_DIAGNOSTICS_MASTER.md` | `01_DEEP_RESEARCH/` | 128 | 3984 | 9 | 24 | diagnosticos | KEEP_AS_IS | Usar parcial |
| `05_OPEN_DATASETS_CASEBANK_MASTER.md` | `01_DEEP_RESEARCH/` | 90 | 3846 | 7 | 44 | datasets | KEEP_AS_IS | No cargar para implementacion |
| `06_STATA_JOURNAL_SOFTWARE_ARTICLES_MASTER.md` | `01_DEEP_RESEARCH/` | 306 | 4362 | 16 | 18 | evidencia editorial | KEEP_AS_IS | Informativo |
| `07_ALGORITHM_PSEUDOCODE_MASTER.md` | `02_IMPLEMENTATION_MASTERS/` | 289 | 2464 | 28 | 0 | pseudocodigo | REVIEW_MANUALLY | API historica; subordinado a `09` |
| `08_TESTING_QC_BENCHMARK_MASTER.md` | `02_IMPLEMENTATION_MASTERS/` | 155 | 2162 | 19 | 11 | testing inicial | KEEP_AS_IS | Complementa rules |
| `09_STATA_PACKAGE_ARCHITECTURE_MASTER.md` | `02_IMPLEMENTATION_MASTERS/` | 369 | 2395 | 31 | 67 | arquitectura | KEEP_AS_IS | Normativo |
| `10_AGENT_RULES_FOR_QRESID.md` | `02_IMPLEMENTATION_MASTERS/` | 250 | 2037 | 21 | 26 | reglas agentes | KEEP_AS_IS | Normativo |
| `DOCUMENT_*` | `03_REPO_REVIEW/` | 34-133 | 539-945 | varied | varied | auditoria previa | KEEP_AS_IS | Insumo diagnostico |
| `QRESID_CURRENT_REPO_AUDIT.md` | `03_REPO_REVIEW/` | 0 | 0 | 0 | 0 | placeholder | REVIEW_MANUALLY | Nombre sugiere auditoria hecha |
| `QRESID_ROADMAP_PHASED_UPDATES.md` | `03_REPO_REVIEW/` | 0 | 0 | 0 | 0 | placeholder | REVIEW_MANUALLY | Vacio |
| `WEIGHTS_RQR_EVIDENCE_REVIEW.md` | `03_REPO_REVIEW/` | 63 | 447 | 7 | 5 | evidencia pesos | KEEP_AS_IS | Obligatorio para pesos |
| `COUNT_MODELS_EXTRACTION_RULES.md` | `04_RETRIEVAL_CONTEXT/` | 71 | 1452 | 9 | 26 | extraction count | KEEP_AS_IS | Local |
| `GLM_POSTESTIMATION_RULES.md` | `04_RETRIEVAL_CONTEXT/` | 56 | 1024 | 7 | 27 | extraction GLM | KEEP_AS_IS | Local |
| `MIXED_MODELS_EXTRACTION_RULES.md` | `04_RETRIEVAL_CONTEXT/` | 39 | 1016 | 6 | 10 | mixed futuro | KEEP_AS_IS | No cargar Fase 1 |
| `RETRIEVAL_MAP_FOR_QRESID.md` | `04_RETRIEVAL_CONTEXT/` | 251 | 1983 | 20 | 60 | retrieval map | SPLIT_RECOMMENDED | Alta centralidad; agregar indice MCP/pre-MCP |
| `SOURCE_ACCESS_LOG.md` | `04_RETRIEVAL_CONTEXT/` | 137 | 1696 | 10 | 67 | source log | REVIEW_MANUALLY | Rutas `07`/`08` rotas |
| `STATA_BUILTIN_COMMANDS_MAP.md` | `04_RETRIEVAL_CONTEXT/` | 114 | 1490 | 8 | 76 | comandos | KEEP_AS_IS | Tabla focalizada |
| `STATA_MINIMAL_PROGRAMMING_NOTES.md` | `04_RETRIEVAL_CONTEXT/` | 505 | 5271 | 44 | 0 | notas Stata/Mata | SPLIT_RECOMMENDED | Varias responsabilidades practicas |
| `STATA_MODEL_EXTRACTION_RULES.md` | `04_RETRIEVAL_CONTEXT/` | 143 | 1593 | 9 | 15 | extraction general | KEEP_AS_IS | Actualizado para pesos/offset |
| `STATA_NUMERICAL_STABILITY_RULES.md` | `04_RETRIEVAL_CONTEXT/` | 169 | 1523 | 12 | 63 | numerica | KEEP_AS_IS | Normativo |
| `STATA_PACKAGE_STYLE_RULES.md` | `04_RETRIEVAL_CONTEXT/` | 236 | 1490 | 14 | 45 | estilo/package | KEEP_AS_IS | Normativo |
| `STATA_R_BENCHMARK_MAPPING.md` | `04_RETRIEVAL_CONTEXT/` | 236 | 1671 | 22 | 67 | benchmark | KEEP_AS_IS | Normativo |
| `STATA_TESTING_CERTIFICATION_RULES.md` | `04_RETRIEVAL_CONTEXT/` | 417 | 1905 | 32 | 44 | testing/cert | KEEP_AS_IS | Normativo |
| `05_MCP_STATA_EXECUTION/*.md` | `05_MCP_STATA_EXECUTION/` | 0 | 0 | 0 | 0 | MCP placeholders | REVIEW_MANUALLY | Bloquea MCP |
| `AGENTS.md` | root | 154 | 769 | 13 | 0 | router | KEEP_AS_IS | Normativo |
| `PROJECT_VERSION_LOCK.md` | root | 66 | 375 | 7 | 24 | version lock | KEEP_AS_IS | Freeze |
| `qresid_plan_rearmado_retrieval_mcp.md` | root | 633 | 3002 | 20 | 6 | prompt historico | REVIEW_MANUALLY | Probablemente superseded |

## 3. Documentos a dividir

- `RETRIEVAL_MAP_FOR_QRESID.md`: split recomendado en indice + rutas por tarea, antes de automatizar MCP.
- `STATA_MINIMAL_PROGRAMMING_NOTES.md`: split recomendado en ado basics, Mata, logging/RNG, certification snippets.

## 4. Documentos a mantener intactos

- `AGENTS.md`
- `09_STATA_PACKAGE_ARCHITECTURE_MASTER.md`
- `10_AGENT_RULES_FOR_QRESID.md`
- Rules especializados de `04_RETRIEVAL_CONTEXT/`, salvo correcciones puntuales aprobadas.

