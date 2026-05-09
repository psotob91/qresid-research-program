# STATA_R_BENCHMARK_MAPPING.md

## 0. Propósito

Mapa operativo para comparar `qresid` en Stata contra implementaciones R por familia/modelo.

Regla central: validar primero capas deterministas —coeficientes, `xb`, `mu`, dispersión, endpoints CDF— y solo después validar aleatorización mediante `uvar()` o criterios distribucionales.

---

## 1. Estrategia general de benchmark

### 1.1 Capas de comparación

| Capa | Qué comparar | Nivel esperado | Estado |
|---|---|---|---|
| 1 | Datos, fórmula, muestra, pesos, offset | Exacto | `ESTÁNDAR OFICIAL` |
| 2 | Coeficientes y log-likelihood | Exacto/aproximado | `RECOMENDACIÓN OPERATIVA` |
| 3 | `xb`, `mu`, `pr`, `n` | Exacto/aproximado | `ESTÁNDAR OFICIAL` |
| 4 | Parámetros accesorios: `phi`, `sigma`, `alpha`, `theta`, trials | Exacto/aproximado | `RECOMENDACIÓN OPERATIVA` |
| 5 | Endpoints `F(y-)`, `F(y)` | Exacto/aproximado | `ESTÁNDAR OFICIAL` |
| 6 | Uniformes externos `V_i` | Exacto si se exportan | `RECOMENDACIÓN OPERATIVA` |
| 7 | Residuos finales con `uvar()` | Exacto/aproximado | `RECOMENDACIÓN OPERATIVA` |
| 8 | Residuos con RNG propio de cada lenguaje | Distribucional/visual | `ESTÁNDAR OFICIAL` |
| 9 | Gráficos y tests agregados | Visual/distribucional | `RECOMENDACIÓN OPERATIVA` |

### 1.2 Orden obligatorio

1. Ajustar modelo equivalente en R y Stata.
2. Validar muestra (`e(sample)` vs filas R usadas).
3. Validar fórmula, offset, exposure y pesos.
4. Comparar coeficientes.
5. Comparar `xb` y `mu`/`pr`/`n`.
6. Comparar parámetros de dispersión o tamaño.
7. Comparar `F(y-)` y `F(y)`.
8. Exportar uniformes desde R o generarlos externamente.
9. Ejecutar `qresid, uvar()` en Stata.
10. Comparar residuos transformados.
11. Solo al final comparar residuos generados con RNG interno.

---

## 2. Paquetes R recomendados por familia/modelo

| Familia/modelo | Paquete R primario | Paquete R secundario | Estado |
|---|---|---|---|
| Gaussian / normal GLM | `statmod`, `stats::glm`, `stats::lm` | `DHARMa` para simulación | `ESTÁNDAR OFICIAL` |
| Bernoulli/binomial | `statmod`, `stats::glm` | `VGAM` | `ESTÁNDAR OFICIAL` |
| Poisson | `statmod`, `stats::glm` | `DHARMa`, `VGAM` | `ESTÁNDAR OFICIAL` |
| Negative binomial | `MASS::glm.nb`, `statmod`, `VGAM` | `glmmTMB` | `ESTÁNDAR OFICIAL` |
| Gamma | `statmod`, `stats::glm` | `gamlss` | `ESTÁNDAR OFICIAL` |
| Inverse Gaussian | `statmod`, `stats::glm` | `gamlss` | `EVIDENCIA PENDIENTE` para CDF Stata nativa |
| Tweedie | `statmod`, `tweedie` | `cplm`, `gamlss` | `EVIDENCIA PENDIENTE` para implementación Fase 1 |
| ZIP/ZINB | `pscl`, `VGAM`, `glmmTMB` | `topmodels` | `RECOMENDACIÓN OPERATIVA` Fase 2 |
| Hurdle | `pscl`, `VGAM`, `topmodels` | `glmmTMB` | `RECOMENDACIÓN OPERATIVA` Fase 2 |
| Generalized Poisson | `VGAM` | `glmmTMB` | `EVIDENCIA PENDIENTE` |
| COM-Poisson | `COMPoissonReg`, `VGAM`, `glmmTMB` | `DHARMa` | `EVIDENCIA PENDIENTE` |
| GLMM | `lme4`, `glmmTMB` | `DHARMa` | `RECOMENDACIÓN OPERATIVA` simulado Fase 2 |
| PIT/simulation-based | `DHARMa` | `topmodels` | `RECOMENDACIÓN OPERATIVA` |

---

## 3. Qué comparar exactamente

### 3.1 Siempre comparar

- `ESTÁNDAR OFICIAL`: número de observaciones usadas.
- `ESTÁNDAR OFICIAL`: variable outcome y soporte válido.
- `ESTÁNDAR OFICIAL`: fórmula y matriz de diseño equivalente.
- `ESTÁNDAR OFICIAL`: `xb` o predictor lineal.
- `ESTÁNDAR OFICIAL`: `mu`, `n` o `pr` según comando.
- `ESTÁNDAR OFICIAL`: CDF `F(y)`.
- `ESTÁNDAR OFICIAL`: en discretas, CDF izquierda `F(y-)`.
- `RECOMENDACIÓN OPERATIVA`: residuos finales solo con `uvar()` compartido.

