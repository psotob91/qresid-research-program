Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before weighted RQR implementation

# QRESID_WEIGHTS_TECHNICAL_RESEARCH_PLAN.md

Fecha: 2026-05-10

## 1. Estado

Weights pasan de `DO_NOT_DO` permanente a `RESEARCH_GATE_REQUIRED`.

No aplicar una transformacion global `sqrt(w_i)` al residuo final.

## 2. Fuentes Inspeccionadas

| source | evidence |
|---|---|
| `C:/Program Files/StataNow19/ado/base/g/glm.ado` | maneja `fweight`, `aweight`, `pweight`, `iweight`; registra `e(wtype)` y `e(wexp)`. |
| `C:/Program Files/StataNow19/ado/base/n/nbreg.ado` | acepta pesos y ajusta log-likelihood/starting values segun tipo. |
| `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/R/statmod/R/qres.R` | `qres.gamma()` usa `prior.weights`; binomial usa `prior.weights` como ensayos; Poisson no multiplica residuo final por `sqrt(w)`. |
| `https://rdrr.io/cran/statmod/man/qresiduals.html` | RQR `statmod` documenta comportamiento por familia. |
| `03_REPO_REVIEW/WEIGHTS_RQR_EVIDENCE_REVIEW.md` | evidencia interna previa: pesos requieren regla por familia/tipo. |

## 3. Matriz Requerida

| family | Stata weight type | possible semantics | status |
|---|---|---|---|
| binomial | trials/frequency | puede representar numero de ensayos | research required |
| Gamma | prior/frequency-like | puede entrar en dispersion/CDF como en `statmod` | research required |
| Poisson | frequency/analytic/pweight | no transformar residuo final globalmente | research required |
| Gaussian | analytic/frequency | evaluar si afecta escala/muestra, no RQR final global | research required |
| NB | any | bloqueado hasta NB gate | blocked by NB |

## 4. Benchmarks Minimos

Cada combinacion activada necesita:

1. dataset sintetico ponderado;
2. dataset estilo Stata/manual;
3. dataset adversarial con ceros o pesos extremos razonables.

Gate verde:

- Stata y R usan la misma muestra;
- fitted values alineados;
- parametro de dispersion/shape alineado si aplica;
- CDF endpoints alineados;
- residuo final alineado con `uvar()` si discreto;
- docs indican exactamente que tipos de peso estan soportados.

## 5. Decision

Si no se puede cerrar la semantica por familia/tipo de peso, el comando debe detectar pesos y fallar con error controlado para esa ruta.

Post-change documentation sync: `POST_CHANGE_SYNC_DONE`
