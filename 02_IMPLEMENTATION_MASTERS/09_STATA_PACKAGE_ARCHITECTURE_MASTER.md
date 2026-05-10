# 09_STATA_PACKAGE_ARCHITECTURE_MASTER.md

## 1. Propósito del documento

`ESTÁNDAR OFICIAL`: este documento define la arquitectura operativa del paquete Stata/Mata `qresid` antes de implementar código.

`qresid` debe ser un comando de postestimación para residuos cuantílicos y residuos cuantílicos aleatorizados, con extracción reproducible desde modelos Stata, cálculo CDF/PIT auditable, benchmarks R-Stata por capas y preparación eventual para SSC/Stata Journal.

`RECOMENDACIÓN OPERATIVA`: tratar este archivo como especificación interna de diseño. No copiarlo al paquete final SSC.

---

## 2. Alcance Fase 1 vs Fase 2/3

### Fase 1

`ESTÁNDAR OFICIAL`: Fase 1 cubre modelos no correlacionados con CDF evaluable, extracción postestimación documentada y benchmark R reproducible.

Familias objetivo:

- Gaussian normal.
- Bernoulli/binomial.
- Poisson.
- Negative binomial con validación explícita de parametrización.
- Gamma como Fase 1 activa con gate técnico obligatorio de validación.

### Fase 2

`RECOMENDACIÓN OPERATIVA`: Fase 2 cubre extensiones discretas compuestas o modelos donde la CDF requiere estructura adicional.

Familias/modelos:

- ZIP/ZINB fuera de las rutas unweighted ya validadas en extension prerelease.
- Hurdle fuera de las rutas pinneadas/validadas `hplogit` y `hnblogit`.
- Truncados/censurados fuera de las rutas unweighted ya validadas en extension prerelease.
- PIT o diagnósticos simulados.
- Modelos `me*` simples solo si se define CDF condicional, marginal o simulada.

### Fase 2/3

`EVIDENCIA PENDIENTE`: GLMM, GSEM, FMM, `xt*`, modelos bayesianos y correlacionados requieren revisión humana antes de cualquier soporte activo.

### Extension prerelease experimental

`ESTÁNDAR OFICIAL`: una ruta puede existir como `extension prerelease experimental` si tiene CDF/PIT definido, extractor Stata cerrado, tests, benchmarks y matrices vivas sincronizadas, pero aun no constituye public RC ni soporte estable SSC.

Rutas experimentales locales actualmente permitidas por evidencia:

- inverse Gaussian `glm, family(igaussian)` para links `READY_FOR_EXTENSION_PRERELEASE` listados en la matriz viva;
- grouped binomial `glm, family(binomial trials)` y `binreg, n(trials)` aliases validados;
- NB2 `nbreg, dispersion(mean)` incluyendo `offset()` y `exposure()`;
- NB variants `nbreg, dispersion(constant)`, `gnbreg`, y fixed-parameter `glm, family(nbinomial #)`;
- zero-inflated count `zip` y `zinb` sin pesos, incluyendo rutas validadas de `offset()` y `exposure()` del componente de conteo;
- truncated count `tpoisson`, `ztp`, `tnbreg`, y `ztnb` sin pesos en rutas validadas localmente;
- censored count `cpoisson` sin pesos en rutas validadas localmente;
- generalized Poisson mediante Stata Journal `st0279`/`gpoisson` sin pesos en
  rutas validadas localmente; requiere estimador externo pinneado/instalado;
- hurdle count mediante Hilbe/Hardin `hplogit`/`hnblogit` sin pesos en rutas
  validadas localmente; requiere estimador externo pinneado/instalado y firma
  `ml` estricta;
- direct `fweight` solo en combinaciones `READY_FOR_EXTENSION_PRERELEASE` validadas por benchmarks;
- direct `[pweight=]` solo como diagnostico model-based/Stata-only, no `svy:`.

`ESTÁNDAR OFICIAL`: estas rutas deben permanecer separadas de Fase 1 estable y de public RC hasta decision humana de release policy.

---

## 3. Estructura final esperada del paquete

