# STATA_TESTING_CERTIFICATION_RULES.md

## 0. Propósito

Reglas operativas para probar, auditar y certificar `qresid` antes de commits, merges, releases y preparación SSC/Stata Journal.

Regla central: una implementación se acepta solo si pasa pruebas unitarias de CDF, pruebas de integración con modelos Stata, benchmarking contra R y scripts de certificación reproducibles.

---

## 1. Estructura recomendada de pruebas

```text
tests/
  unit/
    test_cdf_poisson.do
    test_cdf_binomial.do
    test_cdf_nbreg.do
    test_cdf_gaussian.do
    test_cdf_gamma.do
  integration/
    test_qresid_poisson.do
    test_qresid_nbreg.do
    test_qresid_glm_binomial.do
    test_qresid_glm_gamma.do
  r_benchmarks/
    make_poisson_benchmark.R
    make_nb_benchmark.R
    make_binomial_benchmark.R
    make_gamma_benchmark.R
    outputs/
  data/
    README.md
    *.dta
    *.csv
  helpers/
    assert_close.do
    compare_vectors.do
    import_r_benchmark.do
certification/
  master.do
  master_R.R
  logs/
  outputs/
  reports/
```

### 1.1 Unit tests

Objetivo: probar piezas matemáticas sin depender de un ajuste completo.

Deben cubrir:

- CDF `F(y)`.
- Endpoint izquierdo `F(y-)`.
- Soporte de `y`.
- Parámetros extremos.
- `U_i` dentro de `[F(y-), F(y)]`.
- `invnormal(U_i)` sin missing inesperado.

### 1.2 Integration tests

Objetivo: probar `qresid` después de comandos Stata reales.

Deben cubrir:

- `glm`
- `regress`
- `poisson`
- `nbreg`
- `logit` / `logistic`
- `binreg`
- opciones `if`/`in`
- `e(sample)`
- `offset()` / `exposure()`
- pesos cuando estén soportados

### 1.3 Benchmark tests

Objetivo: comparar contra R en datos y modelos equivalentes.

Deben cubrir:

- coeficientes;
- fitted values;
- `xb`;
- `mu`/`pr`/`n`;
- dispersión;
- endpoints CDF;
- uniformes externos;
- residuos finales con `uvar()`.

### 1.4 Certification scripts

Objetivo: generar evidencia ejecutable y logs auditables.

Deben:

- correr desde cero;
- producir logs limpios;
- exportar tablas de concordancia;
- guardar session info/versiones;
- fallar con `assert` ante discrepancias;
- no requerir interacción manual.

---

## 2. Qué probar antes de aceptar una implementación

| Componente | Prueba mínima | Estado |
|---|---|---|
| CDF | `F(y)` coincide con valor conocido o R | `ESTÁNDAR OFICIAL` |
| Endpoints | `F(y-) <= F(y)` y ambos en `[0,1]` | `ESTÁNDAR OFICIAL` |
| PIT | `U_i` dentro de intervalo | `ESTÁNDAR OFICIAL` |
| Transformación normal | `r_i = invnormal(U_i)` finito salvo colas documentadas | `ESTÁNDAR OFICIAL` |
| RNG | `seed()` reproduce resultados dentro de Stata | `ESTÁNDAR OFICIAL` |
| Uniformes externos | `uvar()` reproduce R observación a observación | `RECOMENDACIÓN OPERATIVA` |
| `predict()` | extrae `mu`/`n`/`pr` según comando | `ESTÁNDAR OFICIAL` |
| Offset/exposure | no se duplica ni se omite | `ESTÁNDAR OFICIAL` |
| `e(sample)` | solo calcula en muestra de estimación por defecto | `ESTÁNDAR OFICIAL` |
| Weights | detecta `e(wtype)`/`e(wexp)` y aplica regla documentada | `RECOMENDACIÓN OPERATIVA` |
| Missing values | produce `.` y no imputa ceros | `ESTÁNDAR OFICIAL` |
| Límites numéricos | controla CDF 0/1, underflow/overflow | `RECOMENDACIÓN OPERATIVA` |
| Errores esperados | comandos no soportados devuelven error claro | `ESTÁNDAR OFICIAL` |

---

## 3. Pruebas por familia

| Familia/modelo | Unit CDF | Integration | R benchmark | Tests especiales | Estado |
|---|---:|---:|---:|---|---|
| Gaussian/regress | Sí | Sí | Sí | sigma/RMSE, outliers | Fase 1 |
| GLM Gaussian | Sí | Sí | Sí | `e(phi)`, links si aplica | Fase 1 |
| Bernoulli/logit/logistic | Sí | Sí | Sí | y=0/1, p extremo | Fase 1 |
| Binomial agrupada/binreg | Sí | Sí | Sí | trials `m`, y > m inválido | Fase 1 |
| Poisson | Sí | Sí | Sí | y=0, offset/exposure | Fase 1 |
| NB/nbreg | Sí | Sí | Sí | alpha/theta/k, NB1/NB2 | Fase 1 con cautela |
| Gamma | Sí | Sí | Sí | y>0, forma/escala | Fase 1 |
| Inverse Gaussian | Sí si hay CDF validada | No hasta CDF | Sí | Mata/plugin | `EVIDENCIA PENDIENTE` |
| Tweedie | No Fase 1 | No Fase 1 | Exploratorio | CDF aproximada | `EVIDENCIA PENDIENTE` |
| ZIP/ZINB | Diseño Fase 2 | Stub Fase 1 | Exploratorio | masa cero, inflación | Fase 2 |
| Hurdle/truncados | Diseño Fase 2 | Stub Fase 1 | Exploratorio | CDF truncada | Fase 2 |
| GLMM/GSEM | Simulado | Stub Fase 1 | DHARMa-like | condicional vs marginal | Fase 2/3 |

