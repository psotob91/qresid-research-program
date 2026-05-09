# RETRIEVAL_MAP_FOR_QRESID.md

Nota operativa 2026-05-10: antes de auditar `qresid/`, consultar `04_RETRIEVAL_CONTEXT/DOCUMENT_STATUS_REGISTRY.md` y cargar solo reportes `03_REPO_REVIEW/` marcados `ACTIVE` o `PARTIALLY_ACTIVE` para la tarea. Para readiness pre-MCP usar primero `03_REPO_REVIEW/PRE_MCP_FINAL_AUDIT.md`, `PRE_MCP_DECISION_QUEUE.md`, `PRE_MCP_PATCH_QUEUE.md` y `PRE_MCP_RESOLUTION_STATUS.md`.

Nota pre-MCP 2026-05-10: para preparar MCP, leer `03_REPO_REVIEW/PRE_MCP_RESOLUTION_LOG.md`, `03_REPO_REVIEW/MCP_READINESS_CHECKLIST.md`, `04_RETRIEVAL_CONTEXT/CANONICAL_TERMINOLOGY_FOR_QRESID.md` y los protocolos en `05_MCP_STATA_EXECUTION/`. `qresid_plan_rearmado_retrieval_mcp.md` es historico/deprecated y no se carga por defecto como instruccion activa.

Nota lifecycle 2026-05-10: antes de cargar cualquier `03_REPO_REVIEW/*.md`, consultar `04_RETRIEVAL_CONTEXT/DOCUMENT_STATUS_REGISTRY.md`. No cargar documentos `SUPERSEDED`, `ARCHIVED`, `OBSOLETE` o `DRAFT` salvo auditoria historica explicita.

## 0. Propósito

Documento operativo para decidir qué archivos de contexto leer antes de modificar, auditar, testear o documentar `qresid`.

Regla central: leer el mínimo contexto suficiente, priorizar documentos Markdown curados y detener la tarea cuando una familia, comando o CDF esté marcada como `EVIDENCIA PENDIENTE`.

---

## 1. Mapa de archivos disponibles

