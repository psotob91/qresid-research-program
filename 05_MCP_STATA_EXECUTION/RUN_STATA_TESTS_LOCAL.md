# RUN_STATA_TESTS_LOCAL.md

## Purpose

Protocol for future local Stata tests.

Status: `NOT_VERIFIED`.

## Preconditions

- Stata executable verified.
- `qresid/` repo audit completed.
- Test files approved.
- No unresolved decision required for the tested feature.

## Suggested command pattern

```powershell
stata-mp -b do "qresid\tests\run_all_tests.do"
```

Alternative full path:

```powershell
& "C:\Program Files\Stata18\StataMP-64.exe" /e do "qresid\tests\run_all_tests.do"
```

## Log requirements

- Store logs under `05_MCP_STATA_EXECUTION/STATA_EXECUTION_LOGS/`.
- Include date, Stata version, command, working directory and exit status.
- Treat missing log as test not run.

## What not to claim

- Do not claim certification passed from a smoke test.
- Do not claim Fase 1 support until unit, integration and benchmark evidence exists.
- Do not claim R-Stata exactness for discrete residuals without `uvar()`.
