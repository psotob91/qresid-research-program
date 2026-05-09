Lifecycle: review_snapshot
Status: PARTIALLY_ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load for weights only

# WEIGHTS_RQR_EVIDENCE_REVIEW.md

## 1. PropÃ³sito

AuditorÃ­a mÃ­nima de evidencia para decidir cÃ³mo tratar pesos en residuos cuantÃ­licos aleatorizados de `qresid`.

`ESTÃNDAR OFICIAL`: este documento no activa soporte de pesos. Solo fija que no existe una regla universal `sqrt(w_i)` para todos los RQR.

---

## 2. ConclusiÃ³n operativa

- `HUMAN_DECISION_REQUIRED`: pesos quedan fuera de soporte activo hasta cerrar semÃ¡ntica por familia y tipo de peso.
- `ESTÃNDAR OFICIAL`: no implementar una transformaciÃ³n final global `r_i = sqrt(w_i) * r_i`.
- `RECOMENDACIÃ“N OPERATIVA`: separar `fweights`, trials/frequency weights, prior weights, analytic weights y probability weights.
- `RECOMENDACIÃ“N OPERATIVA`: permitir soporte solo cuando el peso sea parte clara de la distribuciÃ³n ajustada usada para construir `F_i(y)`.

---

## 3. Evidencia teÃ³rica

La construcciÃ³n Dunn-Smyth define el residuo como `qnorm(F_i(y_i))` para continuas o como `qnorm(U_i)` con `U_i` aleatorizado dentro de `[F_i(y_i-), F_i(y_i)]` para discretas.

`ESTÃNDAR OFICIAL`: si hay pesos, deben entrar por la distribuciÃ³n condicional ajustada, los parÃ¡metros estimados o una convenciÃ³n explÃ­cita de la familia. No se deriva una regla universal de multiplicar el residuo normal final.

---

## 4. Evidencia R auditada

| paquete | archivo/fuente | evidencia | implicaciÃ³n |
|---|---|---|---|
| `statmod` | `R/qres.R`; docs `qresiduals` | Binomial usa `prior.weights` como nÃºmero de ensayos; Gamma usa `shape = w/dispersion` y escala equivalente a `mu*dispersion/w`; Poisson no multiplica residuo final por `sqrt(w)`. | Pesos son dependientes de familia. |
| `glmmTMB` | `R/methods.R` | `residuals.glmmTMB` aplica un ajuste posterior con `sqrt(wts)` en rutas de residuos, incluyendo cÃ³digo cercano a Dunn-Smyth. | No copiar sin auditar familia, tipo de peso y definiciÃ³n exacta de residuo. |
| `gamlss` | `R/extra.R`, `R/rqresplot_new.R`, `R/wp.R` | Hay advertencias sobre pesos que no son frecuencias; algunos residuos permanecen unweighted. | Refuerza cautela: no asumir pesos no-frecuencia. |

Fuentes pÃºblicas consultables:

- `statmod::qresiduals`: https://www.rdocumentation.org/packages/statmod/versions/1.5.1/topics/qresiduals
- `statmod` source `qres.R`: https://rdrr.io/cran/statmod/src/R/qres.R
- `gamlss` manual CRAN: https://rsync.udc.es/CRAN/web/packages/gamlss/gamlss.pdf

---

## 5. Regla temporal para `qresid`

1. Detectar y reportar `e(wtype)` y `e(wexp)`.
2. Bloquear soporte ponderado si el tipo de peso no tiene regla aprobada.
3. Permitir investigaciÃ³n de casos con semÃ¡ntica clara:
   - binomial con ensayos/frecuencias;
   - Gamma GLM si se valida la parametrizaciÃ³n estilo `statmod`;
   - Poisson solo si la evidencia muestra cÃ³mo debe entrar el peso en la distribuciÃ³n, no en el residuo final.
4. Exigir benchmarks R-Stata por capas antes de cualquier activaciÃ³n.

---

## 6. PrÃ³ximos pasos

- Crear matriz `familia x tipo_peso x paquete_R x regla_CDF`.
- Auditar `statmod` para Gaussian, binomial, Poisson, Gamma y Tweedie.
- Auditar si Stata `glm` expone pesos comparables a `prior.weights` de R por familia.
- DiseÃ±ar tests que comparen CDF endpoints, no solo residuos finales.
- Mantener pesos como `EVIDENCIA PENDIENTE` hasta cerrar teorÃ­a, extracciÃ³n y benchmark.

