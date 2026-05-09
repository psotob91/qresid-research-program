# DEPRECATED / HISTORICAL PLAN — DO NOT USE AS ACTIVE INSTRUCTION

Lifecycle: historical
Status: SUPERSEDED
Authority: historical
Superseded by: `AGENTS.md`; `04_RETRIEVAL_CONTEXT/RETRIEVAL_MAP_FOR_QRESID.md`; `04_RETRIEVAL_CONTEXT/DOCUMENT_STATUS_REGISTRY.md`
Retrieval policy: do not load by default

This file is retained for historical traceability only. Current operational authority is:

1. `AGENTS.md`
2. `04_RETRIEVAL_CONTEXT/RETRIEVAL_MAP_FOR_QRESID.md`
3. `02_IMPLEMENTATION_MASTERS/09_STATA_PACKAGE_ARCHITECTURE_MASTER.md`
4. `02_IMPLEMENTATION_MASTERS/10_AGENT_RULES_FOR_QRESID.md`
5. `05_MCP_STATA_EXECUTION/README_MCP_STATA.md` for current MCP preparation.

Do not execute prompts, paths or MCP assumptions from this historical plan without checking current retrieval and MCP readiness documents.

---

# Plan rearmado para `qresid`: retrieval + MCP Stata + Codex Desktop

## Diagnóstico general

El flujo seguido hasta el Prompt 7 está bien armado y no debe reescribirse. Lo correcto ahora no es tocar los documentos ya producidos, sino agregar una capa de **context engineering**, **retrieval local** y **ejecución/verificación con Stata** antes de pedirle a Codex que audite o programe. El objetivo es que Codex deje de depender de su memoria general sobre Stata/Mata y trabaje con evidencia local: manuales, help files, artículos Stata Journal/SSC, paquetes Stata bien escritos, documentación R de referencia, outputs de benchmarking y tus maestros metodológicos.

La lógica nueva queda así:

1. Mantener intacto lo ya producido hasta `08_TESTING_QC_BENCHMARK_MASTER.md`.
2. Agregar carpetas de soporte para retrieval, fuentes externas y ejecución MCP.
3. Insertar dos prompts nuevos antes del antiguo Prompt 8:
   - nuevo Prompt 8A: construir índice retrieval y log de fuentes.
   - nuevo Prompt 8B: configurar/verificar MCP Stata o, si MCP no está disponible, crear protocolo equivalente local.
4. Ejecutar la auditoría del repo solo después de que Codex pueda consultar fuentes externas y, preferentemente, correr Stata.
5. Crear maestros de arquitectura y reglas del agente solo después de la auditoría.
6. Implementar Fase 1 solo después de aprobar teoría, arquitectura, tests y benchmarking.

## Qué agregar sin modificar lo existente

Estructura recomendada:

