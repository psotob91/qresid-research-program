Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before Gamma implementation

# QRESID_GAMMA_TECHNICAL_RESEARCH_PLAN.md

Fecha: 2026-05-10

## 1. Estado

Gamma es Fase 1 aprobada, pero requiere gate tecnico antes de claim estable.

## 2. Fuentes Inspeccionadas

| source | evidence |
|---|---|
| `C:/Program Files/StataNow19/ado/base/g/glm.ado` | `family(gamma)` mapea a familia interna; `glm` registra pesos en `e(wtype)`/`e(wexp)` y scale/dispersion logic. |
| `C:/Program Files/StataNow19/docs/r.pdf` | manual local Stata para comandos `glm` y familias. |
| `https://www.stata.com/manuals/rglm.pdf` | manual oficial online para `glm`. |
| `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/R/statmod/R/qres.R` | `qres.gamma()` usa `prior.weights`, dispersion y CDF Gamma. |
| `https://rdrr.io/cran/statmod/man/qresiduals.html` | documentacion CRAN/R para RQR en `statmod`. |

## 3. Hipotesis De Implementacion

Gamma continua:

- soporte: `y > 0`;
- fitted mean: `mu > 0`;
- dispersion: `phi > 0`;
- shape inicial: `1 / phi`;
- scale inicial: `mu * phi`;
- CDF: `gammap(shape, y / scale)` o funcion Stata equivalente validada.

La semantica con pesos no se activa automaticamente. Si se detectan pesos, Gamma ponderado queda sujeto al gate de weights.

## 4. Benchmarks Minimos

| dataset | purpose |
|---|---|
| synthetic_gamma_log | parametros controlados, link log |
| stata_manual_gamma | ejemplo manual/oficial reproducible |
| gamma_edge_small | `y` pequeno positivo, `mu` extremo moderado, dispersion alta/baja |

Gate verde:

- coeficientes y `mu` alineados;
- dispersion reconciliada;
- CDF Gamma alineada por capa;
- residuo final dentro de tolerancia;
- 0 fallos inesperados.

## 5. Decision

Gamma puede implementarse despues de API/core y antes de docs publicas, pero no puede declararse estable sin los 3 benchmarks.

Post-change documentation sync: `POST_CHANGE_SYNC_DONE`
