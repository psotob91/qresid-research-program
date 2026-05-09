# meglm, mepoisson, menbreg, melogit, xtpoisson, xtnbreg, xtlogit y gsem.

| Comando | Outcome / Familias relevantes | Predict options útiles | Predicción condicional vs marginal | Parámetros necesarios para CDF | Disponibilidad de simulación o dist. predictiva | Limitaciones para RQR analítico | Riesgos | Estado recomendado para `qresid` |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **`meglm`** | Gaussian, Bernoulli, binomial, gamma, negative binomial, ordinal, Poisson. | `mu`, `pr`, `eta`, `xb`, `density`, `distribution`. | Documentada. `conditional(ebmeans)` (por defecto), `conditional(ebmodes)`, `conditional(fixedonly)` y `marginal`. | `mu` y el parámetro de dispersión/escala correspondiente a la familia. | Opción `predict, distribution` calcula directamente la CDF empírica. | La CDF marginal rara vez tiene forma cerrada; se aproxima integrando los efectos aleatorios. | Computacionalmente pesado. Las predicciones con `ebmeans` o integraciones numéricas pueden ser lentas. | **Posponer a Fase 2** (Requiere enfoque PIT simulado tipo DHARMa). |
| **`mepoisson`** | Conteo (Poisson). | `mu`, `eta`, `xb`, `density`, `distribution`. | Documentada. Mismas opciones que `meglm`: `conditional(...)` y `marginal`. | $\hat{\mu}$ (conteo esperado) condicional o marginal. | Opción `predict, distribution` disponible. | La CDF marginal exacta es intratable analíticamente. | Evaluar la CDF exige cuadratura de Gauss-Hermite, lo que escala no linealmente y puede fallar. | **Posponer a Fase 2**. |
| **`menbreg`** | Conteo (Binomial Negativa, param. por media o constante). | `mu`, `eta`, `xb`, `density`, `distribution`. | Documentada. Mismas opciones que `meglm`: `conditional(...)` y `marginal`. | $\hat{\mu}$ y el parámetro de sobredispersión. | Opción `predict, distribution` disponible. | Requiere combinar la integración de efectos aleatorios con la sobredispersión intrínseca. | Inestabilidad en la estimación de la dispersión si se sobreparametriza con los efectos aleatorios. | **Posponer a Fase 2**. |
| **`melogit`** | Binaria o Binomial (Bernoulli/Binomial). | `pr` (probabilidad), `eta`, `xb`, `density`, `distribution`. | Documentada. Mismas opciones que `meglm`: `conditional(...)` y `marginal`. | $\hat{p}$ (probabilidad) y número de ensayos binomiales $m$. | Opción `predict, distribution` disponible. | Sin aleatorización explícita, produce artefactos (líneas) en los residuos debido a la discreción. | Interpretación de CDF depende estrictamente del ajuste correcto del efecto aleatorio latente. | **Posponer a Fase 2**. |
| **`xtpoisson`** | Conteo (Poisson en panel). | **EVIDENCIA PENDIENTE**. | **EVIDENCIA PENDIENTE**. | **EVIDENCIA PENDIENTE**. | **EVIDENCIA PENDIENTE**. | La literatura general de GLMM aplica: CDF analítica marginal no suele ser cerrada. | **EVIDENCIA PENDIENTE** (Fuentes solo lo listan como estimador). | **Posponer a Fase 2**. |
| **`xtnbreg`** | Conteo sobredisperso en panel. | **EVIDENCIA PENDIENTE**. | **EVIDENCIA PENDIENTE**. | **EVIDENCIA PENDIENTE**. | **EVIDENCIA PENDIENTE**. | Ver `xtpoisson`. | **EVIDENCIA PENDIENTE**. | **Posponer a Fase 2**. |
| **`xtlogit`** | Binario en panel. | **EVIDENCIA PENDIENTE**. | **EVIDENCIA PENDIENTE**. | **EVIDENCIA PENDIENTE**. | **EVIDENCIA PENDIENTE**. | Ver `xtpoisson`. | **EVIDENCIA PENDIENTE**. | **Posponer a Fase 2**. |
| **`gsem`** | Gaussian, Bernoulli, beta, binomial, ordinal, multinomial, Poisson, negative binomial, exp., Weibull, gamma, loglogistic, lognormal, pointmass. | `mu`, `pr`, `eta`, `density`, `distribution`, `survival`, `classpr`, `classposteriorpr`. | Documentada. `conditional(ebmeans/ebmodes/fixedonly)`, `marginal` y `pmarginal` (para clases latentes). | Valores esperados de las respuestas, probabilidades de clases latentes y varianzas integradas. | `predict, distribution` (excepto en multinomial) y `predict, survival` (para supervivencia). | **Extremadamente limitante:** La CDF marginal requiere integración numérica pesada o es intratable en modelos cruzados o con múltiples latentes. | Altamente propenso a problemas de convergencia, modelos no identificados e inestabilidad de varianzas (sobreparametrización). | **Posponer a Fase 2 o 3** (Ideal tratarlo exclusivamente con herramientas simuladas tipo DHARMa). |

