Lifecycle: review_snapshot
Status: ACTIVE
Authority: diagnostic
Superseded by: NONE
Retrieval policy: load before asking for next ChatGPT/release-management step

# NEXT_STEPS_RECOMMENDATION_FOR_CHATGPT.md

Date: 2026-05-10

Status source: hardening iteration evidence after local tests, smoke checks, certification and benchmarks.

## 1. Recommended Next Phase

Recommended next phase: `PRERELEASE_PAYLOAD_AND_POLICY_REVIEW`

Do not continue iterating hardening unless new evidence shows a regression.

## 2. Suggested Order

1. Review final package payload: `qresid.pkg`, `stata.toc`, `README.md`, `LICENSE`, `changelog/CHANGELOG.md`.
2. Decide whether a root `CHANGELOG.md` is needed before public release.
3. Confirm clean git state after committing hardening changes.
4. Decide tag/version naming for local prerelease versus public RC.
5. Prepare a prerelease tag only after the maintainer confirms payload policy.

## 3. What Not To Do Yet

- Do not implement NB.
- Do not implement weights.
- Do not implement grouped binomial.
- Do not implement ZIP/ZINB, hurdle, truncados or mixed/GLMM/GSEM.
- Do not broaden the public support claims.
- Do not mark public `RC_READY` until payload/tag policy is decided.

## 4. Recommended Prompt

```text
Actua como release manager SSC/Stata Journal para qresid. Revisa PRERELEASE_READY_LOCAL, decide payload final de qresid.pkg/README/LICENSE/changelog, verifica git status limpio y prepara una estrategia de tag prerelease. No implementes nuevas familias.
```

## 5. Human Decisions Still Pending

- Public payload policy.
- Root changelog policy.
- Public RC/tag threshold.
- Future NB parametrization and benchmark gate.
- Future weights semantics gate.

## 6. Post-Change Sync

POST_CHANGE_SYNC_DONE
