# Extraction rules

**Tablas Operativas de Extracción (Por Comando)**

| Comando | Outcome | Estimation Sample | Fitted Values | xb / eta | Disp / m / Theta | Offset / Exposure | e() identificadores (ESTÁNDAR) |
| --- | --- | --- | --- | --- | --- | --- | --- |
| **glm** | `e(depvar)` | `e(sample)` | `predict, mu` | `predict, xb` o `eta` | `e(m)` (binomial) / `e(phi)` | `e(offset)` | `e(cmd)="glm"`, `e(family)`, `e(link)` |
| **regress** | `e(depvar)` | `e(sample)` | `predict, xb` | `predict, xb` | `e(rmse)` | **EVIDENCIA PENDIENTE** | `e(cmd)="regress"` |
| **poisson** | `e(depvar)` | `e(sample)` | `predict, n` | `predict, xb` | N/A | `e(offset)` | `e(cmd)="poisson"` |
| **nbreg** | `e(depvar)` | `e(sample)` | `predict, n` | `predict, xb` | **EVIDENCIA PENDIENTE** (param exacto) | `e(offset)` | `e(cmd)="nbreg"` |
| **logit** / **logistic** | `e(depvar)` | `e(sample)` | `predict, pr` | `predict, xb` | N/A | **EVIDENCIA PENDIENTE** | `e(cmd)="logit"` o `"logistic"` |
| **binreg** | `e(depvar)` | `e(sample)` | `predict, mu` | `predict, xb` o `eta`| `e(m)` | `e(offset)` | `e(cmd)="binreg"`, `e(family)`, `e(link)` |
| **blogit** | **EVIDENCIA PENDIENTE** | **EVIDENCIA PENDIENTE** | **EVIDENCIA PENDIENTE** | **EVIDENCIA PENDIENTE** | **EVIDENCIA PENDIENTE** | **EVIDENCIA PENDIENTE** | **EVIDENCIA PENDIENTE** |
| **zip** / **zinb** | `e(depvar)` | `e(sample)` | **EVIDENCIA PENDIENTE** (counts) | `predict, xb` | **EVIDENCIA PENDIENTE** | **EVIDENCIA PENDIENTE** | `e(cmd)="zip"` o `"zinb"` |
| **meglm** | `e(depvar)` | `e(sample)` | `predict, mu` | `predict, xb` o `eta`| `e(dispersion)`, `e(binomial)` | `e(offset)` | `e(cmd)="meglm"`, `e(family)`, `e(link)` |
| **mepoisson** | `e(depvar)` | `e(sample)` | `predict, mu` | `predict, xb` o `eta`| N/A | `e(offset)` | `e(cmd2)="mepoisson"`, `e(family)` |
| **menbreg** | `e(depvar)` | `e(sample)` | `predict, mu` | `predict, xb` o `eta`| `e(dispersion)` | `e(offset)` | `e(cmd2)="menbreg"`, `e(family)` |
| **melogit** | `e(depvar)` | `e(sample)` | `predict, mu` | `predict, xb` o `eta`| `e(binomial)` | `e(offset)` | `e(cmd2)="melogit"`, `e(family)` |
| **gsem** | `e(depvar)` | `e(sample)` | `predict, mu` | `predict, eta` | `e(family#)`, `e(link#)` | `e(offset#)` | `e(cmd)="gsem"` |

*(Nota: En comandos `me*`, Stata guarda el comando general en `e(cmd)` como "meglm" y el subcomando específico en `e(cmd2)`).*

---

**Checklist Operativo para `qresid`**

1. **Validación del entorno:** Confirmar que `e(cmd)` no está vacío. Rechazar si el comando no está soportado.
2. **Determinación del tipo de modelo y familia:** Utilizar `e(family)` y `e(link)` si están disponibles. Si el comando es específico (ej. `poisson`), forzar internamente la familia "poisson" y el enlace "log" si los escalares de e() no existen.
3. **Manejo de estimadores compuestos (multinivel/gsem):** 
   - Revisar si es `gsem`. Si lo es, iterar sobre `e(depvar)` o exigir al usuario el parámetro `outcome()` para saber de qué variable dependiente calcular la CDF.
   - En modelos `me*` y `gsem`, decidir si el `predict` usará medias empíricas de Bayes (RECOMENDACIÓN OPERATIVA: evaluar `predict, conditional(ebmeans)` o `fixedonly`).
