# QRESID_STHLP_FORMAT_MASTER.md

## Purpose

This file defines the visual, structural, and SMCL-format standard for `qresid.sthlp`. It is the style master for rewriting the Stata help file. It controls layout, indentation, typography, navigation, section order, examples, stored results, and reference formatting. It must be used together with the content master and the project/retrieval masters.

## Non-negotiable rules

1. `qresid.sthlp` must remain a valid Stata SMCL help file.
2. Do not convert the help file into Markdown, HTML, or plain text.
3. Do not include prompts, agent instructions, internal notes, AI language, or development commentary in the final `.sthlp`.
4. Preserve package truth from the ado/tests. Do not document options, models, returned results, or behavior that are not actually implemented and tested.
5. Prefer conservative documentation over impressive documentation.
6. Every documented option must be supported by code or explicitly marked as experimental only if the package itself exposes it that way.
7. Use Stata help-file conventions, not R-vignette conventions.
8. The help file should look like official Stata help: compact, structured, navigable, and typographically disciplined.

## Visual style target

The target style is close to official Stata help files such as `help predict` and `help regress`:

- title line with command name, short dash, and concise description;
- viewer jump links at the top;
- section titles using `{title:...}`;
- major subsections using `{marker ...}` plus `{title:...}` or `{dlgtab:...}` where appropriate;
- option tables with clear command-style syntax at left and short descriptions at right;
- indented paragraphs using Stata paragraph directives;
- horizontal rules and tab-like boxed headings where useful;
- command names in Stata command style;
- variables and arguments in italic;
- mathematical notation written carefully using SMCL text conventions;
- examples separated into readable blocks with short comments.

## Required top matter

Use this structure at the top:

```smcl
{smcl}
{* *! version X.Y.Z DD Mon YYYY}{...}
{viewerjumpto "Syntax" "qresid##syntax"}{...}
{viewerjumpto "Description" "qresid##description"}{...}
{viewerjumpto "Options" "qresid##options"}{...}
{viewerjumpto "Supported models" "qresid##supported"}{...}
{viewerjumpto "Examples" "qresid##examples"}{...}
{viewerjumpto "Stored results" "qresid##results"}{...}
{viewerjumpto "Methods and formulas" "qresid##methods"}{...}
{viewerjumpto "Limitations" "qresid##limitations"}{...}
{viewerjumpto "References" "qresid##references"}{...}
```

Then:

```smcl
{title:Title}

{p 4 4 2}
{bf:qresid} {hline 2} Quantile and randomized quantile residuals after supported Stata estimation commands
```

The title should be informative but not overloaded.

## Section order

Use this exact order unless there is a strong package-specific reason:

1. Title
2. Syntax
3. Description
4. Options
5. Supported models
6. Examples
7. Stored results
8. Methods and formulas
9. Limitations
10. References
11. Also see, if relevant

Each section must start with a marker:

```smcl
{marker syntax}{...}
{title:Syntax}
```

## Syntax section standard

The syntax section must be compact and official-looking. Use command names in `{cmd:}` and arguments in `{it:}`.

Preferred pattern:

```smcl
{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:qresid} {it:newvarname} {ifin}
[{cmd:,} {it:options}]
```

Then add an option table:

```smcl
{synoptset 24 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{cmd:seed(}{it:integer}{cmd:)}}set random-number seed for randomized residuals{p_end}
{synopt:{cmd:uvar(}{it:varname}{cmd:)}}use externally supplied uniform variates{p_end}
...
{synoptline}
```

Use `{synoptset}`, `{synopthdr}`, `{synoptline}`, `{syntab:...}`, and `{synopt:...}` for option tables whenever possible. This gives a look close to official Stata help pages.

## Description section standard

The description should be concise but scientifically complete. It must answer:

- what `qresid` creates;
- what a quantile residual is;
- what randomization does for discrete outcomes;
- what scale the final residual is on;
- how it differs from Pearson/deviance residuals;
- what the current implementation scope is;
- when the user should be cautious.

Use 4 to 7 paragraphs maximum. Each paragraph should be short.

Preferred paragraph indentation:

```smcl
{pstd}
Text...
```

or, when tighter control is needed:

```smcl
{p 4 4 2}
Text...
```

Avoid long dense paragraphs.

## Typography rules

