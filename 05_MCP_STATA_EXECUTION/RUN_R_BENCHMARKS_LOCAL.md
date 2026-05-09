# RUN_R_BENCHMARKS_LOCAL.md

## Purpose

Protocol for future local R benchmarks.

Status: `NOT_VERIFIED`.

## Preconditions

- Rscript verified.
- Benchmark script approved.
- R package versions logged.
- Uniform vectors shared through `uvar()` when exact discrete residual comparison is required.

## Suggested command pattern

```powershell
Rscript "path\to\benchmark.R"
```

Alternative full path:

```powershell
& "C:\Program Files\R\R-4.x.x\bin\Rscript.exe" "path\to\benchmark.R"
```

## Log requirements

- Store logs under `05_MCP_STATA_EXECUTION/R_EXECUTION_LOGS/`.
- Include `sessionInfo()`.
- Store generated comparison files under `TEMP_BENCHMARK_OUTPUTS/`.

## What not to claim

- Do not claim exact R-Stata equality for randomized residuals without shared uniform values.
- Do not claim weights support until family-specific evidence is closed.
- Do not claim NB stable support until parametrization and CDF are aligned.