### 3.2 Comparar si aplica

- `phi` / escala en `glm`.
- `sigma` / RMSE en `regress`.
- `alpha` o `theta` en NB.
- Número de ensayos `m` en binomial agrupada.
- Offset/exposure usado por observación.
- Pesos `e(wexp)` y transformación `sqrt(w_i)` si se aplica.
- Log-likelihood si el método de estimación es comparable.

### 3.3 No comparar exactamente

- `ESTÁNDAR OFICIAL`: residuos aleatorizados generados con RNG propio de R y Stata.
- `ESTÁNDAR OFICIAL`: secuencias de `runiform()` vs `runif()` sin vector externo.
- `RECOMENDACIÓN OPERATIVA`: p-values de tests agregados en una sola corrida aleatoria.
- `RECOMENDACIÓN OPERATIVA`: gráficos con jitter aleatorio sin semilla compartida.
- `RECOMENDACIÓN OPERATIVA`: resultados de modelos mixtos marginales si usan integración/cuadratura distinta.

---

## 4. Cuándo comparar `F(y-)`, `F(y)`, intervalos PIT y residuos

| Escenario | Comparar `F(y-)` | Comparar `F(y)` | Comparar intervalo PIT | Comparar residuo transformado |
|---|---:|---:|---:|---:|
| Distribución continua | No, igual a `F(y)` | Sí | No | Sí, determinístico |
| Bernoulli/binomial | Sí | Sí | Sí | Solo con `uvar()` |
| Poisson | Sí | Sí | Sí | Solo con `uvar()` |
| NB | Sí | Sí | Sí | Solo con `uvar()` |
| ZIP/ZINB | Sí, incluyendo masa en cero | Sí | Sí | Solo con `uvar()` o simulación |
| Hurdle | Sí, especialmente masa en cero/límite | Sí | Sí | Solo con `uvar()` o simulación |
| GLMM | Depende de CDF condicional/marginal | Depende | Preferir PIT simulado | Distribucional |
| DHARMa-like | No necesariamente analítico | No necesariamente analítico | Sí, simulado | Distribucional/visual |

---

## 5. Uso de `seed()`, `uvar()` y uniformes externos

### 5.1 `seed()`

Usar `seed()` cuando:

- se quiere reproducibilidad dentro de Stata;
- se ejecutan tests de estabilidad interna;
- se genera documentación reproducible;
- se comparan corridas repetidas del mismo comando Stata.

No usar `seed()` para reclamar igualdad exacta con R si no se comparte el vector de uniformes.

### 5.2 `uvar()`

Usar `uvar()` cuando:

- se comparan residuos finales observación a observación contra R;
- se desea separar el cálculo de CDF del RNG;
- se necesita reproducir un benchmark publicado;
- se audita una discrepancia de residuos en discretas.

### 5.3 Uniformes externos

Requisitos:

- vector `V_i` en `(0,1)` o `[0,1]` con manejo documentado de extremos;
- longitud igual a la muestra de estimación o identificador que permita merge exacto;
- orden de filas congelado con ID estable;
- exportación a `.csv`/`.dta` con precisión suficiente;
- test de que `U_i = F(y-) + V_i * (F(y)-F(y-))` cae dentro del intervalo.

---

## 6. Tolerancias sugeridas

| Objeto | Tolerancia inicial | Criterio |
|---|---:|---|
| Coeficientes GLM simples | `1e-8` absoluta o relativa | Aproximado |
| `xb` / `eta` | `1e-8` | Aproximado |
| `mu` / `pr` / `n` | `1e-8` | Aproximado |
| `sigma`, `phi` | `1e-8` | Aproximado |
| `alpha`, `theta`, `k` NB | `1e-8` o documentar diferencia | Aproximado |
| CDF continua | `1e-12` | Casi exacto |
| CDF discreta | `1e-8` a `1e-12` según función | Aproximado |
| PIT uniforme con `uvar()` | `1e-12` | Exacto/casi exacto |
| Residuo final con `uvar()` | `1e-8` | Aproximado |
| Log-likelihood | `1e-6` | Aproximado |
| Simulaciones agregadas | No usar tolerancia punto a punto | Distribucional |
| Gráficos | No aplica | Visual |

`RECOMENDACIÓN OPERATIVA`: si una tolerancia falla, comparar en cascada: muestra → coeficientes → `mu` → parámetros accesorios → CDF → PIT → residuo.

---

## 7. Tabla maestra por familia/modelo

