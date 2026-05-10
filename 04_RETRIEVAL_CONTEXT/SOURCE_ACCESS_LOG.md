# SOURCE_ACCESS_LOG.md

## 0. Propósito

Registro operativo de fuentes usadas por los MD de retrieval y por futuras tareas de desarrollo, auditoría y certificación de `qresid`.

Regla central: no afirmar que una fuente fue leída si solo está listada. Este log distingue fuentes disponibles, pendientes, restringidas, no necesarias o superadas.

---

## 1. Estados permitidos

| Estado | Significado |
|---|---|
| `AVAILABLE` | Fuente local disponible y utilizable en el proyecto |
| `PENDING` | Fuente identificada pero aún no disponible localmente o no auditada |
| `RESTRICTED` | Fuente propietaria o con acceso limitado; no copiar texto largo |
| `NOT_NEEDED` | Fuente identificada pero no necesaria para la fase actual |
| `SUPERSEDED` | Fuente reemplazada por un MD curado o versión más reciente |

---

## 2. Fuentes internas del proyecto

| source_id | source_type | title | local_path_or_url | access_status | license_or_access_note | used_by_md | last_checked | notes |
|---|---|---|---|---|---|---|---|---|
| INT-001 | internal_md | PROJECT_BRIEF_QRESID.md | `00_PROJECT_CONTEXT/PROJECT_BRIEF_QRESID.md` | AVAILABLE | Proyecto interno | Todos | 2026-05-10 | Alcance, fases, reglas editoriales y trazabilidad |
| INT-002 | internal_md | RETRIEVAL_MAP_FOR_QRESID.md | `04_RETRIEVAL_CONTEXT/RETRIEVAL_MAP_FOR_QRESID.md` | AVAILABLE | Proyecto interno | Retrieval | 2026-05-10 | Incluye router, 09 y 10; debe incluir reportes `DOCUMENT_*` para auditoria repo |
| INT-003 | internal_md | STATA_MODEL_EXTRACTION_RULES.md | `04_RETRIEVAL_CONTEXT/STATA_MODEL_EXTRACTION_RULES.md` | AVAILABLE | Proyecto interno | Builtins, extracción | 2026-05-10 | Reglas generales `predict`, `e()`, `e(sample)` |
| INT-004 | internal_md | GLM_POSTESTIMATION_RULES.md | `04_RETRIEVAL_CONTEXT/GLM_POSTESTIMATION_RULES.md` | AVAILABLE | Proyecto interno | Builtins, estabilidad | 2026-05-10 | GLM, regress, logit, logistic, binreg |
| INT-005 | internal_md | COUNT_MODELS_EXTRACTION_RULES.md | `04_RETRIEVAL_CONTEXT/COUNT_MODELS_EXTRACTION_RULES.md` | AVAILABLE | Proyecto interno | Builtins, estabilidad | 2026-05-10 | Poisson, NB, ZIP/ZINB y modelos de conteo |
| INT-006 | internal_md | MIXED_MODELS_EXTRACTION_RULES.md | `04_RETRIEVAL_CONTEXT/MIXED_MODELS_EXTRACTION_RULES.md` | AVAILABLE | Proyecto interno | Builtins | 2026-05-10 | Modelos `me*`, `xt*`, `gsem` |
| INT-007 | internal_md | STATA_MINIMAL_PROGRAMMING_NOTES.md | `04_RETRIEVAL_CONTEXT/STATA_MINIMAL_PROGRAMMING_NOTES.md` | AVAILABLE | Proyecto interno | Builtins, style, estabilidad | 2026-05-10 | Ado/Mata, syntax, RNG, logs |
| INT-008 | internal_md | STATA_R_BENCHMARK_MAPPING.md | `04_RETRIEVAL_CONTEXT/STATA_R_BENCHMARK_MAPPING.md` | AVAILABLE | Proyecto interno | Estabilidad, style | 2026-05-10 | Comparación R–Stata por capas |
| INT-009 | internal_md | STATA_TESTING_CERTIFICATION_RULES.md | `04_RETRIEVAL_CONTEXT/STATA_TESTING_CERTIFICATION_RULES.md` | AVAILABLE | Proyecto interno | Style, estabilidad | 2026-05-10 | Tests, logs, certificación |
| INT-010 | internal_md | 07_ALGORITHM_PSEUDOCODE_MASTER.md | `02_IMPLEMENTATION_MASTERS/07_ALGORITHM_PSEUDOCODE_MASTER.md` | AVAILABLE | Proyecto interno | Estabilidad | 2026-05-10 | Algoritmos RQR, endpoints y familias |
| INT-011 | internal_md | 08_TESTING_QC_BENCHMARK_MASTER.md | `02_IMPLEMENTATION_MASTERS/08_TESTING_QC_BENCHMARK_MASTER.md` | AVAILABLE | Proyecto interno | Estabilidad, style | 2026-05-10 | QC, tolerancias y benchmarking |
| INT-012 | internal_md | STATA_BUILTIN_COMMANDS_MAP.md | `04_RETRIEVAL_CONTEXT/STATA_BUILTIN_COMMANDS_MAP.md` | AVAILABLE | Proyecto interno | Retrieval futuro | 2026-05-10 | Nuevo mapa de capacidades Stata |
| INT-013 | internal_md | STATA_NUMERICAL_STABILITY_RULES.md | `04_RETRIEVAL_CONTEXT/STATA_NUMERICAL_STABILITY_RULES.md` | AVAILABLE | Proyecto interno | Retrieval futuro | 2026-05-10 | Nuevo estándar numérico |
| INT-014 | internal_md | SOURCE_ACCESS_LOG.md | `04_RETRIEVAL_CONTEXT/SOURCE_ACCESS_LOG.md` | AVAILABLE | Proyecto interno | Retrieval futuro | 2026-05-10 | Este registro |
| INT-015 | internal_md | STATA_PACKAGE_STYLE_RULES.md | `04_RETRIEVAL_CONTEXT/STATA_PACKAGE_STYLE_RULES.md` | AVAILABLE | Proyecto interno | Retrieval futuro | 2026-05-10 | Nuevo estándar de paquete público |