Use SMCL tags consistently:

- command names: `{cmd:qresid}`, `{cmd:glm}`, `{cmd:poisson}`;
- options: `{cmd:seed()}`, `{cmd:uvar()}`, `{cmd:type(quantile)}`;
- variables and placeholders: `{it:newvarname}`, `{it:varname}`, `{it:y_i}`;
- strong emphasis: `{bf:...}` sparingly;
- light emphasis: `{it:...}` for arguments, not for whole paragraphs;
- references to Stata commands: `{helpb regress}`, `{helpb glm}`, `{helpb poisson}` when links are useful;
- references to internal sections: `{help qresid##methods:Methods and formulas}`.

Do not use Markdown bold (`**`) or Markdown code backticks in `.sthlp`.

## Indentation rules

Use standard indentation levels:

- section body: `{pstd}` or `{p 4 4 2}`;
- syntax lines: `{p 8 16 2}`;
- option explanations: `{phang}` or `{p 4 8 2}`;
- examples: `{phang2}` for explanatory bullets only when needed;
- code blocks: `{cmd:. command}` lines with `{p 8 8 2}` or `{phang2}` context.

Avoid ragged mixed indentation. Do not hand-align large blocks with spaces unless SMCL requires it.

## Horizontal rules and boxed tabs

Use `{hline}` through SMCL conventions. Prefer `{synoptline}` for option and stored-result tables. Do not manually draw ASCII horizontal rules.

For major option groups, use:

```smcl
{syntab:Main}
```

For example groups, use section headings rather than excessive rules:

```smcl
{marker examples_poisson}{...}
{dlgtab:Poisson model}
```

or:

```smcl
{title:Examples}
```

followed by paragraph labels.

## Options section standard

The Options section should not merely repeat the syntax table. It should explain each option in short, substantive paragraphs.

Use this style:

```smcl
{marker options}{...}
{title:Options}

{phang}
{cmd:seed(}{it:integer}{cmd:)} sets Stata's random-number seed before drawing the uniform variates used for randomized quantile residuals. This option affects only residuals that require randomization.
```

Each option must include:

1. what it does;
2. when it applies;
3. whether it affects continuous, discrete, or all models;
4. reproducibility implications, when relevant;
5. constraints or failure behavior, when relevant.

If an option creates a variable, state exactly what scale and range it stores.

## Supported models section standard

Use a table-like layout. Document only models that are implemented and tested.

Suggested structure:

```smcl
{marker supported}{...}
{title:Supported models}

{pstd}
The following table summarizes the estimation commands and residual routes supported in this release.

{synoptset 28 tabbed}{...}
{synopthdr:command}
{synoptline}
{synopt:{cmd:regress}}Gaussian linear model; continuous quantile residuals{p_end}
{synopt:{cmd:poisson}}Poisson count model; randomized quantile residuals{p_end}
...
{synoptline}
```

Include columns conceptually even if SMCL is simple:

- Stata command;
- family/distribution;
- outcome type;
- residual construction;
- restrictions.

For unsupported or future models, use a separate paragraph in Limitations, not the supported-model table.

## Examples section standard

Examples must be practical and layered. Use official Stata style with setup comments followed by commands.

Every example should have:

- a short title;
- setup data command;
- estimation command;
- `qresid` command;
- at least one immediate diagnostic use, usually `qnorm`, `kdensity`, `histogram`, or residual-versus-fitted plot;
- short comments explaining what the block demonstrates.

Preferred style:

```smcl
{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto, clear}{p_end}

{pstd}Fit a Gaussian linear model and compute quantile residuals{p_end}
{phang2}{cmd:. regress mpg weight foreign}{p_end}
{phang2}{cmd:. qresid rq}{p_end}
{phang2}{cmd:. qnorm rq}{p_end}
```

Use examples for every model class actually implemented:

- Gaussian / `regress` or equivalent route;
- Poisson;
- Bernoulli / logistic-type route;
- grouped binomial, if implemented;
- negative binomial;
- Gamma GLM, if implemented;
- inverse Gaussian, if implemented;
- zero-inflated count, if implemented;
- hurdle/truncated/censored/pinned routes only if truly implemented and tested.

Include external ado examples only in a separate section:

```smcl
{dlgtab:Using qresid after a user-written command}

{pstd}Install the user-written command if needed{p_end}
{phang2}{cmd:. ssc install commandname}{p_end}
```

Do not instruct installation for a command unless it is actually required by an example and available from a stable source.

## Diagnostic graph examples

Include a basic diagnostic block. Keep it simple:

```smcl
{pstd}Basic diagnostic displays{p_end}
{phang2}{cmd:. qnorm rq}{p_end}
{phang2}{cmd:. histogram rq, normal}{p_end}
{phang2}{cmd:. predict muhat}{p_end}
{phang2}{cmd:. scatter rq muhat, yline(0)}{p_end}
```

If `predict` requires a specific option after a command, use the correct command-specific form.

Do not overstate diagnostic interpretation. Use cautious wording: departures may suggest misspecification, outlying observations, discreteness, dependence, or instability, and should be interpreted with the model and data-generating process in mind.

## Stored results section standard

Use official Stata style:

```smcl
{marker results}{...}
{title:Stored results}

{pstd}
{cmd:qresid} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations used{p_end}
...
```

Only list results actually returned by the ado. Do not guess.

If the command is r-class, say r(). If e-class, say e(). If it does not store results, say so plainly.

## Methods and formulas section standard

This section must be mathematically clear but readable in SMCL. It should include:

1. continuous quantile residual;
2. discrete randomized quantile residual;
3. plug-in fitted CDF;
4. treatment of lower and upper CDF endpoints;
5. endpoint clipping/numerical safeguards if implemented;
6. family-specific CDF definitions or references to Stata functions;
7. limitations of studentization/leverage adjustment if relevant.

Use notation that is readable in Stata help. Example:

```smcl
{pstd}
For a continuous conditional distribution F_i(.), the quantile residual is

{p 8 8 2}
{it:r_i} = Phi^{-1}{c -(} F_i({it:y_i}; {it:theta_hat}) {c )-}.
```

For discrete outcomes:

```smcl
{p 8 8 2}
{it:u_i} ~ Uniform{c -(} F_i({it:y_i}-; {it:theta_hat}), F_i({it:y_i}; {it:theta_hat}) {c )-}
```

Do not overload SMCL with LaTeX. Use plain mathematical notation compatible with Stata help display.

## References section standard

References must be real, relevant, and cited because they support content in the help file. Do not invent references.

Use Stata help style:

```smcl
{marker references}{...}
{title:References}

{phang}
Dunn, P. K., and G. K. Smyth. 1996. Randomized quantile residuals. {it:Journal of Computational and Graphical Statistics} 5: 236-244.
```

Every reference must be checked against the source masters or verified source files. Avoid excessive bibliography. Prefer a concise set of load-bearing references.

## Also see section

Use if useful:

```smcl
{title:Also see}

{psee}
Manual: {manlink R predict}, {manlink R glm}, {manlink R poisson}

{psee}
Help: {helpb predict}, {helpb glm}, {helpb poisson}, {helpb nbreg}
```

Only include links that are directly relevant.

## Voice and editorial style

Use professional scientific prose:

- precise;
- compact;
- careful about assumptions;
- not promotional;
- not vague;
- not AI-like;
- no unsupported claims;
- no inflated language such as “powerful”, “seamless”, “cutting-edge”, “robust” unless technically justified.

Preferred phrases:

- “Under correct specification...”
- “For discrete outcomes...”
- “The randomization removes the discontinuity of the PIT...”
- “Because parameters are estimated, finite-sample residuals are not exactly independent standard normal variables.”
- “This option is intended for reproducibility and benchmarking.”

Avoid phrases:

- “This amazing command...”
- “Simply...” when the concept is not simple;
- “guarantees normality”;
- “fixes model misspecification”;
- “validated” unless there is an explicit test/certification artifact.

## Final validation checklist

Before committing `qresid.sthlp`, verify:

- opens with `help qresid` in Stata;
- no SMCL rendering artifacts;
- all viewer jumps work;
- all examples run from a clean Stata session or are clearly marked as requiring installed commands/data;
- every option documented in help exists in `qresid.ado`;
- every returned result documented is actually stored;
- references are real and source-supported;
- no prompts, AI terms, or internal project notes appear;
- no future unsupported models are presented as current features;
- examples are reproducible and do not depend on private data.
