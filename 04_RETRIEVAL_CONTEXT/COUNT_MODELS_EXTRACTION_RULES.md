# poisson y nbreg

Basado en la literatura metodológica y la documentación de Stata proporcionada, aquí tienes la tabla operativa de extracción para los modelos de conteo principales requeridos en la Fase 1.

| Característica | `poisson` | `nbreg` |
| :--- | :--- | :--- |
| **Comando** | `poisson` | `nbreg` |
| **Predict options útiles** | `n` (número esperado de eventos), `xb` (predictor lineal), `ir` (tasa de incidencia). | `n` (número esperado de eventos), `xb` (predictor lineal), `ir` (tasa de incidencia). |
| **Cómo obtener xb** | `predict [var], xb`. | `predict [var], xb`. |
| **Cómo obtener mu/fitted** | `predict [var], n` (En los comandos de conteo de Stata, la opción `n` recupera el valor esperado $\hat{\mu}_i$). | `predict [var], n`. |
| **Cómo recuperar alpha/theta/dispersion** | N/A (La varianza es igual a la media). | La estimación reporta el logaritmo de la dispersión como coeficiente `/lnalpha`, por lo que $\hat{\alpha} = \exp(\text{\_b[/lnalpha]})$. El nombre exacto del escalar matricial en `e()` es **EVIDENCIA PENDIENTE** (posiblemente a extraer desde la matriz de coeficientes `e(b)`). El macro `e(dispersion)` guarda el tipo ("mean" o "constant"). |
| **Parametrización NB si está explícita** | N/A | Permite parametrización por "media" (NB2): varianza = $\mu_i(1 + \alpha\mu_i)$, y por "constante" (NB1): varianza = $\mu_i(1 + \delta)$. Para usar en la CDF nativa de Stata `nbinomial()`, en NB2 se requiere definir el tamaño $k = 1/\alpha$ y la probabilidad $p_i = k/(k + \mu_i)$. |
| **Offset / exposure** | Añade sumando `offset` o $\ln(exposure)$ al predictor lineal $x_i\beta$ con coeficiente restringido a 1. `predict` lo incluye por defecto en `n` o `xb`, pero se puede ignorar con la opción `nooffset` o usar la opción `ir` (incidence rate). Extraíble vía `e(offset)`. | Igual que `poisson`. |
| **Weights** | `fweights`, `pweights`, `iweights` permitidos. | `fweights`, `pweights`, `iweights` permitidos. |
| **e(sample)** | Condicional `if e(sample)` en las instrucciones postestimación. | Condicional `if e(sample)`. |
| **Stored results e() relevantes** | `e(cmd)`, `e(offset)`, matriz de varianzas `e(V)`. | `e(cmd)`, `e(offset)`, `e(dispersion)` ("mean" o "constant"). |
| **Riesgos para qresid** | Para valores de $\hat{\mu}_i$ extremadamente grandes o pequeños, la función CDF puede requerir aproximación numérica cuidadosa y el uso de funciones de precisión extendida en el generador. | Es crítico asegurar que el parámetro de dispersión ($k$ o $\alpha$) sea positivo y alinear estrictamente las diferencias de parametrización (NB1 vs NB2) entre el modelo estimado y el alimentado a la CDF `nbinomial(k, p)`. |
| **Estado para Fase 1** | **APROBADO**. Modelo fundacional directo según la teoría de Dunn-Smyth. | **APROBADO**. Prioridad alta, sujeta a la alineación del parámetro de dispersión y la consistencia con R. |

# zip, zinb, tpoisson, tnbreg, fmm y churdle.

Basado en las fuentes proporcionadas y el historial del proyecto, aquí tienes la tabla operativa de extracción para los comandos avanzados y de mezclas. 

Dado que tu instrucción es estricta sobre no inventar información, notarás que los comandos `tpoisson` y `tnbreg` tienen casi todos sus campos marcados como **EVIDENCIA PENDIENTE**, ya que la literatura suministrada solo los menciona en índices o referencias cruzadas sin detallar su sintaxis de postestimación o resultados `e()`.