---

## 3. Fuentes primarias Stata pendientes/restringidas

| source_id | source_type | title | local_path_or_url | access_status | license_or_access_note | used_by_md | last_checked | notes |
|---|---|---|---|---|---|---|---|---|
| STATA-001 | official_manual | Stata Programming Reference Manual | PENDING | PENDING | Documentación oficial; no copiar texto largo | Builtins, style | 2026-05-10 | Confirmar sintaxis avanzada de `syntax`, `marksample`, `ereturn` |
| STATA-002 | official_manual | Stata Mata Reference Manual | PENDING | PENDING | Documentación oficial; no copiar texto largo | Estabilidad, Mata | 2026-05-10 | Confirmar funciones CDF disponibles en Mata |
| STATA-003 | official_manual | Stata Base Reference Manual | PENDING | PENDING | Documentación oficial; no copiar texto largo | Builtins | 2026-05-10 | Confirmar funciones probabilísticas y `sort, stable` |
| STATA-004 | official_manual | Stata User’s Guide | PENDING | PENDING | Documentación oficial; no copiar texto largo | Style | 2026-05-10 | Convenciones generales de uso |
| STATA-005 | official_manual | Stata GLM manual | PENDING | PENDING | Documentación oficial; no copiar texto largo | GLM | 2026-05-10 | Confirmar `e(phi)`, `e(m)`, predict options |
| STATA-006 | official_manual | Stata Count manual | PENDING | PENDING | Documentación oficial; no copiar texto largo | Conteos | 2026-05-10 | Confirmar `nbreg`, `zip`, `zinb`, `tpoisson` |
| STATA-007 | official_manual | Stata Multilevel Mixed-Effects manual | PENDING | PENDING | Documentación oficial; no copiar texto largo | Mixed | 2026-05-10 | Confirmar `predict, distribution` y opciones condicional/marginal |
| STATA-008 | official_manual | Stata SEM/GSEM manual | PENDING | PENDING | Documentación oficial; no copiar texto largo | GSEM | 2026-05-10 | Confirmar `e(family#)`, `e(link#)`, CDF predictiva |