---

## 4. Datasets recomendados

### 4.1 Pruebas rápidas

Usar datasets sintéticos pequeños creados dentro del do-file.

Requisitos:

- 10–50 observaciones;
- valores de `y` que cubran bordes;
- ID estable;
- sin dependencia externa;
- CDF calculable a mano o con funciones nativas.

Ejemplos:

- Poisson con `mu = 1`, `y = 0,1,2,5`.
- Binomial con `m = 1`, `m = 5`, `p = 0.2, 0.8`.
- Gaussian con `mu = 0`, `sigma = 1`.
- Gamma con `shape = 2`, `scale = 1`.

### 4.2 Benchmarking

Usar datasets con equivalentes R–Stata y tamaño moderado:

- `CrabSatellites`.
- `bioChemists`.
- `NMES1988`.
- `esoph`.
- `GasolineYield`.
- `LGAclaims` para offset/exposure.

### 4.3 Stress testing

Crear datasets simulados con:

- `mu` muy pequeña y muy grande;
- y=0 frecuente;
- probabilidades cerca de 0 y 1;
- dispersión NB extrema;
- missing en outcome y covariables;
- offsets muy pequeños/grandes;
- pesos extremos;
- filas fuera de `e(sample)`.

### 4.4 Gráficos

Usar datasets que produzcan patrones diagnósticos claros:

- QQ plot bajo correcta especificación.
- QQ plot bajo sobredispersión.
- residual vs fitted con curvatura.
- histograma de residuos con discreción si no se aleatoriza.

---

## 5. Manejo de logs, seeds y outputs temporales

### 5.1 Logs

```stata
version 19.0
capture log close
log using certification/logs/test_qresid_poisson.log, replace text
set more off

// tests

log close
exit
```

Reglas:

- `ESTÁNDAR OFICIAL`: todo script de prueba abre y cierra log.
- `ESTÁNDAR OFICIAL`: usar `replace` para ejecución desatendida.
- `RECOMENDACIÓN OPERATIVA`: logs en texto plano para diff en Git.

### 5.2 Seeds

```stata
version 19.0: set seed 123456789
```

Reglas:

- `ESTÁNDAR OFICIAL`: fijar versión antes de RNG.
- `ESTÁNDAR OFICIAL`: tests con aleatorización deben tener semilla.
- `RECOMENDACIÓN OPERATIVA`: guardar `c(rngstate)` si se necesita restaurar estado.
- `RECOMENDACIÓN OPERATIVA`: no usar comparación exacta R–Stata sin `uvar()`.

### 5.3 Outputs temporales

- Usar `tempfile` para archivos intermedios dentro de tests.
- Guardar outputs permanentes solo si son evidencia de certificación.
- Separar:
  - `tests/r_benchmarks/outputs/`
  - `certification/outputs/`
  - `certification/reports/`
- No guardar datasets mutados manualmente.

---

## 6. Criterios mínimos de aceptación

### 6.1 Antes de commit

- [ ] Corre unit test de la familia modificada.
- [ ] No hay variables temporales fijas derramadas al dataset.
- [ ] No hay cambios no documentados en outputs de benchmark.
- [ ] `qresid` no calcula fuera de `e(sample)` salvo opción explícita futura.
- [ ] Los errores esperados devuelven código claro.

### 6.2 Antes de merge

- [ ] Corre suite completa Fase 1.
- [ ] Corre benchmark R–Stata de familias afectadas.
- [ ] Pasan endpoints CDF.
- [ ] Pasan residuos con `uvar()`.
- [ ] Logs completos guardados.
- [ ] No se agregan modelos marcados `EVIDENCIA PENDIENTE` como soportados.

### 6.3 Antes de release

- [ ] Corre `certification/master.do` desde una sesión limpia.
- [ ] Corre `certification/master_R.R`.
- [ ] Se regeneran tablas de concordancia.
- [ ] Se revisan casos extremos.
- [ ] Se revisa documentación `.sthlp`.
- [ ] Se valida instalación local del paquete.

### 6.4 Antes de SSC/Stata Journal

- [ ] Certification script completo y reproducible.
- [ ] Logs limpios.
- [ ] Benchmarks R adjuntos o reproducibles.
- [ ] Datasets con licencia clara.
- [ ] Help file con ejemplos ejecutables.
- [ ] Sin archivos scratch, prompts o notas internas.
- [ ] Versionado y changelog completos.

