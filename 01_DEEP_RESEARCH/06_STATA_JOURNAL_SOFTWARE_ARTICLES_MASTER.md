# 06_STATA_JOURNAL_SOFTWARE_ARTICLES_MASTER.md

## Marco editorial útil para `qresid`

La pauta más consistente de entity["organization","The Stata Journal","statistical journal for Stata users"] para artículos de software no es “presentar código” sin más, sino enlazar un problema estadístico identificado, una justificación metodológica ya validada en la literatura, una implementación concreta en entity["software","Stata","statistical software"], y ejemplos reproducibles. Las guías oficiales dicen explícitamente que el Journal quiere artículos que discutan comandos nuevos o programas de Stata de interés amplio o de un segmento importante de usuarios; además, exige que las propiedades del método subyacente ya estén “validated” en publicaciones arbitradas o equivalentes antes del envío. También descarta programas sin discusión suficiente y exige que los resultados sean reproducibles. citeturn19view0turn12view1

Eso encaja muy bien con un artículo para `qresid`: la contribución central no debería formularse como “otro ado con residuos”, sino como “implementación reproducible y usable de residuos cuantílicos aleatorizados para familias de modelos en las que los residuos clásicos son poco informativos, especialmente en regresión de conteo, GLM y modelos con inflación de ceros”. Esa formulación sigue el patrón editorial observado en artículos de diagnóstico, conteo, visualización y GLMM revisados aquí. citeturn23view0turn23view1turn23view2turn23view3turn23view5turn23view6turn23view7

## Corpus de artículos modelo

A continuación recojo un corpus de ocho artículos especialmente útiles para imitar estructura editorial, técnica y de distribución. La selección cubre regresión, diagnósticos, gráficos, simulación, conteo y GLMM.

- **Miguel Manjón y Oscar Martínez, 2014, “The chi-squared goodness-of-fit test for count-data models”, comando `chi2gof`.** Problema estadístico: diagnóstico postestimación para modelos de conteo, con foco en bondad de ajuste después de `poisson`, `nbreg`, `zip` y `zinb`. La estructura es muy canónica y muy útil para `qresid`: introducción del problema, desarrollo teórico del estadístico, sección propia del comando con sintaxis y opciones, y luego una sección de ejemplos extensa. La estructura de ejemplos es especialmente instructiva: los autores **replican y extienden** resultados de fuentes conocidas y, para cada caso, muestran tanto el comando de estimación base como el nuevo comando diagnóstico. La sintaxis se documenta en una subsección autónoma y las opciones se explican inmediatamente después. La validación no se apoya en comparación con R, sino en replicación de ejemplos de referencia y en interpretación del test frente a modelos alternativos. En lo revisado, no vi comparación con R u otro software. El artículo está claramente asociado al tag `st0360`, por lo que el software está confirmado en el sitio del Journal; en la búsqueda revisada no confirmé una entrada SSC específica para `chi2gof`, así que no la doy por hecha. citeturn23view0turn24view0turn25view0turn27view4turn7search8turn12view1

- **Tammy Harris, Zhao Yang y James W. Hardin, 2012, “Modeling underdispersed count data with generalized Poisson regression”, comando `gpoisson`.** Problema estadístico: estimación de conteos con subdispersión, donde Poisson y aproximaciones habituales pueden inducir inferencias engañosas. La estructura editorial es muy clara: motivación, revisión breve de modelos, sección del comando con sintaxis, ejemplo gráfico y ejemplo con datos reales, estudio de simulación y conclusiones. La estructura de ejemplos es una de las mejores del corpus para `qresid`: primero una comparación visual simple para intuición, luego una aplicación empírica, y después una validación por simulación. La sintaxis se documenta por analogía explícita con `poisson`, lo que reduce la carga cognitiva del lector. La validación es fuerte: compara cobertura y potencia entre Poisson, generalized Poisson y quasi-Poisson bajo subdispersión. No encontré comparación con R u otro software. El artículo tiene tag `st0279`, así que el código del artículo está confirmado en el sitio del Journal. Importante: en SSC sí aparece `gnpoisson`, pero esa entrada corresponde a otro módulo y no debe confundirse automáticamente con el `gpoisson` del artículo; por prudencia, para este artículo considero confirmada solo la distribución vía Journal en lo que pude revisar. citeturn32view1turn27view0turn27view5turn24view1turn7search17turn30search1turn12view1