---

## 4. Help files oficiales Stata pendientes

| source_id | source_type | title | local_path_or_url | access_status | license_or_access_note | used_by_md | last_checked | notes |
|---|---|---|---|---|---|---|---|---|
| HELP-001 | official_help | `help glm` | Stata local help | PENDING | Verificar en Stata instalado | GLM | 2026-05-10 | Predict y stored results |
| HELP-002 | official_help | `help poisson` | Stata local help | PENDING | Verificar en Stata instalado | Conteos | 2026-05-10 | `predict, n` |
| HELP-003 | official_help | `help nbreg` | Stata local help | PENDING | Verificar en Stata instalado | Conteos | 2026-05-10 | Alpha/k y NB1/NB2 |
| HELP-004 | official_help | `help logit` | Stata local help | PENDING | Verificar en Stata instalado | Binario | 2026-05-10 | `predict, pr` |
| HELP-005 | official_help | `help logistic` | Stata local help | PENDING | Verificar en Stata instalado | Binario | 2026-05-10 | `e(cmd)` exacto |
| HELP-006 | official_help | `help binreg` | Stata local help | PENDING | Verificar en Stata instalado | Binomial | 2026-05-10 | `e(m)`, links |
| HELP-007 | official_help | `help predict` | Stata local help | PENDING | Verificar en Stata instalado | Todos | 2026-05-10 | Opciones por comando |
| HELP-008 | official_help | `help syntax` | Stata local help | PENDING | Verificar en Stata instalado | Style | 2026-05-10 | Interfaz pública |
| HELP-009 | official_help | `help marksample` | Stata local help | PENDING | Verificar en Stata instalado | Style | 2026-05-10 | Muestras `if/in` |
| HELP-010 | official_help | `help ereturn` | Stata local help | PENDING | Verificar en Stata instalado | Style | 2026-05-10 | Stored results |
| HELP-011 | official_help | `help return` | Stata local help | PENDING | Verificar en Stata instalado | Style | 2026-05-10 | `rclass` |
| HELP-012 | official_help | `help mata` | Stata local help | PENDING | Verificar en Stata instalado | Mata | 2026-05-10 | Integración ado/Mata |

---

## 5. Documentación R pendiente o disponible externamente