```text
qresid-research-program/
├── 00_PROJECT_CONTEXT/
├── 01_DEEP_RESEARCH/
├── 02_IMPLEMENTATION_MASTERS/
├── 03_REPO_REVIEW/
├── 04_RETRIEVAL_CONTEXT/                 # NUEVO
│   ├── README_RETRIEVAL_CONTEXT.md
│   ├── RETRIEVAL_SOURCE_MANIFEST.md
│   ├── RETRIEVAL_QUERY_PLAYBOOK.md
│   ├── SOURCE_ACCESS_LOG.md              # mover/copiar aquí si hoy está en 00
│   ├── STATA_OFFICIAL_MANUALS/
│   │   ├── README.md
│   │   └── index_manifest.csv
│   ├── STATA_HELP_SNAPSHOTS/
│   │   ├── README.md
│   │   └── help_manifest.csv
│   ├── STATA_JOURNAL_AND_SSC/
│   │   ├── README.md
│   │   └── package_manifest.csv
│   ├── EXEMPLAR_STATA_REPOS/
│   │   ├── README.md
│   │   └── repo_manifest.csv
│   ├── R_REFERENCE_SOURCES/
│   │   ├── README.md
│   │   └── r_reference_manifest.csv
│   └── RETRIEVAL_NOTES/
│       ├── stata_programming_patterns.md
│       ├── mata_patterns.md
│       ├── postestimation_patterns.md
│       ├── help_file_patterns.md
│       └── ssc_submission_patterns.md
├── 05_MCP_STATA_EXECUTION/                # NUEVO
│   ├── README_MCP_STATA.md
│   ├── MCP_SETUP_LOG.md
│   ├── STATA_EXECUTION_PROTOCOL.md
│   ├── CODEX_DESKTOP_WORKFLOW.md
│   ├── RUN_STATA_TESTS_LOCAL.md
│   ├── RUN_R_BENCHMARKS_LOCAL.md
│   └── logs/
├── 06_AGENT_WORKSPACE/                    # NUEVO, no público
│   ├── PROMPTS_ACTIVE/
│   ├── AGENT_RUN_LOGS/
│   ├── SCRATCH_NOT_PUBLIC/
│   └── OUTPUTS_TO_REVIEW/
└── qresid/
```

Regla clave: `04_RETRIEVAL_CONTEXT`, `05_MCP_STATA_EXECUTION` y `06_AGENT_WORKSPACE` pertenecen al programa de investigación, no al paquete final. No deben terminar dentro del paquete público `qresid` salvo archivos depurados y humanos como tests, examples, README, help, certification y changelog.

## Archivos nuevos mínimos

### 1. `04_RETRIEVAL_CONTEXT/README_RETRIEVAL_CONTEXT.md`

Propósito: explicar que esta carpeta contiene fuentes externas curadas para que Codex consulte antes de escribir código Stata/Mata.

Debe contener:

- qué fuentes están permitidas;
- qué fuentes son primarias;
- qué fuentes son secundarias;
- cómo citar/usar cada fuente;
- qué no puede copiarse dentro del paquete final;
- regla: si Codex no encuentra evidencia, debe marcar `EVIDENCIA PENDIENTE`.

### 2. `04_RETRIEVAL_CONTEXT/RETRIEVAL_SOURCE_MANIFEST.md`

Tabla maestra:

| ID | Tipo | Fuente | Archivo/local path | Uso permitido | Prioridad | Estado |
|---|---|---|---|---|---|---|
| STATA-P | Manual Programming | PDF oficial Stata | path | sintaxis ado, syntax, marksample, ereturn | alta | pendiente |
| STATA-M | Manual Mata | PDF oficial Stata | path | Mata, funciones numéricas | alta | pendiente |
| STATA-U | User-written package | repo/ado | path | patrones idiomáticos | media | pendiente |
| R-STATMOD | R source/docs | statmod | path | benchmarking GLM | alta | pendiente |

### 3. `04_RETRIEVAL_CONTEXT/RETRIEVAL_QUERY_PLAYBOOK.md`

Debe decirle a Codex qué buscar antes de programar:

- “Antes de modificar `qresid.ado`, recuperar patrones de `syntax`, `marksample`, `tempvar`, `capture confirm`, `predict`, `ereturn`, `return`, `sortpreserve`.”
- “Antes de implementar Mata, recuperar ejemplos de funciones Mata con vistas, matrices, missing values y funciones especiales.”
- “Antes de tocar `qresid.sthlp`, recuperar ejemplos de help files SSC/Stata Journal.”
- “Antes de implementar NB, recuperar parametrización Stata vs R.”
- “Antes de implementar RNG, recuperar reglas de `set seed`, `runiform()`, opción `uvar()` y pruebas reproducibles.”

### 4. `05_MCP_STATA_EXECUTION/STATA_EXECUTION_PROTOCOL.md`

Debe definir:

- cómo ejecutar `do` files;
- dónde guardar logs;
- cómo fallar si hay error;
- cómo comparar outputs Stata/R;
- cómo registrar versión de Stata;
- cómo registrar plataforma;
- qué comandos correr antes de aceptar cambios.

### 5. `05_MCP_STATA_EXECUTION/CODEX_DESKTOP_WORKFLOW.md`

Debe ser la guía práctica para trabajar en tu PC:

1. Abrir Codex Desktop apuntando a `qresid-research-program`.
2. Verificar que el workspace contiene el clon `qresid/`.
3. Pedir auditoría solo lectura.
4. Crear branch local antes de cambios.
5. Ejecutar tests localmente.
6. No hacer commit hasta que Stata y R benchmarks pasen.
7. Separar commits: estructura, ado, help, tests, docs.

## Sobre GitHub Actions

No lo necesitas para empezar. Si trabajas con Codex Desktop en tu PC, GitHub Actions puede quedar como fase posterior de integración continua. Lo importante ahora es tener:

- tests locales reproducibles;
- logs Stata;
- scripts R de benchmark;
- comandos claros de ejecución;
- un protocolo que Codex pueda seguir.

GitHub Actions recién entra cuando ya tengas una suite local estable. En Stata puede ser más difícil por licencias, así que no conviene bloquear el proyecto por CI.

## Flujo rearmado de prompts

### Prompt 8A — construir capa retrieval local

Modo: Codex Desktop / agente local, sin tocar código.

Objetivo: crear la infraestructura de retrieval y manifest de fuentes.

```text
Actúa como scientific software engineer, bibliotecario técnico de software estadístico y arquitecto de context engineering para agentes de programación.

Workspace raíz:
`qresid-research-program/`

No modifiques el repo `qresid/`.
No modifiques los documentos maestros existentes.

Lee obligatoriamente:
- `00_PROJECT_CONTEXT/PROJECT_BRIEF_QRESID.md`
- `01_DEEP_RESEARCH/01_THEORY_RQR_MASTER.md`
- `01_DEEP_RESEARCH/02_R_PACKAGES_RQR_MASTER.md`
- `01_DEEP_RESEARCH/03_STATA_PACKAGES_RQR_MASTER.md`
- `02_IMPLEMENTATION_MASTERS/07_ALGORITHM_PSEUDOCODE_MASTER.md`
- `02_IMPLEMENTATION_MASTERS/08_TESTING_QC_BENCHMARK_MASTER.md`

Objetivo:
Crear una capa de retrieval local para mejorar el rendimiento de Codex en Stata/Mata y evitar que programe desde memoria.

Crea, si no existen, estas carpetas:
- `04_RETRIEVAL_CONTEXT/`
- `04_RETRIEVAL_CONTEXT/STATA_OFFICIAL_MANUALS/`
- `04_RETRIEVAL_CONTEXT/STATA_HELP_SNAPSHOTS/`
- `04_RETRIEVAL_CONTEXT/STATA_JOURNAL_AND_SSC/`
- `04_RETRIEVAL_CONTEXT/EXEMPLAR_STATA_REPOS/`
- `04_RETRIEVAL_CONTEXT/R_REFERENCE_SOURCES/`
- `04_RETRIEVAL_CONTEXT/RETRIEVAL_NOTES/`

Crea estos archivos:
- `04_RETRIEVAL_CONTEXT/README_RETRIEVAL_CONTEXT.md`
- `04_RETRIEVAL_CONTEXT/RETRIEVAL_SOURCE_MANIFEST.md`
- `04_RETRIEVAL_CONTEXT/RETRIEVAL_QUERY_PLAYBOOK.md`
- `04_RETRIEVAL_CONTEXT/RETRIEVAL_GAPS_AND_REQUESTS.md`

Contenido mínimo:
1. Lista de fuentes primarias requeridas:
   - Stata Programming Reference Manual
   - Stata Mata Reference Manual
   - Stata User's Guide sections on estimation/postestimation
   - help files oficiales de `glm`, `poisson`, `nbreg`, `logit`, `binreg`, `predict`, `marksample`, `syntax`, `ereturn`, `return`
   - documentación Stata Journal/SSC relevante para paquetes ado/sthlp
   - código fuente/documentación R de `statmod::qresiduals`
2. Lista de fuentes ejemplares opcionales:
   - paquetes Stata user-written con buena arquitectura ado/Mata
   - ejemplos de help files SSC/Stata Journal
3. Tabla manifest con columnas:
   - source_id
   - source_type
   - title
   - local_path_or_url
   - priority
   - use_case
   - license_or_access_note
   - retrieval_status
   - last_checked
4. Query playbook para que futuros agentes sepan qué recuperar antes de tocar código.
5. Gaps: enumera qué PDFs, help files o repos aún faltan descargar/manualizar.

Reglas:
- No inventes fuentes descargadas si no están localmente.
- Marca todo lo pendiente como `PENDING`.
- No copies texto propietario largo dentro de archivos del proyecto; solo registra referencia, path y uso permitido.
- No toques `qresid/`.

Entrega al final:
- árbol de carpetas creado
- lista de archivos nuevos
- lista de fuentes pendientes de conseguir
- cómo usar esta capa en el Prompt 8B y Prompt 9.
```

