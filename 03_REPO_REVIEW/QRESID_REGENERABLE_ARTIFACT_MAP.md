Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before deleting logs, rerunning certification, or regenerating reports from clean state

# QRESID_REGENERABLE_ARTIFACT_MAP.md

Date: 2026-05-10

POST_CHANGE_SYNC_DONE: regenerable artifact map created for clean regeneration workflow.
SUPPORT_MATRIX_SYNC_NOT_REQUIRED: this map does not change support claims; it maps artifact classes and regeneration routes.

## Artifact Classes

| class | examples | tracked | clean action | regeneration source |
|---|---|---:|---|---|
| `TRACKED_SOURCE` | `qresid/qresid.ado`, `qresid/qresid.sthlp`, tests, examples, certification scripts, normative docs | yes | keep | git |
| `TRACKED_GENERATED_CANONICAL` | `qresid/certification/reports/qresid_glm_link_matrix.html`, `qresid/certification/reports/qresid_support_evidence_index.csv`, active root HTML matrices | yes | keep unless generator is being tested directly | listed below |
| `IGNORED_REGENERABLE` | root `*.log`, `qresid/tests/logs/`, `qresid/certification/logs/`, `qresid/examples/logs/`, MCP execution/temp logs | no | archive then delete | tests, certification, R checkers |
| `EXTERNAL_PINNED_SOURCE` | `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/STATA/hurdle_count_hilbe_hardin`, `st0279` retrieval clone/source | mixed/ignored by policy | keep | source log and external repo manifest |
| `ORPHAN_CLEANUP_CANDIDATE` | root probe logs such as `probe_*.log`, `qresid_trace_*.log`, `benchmark_*_stata.log` | no | archive then delete | rerun probes only if needed |

## Versioned Report Regeneration

| artifact | regeneration status | command or source | clean-run rule |
|---|---|---|---|
| `qresid/certification/reports/qresid_support_evidence_index.csv` | `REGENERATOR_CLOSED` | `Rscript qresid/tests/build_support_evidence_index.R` | regenerate after benchmark logs/CSVs exist |
| `qresid/certification/reports/qresid_glm_link_matrix.html` | `REGENERATOR_CLOSED` | `Rscript qresid/tests/benchmark_glm_link_matrix_r.R <latest_glm_link_matrix.csv>` | preserve tracked file until latest CSV is recreated |
| `03_REPO_REVIEW/qresid_current_feature_support_matrix.html` | `REGENERATOR_GAP` | current tracked canonical view, consistency checked | preserve; do not delete in clean run |
| `03_REPO_REVIEW/qresid_unified_extension_matrix.html` | `REGENERATOR_GAP` | current tracked canonical view, consistency checked | preserve; do not delete in clean run |
| `04_RETRIEVAL_CONTEXT/qresid_support_status_glossary.html` | `REGENERATOR_GAP` | current tracked canonical view, consistency checked | preserve; do not delete in clean run |
| `03_REPO_REVIEW/qresid_math_software_evidence_matrix.html` | `REGENERATOR_GAP` | current tracked canonical view, consistency checked | preserve; do not delete in clean run |
| `03_REPO_REVIEW/qresid_r_cdf_replay_theory_audit.html` | `REGENERATOR_GAP` | current tracked canonical view, consistency checked | preserve; do not delete in clean run |
| `03_REPO_REVIEW/qresid_estimator_equivalence_audit.html` | `REGENERATOR_GAP` | current tracked canonical view, consistency checked | preserve; do not delete in clean run |
| `03_REPO_REVIEW/qresid_genpoisson_hurdle_release_decision.html` | `REGENERATOR_GAP` | current tracked canonical view, consistency checked | preserve; do not delete in clean run |
| `03_REPO_REVIEW/qresid_hurdle_count_postestimation_extraction_audit.html` | `REGENERATOR_GAP` | current tracked canonical view, consistency checked | preserve; do not delete in clean run |
| `03_REPO_REVIEW/qresid_hurdle_stata_ado_pinning_audit.html` | `REGENERATOR_GAP` | current tracked canonical view, consistency checked | preserve; do not delete in clean run |
| `docs/qresid-web/_site/` | `IGNORED_REGENERABLE` | `quarto render docs/qresid-web` | may delete/regenerate; source `.qmd` files are tracked |
| `docs/qresid-web/assets/output/*.txt` | `TRACKED_GENERATED_CANONICAL` | `StataSE-64.exe /e do docs/qresid-web/assets/stata/qresid_web_examples.do` | keep; regenerate when teaching examples change |
| `docs/qresid-web/assets/img/*.png` | `TRACKED_GENERATED_CANONICAL` | `StataSE-64.exe /e do docs/qresid-web/assets/stata/qresid_web_examples.do` | keep; regenerate when teaching examples change |
| `docs/qresid-web/assets/stata/qresid_web_examples.do` | `TRACKED_SOURCE` | source script for website Stata outputs and figures | keep |

## Ignored Regenerables To Archive

Archive before deletion:

- root `*.log`;
- `qresid/tests/logs/`;
- `qresid/certification/logs/`;
- `qresid/examples/logs/`;
- `05_MCP_STATA_EXECUTION/logs/`;
- `05_MCP_STATA_EXECUTION/STATA_EXECUTION_LOGS/`;
- `05_MCP_STATA_EXECUTION/R_EXECUTION_LOGS/`;
- `05_MCP_STATA_EXECUTION/TEMP_BENCHMARK_OUTPUTS/`;
- transient R/Python/Stata caches if present.

Archive destination:

- `05_MCP_STATA_EXECUTION/archives/regenerables_<timestamp>.zip`

The archive directory is ignored by git and is not package payload.

## Clean Run Order

1. `qresid/tests/run_all_tests.do`
2. `qresid/tests/hardening_smoke.do`
3. `qresid/certification/certify_phase1.do`
4. Required R checkers for the new CSVs/logs.
5. `Rscript qresid/tests/build_support_evidence_index.R`
6. `Rscript qresid/tests/check_support_report_consistency.R`

## Open Hygiene Items

| item | severity | action |
|---|---|---|
| Root ignored logs are visually noisy | `LOW_HYGIENE` | archive and delete in clean regeneration |
| Several tracked HTML views lack a centralized generator | `SHOULD_FIX_BEFORE_PUBLIC_RC` | build a future root report generator; do not block clean test |
| External retrieval clones are large and ignored | `EXPECTED` | preserve; source manifests and pinning audits govern use |
