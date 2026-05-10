Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before prerelease tag or payload decisions

# QRESID_PRERELEASE_PAYLOAD_DECISION.md

Date: 2026-05-10

Status source: root `16c7f02`, qresid `b236630`, prerelease payload review.

## 1. Decision

Decision: `PRERELEASE_PAYLOAD_MINIMAL_SSC_STYLE`

For local prerelease `v0.1.0-prerelease.1`, keep `qresid.pkg` minimal:

```text
F qresid.ado
f qresid.sthlp
```

README, LICENSE, changelog, examples, tests and certification remain part of
the GitHub/repo payload, not files installed by `net install`.

## 2. Rationale

- `09_STATA_PACKAGE_ARCHITECTURE_MASTER.md` requires `qresid.pkg` to list only public distribution files.
- `STATA_PACKAGE_STYLE_RULES.md` allows examples/tests/certification in the repo while avoiding heavy or internal install payload.
- Current install smoke passed with ado/help-only package metadata.
- No support claims are added beyond tested Gaussian, Poisson, Bernoulli and unweighted Gamma.

## 3. Public Claims

| topic | prerelease decision |
|---|---|
| Gaussian | claimed, locally tested and benchmarked |
| Poisson | claimed, locally tested and benchmarked |
| Bernoulli | claimed, locally tested and benchmarked |
| Gamma | claimed for unweighted `glm, family(gamma)`, locally tested and benchmarked |
| NB | not claimed |
| weights | not claimed |
| grouped binomial | not claimed |
| ZIP/ZINB/hurdle/truncated/mixed | not claimed |

## 4. Remaining Before Public RC

- Decide whether to include README/LICENSE/changelog in public distribution metadata.
- Decide root changelog policy.
- Decide public RC threshold and tag naming.

## 5. Post-Change Sync

POST_CHANGE_SYNC_DONE