### Prompt 8B — configurar/verificar MCP Stata o protocolo local equivalente

Modo: Codex Desktop / agente local. Idealmente con MCP Stata. Si no hay MCP, generar protocolo y scripts.

```text
Actúa como senior Stata/Mata developer, DevOps local y auditor de ejecución reproducible.

Workspace raíz:
`qresid-research-program/`

No modifiques aún el código del paquete salvo crear archivos de infraestructura fuera de `qresid/`.

Lee obligatoriamente:
- `04_RETRIEVAL_CONTEXT/README_RETRIEVAL_CONTEXT.md`
- `04_RETRIEVAL_CONTEXT/RETRIEVAL_SOURCE_MANIFEST.md`
- `04_RETRIEVAL_CONTEXT/RETRIEVAL_QUERY_PLAYBOOK.md`
- `02_IMPLEMENTATION_MASTERS/08_TESTING_QC_BENCHMARK_MASTER.md`
- `02_IMPLEMENTATION_MASTERS/07_ALGORITHM_PSEUDOCODE_MASTER.md`

Objetivo:
Preparar la ejecución local de Stata y R para que Codex pueda auditar, testear y corregir `qresid` con evidencia empírica.

Tareas:
1. Crear carpeta `05_MCP_STATA_EXECUTION/` si no existe.
2. Crear:
   - `README_MCP_STATA.md`
   - `MCP_SETUP_LOG.md`
   - `STATA_EXECUTION_PROTOCOL.md`
   - `CODEX_DESKTOP_WORKFLOW.md`
   - `RUN_STATA_TESTS_LOCAL.md`
   - `RUN_R_BENCHMARKS_LOCAL.md`
   - `logs/`
3. Detectar si existe forma local de ejecutar Stata desde terminal:
   - Windows: `StataMP-64.exe`, `StataSE-64.exe`, `stata-mp`, etc.
   - macOS/Linux: `stata-mp`, `stata-se`, `xstata-mp`, etc.
4. Si MCP Stata está disponible, documentar cómo se invoca y hacer una prueba mínima:
   - abrir Stata
   - correr `display c(version)`
   - correr `sysuse auto, clear`
   - guardar log en `05_MCP_STATA_EXECUTION/logs/`
5. Si MCP Stata NO está disponible, no detener el proyecto:
   - documentar que se trabajará con protocolo local equivalente
   - crear comandos manuales para ejecutar `.do` files
   - crear plantilla de logs
6. Verificar R local:
   - `Rscript --version`
   - crear instrucción para correr benchmarks R
7. Crear protocolo mínimo de aceptación antes de modificar código:
   - Stata corre
   - R corre
   - se puede ejecutar un `.do`
   - se puede guardar log
   - se puede comparar CSV de R vs Stata

Reglas:
- No toques `qresid.ado` ni `qresid.sthlp`.
- No inventes que Stata corre si no lo verificaste.
- Si no puedes ejecutar Stata, deja instrucciones manuales exactas para que el usuario lo ejecute.
- Todo resultado debe guardarse en logs.

Entrega:
- estado de MCP Stata: disponible / no disponible / no verificado
- estado de Stata local
- estado de R local
- archivos creados
- comandos exactos para la siguiente auditoría.
```