| Familia/modelo | Benchmark R | Concordancia esperada | Dificultad | Riesgos principales | Estado |
|---|---|---|---|---|---|
| Gaussian `regress`/`glm` | `stats::lm`, `statmod` | Determinística en CDF/residuo | Baja | sigma/RMSE, pesos | `ESTÁNDAR OFICIAL` |
| Binomial Bernoulli | `stats::glm`, `statmod` | CDF endpoints exactos/aprox.; residuos exactos con `uvar()` | Media | trials, probabilidades extremas | `ESTÁNDAR OFICIAL` |
| Binomial agrupada | `stats::glm(cbind(...))`, `statmod` | Endpoints exactos/aprox. | Media | extraer `m`, soporte `0..m` | `ESTÁNDAR OFICIAL` |
| Poisson | `stats::glm`, `statmod` | Endpoints exactos/aprox.; residuos exactos con `uvar()` | Baja | offset/exposure, mu extrema | `ESTÁNDAR OFICIAL` |
| Negative binomial | `MASS::glm.nb`, `statmod`, `VGAM` | Endpoints aprox. | Media-alta | NB1/NB2, `alpha` vs `theta` | `RECOMENDACIÓN OPERATIVA` |
| Gamma | `stats::glm`, `statmod` | CDF/residuo determinístico | Media | escala/forma, `y>0` | `ESTÁNDAR OFICIAL` |
| Inverse Gaussian | `statmod`, `stats::glm` | CDF/residuo determinístico si CDF válida | Alta | Stata sin CDF nativa | `EVIDENCIA PENDIENTE` |
| Tweedie | `statmod`, `tweedie` | Aproximada | Alta | CDF aproximada, masa en cero | `EVIDENCIA PENDIENTE` |
| ZIP | `pscl`, `VGAM`, `topmodels` | Endpoints aprox. si parametrización idéntica | Alta | masa cero, predicción inflación | Fase 2 |
| ZINB | `pscl`, `VGAM`, `glmmTMB`, `topmodels` | Endpoints aprox. | Alta | inflación + NB parametrización | Fase 2 |
| Hurdle | `pscl`, `VGAM`, `topmodels` | Endpoints aprox. | Alta | CDF truncada, masa cero | Fase 2 |
| Truncated Poisson/NB | `VGAM`, `glmmTMB` | Endpoints aprox. | Alta | normalización truncada | `EVIDENCIA PENDIENTE` |
| COM-Poisson | `COMPoissonReg`, `VGAM`, `glmmTMB` | Aproximada/distribucional | Alta | CDF no nativa Stata | `EVIDENCIA PENDIENTE` |
| GLMM | `lme4`, `glmmTMB`, `DHARMa` | Distribucional/simulada | Alta | condicional vs marginal | Fase 2/3 |
| GSEM/FMM | `glmmTMB`, `flexmix`, `DHARMa` | Distribucional/simulada | Muy alta | latentes, identificación | Fase 2/3 |

---

## 8. Snippets mínimos

### 8.1 R: exportar uniformes y endpoints

```r
set.seed(12345)
V <- runif(nrow(dat))
bench <- data.frame(
  id = dat$id,
  y = dat$y,
  mu = fitted(fit),
  V = V,
  Flo = Flo,
  Fhi = Fhi,
  U = Flo + V * (Fhi - Flo),
  rqres = qnorm(U)
)
write.csv(bench, "tests/r_benchmarks/poisson_bench.csv", row.names = FALSE)
```

### 8.2 Stata: comparar con `uvar()`

```stata
version 19.0
use tests/data/poisson_case.dta, clear
merge 1:1 id using tests/r_benchmarks/poisson_bench.dta, nogen
poisson y x1 x2, exposure(expo)
qresid rq_stata, uvar(V)
assert abs(rq_stata - rqres) < 1e-8 if e(sample)
```

### 8.3 Stata: validar endpoints antes del residuo

```stata
assert abs(Flo_stata - Flo_R) < 1e-8 if e(sample)
assert abs(Fhi_stata - Fhi_R) < 1e-8 if e(sample)
assert Flo_stata <= Fhi_stata if e(sample)
```

---

## 9. Reglas de aceptación de benchmark

- `ESTÁNDAR OFICIAL`: no aceptar una familia si no pasan los tests de CDF endpoints.
- `ESTÁNDAR OFICIAL`: no aceptar una familia discreta si `uvar()` no reproduce residuos contra R.
- `RECOMENDACIÓN OPERATIVA`: no bloquear Fase 1 por ZIP/ZINB/hurdle/GLMM; marcarlos como Fase 2.
- `RECOMENDACIÓN OPERATIVA`: si el benchmark falla, guardar tabla de discrepancias con `id`, `y`, `mu_R`, `mu_Stata`, `Flo_R`, `Flo_Stata`, `Fhi_R`, `Fhi_Stata`, `V`, `rq_R`, `rq_Stata`.
- `EVIDENCIA PENDIENTE`: si no existe benchmark R confiable o CDF Stata validada, no implementar como familia soportada.