| Ruta | Responsabilidad | Regla |
|---|---|---|
| `qresid.ado` | Comando público de postestimación | `ESTÁNDAR OFICIAL`: `version`, `program qresid, rclass`, `syntax`, dispatcher y returned results. |
| `qresid.sthlp` | Ayuda oficial | `ESTÁNDAR OFICIAL`: sintaxis, opciones, ejemplos, stored results, métodos breves, limitaciones. |
| `qresid.pkg` | Instalación SSC | `ESTÁNDAR OFICIAL`: listar solo archivos públicos necesarios. |
| `stata.toc` | Índice Stata | `ESTÁNDAR OFICIAL`: descripción breve, sin texto interno. |
| `README.md` | Entrada pública GitHub | `RECOMENDACIÓN OPERATIVA`: estado de soporte, instalación y ejemplos mínimos. |
| `examples/` | Ejemplos ejecutables | `ESTÁNDAR OFICIAL`: `version`, datos pequeños o oficiales, `set seed` si aplica. |
| `tests/` | Unit, integration y R benchmarks | `ESTÁNDAR OFICIAL`: separar familias, capas y outputs. |
| `certification/` | Evidencia release/SJ | `ESTÁNDAR OFICIAL`: `master.do`, `master_R.R`, logs, outputs, reports. |

`ESTÁNDAR OFICIAL`: el paquete final no debe contener prompts, notas de agentes, scratch, logs gigantes ni claims sin test.

---

## 4. Arquitectura de comando

Flujo interno esperado:

1. Comando público: recibir `newvarname`, `if/in` y opciones.
2. Parser: validar sintaxis pública con `syntax`.
3. Validación de entorno: verificar `e(cmd)` y modelo soportado.
4. Muestra: combinar `marksample` con `e(sample)`.
5. Dispatcher: mapear comando/familia a extractor y CDF.
6. Extracción postestimación: obtener `y`, `mu/pr/n/xb`, parámetros accesorios, pesos y offset si aplica.
7. Cálculo CDF: crear `F_low` y `F_high` como `double`.
8. Uniformización: construir `U` determinístico o aleatorizado.
9. Transformación normal: aplicar clipping documentado y `invnormal(U)`.
10. Outputs: generar residuo principal y variables auditables solicitadas.
11. Returned results: devolver conteos, flags y metadatos en `r()`.

`RECOMENDACIÓN OPERATIVA`: mantener `qresid.ado` delgado. Mover cálculo repetido o vectorizable a subrutinas o Mata solo cuando los tests estén estables.

---

## 5. API pública final Fase 1

`ESTÁNDAR OFICIAL`: la API pública Fase 1 usa la opción A del brief `PRE_MCP_HUMAN_DECISION_BRIEF.md`: `newvarname` como argumento principal. No exponer `generate()` ni una interfaz híbrida en Fase 1.

Sintaxis final:

```stata
qresid newvarname [if] [in] [, seed(integer) uvar(varname numeric) ///
    savev(name) saveflo(name) savefhi(name) saveu(name) ///
    type(string) family(string) ]
```

Opciones:

| Opción | Estado | Regla |
|---|---|---|
| `seed(integer)` | Fase 1 | `ESTÁNDAR OFICIAL`: reproducibilidad interna en Stata; no implica igualdad con R. |
| `uvar(varname numeric)` | Fase 1 | `ESTÁNDAR OFICIAL`: uniformes externos para benchmarks exactos R-Stata. |
| `savev(name)` | Fase 1 | `ESTÁNDAR OFICIAL`: guardar uniforme base `V` usado en discretas; se mantiene separado de `saveu()`. |
| `saveflo(name)` | Recomendado | `RECOMENDACIÓN OPERATIVA`: guardar `F_low`. |
| `savefhi(name)` | Recomendado | `RECOMENDACIÓN OPERATIVA`: guardar `F_high`. |
| `saveu(name)` | Fase 1 | `ESTÁNDAR OFICIAL`: guardar `U` final antes de `invnormal()`; no es alias de `savev()`. |
| `type(string)` | Extension prerelease | `ESTÁNDAR OFICIAL`: `type(quantile)` es el default; `type(studentized)` solo para rutas unweighted `regress` y GLM testeadas; `type(adjusted)` solo para GLM Gamma/inverse Gaussian unweighted con formula Scudilio-Pereira. |
| `family(string)` | Fase 1 condicional | `ESTÁNDAR OFICIAL`: permitir solo si el comando activo no permite inferencia segura; nunca debe contradecir `e(family)`. |