- **Charles Lindsey y Simon Sheather, 2010, “Model fit assessment via marginal model plots”, comando `mmp`.** Problema estadístico: evaluación gráfica del ajuste de modelos de regresión más allá de los residuos, especialmente útil donde los residuos tradicionales son difíciles de interpretar. Para `qresid`, este artículo es probablemente el más cercano editorialmente en espíritu diagnóstico. Su estructura es breve pero muy eficaz: teoría/motivación, uso y ejemplos, discusión final. Los ejemplos están organizados para enseñar el comando mientras introducen la lógica del diagnóstico, algo muy deseable para `qresid`. La sintaxis aparece integrada al inicio de la sección de uso, seguida de la explicación operativa de cada opción; es una forma compacta y pedagógica. La validación se hace por demostración en regresión lineal y logística, comparando la curva del modelo con una alternativa no paramétrica/semiparamétrica. No vi comparación con R u otro software. El tag `st0189` confirma distribución en el sitio del Journal; no confirmé una entrada SSC específica en la revisión hecha. citeturn32view2turn23view2turn24view2turn25view2turn12view1

- **Patrick Royston, 2013, “marginscontplot: Plotting the marginal effects of continuous predictors”, comando `marginscontplot` o `mcp`.** Problema estadístico: graficar márgenes de predictores continuos en modelos de regresión, especialmente cuando `margins`/`marginsplot` dejan trabajo manual o poco elegante. La estructura del artículo es excelente para software “utility layer”: introducción, discusión conceptual sobre `margins`, ejemplos simples, ejemplos más avanzados, sintaxis completa y comentarios finales. La estructura de ejemplos es incremental: empieza con el flujo estándar `margins` + `marginsplot`, muestra enseguida la ganancia de usar el nuevo comando, y luego pasa a transformaciones y casos más complejos. La sintaxis está muy detallada y las opciones reciben explicación extensa. La validación es principalmente por comparación funcional con el workflow nativo de Stata y por demostraciones gráficas; no aparece benchmarking con R. El software del artículo está confirmado en el sitio del Journal por el tag `gr0056`. Además, sí encontré en SSC una **extensión posterior**, `marginscontplot2`, que remite explícitamente al artículo original; eso refuerza la utilidad del artículo como modelo de evolución desde Journal hacia ecosistema SSC. citeturn32view3turn23view3turn24view3turn25view3turn26view3turn31search0turn12view1

- **Ian R. White, 2010, “simsum: Analyses of simulation studies including Monte Carlo error”, comando `simsum`.** Problema estadístico: análisis y reporte de estudios de simulación con estimación explícita del error Monte Carlo. Para `qresid`, este artículo importa por dos razones: ofrece un modelo editorial de artículo centrado en una utilidad metodológica y, además, enseña cómo incorporar validación por simulación en un paper de software. Su estructura es muy ordenada: introducción, sección del comando con sintaxis y opciones, desarrollo de estadísticas reportadas, discusión y referencias. La organización de ejemplos gira en torno a formatos de datos y métricas de simulación más que a datasets aplicados tradicionales, una opción válida si `qresid` necesitara una sección de validación Monte Carlo amplia. La sintaxis está muy claramente separada para formato ancho y largo. La validación principal consiste en mostrar cómo `simsum` cuantifica sesgo, cobertura, precisión y error MC; la discusión menciona métodos disponibles en R, pero no hace comparación software contra software. En distribución, aquí sí hay confirmación doble: el artículo del Journal tiene tag `st0200` y el módulo en SSC/RePEc existe y se instala con `ssc install simsum`. citeturn32view4turn28view2turn26view4turn29search0turn12view1

