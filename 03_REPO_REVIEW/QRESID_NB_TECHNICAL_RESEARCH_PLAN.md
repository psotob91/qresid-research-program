Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before NB implementation

# QRESID_NB_TECHNICAL_RESEARCH_PLAN.md

Fecha: 2026-05-10

## 1. Estado

NB deja de ser `DO_NOT_DO` permanente y pasa a `RESEARCH_GATE_REQUIRED`.

No implementar soporte NB estable hasta cerrar parametrizacion, CDF y benchmarks.

## 2. Fuentes Inspeccionadas

| source | evidence |
|---|---|
| `C:/Program Files/StataNow19/ado/base/n/nbreg.ado` | `nbreg` distingue `dispersion(mean)` y `dispersion(constant)`; usa `alpha`/`lnalpha`; guarda predictor `nbreg_p`. |
| `C:/Program Files/StataNow19/ado/base/g/glm.ado` | `glm` con `family(nbinomial ...)` llama/usa alpha de `nbreg` para inicializacion y registra familia interna. |
| `C:/Program Files/StataNow19/docs/r.pdf` | manual local Stata para `nbreg`. |
| `https://www.stata.com/manuals/rnbreg.pdf` | manual oficial online para `nbreg`. |
| `https://www.stata.com/support/faqs/stat/nbreg1.html` | FAQ oficial: Stata tiene dispersion mean/default y constant, relacionado con NB2/NB1. |
| `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/R/statmod/R/qres.R` | `statmod` detecta familias `Negative Binomial`; requiere mapear parametros R-Stata. |

## 3. Preguntas Que Deben Cerrarse

| question | required output |
|---|---|
| `nbreg` default es NB2? | formula exacta de varianza y CDF |
| `dispersion(constant)` corresponde a NB1? | formula exacta y mapeo R |
| `alpha`, `theta`, `k` | equivalencia `theta = 1/alpha` cuando aplique |
| `glm family(nbinomial)` | decidir si se soporta o se bloquea inicialmente |
| CDF Stata | validar `nbinomial()`/`ibeta()`/funcion equivalente |

## 4. Benchmarks Minimos

| dataset | purpose |
|---|---|
| synthetic_nb2 | known `mu`, known theta/alpha, no weights |
| stata_manual_nbreg | ejemplo oficial/manual |
| nb_edge_small | counts con ceros, mu pequeno/grande, alpha pequeno/grande |

Gate verde:

- muestra y coeficientes alineados;
- `mu`/`n` alineados;
- alpha/theta map cerrado;
- CDF `F(y-)` y `F(y)` alineadas;
- residuo final con `uvar()` alineado;
- 3 datasets pasan.

## 5. Decision

Si cualquier punto de parametrizacion no cierra, implementar solo error controlado para NB y registrar `HUMAN_DECISION_REQUIRED`.

Post-change documentation sync: `POST_CHANGE_SYNC_DONE`