`ESTÁNDAR OFICIAL`: `replace` no forma parte de la API pública Fase 1. Si `newvarname` o una variable solicitada con `save*()` ya existe, el comando debe fallar con error claro.

`ESTÁNDAR OFICIAL`: `generate(newvarname)` y la interfaz híbrida quedan fuera de Fase 1. Reconsiderarlas requiere nueva decisión humana y actualización de help, examples, tests y changelog.

`ESTÁNDAR OFICIAL`: no cambiar la API pública sin actualizar `.sthlp`, examples, tests y changelog.

`ESTÁNDAR OFICIAL`: el residuo producido por `type(quantile)` ya esta en
escala normal estandar porque aplica `invnormal(U)` al PIT. No agregar una
opcion publica llamada simplemente `standardized` para este comportamiento
existente. `type(studentized)` es una excepcion limitada: divide el residuo
cuantilico por `sqrt(1-h)` solo despues de `regress` y GLM testeadas sin pesos,
con `h` obtenido de `predict, hat` y benchmark contra `glmtoolbox` o R CDF
replay. `type(adjusted)` usa la misma correccion Scudilio-Pereira solo para
GLM Gamma/inverse Gaussian sin pesos. Opciones futuras de
residuos ajustados o nuevas variantes studentizadas requieren cerrar primero
`QRESID_STANDARDIZED_QUANTILE_RESIDUALS_GATE.md`, incluyendo revision de
formulas, paquetes R/codigo fuente y benchmarks por ruta.

---

## 6. Familias soportadas por fase

| Familia | Comandos | Fase | Estado |
|---|---|---:|---|
| Gaussian | `regress`, `glm` | 1 | `ESTÁNDAR OFICIAL` |
| Bernoulli/binomial | `logit`, `logistic`, `binreg`, `glm` | 1 | `ESTÁNDAR OFICIAL` |
| Poisson | `poisson`, `glm` | 1 | `ESTÁNDAR OFICIAL` |
| Negative binomial | `nbreg`, `glm` si aplica | 1 | `RECOMENDACIÓN OPERATIVA`: requiere validar NB1/NB2, `alpha/theta/k`. |
| Gamma | `glm` | 1 | `ESTÁNDAR OFICIAL`: Fase 1 activa; requiere validar `y > 0`, `mu > 0`, `phi > 0`, `shape = 1/phi`, `scale = mu*phi`, CDF y benchmark R. |
| Inverse Gaussian | `glm` | extension prerelease | `READY_FOR_EXTENSION_PRERELEASE`: CDF y benchmarks locales cerrados para rutas listadas en la matriz viva; no public RC. |
| Tweedie | `glm`/externos | futura | `EVIDENCIA PENDIENTE`: CDF aproximada/no cerrada. |
| ZIP/ZINB | `zip`, `zinb` | extension prerelease | `EXPERIMENTAL_VALIDATED_LOCAL`: rutas no ponderadas validadas localmente; pesos y extensiones correlacionadas siguen gated. |
| Truncados/censurados oficiales | `tpoisson`, `ztp`, `tnbreg`, `ztnb`, `cpoisson` | extension prerelease | `EXPERIMENTAL_VALIDATED_LOCAL`: rutas no ponderadas validadas localmente; pesos y variantes no probadas siguen gated. |
| Generalized Poisson | Stata Journal `st0279`/`gpoisson` | extension prerelease | `READY_FOR_EXTENSION_PRERELEASE`: ruta externa pinneada, no ponderada, con CDF GP-0 y benchmarks locales; otros estimadores GP siguen gated. |
| Hurdle count pinneado | `hplogit`, `hnblogit` | extension prerelease | `READY_FOR_EXTENSION_PRERELEASE`: solo rutas unweighted Hilbe/Hardin pinneadas; otros hurdle siguen gated. |
| Hurdle y otros truncados/censurados no validados | `churdle`, `ztpnm` y rutas no probadas | 2 | `EVIDENCIA PENDIENTE`: extraccion y CDF pendientes. |
| GLMM/GSEM | `me*`, `xt*`, `gsem`, `fmm` | 2/3 | `EVIDENCIA PENDIENTE`: preferir diseño simulado. |

