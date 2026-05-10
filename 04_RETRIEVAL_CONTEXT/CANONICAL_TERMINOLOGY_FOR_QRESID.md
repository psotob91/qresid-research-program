# CANONICAL_TERMINOLOGY_FOR_QRESID.md

Fecha: 2026-05-10

## 1. Proposito

Glosario operativo para evitar ambiguedad semantica en auditoria, retrieval, MCP, implementacion, testing y release de `qresid`.

Regla central: si un termino contradice `AGENTS.md`, `09_STATA_PACKAGE_ARCHITECTURE_MASTER.md` o `10_AGENT_RULES_FOR_QRESID.md`, domina la jerarquia normativa y este glosario debe actualizarse.

## 2. Terminos canonicos

| canonical_term | accepted_aliases | forbidden_or_deprecated_terms | definition | authority_doc | notes |
|---|---|---|---|---|---|
| RQR | randomized quantile residual, residuo cuantílico aleatorizado | residual cuantílico sin aclarar si es aleatorizado | Residuo basado en PIT/CDF y transformacion normal, con aleatorizacion dentro del salto CDF para discretas. | `07`, numerical rules | Usar `RQR` en documentos operativos. |
| quantile residual | qresidual, residuo cuantílico | residual generic | Residuo cuantílico; especificar si es aleatorizado cuando la familia es discreta. | `07` | No usar como sinonimo de cualquier residual. |
| randomized quantile residual | Dunn-Smyth residual, RQR | residual aleatorio sin CDF | RQR con uniforme externo o generado para discretas. | `07`, benchmark mapping | Comparacion exacta R-Stata requiere `uvar()`. |
| PIT | probability integral transform, uniformizacion | U si no se distingue de uniforme final | Transformacion a escala uniforme por CDF condicional ajustada. | numerical rules | En discretas, PIT usa intervalo `[F_low,F_high]`. |
| simulation-based residual | DHARMa-like residual, residual simulado | RQR analitico | Residuo basado en simulaciones, no en CDF analitica cerrada. | `09`, deep research | Fase 2/3; no reemplaza Fase 1 analitica. |
| endpoint | CDF endpoint, CDF bound | limite sin indicar lado | Valor de frontera CDF para `F(y-)` o `F(y)`. | numerical rules | Siempre validar orden. |
| `F_low` | `F(y-)`, lower endpoint, left CDF | Flo ambiguo sin definicion | CDF izquierda antes del salto discreto; igual a `F_high` en continuas. | `09`, numerical rules | Debe cumplir `0 <= F_low <= F_high <= 1`. |
| `F_high` | `F(y)`, upper endpoint | Fhi ambiguo sin definicion | CDF en la observacion. | `09`, numerical rules | Entrada a PIT en continuas. |
| `U` | PIT uniform, final uniform | `V` cuando es uniforme base | Uniforme final usado en `invnormal(U)`. | `09`, benchmark mapping | En discretas: `U = F_low + V*(F_high-F_low)`. |
| `uvar()` | external uniform, shared uniforms | seed como sinonimo | Opcion que recibe uniformes externos para comparacion exacta R-Stata. | `09`, `10`, benchmark mapping | Obligatorio para residuos discretos exactos. |
| `seed()` | Stata seed, RNG seed | reproducibilidad R-Stata exacta | Opcion para reproducibilidad interna de Stata. | `09`, `10` | No garantiza igualdad con R. |
| exact benchmark | pointwise benchmark, exact R-Stata | exacto sin `uvar()` en discretas | Comparacion punto a punto con misma muestra, parametros, CDF y uniformes compartidos cuando aplica. | benchmark mapping | En discretas requiere `uvar()`. |
| approximate benchmark | tolerance benchmark | exact benchmark | Comparacion por tolerancias numericas. | benchmark mapping | Usar para coeficientes, CDF y residuos continuos. |
| distributional benchmark | simulation benchmark, aggregate benchmark | exact benchmark | Comparacion por distribucion, graficos o tests agregados. | testing rules | No demuestra igualdad punto a punto. |
| supported | stable support | allowed, implemented | Implementado, testeado, benchmarkeado y documentado dentro del alcance declarado. | `09`, `10`, support glossary | No confundir con Fase 1 allowed ni con prerelease experimental. |
| SUPPORTED_TESTED | supported tested | stable si no hay release policy | Implementado, probado localmente, benchmarkeado y documentado para el alcance actual. | support glossary, feature matrix | Puede ser prerelease-ready sin implicar SSC/public RC. |
| READY_FOR_EXTENSION_PRERELEASE | prerelease-ready local, ready extension prerelease | public RC | Implementado y validado localmente con evidencia suficiente para prerelease experimental ampliado. | feature matrix, release audit | No autoriza public RC sin decision de release policy. |
| experimental | experimental validated local, extension experimental | research-only si hay codigo validado | En la rama actual significa implementado y validado localmente para prerelease experimental, pero no soporte estable/public RC. | support glossary, feature matrix | Si no hay codigo o benchmark, usar `GATED_RESEARCH` en vez de experimental. |
| EXPERIMENTAL_VALIDATED_LOCAL | experimental local | supported stable | Funciona y paso evidencia local, pero debe mantenerse como experimental hasta hardening/politica publica adicional. | support glossary, feature matrix | Usar para grouped binomial, NB minimo o fweight cuando aplique. |
| EXPERIMENTAL_VALIDATED_SEPARATE_BENCHMARK | separate benchmark evidence | unsupported | Funciona y paso evidencia local, pero la prueba principal vive en otro benchmark activo. | support glossary, GLM/link report | Usar cuando un reporte de alcance estrecho apunta a evidencia externa. |
| DIAGNOSTIC_ONLY | diagnostic, model-based diagnostic | exact support | Util como diagnostico, pero no equivale a soporte estandar ni a validacion exacta R-Stata. | support glossary, feature matrix | Usar para direct `[pweight=]` sin `svy:`. |
| STATA_ONLY_DIAGNOSTIC | Stata-only diagnostic | R equivalent | Diagnostico validado solo en Stata o sin equivalente R exacto aceptado. | support glossary, pweight plan | No usar como benchmark exacto R-Stata. |
| GATED_RESEARCH | research gate, gated | experimental implemented | Investigable, pero no implementado como soporte activo o no autorizado aun. | support glossary, extension matrix | Requiere benchmark/gate antes de codigo. |
| GATED_VARIANT | scoped gated variant | whole-family unsupported | Variante especifica todavia bloqueada aunque la ruta base este validada. | support glossary, GLM/link report | No usar para negar soporte a toda la familia. |
| REPORT_SCOPE_ONLY | report-scoped status | support matrix status | Estado que describe el alcance de un reporte, no el soporte global del paquete. | support glossary, GLM/link report | Ayuda a leer reportes complementarios sin contradiccion. |
| MISSING_NOT_BLOCKING | absent not blocking, out of scope | blocker | Falta una funcionalidad, pero no invalida el paquete porque no se reclama soporte. | support glossary, feature matrix | Inverse Gaussian, Tweedie y Phase 2 pueden estar aqui. |
| BLOCKS_PUBLIC_RC | blocks public release, release policy blocker | blocks local prerelease | No bloquea prerelease local, pero debe resolverse antes de public RC/SSC. | support glossary, release audit | Tipico: politica publica sobre pweight diagnostico. |
| BLOCKS_CURRENT_VALIDITY | invalidates current claim | future blocker | Pondria en duda la validez actual si algo prometido falla o carece de evidencia critica. | support glossary, feature matrix | No usar para faltantes fuera del alcance prometido. |
| postponed | deferred, future phase | supported | Fuera de Fase 1; no implementar salvo aprobacion. | `09` | ZIP/ZINB/hurdle/truncados y GLMM/GSEM segun caso. |
| evidence pending | `EVIDENCIA PENDIENTE`, pending evidence | supported | Falta CDF, extractor, parametrizacion o benchmark suficiente. | `AGENTS.md`, `10` | Bloquea soporte activo. |
| Phase 1 | Fase 1, Fase 1 allowed | stable support | Alcance permitido inicial: Gaussian, Bernoulli/binomial, Poisson, NB con gate y Gamma con gate. | `09` | No implica que ya este implementado. |
| Phase 2 | Fase 2 | Fase 1 | Extensiones como ZIP/ZINB, hurdle, truncados. | `09` | No bloquear Fase 1 core. |
| Phase 3 | Fase 3, Fase 2/3 | Fase 1 | GLMM/GSEM/FMM/xt/bayes/correlacionados o simulados. | `09` | Requiere revision humana. |
| dispatcher | model dispatcher, family dispatcher | parser | Logica que mapea `e(cmd)`/familia a extractor y CDF. | `09` | No cambiar sin actualizar tests. |
| postestimation | post-estimation, extraction | estimation | Uso de `predict`, `e()`, `e(sample)` despues de ajustar modelo. | extraction rules | Preferir `predict` final. |
| estimation sample | `e(sample)`, sample | if/in solamente | Muestra realmente usada por el estimador. | `09`, `10` | Cruzar con `marksample`. |
| offset | `offset()`, log-offset | exposure sin log | Termino aditivo en predictor lineal. | extraction rules | Usar `predict` final para evitar duplicacion. |
| exposure | `exposure()`, log exposure | offset si no se aclara escala | Exposicion que suele entrar como log-offset. | extraction rules | Validar no duplicacion. |
| weights | pesos, `e(wtype)`, `e(wexp)` | `sqrt(w_i)` global | Informacion ponderada cuya semantica depende de tipo y familia. | weights review, `09` | No activar sin decision por familia. |
| CDF | conditional CDF, distribution function | PDF/PMF | Funcion acumulada condicional ajustada usada para endpoints. | numerical rules | Debe estar en `[0,1]`. |
| RNG | random number generator, aleatorizacion | seed como garantia R-Stata | Sistema que genera uniformes base. | benchmark mapping | Separar `seed()` de `uvar()`. |
| MCP_READY_AFTER_HUMAN_DECISIONS | ready with human decisions | MCP_READY | Estado documental: protocolos y rutas preparados, pero quedan decisiones humanas/verificacion local. | MCP checklist | No habilita ejecucion automatizada completa. |
| MCP_READY | ready for MCP | ready with warnings | Stata/R verificados, protocolos poblados, logs minimos y decisiones bloqueantes cerradas. | MCP checklist | Requiere verificacion real. |