| Archivo | Uso principal | Estado de lectura por defecto |
|---|---|---|
| `AGENTS.md` | Router raíz para agentes: límites globales, fases, prohibiciones y regla de lectura previa | Leer al iniciar tareas de modificación, auditoría o documentación |
| `PROJECT_BRIEF_QRESID.md` | Alcance, fases, criterios generales, exclusiones, trazabilidad | Leer solo al iniciar una tarea nueva o revisar alcance |
| `07_ALGORITHM_PSEUDOCODE_MASTER.md` | Algoritmo RQR, endpoints CDF, familias, pseudocódigo Stata/Mata | Leer para implementar o auditar cálculo matemático |
| `08_TESTING_QC_BENCHMARK_MASTER.md` | Diseño de pruebas, QC, tolerancias, datasets, benchmarking | Leer para tests, certificación y benchmark |
| `09_STATA_PACKAGE_ARCHITECTURE_MASTER.md` | Arquitectura del paquete, API, dispatcher, outputs, returned results y fases de soporte | Leer antes de cambiar arquitectura, API pública, dispatcher u outputs |
| `10_AGENT_RULES_FOR_QRESID.md` | Reglas operativas para agentes antes de modificar código, tests o documentación | Leer antes de cualquier modificación de código, tests, benchmarks o documentación |
| `STATA_MODEL_EXTRACTION_RULES.md` | Extracción general desde modelos Stata: `e()`, `predict`, `e(sample)`, pesos, offset | Leer antes de tocar extracción postestimación |
| `GLM_POSTESTIMATION_RULES.md` | Reglas específicas para `glm`, `regress`, `logit`, `logistic`, `binreg` | Leer para GLM, Gaussian, binomial, Gamma |
| `COUNT_MODELS_EXTRACTION_RULES.md` | Reglas para `poisson`, `nbreg`, ZIP/ZINB, truncados, hurdle, mezclas | Leer para conteos e inflados/truncados |
| `MIXED_MODELS_EXTRACTION_RULES.md` | Reglas para `meglm`, `mepoisson`, `menbreg`, `melogit`, `xt*`, `gsem` | Leer solo si la tarea involucra modelos mixtos/panel/gsem |
| `STATA_MINIMAL_PROGRAMMING_NOTES.md` | Reglas mínimas Stata/Mata: `syntax`, `marksample`, temporales, logs, RNG, tests | Leer antes de modificar ado/do/Mata |
| `STATA_BUILTIN_COMMANDS_MAP.md` | Mapa operativo de comandos, funciones `predict`, stored results, funciones probabilísticas/CDF y estado de soporte por fases | Leer antes de modificar dispatchers, soporte de modelos o lógica de extracción |
| `STATA_NUMERICAL_STABILITY_RULES.md` | Reglas de estabilidad numérica, clipping, validación PIT/CDF, tolerancias y control RNG | Leer antes de modificar CDF, PIT, uniformización o transformaciones normales |
| `SOURCE_ACCESS_LOG.md` | Registro de fuentes disponibles, pendientes, restringidas o superseded usadas por retrieval y benchmarking | Leer antes de afirmar soporte documental o agregar nuevas referencias |
| `STATA_PACKAGE_STYLE_RULES.md` | Reglas editoriales, estructura SSC/Stata Journal, packaging y limpieza pública del repositorio | Leer antes de editar `.ado`, `.sthlp`, examples, certification o releases |
| `CANONICAL_TERMINOLOGY_FOR_QRESID.md` | Glosario operativo y terminos canonicos para fases, soporte, benchmark, RQR/PIT, extraction y MCP | Leer ante ambiguedad semantica o preparacion MCP |
| `DOCUMENT_LIFECYCLE_RULES.md` | Reglas de lifecycle, estados, superseding, anti-drift y anti-loop retrieval | Leer antes de crear auditorias, reviews, roadmaps o snapshots |
| `DOCUMENT_STATUS_REGISTRY.md` | Registro vigente de status, autoridad, superseding y politica de retrieval por documento | Leer antes de cargar snapshots, reportes `03_REPO_REVIEW/` o planes historicos |

---

## 2. Regla de retrieval mínimo

- `ESTÁNDAR OFICIAL`: usar el menor número posible de archivos.
- `ESTÁNDAR OFICIAL`: priorizar Markdown curados sobre PDFs completos o fuentes largas.
- `RECOMENDACIÓN OPERATIVA`: abrir primero el archivo más cercano a la tarea; abrir archivos adicionales solo si aparece una dependencia concreta.
- `RECOMENDACIÓN OPERATIVA`: no cargar teoría completa para tareas de programación si bastan reglas de extracción y pseudocódigo.
- `RECOMENDACIÓN OPERATIVA`: no cargar documentos de modelos mixtos, ZIP/ZINB, hurdle o GSEM para tareas de Fase 1 salvo que la tarea los mencione explícitamente.
- `EVIDENCIA PENDIENTE`: si el archivo operativo marca como pendiente un comando, parámetro, CDF o sintaxis de postestimación, no inventar implementación; crear issue, stub con error controlado o test pendiente.
- `RECOMENDACIÓN OPERATIVA`: no leer `SOURCE_ACCESS_LOG.md` para tareas puramente matemáticas o debugging local que no dependan de nuevas fuentes.
- `RECOMENDACIÓN OPERATIVA`: no leer `STATA_PACKAGE_STYLE_RULES.md` para derivaciones matemáticas o pruebas unitarias aisladas.
- `RECOMENDACIÓN OPERATIVA`: no leer `STATA_NUMERICAL_STABILITY_RULES.md` para revisiones editoriales sin cálculos numéricos.
- `RECOMENDACIÓN OPERATIVA`: no leer `STATA_BUILTIN_COMMANDS_MAP.md` para tareas exclusivamente narrativas o conceptuales.
- `ESTÁNDAR OFICIAL`: si hay conflicto entre documentos, detenerse, reportar la contradicción y no decidir por fecha, preferencia o conveniencia.
- `ESTÁNDAR OFICIAL`: antes de cargar reportes `03_REPO_REVIEW/*.md`, revisar `DOCUMENT_STATUS_REGISTRY.md`.
- `ESTÁNDAR OFICIAL`: no cargar documentos `SUPERSEDED`, `ARCHIVED`, `OBSOLETE` o `DRAFT` salvo auditoria historica explicita.
- `RECOMENDACIÓN OPERATIVA`: cargar snapshots `PARTIALLY_ACTIVE` solo por el tema registrado en el registry.

