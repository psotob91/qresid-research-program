Lifecycle: audit_snapshot
Status: PARTIALLY_SUPERSEDED
Authority: diagnostic
Superseded by: 03_REPO_REVIEW/DOCUMENT_HYGIENE_REPORT.md
Retrieval policy: load by task

# DOCUMENT_RETRIEVAL_HYGIENE_AUDIT.md

## 1. Resumen

No se detectan documentos que cumplan criterios automaticos de `SPLIT_REQUIRED` o `INDEX_ONLY_RECOMMENDED` por longitud. La higiene documental debe concentrarse en:

- placeholders vacios;
- rutas internas inconsistentes;
- documentos historicos que contienen reglas fuertes subordinadas;
- mapas de retrieval que deben incorporar estos reportes si se usaran antes de auditoria repo.

## 2. Tabla de higiene

| file | path | lines | approx_words | headings_count | tables_count | role | split_status | reason |
|---|---|---:|---:|---:|---:|---|---|---|
| `AGENTS.md` | `AGENTS.md` | 154 | 769 | 13 | 0 | Router raiz | KEEP_AS_IS | Breve, normativo, se usa casi completo. |
| `PROJECT_BRIEF_QRESID.md` | `00_PROJECT_CONTEXT/PROJECT_BRIEF_QRESID.md` | 593 | 1599 | 59 | 0 | Brief de alcance | KEEP_AS_IS | Menos de 800 lineas; muchas secciones pero funcion clara de brief. |
| `SOURCE_ACCESS_LOG.md` | `00_PROJECT_CONTEXT/SOURCE_ACCESS_LOG.md` | 0 | 0 | 0 | 0 | Placeholder | REVIEW_MANUALLY | Vacio; duplica nombre de source log activo en `04`. |
| `TERMINOLOGY_MASTER.md` | `00_PROJECT_CONTEXT/TERMINOLOGY_MASTER.md` | 0 | 0 | 0 | 0 | Placeholder terminologico | REVIEW_MANUALLY | Vacio; decidir poblar o retirar de retrieval. |
| `01_THEORY_RQR_MASTER.md` | `01_DEEP_RESEARCH/01_THEORY_RQR_MASTER.md` | 265 | 5590 | 25 | 35 | Deep research teorico | KEEP_AS_IS | Largo en palabras por teoria, pero tema unico; no normativo. |
| `02_R_PACKAGES_RQR_MASTER.md` | `01_DEEP_RESEARCH/02_R_PACKAGES_RQR_MASTER.md` | 145 | 4030 | 22 | 49 | Deep research R | KEEP_AS_IS | Tema unico; usar como evidencia, no reglas. |
| `03_STATA_PACKAGES_RQR_MASTER.md` | `01_DEEP_RESEARCH/03_STATA_PACKAGES_RQR_MASTER.md` | 91 | 3153 | 11 | 37 | Deep research Stata | KEEP_AS_IS | Corto y focalizado. |
| `04_GRAPHICS_TESTS_DIAGNOSTICS_MASTER.md` | `01_DEEP_RESEARCH/04_GRAPHICS_TESTS_DIAGNOSTICS_MASTER.md` | 128 | 3984 | 9 | 24 | Deep research diagnosticos | KEEP_AS_IS | Tema unico; no partir. |
| `05_OPEN_DATASETS_CASEBANK_MASTER.md` | `01_DEEP_RESEARCH/05_OPEN_DATASETS_CASEBANK_MASTER.md` | 90 | 3846 | 7 | 44 | Deep research datasets | KEEP_AS_IS | Tema unico; revisar licencias luego. |
| `06_STATA_JOURNAL_SOFTWARE_ARTICLES_MASTER.md` | `01_DEEP_RESEARCH/06_STATA_JOURNAL_SOFTWARE_ARTICLES_MASTER.md` | 306 | 4362 | 16 | 18 | Deep research editorial | KEEP_AS_IS | Fuente editorial; util completo para SJ/SSC. |
| `07_ALGORITHM_PSEUDOCODE_MASTER.md` | `02_IMPLEMENTATION_MASTERS/07_ALGORITHM_PSEUDOCODE_MASTER.md` | 287 | 2436 | 28 | 0 | Pseudocodigo historico | REVIEW_MANUALLY | API antigua permanece como pseudocodigo; pesos/offset fueron aclarados y quedan subordinados a `09`/`10`. |
| `08_TESTING_QC_BENCHMARK_MASTER.md` | `02_IMPLEMENTATION_MASTERS/08_TESTING_QC_BENCHMARK_MASTER.md` | 155 | 2162 | 19 | 11 | Testing master inicial | KEEP_AS_IS | Complementa testing rules; algunas reglas antiguas deben aclararse. |
| `09_STATA_PACKAGE_ARCHITECTURE_MASTER.md` | `02_IMPLEMENTATION_MASTERS/09_STATA_PACKAGE_ARCHITECTURE_MASTER.md` | 369 | 2352 | 31 | 67 | Arquitectura/API | KEEP_AS_IS | Normativo y auditable; no partir antes de implementacion. |
| `10_AGENT_RULES_FOR_QRESID.md` | `02_IMPLEMENTATION_MASTERS/10_AGENT_RULES_FOR_QRESID.md` | 250 | 2017 | 21 | 26 | Reglas agentes | KEEP_AS_IS | Normativo; ampliacion de `AGENTS.md`. |
| `QRESID_CURRENT_REPO_AUDIT.md` | `03_REPO_REVIEW/QRESID_CURRENT_REPO_AUDIT.md` | 0 | 0 | 0 | 0 | Placeholder review | REVIEW_MANUALLY | Vacio; aun no es evidencia de auditoria repo. |
| `QRESID_ROADMAP_PHASED_UPDATES.md` | `03_REPO_REVIEW/QRESID_ROADMAP_PHASED_UPDATES.md` | 0 | 0 | 0 | 0 | Placeholder roadmap | REVIEW_MANUALLY | Vacio; decidir si reservar o poblar tras auditoria. |
| `COUNT_MODELS_EXTRACTION_RULES.md` | `04_RETRIEVAL_CONTEXT/COUNT_MODELS_EXTRACTION_RULES.md` | 71 | 1452 | 9 | 26 | Extraccion count | KEEP_AS_IS | Corto y focalizado; contiene gates Fase 2. |
| `GLM_POSTESTIMATION_RULES.md` | `04_RETRIEVAL_CONTEXT/GLM_POSTESTIMATION_RULES.md` | 56 | 1024 | 7 | 27 | Extraccion GLM | KEEP_AS_IS | Corto y focalizado. |
| `MIXED_MODELS_EXTRACTION_RULES.md` | `04_RETRIEVAL_CONTEXT/MIXED_MODELS_EXTRACTION_RULES.md` | 39 | 1016 | 6 | 10 | Extraccion mixed futura | KEEP_AS_IS | Corto; usar solo para Fase 2/3. |
| `RETRIEVAL_MAP_FOR_QRESID.md` | `04_RETRIEVAL_CONTEXT/RETRIEVAL_MAP_FOR_QRESID.md` | 247 | 1937 | 20 | 58 | Mapa retrieval | KEEP_AS_IS | Mapa central; actualizado para reportes `DOCUMENT_*` y evidencia de pesos. |
| `SOURCE_ACCESS_LOG.md` | `04_RETRIEVAL_CONTEXT/SOURCE_ACCESS_LOG.md` | 137 | 1691 | 10 | 67 | Source log activo | REVIEW_MANUALLY | Ruta de project brief y nota stale corregidas; revisar duplicado vacio en `00`. |
| `STATA_BUILTIN_COMMANDS_MAP.md` | `04_RETRIEVAL_CONTEXT/STATA_BUILTIN_COMMANDS_MAP.md` | 114 | 1490 | 8 | 76 | Mapa comandos Stata | KEEP_AS_IS | Tabla tecnica focalizada. |
| `STATA_MINIMAL_PROGRAMMING_NOTES.md` | `04_RETRIEVAL_CONTEXT/STATA_MINIMAL_PROGRAMMING_NOTES.md` | 505 | 5271 | 44 | 0 | Notas Stata/Mata | KEEP_AS_IS | Largo pero bajo umbral; muy usado como referencia completa. |
| `STATA_MODEL_EXTRACTION_RULES.md` | `04_RETRIEVAL_CONTEXT/STATA_MODEL_EXTRACTION_RULES.md` | 141 | 1564 | 9 | 15 | Extraccion general | REVIEW_MANUALLY | Regla `sqrt(w_i)` global retirada; pesos siguen pendientes por familia. |
| `STATA_NUMERICAL_STABILITY_RULES.md` | `04_RETRIEVAL_CONTEXT/STATA_NUMERICAL_STABILITY_RULES.md` | 169 | 1523 | 12 | 63 | Numerica CDF/PIT | KEEP_AS_IS | Focalizado y normativo. |
| `STATA_PACKAGE_STYLE_RULES.md` | `04_RETRIEVAL_CONTEXT/STATA_PACKAGE_STYLE_RULES.md` | 236 | 1490 | 14 | 45 | Estilo package | KEEP_AS_IS | Focalizado en SSC/SJ. |
| `STATA_R_BENCHMARK_MAPPING.md` | `04_RETRIEVAL_CONTEXT/STATA_R_BENCHMARK_MAPPING.md` | 236 | 1664 | 22 | 67 | Benchmark R-Stata | KEEP_AS_IS | Focalizado; duplicacion de `uvar()` aceptable. |
| `STATA_TESTING_CERTIFICATION_RULES.md` | `04_RETRIEVAL_CONTEXT/STATA_TESTING_CERTIFICATION_RULES.md` | 417 | 1905 | 32 | 44 | Testing/certificacion | KEEP_AS_IS | Normativo; algunas fases deben alinearse con `09`. |
| `MCP_PHASE1_CHECKLIST.md` | `05_MCP_STATA_EXECUTION/MCP_PHASE1_CHECKLIST.md` | 0 | 0 | 0 | 0 | Placeholder MCP | REVIEW_MANUALLY | Vacio; no usar como regla. |
| `MCP_SETUP_GUIDE.md` | `05_MCP_STATA_EXECUTION/MCP_SETUP_GUIDE.md` | 0 | 0 | 0 | 0 | Placeholder MCP | REVIEW_MANUALLY | Vacio; no usar como guia aun. |
| `MCP_TEST_COMMANDS.md` | `05_MCP_STATA_EXECUTION/MCP_TEST_COMMANDS.md` | 0 | 0 | 0 | 0 | Placeholder MCP | REVIEW_MANUALLY | Vacio; no usar como test source. |
| `STATA_MCP_LOCAL_EXECUTION.md` | `05_MCP_STATA_EXECUTION/STATA_MCP_LOCAL_EXECUTION.md` | 0 | 0 | 0 | 0 | Placeholder MCP | REVIEW_MANUALLY | Vacio; no usar antes de poblar. |

## 3. Recomendaciones de particion

No hay `SPLIT_REQUIRED`.

No hay `INDEX_ONLY_RECOMMENDED`.

`REVIEW_MANUALLY` no implica partir: significa que el documento esta vacio, contiene rutas/rules sensibles, o requiere decision antes de modificar.