4. **Captura de Weights:** Identificar si `e(wtype)` y `e(wexp)` existen. No aplicar `sqrt(w_i)` global en la etapa final; registrar tipo/expresión y activar pesos solo con regla por familia validada.
5. **Cálculo de Límites CDF (\(\hat{a}_i\) y \(\hat{b}_i\)):** Extraer el `mu` o los predictores lineales. **No existe una opción universal de Stata para predecir la CDF**. Debes calcular numéricamente `F(y)` y `F(y^-)` usando las funciones de Mata o Stata (`poisson()`, `binomial()`, `nbinomial()`, `gammap()`, etc.) alimentadas con el `mu` extraído.

---

**Snippets Básicos de Implementación**

```stata
* ESTÁNDAR OFICIAL: Verificación de modelo y entorno
if "`e(cmd)'" == "" {
    display as error "No hay modelo activo. Ajuste primero un modelo soportado."
    exit 198
}

* RECOMENDACIÓN OPERATIVA: Normalizar el comando principal para el despachador
local model = e(cmd)
if "`model'" == "meglm" & "`e(cmd2)'" != "" {
    local model = e(cmd2)
}

tempvar touse
gen byte `touse' = e(sample)

* RECOMENDACIÓN OPERATIVA: Mapeo de predict según el comando evaluado
tempvar mu
if inlist("`model'", "glm", "binreg", "meglm", "melogit", "mepoisson", "menbreg", "gsem") {
    * ESTÁNDAR OFICIAL: Devuelve el valor esperado
    predict double `mu' if `touse', mu 
}
else if inlist("`model'", "poisson", "nbreg") {
    * ESTÁNDAR OFICIAL: En comandos clásicos de conteo, 'n' es el número esperado de eventos
    predict double `mu' if `touse', n 
}
else if inlist("`model'", "logit", "logistic") {
    * ESTÁNDAR OFICIAL: probabilidad de un resultado positivo
    predict double `mu' if `touse', pr 
}
else if inlist("`model'", "regress") {
    predict double `mu' if `touse', xb
}
else {
    display as error "El modelo `model' es EVIDENCIA PENDIENTE o no soportado."
    exit 198
}