---

## 3. Qué leer por tipo de tarea

| Tipo de tarea | Archivos mínimos requeridos | Archivos condicionales | No leer por defecto |
|---|---|---|---|
| Tarea nueva o cambio de alcance | `AGENTS.md`, `PROJECT_BRIEF_QRESID.md`, `RETRIEVAL_MAP_FOR_QRESID.md` | `10_AGENT_RULES_FOR_QRESID.md` si habrá modificación | Documentos de familia no involucrada |
| Modificar código ado/Mata | `AGENTS.md`, `10_AGENT_RULES_FOR_QRESID.md`, `STATA_MINIMAL_PROGRAMMING_NOTES.md`, archivo específico de familia | `09_STATA_PACKAGE_ARCHITECTURE_MASTER.md`, `STATA_MODEL_EXTRACTION_RULES.md`, `STATA_NUMERICAL_STABILITY_RULES.md` según alcance | Modelos fuera de fase |
| Cambiar arquitectura, API, dispatcher, outputs o returned results | `AGENTS.md`, `10_AGENT_RULES_FOR_QRESID.md`, `09_STATA_PACKAGE_ARCHITECTURE_MASTER.md`, `STATA_PACKAGE_STYLE_RULES.md` | `STATA_BUILTIN_COMMANDS_MAP.md`, `STATA_MODEL_EXTRACTION_RULES.md` si cambia soporte de comandos | Teoría matemática extensa |
| Teoría matemática RQR | `07_ALGORITHM_PSEUDOCODE_MASTER.md` | `PROJECT_BRIEF_QRESID.md` si hay duda de alcance | `MIXED_MODELS_EXTRACTION_RULES.md`, PDFs completos |
| Implementar Poisson | `07_ALGORITHM_PSEUDOCODE_MASTER.md`, `COUNT_MODELS_EXTRACTION_RULES.md`, `STATA_MINIMAL_PROGRAMMING_NOTES.md` | `08_TESTING_QC_BENCHMARK_MASTER.md`, `STATA_NUMERICAL_STABILITY_RULES.md` | `MIXED_MODELS_EXTRACTION_RULES.md` |
| Implementar NB | `07_ALGORITHM_PSEUDOCODE_MASTER.md`, `COUNT_MODELS_EXTRACTION_RULES.md`, `STATA_MODEL_EXTRACTION_RULES.md` | `08_TESTING_QC_BENCHMARK_MASTER.md`, `STATA_NUMERICAL_STABILITY_RULES.md` | `MIXED_MODELS_EXTRACTION_RULES.md` |
| Implementar Gaussian/regress | `07_ALGORITHM_PSEUDOCODE_MASTER.md`, `GLM_POSTESTIMATION_RULES.md`, `STATA_MINIMAL_PROGRAMMING_NOTES.md` | `STATA_MODEL_EXTRACTION_RULES.md`, `STATA_NUMERICAL_STABILITY_RULES.md` | ZIP/ZINB/mixed docs |
| Implementar binomial/logit/binreg | `07_ALGORITHM_PSEUDOCODE_MASTER.md`, `GLM_POSTESTIMATION_RULES.md`, `STATA_MODEL_EXTRACTION_RULES.md` | `08_TESTING_QC_BENCHMARK_MASTER.md`, `STATA_NUMERICAL_STABILITY_RULES.md` | `MIXED_MODELS_EXTRACTION_RULES.md` |
| Implementar Gamma | `07_ALGORITHM_PSEUDOCODE_MASTER.md`, `GLM_POSTESTIMATION_RULES.md`, `STATA_MODEL_EXTRACTION_RULES.md` | `08_TESTING_QC_BENCHMARK_MASTER.md`, `STATA_NUMERICAL_STABILITY_RULES.md` | `COUNT_MODELS_EXTRACTION_RULES.md` salvo offset/count |
| Implementar inverse Gaussian | `07_ALGORITHM_PSEUDOCODE_MASTER.md`, `GLM_POSTESTIMATION_RULES.md` | `STATA_NUMERICAL_STABILITY_RULES.md`, fuente externa/CDF validada | Modelos inflados/mixtos |
| Implementar Tweedie | `07_ALGORITHM_PSEUDOCODE_MASTER.md`, `GLM_POSTESTIMATION_RULES.md` | `STATA_NUMERICAL_STABILITY_RULES.md`, fuente externa/CDF validada | Implementación directa sin evidencia |
| ZIP/ZINB | `COUNT_MODELS_EXTRACTION_RULES.md`, `07_ALGORITHM_PSEUDOCODE_MASTER.md` | `08_TESTING_QC_BENCHMARK_MASTER.md`, `STATA_NUMERICAL_STABILITY_RULES.md` | `MIXED_MODELS_EXTRACTION_RULES.md` salvo GSEM/FMM |
| Hurdle/truncados | `COUNT_MODELS_EXTRACTION_RULES.md`, `07_ALGORITHM_PSEUDOCODE_MASTER.md` | `STATA_NUMERICAL_STABILITY_RULES.md`, documentación oficial adicional | Fase 1 core |
| Modelos mixtos/panel/GSEM | `MIXED_MODELS_EXTRACTION_RULES.md`, `STATA_MODEL_EXTRACTION_RULES.md` | `08_TESTING_QC_BENCHMARK_MASTER.md`, `STATA_NUMERICAL_STABILITY_RULES.md` | Implementación analítica Fase 1 |
| Mata/vectorización | `STATA_MINIMAL_PROGRAMMING_NOTES.md`, `07_ALGORITHM_PSEUDOCODE_MASTER.md` | `STATA_MODEL_EXTRACTION_RULES.md` | Teoría extensa |
| Gráficos diagnósticos | `08_TESTING_QC_BENCHMARK_MASTER.md`, `PROJECT_BRIEF_QRESID.md` | documentos gráficos si existen | extracción avanzada no relacionada |
| Tests unitarios | `10_AGENT_RULES_FOR_QRESID.md`, `STATA_TESTING_CERTIFICATION_RULES.md`, `08_TESTING_QC_BENCHMARK_MASTER.md`, `07_ALGORITHM_PSEUDOCODE_MASTER.md` | archivo por familia, `STATA_NUMERICAL_STABILITY_RULES.md` | documentos de modelos no testeados |
| Benchmark R–Stata | `10_AGENT_RULES_FOR_QRESID.md`, `STATA_R_BENCHMARK_MAPPING.md`, `08_TESTING_QC_BENCHMARK_MASTER.md`, `STATA_MODEL_EXTRACTION_RULES.md`, archivo por familia | `07_ALGORITHM_PSEUDOCODE_MASTER.md`, `STATA_NUMERICAL_STABILITY_RULES.md` si hay discrepancia CDF | mixed/ZI si no aplica |
| Revisión SSC/Stata Journal | `PROJECT_BRIEF_QRESID.md`, `STATA_MINIMAL_PROGRAMMING_NOTES.md`, `08_TESTING_QC_BENCHMARK_MASTER.md`, `STATA_PACKAGE_STYLE_RULES.md` | archivos por familia implementada | teoría no usada |
| Agregar soporte a nuevo comando Stata | `STATA_BUILTIN_COMMANDS_MAP.md`, `STATA_MODEL_EXTRACTION_RULES.md`, archivo de familia correspondiente | `08_TESTING_QC_BENCHMARK_MASTER.md` | teoría extensa |
| Auditar estabilidad numérica | `STATA_NUMERICAL_STABILITY_RULES.md`, `07_ALGORITHM_PSEUDOCODE_MASTER.md` | archivo de familia | documentación editorial |
| Preparar MCP / readiness | `AGENTS.md`, `RETRIEVAL_MAP_FOR_QRESID.md`, `CANONICAL_TERMINOLOGY_FOR_QRESID.md`, `03_REPO_REVIEW/MCP_READINESS_CHECKLIST.md`, `03_REPO_REVIEW/PRE_MCP_RESOLUTION_LOG.md`, `05_MCP_STATA_EXECUTION/README_MCP_STATA.md` | protocolos Stata/R/Codex si se ejecutara localmente | `qresid_plan_rearmado_retrieval_mcp.md` salvo auditoria historica |
| Verificar trazabilidad documental | `SOURCE_ACCESS_LOG.md`, `PROJECT_BRIEF_QRESID.md` | documentos metodológicos específicos | tests y benchmarking |
| Preparar release público | `AGENTS.md`, `10_AGENT_RULES_FOR_QRESID.md`, `09_STATA_PACKAGE_ARCHITECTURE_MASTER.md`, `STATA_PACKAGE_STYLE_RULES.md`, `PROJECT_BRIEF_QRESID.md`, `08_TESTING_QC_BENCHMARK_MASTER.md` | archivos implementados por familia | teoría no usada |

