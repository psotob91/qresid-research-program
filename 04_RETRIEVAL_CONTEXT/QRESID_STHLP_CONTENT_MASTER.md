# QRESID_STHLP_CONTENT_MASTER.md

## Purpose

This file defines the scientific and instructional content standard for `qresid.sthlp`. It tells Codex what the help file must explain, how deeply to explain it, what scientific claims require support, and what examples should be included. It complements `QRESID_STHLP_FORMAT_MASTER.md`.

## Core content objective

The help file must make `qresid` understandable to three audiences:

1. Stata users who want to run the command correctly;
2. applied statisticians who need to understand what a randomized quantile residual is;
3. reviewers or maintainers who need confidence that the command is mathematically grounded and not an undocumented black box.

The help file should be concise enough to feel like official Stata documentation, but complete enough to explain the statistical construction, assumptions, supported models, diagnostics, and limitations.

## Package identity

`qresid` computes quantile residuals and randomized quantile residuals after supported Stata estimation commands.

A quantile residual maps the observed outcome through the fitted conditional cumulative distribution function (CDF), obtaining a probability-scale value, and then maps that value to the standard normal scale using the inverse standard normal CDF.

For continuous outcomes, this is a direct probability integral transform. For discrete outcomes, the fitted CDF has jumps, so `qresid` uses the Dunn-Smyth randomized construction by drawing or accepting a uniform value inside the CDF interval for the observed response.

The generated residual is already on the normal quantile scale. It is not a raw response residual, Pearson residual, deviance residual, or automatically studentized residual.

## Required scientific concepts

### 1. Probability integral transform

Explain that if `Y_i` has conditional distribution `F_i` and the model is correct, then `F_i(Y_i)` is uniform on `(0,1)` for continuous outcomes. Applying the inverse normal CDF gives a residual with standard normal distribution under the ideal model.

Use careful wording: with estimated parameters, the CDF is a plug-in fitted CDF. Therefore finite-sample residuals are not exactly independent standard normal variables.

### 2. Randomization for discrete outcomes

Explain that for discrete outcomes, `F_i(Y_i)` is not continuously uniform because the CDF has jumps. The Dunn-Smyth construction samples from the interval:

`[F_i(y_i -), F_i(y_i)]`

then applies the inverse normal transformation.

Emphasize that randomization is not an arbitrary noise addition; it is the mathematical device that restores a continuous PIT under a discrete fitted distribution.

### 3. Plug-in fitted CDF

Explain that `qresid` uses estimated model parameters from the preceding Stata estimation command. This means `F_i` is evaluated at parameter estimates rather than unknown true parameters.

Consequences:

- residuals share the same estimated model;
- exact independence is not expected in finite samples;
- leverage or studentization adjustments are not universally defined for all supported models;
- diagnostics should be interpreted as model-checking tools, not formal proof of correctness.

### 4. Difference from Pearson and deviance residuals

Briefly state:

- Pearson residuals standardize `y - mu` by the model variance;
- deviance residuals are based on likelihood deviance contributions;
- quantile residuals instead use the full fitted conditional distribution;
- this is especially useful for discrete, skewed, or non-Gaussian outcomes where conventional residuals may have strong nonnormality even under correct specification.

Do not claim that quantile residuals dominate all other residuals in every setting.

### 5. Diagnostic use

Explain that a well-specified model should tend to produce residuals that are approximately standard normal, with no strong systematic pattern against fitted values or key covariates.

Recommended basic checks:

- normal Q-Q plot using `qnorm`;
- histogram with normal overlay;
- residual versus fitted mean or linear predictor;
- residual versus important covariates;
- checks for outlying or influential observations when appropriate.

Interpretation must be cautious. A pattern may reflect misspecified mean structure, wrong family, overdispersion, zero inflation, dependence, omitted nonlinear terms, influential observations, or limitations of the fitted model.

## Required content sections

### Syntax

Must show the command call and all implemented options. Do not include unsupported options. If the current `.ado` contains options whose behavior is experimental, the help file must say so.

### Description

Must include:

- what `qresid` does;
- continuous and discrete construction;
- normal-score scale;
- current scope;
- reproducibility implications of randomized residuals.