### Prompt 9 — auditoría del repo qresid con retrieval y ejecución

Este reemplaza al antiguo Prompt 8.

```text
Actúa como auditor senior de paquetes Stata, estadístico matemático, desarrollador Stata/Mata y maintainer de software científico.

Workspace raíz:
`qresid-research-program/`
Repositorio objetivo local:
`qresid/`
Repositorio remoto de referencia:
https://github.com/psotob91/qresid

Usa obligatoriamente estos documentos maestros:
- `00_PROJECT_CONTEXT/PROJECT_BRIEF_QRESID.md`
- `01_DEEP_RESEARCH/01_THEORY_RQR_MASTER.md`
- `01_DEEP_RESEARCH/02_R_PACKAGES_RQR_MASTER.md`
- `01_DEEP_RESEARCH/03_STATA_PACKAGES_RQR_MASTER.md`
- `01_DEEP_RESEARCH/04_GRAPHICS_TESTS_DIAGNOSTICS_MASTER.md`
- `02_IMPLEMENTATION_MASTERS/07_ALGORITHM_PSEUDOCODE_MASTER.md`
- `02_IMPLEMENTATION_MASTERS/08_TESTING_QC_BENCHMARK_MASTER.md`
- `04_RETRIEVAL_CONTEXT/RETRIEVAL_SOURCE_MANIFEST.md`
- `04_RETRIEVAL_CONTEXT/RETRIEVAL_QUERY_PLAYBOOK.md`
- `05_MCP_STATA_EXECUTION/STATA_EXECUTION_PROTOCOL.md`

Objetivo:
Auditar el paquete actual `qresid` y crear una hoja de ruta por fases para completarlo, sin modificar todavía el código.

Antes de auditar:
1. Usa el retrieval playbook para consultar patrones Stata/Mata relevantes.
2. Verifica la estructura completa del repo.
3. Si Stata está disponible, ejecuta solo pruebas no destructivas:
   - `which qresid` apuntando al repo local si procede
   - carga de help si es posible
   - chequeo de sintaxis básica con un ejemplo mínimo
   - guarda logs
4. Si no puedes ejecutar Stata, dilo explícitamente y audita estáticamente.

Evalúa:
- estructura SSC/Stata package
- sintaxis ado
- manejo de `syntax`, `if/in`, `marksample`, `e(sample)`
- uso de `predict`
- recuperación de familia/enlace/parámetros
- manejo de offsets/exposure
- manejo de pesos
- RNG, `seed()`, `uvar()` y guardado de uniformes
- CDF endpoints `F(y-)` y `F(y)`
- estabilidad numérica
- familias soportadas vs teoría
- pruebas existentes
- ejemplos existentes
- help file `.sthlp`
- README
- pkg/toc
- license
- readiness SSC/Stata Journal
- deuda técnica
- bugs probables
- features que deben eliminarse, posponerse o marcarse experimental

Crea estos documentos:
- `03_REPO_REVIEW/QRESID_CURRENT_REPO_AUDIT.md`
- `03_REPO_REVIEW/QRESID_ROADMAP_PHASED_UPDATES.md`
- `03_REPO_REVIEW/QRESID_PRE_IMPLEMENTATION_TESTS_TO_RUN.md`

Roadmap obligatorio:
- Fase 0: limpieza y estructura
- Fase 1: GLM no correlacionados y conteos básicos
- Fase 2: conteos complicados
- Fase 3: diagnósticos gráficos y pruebas
- Fase 4: extensiones simuladas/multinivel
- Fase 5: paper Stata Journal / SSC

Reglas:
- No modifiques archivos del paquete.
- No inventes que algo funciona: si no lo corriste, dilo.
- Toda recomendación debe apuntar a un documento maestro o fuente retrieval.
- Toda feature sin teoría suficiente debe marcarse `EVIDENCIA PENDIENTE` o `POSTPONER`.
- Antes de proponer cambios de código, indica qué pruebas deben correrse.

Entrega final:
- resumen ejecutivo
- archivos revisados
- pruebas ejecutadas y no ejecutadas
- hallazgos críticos
- roadmap
- checklist antes de implementar.
```

