# CODEX_EXECUTION_WORKFLOW.md

## Purpose

Workflow for Codex before using MCP or local execution on `qresid`.

Status: `NOT_VERIFIED`.

## Required reading

1. `AGENTS.md`
2. `04_RETRIEVAL_CONTEXT/RETRIEVAL_MAP_FOR_QRESID.md`
3. `04_RETRIEVAL_CONTEXT/CANONICAL_TERMINOLOGY_FOR_QRESID.md`
4. `03_REPO_REVIEW/MCP_READINESS_CHECKLIST.md`
5. This folder's execution protocol relevant to the task.

## Rules

- Do not modify `qresid/` before repo audit and test plan are approved.
- Do not run destructive commands.
- Do not claim Stata/R/MCP success without logs.
- Do not activate weights, NB stable support, or API changes while they are `HUMAN_DECISION_REQUIRED`.
- Keep logs outside the final Stata package.

## Execution stages

1. Verify tool availability.
2. Run smoke test.
3. Review log.
4. Only then run targeted tests or benchmarks.
5. Record command, path, date, status and log path.

## Failure handling

If Stata/R/MCP is unavailable, mark `NOT_VERIFIED` or `FAILED_SETUP`; do not infer results from documentation.
