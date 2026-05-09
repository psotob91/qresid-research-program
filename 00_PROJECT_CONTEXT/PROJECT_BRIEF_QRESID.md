# `qresid`: Briefing Maestro para Programa de Investigación y Desarrollo

## 1. Descripción General del Proyecto

`qresid` es un paquete para Stata orientado a la implementación rigurosa, reproducible y extensible de residuos cuantílicos, especialmente residuos cuantílicos aleatorizados de Dunn y Smyth, para modelos estadísticos discretos y otros modelos probabilísticos complejos.

El objetivo central del proyecto es proporcionar herramientas diagnósticas modernas para modelos donde los residuos clásicos (Pearson, deviance, response residuals) presentan limitaciones importantes, particularmente en modelos discretos, sobredispersos, infradispersos o con distribuciones altamente asimétricas.

El proyecto combinará:

- teoría estadística formal;
- validación matemática;
- simulación Monte Carlo;
- comparación cruzada con implementaciones de referencia en R;
- ingeniería robusta de software estadístico en Stata/Mata;
- documentación técnica reproducible.

El desarrollo deberá seguir estándares compatibles con:

- paquetes SSC/Stata Journal;
- auditoría metodológica;
- trazabilidad matemática;
- reproducibilidad computacional;
- control estricto de versiones en GitHub.

---

# 2. Objetivo General

Desarrollar un paquete Stata robusto, matemáticamente documentado y computacionalmente validado para el cálculo y diagnóstico basado en residuos cuantílicos aleatorizados y extensiones relacionadas, inicialmente enfocado en modelos no correlacionados y posteriormente extensible a modelos más complejos.

---

# 3. Objetivos Específicos

## 3.1 Objetivos metodológicos

1. Implementar residuos cuantílicos aleatorizados según Dunn y Smyth.
2. Implementar residuos cuantílicos para distribuciones discretas y continuas.
3. Evaluar propiedades distribucionales bajo correcta especificación.
4. Comparar desempeño frente a:
   - Pearson residuals;
   - deviance residuals;
   - Anscombe residuals;
   - PIT residuals;
   - simulation-based residuals.
5. Investigar extensiones para:
   - modelos zero-inflated;
   - hurdle models;
   - modelos multinivel;
   - modelos correlacionados;
   - GAM/GAMLSS;
   - modelos bayesianos;
   - modelos simulacionales estilo DHARMa.

---

## 3.2 Objetivos computacionales

1. Desarrollar implementación eficiente en Mata.
2. Garantizar estabilidad numérica.
3. Implementar pruebas automáticas de validación.
4. Comparar resultados contra implementaciones de referencia en R.
5. Permitir integración futura con:
   - `glm`
   - `poisson`
   - `nbreg`
   - `zinb`
   - `zip`
   - `menbreg`
   - `gsem`
   - extensiones de terceros.

---

## 3.3 Objetivos editoriales y de distribución

1. Crear documentación técnica reproducible.
2. Mantener trazabilidad matemática completa.
3. Preparar eventual publicación estilo Stata Journal.
4. Mantener estructura compatible con SSC.
5. Evitar cualquier rastro de:
   - prompts;
   - agentes;
   - lenguaje LLM;
   - notas internas de desarrollo asistido.

---

# 4. Alcance Inicial

## 4.1 Modelos incluidos inicialmente

### GLM y modelos de conteo no correlacionados

- Gaussian
- Poisson
- Quasi-Poisson
- Negative Binomial
- Gamma
- Binomial
- Beta-binomial (EVIDENCIA PENDIENTE)
- Conway-Maxwell-Poisson (EVIDENCIA PENDIENTE)
- Generalized Poisson (EVIDENCIA PENDIENTE)

---

## 4.2 Funcionalidades iniciales

- cálculo de residuos cuantílicos;
- residuos cuantílicos aleatorizados;
- residuos normalizados;
- QQ plots;
- histogramas;
- worm plots;
- pruebas de normalidad;
- gráficos residual-vs-fitted;
- simulaciones Monte Carlo;
- comparación contra R.

---

# 5. Alcance Futuro

## 5.1 Extensiones metodológicas

- modelos zero-inflated;
- hurdle models;
- modelos multinivel;
- modelos longitudinales;
- residuos PIT;
- simulation-based residuals;
- integración parcial con ideas tipo DHARMa;
- bootstrap diagnostics;
- envelopes simulados;
- diagnóstico de dependencia.

---

## 5.2 Extensiones computacionales

