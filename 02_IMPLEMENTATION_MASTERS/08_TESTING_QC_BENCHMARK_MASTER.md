<!--
Este documento establece un plan de pruebas y control de calidad (QC) para `qresid`.
Se apoya en los documentos teóricos, en el inventario de paquetes R y en el casebank recomendado.
El objetivo es verificar la exactitud numérica, reproducibilidad y comparabilidad con R, así como detectar errores y límites en las implementaciones en Stata.
-->

# Plan de pruebas y control de calidad para `qresid`

## 1 Principios generales de validación

Los documentos del proyecto recomiendan comparar Stata y R de forma escalonada: primero los parámetros y valores ajustados, después los valores de la CDF por observación —o, en discretas, los límites F(y-) y F(y)— y solo al final la transformación aleatoria【filecite†L15-L17】.  Esta estrategia evita que diferencias en el generador aleatorio oculten errores en la parametrización o en la evaluación de la CDF y constituye la base del plan de pruebas.

Además, las pruebas deben distinguir entre implementaciones analíticas (basadas en CDF cerrada) y PIT/simuladas.  Para las primeras se espera comparaciones exactas observación a observación; para las segundas solo se exige coincidencia en el mecanismo, en los intervalos y en las distribuciones agregadas【filecite†L39-L48】.

El banco de datasets (casebank) seleccionado para la fase inicial proporciona ejemplos con CDF conocida, tamaño moderado y patrones diagnósticos claros【filecite†L1-L20】.  Estos datasets —CrabSatellites, bioChemists, NMES1988, esoph y GasolineYield— serán la base de muchas pruebas.

## 2 Diseño de pruebas unitarias

Las pruebas unitarias validan piezas individuales de código sin depender de un modelo completo.  Se aconseja estructurarlas en carpetas `tests/unit/` por familia.

### 2.1 Cálculo de la CDF y de los intervalos

* **Objetivo:** verificar que, dado un conjunto de parámetros (mu, theta), el programa calcula correctamente F(y-) y F(y).
* **Método:** seleccionar valores de y y parámetros para los cuales la CDF tiene valores conocidos (por ejemplo Poisson con mu=1 para y=0,1,2) y comparar con las funciones de Stata (`poisson()`, `binomial()`, `gammap()`).  Para familias sin CDF nativa emplear un plugin o valores precomputados en R.
* **Casos de borde:** y=0, y muy grande, mu muy pequeña o muy grande, dispersiones extremas.
* **Criterio de éxito:** coincidencia dentro de tolerancia numérica (`1e-12` en continuas, `1e-8` en discretas) y verificación de que F(y-) ≤ F(y).

### 2.2 Transformación PIT y normal

* **Objetivo:** asegurar que el algoritmo uniforme produce U_i dentro de [F(y-), F(y)] y que la transformación normal se aplica correctamente.
* **Método:** para casos continuos, verificar que U_i=F(y) exactamente; para discretos, fijar semilla (`set seed`) y comprobar que los valores generados por `runiform()` en Stata se utilizan de manera correcta (o probar con `uvar()` definido por el usuario).
* **Casos de borde:** F(y-)=F(y) (por ejemplo cuando la observación cae en un intervalo continuo); F(y) aproximado a 0 o 1.
* **Criterio de éxito:** U_i dentro del intervalo y residuo no missing inesperado.

### 2.3 Manejo de offset y peso

* **Objetivo:** asegurar que el offset se incorpora en la predicción y que los pesos multiplican el residuo cuando procede.
* **Método:** definir un modelo simple con un offset constante (por ejemplo Poisson con exposición) y comprobar que, al anular el offset, los residuos cambian de forma coherente; verificar que al pasar `weight()` el residuo resultante se multiplica por la raíz del peso como indica la teoría.
* **Criterio de éxito:** coincidencia con resultados manuales o con R en modelos con offset y pesos.

### 2.4 Gestión de valores faltantes y submuestras

* **Objetivo:** comprobar que las observaciones fuera del rango `if`/`in` o con valores faltantes obtienen residuo `missing` y no se usan en cálculos intermedios.
* **Método:** crear datos con valores faltantes en y o en covariables y ejecutar `qresid`; verificar que el resultado es `.` en las posiciones correspondientes y que no genera errores.

## 3 Diseño de pruebas de integración

Las pruebas de integración evalúan el paquete en el contexto de un modelo completo.  Se recomienda ubicarlas en `tests/integration/` y replicar cada escenario en Stata y R.

### 3.1 Comparación exacta con R

Para familias con CDF analítica, las comparaciones deben ser observación a observación.  El flujo de validación es:

1. Ajustar el modelo en R (por ejemplo con `glm()` o `MASS::glm.nb()`) y en Stata con la misma fórmula y enlace.
2. Comparar coeficientes y fitted values; deben coincidir hasta la tolerancia numérica.
3. Evaluar F(y-) y F(y) en ambos programas; deben coincidir exactamente en continuas y hasta `1e-12` en discretas.
4. Generar uniformes idénticos: exportar un vector V_i de R a Stata y usar la opción `uvar()` para producir los mismos residuos; comparar r_i observación a observación.

