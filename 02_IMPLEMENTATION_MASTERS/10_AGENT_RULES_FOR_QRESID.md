# 10_AGENT_RULES_FOR_QRESID.md

## 1. Propósito

`ESTÁNDAR OFICIAL`: este documento define reglas operativas para agentes de programación que trabajen sobre `qresid`.

Su función es convertir la arquitectura, las reglas de retrieval, las reglas Stata/Mata y los criterios de validación en acciones obligatorias antes de leer, modificar, testear o documentar el paquete.

`RECOMENDACIÓN OPERATIVA`: usar este documento como checklist interno. No forma parte del paquete Stata final ni sustituye los masters técnicos.

---

## 2. Jerarquía de autoridad documental

Cuando haya conflicto, aplicar esta jerarquía tentativa y marcar el conflicto si no se puede resolver sin criterio humano:

| Nivel | Documento | Autoridad principal |
|---:|---|---|
| 1 | `AGENTS.md` | Router raíz, límites del workspace, prohibiciones globales. |
| 2 | `04_RETRIEVAL_CONTEXT/RETRIEVAL_MAP_FOR_QRESID.md` | Qué leer y en qué orden antes de actuar. |
| 3 | `02_IMPLEMENTATION_MASTERS/09_STATA_PACKAGE_ARCHITECTURE_MASTER.md` | Arquitectura, API, fases, dispatcher y responsabilidades. |
| 4 | `04_RETRIEVAL_CONTEXT/STATA_NUMERICAL_STABILITY_RULES.md` | CDF, endpoints, PIT, clipping, tolerancias y abortos numéricos. |
| 5 | `04_RETRIEVAL_CONTEXT/STATA_TESTING_CERTIFICATION_RULES.md` | Tests, certificación, logs y criterios de aceptación. |
| 6 | `04_RETRIEVAL_CONTEXT/STATA_R_BENCHMARK_MAPPING.md` | Benchmarks R-Stata y reglas de `uvar()`. |
| 7 | `04_RETRIEVAL_CONTEXT/STATA_PACKAGE_STYLE_RULES.md` | Estilo público, help, examples, SSC/Stata Journal. |
| 8 | Reglas de extracción por familia | Comandos, `predict`, parámetros, offsets, pesos y soporte local. |

`HUMAN_DECISION_REQUIRED`: si dos documentos del mismo nivel o niveles cercanos difieren sobre fase, API o soporte, no decidir por fecha ni por preferencia.

---

## 3. Reglas antes de leer código

- `ESTÁNDAR OFICIAL`: leer primero el contexto mínimo indicado por `RETRIEVAL_MAP_FOR_QRESID.md`.
- `ESTÁNDAR OFICIAL`: verificar si la tarea involucra implementación, tests, benchmarking, documentación pública o auditoría.
- `ESTÁNDAR OFICIAL`: identificar familia, comando Stata, fase y estado de evidencia antes de abrir código.
- `RECOMENDACIÓN OPERATIVA`: no abrir documentos de hurdle, truncated/censored no validados, mixed, `gsem` o `xt*` para tareas Fase 1 salvo que la tarea los mencione; ZIP/ZINB y truncados/censurados solo se abren para rutas extension-prerelease validadas o su auditoria activa.
- `EVIDENCIA PENDIENTE`: si una CDF, comando, extractor o parametrización aparece como pendiente, no inspeccionar código para “inferir” soporte no documentado.
- `RECOMENDACIÓN OPERATIVA`: registrar mentalmente qué documento gobierna la decisión antes de proponer cambios.

---

## 4. Reglas antes de modificar código

