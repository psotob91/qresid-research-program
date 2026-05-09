# STATA_EXECUTION_PROTOCOL.md

## Purpose

Protocol for future local Stata execution for `qresid`.

Status: `LOCAL_EXECUTION_VERIFIED_MCP_NOT_VERIFIED`.

## Suggested Windows commands

If Stata is in PATH:

```powershell
stata-mp -b do path\to\script.do
stata-se -b do path\to\script.do
stata -b do path\to\script.do
```

If Stata is not in PATH, use a full executable path, for example:

```powershell
& "C:\Program Files\Stata18\StataMP-64.exe" /e do "path\to\script.do"
```

The exact path must be verified locally before use.

## Log protocol

- Write logs to `05_MCP_STATA_EXECUTION/STATA_EXECUTION_LOGS/`.
- For MCP setup verification, write unified local smoke logs to `05_MCP_STATA_EXECUTION/logs/`.
- Use timestamped names: `YYYYMMDD_HHMMSS_task.log`.
- Keep generated temporary outputs in `TEMP_BENCHMARK_OUTPUTS/`.
- Do not copy logs or scratch outputs into the final Stata package.

## Minimal smoke test later

Use a small do-file that runs:

```stata
version 18
display c(stata_version)
clear
set obs 3
generate double x = _n
summarize x
```

Only mark Stata as verified after reviewing the log.

## Latest verified local smoke

Fecha: 2026-05-10 05:04 JST.

- Executable: `C:\Program Files\StataNow19\StataSE-64.exe`.
- Log: `05_MCP_STATA_EXECUTION/logs/20260510_050408_stata_smoke.log`.
- Evidence: `c(version)` = `18`, `c(stata_version)` = `19.5`, `sysuse auto`, `count` = `74`, `SMOKE_STATUS SMOKE_PASSED`.
- MCP-mediated Stata remains `NOT_VERIFIED`.