- **Reinhard Schunck y Francisco Perales, 2017, “Within- and between-cluster effects in generalized linear mixed models: A discussion of approaches and the xthybrid command”, comando `xthybrid`.** Problema estadístico: estimación de efectos within/between en GLMM, donde los estimadores FE/RE estándar no siempre bastan. Este artículo es un modelo muy fuerte para `qresid` si el paquete quiere cubrir GLM/GLMM y varios tipos de familia sin escribir un paper “por familia”. La estructura es: motivación teórica, desarrollo metodológico, sección del comando con sintaxis/opciones/resultados almacenados, aplicaciones empíricas. Los ejemplos usan un dataset estándar (`nlswork`) y enseñan primero la idea del modelo y luego los comandos; ese orden es importante. La sintaxis se apoya explícitamente en `meglm`, lo que simplifica el aprendizaje y transmite integración con Stata oficial. La validación descansa en comparaciones dentro del ecosistema Stata: within vs between, contrastes con enfoques FE/RE y relación con `meglm`; no vi comparación con R. En distribución, el artículo está en el Journal con tag `st0468` y el módulo también está en SSC/RePEc como `xthybrid`, instalable con `ssc install xthybrid`. citeturn32view5turn23view5turn24view5turn25view5turn27view1turn27view7turn29search2turn12view1

- **Michael J. Crowther, 2020, “merlin—A unified modeling framework for data analysis and methods development in Stata”, comando `merlin`.** Problema estadístico: marco unificado y extensible para regresión lineal, GLM, modelos multinivel, supervivencia, longitudinales y modelos conjuntos. Editorialmente, este artículo es el mejor ejemplo del corpus para un paquete ambicioso, porque combina arquitectura del software, sintaxis, ejemplos de complejidad creciente, discusión de implementación y nota de instalación. La estructura es muy madura: introducción y posicionamiento respecto a `gsem`, `gllamm` y `cmp`; arquitectura/sintaxis; una sección de ejemplos larga y escalonada; discusión; y una nota explícita sobre instalación y versiones. Los ejemplos usan un solo dataset pero lo explotan para mostrar un rango de capacidades, estrategia muy recomendable para `qresid` si se quiere dar sensación de coherencia. La sintaxis se documenta como gramática de modelos. La validación es principalmente demostrativa y por cobertura funcional amplia; no vi comparación con R. En lo revisado, este es uno de los pocos artículos que declara de forma explícita la instalación estable por SSC (`ssc install merlin`) y una versión de desarrollo por `net install` desde el sitio del autor. citeturn32view6turn24view6turn25view6turn27view6turn29search1

- **Tammy H. Cummings y James W. Hardin, 2019, “Modeling count data with marginalized zero-inflated distributions”, comandos `mzip`, `mzigp`, `mzinb` y postestimation asociada.** Problema estadístico: modelización de conteos con inflación de ceros e interpretación marginal poblacional. La estructura es uno de los patrones más limpios y más directamente imitable para `qresid`: introducción, breve desarrollo metodológico, sintaxis completa, ejemplos y resumen. Además, el propio artículo anuncia en el resumen y en la sección de sintaxis que el software incluye archivos del comando y archivos de soporte para predicción y ayuda; eso es una pista muy valiosa sobre cómo presentar software asociado al paper. La estructura de ejemplos combina datos sintéticos y datos reales, exactamente la mezcla que conviene a `qresid`. La validación es por plausibilidad del modelo y comparación empírica entre variantes MZIP/MZIGP/MZINB; no vi comparación con R. El tag `st0563` confirma software en el Journal; en la revisión realizada no confirmé una entrada SSC separada para estos comandos. citeturn32view7turn23view7turn24view7turn25view7turn26view7turn9search13turn12view1

Tomados en conjunto, estos artículos muestran un patrón editorial muy estable: **motivación aplicada breve pero clara; apoyo metodológico ya validado fuera del artículo; sintaxis en sección explícita; ejemplos crecientes en dificultad; y validación por una de cuatro vías**: replicación de referencias conocidas, comparación con comandos nativos de Stata, comparación entre modelos alternativos, o simulación. Para `qresid`, eso sugiere que el artículo debería evitar tanto el extremo “solo teoría” como el extremo “solo manual de ayuda”: el modelo más cercano es teoría suficiente + sintaxis precisa + ejemplos reproducibles + una sección de validación propia. citeturn19view0turn23view0turn27view5turn25view2turn25view3turn28view2turn25view5turn25view6turn25view7

