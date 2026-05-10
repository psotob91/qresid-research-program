Lifecycle: retrieval
Status: ACTIVE
Authority: normative/local
Superseded by: NONE
Retrieval policy: load before using external documentation tooling, MarkDoc, GitHub Stata tooling, or Quarto site generation

# QRESID_DOCUMENTATION_TOOLING_MASTER.md

Date: 2026-05-10

POST_CHANGE_SYNC_DONE: created after pinning `haghish/github` and `haghish/markdoc` as external documentation-tooling sources.

## Purpose

This master defines how external documentation tools can support `qresid` without becoming package runtime dependencies or leaking external code into the SSC payload.

## Pinned External Sources

| tool | local path | pinned commit | license evidence | permitted use | prohibited use |
|---|---|---|---|---|---|
| `github` by Haghish | `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/STATA/haghish/github` | `85e5f9aa9dfa5dc656be44f25a9bb0e71717db5b` | `github.pkg` and `make.do` state MIT | Study Stata package GitHub install/build workflows; optionally use in local tooling after explicit install decision | Do not add as `qresid` runtime dependency; do not copy code into `qresid/` |
| `markdoc` by Haghish | `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/STATA/haghish/markdoc` | `d949731ac730a66252a45d3a106500c8f3178225` | `markdoc.pkg`, `markdoc.ado`, and `README.md` state MIT | Prototype documentation from Markdown to SMCL/HTML; study `mini export(sthlp)` | Do not make generated help unreviewed; do not require users to install MarkDoc for `qresid` |
| `ggeffects` website/source | `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/R/ggeffects` | `fa3a1ffb991c0e98601d36ecaaca73b6bfcfe16d` | repository MIT license | Study pkgdown teaching structure, News/Reference organization, examples, and visual rhythm | Do not copy prose/assets verbatim; do not treat as a `qresid` dependency |

## Operating Rules

- External tooling lives under `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/` and is not part of `qresid.pkg`.
- Tooling may generate drafts, but committed public docs must be reviewed for SMCL style, claims, examples, and absence of internal traces.
- If MarkDoc or GitHub commands are installed locally, record version/source in `SOURCE_ACCESS_LOG.md`.
- Do not use third-party tooling to broaden support claims or bypass benchmark gates.
- `ggeffects` may guide site structure, but qresid pages must use qresid data, qresid output, and qresid support labels.

## Quarto Website Policy

The Quarto site is a teaching/manual layer outside the Stata package. It may reference support matrices and examples, but it must not become the authority for supported routes. Authority remains with `AGENTS.md`, `09`, `10`, support matrices, and benchmark audits.
