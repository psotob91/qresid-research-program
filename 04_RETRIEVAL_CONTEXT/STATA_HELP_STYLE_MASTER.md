Lifecycle: retrieval
Status: ACTIVE
Authority: normative/local
Superseded by: NONE
Retrieval policy: load before substantial `.sthlp` rewrites

# STATA_HELP_STYLE_MASTER.md

Date: 2026-05-10

POST_CHANGE_SYNC_DONE: created from local `predict`, `regress`, and `glm` help-file inspection.

## Purpose

This master records Stata help-file style patterns to use when rewriting `qresid.sthlp`. It complements `STATA_PACKAGE_STYLE_RULES.md`; it does not override support or API rules.

## Authority and Precedence

For `qresid.sthlp` rewrites, `QRESID_STHLP_FORMAT_MASTER.md` and
`QRESID_STHLP_CONTENT_MASTER.md` are the controlling masters. This document is
supporting evidence from local `predict`, `regress`, and `glm` help-file
inspection. If this document conflicts with either `QRESID_STHLP_*` master, the
`QRESID_STHLP_*` master controls.

## Five-Pass Style Audit

| pass | files inspected | finding | rule for `qresid.sthlp` |
|---|---|---|---|
| 1 structure | `predict.sthlp`, `regress.sthlp`, `glm.sthlp` | Official help starts with `{smcl}`, version comment, `viewerjumpto` links, title block, syntax, description, options, examples, stored results/references when applicable. | Keep `qresid` in this order: Title, Syntax, Description, Options, Supported models, Examples, Stored results, Methods and formulas, Limitations, References, Author. |
| 2 syntax/options | same | Syntax uses compact command blocks and `synopt` tables for longer option lists. Options are short, imperative, and avoid tutorial prose. | Use `synoptset` for options and stored results; keep descriptions concise. |
| 3 examples | same | Examples are executable, grouped by task, and use `{pstd}` narrative followed by `{phang2}{cmd:. ...}` command lines. | Every supported route should have a short example, but advanced/externally dependent routes can be summarized to avoid an oversized help file. |
| 4 visual style | same | SMCL uses `{title:}`, `{marker}`, `{pstd}`, `{phang}`, `{phang2}`, `{p2col}`/`{synopt}`; no decorative colors or long equations in display blocks. | Keep math readable in text; avoid large derivations in `.sthlp`. Put deeper theory in project docs/web. |
| 5 public voice | same | Official Stata prose is direct: what the command does, what options mean, and what examples show. It avoids internal development status except when warning about unsupported options. | Explain “extension-prerelease” as a support label only where necessary; no agent/workflow language in public help. |

## SMCL Patterns To Reuse

| element | preferred pattern |
|---|---|
| Navigation | `{viewerjumpto "Syntax" "qresid##syntax"}{...}` |
| Title line | `{bf:qresid} {hline 2} Quantile and randomized quantile residuals` |
| Paragraph | `{pstd}` for standard prose; `{p 4 4 2}` for compact explanatory text |
| Command example | `{phang2}{cmd:. command ...}{p_end}` |
| Option table | `{synoptset 24 tabbed}` plus `{synopthdr}` and `{synoptline}` |
| Warnings | Put in Limitations, not scattered through examples |
| References | Use compact bibliographic entries, no long abstracts |

## Help Content Boundary

`qresid.sthlp` may include the Dunn-Smyth formulas, a short explanation of PIT, `F_low`, `F_high`, `U`, `V`, and `uvar()`, and one normality graph command. It must not include the full theory gate, reverse-engineering notes, or web manual content.

## External Tooling Note

`markdoc` may be used to prototype or regenerate SMCL from Markdown, especially through its `mini export(sthlp)` path. Any generated `.sthlp` must still be reviewed against this master before commit.