| source_id | source_type | title | local_path_or_url | access_status | license_or_access_note | used_by_md | last_checked | notes |
|---|---|---|---|---|---|---|---|---|
| R-001 | R_documentation | `statmod::qresiduals` | CRAN/manual local pendiente | PENDING | Documentación paquete R | Benchmark | 2026-05-10 | Referencia principal RQR |
| R-002 | R_documentation | `MASS::glm.nb` | CRAN/manual local pendiente | PENDING | Documentación paquete R | NB benchmark | 2026-05-10 | Parametrización theta |
| R-003 | R_documentation | `DHARMa` | CRAN/vignette pendiente | PENDING | Documentación paquete R | Simulados | 2026-05-10 | GLMM y PIT simulado |
| R-004 | R_documentation | `VGAM` | CRAN/manual local pendiente | PENDING | Documentación paquete R | Benchmark alternativo | 2026-05-10 | RQR en conteos avanzados |
| R-005 | R_documentation | `gamlss` | CRAN/manual local pendiente | PENDING | Documentación paquete R | Familias flexibles | 2026-05-10 | CDFs amplias |
| R-006 | R_documentation | `topmodels` | CRAN/manual local pendiente | PENDING | Documentación paquete R | PIT/residuals | 2026-05-10 | ZIP/hurdle/PIT |
| R-007 | R_documentation | `glmmTMB` | CRAN/manual local pendiente | PENDING | Documentación paquete R | GLMM/ZI | 2026-05-10 | Benchmarks Fase 2 |
| R-008 | R_documentation | `VGAM::genpoisson0/1/2` | local R package `VGAM` 1.1.14; CRAN refman | AVAILABLE | Package documentation; used for parameter mapping and positive-delta GP-0 CDF check | `QRESID_GENPOISSON_EXTENSION_AUDIT.md` | 2026-05-10 | `pgenpois0` matches pinned `st0279` PMF/CDF for positive delta with `theta=(1-delta)*mu`, `lambda=delta`; negative delta uses analytic CDF replay because modern VGAM restricts the fitted GP-0 lambda route. |
| R-009 | R_documentation | `glmmTMB::genpois` | local R package `glmmTMB` 1.1.14; online reference | AVAILABLE | Package documentation; secondary family evidence, not exact benchmark for `st0279` | `QRESID_GENPOISSON_EXTENSION_AUDIT.md` | 2026-05-10 | glmmTMB generalized Poisson uses a different variance parameterization; retained for future approximate/simulation work. |
| R-010 | R_documentation | `pscl::hurdle` | https://search.r-project.org/CRAN/refmans/pscl/html/hurdle.html | AVAILABLE_EXTERNAL_NOT_INSTALLED | Package documentation; local package not installed at gate creation | `QRESID_HURDLE_RQR_THEORY_AND_BENCHMARK.md` | 2026-05-10 | Candidate estimator benchmark for Poisson/NB hurdle count models if installed or otherwise authorized. |
| R-011 | R_documentation | `glmmTMB` hurdle count routes | local R package `glmmTMB` 1.1.14; https://glmmtmb.github.io/glmmTMB/reference/glmmTMB.html | AVAILABLE | Package documentation; possible zero component plus truncated count family estimator | `QRESID_HURDLE_RQR_THEORY_AND_BENCHMARK.md` | 2026-05-10 | Candidate R estimator and DHARMa simulation sanity route for non-correlated hurdle count models. |
| R-012 | R_documentation | `VGAM` zero-altered and positive-count families | local R package `VGAM` 1.1.14; https://www.rdocumentation.org/packages/VGAM/versions/1.1-14/topics/zanegbinomial | AVAILABLE | Package documentation; CDF/PIT replay candidate | `QRESID_HURDLE_RQR_THEORY_AND_BENCHMARK.md` | 2026-05-10 | Candidate CDF/distribution support for zero-altered and positive Poisson/NB hurdle layers. |
| R-013 | R_documentation | `topmodels::qresiduals` | https://rdrr.io/rforge/topmodels/man/qresiduals.html | AVAILABLE_EXTERNAL_NOT_INSTALLED | Package documentation; local package not installed at gate creation | `QRESID_HURDLE_RQR_THEORY_AND_BENCHMARK.md` | 2026-05-10 | Documents PIT/RQR interpretation for probabilistic model residuals; not required for qresid endpoint replay. |
| R-014 | R_documentation | `DHARMa` simulation residuals | local R package `DHARMa` 0.4.7 | AVAILABLE | Package documentation; simulation sanity only | `QRESID_HURDLE_RQR_THEORY_AND_BENCHMARK.md`, `QRESID_SIMULATED_PIT_BENCHMARK_AUDIT.md` | 2026-05-10 | Use only as `SIMULATION_SANITY_CHECK`; never as analytic CDF endpoint authority. |

---

## 5b. External Stata ado sources pinned for extension benchmarks

