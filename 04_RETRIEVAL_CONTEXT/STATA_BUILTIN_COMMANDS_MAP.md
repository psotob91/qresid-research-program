# STATA_BUILTIN_COMMANDS_MAP.md

## 0. Propósito

Mapa operativo de comandos, funciones y capacidades nativas de Stata que puede usar `qresid` para extracción postestimación, cálculo CDF/PIT, aleatorización, testing y reproducibilidad.

Regla central: este archivo no reemplaza las reglas por familia. Solo indica qué capacidad Stata usar y qué archivo debe leerse antes de implementarla.

---

## 1. Comandos de estimación relevantes

| Comando | Estado en `qresid` | Familia principal | Extractor principal de media | Stored results relevantes | Riesgo principal | MD obligatorio antes de usar |
|---|---|---|---|---|---|---|
| `regress` | Fase 1 | Gaussian normal | `predict, xb` | `e(cmd)`, `e(depvar)`, `e(rmse)`, `e(b)`, `e(V)` | Confundir fitted con residuo; sigma debe ser positiva | `GLM_POSTESTIMATION_RULES.md` |
| `glm` | Fase 1 | Gaussian, binomial, Poisson, Gamma, NB si aplica | `predict, mu` | `e(cmd)`, `e(family)`, `e(link)`, `e(phi)`, `e(m)`, `e(offset)` | Doble manejo de offset; dispersión/familia mal alineada | `GLM_POSTESTIMATION_RULES.md`, `STATA_MODEL_EXTRACTION_RULES.md` |
| `poisson` | Fase 1 | Poisson | `predict, n` | `e(cmd)`, `e(depvar)`, `e(offset)`, `e(b)`, `e(V)` | `mu` extrema; exposición/offset duplicado | `COUNT_MODELS_EXTRACTION_RULES.md` |
| `nbreg` | Fase 1 con cautela | Negative binomial | `predict, n` | `e(cmd)`, `e(dispersion)`, `e(offset)`, `e(b)`, `e(V)` | Parametrización NB1/NB2 y extracción de alpha/k | `COUNT_MODELS_EXTRACTION_RULES.md` |
| `logit` | Fase 1 | Bernoulli/binomial 0/1 | `predict, pr` | `e(cmd)`, `e(depvar)`, `e(b)`, `e(V)` | Probabilidades extremas; outcome no codificado 0/1 | `GLM_POSTESTIMATION_RULES.md` |
| `logistic` | Fase 1 | Bernoulli/binomial 0/1 | `predict, pr` | `e(cmd)`, `e(depvar)`, `e(b)`, `e(V)` | Igual que `logit`; confirmar `e(cmd)` exacto | `GLM_POSTESTIMATION_RULES.md` |
| `binreg` | Fase 1 | Bernoulli/binomial agrupado | `predict, mu` | `e(cmd)`, `e(m)`, `e(linkf)`, `e(varfuncf)`, `e(offset)` | Número de ensayos y probabilidades fuera de rango | `GLM_POSTESTIMATION_RULES.md` |
| `zip` | Fase 2 | Zero-inflated Poisson | EVIDENCIA PENDIENTE | `e(cmd)`, `e(b)`, `e(V)` | Confundir CDF inflada con CDF Poisson base | `COUNT_MODELS_EXTRACTION_RULES.md` |
| `zinb` | Fase 2 | Zero-inflated NB | EVIDENCIA PENDIENTE | `e(cmd)`, `e(b)`, `e(V)`, dispersión pendiente | Inflación + parametrización NB | `COUNT_MODELS_EXTRACTION_RULES.md` |
| `meglm` | Fase 2 | GLMM general | `predict, mu` | `e(cmd)`, `e(family)`, `e(link)`, `e(dispersion)`, `e(binomial)` | CDF marginal/condicional; cuadratura lenta | `MIXED_MODELS_EXTRACTION_RULES.md` |
| `mepoisson` | Fase 2 | Poisson multinivel | `predict, mu` | `e(cmd)`, `e(cmd2)`, `e(family)`, `e(offset)` | Dependencia y CDF marginal intratable | `MIXED_MODELS_EXTRACTION_RULES.md` |
| `menbreg` | Fase 2 | NB multinivel | `predict, mu` | `e(cmd2)`, `e(family)`, `e(dispersion)`, `e(offset)` | Combinar sobredispersión y efectos aleatorios | `MIXED_MODELS_EXTRACTION_RULES.md` |
| `melogit` | Fase 2 | Bernoulli/binomial multinivel | `predict, mu` | `e(cmd2)`, `e(family)`, `e(binomial)`, `e(offset)` | CDF condicionada vs marginal | `MIXED_MODELS_EXTRACTION_RULES.md` |
| `gsem` | Fase 3 | Modelos latentes/mixtos/SEM | `predict, mu` / `predict, eta` | `e(cmd)`, `e(family#)`, `e(link#)`, `e(offset#)` | Múltiples outcomes, latentes, identificación | `MIXED_MODELS_EXTRACTION_RULES.md` |
| `xtpoisson` | Fase 2 / evidencia pendiente | Conteo panel | EVIDENCIA PENDIENTE | EVIDENCIA PENDIENTE | Dependencia longitudinal y predict options no auditadas | `MIXED_MODELS_EXTRACTION_RULES.md` |
| `xtnbreg` | Fase 2 / evidencia pendiente | NB panel | EVIDENCIA PENDIENTE | EVIDENCIA PENDIENTE | Parametrización y dependencia | `MIXED_MODELS_EXTRACTION_RULES.md` |
| `xtlogit` | Fase 2 / evidencia pendiente | Binario panel | EVIDENCIA PENDIENTE | EVIDENCIA PENDIENTE | Condicional vs marginal; soporte discreto | `MIXED_MODELS_EXTRACTION_RULES.md` |

