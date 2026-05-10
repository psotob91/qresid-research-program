# AGENTS.md

## 1. Funcion

Router operativo para trabajo asistido sobre `qresid`.

Este archivo vive en la raiz del workspace de investigacion. No forma parte del paquete Stata final.

## 2. Objetivo del proyecto

`qresid` es un paquete Stata/Mata para calcular y diagnosticar residuos cuantilicos, incluidos residuos cuantilicos aleatorizados, con trazabilidad matematica, estabilidad numerica, benchmarks R-Stata y preparacion eventual para SSC/Stata Journal.

El desarrollo debe priorizar:

- implementacion reproducible;
- validacion de CDF, PIT y transformacion normal;
- comparacion por capas contra R;
- estilo de paquete Stata publico;
- ausencia de claims sin tests.

## 3. Regla central

Antes de modificar codigo, leer el contexto minimo aplicable en `04_RETRIEVAL_CONTEXT/`.

No implementar una familia, comando, CDF, parametrizacion o regla de postestimacion si esta marcada como `EVIDENCIA PENDIENTE` o si no tiene evidencia suficiente.

## 4. Orden minimo de lectura

Para iniciar una tarea nueva:

1. `00_PROJECT_CONTEXT/PROJECT_BRIEF_QRESID.md`
2. `04_RETRIEVAL_CONTEXT/RETRIEVAL_MAP_FOR_QRESID.md`

Antes de tocar ado/do/Mata:

1. `04_RETRIEVAL_CONTEXT/STATA_MINIMAL_PROGRAMMING_NOTES.md`
2. archivo especifico de familia o comando;
3. `04_RETRIEVAL_CONTEXT/STATA_MODEL_EXTRACTION_RULES.md` si se toca `e()`, `predict`, pesos, offset, exposure o muestra.

Antes de tocar CDF, PIT, RNG o `invnormal()`:

1. `04_RETRIEVAL_CONTEXT/STATA_NUMERICAL_STABILITY_RULES.md`
2. `02_IMPLEMENTATION_MASTERS/07_ALGORITHM_PSEUDOCODE_MASTER.md`

Antes de tests, benchmarks o certificacion:

1. `04_RETRIEVAL_CONTEXT/STATA_TESTING_CERTIFICATION_RULES.md`
2. `04_RETRIEVAL_CONTEXT/STATA_R_BENCHMARK_MAPPING.md`

Antes de cambios publicos, help, examples, pkg o release:

1. `04_RETRIEVAL_CONTEXT/STATA_PACKAGE_STYLE_RULES.md`

## 5. Fases del proyecto

1. Fundamentos teoricos y definiciones.
2. Arquitectura Stata/Mata y API interna.
3. Implementacion minima viable.
4. Diagnosticos graficos.
5. Validacion extensa, stress testing y benchmarks.
6. Extensiones complejas.
7. Preparacion SSC/Stata Journal.

## 6. Fase 1 permitida

Familias y comandos elegibles solo si pasan extraccion, CDF, tests y benchmark:

- Gaussian: `regress`, `glm`;
- Poisson: `poisson`, `glm, family(poisson)`;
- Binomial/Bernoulli: `logit`, `logistic`, `binreg`, `glm, family(binomial)`;
- Negative binomial: `nbreg`, con parametrizacion documentada;
- Gamma: `glm, family(gamma)`.

## 7. Postergado o prohibido sin evidencia

No implementar como soporte activo en Fase 1:

- inverse Gaussian;
- Tweedie;
- ZIP/ZINB;
- hurdle;
- truncados;
- COM-Poisson;
- generalized Poisson;
- beta-binomial;
- modelos mixtos, panel, GLMM, GSEM o FMM;
- modelos bayesianos;
- modelos correlacionados complejos;
- diagnosticos simulacionales tipo DHARMa como sustituto de CDF analitica.

Usar error controlado o stub si una ruta fuera de fase aparece en codigo.

## 8. Reglas obligatorias Stata/Mata

- Todo ado/do publico debe declarar `version`.
- Usar `syntax`, no macros posicionales fragiles.
- Usar `marksample` y cruzar con `e(sample)`.
- Usar `tempvar`, `tempname` y `tempfile` para objetos internos.
- Crear CDF, PIT, uniformes, residuos y predicciones internas como `double`.
- Validar `e(cmd)` antes de calcular.
- Preferir `predict` para `mu`, `pr`, `n`, `xb` o cantidades postestimacion.
- No duplicar offset/exposure.
- Controlar RNG con `set seed` cuando haya aleatorizacion.
- Usar `uvar()` para benchmarks exactos R-Stata de residuos aleatorizados.
- No comparar exactamente RNG nativo de R contra RNG nativo de Stata.

