Lifecycle: audit_snapshot
Status: PARTIALLY_SUPERSEDED
Authority: diagnostic
Superseded by: 03_REPO_REVIEW/DOCUMENT_HIERARCHY_FINAL_PROPOSAL.md
Retrieval policy: load by task

# DOCUMENT_HIERARCHY_PROPOSAL.md

## 1. Jerarquia documental propuesta

| nivel | documento o familia documental | autoridad principal | regla de precedencia |
|---:|---|---|---|
| 1 | `AGENTS.md` | Router raiz, fronteras del workspace, prohibiciones globales, lectura previa. | Domina cuando define limites de trabajo, fases generales o prohibiciones. |
| 2 | `04_RETRIEVAL_CONTEXT/RETRIEVAL_MAP_FOR_QRESID.md` | Que leer, en que orden y que no cargar. | Domina en retrieval y seleccion de contexto. |
| 3 | `02_IMPLEMENTATION_MASTERS/09_STATA_PACKAGE_ARCHITECTURE_MASTER.md` | Arquitectura, API, fases, dispatcher, outputs, returned results. | Domina en API, soporte por fase y arquitectura de paquete. |
| 4 | `02_IMPLEMENTATION_MASTERS/10_AGENT_RULES_FOR_QRESID.md` | Reglas operativas antes de leer/modificar codigo, tests o docs. | Domina en conducta de agentes y reglas de detencion. |
| 5 | `04_RETRIEVAL_CONTEXT/STATA_NUMERICAL_STABILITY_RULES.md` | CDF, endpoints, PIT, clipping, tolerancias, RNG numerico. | Domina en estabilidad numerica si no contradice `09`. |
| 6 | `04_RETRIEVAL_CONTEXT/STATA_TESTING_CERTIFICATION_RULES.md` | Unit tests, integration tests, benchmarks y certification. | Domina en pruebas y acceptance criteria. |
| 7 | `04_RETRIEVAL_CONTEXT/STATA_R_BENCHMARK_MAPPING.md` | Comparacion R-Stata por capas, `uvar()`, tolerancias de benchmark. | Domina en benchmark R-Stata. |
| 8 | `04_RETRIEVAL_CONTEXT/STATA_PACKAGE_STYLE_RULES.md` | Estilo SSC/Stata Journal, help, examples, release, limpieza editorial. | Domina en documentacion publica y packaging. |
| 9 | Reglas de extraccion por familia/modelo | `GLM_POSTESTIMATION_RULES.md`, `COUNT_MODELS_EXTRACTION_RULES.md`, `MIXED_MODELS_EXTRACTION_RULES.md`, `STATA_MODEL_EXTRACTION_RULES.md`, `STATA_BUILTIN_COMMANDS_MAP.md`. | Domina localmente en `predict`, `e()`, comandos y parametros si la familia esta autorizada por `09`. |
| 10 | `02_IMPLEMENTATION_MASTERS/07_*` y `08_*` | Pseudocodigo y diseno historico de tests. | Informan, pero no dominan API ni fases si difieren de `09`/`10`. |
| 11 | `01_DEEP_RESEARCH/*.md` | Evidencia, literatura, referencias y contexto metodologico. | Informan, no autorizan implementacion. |
| 12 | `00_PROJECT_CONTEXT/PROJECT_BRIEF_QRESID.md` | Alcance amplio y vision del proyecto. | Domina en objetivo general salvo que `09`/`10` hayan concretado una regla tecnica posterior. |
| 13 | `03_REPO_REVIEW/WEIGHTS_RQR_EVIDENCE_REVIEW.md` | Evidencia curada para pesos/RQR. | Informa decisiones de pesos; no autoriza implementacion sin `09`/`10` y tests. |
| 14 | Placeholders vacios | Archivos vacios en `00`, `03`, `05`. | Sin autoridad normativa hasta poblarse. |

## 2. Reglas de precedencia

1. Si hay conflicto de fase o soporte, domina `09_STATA_PACKAGE_ARCHITECTURE_MASTER.md`, salvo prohibicion mas estricta en `AGENTS.md`.
2. Si hay conflicto sobre que leer, domina `RETRIEVAL_MAP_FOR_QRESID.md`.
3. Si hay conflicto sobre conducta antes de modificar codigo, domina `10_AGENT_RULES_FOR_QRESID.md`.
4. Si hay conflicto sobre CDF/PIT/clipping/tolerancias, domina `STATA_NUMERICAL_STABILITY_RULES.md` siempre que la familia este autorizada por `09`.
5. Si hay conflicto sobre R-Stata, domina `STATA_R_BENCHMARK_MAPPING.md` para comparacion por capas y `uvar()`.
6. Si hay conflicto sobre help/examples/release, domina `STATA_PACKAGE_STYLE_RULES.md`.
7. Deep research no autoriza soporte activo por si solo.
8. Ejemplos o snippets no deben tratarse como reglas si contradicen un documento normativo.
9. Si dos documentos normativos del mismo nivel difieren, marcar `HUMAN_DECISION_REQUIRED`.

## 3. Autoridad por archivo auditado