- `ESTÁNDAR OFICIAL`: no modificar `qresid/` sin leer el archivo específico de familia y las reglas de extracción aplicables.
- `ESTÁNDAR OFICIAL`: confirmar que el cambio pertenece a Fase 1 base o a una ruta `extension prerelease experimental` ya aprobada por reportes activos; fases posteriores requieren aprobacion explicita.
- `ESTÁNDAR OFICIAL`: todo cambio en CDF, PIT, RNG o `invnormal()` requiere leer `STATA_NUMERICAL_STABILITY_RULES.md`.
- `ESTÁNDAR OFICIAL`: todo cambio en dispatcher o soporte de comandos requiere leer `STATA_BUILTIN_COMMANDS_MAP.md`.
- `ESTÁNDAR OFICIAL`: todo cambio que use `predict`, `e()`, offset, exposure, pesos o muestra requiere leer `STATA_MODEL_EXTRACTION_RULES.md`.
- `RECOMENDACIÓN OPERATIVA`: implementar primero el error controlado para rutas fuera de fase.
- `HUMAN_DECISION_REQUIRED`: si el cambio exige elegir entre API alternativas no cerradas, detenerse.

---

## 5. Reglas antes de modificar tests

- `ESTÁNDAR OFICIAL`: leer `STATA_TESTING_CERTIFICATION_RULES.md`.
- `ESTÁNDAR OFICIAL`: leer `STATA_R_BENCHMARK_MAPPING.md` si el test compara con R.
- `ESTÁNDAR OFICIAL`: tests de CDF deben preceder tests de residuo final.
- `ESTÁNDAR OFICIAL`: en familias discretas, tests exactos de residuo contra R requieren `uvar()`.
- `RECOMENDACIÓN OPERATIVA`: separar unit, integration, r_benchmarks, helpers y certification.
- `ESTÁNDAR OFICIAL`: los tests deben fallar con `assert`, no solo imprimir discrepancias.
- `RECOMENDACIÓN OPERATIVA`: guardar tablas de discrepancia cuando un benchmark falle.

---

## 6. Reglas antes de modificar help o documentación pública

- `ESTÁNDAR OFICIAL`: leer `STATA_PACKAGE_STYLE_RULES.md`.
- `ESTÁNDAR OFICIAL`: no declarar soporte de un modelo si no existe implementación, help, ejemplo y test/certificación.
- `ESTÁNDAR OFICIAL`: no incluir teoría extensa en `.sthlp`.
- `ESTÁNDAR OFICIAL`: ejemplos deben ser ejecutables, con `version`, sin rutas absolutas, y con `set seed` si hay aleatorización.
- `RECOMENDACIÓN OPERATIVA`: documentar `uvar()` como ruta de reproducibilidad R-Stata, no como opción avanzada opcional.
- `ESTÁNDAR OFICIAL`: documentación pública no debe contener prompts, trazas, notas internas ni lenguaje de trabajo asistido.

---

## 7. Reglas de implementación Stata

- `ESTÁNDAR OFICIAL`: todo ado/do público debe iniciar con `version`.
- `ESTÁNDAR OFICIAL`: el comando principal debe usar `program qresid, rclass` salvo rediseño aprobado.
- `ESTÁNDAR OFICIAL`: usar `syntax`; no usar macros posicionales para la API pública.
- `ESTÁNDAR OFICIAL`: la API pública Fase 1 es `qresid newvarname [if] [in], options`; no aceptar `generate()` ni interfaz híbrida.
- `ESTÁNDAR OFICIAL`: `replace` no forma parte de Fase 1; si la variable de salida ya existe, fallar con error claro.
- `ESTÁNDAR OFICIAL`: `family()` es opción condicional; no debe contradecir `e(family)`.
- `ESTÁNDAR OFICIAL`: usar `marksample` y cruzar con `e(sample)`.
- `ESTÁNDAR OFICIAL`: usar `tempvar`, `tempname` y `tempfile` para objetos internos.
- `ESTÁNDAR OFICIAL`: crear `mu`, `xb`, `pr`, `n`, `F_low`, `F_high`, `V`, `U` y residuos como `double`.
- `ESTÁNDAR OFICIAL`: preferir `predict` para medias, probabilidades y predictores postestimación.
- `ESTÁNDAR OFICIAL`: no recalcular manualmente factor variables ni offsets si `predict` entrega el valor necesario.
- `ESTÁNDAR OFICIAL`: usar `display as err` y `exit #` para errores controlados.
- `RECOMENDACIÓN OPERATIVA`: usar `exit 198` para modelo fuera de fase o sintaxis no soportada; usar códigos más específicos si el error Stata es claro.

