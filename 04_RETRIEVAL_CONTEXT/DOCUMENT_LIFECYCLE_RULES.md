# DOCUMENT_LIFECYCLE_RULES.md

Lifecycle: retrieval
Status: ACTIVE
Authority: normative
Superseded by: NONE
Retrieval policy: load by task

## 1. Purpose

Define document lifecycle rules for `qresid-research-program/` so audits, reviews, historical prompts, roadmaps and snapshots are not treated as active normative sources after their task is resolved.

## 2. Lifecycle Types

| lifecycle_type | meaning | examples |
|---|---|---|
| constitutional | Root boundaries and global rules | `AGENTS.md` |
| architecture | Architecture, API, phases, support surface | `09_STATA_PACKAGE_ARCHITECTURE_MASTER.md` |
| retrieval | Context selection, terminology, source logs, lifecycle rules | retrieval map, lifecycle registry |
| implementation | Pseudocode and technical implementation masters | `07_ALGORITHM_PSEUDOCODE_MASTER.md` |
| testing | Testing, certification, benchmark rules | `08`, testing rules, benchmark mapping |
| operational | Execution protocols, MCP, workflow, version lock | `05_MCP_STATA_EXECUTION/*.md` |
| audit_snapshot | Point-in-time audit finding | `DOCUMENT_*`, `PRE_MCP_FULL_*` |
| review_snapshot | Resolution queue, readiness or decision snapshot | MCP readiness, resolution logs |
| roadmap | Plan of future work | roadmap placeholders |
| historical | Historical prompt or plan retained for traceability | `qresid_plan_rearmado_retrieval_mcp.md` |
| archive | Preserved document with no operational authority | archived material |

## 3. Status Values

| status | meaning | retrieval behavior |
|---|---|---|
| ACTIVE | Current source for its scope | May load when task matches |
| PARTIALLY_ACTIVE | Current only for a narrow topic | Load only for that topic |
| SUPERSEDED | Replaced by newer source | Do not load by default |
| PARTIALLY_SUPERSEDED | Some findings remain useful; some resolved | Load only through registry |
| ARCHIVED | Preserved, non-operational | Do not load except archive review |
| OBSOLETE | Should not be used except historical audit | Do not load by default |
| DRAFT | Incomplete placeholder or unapproved draft | Do not use as authority |

## 4. Superseding Rules

- A snapshot never overrides `AGENTS.md`, `09_STATA_PACKAGE_ARCHITECTURE_MASTER.md`, `10_AGENT_RULES_FOR_QRESID.md` or `RETRIEVAL_MAP_FOR_QRESID.md`.
- A resolved audit or review becomes `PARTIALLY_SUPERSEDED` unless it is explicitly kept active for a narrow topic.
- A historical prompt is `SUPERSEDED` even if it remains in the repository root.
- A `DRAFT` document has no authority until it is populated and registered.
- A newer report does not automatically dominate older reports; dominance must be recorded in `DOCUMENT_STATUS_REGISTRY.md`.
- If two active documents conflict, stop and mark `HUMAN_DECISION_REQUIRED`.

## 5. Required Lifecycle Header

Every new audit, review, roadmap, historical plan or operational protocol should include:

```markdown
Lifecycle: <type>
Status: <state>
Authority: <normative|diagnostic|historical|none>
Superseded by: <path or NONE>
Retrieval policy: <load by default|load by task|do not load by default>
```

## 6. Anti-Drift Rules

- Do not copy old findings into new reports without marking whether they remain active.
- Do not leave `NOT_READY` snapshots as default retrieval after a later resolution log changes readiness.
- Do not use `Fase 1`, `supported`, `validated`, `MCP_READY`, `exact benchmark` or `EVIDENCIA PENDIENTE` outside the canonical terminology.
- When a new report resolves a finding, update the registry instead of editing historical reports.

## 7. Anti-Loop Retrieval Rules

- Before loading any `03_REPO_REVIEW/*.md`, consult `DOCUMENT_STATUS_REGISTRY.md`.
- If a report points to another report and the second points back, stop at the highest-authority active document.
- Do not follow chains through `SUPERSEDED`, `ARCHIVED` or `OBSOLETE` documents unless the task is historical audit.
- Use snapshots as evidence, not as normative instructions.

