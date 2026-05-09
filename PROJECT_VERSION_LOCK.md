# PROJECT_VERSION_LOCK.md

## Freeze

- freeze_date: 2026-05-10
- workspace_root: `C:/qresid-research-program`
- root_remote: `https://github.com/psotob91/qresid-research-program.git`
- root_branch: `main`
- purpose: Freeze the research-program context without vendoring nested Git repositories.

## Root Repository Policy

- `qresid/` is tracked as a Git submodule, not copied into the root repository.
- External repositories under `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/{R,STATA}/` are local retrieval caches and are not tracked by this root repository.
- External repository states are recorded here and in `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/*.md`.
- `mermaid-diagram.png` is treated as a generated artifact and is not tracked.
- No external code is copied into `qresid/`.

## qresid Submodule

| field | value |
|---|---|
| path | `qresid` |
| remote | `https://github.com/psotob91/qresid.git` |
| branch_at_freeze | `dev-qresid-v2` |
| commit_at_freeze | `785732f437e6a1112397dd62ab759d2997fdb541` |

Untracked files present inside `qresid/` at freeze time:

- `certification/certify_phase1.do`
- `changelog/`
- `tests/run_all_tests.do`

These untracked files are not frozen by the root repository. Commit them inside the `qresid` repository if they should become part of the package history.

## External Repository Snapshot

| repo_name | branch | commit | remote |
|---|---|---|---|
| `binsreg` | `master` | `ae13048ac66842c6d2f750cab8923220fd2bf212` | `https://github.com/nppackages/binsreg.git` |
| `boottest` | `master` | `76b4e9ff5e6773d5bb11680083c40d57269228a6` | `https://github.com/droodman/boottest.git` |
| `coefplot` | `master` | `60b9ae5dfae968b2998652a5acfe1c59c97ee094` | `https://github.com/benjann/coefplot.git` |
| `DHARMa` | `master` | `953f0eca0c70c838cf7b6e78b758cbec5cff412e` | `https://github.com/florianhartig/DHARMa.git` |
| `estout` | `master` | `2c6beb2df405a1aa8940e0432a4a53810eca8e60` | `https://github.com/benjann/estout.git` |
| `ftools` | `master` | `7b3663e49ea5c5b81638c55be29edf416e68e8b7` | `https://github.com/sergiocorreia/ftools.git` |
| `gamlss` | `main` | `be6fe0c6918d05709e14e60ac419a1a2a3bc47ee` | `https://github.com/gamlss-dev/gamlss.git` |
| `glmmTMB` | `master` | `2b4d87fe259d82a9ce34a963fc330a0b37c2fbd0` | `https://github.com/glmmTMB/glmmTMB.git` |
| `gtools` | `master` | `f8e303d90be1ac7fb469b9ed7caf202957139b69` | `https://github.com/mcaceresb/stata-gtools.git` |
| `moremata` | `master` | `f2c06a4b9473fc91f89fc90956036101ed333d37` | `https://github.com/benjann/moremata.git` |
| `reghdfe` | `master` | `4c1744df2c3bc474d0ee7ee5efa1bb54760067e5` | `https://github.com/sergiocorreia/reghdfe.git` |
| `statmod` | `master` | `f4ad49172e29d07dccb5d5ed901a8b82da34b910` | `https://github.com/cran/statmod.git` |
| `VGAM` | `master` | `2c0cbb3623638c6a2832ff797b78400b0d322938` | `https://github.com/cran/VGAM.git` |

## Pending External Source

| repo_name | status | note |
|---|---|---|
| `topmodels` | `PENDING_SOURCE_TOOLING` | No canonical GitHub repository was verified; retrieve later only through verified R-Forge/SVN source when SVN tooling is available. |

## Rehydration Notes

1. Clone the root repository.
2. Initialize the `qresid` submodule with `git submodule update --init qresid`.
3. Recreate external retrieval caches only when needed, using the remotes and commits listed above.
4. Treat external caches as read-only context; do not copy their code into `qresid/`.