---

## 8. Reglas RQR

- `ESTÁNDAR OFICIAL`: validar soporte de `y` antes de evaluar CDF.
- `ESTÁNDAR OFICIAL`: calcular y validar `F(y-)` en distribuciones discretas.
- `ESTÁNDAR OFICIAL`: calcular y validar `F(y)` en todas las familias.
- `ESTÁNDAR OFICIAL`: verificar `0 <= F(y-) <= F(y) <= 1`.
- `ESTÁNDAR OFICIAL`: si `F(y) + tol < F(y-)`, abortar.
- `RECOMENDACIÓN OPERATIVA`: saturar errores leves de CDF solo dentro de tolerancia documentada.
- `ESTÁNDAR OFICIAL`: construir `U` dentro del intervalo PIT.
- `ESTÁNDAR OFICIAL`: validar `U` antes de `invnormal(U)`.
- `RECOMENDACIÓN OPERATIVA`: aplicar clipping documentado antes de `invnormal()` y devolver conteos de clipping en `r()`.
- `ESTÁNDAR OFICIAL`: `uvar()` es obligatorio para comparación exacta de residuos aleatorizados R-Stata.

---

## 9. Reglas de familias y fases

### Fase 1 permitida

- Gaussian: `regress`, `glm`.
- Bernoulli/binomial: `logit`, `logistic`, `binreg`, `glm`.
- Poisson: `poisson`, `glm`.
- Negative binomial: `nbreg`, `glm` solo con validación de `alpha/theta/k` y NB1/NB2.
- Gamma: Fase 1 activa con gate técnico de `phi`, forma/escala, CDF y benchmark R.

### Fase 2 postergada

- ZIP/ZINB ponderados, correlacionados o no validados.
- Hurdle.
- Truncados/censurados fuera de rutas unweighted ya validadas.
- PIT o diagnósticos simulados.

### Fase 2/3 o evidencia pendiente

- GLMM/GSEM/FMM.
- `me*`, `xt*`.
- Tweedie.
- COM-Poisson.
- Generalized Poisson.
- Beta-binomial.

### Extension prerelease experimental

- inverse Gaussian `glm` solo en rutas `READY_FOR_EXTENSION_PRERELEASE` listadas en la matriz viva.
- grouped binomial `glm, family(binomial trials)` y `binreg, n()` aliases validados.
- NB2 `nbreg, dispersion(mean)` con no-offset, `offset()` y `exposure()`.
- NB variants `nbreg, dispersion(constant)`, `gnbreg`, y fixed-parameter `glm, family(nbinomial #)`; `glm nbinomial ml` sigue gated.
- zero-inflated count `zip` y `zinb` sin pesos, con rutas validadas localmente.
- truncated count `tpoisson`, `ztp`, `tnbreg`, y `ztnb` sin pesos, con rutas validadas localmente.
- censored count `cpoisson` sin pesos, con rutas validadas localmente.
- direct `fweight` solo en combinaciones `READY_FOR_EXTENSION_PRERELEASE` validadas.
- direct `[pweight=]` solo como diagnostico model-based/Stata-only, no `svy:`.

`ESTÁNDAR OFICIAL`: estas rutas pueden documentarse como experimentales locales si los benchmarks y matrices vivas estan sincronizados. No son public RC ni soporte estable SSC.

`ESTÁNDAR OFICIAL`: comandos fuera de fase deben devolver error controlado o stub. No se permite cálculo parcial.