## 9. Validaciones obligatorias antes de aceptar calculo

- `y` esta dentro del soporte de la familia.
- Parametros requeridos son extraibles via `predict` o `e()`.
- Parametros numericos tienen rango valido.
- `F_low` y `F_high` son `double`.
- `0 <= F_low <= F_high <= 1`.
- `U` cae dentro del intervalo PIT.
- `invnormal(U)` no genera missing inesperado.
- Las observaciones fuera de `e(sample)` no reciben residuo calculado.
- Familias discretas pasan benchmark final con `uvar()`.

## 10. Prohibiciones

- No incluir prompts, conversaciones, notas de IA, rastros de agente ni reasoning traces en el paquete final.
- No copiar codigo externo dentro de `qresid`.
- No asumir licencias de repos externos.
- No declarar soporte sin implementacion, help, ejemplo y test.
- No implementar CDF sin evidencia matematica y benchmark reproducible.
- No modificar `qresid/` sin tests correspondientes.
- No llenar archivos `09*` ni `10*` salvo instruccion explicita.

## 11. Detenerse y pedir revision humana

Detener la tarea si:

- falta evidencia para una CDF o parametrizacion;
- `predict` no permite extraer un parametro esencial;
- R y Stata no tienen parametrizacion alineada;
- `F_high + tol < F_low`;
- el benchmark falla antes de llegar al residuo final;
- el cambio ampliaria Fase 1 sin aprobacion;
- la solucion requiere copiar codigo externo;
- la documentacion publica prometeria soporte no certificado.

## 12. Checklist antes de commit

- Se leyeron los archivos de contexto aplicables.
- After any change, run the post-change documentation sync checklist in `04_RETRIEVAL_CONTEXT/POST_CHANGE_DOCUMENTATION_SYNC.md`.
- No se modifico codigo fuera del alcance.
- No se calculan residuos fuera de `e(sample)`.
- CDF, PIT y residuos usan `double`.
- Endpoints CDF tienen tests.
- `uvar()` cubre comparacion exacta con R cuando aplica.
- `seed()` reproduce resultados dentro de Stata.
- Modelos fuera de fase fallan con mensaje claro.
- No hay prompts ni rastros de agente en archivos publicos.
- Help, examples y claims coinciden con tests existentes.

## 13. Matriz viva de soporte y glosario

Despues de cualquier cambio que afecte soporte implementado, benchmarks, status experimental/diagnostico, help, README, changelog, release readiness o claims publicos:

- actualizar `04_RETRIEVAL_CONTEXT/QRESID_SUPPORT_STATUS_GLOSSARY.md` y `04_RETRIEVAL_CONTEXT/qresid_support_status_glossary.html` si cambio la semantica de algun termino;
- actualizar `03_REPO_REVIEW/QRESID_CURRENT_FEATURE_SUPPORT_MATRIX.md` y `03_REPO_REVIEW/qresid_current_feature_support_matrix.html` si cambio una funcionalidad, benchmark, status, semaforo de validez o claim;
- revisar `qresid/certification/reports/qresid_glm_link_matrix.html` y sus generadores si cambio soporte de familia, comando GLM, funcion de enlace, offset/exposure o evidencia familia x link, aunque el prompt no lo mencione explicitamente;
- verificar coherencia cruzada entre la matriz de soporte viva, el reporte GLM/link, el registry y benchmarks separados; si una ruta esta validada fuera del reporte visible, usar un estado granular como `EXPERIMENTAL_VALIDATED_SEPARATE_BENCHMARK` o `GATED_VARIANT`, no un `GATED_FUTURE` absoluto que oculte soporte existente;
- ejecutar o justificar el chequeo `qresid/tests/check_support_report_consistency.R` despues de cualquier cambio de soporte, benchmark, familia/link GLM, pesos o claim publico;
- si no aplica, registrar explicitamente `SUPPORT_MATRIX_SYNC_NOT_REQUIRED` en el resumen de cierre;
- no reescribir snapshots historicos para sincronizar esta matriz; el registry y los reportes vivos mandan.

Toda respuesta final sobre soporte, release, prerelease, validez del paquete o funcionalidades disponibles debe incluir enlaces al glosario HTML, a la matriz HTML y, si la respuesta trata familias GLM o links, al reporte GLM/link para consulta rapida.