## Requisitos prácticos de preparación, distribución y envío

Aquí conviene separar claramente tres circuitos.

**Circuito Stata Journal.** El Journal pide, para envío inicial, un PDF o documento Word del manuscrito; si el artículo introduce software, debe enviarse también la versión actual del software junto con el artículo. La guía enumera expresamente como paquete típico: `ado-files`, `help files`, `do-files`, `log files`, `datasets` y un `readme.txt`. También exige que cada comando tenga su propio ado-file y su archivo de ayuda asociado; recomienda nombres en minúsculas; requiere que los ejemplos comiencen cargando datos; y pide resultados reproducibles. El envío inicial se hace en un archivo Zip al correo editorial; una vez aceptado, se solicitan además los ficheros fuente y el acuerdo de cesión, y el archivo se pide con la extensión renombrada a `.zippy`. citeturn19view0

**Circuito de distribución net-installable.** La documentación oficial de `net` dice que para crear un sitio instalable basta con servir los archivos en una web y añadir dos ficheros de metadatos: un contenido `stata.toc` y un archivo de paquete `pkgname.pkg`. El manual muestra el formato de ambos, incluyendo líneas `d` para descripción, `p` para paquetes, `f` para archivos distribuidos y una línea `Distribution-Date:` en el `.pkg`; también explica que `ado update` puede usar esa fecha para detectar actualizaciones. El mismo manual resume la instalación: `net from`, `net describe`, `net install`, `net get`, y documenta que `net sj vol-issue` es un atajo para acceder al software del Journal. La FAQ del Journal, además, da el patrón concreto de instalación desde `https://www.stata-journal.com/software`, con `net cd sjvol-issue`, `net describe tag` y `net install tag`. citeturn20view0turn20view3turn32view8turn32view9turn12view1turn12view3

**Circuito SSC/RePEc.** La evidencia oficial que pude confirmar sin ambigüedad es la siguiente: la SSC es la serie “Statistical Software Components” hospedada por el Departamento de Economía de Boston College y editada por Christopher F. Baum; la guía pública `SSCSUBMIT` es la referencia oficial para enviar materiales; y el propio manual de Stata remite a esa guía cuando recomienda el SSC como vía habitual de compartición de software comunitario. También confirmé, en entradas concretas de RePEc, que muchos paquetes del corpus se distribuyen por SSC con instrucciones canónicas del tipo `ssc install simsum`, `ssc install xthybrid` o `ssc install merlin`. No incluyo aquí requisitos más detallados de envío al SSC —por ejemplo, formato exacto del correo o convenciones internas no visibles en los extractos revisados— porque no pude abrir íntegramente la guía HTML `SSCSUBMIT` en esta sesión y no quiero inventar reglas no verificadas. citeturn21search6turn14search1turn10search5turn21search3turn29search0turn29search1turn29search2

**Circuito GitHub.** urlGitHubhttps://github.com no impone requisitos específicos para paquetes de Stata, así que aquí hay que distinguir entre lo obligatorio y lo recomendable. Lo confirmado por la documentación oficial es: los *releases* se basan en *tags* de Git; un release sirve para empaquetar software y notas de versión; `CITATION.cff` puede colocarse en la raíz del repositorio para indicar cómo citar el trabajo; y una licencia visible en la raíz es la forma recomendada de dejar claro que otros pueden usar, modificar y distribuir el software. Por tanto, para `qresid` yo trataría GitHub como el lugar de desarrollo y versionado, pero no como sustituto automático de SJ/SSC: sirve muy bien para ramas, *issues*, *releases*, `README.md`, `CHANGELOG.md`, `LICENSE` y `CITATION.cff`; el mecanismo de distribución a usuarios de Stata seguiría necesitando un sitio `net install` bien formado o una entrada SSC. citeturn18search0turn18search1turn17search0turn17search2turn22search5