---

## 10. Reglas de benchmarking

- `ESTÁNDAR OFICIAL`: comparar por capas: datos, muestra, fórmula, offset/pesos, coeficientes, fitted values, parámetros accesorios, CDF endpoints, `U`, residuo.
- `ESTÁNDAR OFICIAL`: no comparar exactamente residuos aleatorizados R-Stata sin uniformes compartidos.
- `ESTÁNDAR OFICIAL`: usar `uvar()` para residuos finales exactos en discretas.
- `RECOMENDACIÓN OPERATIVA`: si falla el residuo, retroceder en cascada: muestra -> `mu/pr/n` -> parámetros -> CDF -> `U` -> residuo.
- `EVIDENCIA PENDIENTE`: si no existe benchmark R confiable o CDF Stata validada, no declarar soporte.
- `RECOMENDACIÓN OPERATIVA`: usar datasets pequeños y reproducibles antes de casebanks más grandes.

---

## 11. Reglas de reproducibilidad

- `ESTÁNDAR OFICIAL`: `seed()` solo garantiza reproducibilidad interna en Stata.
- `ESTÁNDAR OFICIAL`: tests con aleatorización deben fijar semilla.
- `RECOMENDACIÓN OPERATIVA`: guardar `c(rngstate)` si la prueba audita estado RNG.
- `ESTÁNDAR OFICIAL`: scripts de certificación deben abrir y cerrar logs en texto.
- `ESTÁNDAR OFICIAL`: tests y certificación deben correr sin interacción manual.
- `RECOMENDACIÓN OPERATIVA`: usar ID estable y orden estable cuando se importan uniformes externos.

---

## 12. Reglas de commits

- `ESTÁNDAR OFICIAL`: no commitear soporte de familia sin tests mínimos.
- `ESTÁNDAR OFICIAL`: no commitear cambios de API sin actualizar help, examples y tests.
- `ESTÁNDAR OFICIAL`: no commitear outputs temporales, logs innecesarios ni archivos scratch.
- `RECOMENDACIÓN OPERATIVA`: mantener commits pequeños por familia, componente o documento.
- `RECOMENDACIÓN OPERATIVA`: incluir en el mensaje de commit la familia/comando afectado y la capa validada.
- `HUMAN_DECISION_REQUIRED`: no commitear cambios que resuelven gaps de fase, API o CDF sin aprobación.

---

## 13. Post-change documentation synchronization

- `ESTANDAR OFICIAL`: despues de cualquier cambio, ejecutar `04_RETRIEVAL_CONTEXT/POST_CHANGE_DOCUMENTATION_SYNC.md`.
- `ESTANDAR OFICIAL`: revisar si cambiaron codigo, API, familias, benchmarks, tests, retrieval, lifecycle, MCP, help, changelog o readiness.
- `ESTANDAR OFICIAL`: no actualizar snapshots historicos como si fueran fuentes vivas; actualizar registry o crear resolution log.
- `ESTANDAR OFICIAL`: si no se ejecutaron tests, Stata, R o MCP, no marcar readiness como `READY`; usar `READY_PENDING_EXECUTION` o `NOT_VERIFIED`.
- `RECOMENDACION OPERATIVA`: si el unico cambio fue metadata lifecycle/registry/sync, no iniciar otro ciclo de actualizacion salvo inconsistencia directa.

Checklist post-cambio:

- [ ] Cambio codigo?
- [ ] Cambio API?
- [ ] Cambio familia soportada?
- [ ] Cambio benchmark?
- [ ] Cambio testing?
- [ ] Cambio retrieval?
- [ ] Cambio lifecycle status?
- [ ] Debe actualizarse changelog?
- [ ] Debe actualizarse help?
- [ ] Debe actualizarse readiness checklist?
- [ ] Debe marcarse algun review como superseded?
- [ ] Debe crearse resolution log?

---

