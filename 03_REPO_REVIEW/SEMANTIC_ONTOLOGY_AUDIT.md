Lifecycle: audit_snapshot
Status: PARTIALLY_ACTIVE
Authority: diagnostic
Superseded by: 04_RETRIEVAL_CONTEXT/CANONICAL_TERMINOLOGY_FOR_QRESID.md
Retrieval policy: load by task

# SEMANTIC_ONTOLOGY_AUDIT.md

Fecha: 2026-05-10

## 1. Ontology map

| clase | documentos canonicos propuestos | notas |
|---|---|---|
| Constitutional/router | `AGENTS.md` | Limites globales y prohibiciones |
| Retrieval | `RETRIEVAL_MAP_FOR_QRESID.md` | Que leer y que ignorar |
| Architecture | `09_STATA_PACKAGE_ARCHITECTURE_MASTER.md` | API, fases, dispatcher, outputs |
| Agent operations | `10_AGENT_RULES_FOR_QRESID.md` | Antes de codigo/tests/docs |
| Numerical | `STATA_NUMERICAL_STABILITY_RULES.md` | CDF, PIT, clipping, tolerancias |
| Extraction | `STATA_MODEL_EXTRACTION_RULES.md`, family rules | `predict`, `e()`, muestra, offsets, pesos |
| Testing/benchmark | `STATA_TESTING_CERTIFICATION_RULES.md`, `STATA_R_BENCHMARK_MAPPING.md` | Tests, certification, R-Stata |
| Style/package | `STATA_PACKAGE_STYLE_RULES.md` | SSC/SJ, help, release |
| Evidence | `01_DEEP_RESEARCH/*.md`, weights review | No autoriza soporte |
| Audit | `03_REPO_REVIEW/*.md` | Diagnostico |
| MCP | `05_MCP_STATA_EXECUTION/*.md` | Pendiente/vacio |

## 2. Terminology map canonico

| termino | significado canonico | fuente dominante |
|---|---|---|
| RQR | Residuo cuantitico aleatorizado Dunn-Smyth | `07`, numerical rules |
| PIT | Uniformizacion por CDF condicional ajustada | numerical rules |
| endpoint | `F(y-)` y `F(y)` | numerical rules |
| benchmark exacto | Comparacion punto a punto solo cuando RNG esta controlado con `uvar()` | benchmark mapping |
| benchmark aproximado | Comparacion por tolerancias de coeficientes/CDF/residuos | benchmark mapping |
| Fase 1 | Familias no correlacionadas con CDF evaluable y extraction validada | `09` |
| Fase 2 | ZIP/ZINB/hurdle/truncados o extensiones discretas compuestas | `09` |
| Fase 2/3 | GLMM/GSEM/FMM/xt/bayes/correlacionados | `09` |
| supported | Implementado, testeado y benchmarkeado | debe documentarse mejor |
| evidence pending | No implementar salvo stub/error o investigacion | `AGENTS`, `10` |
| dispatcher | Mapeo `e(cmd)`/familia a extractor y CDF | `09` |
| family | Distribucion/model family declarada por Stata/R | `09`, extraction rules |
| weights | Semantica por familia/tipo de peso; no `sqrt(w_i)` global | weights review |

## 3. Synonym conflicts

| concepto | variantes | riesgo | recomendacion |
|---|---|---|---|
| RQR | randomized quantile residuals, residuos cuantÃ­licos, qresiduals | Bajo | Usar `RQR` + definicion corta |
| PIT | uniformizacion, CDF transform, U | Moderado | Reservar `U` para uniforme final usado |
| exacto | exacto, reproducible, deterministic, pointwise | Alto | "Exacto" solo con misma muestra, CDF y `uvar()` |
| supported | soportado, permitido, Fase 1, estable | Alto | Diferenciar `allowed`, `implemented`, `stable` |
| weights | weights, pesos, prior weights, frequency/trials | Alto | Usar tipo explicito |
| offset/exposure | offset, exposure, log exposure | Moderado | `predict` final como puente |

## 4. Semantic drift

- Gamma: antes Fase 1b/gate; ahora Fase 1 con gate tecnico. Drift resuelto, pero debe quedar en terminologia.
- Pesos: antes sugerencia `sqrt(w_i)`; ahora evidencia pendiente por familia. Drift resuelto parcialmente.
- Inverse Gaussian: deep research la trata como candidata; governance la mantiene pendiente. Drift controlado por jerarquia.
- MCP: plan historico describe archivos/protocolo no existentes. Drift no resuelto.
- `supported`: a veces significa "permitido en Fase 1" y a veces "estable/publicable". Falta puente semantico.

## 5. Missing semantic bridges

- `TERMINOLOGY_MASTER.md` vacio.
- No hay definicion canonica de `READY_FOR_MCP`, `READY_WITH_WARNINGS`, `NOT_READY`.
- No hay estado canonico para `experimental`, `postponed`, `stub`, `implemented`, `validated`, `stable`.
- No hay puente claro entre "auditoria de repo", "MCP execution", "implementation", "certification", "release".

## 6. Recommended canonical terminology

- `Fase 1 allowed`: dentro de alcance, pero no necesariamente implementado.
- `Implemented`: existe codigo.
- `Validated`: tiene tests unitarios/integracion.
- `Benchmarked`: comparado contra R por capas.
- `Stable support`: implementado + validado + benchmark + help.
- `EVIDENCIA PENDIENTE`: no activar calculo; solo investigacion o stub.
- `HUMAN_DECISION_REQUIRED`: bloqueo de decision, no inferir por fecha.
- `MCP_READY`: protocolo MCP poblado, rutas validas, checklist pasado.