| source_id | source_type | title | local_path_or_url | access_status | license_or_access_note | used_by_md | last_checked | notes |
|---|---|---|---|---|---|---|---|---|
| STATA-EXT-001 | Stata_Journal_software | `st0279` / `gpoisson` generalized Poisson regression | `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/STATA/st0279`; article https://doi.org/10.1177/1536867X1201200412 | AVAILABLE_PINNED | Stata Journal software installed locally via `net install st0279`; do not copy external ado code into `qresid` | `QRESID_GENPOISSON_EXTENSION_AUDIT.md`, `QRESID_HILBE_COUNT_MODEL_COVERAGE_PLAN.md` | 2026-05-10 | Pinned files include `gpoisson.ado` version 1.1.0 11jun2011 and `gpois_lf.ado` version 1.0.0 31oct2006. `qresid` support is postestimation only and requires the external estimator to be installed separately. |
| STATA-EXT-002 | Stata_official_help | `churdle` Cragg hurdle regression | `C:\Program Files\StataNow19\ado\base\c\churdle.ado`; `churdle.sthlp`; https://www.stata.com/features/overview/hurdle-models/ | AVAILABLE_LOCAL_OFFICIAL | Official Stata command; not a count-hurdle Poisson/NB route | `QRESID_CHURDLE_CRAGG_GATE_AUDIT.md`, `QRESID_HURDLE_RQR_THEORY_AND_BENCHMARK.md` | 2026-05-10 | Treat separately as bounded/continuous Cragg hurdle gate; do not use as count-hurdle support evidence. |

---

## 6. Gaps prioritarios

| Gap | Prioridad | Para qué tarea se necesita | Acción |
|---|---:|---|---|
| Confirmar sintaxis exacta de `nbinomial()`/`nbinomialp()` | Alta | NB Fase 1 | Revisar help/Base/Mata manuals y crear unit tests |
| Confirmar extracción robusta de alpha/k en `nbreg` | Alta | NB Fase 1 | Revisar `help nbreg`, `ereturn list`, benchmarks |
| Confirmar argumentos exactos de `binomial()` | Alta | Binomial Fase 1 | Unit tests contra R |
| Confirmar `glm` Gamma parametrización Stata → CDF | Alta | Gamma Fase 1 | Benchmark con `statmod` |
| Confirmar CDF inverse Gaussian disponible/no disponible | Media | Decidir soporte Fase 1 | Revisar Base/Mata manuals |
| Confirmar predict options `zip/zinb` para inflación | Media | Fase 2 | Revisar Count manual/help |
| Confirmar `predict, distribution` en `me*` y `gsem` | Media | Fase 2/3 | Revisar Mixed/SEM manuals |
| Conseguir documentación local de paquetes R | Media | Certificación | Guardar versiones y session info |

---

## 7. Reglas de uso del log

- `ESTÁNDAR OFICIAL`: no marcar `AVAILABLE` una fuente que no esté localmente accesible o cuyo contenido no haya sido auditado.
- `ESTÁNDAR OFICIAL`: no copiar documentación propietaria larga en MD del proyecto.
- `RECOMENDACIÓN OPERATIVA`: si una fuente oficial confirma una regla ya usada, actualizar el estado de `EVIDENCIA PENDIENTE` a `ESTÁNDAR OFICIAL` en el MD correspondiente.
- `RECOMENDACIÓN OPERATIVA`: si una fuente contradice un MD curado, crear issue y no modificar silenciosamente la regla.
- `ESTÁNDAR OFICIAL`: registrar fecha `last_checked` con formato ISO `YYYY-MM-DD`.

---

## 8. Cómo actualizar el log

Al añadir una fuente:

1. Crear `source_id` único.
2. Definir `source_type`.
3. Registrar ruta local o URL.
4. Marcar `access_status` real.
5. Indicar licencia o nota de acceso.
6. Listar MD que la usan.
7. Actualizar `last_checked`.
8. Añadir nota de decisión si cambia una regla.

Al marcar una fuente como obsoleta:

1. Cambiar `access_status` a `SUPERSEDED`.
2. Indicar por qué fue reemplazada.
3. Apuntar a la nueva fuente.
4. No borrar la fila histórica.
