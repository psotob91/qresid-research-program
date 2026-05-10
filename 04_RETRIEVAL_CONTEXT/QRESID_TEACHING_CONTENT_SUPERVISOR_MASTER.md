Lifecycle: retrieval
Status: ACTIVE
Authority: normative/local
Superseded by: NONE
Retrieval policy: load before expanding the Quarto teaching website or applied examples

# QRESID_TEACHING_CONTENT_SUPERVISOR_MASTER.md

Date: 2026-05-10

POST_CHANGE_SYNC_DONE: created to supervise teaching quality for qresid web/manual content.

## Purpose

The teaching website should help a Stata user learn when quantile residuals reveal model misspecification. It should not become a static list of commands.

## Page Contract

Every applied/model page should include:

| element | requirement |
|---|---|
| Learning goal | One sentence naming the diagnostic question. |
| Data | State whether data are Stata official, package-provided, health/real-like, or simulated. |
| Correct model | Show Stata code and an output excerpt. |
| Incorrect comparison | Include at least one plausible misspecified model when the page teaches model choice. |
| qresid command | Show the exact residual command and any `type()`/`uvar()`/weight option. |
| Graphs | Include QQ-normal; include residual-vs-fitted or residual-vs-covariate when meaningful. |
| Interpretation | Explain what the user should see and what action to take. |
| Evidence link | Link to support matrix or benchmark evidence for non-base routes. |

## Model Comparison Guidance

- Continuous pages should emphasize QQ-normal, residual-vs-fitted, and variance patterns.
- Count pages should compare Poisson, NB, zero-inflated, truncated/censored, generalized Poisson, and hurdle only where support evidence exists.
- Binomial pages should separate Bernoulli and grouped-binomial interpretation.
- Weights pages must distinguish `fweight` support from direct `[pweight=]` diagnostic and gated `aweight`/`iweight`/`svy:`.
- Future/correlated pages must teach what is not claimed and why.

## Review Checklist

- Does the page teach an action, not only show syntax?
- Are outputs and graphs generated from reproducible scripts?
- Is the support status visible and consistent with matrices?
- Is any health/real dataset used respectfully and without unsupported causal claims?
- Would a new Stata user know what to do after seeing a bad QQ plot?