**Notas Operativas para `qresid`:**
*   Para los modelos `me*` (multinivel), **Stata ofrece explícitamente `predict, distribution`** que calcula la CDF condicional o marginal. Esto teóricamente facilita el RQR, pero su evaluación marginal requiere cuadratura de Gauss-Hermite iterativa y puede ser inaceptablemente lenta.
*   Toda la evidencia teórica y de diseño del proyecto concuerda en que la inferencia de RQR exacto individual se corrompe con estructuras de dependencia complejas, por lo que **se desaconseja intentar derivaciones analíticas para estos comandos en la Fase 1**. En su lugar, la recomendación estructurada para el paquete es utilizar residuales basados en simulación (PIT simulados, estilo *DHARMa*) en la Fase 2.

# Extra summary

## Modelos Mixtos y Multinivel (Fase 2/3)

Este bloque define las reglas e impedimentos para aplicar RQR analítico en modelos de efectos aleatorios (`meglm`, `mepoisson`, `menbreg`, `melogit`, `gsem`) y longitudinales o de panel (`xtpoisson`, `xtnbreg`, `xtlogit`).

### 1. Estado y Criterios de Pospone 
*   **ESTÁNDAR OFICIAL:** Todos los modelos `me*` (incluidos `xt*` y `gsem`) quedan relegados a **Fases 2 y 3**.
*   **Justificación Matemática:** Para calcular RQR exacto en modelos multinivel se requiere una CDF marginal integrada empíricamente. En la inmensa mayoría de distribuciones no-Gaussianas jerárquicas, esta integral $\int F(y | b_i, x_i) dG(b_i)$ no tiene forma analítica cerrada.
*   **Limitaciones en Stata:** Evaluar estas densidades marginales exige métodos de cuadratura Gauss-Hermite iterativos (ej. `mvaghermite`), cuyo tiempo de cómputo y riesgo de fallo crecen exponencialmente con las dimensiones de los efectos aleatorios.

### 2. Extracción de Predicciones Condicionales y Simuladas
*   Si se requiriese evaluar residuales estandarizados condicionales:
    *   **Comandos `me*`:** Emplear `predict, mu conditional(ebmeans)` para fijar las medias empíricas de Bayes, o `conditional(fixedonly)` para excluir aleatoriedad. 
    *   **Comando `gsem`:** Emplea variables latentes categóricas o continuas complejas (`lclass()`).
*   **Enfoque Futuro PIT Simulado:** La literatura base del paquete (DHARMa) sugiere la simulación paramétrica $S$ veces del modelo generador. Para que `qresid` aborde la Fase 2 requiere extraer toda la matriz $\Sigma$ y `e(b)` para remuestreo, evitando intentar construir límites CDF algebraicos estáticos.

### 3. Riesgos Estructurales y Evidencia Pendiente
*   **GSEM Inestabilidad:** `gsem` permite parametrizar covarianzas y vías cruzadas extremas, por lo que recuperar `xb` automáticamente es numéricamente inviable sin invocar sintaxis de postestimación latente (`predict ..., latent()`).
*   **Dependencia Longitudinal (`xt*`):** La dependencia entre respuestas corrompe la asintótica del RQR. No se recomienda usar transformación PIT unidimensional sin lidiar primero con la estructura rotacional del error correlacionado.
*   **EVIDENCIA PENDIENTE:** La literatura auditada marca la inexistencia de opciones nativas para extraer CDFs integradas o utilidades equivalentes a DHARMa explícitas para Stata 19 base (`mepoisson`, `menbreg`, `melogit`), por lo que todo diseño `qresid` multinivel debe partir de cero.