Esta metodología está en línea con la recomendación de evitar que diferencias de RNG oculten errores reales【filecite†L15-L17】.  Para Poisson, binomial, NB, Gamma y Gaussian, `statmod` y `VGAM` son referencias de oro.

### 3.2 Validación con datasets del casebank

Para los cinco datasets de la fase inicial (CrabSatellites, bioChemists, NMES1988, esoph, GasolineYield)【filecite†L1-L20】 se propone:

1. Ajustar el modelo inicial sugerido en cada dataset tanto en R como en Stata.
2. Seguir el flujo de comparación exacta descrito en 3.1.
3. Analizar los gráficos de residuos (QQ, residuo vs ajustado, residuo vs covariable) y comprobar que los patrones coinciden con los descritos en el casebank y en la literatura.
4. Documentar cualquier discrepancia y revisar si se debe a parametrización, offset o a la implementación de la CDF.

### 3.3 Escenarios con offset y proporciones

Utilizar datasets como `LGAclaims` (Poisson con offset y tasas) y `GasolineYield` (beta-regresión) para verificar el manejo de offset y pesos.  El diseño contempla: ajustar el modelo en R (`glm()` con `offset()` o `betareg`), exportar parámetros y fitted values a Stata, ejecutar `qresid` y comparar CDFs y residuos.

### 3.4 Pruebas de interfaz y opciones

Verificar que las opciones de `qresid` funcionan correctamente:

- `generate()` crea la variable con el nombre solicitado y respeta el tipo `double`.
- `seed()` fija la semilla y produce residuos reproducibles.
- `uvar()` admite un vector de uniformes externo y, si su longitud difiere de n, devuelve un error amigable.
- `weight()` y `offset()` deben ser compatibles con los modelos estimados y, en caso contrario, producir mensajes claros.

## 4 Pruebas de reproducibilidad

La reproducibilidad es crítica cuando el algoritmo utiliza aleatorización.  Se proponen:

1. **Semilla fija:** ejecutar `qresid, seed(12345)` dos veces consecutivas; los residuos deben ser idénticos.
2. **Semilla distinta:** cambiar la semilla y comprobar que los intervalos (F(y-), F(y)) se mantienen pero los residuos cambian, evidenciando la aleatorización.
3. **Uniformes externos:** generar un vector V_i de R y pasarlo por `uvar()`; los residuos deben coincidir con los de R.
4. **Persistencia:** escribir los uniformes utilizados en un archivo o variable auxiliar para poder regenerar exactamente los mismos residuos en pruebas posteriores.

## 5 Pruebas de errores esperados

Estas pruebas confirman que el programa reacciona adecuadamente ante entradas no válidas.  Casos a considerar:

- **Familia no soportada:** llamar a `qresid` con `distribution()` desconocido debe devolver un error claro.
- **Parámetros imposibles:** dispersión negativa, probabilidades fuera de [0,1] o tamaño NB no positivo deben generar errores o advertencias.
- **Valores fuera de soporte:** respuestas negativas para conteos, valores y mayores que m en binomial, o y menores que cero en Gamma; el programa debe negarse a calcular la CDF y asignar residuo `missing` o abortar con explicación.
- **Longitud incorrecta de `uvar()`:** si el vector de uniformes externo tiene longitud distinta de n, debe emitir error o recortar/expandir de forma documentada.
- **Offset o peso no compatibles:** usar `offset()` o `weight()` cuando el modelo activo no los tuvo; el programa debe advertir al usuario.

## 6 Pruebas de límites y escenarios extremos

Para asegurar robustez numérica y diagnóstica, se deben incluir pruebas con valores extremos y condiciones límite.  La tabla siguiente resume algunos ejemplos:

| Escenario | Descripción breve | Motivo de la prueba |
|---|---|---|
| **y=0** | Observaciones con cero en distribuciones discretas (Poisson, NB, binomial, ZIP, ZINB) | La CDF inferior puede ser 0 o puede incluir el peso inflado; verifica la fórmula de la CDF y la aleatorización. |
| **Probabilidades extremas** | Probabilidad de éxito muy cercana a 0 o 1 en binomial; media muy pequeña o grande en Poisson/NB | Valida que la CDF no devuelva 0 o 1 exactos salvo en los extremos y que la función `invnormal()` no produzca valores infinitos. |
| **CDF igual a 0 o 1** | F(y-)=0 o F(y)=1, por ejemplo en colas | El residuo debería tender a menos o más infinito; en la práctica debe saturarse o advertir al usuario sobre valores extremos. |
| **Media ajustada muy pequeña o grande** | Casos con mu<1e-6 o mu>1e6 | Asegura que la CDF se evalúa sin underflow/overflow y que la transformación normal sigue siendo estable. |
| **Sobredispersión extrema** | NB con parámetro de tamaño muy pequeño (alta dispersión) | Comprueba que la CDF NB se maneja correctamente y que la aleatorización no se degenera. |
| **Missing data** | Observaciones con `.` en la respuesta o en covariables | Valida la propagación de `missing` y que los residuos se omitan correctamente. |
| **Factor variables** | Uso de variables categóricas con la sintaxis `i.var` en Stata | Verifica que el vector de covariables se interpreta correctamente y que los parámetros se aplican sin ambigüedades. |
| **Subconjuntos (`if`/`in`)** | Computar residuos solo para un subconjunto | Asegura que las observaciones fuera del subconjunto permanecen sin alterar. |
| **Pesos** | Pesos muy grandes o muy pequeños | Valida que la multiplicación por la raíz del peso no sature y que los tests comparativos los tengan en cuenta. |