- paralelización;
- simulación masiva;
- integración con frames;
- soporte para grandes datasets;
- API Mata reutilizable.

---

# 6. Exclusiones Explícitas

## 6.1 Exclusiones metodológicas

No implementar inicialmente:

- residuos para modelos correlacionados complejos sin teoría sólida;
- residuos para modelos bayesianos sin definición matemática clara;
- diagnósticos puramente heurísticos sin literatura;
- métodos “inspirados” en paquetes de R sin validación formal.

---

## 6.2 Exclusiones editoriales

El paquete final NO debe contener:

- prompts;
- instrucciones de agentes;
- comentarios tipo ChatGPT;
- notas internas de IA;
- artefactos temporales;
- reasoning traces;
- texto no científico;
- referencias inventadas.

---

# 7. Definiciones Conceptuales

## 7.1 Residuo cuantílico

Transformación residual basada en la función de distribución acumulada (CDF) del modelo ajustado.

Idea central:

Si el modelo está correctamente especificado, la transformación probabilística debería producir una distribución aproximadamente uniforme y posteriormente normalizable mediante la inversa normal estándar.

---

## 7.2 Residuo cuantílico aleatorizado

Definición propuesta por Dunn y Smyth para variables discretas.

Para una observación discreta:

\[
u_i \sim \text{Uniform}(F(y_i^-), F(y_i))
\]

y luego:

\[
r_i = \Phi^{-1}(u_i)
\]

donde:

- \(F(y_i^-)\) es el límite izquierdo de la CDF;
- \(\Phi^{-1}\) es la inversa normal estándar.

Objetivo:

Evitar acumulaciones artificiales debidas a discreción.

---

## 7.3 Residuo cuantílico normalizado

Residuo cuantílico transformado mediante:

\[
r_i = \Phi^{-1}(u_i)
\]

para obtener distribución aproximadamente:

\[
N(0,1)
\]

bajo correcta especificación.

---

## 7.4 Simulation-based quantile residual

Residuos construidos mediante simulaciones desde el modelo ajustado en lugar de usar únicamente la CDF analítica.

Muy usados cuando:

- la CDF exacta es complicada;
- existen efectos aleatorios;
- existen dependencias;
- el modelo es implícito o simulacional.

Relación conceptual cercana con DHARMa.

---

## 7.5 PIT residual

Residual basado en Probability Integral Transform:

\[
u_i = F(y_i)
\]

Si el modelo es correcto:

\[
u_i \sim U(0,1)
\]

Problema:

En variables discretas el PIT no es continuo, por lo que suelen requerirse randomizaciones.

---

## 7.6 Diferencias con Pearson residuals

Pearson residual:

\[
r_i = \frac{y_i - \mu_i}{\sqrt{Var(y_i)}}
\]

Limitaciones:

- fuerte asimetría;
- discreción;
- mala aproximación normal;
- patrones espurios;
- pobre desempeño en conteos pequeños.

---

## 7.7 Diferencias con deviance residuals

Basados en contribuciones a la deviance del likelihood.

Ventajas:

- mejores propiedades asintóticas;
- interpretabilidad ligada a likelihood.

Limitaciones:

- aún problemáticos en conteos discretos;
- normalidad imperfecta;
- sensibilidad a rare events.

---

# 8. Criterios de Calidad para Aceptar una Implementación

## 8.1 Criterios matemáticos

Toda implementación debe:

- tener definición matemática explícita;
- derivarse de literatura existente;
- indicar claramente supuestos;
- indicar limitaciones.

---

## 8.2 Criterios computacionales

Toda implementación debe:

- reproducir ejemplos publicados;
- coincidir razonablemente con R;
- ser estable numéricamente;
- manejar valores extremos;
- manejar probabilidades cercanas a 0 y 1;
- evitar overflow/underflow.

---

## 8.3 Criterios de simulación

Deben realizarse:

- simulaciones bajo correcta especificación;
- simulaciones bajo misspecification;
- evaluación de:
  - normalidad;
  - sensibilidad;
  - robustez;
  - potencia diagnóstica.

---

## 8.4 Criterios editoriales

Toda funcionalidad debe incluir:

- help file;
- ejemplos reproducibles;
- referencias;
- documentación de validación.

---

# 9. Outputs Maestros Esperados

## 9.1 Outputs metodológicos

- revisión sistemática conceptual;
- mapa de métodos;
- taxonomía de residuos;
- benchmark frente a R.

---

## 9.2 Outputs computacionales

