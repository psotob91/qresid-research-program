Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before extended overnight implementation

# QRESID_EXTENDED_OVERNIGHT_ITERATION_PLAN.md

Fecha: 2026-05-10

## 1. Proposito

Plan iterativo para avanzar `qresid` durante una corrida larga con checkpoints, tests, investigacion tecnica y rollback acotado.

Este plan extiende los planes Phase 0/Phase 1. No sustituye `AGENTS.md`, `09` ni `10`.

## 2. Regla De Checkpoint

Cada ciclo debe seguir:

1. Leer documentos aplicables.
2. Ejecutar cambio minimo.
3. Ejecutar Stata tests.
4. Ejecutar R benchmarks si aplica.
5. Si pasa el gate, commitear en `qresid/`.
6. Actualizar reportes y commitear el repo raiz con el gitlink.
7. Si falla, revertir solo los archivos del ciclo y registrar decision.

No usar `git reset --hard` sin instruccion explicita.

## 3. Checkpoints Sugeridos

| checkpoint | scope | gate |
|---|---|---|
| `checkpoint-phase0-scaffold` | test/certification scaffold | `PASS_WITH_EXPECTED_FAILURES`, 0 unexpected |
| `checkpoint-phase1b-api` | API oficial completa | parser tests verdes |
| `checkpoint-phase1b-core` | sample, RNG, outputs, returned results | sample/RNG/output tests verdes |
| `checkpoint-gaussian-poisson-bernoulli` | familias seguras iniciales | integration tests verdes |
| `checkpoint-gamma-research` | Gamma research + benchmarks | 3 datasets equivalentes |
| `checkpoint-nb-research` | NB research gate | equivalencia cerrada o stop |
| `checkpoint-weights-research` | weights research gate | matriz familia x tipo de peso |
| `checkpoint-docs-phase1` | help/README/examples/changelog | docs solo de soporte testeado |

## 4. Fuentes Locales Obligatorias

| topic | local source |
|---|---|
| GLM/Gamma/weights | `C:/Program Files/StataNow19/ado/base/g/glm.ado` |
| NB | `C:/Program Files/StataNow19/ado/base/n/nbreg.ado` |
| binomial | `C:/Program Files/StataNow19/ado/base/b/binreg.ado` |
| manuals | `C:/Program Files/StataNow19/docs/r.pdf`, `st.pdf` |
| R/statmod | `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/R/statmod/R/qres.R` |

## 5. Fuentes Online Permitidas

Usar solo para investigacion y citacion, no para copiar codigo:

- Stata `nbreg` manual: `https://www.stata.com/manuals/rnbreg.pdf`
- Stata `glm` manual: `https://www.stata.com/manuals/rglm.pdf`
- Stata NB FAQ: `https://www.stata.com/support/faqs/stat/nbreg1.html`
- `statmod` qresiduals docs/source: `https://rdrr.io/cran/statmod/man/qresiduals.html`

## 6. Benchmarks Requeridos Para Gamma/NB/Weights

Cada feature estable requiere al menos 3 datasets:

1. Sintetico con parametros conocidos.
2. Dataset oficial o de manual Stata/R.
3. Dataset adversarial pequeno con bordes numericos.

Comparar por capas:

- muestra;
- coeficientes;
- `mu/pr/n`;
- parametros accesorios;
- `F_low`, `F_high`;
- `U`;
- residuo final.

## 7. Regla De Parada

Detener la rama si:

- Stata y R no alinean parametrizacion;
- CDF exacta no queda cerrada;
- pesos no tienen semantica por familia;
- un benchmark falla antes del residuo final;
- la solucion requiere copiar codigo externo;
- docs publicas prometerian soporte no certificado.

Post-change documentation sync: `POST_CHANGE_SYNC_DONE`