---

## 4. Orden recomendado de lectura

### 4.1 Auditoría técnica

1. `AGENTS.md`
2. `10_AGENT_RULES_FOR_QRESID.md`
3. `PROJECT_BRIEF_QRESID.md`
4. `STATA_MINIMAL_PROGRAMMING_NOTES.md`
5. `STATA_MODEL_EXTRACTION_RULES.md`
6. Archivo específico de familia: `GLM_POSTESTIMATION_RULES.md`, `COUNT_MODELS_EXTRACTION_RULES.md` o `MIXED_MODELS_EXTRACTION_RULES.md`
7. `08_TESTING_QC_BENCHMARK_MASTER.md`
8. `STATA_NUMERICAL_STABILITY_RULES.md` si la auditoría involucra CDF/PIT/RNG
9. `STATA_BUILTIN_COMMANDS_MAP.md` si la auditoría involucra dispatchers o soporte de comandos

### 4.1b Arquitectura o API

1. `AGENTS.md`
2. `10_AGENT_RULES_FOR_QRESID.md`
3. `09_STATA_PACKAGE_ARCHITECTURE_MASTER.md`
4. `STATA_PACKAGE_STYLE_RULES.md`
5. `STATA_BUILTIN_COMMANDS_MAP.md` si cambia dispatcher o soporte de comandos
6. `STATA_MODEL_EXTRACTION_RULES.md` si cambia extracción postestimación