En términos operativos, el mínimo sólido para `qresid` es este: un comando principal en ado separado; un `.sthlp` detallado; uno o varios do-files que reproduzcan exactamente ejemplos del artículo; logs en texto plano; datasets redistribuibles o muestras sustitutas; un `readme.txt` para el paquete enviado al Journal; y, si además se quiere canal GitHub maduro, `README.md`, `CHANGELOG.md`, `LICENSE` y `CITATION.cff`. La extensión `.sthlp` es la forma moderna recomendada para ayuda en Stata 10 en adelante. citeturn19view0turn12view4turn17search0turn17search2turn22search5

## Estructura propuesta del artículo estilo Stata Journal para `qresid`

La estructura que mejor encaja con el corpus no es la de un artículo “largo de teoría” ni la de una nota breve. Para `qresid`, la mejor imitación es la plantilla usada por `chi2gof`, `gpoisson`, `marginscontplot`, `xthybrid` y `mzip`: problema aplicado, base teórica suficiente, sintaxis clara, ejemplos escalonados, validación propia y cierre breve. citeturn25view0turn27view5turn24view3turn24view5turn24view7

**Propuesta de estructura:**

1. **Título, resumen y palabras clave.** El resumen debe poder leerse solo, sin depender del cuerpo, y las palabras clave deben incluir el tag del artículo y los nombres de los comandos. Eso está alineado con la guía oficial. citeturn19view0

2. **Introducción.**  
   - Problema: por qué los residuos clásicos son insuficientes o poco interpretables en ciertos modelos discretos/GLM.  
   - Qué aporta `qresid`: estandarización, interfaz común, compatibilidad con varias familias/modelos y salida utilizable para diagnóstico gráfico.  
   - Alcance real del comando: qué modelos soporta ahora y cuáles quedan fuera.

3. **Fundamento estadístico.**  
   - Definición de residuo cuantílico aleatorizado.  
   - Relación con continuidad aproximada normal bajo especificación correcta.  
   - Condiciones, límites y casos problemáticos.  
   - Si hay varias familias soportadas, una subsección corta por familia o una notación unificada.

4. **Diseño del software y sintaxis.**  
   - Sintaxis principal.  
   - Subcomandos u opciones clave.  
   - Convenciones de salida.  
   - Resultados almacenados en `r()` o `e()`.  
   - Compatibilidad con `predict`, si aplica.  
   Esta sección debe ser explícita y separada, como en `chi2gof`, `marginscontplot`, `xthybrid` y `mzip`. citeturn24view0turn24view3turn24view5turn24view7

5. **Ejemplos introductorios.**  
   - Un ejemplo mínimo con datos nativos o públicos.  
   - Un ejemplo donde el modelo está bien especificado.  
   - Un ejemplo donde la especificación falla y `qresid` lo hace visible.

6. **Ejemplos avanzados.**  
   - Un ejemplo de conteo con sobredispersión o inflación de ceros.  
   - Un ejemplo GLM/GLMM si el comando lo soporta.  
   - Un ejemplo gráfico, si `qresid` produce o alimenta gráficos diagnósticos.

7. **Validación.**  
   Esta es la sección decisiva para que el paper no parezca “solo documentación”. Recomiendo tres capas:
   - **Replicación** de un resultado conocido en la literatura de residuos cuantílicos.  
   - **Comparación entre especificaciones** dentro de Stata, mostrando cuándo `qresid` cambia de forma diagnóstica útil.  
   - **Simulación**, al estilo `gpoisson` o con reporte semejante a `simsum`, para mostrar comportamiento bajo correcta e incorrecta especificación. citeturn27view0turn28view2  
   Si además existe una implementación externa bien establecida y comparable, se puede añadir una subsección de “equivalencia numérica con otro software”; lo recomendaría como valor añadido, no como requisito editorial.

8. **Conclusiones.**  
   La guía oficial pide una sección final llamada “Conclusions”. Debe ser breve y centrarse en conclusiones reales, limitaciones y trabajo futuro, no en repetir el resumen. citeturn19view0