---

## 2. Postestimación y stored results

| Capacidad | Uso en `qresid` | Estado | Riesgo | MD fuente |
|---|---|---|---|---|
| `predict` | Extraer `mu`, `n`, `pr`, `xb`, `eta` | ESTÁNDAR OFICIAL | Recalcular `xb` manualmente y duplicar offset | `STATA_MODEL_EXTRACTION_RULES.md` |
| `e(sample)` | Restringir cálculo a muestra estimada | ESTÁNDAR OFICIAL | Calcular residuos fuera del modelo ajustado | `STATA_MINIMAL_PROGRAMMING_NOTES.md` |
| `ereturn` | Leer resultados de estimación activos | ESTÁNDAR OFICIAL | Modificar `e()` desde postestimación | `STATA_MINIMAL_PROGRAMMING_NOTES.md` |
| `return` | Devolver conteos, flags y resúmenes de `qresid` | ESTÁNDAR OFICIAL | Confundir `r()` con `return()` | `STATA_MINIMAL_PROGRAMMING_NOTES.md` |
| `_b[]` | Recuperar coeficientes específicos, p. ej. `/lnalpha` si aplica | ESTÁNDAR OFICIAL | Nombre de coeficiente no portable | `STATA_MODEL_EXTRACTION_RULES.md` |
| `e(b)` | Copiar vector de coeficientes para auditoría | ESTÁNDAR OFICIAL | Perder stripes/nombres de ecuación | `STATA_MINIMAL_PROGRAMMING_NOTES.md` |
| `e(V)` | Copiar matriz de varianza-covarianza si se requiere | ESTÁNDAR OFICIAL | Usarla para tareas no necesarias en RQR básico | `STATA_MINIMAL_PROGRAMMING_NOTES.md` |

---

## 3. Funciones probabilísticas, CDF y cuantiles

| Función Stata/Mata | Uso esperado | Estado | Riesgo |
|---|---|---|---|
| `normal()` | CDF normal estándar para Gaussian y validaciones | ESTÁNDAR OFICIAL | Saturación en colas si se alimenta z extremo |
| `invnormal()` | Transformación final `r = invnormal(U)` | ESTÁNDAR OFICIAL | `U==0` o `U==1` produce valores infinitos/missing |
| `poisson()` | CDF Poisson `F(y; mu)` | ESTÁNDAR OFICIAL | Underflow/overflow con `mu` extrema |
| `binomial()` | CDF binomial | ESTÁNDAR OFICIAL | Confirmar orden exacto de argumentos antes de producción |
| `ibinomial()` | Función binomial inversa o relacionada | EVIDENCIA PENDIENTE | No usar para CDF RQR sin confirmación de sintaxis |
| `gammap()` | CDF gamma incompleta regularizada para Gamma | ESTÁNDAR OFICIAL | Parametrización forma/escala debe validarse |
| `nbinomial()` | CDF/probabilidad NB según sintaxis Stata | EVIDENCIA PENDIENTE | Confirmar parametrización exacta `k,p` y versión |
| `nbinomialp()` | Variante NB si está disponible | EVIDENCIA PENDIENTE | Confirmar disponibilidad, argumentos y equivalencia R |
| CDF inverse Gaussian | RQR inverse Gaussian | EVIDENCIA PENDIENTE | No nativa validada para Fase 1 |
| CDF Tweedie | RQR Tweedie | EVIDENCIA PENDIENTE | CDF aproximada/no cerrada |
| CDF COM-Poisson / generalized Poisson | Extensiones conteo | EVIDENCIA PENDIENTE | Requiere Mata/plugin/benchmark externo |

---