## 14. Limpieza editorial

- `ESTÁNDAR OFICIAL`: el paquete final no debe contener prompts.
- `ESTÁNDAR OFICIAL`: el paquete final no debe contener traces, razonamientos internos, notas de agentes ni texto de desarrollo asistido.
- `ESTÁNDAR OFICIAL`: no copiar código externo ni fragmentos de fuentes externas dentro de `qresid`.
- `ESTÁNDAR OFICIAL`: no asumir licencias de repos externos.
- `ESTÁNDAR OFICIAL`: no inventar referencias.
- `RECOMENDACIÓN OPERATIVA`: mantener textos públicos breves, técnicos y verificables.
- `RECOMENDACIÓN OPERATIVA`: mover discusiones metodológicas largas fuera del `.sthlp`.

---

## 15. Reglas de detención

Detenerse y no modificar código si:

- `EVIDENCIA PENDIENTE`: falta CDF validada.
- `EVIDENCIA PENDIENTE`: no se puede extraer un parámetro esencial con `predict` o `e()`.
- `EVIDENCIA PENDIENTE`: parametrización R-Stata no está alineada.
- `EVIDENCIA PENDIENTE`: fuente documental clave está pendiente o restringida.
- `ESTÁNDAR OFICIAL`: Gamma es Fase 1 para modelos no ponderados `glm, family(gamma)` si pasan tests CDF y benchmark R; pesos en Gamma siguen bloqueados por la regla general de pesos.
- `ESTÁNDAR OFICIAL`: NB mean/constant, `gnbreg`, y fixed-parameter `glm nbinomial #` estan permitidos como extension prerelease experimental cuando benchmarks verdes; `glm nbinomial ml` sigue `HUMAN_DECISION_REQUIRED` o gated.
- `ESTÁNDAR OFICIAL`: direct `fweight` queda limitado a combinaciones validadas; otros pesos requieren regla final por familia.
- `ESTÁNDAR OFICIAL`: direct `[pweight=]` puede documentarse solo como diagnostico experimental/model-based/Stata-only; soporte survey/public RC requiere decisión humana explícita.
- `ESTÁNDAR OFICIAL`: API pública Fase 1 está cerrada; cambios futuros requieren aprobación humana y actualización de help/examples/tests/changelog.
- `ESTÁNDAR OFICIAL`: si un benchmark falla antes de CDF/PIT, no ajustar el residuo final para ocultar el fallo.

Crear issue o nota de revisión cuando el bloqueo sea reproducible, tenga archivo/familia/comando claro y no pueda resolverse con los documentos actuales.

---

## 16. Checklist antes de entregar cambios

- [ ] Se leyó el contexto mínimo requerido.
- [ ] Se ejecuto el checklist post-cambio si hubo modificaciones.
- [ ] Se identificó familia, comando, fase y estado de evidencia.
- [ ] No se modificó `qresid/` fuera del alcance.
- [ ] No se agregó soporte nuevo sin tests.
- [ ] No se calculan residuos fuera de `e(sample)`.
- [ ] Todas las variables CDF/PIT/residuo son `double`.
- [ ] `F(y-)`, `F(y)`, `U` e `invnormal(U)` tienen validación.
- [ ] Discretas usan `uvar()` para comparación exacta con R.
- [ ] Tests fallan con `assert`.
- [ ] Help/examples coinciden con la API real.
- [ ] No hay prompts, traces, notas internas ni código externo copiado.
- [ ] Gaps quedaron marcados como `EVIDENCIA PENDIENTE` o `HUMAN_DECISION_REQUIRED`.

---

## 17. Tabla situacional

