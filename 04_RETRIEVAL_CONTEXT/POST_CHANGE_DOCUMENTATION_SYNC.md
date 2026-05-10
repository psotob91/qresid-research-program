# POST_CHANGE_DOCUMENTATION_SYNC.md

Lifecycle: retrieval
Status: ACTIVE
Authority: normative
Superseded by: NONE
Retrieval policy: load after any change

## 1. Purpose

Define the mandatory post-change documentation synchronization check for `qresid-research-program/`.

This file prevents code, tests, architecture, retrieval, MCP or documentation changes from leaving stale lifecycle status, stale retrieval maps, unresolved readiness claims or obsolete snapshots as active context.

## 2. Activation

Run this checklist after any change that touches:

- Stata/Mata/R code or package files;
- tests, certification scripts or benchmarks;
- public API, options, returned results, outputs or help;
- supported families, commands, CDF/PIT/RNG logic or extraction rules;
- support status, experimental/diagnostic classification, canonical support rows, feature matrix, public claims or release validity semaphore;
- retrieval maps, lifecycle status, source logs or terminology;
- MCP protocols, readiness, setup logs or execution workflows;
- audit/review snapshots, roadmaps, changelogs or release notes.

`RECOMENDACION OPERATIVA`: if a task only reads files and makes no changes, record no sync update unless it discovers a direct inconsistency.

## 3. Documents To Review

Always start with:

- `AGENTS.md`
- `04_RETRIEVAL_CONTEXT/RETRIEVAL_MAP_FOR_QRESID.md`
- `04_RETRIEVAL_CONTEXT/DOCUMENT_STATUS_REGISTRY.md`
- `04_RETRIEVAL_CONTEXT/DOCUMENT_LIFECYCLE_RULES.md`
- this file

Then review only the task-specific documents listed in the matrix below.

## 4. Update Decision Rule

Update a document only when the change makes an existing rule, status, route, readiness claim or public claim stale.

Do not update a document when:

- the change is purely internal and covered by existing rules;
- a snapshot is historical and the correct action is registry/resolution-log update;
- the only change was lifecycle/registry/sync metadata and no inconsistency was found;
- tests, Stata, R or MCP were not executed and readiness would need execution evidence.

If uncertain, add a short `sync_notes` entry in the registry rather than rewriting source documents.

## 5. Change Matrix

| Tipo de cambio | Docs que deben revisarse | Docs que suelen actualizarse | Obligatorio |
|---|---|---|---|
| cambio en `qresid.ado` | `09`, `10`, testing rules, help/changelog | tests, help, changelog | si |
| cambio en API publica | `09`, `.sthlp`, README, tests, style rules | `09`, help, README, tests, changelog | si |
| cambio en familia soportada | `09`, benchmark, testing, retrieval, extraction rules | `09`, tests, benchmark map, help | si |
| cambio en familia/link GLM | GLM/link benchmark scripts, `qresid_glm_link_matrix.html`, support matrix, registry | GLM/link producer/checker, HTML report, support matrix | si |
| cambio en soporte/status/claims | canonical support rows, support glossary, feature matrix, terminology, registry, help/README/changelog | `QRESID_SUPPORT_REPORT_CANONICAL_ROWS.md`, `QRESID_SUPPORT_STATUS_GLOSSARY.md`, `QRESID_CURRENT_FEATURE_SUPPORT_MATRIX.md`, HTML derivados | si |
| cambio o propuesta de residuo ajustado/studentizado/standardized adicional | standardized residual gate, API architecture, help, tests, benchmark rules, R package source audit | `QRESID_STANDARDIZED_QUANTILE_RESIDUALS_GATE.md`, `09`, `10`, help/changelog only after gate | si |
| cambio en `.sthlp`, MarkDoc, GitHub tooling o Quarto docs | `QRESID_STHLP_FORMAT_MASTER.md`, `QRESID_STHLP_CONTENT_MASTER.md`, help style master, documentation tooling master, package style rules, registry | `QRESID_STHLP_FORMAT_MASTER.md`, `QRESID_STHLP_CONTENT_MASTER.md`, `STATA_HELP_STYLE_MASTER.md`, `QRESID_DOCUMENTATION_TOOLING_MASTER.md`, website blueprint/regenerable map | si |
| cambio en packaging/release GitHub/SSC | package style rules, `09`, documentation tooling master, registry, README/help/changelog si hay enlaces publicos | SSC manifest, release builder, package style rules, `09`, post-change sync notes | si |
| cambio en cobertura count/Hilbe/external ado | canonical support rows, support matrix, unified extension matrix, source rules, registry, glossary | `QRESID_SUPPORT_REPORT_CANONICAL_ROWS.md`, `QRESID_HILBE_COUNT_MODEL_COVERAGE_PLAN.md`, `qresid_unified_extension_matrix.html`, glossary validation terms | si |
| cambio en evidencia separada de benchmark | support matrix, GLM/link report if adjacent, registry, glossary | scoped report notes and granular statuses | si |
| cambio en matriz de soporte, GLM/link report o estado de evidencia | canonical support rows, support matrix, unified matrix, GLM/link report, glossary, registry, `qresid/tests/check_support_report_consistency.R` | HTML regenerado y/o chequeo de consistencia | si |
| cambio en benchmark ejecutado o validacion Stata-internal/diagnostica | evidence index, GLM/link report, support matrix, registry, checker | `qresid_support_evidence_index.csv`, `qresid_glm_link_matrix.html`, badges/labels, consistency checker | si |
| cambio en retrieval | `AGENTS`, retrieval map, lifecycle rules, registry | retrieval map, registry | si |
| cambio en MCP | execution protocols, readiness checklist, resolution log | readiness checklist, setup log | si |
| cambio menor editorial | registry/lifecycle only if status changes | normalmente ninguno | no |