---

## 7. Dispatcher de modelos Stata

| `e(cmd)` / comando | Extractor principal | Familia inferida | Acción |
|---|---|---|---|
| `regress` | `predict double ..., xb` | Gaussian | Soportar Fase 1. |
| `glm` | `predict double ..., mu` | `e(family)` | Soportar solo familias Fase 1/1b validadas. |
| `poisson` | `predict double ..., n` | Poisson | Soportar Fase 1. |
| `nbreg` | `predict double ..., n` | Negative binomial | Soportar solo rutas validadas; `dispersion(mean)` con `offset()`/`exposure()` y `dispersion(constant)` estan validados para extension prerelease. |
| `logit` | `predict double ..., pr` | Bernoulli | Soportar Fase 1. |
| `logistic` | `predict double ..., pr` | Bernoulli | Soportar Fase 1. |
| `binreg` | `predict double ..., mu` | Binomial/Bernoulli | Soportar tras validar `e(m)`; grouped aliases validados son extension prerelease, `hr` solo Stata-internal. |
| `gnbreg` | `predict double ..., n`; `predict double ..., alpha` | Negative binomial | Soportar solo rutas validadas; observation-specific `alpha_i` esta validado para extension prerelease sin pesos. |
| `zip`, `zinb` | `_predict ..., xb eq(#1)`; `predict ..., pr`; `e(alpha)` o `/lnalpha` para ZINB | Inflados | Soportar rutas no ponderadas validadas; pesos y variantes correlacionadas siguen gated. |
| `tpoisson`, `ztp` | `predict double ..., n`; `e(llopt)`, `e(ulopt)` cuando aplica | Poisson truncado | Soportar rutas no ponderadas validadas; pesos y variantes no probadas siguen gated. |
| `tnbreg`, `ztnb` | `predict double ..., n`; `e(alpha)` | NB truncado | Soportar rutas no ponderadas validadas; pesos y variantes no probadas siguen gated. |
| `cpoisson` | `predict double ..., n`; `e(llopt)`, `e(ulopt)` | Poisson censurado | Soportar rutas no ponderadas validadas; pesos y variantes no probadas siguen gated. |
| `gpoisson` | `predict double ..., n`; `e(delta)` | Generalized Poisson GP-0 | Soportar solo Stata Journal `st0279` pinneado, sin pesos; rutas `gp2`, pesos u otros ado GP siguen gated. |
| `meglm`, `mepoisson`, `menbreg`, `melogit` | Pendiente | Mixtos | `EVIDENCIA PENDIENTE`: error controlado Fase 2. |
| `gsem`, `fmm`, `xt*` | Pendiente | Latentes/panel | `EVIDENCIA PENDIENTE`: error controlado Fase 2/3. |

`ESTÁNDAR OFICIAL`: comandos postergados deben fallar con mensaje claro, no calcular residuos parciales.

---

## 8. Manejo postestimación y datos

### `e(cmd)`

`ESTÁNDAR OFICIAL`: abortar si no hay resultados de estimación activos o si el comando no está en el dispatcher.

### `e(sample)` e `if/in`

`ESTÁNDAR OFICIAL`: calcular solo donde `marksample` y `e(sample)` son verdaderos. Fuera de muestra, dejar missing.

### Missing values

`ESTÁNDAR OFICIAL`: no imputar. Si `y`, `mu`, `pr`, `n` o un parámetro requerido es missing en muestra, abortar o dejar missing con regla documentada.

### Offset/exposure