---

## 7. Certification script Stata Journal-ready

Debe incluir:

- encabezado con versión de Stata;
- directorios relativos;
- apertura de log;
- carga/creación de datos;
- ajuste de modelos;
- ejecución de `qresid`;
- importación de benchmarks R;
- comparación por capas;
- `assert` para criterios obligatorios;
- exportación de tabla resumen;
- cierre de log;
- salida explícita.

### 7.1 Esqueleto mínimo

```stata
version 19.0
capture log close
log using certification/logs/certify_poisson.log, replace text
set more off

use tests/data/poisson_case.dta, clear
merge 1:1 id using tests/r_benchmarks/outputs/poisson_bench.dta, nogen

poisson y x1 x2, exposure(expo)

predict double mu_stata if e(sample), n
assert abs(mu_stata - mu_R) < 1e-8 if e(sample)

qresid rq_stata if e(sample), uvar(V)
assert abs(Flo_stata - Flo_R) < 1e-8 if e(sample)
assert abs(Fhi_stata - Fhi_R) < 1e-8 if e(sample)
assert abs(rq_stata - rq_R) < 1e-8 if e(sample)

count if e(sample)
assert r(N) > 0

log close
exit
```

---

## 8. Comandos mínimos Stata/R sugeridos

### 8.1 Stata: correr tests

```stata
version 19.0
do tests/unit/test_cdf_poisson.do
do tests/integration/test_qresid_poisson.do
do certification/master.do
```

### 8.2 Stata: generar log

```stata
capture log close
log using certification/logs/master.log, replace text
do certification/master.do
log close
```

### 8.3 Stata: validar outputs

```stata
assert Flo <= Fhi if e(sample)
assert inrange(Flo, 0, 1) if e(sample)
assert inrange(Fhi, 0, 1) if e(sample)
assert abs(rq_stata - rq_R) < 1e-8 if e(sample)
```

### 8.4 R: generar benchmark

```r
fit <- glm(y ~ x1 + x2 + offset(log(expo)), family = poisson(), data = dat)
mu <- fitted(fit)
Flo <- ppois(dat$y - 1, lambda = mu)
Flo[dat$y == 0] <- 0
Fhi <- ppois(dat$y, lambda = mu)
set.seed(123456789)
V <- runif(nrow(dat))
U <- Flo + V * (Fhi - Flo)
rq <- qnorm(U)
write.csv(data.frame(id = dat$id, mu_R = mu, Flo_R = Flo, Fhi_R = Fhi, V = V, rq_R = rq),
          "tests/r_benchmarks/outputs/poisson_bench.csv", row.names = FALSE)
```

---

## 9. Tabla maestra de pruebas

| Tipo de prueba | Objetivo | Frecuencia | Obligatoriedad | Criterio de aprobación |
|---|---|---|---|---|
| Unit CDF | Validar función CDF y endpoints | Cada commit que toque CDF | Obligatoria | Tolerancia definida; `F(y-) <= F(y)` |
| Unit PIT | Validar `U_i` en intervalo | Cada cambio en aleatorización | Obligatoria | Todos los `U_i` dentro de intervalo |
| Unit normal transform | Validar `invnormal()` y clipping | Cada cambio numérico | Obligatoria | Sin missing no esperado |
| Integration postestimation | Validar `predict`, `e(sample)`, options | Cada familia | Obligatoria | Sin cálculo fuera de muestra |
| Offset/exposure | Detectar omisión/doble suma | Cada familia con offset | Obligatoria | Coincidencia con R |
| Weights | Validar detección/aplicación | Si familia admite pesos | Condicional | Regla documentada y testeada |
| RNG seed | Reproducibilidad interna Stata | Cada cambio en RNG | Obligatoria | Dos corridas idénticas |
| `uvar()` | Reproducibilidad R–Stata | Cada familia discreta | Obligatoria | Residuo final coincide |
| Benchmark R | Validar capas deterministas | Antes de merge/release | Obligatoria | Coeficientes, fitted, CDF pasan |
| Stress numerical | Robustez en extremos | Antes de release | Obligatoria | Sin overflow/underflow no controlado |
| Error handling | Entradas no válidas | Cada release | Obligatoria | Error claro, código esperado |
| Graphics smoke test | Gráficos se generan | Antes de release | Recomendado | Archivos/plots sin error |
| Certification full | Evidencia reproducible | Antes de release/SSC | Obligatoria | `master.do` completo pasa |

---

## 10. Reglas de rechazo automático

Rechazar una implementación si:

- calcula residuos fuera de `e(sample)` sin opción explícita;
- compara residuos aleatorizados R–Stata sin `uvar()` y reclama igualdad exacta;
- no valida CDF endpoints;
- no maneja `y` fuera de soporte;
- omite `version #` en ado/do-files;
- usa variables intermedias fijas en vez de `tempvar`;
- suma offset dos veces;
- marca como soportado un modelo con `EVIDENCIA PENDIENTE`;
- no deja logs reproducibles para benchmark/certificación.
