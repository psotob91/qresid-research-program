# glm y regress.

| Característica | `glm` | `regress` |
| :--- | :--- | :--- |
| **Comando** | `glm` | `regress` |
| **Familias/enlaces relevantes para qresid** | Gaussian, Binomial, Poisson, Negative Binomial, Gamma. Inverse Gaussian (requiere Mata/plugin para CDF). Tweedie explícitamente excluido en Fase 1. | Gaussian (Normal) / Identity. |
| **Predict options útiles** | `mu` (valor esperado), `xb` o `eta` (predictor lineal). | `xb` (predictor lineal/fitted value). |
| **Cómo obtener xb** | `predict [var], xb` o `predict [var], eta`. | `predict [var], xb`. |
| **Cómo obtener mu/fitted** | `predict [var], mu`. | `predict [var], xb` (en el modelo lineal normal, el predictor coincide con la media). |
| **Cómo obtener dispersión/scale/sigma** | Escalar `e(phi)`. Para Gamma, parámetro de forma $k = 1/\hat{\phi}$ y escala $s = \hat{\mu}_i/k$. | Escalar `e(rmse)` (devuelve la desviación estándar residual $\hat{\sigma}$). |
| **Cómo identificar muestra de estimación** | Variable marcadora generada vía `e(sample)` o condicional `if e(sample)`. | Variable marcadora generada vía `e(sample)` o condicional `if e(sample)`. |
| **Manejo de offset/exposure** | Recuperar desde `e(offset)`. Se suma a la parte lineal `xb` antes de invertir el enlace. | No aplica de forma nativa para el modelo lineal estándar / **EVIDENCIA PENDIENTE**. |
| **Stored results e() relevantes** | `e(cmd)`, `e(family)`, `e(link)`, `e(phi)`, `e(offset)`. | `e(cmd)`, `e(rmse)`. |
| **Riesgos para qresid** | Stata no tiene función nativa de CDF para Inverse Gaussian (requiere Mata). Peligro de sumar doble el offset si `predict, xb` ya lo incluye al intentar calcular `mu` manualmente. Riesgo de no normalizar la parametrización de dispersión correctamente en Gamma o Negative Binomial al alimentar la CDF. | Confundir el cálculo. Aunque la transformación RQR en Gaussian equivale esencialmente a residuales estandarizados clásicos, debe aplicarse la transformación integral de probabilidad (CDF normal evaluada con `e(rmse)`) para mantener el rigor del pipeline. |
| **Estado para Fase 1** | **APROBADO** (Foco principal del proyecto para distribuciones de conteo, proporciones y sesgadas continuas). | **APROBADO** (Útil como benchmark base y confirmación estructural). |

# logit, logistic, binreg

Basado en las fuentes proporcionadas y el historial de nuestra conversación, aquí tienes la tabla operativa para los comandos solicitados. Dado que el comando `blogit` no se menciona ni se documenta en las fuentes analizadas, se marca estrictamente según tus instrucciones.