## 7 Estrategia para el generador aleatorio (RNG)

El RNG es un componente clave en discretas.  El plan propone:

1. **Documentar la no equivalencia de RNG:** Stata y R utilizan generadores diferentes, de manera que el residuo aleatorizado no es comparable salvo que se comparta el vector V_i【filecite†L15-L17】.
2. **Opción `seed()`**: ofrecer un argumento `seed()` que fije la semilla de Stata antes de llamar a `runiform()`.
3. **Opción `uvar()`**: permitir al usuario pasar un vector de uniformes predefinidos; esto es imprescindible para replicar exactamente los residuos de R y es la ruta recomendada para benchmarking.
4. **Guardar uniformes:** generar, si el usuario lo pide, una variable que almacene V_i para reproducibilidad y para auditorías.
5. **Comparación determinista:** para validar entre lenguajes, centrarse en las capas deterministas —coeficientes, fitted values y límites de la CDF— y solo comparar residuos aleatorizados cuando se comparta el vector V_i【filecite†L15-L17】.

## 8 Definición de tolerancias

Las comparaciones numéricas deben considerar errores de redondeo y diferencias en la implementación de funciones especiales.  Se proponen las siguientes categorías:

* **Igualdad exacta:** se espera coincidencia exacta para parámetros y fitted values en modelos continuos simples y CDFs cuando se usan funciones deterministas idénticas.
* **Cercanía numérica:** para CDFs en discretas y funciones especiales (Gamma, NB) se acepta una diferencia absoluta menor que 1e-12 o relativa menor que 1e-8.
* **Igualdad de distribución:** para residuos aleatorizados sin vector de uniformes compartido, se compararán histogramas, QQ-plots o pruebas de uniformidad/normalidad; se espera que las distribuciones sean indistinguibles visualmente y que las pruebas no rechacen la hipótesis de igualdad bajo tolerancias estándar.
* **Equivalencia gráfica:** los gráficos de diagnóstico deben exhibir patrones similares (alineación en QQ, ausencia de estructura en residuos vs fitted); pequeñas diferencias de ruido aleatorio se consideran aceptables【filecite†L1-L20】.

## 9 Estructura de carpetas para pruebas y certificación

Se recomienda la siguiente estructura de directorios en el repositorio:

- `tests/`
  - `unit/` – scripts de pruebas unitarias por familia y funcionalidad.
  - `integration/` – pruebas que ajustan modelos completos en Stata, comparan con R y verifican gráficos.
  - `r_benchmarks/` – scripts en R que producen coeficientes, fitted values y CDFs para los datasets del casebank, así como vectores de uniformes para comparación.
  - `data/` – subcarpeta con los datasets transformados a formato Stata (o scripts para descargarlos de la fuente) con licencia clara【filecite†L1-L20】.
  - `helpers/` – funciones comunes para lectura/escritura de uniformes, comparación de vectores, etc.
- `certification/`
  - Documentos de certificación de pruebas (por ejemplo informes en Markdown o resultados de `log files`).
  - Scripts y salidas que documentan la concordancia con R y que puedan adjuntarse a un envío al Stata Journal.

Esta estructura facilita la automatización y permite una trazabilidad clara entre código, datos y resultados.  Cada prueba debe poder ejecutarse mediante `do`-files independientes o con una suite de pruebas automatizada.

## 10 Resumen y pasos siguientes

El plan de pruebas aquí descrito proporciona un marco robusto para validar `qresid`: desde pruebas unitarias de CDF hasta comparaciones exactas con R y exploración de límites numéricos.  Aplica la estrategia de validar primero capas deterministas y solo después la parte aleatoria【filecite†L15-L17】.  La combinación de datasets seleccionados, tolerancias explícitas y manejo cuidadoso del RNG permitirá certificar que la implementación en Stata cumple con la teoría de Dunn–Smyth【filecite†L39-L48】 y con los estándares reproducibles para software estadístico.  En fases posteriores, se añadirán pruebas para modelos inflados, hurdle y residuales PIT simulados, siguiendo la progresión sugerida en el casebank y en la documentación de gráficos y tests【filecite†L1-L20】.