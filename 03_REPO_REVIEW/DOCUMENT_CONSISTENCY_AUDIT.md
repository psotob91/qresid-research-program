Lifecycle: audit_snapshot
Status: PARTIALLY_SUPERSEDED
Authority: diagnostic
Superseded by: 03_REPO_REVIEW/PRE_MCP_FULL_DOCUMENT_AUDIT.md
Retrieval policy: load by task

# DOCUMENT_CONSISTENCY_AUDIT.md

## 1. Resumen ejecutivo

Auditoria documental ejecutada sobre 32 Markdown del workspace, excluyendo `qresid/` y `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/`.

Resultado actualizado tras limpieza 2026-05-10:

- No se detectan conflictos `CRITICAL` que invaliden el mapa de retrieval.
- Gamma queda resuelto como Fase 1 activa, con gate tecnico de CDF, forma/escala y benchmark R.
- Offset/exposure queda resuelto por jerarquia: regla dominante `predict`-first.
- Retrieval queda corregido para ruta de `PROJECT_BRIEF_QRESID.md` y preambulo de reportes `DOCUMENT_*`.
- Pesos siguen como conflicto `MAJOR`: requieren subauditoria por familia/tipo de peso antes de activarse.
- La mayor deuda restante es normativa/API, pesos, placeholders vacios y deep research que puede leerse como regla si se omite la jerarquia.

Archivos auditados: 32.

---

## 2. Conflictos criticos y mayores

### CRITICAL

No se detectaron conflictos `CRITICAL` nuevos tras la Iteracion 2 ni tras la limpieza 2026-05-10.

### MAJOR activos

| topic | resumen | impacto | resolucion recomendada |
|---|---|---|---|
| Pesos | Evidencia Dunn-Smyth/statmod/gamlss/glmmTMB no apoya `sqrt(w_i)` global. Pesos requieren semantica por familia y tipo de peso. | Riesgo de implementar residuos ponderados incorrectos. | `human_decision`; leer `WEIGHTS_RQR_EVIDENCE_REVIEW.md`; bloquear activacion hasta benchmark. |
| API publica | `07` conserva pseudocodigo con `generate()`/`distribution()`; `09` propone `newvarname`, `seed()`, `uvar()`, `save*()`, `family()`. | Riesgo de parser incompatible con arquitectura actual. | `hierarchy`; `09` domina; marcar `07` como pseudocodigo historico. |
| Inverse Gaussian | Deep research la recomienda para implementacion inicial; governance actual la marca pendiente/prohibida sin evidencia. | Riesgo de scope creep hacia familia sin CDF Stata validada. | `hierarchy`; `09`/`10` dominan; documentar supersession. |

### Resueltos por decision o jerarquia

| topic | resolucion |
|---|---|
| Gamma | Fase 1 activa. Requiere validar `y > 0`, `mu > 0`, `phi > 0`, `shape = 1/phi`, `scale = mu*phi`, CDF y benchmark R. |
| Offset/exposure | Usar `predict` final por defecto. Reconstruccion `xb + offset` solo como fallback auditado y con tests de no duplicacion. |
| Source log interno | Ruta corregida a `00_PROJECT_CONTEXT/PROJECT_BRIEF_QRESID.md`. |
| Retrieval de reportes | `RETRIEVAL_MAP_FOR_QRESID.md` referencia reportes `DOCUMENT_*` y evidencia de pesos antes de auditar `qresid/`. |

---

## 3. Contradicciones por tema

### 3.1 Familias

- Gamma: conflicto cerrado; gobiernan `09` y `10` actualizados.
- Negative binomial: no es contradiccion; es gap reconocido sobre `alpha/theta/k`, NB1/NB2 y benchmark.
- Inverse Gaussian: contradiccion temporal entre deep research y gobernanza; resolver por jerarquia.
- ZIP/ZINB, hurdle, truncados, GLMM/GSEM: consistentemente postergados.

### 3.2 RNG y benchmarking