| Situación | Acción obligatoria | Documentos a consultar | ¿Se permite modificar código? |
|---|---|---|---|
| Tarea nueva sin familia clara | Definir alcance y fase antes de abrir código | `AGENTS.md`, `RETRIEVAL_MAP_FOR_QRESID.md`, project brief | No |
| Cambio en dispatcher | Verificar comando, fase y extractor | `09`, `STATA_BUILTIN_COMMANDS_MAP.md`, extracción por familia | Sí, si Fase 1 y con tests |
| Cambio en `predict` o `e()` | Confirmar extractor y muestra | `STATA_MODEL_EXTRACTION_RULES.md`, familia específica | Sí, si documentado |
| Cambio en CDF/PIT | Validar endpoints, soporte, tolerancias | `STATA_NUMERICAL_STABILITY_RULES.md`, `07_ALGORITHM_PSEUDOCODE_MASTER.md` | Sí, si no hay `EVIDENCIA PENDIENTE` |
| Cambio en RNG | Separar `seed()` y `uvar()` | `STATA_R_BENCHMARK_MAPPING.md`, testing rules | Sí, con tests |
| Benchmark R-Stata | Comparar por capas y usar `uvar()` | `STATA_R_BENCHMARK_MAPPING.md`, testing rules | Solo si benchmark define fallo |
| Tests unitarios | Cubrir CDF, endpoints, soporte y PIT | `STATA_TESTING_CERTIFICATION_RULES.md` | Sí, en tests |
| Help o examples | Verificar soporte certificado | `STATA_PACKAGE_STYLE_RULES.md`, `09` | Sí, solo documentación |
| Familia fuera de Fase 1 base | Crear error controlado o issue, salvo ruta `extension prerelease experimental` ya aprobada | `09`, archivo de familia, retrieval map, matriz viva | Solo si hay gate y tests verdes |
| NB `alpha/theta/k` ambiguo | Marcar bloqueo | count rules, benchmark mapping, numerical rules | No |
| Gamma Fase 1 | Validar parametrización y benchmarks antes de claim público | `09`, numerical rules, testing rules | Sí, solo con tests |
| Pesos sin regla cerrada | No activar transformación final ni `sqrt(w_i)` global | extraction rules, numerical rules, testing rules, weights evidence review | No |
| Pweight diagnóstico | Investigar solo como survey/model-based diagnostic; no soporte RQR exacto | pweight diagnostic plan, weights matrix, benchmark rules | No, salvo tests/reportes diagnósticos |
| Archivo público contiene material interno | Remover antes de release | style rules, `AGENTS.md` | Sí, documentación |
| Fuente externa requerida | Revisar licencia y trazabilidad | source log, external repo rules si aplican | No copiar código |

---

## 18. Gaps y contradicciones registradas

- `ESTÁNDAR OFICIAL`: Gamma queda resuelto como Fase 1 para modelos no ponderados con validación técnica de `phi`, forma/escala, CDF y benchmark; pesos en Gamma siguen pendientes.
- `ESTÁNDAR OFICIAL`: NB mean/constant, `gnbreg`, y fixed-parameter `glm nbinomial #` quedan validados para extension prerelease; `glm nbinomial ml` y otras variantes no validadas siguen gated.
- `ESTÁNDAR OFICIAL`: truncados/censurados oficiales `tpoisson`, `ztp`, `tnbreg`, `ztnb`, y `cpoisson` quedan validados para extension prerelease en rutas unweighted; pesos y variantes no probadas siguen gated.
- `ESTÁNDAR OFICIAL`: direct `fweight` validado se limita a las combinaciones de la matriz viva; no usar `sqrt(w_i)` global.
- `HUMAN_DECISION_REQUIRED`: pweights requieren decisión de política survey antes de cualquier soporte público; hasta entonces solo diagnóstico experimental/model-based.
- `ESTÁNDAR OFICIAL`: API pública Fase 1 resuelta: `newvarname`, `family()` condicional, sin `replace`, sin `generate()` y `savev()` separado de `saveu()`.

`ESTÁNDAR OFICIAL`: estos gaps no bloquean documentación interna, pero bloquean claims públicos, soporte estable y release.