9. **Apéndice u online supplementary material.**  
   - detalles algebraicos;  
   - derivaciones;  
   - tablas largas;  
   - scripts completos de simulación;  
   - pruebas auxiliares.  
   El Journal permite material suplementario online a discreción editorial. citeturn12view0

## Plantillas propuestas para help file, README y certification scripts

No encontré una exigencia formal del Journal o de SSC que use la etiqueta “certification script” como requisito editorial autónomo. Lo que sí exigen las guías es reproducibilidad, do-files, logs y software completo. Por eso, lo que sigue es una **propuesta de diseño** compatible con los requisitos verificados, no una regla oficial del Journal o del SSC. citeturn19view0turn10search5

### Help file `.sthlp`

La ayuda debe ser más cercana a `marginscontplot`, `xthybrid` o `mzip` que a una ayuda mínima. La guía del Journal pide un archivo de ayuda detallado que explique características, cada opción y ejemplos, y además que todo comando tecleable tenga su help asociado. citeturn19view0

**Estructura recomendada del `qresid.sthlp`:**

- **Title**  
  `qresid — Randomized quantile residuals after supported count and GLM models`

- **Syntax**  
  - sintaxis principal  
  - variantes por familia o por posestimación  
  - abreviaturas admitidas, si las hay

- **Description**  
  - qué calcula  
  - para qué modelos  
  - qué hipótesis diagnóstica sugiere

- **Options**  
  - opciones globales  
  - opciones de simulación/aleatorización  
  - opciones gráficas, si existen  
  - reproducibility options como `seed()`, si aplica

- **Supported estimators**  
  - lista explícita de comandos soportados  
  - qué hace `qresid` después de cada uno

- **Remarks**  
  - interpretación  
  - cuándo esperar aproximación normal  
  - límites con tamaños pequeños, inflación de ceros, offsets, exposición, etc.

- **Stored results**  
  - `r()` y/o variables generadas

- **Examples**  
  - ejemplo mínimo  
  - ejemplo con mal ajuste  
  - ejemplo reproducible del artículo

- **Author / Citation / Also see**  
  - referencia del artículo  
  - cita sugerida  
  - enlaces a comandos relacionados

### README

Aquí recomiendo **dos capas**: `readme.txt` para el paquete de envío al Journal, porque es obligatorio allí, y `README.md` para el repositorio en GitHub, porque es la pieza de entrada natural del proyecto. citeturn19view0turn22search5

**Estructura recomendada del `README.md`:**

- **Qué es `qresid`**
- **Qué problema resuelve**
- **Modelos actualmente soportados**
- **Instalación**
  - desde SSC, si existe
  - desde sitio `net install`
  - desde release de GitHub, si se distribuyen activos
- **Quick start**
- **Ejemplos reproducibles**
- **Arquitectura del paquete**
  - `qresid.ado`
  - `qresid.sthlp`
  - auxiliares Mata/ado, si existen
  - `examples/`, `cert/`, `data/`
- **Estado de validación**
  - datasets
  - simulaciones
  - equivalencia numérica
- **Cómo citar**
  - texto de cita + `CITATION.cff`
- **Licencia**
- **Changelog**
- **Contribución y reporte de bugs**

**Estructura mínima recomendada del `readme.txt` para SJ:**

- nombre del paquete  
- versión y fecha  
- lista de archivos  
- descripción breve  
- requisitos de versión de Stata  
- datasets incluidos  
- instrucciones para correr ejemplos y logs  
- notas sobre datos no públicos, si hubiera  
- datos de contacto del autor

### Certification scripts

**Propuesta de estructura de carpetas:**

```text
cert/
  00_setup.do
  01_smoke_test.do
  02_supported_estimators.do
  03_numeric_identity.do
  04_graphics.do
  05_saved_results.do
  06_error_handling.do
  07_article_examples.do
  expected/
  logs/
```

**Contenido recomendado:**

- `00_setup.do`  
  fija `version`, `set more off`, semilla, rutas temporales y abre log.