`ESTÁNDAR OFICIAL`: preferir predicciones finales vía `predict`. No recalcular `xb + offset` salvo necesidad documentada. No duplicar offset/exposure.

### Weights

`ESTÁNDAR OFICIAL`: detectar `e(wtype)` y `e(wexp)`. No aplicar una regla global `sqrt(w_i)` al residuo final. Los pesos solo se activan cuando su semántica por familia esté documentada y testeada; ver `03_REPO_REVIEW/WEIGHTS_RQR_EVIDENCE_REVIEW.md`.

`ESTÁNDAR OFICIAL`: `pweight` no es soporte RQR estándar en Fase 1. Puede investigarse solo como diagnóstico experimental/survey en `PWEIGHT_SURVEY_DIAGNOSTIC`, sin equivalencia exacta con R base `glm(weights=)`, sin claim público y sin implementación hasta decisión humana explícita.

### Factor variables

`ESTÁNDAR OFICIAL`: no reconstruir manualmente la matriz de diseño para Fase 1. Usar `predict` para preservar factor variables, interacciones y transformaciones del modelo.

---

## 9. Reglas numéricas

- `ESTÁNDAR OFICIAL`: todas las variables internas de CDF, PIT, uniformes, predicciones y residuos deben ser `double`.
- `ESTÁNDAR OFICIAL`: validar `0 <= F_low <= F_high <= 1`.
- `ESTÁNDAR OFICIAL`: inversión severa `F_high + tol < F_low` debe abortar.
- `RECOMENDACIÓN OPERATIVA`: saturar errores leves de CDF a `[0,1]` solo dentro de tolerancia documentada.
- `RECOMENDACIÓN OPERATIVA`: aplicar clipping antes de `invnormal()` con epsilon documentado.
- `ESTÁNDAR OFICIAL`: validar soporte de `y`: enteros no negativos para conteos, `0..m` para binomial, `y > 0` para Gamma.
- `ESTÁNDAR OFICIAL`: validar parámetros: `mu > 0`, `0 <= p <= 1`, `sigma > 0`, `phi > 0`, `alpha/theta/k > 0`.

Tolerancias iniciales:

| Objeto | Tolerancia |
|---|---:|
| `mu`, `pr`, `n`, `xb` | `1e-8` |
| CDF continua | `1e-12` |
| CDF discreta | `1e-8` a `1e-12` |
| `U` con `uvar()` | `1e-12` |
| Residuo final con `uvar()` | `1e-8` |

---

## 10. Estrategia Mata

`ESTÁNDAR OFICIAL`: la primera implementación puede residir en ado si las CDF nativas de Stata bastan y los tests son legibles.

Qué va en ado:

- parsing;
- validación de entorno;
- `marksample` y `e(sample)`;
- llamadas a `predict`;
- creación de variables de salida;
- returned results y mensajes de error.

Qué podría ir en Mata:

- rutinas vectorizadas de endpoints CDF;
- validación masiva de rangos;
- uniformización;
- clipping y conteo de flags;
- CDF no nativas solo tras evidencia.

Cuándo usar `.mlib`:

- `RECOMENDACIÓN OPERATIVA`: compilar `.mlib` solo después de estabilizar API, tests unitarios, integración y benchmarks.

Qué no implementar aún:

- CDF Tweedie, COM-Poisson o generalized Poisson sin evidencia.
- CDF inverse Gaussian fuera de las rutas ya validadas en extension prerelease.
- Integración marginal GLMM/GSEM.
- Simulación DHARMa-like antes de cerrar Fase 1 analítica.

---

## 11. Estrategia RNG

- `ESTÁNDAR OFICIAL`: `seed()` fija reproducibilidad interna de Stata.
- `ESTÁNDAR OFICIAL`: `uvar()` es obligatorio para comparar residuos aleatorizados discretos R-Stata punto a punto.
- `RECOMENDACIÓN OPERATIVA`: permitir guardar uniforme base `V`, `F_low`, `F_high` y `U` para auditoría.
- `ESTÁNDAR OFICIAL`: no afirmar igualdad exacta entre RNG nativo de R y RNG nativo de Stata.
- `ESTÁNDAR OFICIAL`: si se usan uniformes externos, validar tipo numérico, no missing en muestra, longitud/muestra compatible y rango.
- `RECOMENDACIÓN OPERATIVA`: preferir uniformes en `(0,1)` para benchmarks exactos; documentar manejo de `0` y `1`.

