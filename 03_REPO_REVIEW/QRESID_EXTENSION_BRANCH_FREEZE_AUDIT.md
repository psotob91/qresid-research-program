Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before continuing NB, weights or grouped-binomial extension work

# QRESID_EXTENSION_BRANCH_FREEZE_AUDIT.md

Date: 2026-05-10

Branch: `dev-qresid-nb-weights-grouped-binomial`

Status source: root pre-freeze `b91e964`; qresid subrepo `388e595`.

POST_CHANGE_SYNC_DONE: registry updated for this freeze audit.

## 1. Decision

`EXPERIMENTAL_RESEARCH_FREEZE_READY`

This freeze preserves the experimental research branch as a documentation and gatekeeping checkpoint. It does not authorize implementation of NB, weights, grouped binomial, new links or new CDF logic.

## 2. Branch State

| repository | branch | commit | status |
|---|---|---|---|
| root `qresid-research-program/` | `dev-qresid-nb-weights-grouped-binomial` | `b91e964` before freeze commit | documentation changes pending |
| subrepo `qresid/` | `dev-qresid-nb-weights-grouped-binomial` | `388e595` | clean; no implementation changes |

Existing prerelease tags remain unchanged:

- root: `qresid-v0.1.0-prerelease.2`
- qresid: `v0.1.0-prerelease.2`

The freeze tag for this branch is:

- root: `qresid-extension-research-freeze.1`

No tag is created in `qresid/` because the subrepo has no new changes.

## 3. Files Included In Freeze

The freeze covers only active research and lifecycle documentation:

- `03_REPO_REVIEW/NB_PARAMETRIZATION_RESEARCH.md`
- `03_REPO_REVIEW/NB_BENCHMARK_FEASIBILITY_MATRIX.md`
- `03_REPO_REVIEW/WEIGHTS_SEMANTICS_RESEARCH.md`
- `03_REPO_REVIEW/WEIGHTS_IMPLEMENTATION_MATRIX.md`
- `03_REPO_REVIEW/GROUPED_BINOMIAL_RESEARCH.md`
- `03_REPO_REVIEW/GROUPED_BINOMIAL_LINK_MATRIX.md`
- `04_RETRIEVAL_CONTEXT/DOCUMENT_STATUS_REGISTRY.md`
- `03_REPO_REVIEW/QRESID_EXTENSION_BRANCH_FREEZE_AUDIT.md`

No historical snapshots, pre-MCP reports, public package files, tests, examples, certification scripts or logs are updated by this freeze.

## 4. Gates Preserved

| area | implementation_allowed | benchmark_allowed | frozen conclusion |
|---|---|---|---|
| NB | no | yes | `nbreg, dispersion(mean)` unweighted is benchmark candidate only. |
| Weights | no | yes | No global weighted RQR rule; family x weight-type evidence required. |
| Grouped binomial | no | yes | `glm, family(binomial trials)` is benchmark candidate only. |

## 5. Normative Reconciliation

The freeze is aligned with:

- `AGENTS.md`: no support claim without tests and benchmarks.
- `09_STATA_PACKAGE_ARCHITECTURE_MASTER.md`: NB, weights and grouped binomial remain gated until evidence closes.
- `10_AGENT_RULES_FOR_QRESID.md`: no code change where CDF, parameterization or extraction evidence remains pending.
- `DOCUMENT_LIFECYCLE_RULES.md`: active research reports are registered; historical snapshots are not rewritten.
- `POST_CHANGE_DOCUMENTATION_SYNC.md`: lifecycle registry updated; no readiness or certification status upgraded.

## 6. Validation Notes

Pre-freeze validation:

- root branch confirmed: `dev-qresid-nb-weights-grouped-binomial`;
- subrepo branch confirmed: `dev-qresid-nb-weights-grouped-binomial`;
- `qresid/` status clean;
- `git -C qresid diff -- qresid.ado` empty;
- `IMPLEMENTATION_ALLOWED: no` and `BENCHMARK_ALLOWED: yes` confirmed for NB, weights and grouped binomial reports;
- no new Stata/R tests or benchmarks executed for this freeze.

## 7. Next Safe Step

Start a separate benchmark cycle from this freeze. The first recommended cycle is grouped binomial unweighted, because it is closest to current Bernoulli/binomial support. Do not touch `qresid.ado` until benchmark evidence changes the relevant implementation gate from `no` to `yes`.