- ado principal;
- librerías Mata;
- suite de pruebas;
- datasets ejemplo;
- scripts de certificación.

---

## 9.3 Outputs editoriales

- manual técnico;
- tutoriales;
- vignettes;
- artículo estilo Stata Journal;
- sitio GitHub Pages (opcional).

---

## 9.4 Outputs de validación

- simulaciones Monte Carlo;
- comparación cruzada con R;
- benchmarking computacional;
- tablas de concordancia.

---

# 10. Reglas de Trazabilidad

## 10.1 Regla central

Toda afirmación matemática o computacional debe estar vinculada a:

- artículo;
- libro;
- documentación oficial;
- derivación explícita;
- benchmark reproducible.

---

## 10.2 Reglas de documentación

Cada módulo debe documentar:

- fuente matemática;
- ecuación;
- supuestos;
- referencias;
- diferencias frente a R;
- limitaciones conocidas.

---

## 10.3 Reglas de evidencia

Si no existe respaldo claro:

Debe marcarse explícitamente como:

> EVIDENCIA PENDIENTE

---

# 11. Reglas para el Paquete Final

## 11.1 Limpieza editorial

El repositorio público final NO debe incluir:

- prompts;
- conversaciones;
- instrucciones LLM;
- comentarios de IA;
- archivos scratch;
- archivos temporales.

---

## 11.2 Estilo técnico

Todo contenido final debe:

- parecer escrito por humanos expertos;
- seguir estándares Stata Journal;
- evitar lenguaje informal;
- evitar sobreexplicación innecesaria.

---

## 11.3 Reproducibilidad

Todo resultado publicado debe:

- poder regenerarse;
- tener scripts;
- fijar semillas cuando corresponda;
- documentar versiones.

---

# 12. Decisiones Aún Abiertas

## 12.1 Preguntas metodológicas

- ¿Qué definición exacta usar para modelos zero-inflated?
- ¿Cómo tratar mezclas discretas-continuas?
- ¿Qué métodos adoptar para efectos aleatorios?
- ¿Debe implementarse enfoque DHARMa-like?
- ¿Cómo manejar residuals condicionados vs marginales?
- ¿Cómo tratar simulaciones dependientes?

---

## 12.2 Preguntas computacionales

- ¿Qué partes implementar en Mata puro?
- ¿Qué nivel de vectorización exigir?
- ¿Cómo estructurar API interna?
- ¿Cómo manejar extensibilidad por distribución?

---

## 12.3 Preguntas editoriales

- ¿Preparar desde el inicio artículo Stata Journal?
- ¿Usar GitHub Actions?
- ¿Implementar certificación continua?

---

# 13. Riesgos Técnicos

## 13.1 Riesgos matemáticos

- ausencia de teoría para ciertos modelos;
- ambigüedad conceptual entre residuos PIT y residuals simulacionales;
- diferencias entre implementaciones de R;
- problemas de interpretación en modelos discretos extremos.

---

## 13.2 Riesgos computacionales

- inestabilidad numérica;
- probabilidades degeneradas;
- errores de precisión flotante;
- simulaciones lentas;
- incompatibilidades entre comandos Stata.

---

## 13.3 Riesgos editoriales

- documentación insuficiente;
- mezcla de teoría incompleta con implementación;
- sobreextensión temprana del paquete.

---

# 14. Orden Recomendado de Trabajo

## Fase 1 — Fundamentos teóricos

1. Revisar Dunn y Smyth.
2. Construir taxonomía de residuos.
3. Revisar PIT residuals.
4. Revisar DHARMa.
5. Revisar GAMLSS.

---

## Fase 2 — Arquitectura computacional

1. Diseñar API.
2. Diseñar estructura Mata.
3. Diseñar validaciones.
4. Diseñar datasets benchmark.

---

## Fase 3 — Implementación mínima viable

1. Poisson.
2. Binomial.
3. Negative binomial.
4. Gaussian.
5. Comparación contra R.

---

## Fase 4 — Diagnósticos

1. QQ plots.
2. Worm plots.
3. Residual envelopes.
4. Simulation diagnostics.

---

## Fase 5 — Validación extensa

1. Monte Carlo.
2. Stress testing.
3. Benchmarks.
4. Comparaciones cruzadas.

---

## Fase 6 — Extensiones

1. Zero-inflated.
2. Hurdle.
3. Multinivel.
4. Correlacionados.

---

## Fase 7 — Publicación

1. SSC readiness.
2. Stata Journal paper.
3. Versionado estable.
4. Documentación pública.
