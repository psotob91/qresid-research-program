Lifecycle: retrieval
Status: ACTIVE
Authority: normative/local
Superseded by: NONE
Retrieval policy: load before publishing help, README, website pages, or release-facing copy

# QRESID_AI_LANGUAGE_SUPERVISOR_MASTER.md

Date: 2026-05-10

POST_CHANGE_SYNC_DONE: created to keep public qresid documentation free of internal/AI traces.

## Purpose

Public `qresid` documentation must read like maintained statistical software, not like a project transcript. This master defines a final language pass for help files, README, Quarto pages, release notes, and public matrices.

## Required Pass

Before committing public-facing prose:

- Remove mentions of prompts, agents, AI, internal reasoning, "we decided in the conversation", or implementation chatter.
- Replace vague labels such as "works great" with evidence labels such as `R_EXACT_BENCHMARK`, `R_CDF_REPLAY`, or `STATA_ONLY_DIAGNOSTIC`.
- Avoid overpromising: "supported" means implemented, tested, benchmarked where applicable, documented, and synchronized.
- Use "experimental local prerelease" only when the support matrix uses that status.
- Keep warnings specific: state the unsupported model/weight/residual type and the safe alternative.
- Prefer short active sentences and Stata-style command-focused prose.

## Red Flags

| red flag | replacement |
|---|---|
| "AI", "Codex", "agent", "prompt" in public docs | remove or move to private audit context |
| "all models" | list supported families or link to support matrix |
| "standardized" without definition | say `type(quantile)` normal-score or `type(studentized)` leverage-standardized |
| "validated" without artifact | cite benchmark/report category |
| "future support soon" | say `GATED_RESEARCH` or `MISSING_NOT_BLOCKING` |

## Final Search Terms

Search public files for: `prompt`, `agent`, `Codex`, `ChatGPT`, `AI`, `reasoning`, `conversation`, `internal note`, `todo for agent`.