### 4.2 Implementación de nueva familia Fase 1

1. `AGENTS.md`
2. `10_AGENT_RULES_FOR_QRESID.md`
3. `09_STATA_PACKAGE_ARCHITECTURE_MASTER.md`
4. `07_ALGORITHM_PSEUDOCODE_MASTER.md`
5. Archivo específico de familia
6. `STATA_MODEL_EXTRACTION_RULES.md`
7. `STATA_MINIMAL_PROGRAMMING_NOTES.md`
8. `08_TESTING_QC_BENCHMARK_MASTER.md`
9. `STATA_NUMERICAL_STABILITY_RULES.md`

### 4.3 Debugging

1. Archivo específico de familia
2. `STATA_MODEL_EXTRACTION_RULES.md`
3. `STATA_MINIMAL_PROGRAMMING_NOTES.md`
4. `08_TESTING_QC_BENCHMARK_MASTER.md`
5. `07_ALGORITHM_PSEUDOCODE_MASTER.md` solo si la discrepancia es matemática
6. `STATA_NUMERICAL_STABILITY_RULES.md` si hay overflow/underflow o clipping

### 4.4 Benchmarking

1. `08_TESTING_QC_BENCHMARK_MASTER.md`
2. Archivo específico de familia
3. `STATA_MODEL_EXTRACTION_RULES.md`
4. `07_ALGORITHM_PSEUDOCODE_MASTER.md`
5. `STATA_NUMERICAL_STABILITY_RULES.md`