---

## 12. Testing y certificación

### Unit tests

`ESTÁNDAR OFICIAL`: cada familia soportada debe tener tests de:

- CDF `F(y)`;
- endpoint izquierdo `F(y-)`;
- soporte de `y`;
- parámetros extremos;
- `U` dentro de intervalo;
- `invnormal(U)` sin missing inesperado.

### Integration tests

`ESTÁNDAR OFICIAL`: probar después de comandos Stata reales:

- `regress`;
- `glm`;
- `poisson`;
- `nbreg`;
- `logit`/`logistic`;
- `binreg`;
- `if/in`;
- `e(sample)`;
- offset/exposure;
- pesos cuando estén activados.

### R benchmarks

`ESTÁNDAR OFICIAL`: validar por capas:

1. datos, fórmula, muestra, pesos, offset;
2. coeficientes;
3. `xb`, `mu`, `pr`, `n`;
4. parámetros accesorios;
5. `F_low`, `F_high`;
6. uniformes externos;
7. residuo final con `uvar()`.

### Certification scripts

`ESTÁNDAR OFICIAL`: `certification/master.do` y `certification/master_R.R` deben correr desde cero, abrir logs, fallar con `assert` y producir evidencia reproducible.

---

## 13. Help, examples y documentación

`qresid.sthlp` debe incluir:

1. Title.
2. Syntax.
3. Description breve.
4. Options.
5. Remarks mínimos.
6. Examples ejecutables.
7. Stored results.
8. Methods and formulas breve.
9. Limitations.
10. References.
11. Author/contact.

`ESTÁNDAR OFICIAL`: no incluir teoría extensa, prompts, lenguaje de agentes ni soporte no certificado.

`RECOMENDACIÓN OPERATIVA`: los ejemplos básicos deben usar datos simulados pequeños, `version`, `set seed` y no depender de paquetes externos.

---

## 14. Versionado y release

- `ESTÁNDAR OFICIAL`: toda versión pública debe tener changelog y sintaxis estable.
- `ESTÁNDAR OFICIAL`: no publicar familia sin help, ejemplo, unit test, integration test y benchmark.
- `ESTÁNDAR OFICIAL`: `qresid.pkg` y `stata.toc` deben listar solo archivos de distribución.
- `RECOMENDACIÓN OPERATIVA`: mantener aliases de opciones durante al menos una versión menor si se cambia la API.
- `ESTÁNDAR OFICIAL`: antes de SSC/Stata Journal, correr certificación completa y revisar ausencia de archivos temporales.

---

## 15. Criterios de aceptación antes de implementar Fase 1

No iniciar implementación Fase 1 hasta que:

- `ESTÁNDAR OFICIAL`: el dispatcher Fase 1 esté definido.
- `ESTÁNDAR OFICIAL`: cada comando tenga extractor `predict` documentado.
- `ESTÁNDAR OFICIAL`: cada familia tenga fórmula de CDF y endpoints.
- `ESTÁNDAR OFICIAL`: existan tests unitarios planificados por familia.
- `ESTÁNDAR OFICIAL`: exista estrategia `uvar()` para discretas.
- `ESTÁNDAR OFICIAL`: tolerancias estén fijadas.
- `ESTÁNDAR OFICIAL`: Gamma Fase 1 queda cerrada para modelos no ponderados `glm, family(gamma)` con soporte, `phi`, forma/escala, CDF y benchmark R; pesos en Gamma siguen pendientes.
- `ESTÁNDAR OFICIAL`: NB2 `nbreg, dispersion(mean)` con `theta=1/e(alpha)` esta validado para extension prerelease, incluidas rutas `offset()` y `exposure()`. NB no se declara soporte estable/public RC para variantes no validadas.

---

## 16. Tabla maestra de componentes

