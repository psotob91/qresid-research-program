Lifecycle: retrieval
Status: ACTIVE
Authority: normative/local
Superseded by: NONE
Retrieval policy: load before substantial qresid Quarto website revisions

# QRESID_GGEFFECTS_WEB_STYLE_MASTER.md

Date: 2026-05-10

POST_CHANGE_SYNC_DONE: created after pinning `strengejacke/ggeffects` as a website style reference.

## Purpose

This master captures reusable style lessons from the `ggeffects` website and source. It is a teaching/style reference only; do not copy prose, examples, or assets verbatim.

## Five-Pass Style Audit

| pass | observed pattern | qresid rule |
|---|---|---|
| 1 navigation | Short top navigation with Home, articles/reference/news style destinations. | Add `News` and `Reference`; keep model pages grouped by user task, not by internal benchmark file. |
| 2 landing page | Starts with a plain-language value proposition, then a compact workflow. | Home must explain the one diagnostic framework: fit, `qresid`, plot, interpret. |
| 3 reference structure | Reference pages separate function/API details from tutorials. | Keep support matrices, help links, benchmark evidence, and citations on `Reference`, not scattered across tutorial pages. |
| 4 examples | Teaching examples show code, output, plot, and a short interpretation. | Every major page needs Stata command block, representative output, at least one graph, and an interpretation paragraph. |
| 5 status/news | Changelog/news is findable from the navbar. | Add `News` page sourced from `qresid/changelog/CHANGELOG.md` in summarized, human-readable form. |

## Content Rhythm

Each tutorial page should use this order:

1. What diagnostic question this page answers.
2. Minimal Stata fit.
3. `qresid` command.
4. Model output excerpt.
5. QQ-normal graph.
6. Residual-vs-fitted or residual-vs-covariate graph when meaningful.
7. Interpretation: what would look good, what would warn the user, and what model comparison to try next.

## Visual Rules

- Use clear section headings and short paragraphs.
- Use one highlighted callout per page at most.
- Prefer real Stata output snippets and exported Stata graphs over decorative images.
- Do not use the website to make stronger support claims than the help, support matrix, or benchmark reports.