| Característica | `logit` / `logistic` | `binreg` | `blogit` |
| :--- | :--- | :--- | :--- |
| **Comando** | `logit` / `logistic` | `binreg` | `blogit` |
| **Tipo de outcome soportado** | Variable dicotómica (0/1 o distinto de 0). | Bernoulli (0/1) o Binomial (número de éxitos). | **EVIDENCIA PENDIENTE** |
| **Bernoulli vs binomial agrupado** | Bernoulli. | Soporta ambos. Usa la opción `n(# | varname)` para binomial agrupado. Si se omite, asume Bernoulli. | **EVIDENCIA PENDIENTE** |
| **Predict options útiles** | `pr` (probabilidad), `xb` (predictor lineal) (Contexto previo). | `mu` (valor esperado/probabilidad), `xb` (predictor lineal), `eta` (sinónimo de xb). | **EVIDENCIA PENDIENTE** |
| **Cómo obtener xb** | `predict [var], xb` (Contexto previo). | `predict [var], xb` o `predict [var], eta`. | **EVIDENCIA PENDIENTE** |
| **Cómo obtener probabilidad / fitted** | `predict [var], pr` (Contexto previo). | `predict [var], mu`. | **EVIDENCIA PENDIENTE** |
| **Cómo recuperar número de ensayos si aplica** | N/A (asume 1 ensayo por ser Bernoulli). | Mediante el escalar/macro `e(m)` (number of binomial trials). | **EVIDENCIA PENDIENTE** |
| **e(sample)** | Extraíble vía condicional `if e(sample)` en postestimación. | Extraíble explícitamente vía `if e(sample)` en el comando `predict`. | **EVIDENCIA PENDIENTE** |
| **Weights** | `fweights` documentados explícitamente en ejemplos. (Otros tipos asumidos pero **EVIDENCIA PENDIENTE** en el texto estricto). | `fweights`, `iweights` y `pweights` permitidos oficialmente. | **EVIDENCIA PENDIENTE** |
| **Stored results e() relevantes** | `e(cmd)`, `e(b)`, `e(V)`, `e(sample)` (Contexto general). | `e(cmd)`, `e(m)` (trials), `e(linkf)`, `e(varfuncf)`. | **EVIDENCIA PENDIENTE** |
| **Riesgos para qresid** | Predicciones sin aleatorización recrean líneas visibles; extremadamente sensible a medias extremas. En muestras pequeñas, resultados completamente determinados fallan. | Con enlace de identidad (`rd`), `predict` puede ajustar probabilidades fuera del rango $(0,1)$ que Stata trunca (ej. a 1e-4) internamente. Esto alterará los límites de la CDF. | **EVIDENCIA PENDIENTE** |

# Extra summary

## Modelos Lineales Generalizados (Fase 1)

Este documento estructura las reglas de extracción paramétrica en modelos con respuestas estocásticas continuas y binarias de tipo independiente.

### Comandos y Familias Soportadas
*   **Comandos objetivos:** `glm`, `regress`, `logit`, `logistic`, `binreg`.
*   **Comandos pospuestos:** `blogit` (**EVIDENCIA PENDIENTE**: Sintaxis predictiva y parámetros e() específicos no encontrados en los manuales de referencia base para automatización de la CDF).
*   **Familias/Enlaces (Fase 1):** Gaussian/normal (identidad), Binomial/Bernoulli (logit, probit, cloglog), Poisson (log), Binomial negativa (log), y Gamma (log, inversa). La familia Tweedie requiere aproximaciones especiales o plugins no nativos.

### Reglas de Extracción de Parámetros (`predict` y dispersión)
*   `glm`: Utilizar `predict, mu` para la media esperada condicional $\hat{\mu}_i$. La dispersión o escala $\phi$ se reporta en el escalar `e(phi)`.
*   `regress` (Linear/Gaussian): Utilizar `predict, xb`. El parámetro de dispersión es recuperado desde el escalar `e(rmse)`, equivalente a la desviación estándar residual $\hat{\sigma}$.
*   `logit` / `logistic`: Utilizar `predict, pr` para extraer $\hat{\mu}_i$ o probabilidad esperada $\hat{p}_i$. Los ensayos para datos agrupados binomiales se registran en `e(N)` o en variables especificadas en las opciones binomiales.
*   `binreg`: Opciones `rd` (risk difference, identidad), `rr` (risk ratio, log), `hr` (health ratio, log complemento), y `or` (odds ratio, logit) definen el enlace de la predicción `pr`. El macro `e(m)` almacena el número de ensayos si es un modelo binomial.

### Riesgos de Implementación para `qresid`
*   **RECOMENDACIÓN OPERATIVA:** Si el modelo ajustado incluye pesos analíticos (por ej. ponderaciones frecuentistas), la normalización $\Phi^{-1}(U_i)$ debe incluir $\sqrt{w_i}$.
*   **Aleatorización en variables de soporte acotado:** Sin un "jittering" uniforme estricto entre $F_i(y^-)$ y $F_i(y)$ en datos binomiales, persistirán patrones residuales paralelos indeseables.
*   **Offsets dobles:** Si se requiere un procesamiento manual del valor estimado usando `xb`, evite sumar dos veces el término $o_i$; comandos predictivos como `xb` ya pueden estar absorbiéndolo internamente.
| **Estado para Fase 1** | **APROBADO** (Soporte principal y directo según teoría Dunn-Smyth). | **APROBADO** (Soporte explícito para Binomial/Bernoulli en Fase 1). | **EVIDENCIA PENDIENTE** |