### Tabla Operativa: Modelos de Exceso de Ceros, Truncados y Mezclas

| Característica | `zip` / `zinb` | `tpoisson` / `tnbreg` | `fmm` (Finite Mixture Models) | `churdle` (Linear / Exponential) |
| :--- | :--- | :--- | :--- | :--- |
| **Comando** | `zip` / `zinb` | `tpoisson` / `tnbreg` | `fmm:` (implementado vía `gsem`) | `churdle linear` / `churdle exponential` |
| **Componentes del modelo** | Conteo + Probabilidad de exceso de ceros (inflación) + Dispersión ($k$ en ZINB). | Conteo truncado. | Clases latentes categóricas + Probabilidades de clase latente + Modelo base por clase. | Modelo de selección (probabilidad de salto/hurdle) + Modelo de resultado continuo truncado. |
| **Predict options útiles** | Conteos esperados, probabilidades, `xb`, `scores`. **EVIDENCIA PENDIENTE** (opciones exactas de `predict` para aislar $\hat{\mu}$ condicional vs marginal). | **EVIDENCIA PENDIENTE** | `mu`, `classpr` (prob de clase latente), `density`, `distribution` (calcula la CDF directamente). | `ystar` (valor esperado), `xb`, `residuals`, `pr(a,b)` (probabilidad en un intervalo). |
| **Cómo obtener parámetros para CDF** | Requiere aislar $\hat{\mu}_i$ de la porción de conteo y combinarlo numéricamente. Extraer $k$ (`e(dispersion)`) para ZINB. | **EVIDENCIA PENDIENTE** | Para CDF continua, `predict [var], distribution` da el valor directo. Para discretas, requiere evaluar `distribution` en $y$ y $y^-$. | Puede evaluarse `predict [var], pr(., y)` que calcula la probabilidad $\text{Pr}(LL < Y < y)$. Esto estima parcialmente $F(y)$. |
| **Cómo obtener probabilidad cero / inflación / trunc.** | **EVIDENCIA PENDIENTE** (No se detalla la sintaxis exacta de `predict` para aislar $\hat{\pi}_i$ en la fuente, probablemente derivado de predict o evaluando su `xb`). | **EVIDENCIA PENDIENTE** | `predict [var], classpr` devuelve la probabilidad marginal de pertenecer a cada clase latente. | $\Phi(ll - z_i\hat{\gamma}_{ll})$ calculado manualmente. **EVIDENCIA PENDIENTE** si existe opción directa de `predict` para el modelo de selección. |
| **Offset / Exposure** | **EVIDENCIA PENDIENTE** (Asumido estándar pero no explícito en fuentes para ZIP/ZINB). | **EVIDENCIA PENDIENTE** | Extraíble vía la opción `nooffset` en predict y macros `e(offset#)`. | **EVIDENCIA PENDIENTE** (No listado en la sintaxis provista del comando). |
| **Stored results e() relevantes** | `e(cmd)="zip"` o `"zinb"`, `e(b)`, `e(V)`. | **EVIDENCIA PENDIENTE** | `e(cmd)="gsem"`, `e(lclass)`, `e(family#)`, `e(link#)`. | `e(cmd)="churdle"`, `e(estimator)`, `e(llopt)` (límite inferior), `e(ulopt)` (límite superior). |
| **Qué falta para construir RQR** | Combinar la masa del átomo en cero ($\hat{\pi}_i$) con la CDF discreta del conteo y aleatorizar el salto. | **EVIDENCIA PENDIENTE** | En caso de modelos discretos, combinar/sumar los $F_i(y)$ marginalizados sobre las clases. Evaluar factibilidad del PIT empírico/simulado (DHARMa). | Manejo correcto de la CDF mixta continua-discreta: aleatorización exigida en la masa discreta del límite (ej. ceros) y PIT directo en la parte continua truncada. |
| **Riesgos para qresid** | Usar CDF no inflada o confundir parametrizaciones. Inconsistencia entre Stata y paquetes R en ZINB. | **EVIDENCIA PENDIENTE** | La opción `distribution` puede ser intratable/muy lenta si hay variables latentes continuas. Computacionalmente pesado. | Error al tratar el peso de la masa discreta ($g(0)$ o $g(ll)$) y mal uso de la CDF no truncada. |
| **Estado recomendado** | **Posponer** a Fase 2 (Extensión metodológica planificada). | **Posponer** a Fase 2. | **Experimental / Posponer**. Útil mediante simulación (DHARMa-like). | **Posponer** a Fase 2. |

