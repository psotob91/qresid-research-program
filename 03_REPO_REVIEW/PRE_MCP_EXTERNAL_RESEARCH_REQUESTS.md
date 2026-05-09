Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load by research-planning task

# PRE_MCP_EXTERNAL_RESEARCH_REQUESTS.md

Fecha: 2026-05-10

| research_id | topic | why_needed | recommended_method | target_output_file | blocking_phase | priority |
|---|---|---|---|---|---|---|
| NB_PARAM_01 | NB1 vs NB2 exact mapping in Stata | Benchmark exactness and CDF correctness for `nbreg`. | OFFICIAL_STATA_MANUAL | `04_RETRIEVAL_CONTEXT/NB_PARAMETRIZATION_NOTES.md` | Phase 1 | HIGH |
| NB_R_01 | R NB benchmark mapping | Align Stata `nbreg` with R parameterization and CDF. | CRAN_SOURCE_REVIEW | `04_RETRIEVAL_CONTEXT/NB_R_BENCHMARK_NOTES.md` | Phase 1 | HIGH |
| WEIGHTS_RQR_01 | RQR weights by family/type | Avoid invalid global `sqrt(w_i)` rule; define family-specific semantics. | CRAN_SOURCE_REVIEW; LITERATURE_REVIEW | `03_REPO_REVIEW/WEIGHTS_RQR_EVIDENCE_REVIEW.md` | Phase 1 | HIGH |
| GAMMA_01 | Gamma GLM Stata vs R/statmod | Confirm `phi`, shape/scale and CDF benchmark. | OFFICIAL_STATA_MANUAL; CRAN_SOURCE_REVIEW | `04_RETRIEVAL_CONTEXT/GAMMA_GLM_BENCHMARK_NOTES.md` | Phase 1 | HIGH |
| MIXED_DIST_01 | Mixed/GLMM distribution prediction | Decide whether future MCP can audit simulated/conditional residuals. | OFFICIAL_STATA_MANUAL | `04_RETRIEVAL_CONTEXT/MIXED_DISTRIBUTION_PREDICT_NOTES.md` | Phase 2/3 | MEDIUM |
| ZIP_ZINB_01 | ZIP/ZINB exact benchmarks | Define extraction and CDF endpoints for inflated counts. | OFFICIAL_STATA_MANUAL; CRAN_SOURCE_REVIEW | `04_RETRIEVAL_CONTEXT/ZIP_ZINB_BENCHMARK_NOTES.md` | Phase 2 | MEDIUM |
