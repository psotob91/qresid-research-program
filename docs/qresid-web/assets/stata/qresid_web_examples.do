version 18
set more off

local root "C:/qresid-research-program"
local qroot "`root'/qresid"
local web "`root'/docs/qresid-web"
adopath ++ "`qroot'"

capture mkdir "`web'/assets"
capture mkdir "`web'/assets/img"
capture mkdir "`web'/assets/output"

capture log close _all

log using "`web'/assets/output/continuous_gaussian.txt", text replace name(web_cont)
sysuse auto, clear
regress price mpg
qresid qr_gaussian
predict fitted_price, xb
summarize qr_gaussian
qnorm qr_gaussian, name(qnorm_gaussian, replace) title("Gaussian qresid QQ plot")
graph export "`web'/assets/img/continuous_gaussian_qnorm.png", replace width(1200)
scatter qr_gaussian fitted_price, yline(0) name(rvfit_gaussian, replace) title("Gaussian qresid vs fitted")
graph export "`web'/assets/img/continuous_gaussian_fitted.png", replace width(1200)
log close web_cont

log using "`web'/assets/output/count_poisson.txt", text replace name(web_count)
sysuse auto, clear
poisson rep78 mpg if rep78 < .
qresid qr_poisson, seed(20260510)
predict fitted_rep78, n
summarize qr_poisson
qnorm qr_poisson, name(qnorm_poisson, replace) title("Poisson qresid QQ plot")
graph export "`web'/assets/img/count_poisson_qnorm.png", replace width(1200)
scatter qr_poisson fitted_rep78, yline(0) name(rvfit_poisson, replace) title("Poisson qresid vs fitted")
graph export "`web'/assets/img/count_poisson_fitted.png", replace width(1200)
log close web_count

log using "`web'/assets/output/binomial_logit.txt", text replace name(web_binom)
sysuse auto, clear
generate byte foreign01 = foreign
logit foreign01 mpg
qresid qr_logit, seed(20260510) family(bernoulli)
predict fitted_foreign, pr
summarize qr_logit
qnorm qr_logit, name(qnorm_logit, replace) title("Bernoulli qresid QQ plot")
graph export "`web'/assets/img/binomial_logit_qnorm.png", replace width(1200)
scatter qr_logit fitted_foreign, yline(0) name(rvfit_logit, replace) title("Bernoulli qresid vs fitted probability")
graph export "`web'/assets/img/binomial_logit_fitted.png", replace width(1200)
log close web_binom

log using "`web'/assets/output/weights_fweight.txt", text replace name(web_weight)
sysuse auto, clear
generate int fw = 1 + mod(_n, 3)
regress price mpg [fweight=fw]
qresid qr_fweight
summarize qr_fweight
qnorm qr_fweight, name(qnorm_fweight, replace) title("fweight Gaussian qresid QQ plot")
graph export "`web'/assets/img/weights_fweight_qnorm.png", replace width(1200)
log close web_weight

log using "`web'/assets/output/case_lbw.txt", text replace name(web_case)
capture noisily webuse lbw, clear
if _rc {
    clear
    set obs 120
    set seed 20260510
    generate age = 18 + floor(22*runiform())
    generate smoke = runiform() > .65
    generate double xb = -1.2 + .9*smoke - .03*(age - 28)
    generate low = runiform() < invlogit(xb)
}
logit low smoke age
qresid qr_lbw, seed(20260510) family(bernoulli)
predict fitted_lbw, pr
summarize qr_lbw
qnorm qr_lbw, name(qnorm_lbw, replace) title("Low birthweight example qresid QQ plot")
graph export "`web'/assets/img/case_lbw_qnorm.png", replace width(1200)
scatter qr_lbw fitted_lbw, yline(0) name(rvfit_lbw, replace) title("Case study qresid vs fitted probability")
graph export "`web'/assets/img/case_lbw_fitted.png", replace width(1200)
log close web_case

display as result "QRESID_WEB_EXAMPLES_STATUS PASS"