### Conclusión Estratégica
De acuerdo al documento "03_STATA_PACKAGES_RQR_MASTER" y "PROJECT_BRIEF_QRESID", intentar atacar `zip`, `zinb`, `churdle` y `fmm` al mismo tiempo que los GLM estándar introducirá riesgos severos de validación. 

**Decisión operativa para la API de `qresid`:** 
El *dispatcher* interno debe arrojar un error controlado `exit 198` indicando que *"El modelo [zip/churdle/fmm] está programado para la Fase 2 del paquete"* y rechazar la ejecución hasta que la infraestructura de aleatorización base (Poisson/NB/Gamma/Binomial) esté certificada en CRAN/Stata Journal.

# Extra summary
## Modelos de Conteo, Exceso de Ceros y Truncamiento

En distribuciones de conteo, la aleatorización continua ocurre en el espacio del salto discreto de la CDF. El residuo cuantílico está dictado por variables límite $\hat{a}_i$ y $\hat{b}_i$.

### 1. Requisitos Endpoints CDF 
*   **Límite izquierdo ($\hat{a}_i$):** Definido como la CDF evaluada en $y_i^-$, numéricamente implementado en Stata como $F(y_i - 1; \hat{\theta})$.
*   **Límite derecho ($\hat{b}_i$):** Definido directamente como $F(y_i; \hat{\theta})$.
*   **Variables Aleatorias:** Sembrar un valor uniforme $V_i \sim U(0,1)$ para generar $U_i = \hat{a}_i + V_i(\hat{b}_i - \hat{a}_i)$.

### 2. Extracción de Parámetros Base
*   `poisson`: Predictor de media $\hat{\mu}_i$ disponible a través de `predict, n`. CDF obtenible mediante `poisson(y, mu)` nativo de Stata.
*   `nbreg`: Requiere extraer el parámetro de sobredispersión (frecuentemente llamado $\alpha$ o tamaño $k$). En el modo NB2, la varianza es $\mu_i(1 + \alpha\mu_i)$. El parámetro en `nbreg` puede extraerse calculando $1/\hat{\alpha}$ según el escalar logarítmico matricial o `e(dispersion)`. La CDF utiliza `nbinomial()`.
*   **Estado Fase 1:** `poisson` y `nbreg` son ESTÁNDAR OFICIAL priorizados.

### 3. Modelos Avanzados de Mezcla (Fase 2)
*   **Modelos Zero-Inflated (`zip`, `zinb`):** 
    *   Los modelos constan de probabilidad de inflación $\hat{\pi}_i$ y media condicional $\hat{\mu}_i$. 
    *   La CDF modificada toma la forma: $F_i(0) = \hat{\pi}_i + (1-\hat{\pi}_i)F_{\text{base}}(0)$.
*   **Modelos Hurdle (`churdle linear`/`exponential`):**
    *   Exigen separar la probabilidad de superar el obstáculo, modelada con $Pr(Y_i = ll|z_i)$. 
    *   Variables predictoras en el mecanismo de selección deben leerse usando `select()` limits e interactuar con la parte truncada.
*   **Modelos truncados (`tpoisson`, `tnbreg`):**
    *   **EVIDENCIA PENDIENTE**: El acceso y denominación exacta de la postestimación y CDF truncada no está documentado operativamente en las referencias oficiales suministradas.
*   **Riesgos y Decisión Operativa:** Recrear analíticamente el residuo cuantílico sobre densidades discretas mixtas es computacionalmente pesado e inestable. Se declaran aplazados y asignados metodológicamente a la Fase 2 del desarrollo (para soporte analítico compuesto o enfoques simulados).