### Options

Each option must be explained with the following minimum content:

#### `seed(integer)`

Explain:

- sets Stata's RNG seed before randomization;
- affects only residuals requiring random draws;
- useful for reproducible analysis;
- not needed for continuous residuals unless the implementation uses randomization for a given route.

#### `uvar(varname)`

Explain:

- supplies externally generated uniform values;
- intended for exact benchmarking, reproducibility audits, and cross-software comparisons;
- must be in `[0,1]` for observations used;
- should be independent of the outcome conditional on the fitted model if used analytically;
- overrides internal random draws where applicable.

#### `savev(name)`

Explain:

- saves the uniform variate used within the CDF interval for discrete residuals;
- useful for audit trails and benchmark reproduction;
- if the route is continuous, clarify whether missing, unused, or equal to the PIT depending on actual implementation.

#### `saveflo(name)`

Explain:

- saves the lower CDF endpoint `F_i(y_i -)`;
- for discrete outcomes this is the left endpoint of the jump;
- for continuous outcomes it may not differ conceptually from the upper endpoint or may be unused, depending on implementation.

#### `savefhi(name)`

Explain:

- saves the upper CDF endpoint `F_i(y_i)`;
- for discrete outcomes this is the right endpoint of the jump.

#### `saveu(name)`

Explain:

- saves the final PIT value used before applying `invnormal()`;
- for continuous outcomes this is usually the fitted CDF at the observed value;
- for discrete outcomes this is the randomized value inside the CDF interval.

#### `type(string)`

Explain only implemented types.

If `type(quantile)` is the default, state that it creates the Dunn-Smyth normal-score quantile residual.

If `type(adjusted)` or studentized/leverage-adjusted forms are present in the draft, Codex must verify implementation and theory before documenting. If not fully supported, remove or downgrade the text. Do not claim a universal validated adjustment unless the code and source masters justify it.

#### `dispersion(#)`

Explain only if implemented. State which families use it. Clarify whether it is a fixed scale/dispersion supplied by the user or an override for a stored model parameter.

#### `family(string)`

Explain only if implemented. State whether it is needed for commands whose family cannot be inferred from stored estimation results.

## Supported models content

The help file must not rely on marketing-style lists. It must tie support to actual estimation-command routes.

For each supported model, include:

- Stata command(s);
- distribution/family;
- outcome type;
- residual construction: continuous or randomized discrete;
- relevant restrictions.

Recommended model groups:

1. Gaussian continuous models;
2. Bernoulli/binomial models;
3. Poisson count models;
4. negative binomial count models;
5. Gamma GLM;
6. inverse Gaussian GLM;
7. zero-inflated, hurdle, truncated, censored, generalized Poisson routes only if implemented and tested.

If the existing draft claims broad prerelease support, Codex must verify against `qresid.ado`, tests, certification files, and project masters before retaining those claims.

## Examples content requirements

Examples must be runnable and instructive. Each model class implemented should have a minimal example.

### Example 1: Gaussian model

Include:

- `sysuse auto, clear`
- `regress` or implemented Gaussian route
- `qresid`
- `qnorm`
- `histogram ..., normal`

### Example 2: Poisson count model

Include:

- official Stata example data if possible;
- `poisson` or `glm, family(poisson)` depending on supported route;
- `qresid ..., seed()` for reproducibility;
- Q-Q plot and residual-vs-fitted plot.

### Example 3: Bernoulli/binomial model

Include:

- `logit`, `logistic`, `probit`, or `glm, family(binomial)` only if supported;
- show randomization if outcome is discrete;
- show `seed()`.

### Example 4: Negative binomial model

Include:

- `nbreg` route only if supported;
- residual generation;
- diagnostic graph.

### Example 5: GLM Gamma or inverse Gaussian

Include only if implemented and tested. Use official Stata example datasets if possible.

### Example 6: External ado route

Include only if there is a real implemented route for an external ado. The example must include installation code, for example:

```stata
. ssc install commandname
```

Do not include speculative external examples.

### Example 7: Saved endpoints and benchmarking

Include a compact reproducibility example showing `seed()`, `saveflo()`, `savefhi()`, `saveu()`, and `savev()` if these options are implemented.