### 4.5 Tests/certificación

1. `AGENTS.md`
2. `10_AGENT_RULES_FOR_QRESID.md`
3. `STATA_TESTING_CERTIFICATION_RULES.md`
4. `08_TESTING_QC_BENCHMARK_MASTER.md`
5. `STATA_R_BENCHMARK_MAPPING.md` si hay comparación R–Stata
6. `STATA_MINIMAL_PROGRAMMING_NOTES.md`
7. Archivo específico de familia
8. `STATA_MODEL_EXTRACTION_RULES.md`
9. `STATA_NUMERICAL_STABILITY_RULES.md`
10. `STATA_PACKAGE_STYLE_RULES.md` antes de release público

### 4.6 Documentación pública

1. `AGENTS.md`
2. `10_AGENT_RULES_FOR_QRESID.md`
3. `09_STATA_PACKAGE_ARCHITECTURE_MASTER.md`
4. `PROJECT_BRIEF_QRESID.md`
5. `07_ALGORITHM_PSEUDOCODE_MASTER.md`
6. `08_TESTING_QC_BENCHMARK_MASTER.md`
7. `STATA_PACKAGE_STYLE_RULES.md`
8. Archivos de extracción solo para comandos documentados

---

## 5. Reglas antes de modificar código

### 5.1 Siempre leer

- `AGENTS.md`
- `10_AGENT_RULES_FOR_QRESID.md`
- `STATA_MINIMAL_PROGRAMMING_NOTES.md`
- Archivo específico del modelo o familia
- `09_STATA_PACKAGE_ARCHITECTURE_MASTER.md` si se toca arquitectura, API, dispatcher, outputs o returned results
- `STATA_MODEL_EXTRACTION_RULES.md` si se toca `predict`, `e()`, pesos, offset o muestra
- `STATA_NUMERICAL_STABILITY_RULES.md` si se toca CDF, PIT, clipping o RNG
- `STATA_BUILTIN_COMMANDS_MAP.md` si se modifica soporte de comandos o dispatchers

### 5.2 Checklist mínimo

- [ ] `ESTÁNDAR OFICIAL`: verificar `e(cmd)` antes de calcular residuos.
- [ ] `ESTÁNDAR OFICIAL`: restringir a `e(sample)` por defecto.
- [ ] `ESTÁNDAR OFICIAL`: usar `syntax`, `marksample`, `tempvar`, `tempname`, `tempfile`.
- [ ] `ESTÁNDAR OFICIAL`: usar `double` en CDF, PIT y residuos.
- [ ] `ESTÁNDAR OFICIAL`: controlar RNG con `version #` y `set seed` si hay aleatorización.
- [ ] `RECOMENDACIÓN OPERATIVA`: extraer `mu`/`n`/`pr` vía `predict` antes de recalcular manualmente `xb`.
- [ ] `RECOMENDACIÓN OPERATIVA`: no sumar dos veces el offset.
- [ ] `RECOMENDACIÓN OPERATIVA`: crear stubs con error claro para comandos fuera de fase.
- [ ] `ESTÁNDAR OFICIAL`: validar clipping antes de `invnormal()`.
- [ ] `ESTÁNDAR OFICIAL`: abortar si `F_low > F_high` de forma severa.
- [ ] `RECOMENDACIÓN OPERATIVA`: revisar `STATA_PACKAGE_STYLE_RULES.md` antes de exponer cambios públicos.

---

## 6. Reglas antes de tocar tests

- Leer `08_TESTING_QC_BENCHMARK_MASTER.md`.
- Leer `STATA_MINIMAL_PROGRAMMING_NOTES.md` para logs, seeds, `assert`, `master.do`.
- Leer archivo de familia para parámetros y CDF.
- Leer `STATA_NUMERICAL_STABILITY_RULES.md` para tolerancias y clipping.
- Mantener separación:
  - `tests/unit/`
  - `tests/integration/`
  - `tests/r_benchmarks/`
  - `certification/`
