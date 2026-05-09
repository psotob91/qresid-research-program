# STATA_NUMERICAL_STABILITY_RULES.md

## 0. Propósito

Reglas numéricas obligatorias para implementar CDF, endpoints, PIT, uniformización y transformación normal en `qresid`.

Regla central: ningún residuo debe calcularse si los parámetros, el soporte, los endpoints CDF o el uniforme transformado no pasan validaciones explícitas.

---

## 1. Precisión y tipos

- `ESTÁNDAR OFICIAL`: crear como `double` todas las variables internas: `mu`, `xb`, `eta`, `F_low`, `F_high`, `V`, `U`, residuos y pesos transformados.
- `ESTÁNDAR OFICIAL`: en Mata, usar `real colvector`, que opera en doble precisión.
- `RECOMENDACIÓN OPERATIVA`: nunca usar `generate` sin `double` para CDF, PIT o residuos.
- `RECOMENDACIÓN OPERATIVA`: comparar objetos numéricos en cascada: muestra → predicción → parámetros accesorios → CDF → PIT → residuo.

Snippet mínimo:

```stata
tempvar mu Flo Fhi U rq
quietly generate double `mu'  = . if `touse'
quietly generate double `Flo' = . if `touse'
quietly generate double `Fhi' = . if `touse'
quietly generate double `U'   = . if `touse'
quietly generate double `rq'  = . if `touse'
```

---

## 2. Reglas de CDF y endpoints

| Regla | Acción | Severidad |
|---|---|---|
| `0 <= F_low <= F_high <= 1` | Validar después de cada CDF | ESTÁNDAR OFICIAL |
| Error leve: `F_low < 0` por menos de tolerancia | Saturar a 0 y marcar warning interno | RECOMENDACIÓN OPERATIVA |
| Error leve: `F_high > 1` por menos de tolerancia | Saturar a 1 y marcar warning interno | RECOMENDACIÓN OPERATIVA |
| Inversión leve: `F_high < F_low` dentro de tolerancia | Igualar o intercambiar solo si está documentado y registrar flag | RECOMENDACIÓN OPERATIVA |
| Inversión severa: `F_high + tol < F_low` | Abortar para la familia/caso | ESTÁNDAR OFICIAL |
| CDF missing con parámetros válidos | Abortar o dejar residuo missing con warning explícito | ESTÁNDAR OFICIAL |

Tolerancia inicial para inversión leve: `1e-12` en continuas y `1e-8` en discretas. Ajustar solo si los benchmarks lo justifican.

---

## 3. Reglas antes de `invnormal()`

- `ESTÁNDAR OFICIAL`: `U` debe estar en `[0,1]` después de uniformización.
- `RECOMENDACIÓN OPERATIVA`: antes de aplicar `invnormal()`, saturar `U` a un intervalo abierto documentado, por ejemplo `[epsilon, 1-epsilon]`, si se desea evitar infinitos operativos.
- `RECOMENDACIÓN OPERATIVA`: registrar conteo de saturaciones en `r(N_clipped_low)` y `r(N_clipped_high)`.
- `ESTÁNDAR OFICIAL`: si `U == 0` o `U == 1` por valor matemático real y no por error numérico, el residuo extremo debe documentarse; no ocultarlo silenciosamente.
- `RECOMENDACIÓN OPERATIVA`: emitir advertencia si `abs(residuo) > 8` o si hubo clipping.

Snippet mínimo:

```stata
local eps = 1e-15
quietly replace `U' = `eps'     if `U' <= 0 & `touse'
quietly replace `U' = 1-`eps'   if `U' >= 1 & `touse'
quietly replace `rq' = invnormal(`U') if `touse'
```

---

## 4. Reglas por familia

| Familia | Validaciones obligatorias | Parámetros | Estado |
|---|---|---|---|
| Gaussian | `sigma > 0`; `mu` no missing; `y` no missing | `mu`, `sigma=e(rmse)` o escala GLM | ESTÁNDAR OFICIAL |
| Gamma | `y > 0`; `phi > 0`; forma `k=1/phi > 0`; escala `mu/k > 0` | `mu`, `phi` | ESTÁNDAR OFICIAL |
| Bernoulli | `y` en `{0,1}`; `0 < p < 1` luego de control numérico | `p`, `m=1` | ESTÁNDAR OFICIAL |
| Binomial agrupada | `y` entero; `0 <= y <= m`; `m > 0`; `0 < p < 1` | `p`, `m` | ESTÁNDAR OFICIAL |
| Poisson | `y` entero no negativo; `mu > 0` | `mu` | ESTÁNDAR OFICIAL |
| Negative binomial | `y` entero no negativo; `mu > 0`; `alpha/theta/k > 0` | `mu`, `k` o `alpha` | RECOMENDACIÓN OPERATIVA; parametrización pendiente de confirmación final |
| Inverse Gaussian | `y > 0`; parámetros positivos; CDF validada | `mu`, `phi/lambda` | EVIDENCIA PENDIENTE |
| Tweedie | Soporte y masa en cero según potencia; CDF validada | `mu`, `phi`, `p` | EVIDENCIA PENDIENTE |
| ZIP/ZINB | CDF inflada validada; `0<=pi<=1`; parámetros base válidos | `pi`, `mu`, `k` si ZINB | Fase 2 |
| GLMM/GSEM | Definir si CDF es condicional, marginal o simulada | modelo completo | Fase 2/3 |

---

## 5. Reglas de endpoints

| Tipo de respuesta | `F_low` | `F_high` | Nota |
|---|---|---|---|
| Continua | `F(y)` | `F(y)` | No usar aleatorización |
| Discreta general | `F(y-1)` | `F(y)` | Requiere `V_i` o RNG |
| Conteos con `y=0` | `0` | `F(0)` | No evaluar `F(-1)` salvo que la función lo soporte explícitamente |
| Binomial con `y=0` | `0` | `F(0)` | Validar `m` |
| Binomial con `y=m` | `F(m-1)` | `1` o CDF evaluada | Saturar leve a 1 si aplica |
| ZIP/ZINB con `y=0` | `0` | masa inflada + masa base en cero | Fase 2; validar fórmula |
| Hurdle con `y=0` | `0` | masa del hurdle | Fase 2; validar fórmula |

---

## 6. Reglas de RNG y uniformes externos

- `ESTÁNDAR OFICIAL`: no validar igualdad exacta R–Stata de residuos aleatorizados si no se usa `uvar()`.
- `ESTÁNDAR OFICIAL`: `seed()` solo garantiza reproducibilidad interna dentro de Stata.
- `RECOMENDACIÓN OPERATIVA`: `uvar()` debe aceptar uniformes externos para benchmarking observación a observación.
- `ESTÁNDAR OFICIAL`: los uniformes externos deben ser numéricos, no missing en `e(sample)`, y estar en rango válido.
- `RECOMENDACIÓN OPERATIVA`: si `V==0` o `V==1`, permitirlo solo si el manejo de endpoints/clipping está documentado. Preferir `(0,1)` para tests exactos.
- `ESTÁNDAR OFICIAL`: ordenar datos de forma estable antes de asignar uniformes por posición; idealmente usar ID y merge 1:1.

---

## 7. Tolerancias iniciales

| Objeto | Tolerancia sugerida | Uso |
|---|---:|---|
| `xb` / `eta` | `1e-8` | Benchmark R–Stata |
| `mu`, `pr`, `n` | `1e-8` | Benchmark R–Stata |
| `sigma`, `phi` | `1e-8` | Continuas |
| `alpha`, `theta`, `k` NB | `1e-8` o documentar diferencia | NB |
| CDF continua | `1e-12` | Unit tests |
| CDF discreta | `1e-8` a `1e-12` | Unit tests |
| `U` con `uvar()` | `1e-12` | Benchmark exacto |
| Residuo final con `uvar()` | `1e-8` | Benchmark exacto |
| Simulaciones agregadas | No usar tolerancia punto a punto | Evaluación distribucional |

---

## 8. Missing, soporte y abortos

| Situación | Acción | Estado |
|---|---|---|
| Outcome missing | Residuo missing | ESTÁNDAR OFICIAL |
| Covariable missing usada en modelo | Fuera de `e(sample)`; residuo missing | ESTÁNDAR OFICIAL |
| Predicción `mu/pr` missing en `e(sample)` | Abortar o emitir error de postestimación | ESTÁNDAR OFICIAL |
| `y` fuera de soporte | Abortar para esas observaciones o error 459/198 documentado | ESTÁNDAR OFICIAL |
| Conteo no entero | Error; no redondear | ESTÁNDAR OFICIAL |
| Binomial con `y > m` | Error | ESTÁNDAR OFICIAL |
| Gamma/IG con `y <= 0` | Error o missing documentado según familia | ESTÁNDAR OFICIAL |
| Parámetro accesorio no extraíble | Stub con error controlado | EVIDENCIA PENDIENTE |

---

## 9. Checklist antes de aceptar una función CDF

- [ ] La familia y parametrización están documentadas.
- [ ] Los parámetros requeridos se extraen desde `predict`/`e()` sin ambigüedad.
- [ ] Se validó soporte de `y`.
- [ ] Se validó positividad/rango de parámetros.
- [ ] Se probaron `F_low` y `F_high` en casos de borde.
- [ ] Se probó `F_low <= F_high`.
- [ ] Se comparó contra R o valores conocidos.
- [ ] Se definió tolerancia.
- [ ] Se probó `U` en el intervalo.
- [ ] Se probó `invnormal(U)` con clipping/saturación documentada.
- [ ] Se creó test de error esperado para parámetros inválidos.

---

## 10. Tabla maestra: problema numérico → acción

| Problema numérico | Detección | Acción | Severidad | Test obligatorio |
|---|---|---|---|---|
| `F_low < 0` leve | `F_low > -tol & F_low < 0` | Saturar a 0; registrar flag | Warning | Unit CDF extremo |
| `F_high > 1` leve | `F_high < 1+tol & F_high > 1` | Saturar a 1; registrar flag | Warning | Unit CDF extremo |
| Inversión CDF severa | `F_high + tol < F_low` | Abortar | Error | Stress test |
| `U==0` | `U <= 0` | Clipping o residuo extremo documentado | Warning/Error según opción | PIT endpoint |
| `U==1` | `U >= 1` | Clipping o residuo extremo documentado | Warning/Error según opción | PIT endpoint |
| `mu <= 0` | `mu <= 0` en familia positiva | Error | Error | Soporte/parámetros |
| `p <= 0` o `p >= 1` | Probabilidad fuera de rango | Saturar solo si leve; si no, error | Error | Binomial extremo |
| Conteo no entero | `y != floor(y)` | Error; no redondear | Error | Conteo inválido |
| NB `k <= 0` | Parámetro accesorio inválido | Error | Error | NB extremo |
| Missing inesperado en `e(sample)` | `missing(mu)` si `touse` | Error | Error | Integration test |
| Diferencia R–Stata en residuo | `abs(r_stata-r_R)>tol` | Revisar cascada: `mu`, parámetros, CDF, `U` | Error | Benchmark |