This helps users understand how `qresid` constructs residuals and how to audit results.

## Methods and formulas content

The section must include the following formulas in readable SMCL text.

### Continuous outcome

For continuous outcomes:

`r_i = Phi^{-1}( F_i(y_i; theta_hat) )`

Explain each term.

### Discrete outcome

For discrete outcomes:

`u_i ~ Uniform( F_i(y_i -; theta_hat), F_i(y_i; theta_hat) )`

`r_i = Phi^{-1}(u_i)`

Explain lower and upper CDF endpoints.

### Endpoint handling

If the ado clips probabilities away from 0 and 1 before calling `invnormal()`, document it exactly and explain that it avoids infinite residuals caused by numerical endpoints. If the ado does not clip, do not claim it does.

### Estimated parameters

Explain that `theta_hat` comes from the previous fitted model. The help should explicitly warn that the ideal standard-normal property is exact for the true CDF but only approximate when using estimated parameters.

### Weights, offsets, and exposure

Document only actual behavior.

If the command inherits fitted means/CDF parameters from the estimation command, state whether offset/exposure is already included through stored predictions or whether `qresid` recomputes it.

For weights:

- distinguish `fweight`, `aweight`, `pweight`, and `svy` support;
- do not imply survey design residual validity unless specifically implemented and tested;
- if pweight support is experimental, say so clearly or omit from main support table.

## Limitations content

Include a serious limitations section. Required points:

- model support is command-specific;
- randomized residuals depend on the RNG unless `seed()` or `uvar()` is used;
- finite-sample exact normality is not guaranteed with estimated parameters;
- observations with extreme fitted probabilities may produce large residuals;
- dependence, clustering, panel structure, and random effects require additional care;
- unsupported models should not be forced through undocumented routes;
- diagnostic plots are model-checking tools, not definitive hypothesis tests.

If studentized or adjusted residuals are not fully theoretically supported across all families, state that universal studentization is not provided or is limited.

## Reference requirements

All scientific claims must be supported by references from project source files or verified sources. The minimum expected reference set normally includes:

- Dunn and Smyth (1996) for randomized quantile residuals;
- core GLM reference, if already in the project sources;
- Stata documentation references only where needed for command behavior;
- R package references only where comparisons are discussed and source-supported.

Do not invent article titles, page ranges, DOIs, or package citations. If a reference is not available in project sources, mark it for source verification rather than fabricating it.

## Content audit against current draft

The current draft contains useful content but must be audited before finalization.

Codex must check:

1. whether every option in the draft is implemented;
2. whether `type(adjusted)` is truly validated and documented in code/tests;
3. whether the broad prerelease model list matches actual tested support;
4. whether direct `fweight` and `pweight` support are real and tested;
5. whether zero-inflated, truncated, censored, generalized Poisson, and hurdle routes are implemented or only planned;
6. whether all saved variables are generated with the names and scales described;
7. whether Stata version compatibility affects syntax or SMCL features;
8. whether examples run under the target minimum supported Stata version.

## Scientific writing standard

Use polished academic prose, but not journal-article verbosity. The help should be direct and confident where the method is established, and cautious where implementation or theory is limited.

Good style:

- “For continuous outcomes, the fitted CDF directly defines the PIT value.”
- “For discrete outcomes, the CDF interval has positive width, and randomization within that interval gives the Dunn-Smyth residual.”
- “The residual is on the standard normal quantile scale.”
- “When parameters are estimated, this distributional statement is approximate.”

Bad style:

- “This command magically normalizes all residuals.”
- “This option fixes leverage.”
- “The residuals are guaranteed to be independent.”
- “This is fully validated for all models” unless the certification suite proves that exact scope.

## Final content checklist

Before finalizing `qresid.sthlp`, verify:

- all scientific definitions are correct;
- formulas match Dunn-Smyth residual construction;
- model support table matches implementation;
- examples run cleanly;
- every graph example uses official Stata commands unless an external dependency is explicitly installed;
- all options are documented once in the syntax table and explained in Options;
- all limitations are honest and visible;
- references are real and source-supported;
- the help file is useful both for new users and statistical reviewers.