### Prompt 10 — maestros de arquitectura y reglas del agente

Este reemplaza al antiguo Prompt 9.

```text
Actúa como arquitecto de software estadístico Stata/Mata, maintainer SSC/Stata Journal y diseñador de reglas para agentes de programación.

Workspace raíz:
`qresid-research-program/`

Usa obligatoriamente:
- `03_REPO_REVIEW/QRESID_CURRENT_REPO_AUDIT.md`
- `03_REPO_REVIEW/QRESID_ROADMAP_PHASED_UPDATES.md`
- `03_REPO_REVIEW/QRESID_PRE_IMPLEMENTATION_TESTS_TO_RUN.md`
- `02_IMPLEMENTATION_MASTERS/07_ALGORITHM_PSEUDOCODE_MASTER.md`
- `02_IMPLEMENTATION_MASTERS/08_TESTING_QC_BENCHMARK_MASTER.md`
- `01_DEEP_RESEARCH/06_STATA_JOURNAL_SOFTWARE_ARTICLES_MASTER.md`
- `04_RETRIEVAL_CONTEXT/RETRIEVAL_SOURCE_MANIFEST.md`
- `04_RETRIEVAL_CONTEXT/RETRIEVAL_QUERY_PLAYBOOK.md`
- `05_MCP_STATA_EXECUTION/STATA_EXECUTION_PROTOCOL.md`

Objetivo:
Crear o actualizar dos archivos maestros que controlen el trabajo futuro de agentes/Codex sobre `qresid`.

Archivo 1:
`02_IMPLEMENTATION_MASTERS/09_STATA_PACKAGE_ARCHITECTURE_MASTER.md`

Debe incluir:
1. estructura final del paquete
2. arquitectura de comandos
3. sintaxis pública propuesta
4. sintaxis interna y subrutinas
5. opciones obligatorias y opcionales
6. familias soportadas por fase
7. familias explícitamente postergadas
8. manejo RNG: `seed()`, `uvar()`, guardar uniformes
9. manejo de modelos post-estimation
10. manejo de `e(sample)`, `if/in`, missing values
11. offsets/exposure/weights
12. reglas de errores y warnings
13. outputs esperados: residuo, U, CDF lower/upper, flags
14. gráficos y pruebas por fase
15. estrategia de benchmarking contra R
16. estrategia de versionado
17. estructura de help file
18. estructura de examples
19. estructura de certification scripts
20. criterios de aceptación antes de cada release

Archivo 2:
`02_IMPLEMENTATION_MASTERS/10_AGENT_RULES_FOR_QRESID.md`

Debe incluir reglas estrictas:
1. No incluir rastros de ChatGPT/agente en el paquete final.
2. No modificar teoría matemática sin fuente.
3. No implementar familias marcadas como falta de teoría.
4. No romper compatibilidad Stata sin justificar.
5. No cambiar sintaxis pública sin actualizar help, tests y changelog.
6. No mezclar scripts de investigación con paquete final.
7. Antes de modificar código, leer todos los MD maestros y retrieval playbook.
8. Antes de escribir código, recuperar fuentes relevantes del retrieval.
9. Cada cambio debe tener test.
10. Cada función nueva debe tener ejemplo.
11. Cada warning debe estar documentado.
12. Cada familia debe exponer o permitir validar `F(y-)`, `F(y)`, `U` y `qres`.
13. Si MCP/Stata está disponible, ejecutar pruebas antes y después del cambio.
14. Si no se ejecutó Stata, no declarar que el código funciona.
15. Si una regla se romperá, detenerse y explicar qué regla rompería y por qué.

No modifiques código todavía.

Entrega:
- archivos creados/actualizados
- decisiones de arquitectura críticas
- decisiones que requieren aprobación humana antes de implementación.
```

