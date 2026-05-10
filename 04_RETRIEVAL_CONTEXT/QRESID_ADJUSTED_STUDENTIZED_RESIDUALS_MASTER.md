Lifecycle: retrieval
Status: ACTIVE
Authority: normative/local
Superseded by: NONE
Retrieval policy: load before changing `type(studentized)`, `type(adjusted)`, leverage corrections or residual-scale claims

# QRESID_ADJUSTED_STUDENTIZED_RESIDUALS_MASTER

Date: 2026-05-11

POST_CHANGE_SYNC_DONE: master created after local package/source audit.
SUPPORT_MATRIX_SYNC_DONE: support evidence must be updated when any row below changes.

## Decisions

| route | formula | source | R function / replay | prior.weights role | qresid decision |
|---|---|---|---|---|---|
| `type(quantile)` | `r_i = Phi^{-1}(U_i)` | Dunn and Smyth 1996; `statmod::qresiduals` | `statmod::qresiduals`; manual CDF replay with `uvar()` | affects fitted model/CDF where estimator uses weights | `ALREADY_IMPLEMENTED` |
| `type(studentized)` for unweighted `regress`/tested `glm` families | `r_i^s = r_i / sqrt(1 - h_ii)` | `glmtoolbox::residuals2(..., standardized=TRUE)`; Pierce and Schafer leverage standardization | exact `glmtoolbox` for Gaussian; R CDF replay for discrete/Gamma/IG using exported `U` and `hatvalues(glm)` | weighted route remains gated because `h`, CDF dispersion and trial/frequency meaning must be separated | `READY_FOR_EXTENSION_PRERELEASE` for unweighted `regress`, `glm gaussian`, `glm poisson`, individual `glm binomial`, `glm gamma`, `glm igaussian` |
| `type(adjusted)` for unweighted `glm gamma` and `glm igaussian` | `r_i^{*qu} = r_i^{qu} / sqrt(1 - h_ii)` | Scudilio and Pereira 2020, equations in Section 2.3; arXiv 1710.11172 source | R CDF replay using Stata-exported `U` and R `hatvalues(glm)` | weighted route remains gated | `READY_FOR_EXTENSION_PRERELEASE` only for unweighted Gamma and inverse Gaussian GLM |
| `type(adjusted)` for Gaussian, Poisson, binomial, NB, ZIP/ZINB, truncated, censored, generalized Poisson, hurdle | no accepted route-specific adjusted formula in current evidence | not covered by Scudilio-Pereira implementation gate; `topmodels` and DHARMa do not supply analytic leverage adjustment | none accepted | not applicable | `GATED_RESEARCH` |
| `topmodels::proresiduals` | PIT/quantile residual from predictive distribution | topmodels 0.3-0 source | `proresiduals(type="pit"|"quantile")` | distribution-object dependent | `REFERENCE_ONLY`, not studentized/adjusted evidence |
| `DHARMa::simulateResiduals` / `createDHARMa` | simulated scaled residuals on uniform scale | DHARMa 0.4.7 source | simulation sanity check | simulation-model dependent | `SIMULATION_SANITY_CHECK_ONLY` |

## `prior.weights` Microtest Finding

R `glm(..., weights=w)` stores `w` in `prior.weights`; the IRLS working weights in `object$weights` are not the same object. For integer weights in local microtests, coefficient estimates from weighted GLM match row-expanded data for Gaussian, Poisson, Bernoulli, Gamma and inverse Gaussian within tolerance. This supports using expansion as a semantics check, but it does not by itself authorize weighted `type(studentized)` or `type(adjusted)`.

## Scudilio-Pereira Extraction

Pinned source:

- `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/PAPERS/scudilio_pereira_adjusted_quantile_residual/scudilio_pereira_2017_arxiv_1710.11172.pdf`
- `04_RETRIEVAL_CONTEXT/EXTERNAL_REPOS/PAPERS/scudilio_pereira_adjusted_quantile_residual/source/quant_glm.tex`

Relevant extracted facts:

- The paper explicitly considers continuous responses, emphasizing Gamma and inverse Gaussian regression.
- Standard quantile residual: `r_i^{qu}=Phi^{-1}{F(y_i; mu_hat_i, sigma_hat)}`.
- Adjusted quantile residual: `r_i^{*qu}=r_i^{qu}/sqrt(1-h_hat_ii)`.
- The paper uses the term adjusted to avoid conflict with other standardized quantile residual terminology.
- Scenarios include Gamma with log/inverse links and inverse Gaussian with log/canonical-style inverse-square link.

## Implementation Guardrails

- Do not enable `type(studentized)` for weighted GLM, grouped binomial, NB, zero-inflated, truncated, censored, generalized Poisson or hurdle without a dedicated gate.
- Do not use `topmodels` or DHARMa to justify leverage-adjusted residuals.
- For discrete GLM, exact R comparison must use exported `U` or deterministic `uvar()`; native RNGs must not be compared across R and Stata.
- For Gamma and inverse Gaussian, if `glmtoolbox` CDF differs from qresid/statmod/Stata dispersion conventions, use R CDF replay from exported `U` and document the scope.

## References

- Dunn, P. K., and G. K. Smyth. 1996. Randomized quantile residuals. Journal of Computational and Graphical Statistics 5:236-244.
- Scudilio, J., and G. H. A. Pereira. 2020. Adjusted quantile residual for generalized linear models. Computational Statistics 35:399-421. doi:10.1007/s00180-019-00896-w.
- Vanegas, L. H., Rondon, L. M., and Paula, G. A. `glmtoolbox` 0.1.12 documentation and source.
- Zeileis et al. `topmodels` 0.3-0 source for probabilistic residuals.
- Hartig, F. DHARMa 0.4.7 source for simulated scaled residuals.