- `seed()` solo garantiza reproducibilidad interna Stata.
- `uvar()` sigue obligatorio para comparacion exacta R-Stata en discretas.
- No hay contradiccion activa; la duplicacion es aceptable.

### 3.3 Extraccion Stata

- `predict, n` para `poisson`/`nbreg`, `predict, pr` para `logit`/`logistic`, `predict, mu` para `glm`/`binreg` aparecen alineados.
- Offset/exposure queda resuelto: `predict` final domina; no duplicar offset.
- `e(sample)` esta consistentemente exigido.

### 3.4 Arquitectura/API

- La API actual debe derivarse de `09`.
- `07` contiene pseudocodigo con interfaz vieja; no debe usarse como fuente de parser publico.
- `family()`, `replace`, `savev()` y alias siguen como gaps explicitos en `09`/`10`.

### 3.5 Pesos

- Regla anterior `sqrt(w_i)` queda retirada como norma general.
- Pesos pasan a investigacion obligatoria en `WEIGHTS_RQR_EVIDENCE_REVIEW.md`.
- `HUMAN_DECISION_REQUIRED`: no activar soporte ponderado sin matriz familia x tipo de peso x benchmark.

### 3.6 Retrieval

- `RETRIEVAL_MAP_FOR_QRESID.md` reconoce `AGENTS.md`, `09`, `10`, reportes `DOCUMENT_*` y pesos.
- `SOURCE_ACCESS_LOG.md` ya no tiene la ruta rota de `PROJECT_BRIEF_QRESID.md`.

---

## 4. Duplicaciones

Duplicaciones aceptables:

- Reglas Stata basicas en `AGENTS.md`, `10`, style rules y minimal notes.
- Reglas RNG en numerical, benchmark y testing.
- Reglas de no prompts/traces en router, agentes y style.

Duplicaciones con riesgo:

- API antigua en `07` convive con API recomendada en `09`.
- Deep research menciona familias futuras como implementacion inicial sin reflejar gates posteriores.

---

## 5. Shadow rules

| regla escondida | archivo | estado |
|---|---|---|
| `generate()`/`distribution()` como parser | `07_ALGORITHM_PSEUDOCODE_MASTER.md` | Shadow rule activa; `09` domina. |
| Inverse Gaussian como ruta inicial | `01_THEORY_RQR_MASTER.md` | Shadow rule informativa; `09`/`10` dominan. |
| `sqrt(w_i)` global | `07`, extraction rules | Retirada como norma; reemplazada por evidencia de pesos. |

---

## 6. Gaps y ambiguedades

- Cerrar parametrizacion NB: `alpha`, `theta`, `k`, NB1/NB2 y CDF exacta.
- Cerrar politica de pesos por familia antes de activar transformacion.
- Decidir API publica final: `family()`, `replace`, `savev()` vs `saveu()`, aliases.
- Decidir que hacer con placeholders vacios: poblar, marcar `RESERVED`, o retirar de retrieval map futuro.

---

## 7. Reglas huerfanas

- `00_PROJECT_CONTEXT/TERMINOLOGY_MASTER.md` esta vacio y no aporta autoridad terminologica.
- `00_PROJECT_CONTEXT/SOURCE_ACCESS_LOG.md` esta vacio y duplica por nombre a `04_RETRIEVAL_CONTEXT/SOURCE_ACCESS_LOG.md`.
- Los archivos `05_MCP_STATA_EXECUTION/*.md` estan vacios; no deben ser tratados como reglas operativas hasta poblarse.
- `03_REPO_REVIEW/QRESID_CURRENT_REPO_AUDIT.md` y `QRESID_ROADMAP_PHASED_UPDATES.md` estan vacios; son placeholders, no evidencia.

---

## 8. Recomendacion

Es seguro continuar a auditoria de `qresid/` sin modificar codigo si se lee primero `AGENTS.md`, retrieval map, `09`, `10`, esta auditoria y la cola de conflictos.

No es recomendable implementar soporte estable hasta resolver pesos, API publica final y NB. Gamma puede entrar en Fase 1 con tests especificos; offset/exposure debe auditarse contra la regla `predict`-first.