## 6. Anti-Loop Rules

- Do not update lifecycle/status documents only because lifecycle/status documents changed.
- If the only change was registry, lifecycle rules or this sync file, stop unless a direct inconsistency is detected.
- Do not follow snapshot chains through `SUPERSEDED`, `ARCHIVED`, `OBSOLETE` or `DRAFT` documents.
- If registry and a snapshot disagree, registry controls retrieval; create a resolution note instead of editing the old snapshot.
- If sync itself would require another sync with no new project change, stop.

## 7. Evidence Rule

- If tests were not executed, do not mark tests as passed.
- If Stata was not executed, do not mark Stata readiness as `READY`.
- If R/Rscript was not executed, do not mark R benchmark readiness as `READY`.
- If MCP was not executed, do not mark MCP readiness as `READY`.
- Use `READY_PENDING_EXECUTION` or `NOT_VERIFIED` when evidence is incomplete.

## 8. Snapshot Rule

Do not update historical audit snapshots to make them current.

When a snapshot finding is resolved:

- update `DOCUMENT_STATUS_REGISTRY.md`; or
- create/update the applicable resolution log; or
- mark the snapshot `PARTIALLY_SUPERSEDED` through lifecycle metadata.

## 9. Post-Change Checklist

- [ ] Cambio codigo?
- [ ] Cambio API?
- [ ] Cambio familia soportada?
- [ ] Cambio status experimental/diagnostico?
- [ ] Cambio semaforo de validez o release?
- [ ] Cambio benchmark?
- [ ] Cambio equivalente R o benchmark R-Stata?
- [ ] Cambio residuo ajustado/studentizado/standardized adicional o su gate?
- [ ] Cambio help estilo Stata, MarkDoc/GitHub tooling o Quarto website?
- [ ] Si cambio `qresid.sthlp`, se cargaron y obedecieron `QRESID_STHLP_FORMAT_MASTER.md` y `QRESID_STHLP_CONTENT_MASTER.md` como autoridad superior, dejando `STATA_HELP_STYLE_MASTER.md` como apoyo subordinado?
- [ ] GITHUB_RELEASE_AND_SSC_PAYLOAD_SYNC: si cambio release, packaging, help links o instalacion GitHub/SSC, se actualizo el manifiesto SSC, el builder automatico, las reglas normativas y se verifico que el ZIP SSC no incluya README/docs/tests/logs/assets/audits/pkg/toc?
- [ ] Cambio cobertura count/Hilbe, comando oficial Stata, ruta externa o tipo de validacion (`R_EXACT_BENCHMARK`, `STATA_INTERNAL_VALIDATION`, etc.)?
- [ ] Debe actualizarse `QRESID_HILBE_COUNT_MODEL_COVERAGE_PLAN.md`?
- [ ] CANONICAL_SUPPORT_ROW_SYNC: si se agrego/dividio una familia, comando, gate, peso o ruta RQR/PIT, se actualizo `QRESID_SUPPORT_REPORT_CANONICAL_ROWS.md` antes de regenerar las vistas?
- [ ] SUPPORT_EVIDENCE_INDEX_SYNC: si cambio un benchmark, validacion interna o diagnostico, se ejecuto `Rscript qresid/tests/build_support_evidence_index.R` y el GLM/link report consume ese indice?
- [ ] VISUAL_BADGE_SYNC: si cambio un estado o tipo de validacion, las vistas HTML mantienen badges automaticos verde/azul/ambar/gris/rojo/morado?
- [ ] Debe actualizarse `qresid_unified_extension_matrix.html`?
- [ ] Debe actualizarse `qresid/certification/reports/qresid_glm_link_matrix.html` porque cambio familia/link GLM?
- [ ] Hay coherencia cruzada entre tabla canonica, matriz de soporte, matriz unificada, GLM/link report, glosario, benchmarks separados y registry?
- [ ] Alguna ruta validada en benchmark separado esta marcada como `GATED_FUTURE` absoluto en otro reporte?
- [ ] Debe usarse `EXPERIMENTAL_VALIDATED_SEPARATE_BENCHMARK`, `GATED_VARIANT` o `REPORT_SCOPE_ONLY` para evitar ambiguedad?
- [ ] SUPPORT_REPORT_CONSISTENCY_CHECK: se ejecuto `Rscript qresid/tests/check_support_report_consistency.R` o se justifico por que no aplica?
- [ ] Cambio testing?
- [ ] Cambio retrieval?
- [ ] Cambio lifecycle status?
- [ ] Debe actualizarse `QRESID_SUPPORT_STATUS_GLOSSARY.md`?
- [ ] Debe actualizarse `qresid_support_status_glossary.html`?
- [ ] Debe actualizarse `QRESID_CURRENT_FEATURE_SUPPORT_MATRIX.md`?
- [ ] Debe actualizarse `qresid_current_feature_support_matrix.html`?
- [ ] Debe actualizarse changelog?
- [ ] Debe actualizarse help?
- [ ] Debe actualizarse readiness checklist?
- [ ] Debe marcarse algun review como superseded?
- [ ] Debe crearse resolution log?

## 10. Delivery Rule

Every final change summary should state one of:

- `POST_CHANGE_SYNC_DONE`
- `POST_CHANGE_SYNC_NOT_REQUIRED`
- `POST_CHANGE_SYNC_PENDING_HUMAN_DECISION`

For support, release, prerelease, benchmark or public-claim changes, also state one of:

- `SUPPORT_MATRIX_SYNC_DONE`
- `SUPPORT_MATRIX_SYNC_NOT_REQUIRED`
- `SUPPORT_MATRIX_SYNC_PENDING_HUMAN_DECISION`

Never claim a sync was completed if tests, Stata, R or MCP evidence was required but not executed.
