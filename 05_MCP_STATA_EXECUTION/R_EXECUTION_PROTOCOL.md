# R_EXECUTION_PROTOCOL.md

## Purpose

Protocol for future R/Rscript execution and R benchmarks for `qresid`.

Status: `LOCAL_EXECUTION_VERIFIED_MCP_NOT_VERIFIED`.

## Suggested Windows commands

```powershell
where.exe Rscript
Rscript --version
Rscript path\to\script.R
```

If Rscript is not in PATH, use the full executable path, for example:

```powershell
& "C:\Program Files\R\R-4.x.x\bin\Rscript.exe" "path\to\script.R"
```

The exact path and R version must be logged.

## Log protocol

- Write logs to `05_MCP_STATA_EXECUTION/R_EXECUTION_LOGS/`.
- For MCP setup verification, write unified local smoke logs to `05_MCP_STATA_EXECUTION/logs/`.
- Use timestamped names: `YYYYMMDD_HHMMSS_task.log`.
- Save benchmark intermediates only in `TEMP_BENCHMARK_OUTPUTS/`.
- Record package versions with `sessionInfo()`.

## Minimal smoke test later

```r
cat(R.version.string, "\n")
print(sessionInfo())
```

Do not claim R benchmarks passed without logs and reviewed output.

## Latest verified local smoke

Fecha: 2026-05-10 05:04 JST.

- Executable: `C:\Program Files\R\R-4.5.2\bin\x64\Rscript.exe`.
- Log: `05_MCP_STATA_EXECUTION/logs/20260510_050408_r_smoke.log`.
- CSV: `05_MCP_STATA_EXECUTION/logs/20260510_050408_r_smoke.csv`.
- Evidence: R `4.5.2`, `sessionInfo()`, CSV status `SMOKE_PASSED`.
- MCP-mediated R remains `NOT_VERIFIED`.