## 4. Comandos de programación Stata

| Comando | Uso en `qresid` | Estado | Error a evitar |
|---|---|---|---|
| `syntax` | Parsear `newvarname`, `if/in`, opciones `seed()`, `uvar()` | ESTÁNDAR OFICIAL | Macros posicionales en interfaz pública |
| `marksample` | Definir muestra solicitada por usuario | ESTÁNDAR OFICIAL | Ignorar `if/in` |
| `markout` | Excluir missings de variables adicionales | ESTÁNDAR OFICIAL | Usar variables extra sin limpiar missings |
| `tempvar` | Variables internas `mu`, `Flo`, `Fhi`, `U`, `V` | ESTÁNDAR OFICIAL | Crear variables fijas en datos del usuario |
| `tempname` | Matrices/escalars temporales | ESTÁNDAR OFICIAL | Sobrescribir objetos globales |
| `tempfile` | Outputs intermedios de tests | ESTÁNDAR OFICIAL | Guardar scratch permanente |
| `confirm` | Validar variables, nuevas variables, tipos | ESTÁNDAR OFICIAL | Fallos crípticos de Stata |
| `capture` | Interceptar errores esperados | ESTÁNDAR OFICIAL | Ocultar errores sin revisar `_rc` |
| `quietly` | Ejecutar cálculos sin ruido | ESTÁNDAR OFICIAL | Silenciar mensajes de error necesarios |
| `noisily` | Mostrar errores dentro de bloques silenciosos | ESTÁNDAR OFICIAL | Errores invisibles bajo `quietly` |
| `preserve` | Proteger dataset si se modifica estructura | ESTÁNDAR OFICIAL | Mutar datos del usuario |
| `restore` | Recuperar dataset tras operaciones temporales | ESTÁNDAR OFICIAL | Dejar dataset alterado tras error |

---

## 5. Reproducibilidad y testing

| Comando/capacidad | Uso | Estado | Riesgo |
|---|---|---|---|
| `version` | Primera línea ejecutable de ado/do | ESTÁNDAR OFICIAL | RNG/sintaxis no reproducible |
| `set seed` | Reproducibilidad interna Stata | ESTÁNDAR OFICIAL | Reclamar igualdad R-Stata sin `uvar()` |
| `c(rngstate)` | Registrar/restaurar estado RNG si aplica | ESTÁNDAR OFICIAL | No poder auditar aleatorización |
| `assert` | Tests unitarios, integración y certificación | ESTÁNDAR OFICIAL | Tests que no fallan ante errores |
| `log using` | Logs reproducibles de certificación | ESTÁNDAR OFICIAL | Evidencia no auditable |
| `set more off` | Ejecución desatendida | ESTÁNDAR OFICIAL | Scripts bloqueados por paginación |
| `sort, stable` | Orden reproducible con empates | ESTÁNDAR OFICIAL | Uniformes asignados a filas distintas |

---

## 6. Tabla maestra: tarea interna → capacidad Stata

| Tarea interna de `qresid` | Comando/función Stata | MD fuente | Riesgo |
|---|---|---|---|
| Confirmar modelo activo | `e(cmd)`, `e(cmd2)` | `STATA_MODEL_EXTRACTION_RULES.md` | Soportar accidentalmente un modelo no auditado |
| Restringir muestra | `e(sample)`, `marksample`, `markout` | `STATA_MINIMAL_PROGRAMMING_NOTES.md` | Cálculo fuera de muestra |
| Extraer media Poisson/NB clásica | `predict double ..., n` | `COUNT_MODELS_EXTRACTION_RULES.md` | Confundir tasa con número esperado |
| Extraer media GLM | `predict double ..., mu` | `GLM_POSTESTIMATION_RULES.md` | Doble offset |
| Extraer probabilidad Bernoulli | `predict double ..., pr` | `GLM_POSTESTIMATION_RULES.md` | Probabilidades 0/1 exactas |
| Extraer fitted Gaussian | `predict double ..., xb` | `GLM_POSTESTIMATION_RULES.md` | Usar residual clásico en lugar de CDF normal |
| Calcular CDF discreta | `poisson()`, `binomial()`, `nbinomial()` | `07_ALGORITHM_PSEUDOCODE_MASTER.md` | Endpoints mal definidos |
| Aleatorizar PIT | `runiform()`, `uvar()` | `STATA_R_BENCHMARK_MAPPING.md` | Comparación no reproducible con R |
| Transformar a normal | `invnormal()` | `STATA_NUMERICAL_STABILITY_RULES.md` | `U` en 0/1 |
| Certificar contra R | `assert`, `log using`, `set seed` | `STATA_TESTING_CERTIFICATION_RULES.md` | Aceptar discrepancias no explicadas |
