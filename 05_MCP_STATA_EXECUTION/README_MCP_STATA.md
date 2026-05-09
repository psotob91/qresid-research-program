# README_MCP_STATA.md

## Purpose

Operational index for local Stata/R execution readiness before MCP is enabled for `qresid`.

Status: `LOCAL_SMOKE_PASSED_MCP_NOT_VERIFIED`.

This folder documents protocols and local smoke-test evidence. It does not prove that an MCP server can execute Stata/R until an MCP-mediated command is logged.

## Canonical documents

- `MCP_SETUP_LOG.md`: environment status and verification log.
- `STATA_EXECUTION_PROTOCOL.md`: Stata command/log protocol.
- `R_EXECUTION_PROTOCOL.md`: R/Rscript command/log protocol.
- `CODEX_EXECUTION_WORKFLOW.md`: how Codex should use these protocols.
- `RUN_STATA_TESTS_LOCAL.md`: suggested Stata test execution flow.
- `RUN_R_BENCHMARKS_LOCAL.md`: suggested R benchmark execution flow.

## Current state

- Stata availability: `SMOKE_PASSED`, latest log `STATA_EXECUTION_LOGS/20260510_044107_stata_smoke.log`.
- R availability: `SMOKE_PASSED`, latest log `R_EXECUTION_LOGS/20260510_044230_r_smoke.log`.
- MCP availability: `NOT_VERIFIED`.
- Local Stata/R smoke tests have been executed and logged. Package tests and MCP-mediated execution have not been executed.

## Before real MCP

- Verify MCP-mediated execution path.
- Run an MCP-mediated Stata/R smoke command and store logs.
- Do not claim tests passed unless logs exist and were reviewed.
- Do not modify `qresid/` until repo audit and test plan are approved.