* Extraer parámetros accesorios (ej. offset/exposure o número de ensayos binomial)
local offset = e(offset)
local binomial_trials = e(m) /* ESTÁNDAR OFICIAL para binreg */
if "`model'" == "melogit" {
    local binomial_trials = e(binomial) 
}
```

---

**Riesgos de Extracción**

- **Inconsistencia de parametrizaciones (NB / Gamma):** Stata parametriza la dispersión Binomial Negativa a través de `k` (en NB2: `k = 1/alpha`). Al extraer el `mu`, el parámetro que recuperes en `e()` (ej. escalar `e(alpha)` para `nbreg` - EVIDENCIA PENDIENTE) debe pasarse con la convención estricta que exige la función nativa `nbinomial(k, n, p)` en Stata.
- **Nombres de coeficientes en GSEM/Multinivel:** `gsem` tiene una sintaxis de recuperación de varianzas y covarianzas muy específica en `e(b)` (ej. `_b[/var(e.y)]` o `_b[wage:L]`). Extraer la dispersión automatizadamente requiere rutinas de parsing exactas.
- **`predict` fallará silenciosamente (Genera missings):** Si hay variables con observaciones fuera de rango o submuestras condicionales (`if`/`in`), `predict` rellenará con missing. Tu algoritmo de RQR debe heredar esos `.`, evitar imputar ceros y saltar al siguiente `i`.
- **Offsets / Exposure duplicados:** Muchos comandos incorporan automáticamente el `offset` en la parte lineal cuando se usa `predict`. Calcular la media manualmente usando `xb` puede generar dobles sumas si el `predict, xb` ya incluye (o no) el `offset`. Se recomienda extraer directamente el valor final esperado con `mu` o `n`.

---

**Qué se puede extraer, qué no y qué validar**

**Se puede extraer:**
- Predicciones puntuales (`mu`, `n`, `pr`, `xb`, `eta`).
- Muestras condicionales y marcas de inclusión en el ajuste (`e(sample)`).
- Pesos (`e(wexp)`).
- Componentes macro del modelo base (`e(cmd)`, `e(family)`, `e(link)`).

**No se puede extraer:**
- El **residuo cuantílico aleatorizado** precalculado. No es nativo de la postestimación oficial en ninguno de estos comandos.
- La **CDF condicional puntual** de manera genérica: Salvo excepciones en `meglm` y `gsem` (`predict, distribution`), no hay extractor oficial de CDF para todos los GLMs, por lo que `qresid` tiene que recrear operativamente el cálculo.

**Debe validarse con tests (QC/Benchmarking):**
- **Manejo de RNG:** La secuencia de valores uniformes para el "jittering" de la CDF discreta. Stata y R difieren en sus RNG. Debe validarse introduciendo una secuencia uniforme predeterminada `V_i` desde R vía una opción operativa (como `uvar()`) y comprobar que el RQR final coincide uno a uno con el de `statmod`.
- **Tolerancias de límites:** Validar las fronteras CDF (`F(y)` y `F(y^-)`). En modelos continuos deben tener una exactitud de `1e-12`. Para distribuciones discretas (Poisson, NB), tolerancia de `1e-8`.
- **Pesos y offsets/exposure:** Definir modelos con `exposure` y pesos por tipo. Validar que `predict` incorpora correctamente offset/exposure y que los pesos cambian la CDF solo cuando la semántica por familia lo exige; no validar contra un `sqrt(w_i)` global.

# Extra summary

## Reglas generales de extracción para `qresid`

La implementación de residuos cuantílicos aleatorizados exige extraer sistemáticamente componentes de los modelos ajustados en Stata. El algoritmo base de `qresid` dependerá de la correcta recuperación de parámetros, covariables y predicciones para generar la transformada integral de probabilidad (PIT) de forma determinista antes de la aleatorización. 

### 1. Extracción de Muestra Activa
*   **ESTÁNDAR OFICIAL:** Stata almacena la muestra de estimación en la función booleana `e(sample)`. 
*   **RECOMENDACIÓN OPERATIVA:** Emplear `gen byte touse = e(sample)` o aplicar el calificador `if e(sample)` para evitar que observaciones con valores faltantes (`.`) generen errores durante el cálculo.

### 2. Extracción de Predictores (`predict`)
*   **ESTÁNDAR OFICIAL:** El predictor lineal de los efectos fijos $x_i\beta$ se extrae con la opción `predict, xb` o `eta`.
*   **ESTÁNDAR OFICIAL:** El valor esperado (media $\hat{\mu}_i$) o probabilidad condicional se extrae empleando la opción `predict, mu`, o sus sinónimos `n` (para conteos) y `pr` (para desenlaces discretos/proporciones).

### 3. Offsets y Exposiciones
*   **ESTÁNDAR OFICIAL:** Variables especificadas como `offset()` o `exposure()` en el modelo original son registradas en los macros `e(offset)` o como parte de los resultados matriciales.
*   **ESTÁNDAR OFICIAL:** Usar el valor final de `predict` como fuente primaria para medias/probabilidades con offset/exposure ya incorporado.
*   **RECOMENDACIÓN OPERATIVA:** Si se calcula la función de media manualmente desde $x_i\beta$, sumar el `offset` (o el logaritmo de la exposición) solo como fallback auditado y con test de no duplicación.

### 4. Pesos (Weights)
*   **ESTÁNDAR OFICIAL:** El tipo y la expresión de los pesos se alojan en los macros `e(wtype)` y `e(wexp)`.
*   **ESTÁNDAR OFICIAL:** No existe regla universal para multiplicar el residuo final por $\sqrt{w_i}$. Distinguir `fweights`, `iweights`, `pweights`, `aweights`, prior weights, trials/frequency weights y semántica de familia antes de activar pesos.

### 5. Stored Results Clave (`e()`)
*   **ESTÁNDAR OFICIAL:** Validar la existencia de `e(cmd)` al inicio; un modelo nulo o vacío debe provocar un aborto controlado (`exit 198`). 
*   **RECOMENDACIÓN OPERATIVA:** La familia y el enlace extraídos de `e(family)` y `e(link)` guían el despacho algorítmico interno hacia la CDF condicional pertinente (Poisson, binomial, etc.).

### 6. Criterios de Soporte
*   **Modelo Soportado:** Posee CDF marginal evaluable de forma cerrada, parámetros base extraíbles de `e()` o vía matriz `e(b)`, y se encuentra alineado con la teoría clásica de Dunn-Smyth.
*   **Modelo No Soportado (Fase 1):** La CDF exige integración numérica compleja (modelos mixtos puros o latentes de la familia GSEM), o es una distribución intratable analíticamente.
