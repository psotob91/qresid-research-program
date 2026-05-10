Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before public documentation or release decisions

# CURRENT_HELP_README_DOC_AUDIT.md

Date: 2026-05-10

Status source: hardening iteration evidence after documentation/examples update.

## 1. Status

Documentation status: `ALIGNED_FOR_LOCAL_PRERELEASE`

The public help and README are aligned with the current tested support surface:
Gaussian, Poisson, Bernoulli and unweighted Gamma. They do not claim NB,
weights, grouped binomial or Phase 2 support.

## 2. Help Audit

| item | status |
|---|---|
| syntax matches API | pass |
| options documented | pass |
| supported models documented | pass |
| unsupported/gated models documented | pass |
| stale Phase 1B public wording | resolved |
| executable examples available | pass via `examples/*.do` |
| stored results documented | pass |

## 3. README / Package Metadata Audit

| item | status |
|---|---|
| README support claims | aligned with implementation |
| README benchmark notes | aligned with local evidence |
| `qresid.pkg` | installs ado/help only; payload review remains prerelease policy |
| `stata.toc` | brief public description |
| changelog | active under `qresid/changelog/CHANGELOG.md` |
| root `CHANGELOG.md` | not present; non-blocking policy decision |

## 4. Examples

Executable examples now exist:

- `examples/example_gaussian.do`
- `examples/example_poisson.do`
- `examples/example_bernoulli.do`
- `examples/example_gamma.do`
- `examples/run_examples.do`

Latest evidence: `qresid/tests/logs/10_May_2026_114036_hardening_smoke.log`.

## 5. Claims Audit

| claim | result |
|---|---|
| Gaussian | implemented and locally tested |
| Poisson | implemented and locally tested |
| Bernoulli | implemented and locally tested |
| Gamma | implemented and locally benchmarked |
| NB | not claimed |
| weights | not claimed |
| grouped binomial | not claimed |
| ZIP/ZINB/hurdle/truncated/mixed | not claimed |

## 6. Post-Change Sync

POST_CHANGE_SYNC_DONE