- `01_smoke_test.do`  
  confirma que el comando carga, corre y devuelve salida básica sin error.

- `02_supported_estimators.do`  
  ejecuta `qresid` después de cada estimador oficialmente soportado.

- `03_numeric_identity.do`  
  compara resultados con valores de referencia o invariantes conocidos.

- `04_graphics.do`  
  exporta gráficos diagnósticos y confirma que se generan sin romper el flujo.

- `05_saved_results.do`  
  prueba `return list` o `ereturn list`, nombres de variables generadas y etiquetas.

- `06_error_handling.do`  
  fuerza errores esperados con `capture noisily` y verifica mensajes útiles.

- `07_article_examples.do`  
  reproduce exactamente tablas/figuras del artículo.

La razón de esta estructura no es “seguir una norma SJ”, sino cubrir de forma ordenada lo que sí exige el Journal: ejemplos reproducibles, do-files y logs, además de facilitar una revisión editorial que volverá a ejecutar el código con la versión más reciente de Stata. citeturn19view0

## Checklist de envío para `qresid`

La siguiente checklist mezcla requisitos confirmados y buenas prácticas claramente separadas. Los ítems marcados como “recomendado” no son exigencias formales del Journal o de SSC, sino prácticas de distribución y mantenimiento aconsejables.

### Stata Journal

- [ ] Manuscrito en PDF o Word para envío inicial. citeturn19view0
- [ ] Sección final titulada **Conclusions**. citeturn19view0
- [ ] Resultados reproducibles y ejemplos que comiencen cargando datos. citeturn19view0
- [ ] `ado` principal por comando, en minúsculas. citeturn19view0
- [ ] `.sthlp` detallado por comando. citeturn19view0
- [ ] `do-files` para reproducir ejemplos del artículo. citeturn19view0
- [ ] `log files` preferiblemente en texto plano `.log`. citeturn19view0
- [ ] Datasets redistribuibles o dataset de muestra sustituto. citeturn19view0
- [ ] `readme.txt` incluido en el bundle. citeturn19view0
- [ ] Zip al correo editorial para el envío inicial. citeturn19view0
- [ ] Tras aceptación: fuentes finales + acuerdo de cesión + archivo renombrado `.zippy`. citeturn19view0

### Sitio `net install`

- [ ] `stata.toc` válido. citeturn20view0turn32view8
- [ ] `pkgname.pkg` válido con `Distribution-Date:`. citeturn20view3turn32view8turn32view9
- [ ] Archivos listados con rutas usando `/`. citeturn20view3
- [ ] `ado`, `.sthlp` y archivos auxiliares enumerados con `f`. citeturn32view8turn32view9
- [ ] Prueba manual de `net from`, `net describe` y `net install`. citeturn12view3turn12view1

### SSC/RePEc

- [ ] Preparar paquete net-installable limpio. citeturn10search5turn21search6
- [ ] Verificar ortografía, nombres y metadatos porque la entrada SSC/RePEc será persistente. ꟷ Recomendado, inferido de la función archivística de SSC/RePEc. citeturn21search6turn14search1
- [ ] Seguir la guía oficial `SSCSUBMIT` en el momento del envío. citeturn10search2turn14search1

### GitHub

- [ ] Repositorio público o privado según estrategia del proyecto. ꟷ Recomendado. citeturn18search6
- [ ] `README.md`. ꟷ Recomendado. citeturn22search5
- [ ] `LICENSE`. ꟷ Recomendado. citeturn17search2
- [ ] `CITATION.cff`. ꟷ Recomendado. citeturn17search0
- [ ] `CHANGELOG.md`. ꟷ Recomendado como práctica de release. citeturn18search0turn18search1
- [ ] Release asociado a un tag. ꟷ Recomendado. citeturn18search0turn18search1
- [ ] Adjuntar en el release un zip del paquete instalable o enlace al sitio `net install`. ꟷ Recomendado, coherente con el modelo release/tag. citeturn18search0turn18search1

## Tabla de acceso y limitaciones