### Prompt 11 — implementación Fase 0 antes de Fase 1

Nuevo. Conviene antes de programar residuos.

```text
Actúa como desarrollador senior Stata/Mata y maintainer de paquete público.

Workspace raíz:
`qresid-research-program/`
Repositorio local:
`qresid/`

Lee obligatoriamente:
- `02_IMPLEMENTATION_MASTERS/09_STATA_PACKAGE_ARCHITECTURE_MASTER.md`
- `02_IMPLEMENTATION_MASTERS/10_AGENT_RULES_FOR_QRESID.md`
- `03_REPO_REVIEW/QRESID_CURRENT_REPO_AUDIT.md`
- `03_REPO_REVIEW/QRESID_ROADMAP_PHASED_UPDATES.md`
- `03_REPO_REVIEW/QRESID_PRE_IMPLEMENTATION_TESTS_TO_RUN.md`
- `05_MCP_STATA_EXECUTION/STATA_EXECUTION_PROTOCOL.md`

Objetivo:
Implementar solo Fase 0: limpieza, estructura y preparación de tests, sin cambiar la lógica estadística central salvo correcciones claramente necesarias.

Alcance Fase 0:
- ordenar estructura de carpetas del paquete si hace falta
- crear/actualizar `CHANGELOG.md`
- crear/actualizar `tests/README.md`
- crear/actualizar `certification/README.md`
- crear plantilla de tests Stata
- crear plantilla de benchmarks R
- asegurar que el paquete no contiene prompts ni archivos de agente
- no introducir nuevas familias
- no cambiar sintaxis pública salvo decisión documentada

Reglas:
- cambios pequeños y auditables
- una razón por archivo modificado
- ejecutar tests disponibles si Stata está disponible
- guardar logs

Entrega:
- diff resumido
- archivos modificados
- comandos ejecutados
- logs generados
- próximos pasos para Fase 1.
```

### Prompt 12 — implementación Fase 1

Este reemplaza al antiguo Prompt 10.