| archivo | autoridad propuesta | estado |
|---|---|---|
| `AGENTS.md` | Constitucional/router | Activo |
| `00_PROJECT_CONTEXT/PROJECT_BRIEF_QRESID.md` | Brief de alcance | Activo |
| `00_PROJECT_CONTEXT/SOURCE_ACCESS_LOG.md` | Ninguna | Vacio |
| `00_PROJECT_CONTEXT/TERMINOLOGY_MASTER.md` | Ninguna | Vacio |
| `01_DEEP_RESEARCH/01_THEORY_RQR_MASTER.md` | Evidencia teorica | Informativo |
| `01_DEEP_RESEARCH/02_R_PACKAGES_RQR_MASTER.md` | Evidencia R | Informativo |
| `01_DEEP_RESEARCH/03_STATA_PACKAGES_RQR_MASTER.md` | Evidencia Stata | Informativo |
| `01_DEEP_RESEARCH/04_GRAPHICS_TESTS_DIAGNOSTICS_MASTER.md` | Evidencia graficos/tests | Informativo |
| `01_DEEP_RESEARCH/05_OPEN_DATASETS_CASEBANK_MASTER.md` | Evidencia datasets | Informativo |
| `01_DEEP_RESEARCH/06_STATA_JOURNAL_SOFTWARE_ARTICLES_MASTER.md` | Evidencia editorial/SJ | Informativo |
| `02_IMPLEMENTATION_MASTERS/07_ALGORITHM_PSEUDOCODE_MASTER.md` | Pseudocodigo | Subordinado a `09` |
| `02_IMPLEMENTATION_MASTERS/08_TESTING_QC_BENCHMARK_MASTER.md` | Diseno inicial testing | Subordinado a testing rules |
| `02_IMPLEMENTATION_MASTERS/09_STATA_PACKAGE_ARCHITECTURE_MASTER.md` | Arquitectura/API/fases | Normativo |
| `02_IMPLEMENTATION_MASTERS/10_AGENT_RULES_FOR_QRESID.md` | Operacion de agentes | Normativo |
| `03_REPO_REVIEW/QRESID_CURRENT_REPO_AUDIT.md` | Ninguna | Vacio |
| `03_REPO_REVIEW/QRESID_ROADMAP_PHASED_UPDATES.md` | Ninguna | Vacio |
| `03_REPO_REVIEW/WEIGHTS_RQR_EVIDENCE_REVIEW.md` | Evidencia pesos/RQR | Informativo; obligatorio antes de activar pesos |
| `04_RETRIEVAL_CONTEXT/RETRIEVAL_MAP_FOR_QRESID.md` | Retrieval | Normativo |
| `04_RETRIEVAL_CONTEXT/SOURCE_ACCESS_LOG.md` | Trazabilidad de fuentes | Activo con rutas a revisar |
| `04_RETRIEVAL_CONTEXT/STATA_MINIMAL_PROGRAMMING_NOTES.md` | Stata/Mata practico | Normativo local |
| `04_RETRIEVAL_CONTEXT/STATA_MODEL_EXTRACTION_RULES.md` | Extraccion general | Normativo local |
| `04_RETRIEVAL_CONTEXT/GLM_POSTESTIMATION_RULES.md` | Extraccion GLM/regress/binomial/Gamma | Normativo local |
| `04_RETRIEVAL_CONTEXT/COUNT_MODELS_EXTRACTION_RULES.md` | Extraccion count/NB/ZI | Normativo local |
| `04_RETRIEVAL_CONTEXT/MIXED_MODELS_EXTRACTION_RULES.md` | Extraccion mixed/panel/GSEM | Futuro/pendiente |
| `04_RETRIEVAL_CONTEXT/STATA_BUILTIN_COMMANDS_MAP.md` | Comandos/funciones Stata | Normativo local |
| `04_RETRIEVAL_CONTEXT/STATA_NUMERICAL_STABILITY_RULES.md` | Numerica | Normativo |
| `04_RETRIEVAL_CONTEXT/STATA_PACKAGE_STYLE_RULES.md` | Estilo/package | Normativo |
| `04_RETRIEVAL_CONTEXT/STATA_R_BENCHMARK_MAPPING.md` | Benchmark R-Stata | Normativo |
| `04_RETRIEVAL_CONTEXT/STATA_TESTING_CERTIFICATION_RULES.md` | Tests/certificacion | Normativo |
| `05_MCP_STATA_EXECUTION/*.md` | Ninguna | Vacio |

## 4. Documentos que deben mantenerse intactos por ahora

- `AGENTS.md`
- `02_IMPLEMENTATION_MASTERS/09_STATA_PACKAGE_ARCHITECTURE_MASTER.md`
- `02_IMPLEMENTATION_MASTERS/10_AGENT_RULES_FOR_QRESID.md`
- `04_RETRIEVAL_CONTEXT/RETRIEVAL_MAP_FOR_QRESID.md`

Estos documentos son el andamiaje actual. Cualquier limpieza debe ocurrir mediante queue de conflictos, no edicion oportunista. Gamma queda resuelto como Fase 1 por decision humana; pesos siguen subordinados a evidencia y aprobacion por familia.