| Artículo o fuente | Acceso completo | Qué se pudo revisar | ¿PDF requerido? |
|---|---:|---|---:|
| *The chi-squared goodness-of-fit test for count-data models* | Sí | PDF completo, portada, sintaxis, ejemplos, validación por replicación/extensión | Sí |
| *Modeling underdispersed count data with generalized Poisson regression* | Sí | PDF completo, sintaxis, estructura, ejemplo real y simulación | Sí |
| *Model fit assessment via marginal model plots* | Sí | PDF completo, motivación diagnóstica, sintaxis y ejemplos | Sí |
| *marginscontplot: Plotting the marginal effects of continuous predictors* | Sí | PDF completo, ejemplos escalonados, sintaxis y cierre | Sí |
| *simsum: Analyses of simulation studies including Monte Carlo error* | Sí | PDF completo, sintaxis, discusión y mención a R en discusión | Sí |
| *Within- and between-cluster effects in generalized linear mixed models* | Sí | PDF completo, sintaxis, aplicaciones y vínculo con `meglm` | Sí |
| *merlin—A unified modeling framework for data analysis and methods development in Stata* | Sí | PDF completo, arquitectura, ejemplos, instalación SSC y `net install` de desarrollo | Sí |
| *Modeling count data with marginalized zero-inflated distributions* | Sí | PDF completo, sintaxis, ejemplos y nota sobre archivos de soporte/predicción/help | Sí |
| urlThe Stata Journal submission guidelinesturn10search0 | Sí | Requisitos oficiales de manuscrito, software, reproducibilidad y envío | No |
| urlThe Stata Journal FAQturn10search8 | Sí | Instalación de software SJ, tags y cita sugerida | No |
| urlStata net manualturn10search3 | Sí | Estructura `stata.toc`, `.pkg`, `net install`, `net sj`, `ado update` | Sí |
| urlSSC submission guideturn10search2 | Parcial | Solo resumen público y referencias cruzadas; la guía HTML completa no fue recuperable en esta sesión | No |
| urlBoston College Statistical Software Components archiveturn21search6 | Sí | Naturaleza de SSC/RePEc y editor de la serie | No |
| urlGitHub releases docsturn18search0 | Sí | Relación release/tag y gestión de releases | No |
| urlGitHub CITATION.cff docsturn17search0 | Sí | Uso de `CITATION.cff` | No |
| urlGitHub licensing docsturn17search2 | Sí | Buenas prácticas de licencia en repositorio | No |

La principal limitación práctica de esta revisión es SSC: pude confirmar la existencia y autoridad de la guía `SSCSUBMIT`, el rol archivístico de SSC/RePEc, y entradas concretas de paquetes ya publicados, pero no pude inspeccionar íntegramente la guía HTML de envío en esta sesión. Por eso, he diferenciado cuidadosamente entre **requisitos confirmados** y **recomendaciones de implementación**. En la parte de artículos, en cambio, el acceso fue suficiente para revisar PDFs completos y, por tanto, para imitar con bastante confianza la estructura editorial y técnica que mejor conviene a `qresid`. citeturn14search1turn21search6turn23view0turn23view1turn23view2turn23view3turn23view4turn23view5turn23view6turn23view7

## Juicio final para el diseño de `qresid`

Si tuviera que condensar toda la investigación en una sola recomendación editorial, sería esta: **`qresid` debería parecerse menos a un “manual de usuario” y más a un artículo tipo `chi2gof` + `marginscontplot` + `gpoisson`**. Eso significa: motivación diagnóstica clara, definición estadística compacta, sintaxis separada y completa, dos o tres ejemplos muy didácticos, y una validación propia convincente —idealmente una combinación de casos empíricos y simulación. En distribución, la estrategia más robusta es **doble carril**: paquete limpio y reproducible para el Journal, y al mismo tiempo infraestructura moderna de mantenimiento en urlGitHubhttps://github.com; si el software madura, SSC/RePEc añade discoverability e instalación más estándar para usuarios de Stata. Todo eso es coherente con las guías oficiales y con los mejores artículos de software revisados. citeturn19view0turn12view1turn20view0turn29search0turn29search1turn29search2