- No aceptar tests que comparen residuos aleatorizados entre R y Stata sin uniformes externos.

---

## 7. Reglas antes de agregar familias nuevas

- [ ] Confirmar que la CDF está definida y evaluable.
- [ ] Confirmar que los parámetros necesarios se pueden extraer de Stata.
- [ ] Confirmar que existe benchmark R reproducible.
- [ ] Confirmar tolerancias y casos extremos.
- [ ] Agregar primero tests deterministas de CDF.
- [ ] Agregar después tests de `uvar()`.
- [ ] Agregar al final tests de `seed()` y distribución agregada.
- [ ] Verificar `STATA_BUILTIN_COMMANDS_MAP.md` para soporte real del comando.
- [ ] Revisar `SOURCE_ACCESS_LOG.md` antes de declarar soporte documental.
- [ ] Si no se cumple alguno de estos puntos, marcar `EVIDENCIA PENDIENTE`.

---

## 8. Cuándo detenerse

Detener implementación y abrir issue/stub cuando ocurra cualquiera de estos casos:

- `EVIDENCIA PENDIENTE`: no está clara la sintaxis `predict` para obtener parámetros esenciales.
- `EVIDENCIA PENDIENTE`: no existe CDF nativa, Mata/plugin o benchmark externo validado.
- `EVIDENCIA PENDIENTE`: la parametrización R–Stata no está alineada.
- `EVIDENCIA PENDIENTE`: `SOURCE_ACCESS_LOG.md` marca la fuente clave como `PENDING` o `RESTRICTED`.
- `RECOMENDACIÓN OPERATIVA`: los modelos mixtos, panel, `gsem`, ZIP/ZINB, hurdle y truncados no deben bloquear Fase 1.
- `RECOMENDACIÓN OPERATIVA`: para Fase 1, devolver error controlado en modelos fuera de soporte.

---

## 9. Tabla maestra: tarea → archivos mínimos requeridos