| Componente | Responsabilidad | Archivo fuente esperado | Tests requeridos | Riesgo |
|---|---|---|---|---|
| Parser público | Leer `newvarname`, `if/in`, opciones | `qresid.ado` | Integration interfaz | API inconsistente. |
| Validador de modelo | Verificar `e(cmd)` y soporte | `qresid.ado` | Error tests | Soportar modelo no auditado. |
| Muestra | Combinar `marksample` y `e(sample)` | `qresid.ado` | Integration `if/in`, missing | Calcular fuera de muestra. |
| Extractor Gaussian | `regress`/`glm`, `mu`, `sigma` | `qresid.ado` o helper | Unit CDF, integration, R benchmark | `sigma` incorrecto. |
| Extractor binomial | `pr/mu`, trials `m` | `qresid.ado` o helper | Unit endpoints, integration, R benchmark | `m` mal extraído. |
| Extractor Poisson | `predict, n` | `qresid.ado` o helper | Unit endpoints, offset benchmark | Offset duplicado. |
| Extractor NB | `predict, n`, `alpha/theta/k` | helper dedicado | Unit CDF, R benchmark | NB1/NB2 mal alineado. |
| Extractor Gamma | `predict, mu`, `phi` | helper dedicado | Unit CDF, R benchmark | Forma/escala mal parametrizada. |
| CDF endpoints | Generar `F_low`, `F_high` | ado primero; Mata futuro | Unit CDF extremos | Inversión o CDF fuera de rango. |
| Uniformización | Crear `V` y `U` | ado primero; Mata futuro | RNG, `uvar()` | No reproducibilidad. |
| Transformación normal | Clipping e `invnormal()` | ado/Mata | PIT endpoint tests | Missing o infinitos. |
| Outputs auditables | Residuo, `V`, `F_low`, `F_high`, `U` | `qresid.ado` | Integration outputs | Sobrescritura o tipos no `double`. |
| Returned results | Conteos, flags, familia, comando | `qresid.ado` | Stored result tests | Evidencia insuficiente. |
| Help/examples | Documentación pública | `qresid.sthlp`, `examples/` | Smoke tests | Claims sin soporte. |
| Certification | Evidencia reproducible | `certification/` | `master.do`, `master_R.R` | Resultados no auditables. |

---

## 17. Gaps y decisiones con aprobación humana

`EVIDENCIA PENDIENTE`:

- NB `nbreg, dispersion(mean)`, `nbreg, dispersion(constant)`, `gnbreg`, y fixed-parameter `glm, family(nbinomial #)` quedan cerrados para extension prerelease; falta `glm, family(nbinomial ml)` por extraccion robusta del parametro estimado.
- Truncados/censurados oficiales `tpoisson`, `ztp`, `tnbreg`, `ztnb`, y `cpoisson` quedan cerrados para extension prerelease en rutas unweighted validadas; pesos y variantes no probadas siguen gated.
- Gamma queda decidido como Fase 1 y cerrado para modelos no ponderados con evidencia técnica de forma/escala, CDF y benchmark R; pesos en Gamma siguen pendientes.
- Confirmar uso y transformación final de pesos por familia; no activar `sqrt(w_i)` global.
- API pública Fase 1 queda cerrada: `qresid newvarname [if] [in], ...`; `family()` es condicional, `replace` no se expone, y `savev()` queda separado de `saveu()`.
- Inverse Gaussian queda validada solo para rutas listadas en la matriz viva; nuevas variantes requieren gate CDF/benchmark.
- Confirmar estrategia para Tweedie, COM-Poisson y generalized Poisson.
- Confirmar diseno Fase 2 para hurdle fuera de `hplogit`/`hnblogit`, truncados/censurados ponderados o no validados y para ZIP/ZINB ponderados o correlacionados.
- Confirmar si GLMM/GSEM se abordarán solo por simulación.
- Confirmar licencia y datasets antes de incluir casebank o datos externos.

`ESTÁNDAR OFICIAL`: cualquier gap anterior bloquea claims públicos y soporte activo hasta revisión humana.

