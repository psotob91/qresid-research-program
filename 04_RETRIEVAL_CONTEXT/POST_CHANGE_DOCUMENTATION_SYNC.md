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
- support status, experimental/diagnostic classification, feature matrix, public claims or release validity semaphore;
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
| cambio en soporte/status/claims | support glossary, feature matrix, terminology, registry, help/README/changelog | `QRESID_SUPPORT_STATUS_GLOSSARY.md`, `QRESID_CURRENT_FEATURE_SUPPORT_MATRIX.md`, HTML derivados | si |
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
- [ ] Debe actualizarse `qresid/certification/reports/qresid_glm_link_matrix.html` porque cambio familia/link GLM?
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