| Tarea | Archivos mínimos requeridos |
|---|---|
| Iniciar tarea nueva | `AGENTS.md`, `PROJECT_BRIEF_QRESID.md`, `RETRIEVAL_MAP_FOR_QRESID.md` |
| Modificar código ado/Mata | `AGENTS.md`, `10_AGENT_RULES_FOR_QRESID.md`, `STATA_MINIMAL_PROGRAMMING_NOTES.md`, archivo específico de familia |
| Cambiar arquitectura, API, dispatcher, outputs o returned results | `AGENTS.md`, `10_AGENT_RULES_FOR_QRESID.md`, `09_STATA_PACKAGE_ARCHITECTURE_MASTER.md`, `STATA_PACKAGE_STYLE_RULES.md` |
| Auditar `qresid/` tras auditoria documental | `AGENTS.md`, `RETRIEVAL_MAP_FOR_QRESID.md`, `DOCUMENT_STATUS_REGISTRY.md`, `09_STATA_PACKAGE_ARCHITECTURE_MASTER.md`, `10_AGENT_RULES_FOR_QRESID.md`, reportes `03_REPO_REVIEW/` marcados `ACTIVE` o `PARTIALLY_ACTIVE` para la tarea |
| Crear dispatcher de comandos soportados | `AGENTS.md`, `10_AGENT_RULES_FOR_QRESID.md`, `09_STATA_PACKAGE_ARCHITECTURE_MASTER.md`, `PROJECT_BRIEF_QRESID.md`, `STATA_MODEL_EXTRACTION_RULES.md`, `STATA_BUILTIN_COMMANDS_MAP.md`, `STATA_MINIMAL_PROGRAMMING_NOTES.md` |
| Implementar `qresid` para `poisson` | `AGENTS.md`, `10_AGENT_RULES_FOR_QRESID.md`, `09_STATA_PACKAGE_ARCHITECTURE_MASTER.md`, `07_ALGORITHM_PSEUDOCODE_MASTER.md`, `COUNT_MODELS_EXTRACTION_RULES.md`, `STATA_MINIMAL_PROGRAMMING_NOTES.md`, `STATA_NUMERICAL_STABILITY_RULES.md` |
| Implementar `qresid` para `nbreg` | `AGENTS.md`, `10_AGENT_RULES_FOR_QRESID.md`, `09_STATA_PACKAGE_ARCHITECTURE_MASTER.md`, `07_ALGORITHM_PSEUDOCODE_MASTER.md`, `COUNT_MODELS_EXTRACTION_RULES.md`, `STATA_MODEL_EXTRACTION_RULES.md`, `STATA_NUMERICAL_STABILITY_RULES.md` |
| Implementar `qresid` para `glm, family(poisson)` | `AGENTS.md`, `10_AGENT_RULES_FOR_QRESID.md`, `09_STATA_PACKAGE_ARCHITECTURE_MASTER.md`, `07_ALGORITHM_PSEUDOCODE_MASTER.md`, `GLM_POSTESTIMATION_RULES.md`, `STATA_MODEL_EXTRACTION_RULES.md`, `STATA_NUMERICAL_STABILITY_RULES.md` |
| Implementar `qresid` para Gaussian/regress | `AGENTS.md`, `10_AGENT_RULES_FOR_QRESID.md`, `09_STATA_PACKAGE_ARCHITECTURE_MASTER.md`, `07_ALGORITHM_PSEUDOCODE_MASTER.md`, `GLM_POSTESTIMATION_RULES.md`, `STATA_MINIMAL_PROGRAMMING_NOTES.md`, `STATA_NUMERICAL_STABILITY_RULES.md` |
| Implementar `qresid` para binomial/logit/binreg | `AGENTS.md`, `10_AGENT_RULES_FOR_QRESID.md`, `09_STATA_PACKAGE_ARCHITECTURE_MASTER.md`, `07_ALGORITHM_PSEUDOCODE_MASTER.md`, `GLM_POSTESTIMATION_RULES.md`, `STATA_MODEL_EXTRACTION_RULES.md`, `STATA_NUMERICAL_STABILITY_RULES.md` |
| Implementar `qresid` para Gamma | `AGENTS.md`, `10_AGENT_RULES_FOR_QRESID.md`, `09_STATA_PACKAGE_ARCHITECTURE_MASTER.md`, `07_ALGORITHM_PSEUDOCODE_MASTER.md`, `GLM_POSTESTIMATION_RULES.md`, `STATA_MODEL_EXTRACTION_RULES.md`, `STATA_NUMERICAL_STABILITY_RULES.md` |
| Explorar pesos/RQR | `AGENTS.md`, `10_AGENT_RULES_FOR_QRESID.md`, `03_REPO_REVIEW/WEIGHTS_RQR_EVIDENCE_REVIEW.md`, `STATA_MODEL_EXTRACTION_RULES.md`, `STATA_R_BENCHMARK_MAPPING.md`, `STATA_NUMERICAL_STABILITY_RULES.md` |
| Tests unitarios o integración | `AGENTS.md`, `10_AGENT_RULES_FOR_QRESID.md`, `STATA_TESTING_CERTIFICATION_RULES.md`, `08_TESTING_QC_BENCHMARK_MASTER.md`, archivo específico de familia, `STATA_NUMERICAL_STABILITY_RULES.md` |
| Benchmark R–Stata | `AGENTS.md`, `10_AGENT_RULES_FOR_QRESID.md`, `STATA_R_BENCHMARK_MAPPING.md`, `08_TESTING_QC_BENCHMARK_MASTER.md`, `STATA_MODEL_EXTRACTION_RULES.md`, archivo específico de familia |
| Documentación pública, examples o release | `AGENTS.md`, `10_AGENT_RULES_FOR_QRESID.md`, `09_STATA_PACKAGE_ARCHITECTURE_MASTER.md`, `STATA_PACKAGE_STYLE_RULES.md`, `PROJECT_BRIEF_QRESID.md` |
| Verificar trazabilidad documental | `AGENTS.md`, `10_AGENT_RULES_FOR_QRESID.md`, `SOURCE_ACCESS_LOG.md`, `PROJECT_BRIEF_QRESID.md` |