```text
Actúa como desarrollador senior de Stata/Mata, estadístico computacional y maintainer de software estadístico reproducible.

Workspace raíz:
`qresid-research-program/`
Repositorio local:
`qresid/`

Lee obligatoriamente antes de modificar:
- `02_IMPLEMENTATION_MASTERS/09_STATA_PACKAGE_ARCHITECTURE_MASTER.md`
- `02_IMPLEMENTATION_MASTERS/10_AGENT_RULES_FOR_QRESID.md`
- `02_IMPLEMENTATION_MASTERS/07_ALGORITHM_PSEUDOCODE_MASTER.md`
- `02_IMPLEMENTATION_MASTERS/08_TESTING_QC_BENCHMARK_MASTER.md`
- `03_REPO_REVIEW/QRESID_ROADMAP_PHASED_UPDATES.md`
- `04_RETRIEVAL_CONTEXT/RETRIEVAL_QUERY_PLAYBOOK.md`
- `05_MCP_STATA_EXECUTION/STATA_EXECUTION_PROTOCOL.md`

Antes de escribir código:
1. Recupera fuentes relevantes del retrieval para:
   - `syntax`
   - `marksample`
   - `e(sample)`
   - `predict, mu`
   - `seed()` / `runiform()`
   - CDF Poisson/binomial/NB/Gaussian
   - help file `.sthlp`
2. Revisa tests existentes.
3. Si hay contradicción entre documentos, detente y reporta.

Objetivo:
Implementar Fase 1 del paquete `qresid`.

Alcance Fase 1:
- modelos no correlacionados
- GLM/postestimation cuando sea factible
- familias prioritarias:
  - Gaussian
  - Bernoulli/binomial
  - Poisson
  - negative binomial solo si Stata expone parámetros suficientes y se valida parametrización
- RQR continuo/discreto según Dunn–Smyth
- opción `seed()`
- opción para guardar uniformes usados
- opción `uvar()` para benchmarking exacto
- opción para guardar endpoints CDF lower/upper si fue definida en arquitectura
- help file actualizado
- examples mínimos
- tests/certification scripts
- comparación contra R para Poisson y binomial como mínimo

Reglas:
1. Haz cambios pequeños y auditables.
2. No agregues familias sin test.
3. No agregues zero-inflated todavía salvo como TODO documentado.
4. No incluyas prompts ni lenguaje de agente dentro del paquete.
5. Actualiza README, help y changelog si cambia la interfaz.
6. Crea tests antes o junto con el cambio.
7. Toda familia debe validar `F(y-) <= F(y)`.
8. Toda probabilidad enviada a `invnormal()` debe protegerse contra 0/1 exactos cuando corresponda.
9. Si no puedes ejecutar Stata, no declares que funciona; deja comandos exactos.
10. Si Stata está disponible, ejecuta tests y guarda logs.

Entrega:
- resumen de cambios
- archivos modificados
- comandos Stata para correr tests
- comandos R para benchmarking
- resultados de tests
- limitaciones conocidas
- tareas pendientes para Fase 2.
```

## Orden operativo recomendado en tu PC

1. Hacer backup o commit del estado actual:
   ```bash
   git status
   git add .
   git commit -m "Add qresid research masters through testing plan"
   ```
2. Crear branch de preparación:
   ```bash
   git checkout -b dev-retrieval-mcp-setup
   ```
3. Ejecutar Prompt 8A en Codex Desktop.
4. Descargar/colocar fuentes en `04_RETRIEVAL_CONTEXT/` según el manifest.
5. Ejecutar Prompt 8B.
6. Ejecutar Prompt 9 de auditoría.
7. Revisar manualmente los MD de auditoría.
8. Ejecutar Prompt 10 para arquitectura/reglas.
9. Revisar manualmente `09` y `10`.
10. Crear branch de implementación:
    ```bash
    git checkout -b dev-qresid-phase0-phase1
    ```
11. Ejecutar Prompt 11.
12. Correr tests manuales.
13. Ejecutar Prompt 12.
14. Correr Stata + R benchmarks.
15. Solo después hacer commit.

## Criterio de avance/no avance

No pasar a implementación Fase 1 si falta cualquiera de estos puntos:

- no existe auditoría del repo;
- no existe arquitectura aprobada;
- no existe regla explícita para `seed()` y `uvar()`;
- no existe criterio para comparar `F(y-)` y `F(y)`;
- no existe protocolo de ejecución Stata/R;
- Codex no pudo leer fuentes de retrieval relevantes;
- no hay tests mínimos definidos para Poisson y binomial.

## Qué NO debe hacerse

- No pedir a Codex “implementa todo qresid”.
- No iniciar zero-inflated/hurdle antes de cerrar GLM básicos.
- No confiar en residuos aleatorios finales para validar R vs Stata sin `uvar()` común.
- No meter prompts o reglas de agente dentro del repo público final.
- No hacer que GitHub Actions sea requisito inicial.
- No aceptar código que no exponga o valide endpoints CDF.
