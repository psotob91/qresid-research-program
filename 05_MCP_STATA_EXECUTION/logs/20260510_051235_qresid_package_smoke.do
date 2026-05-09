version 18
capture log close _all
log using "C:/qresid-research-program/05_MCP_STATA_EXECUTION/logs/20260510_051235_qresid_package_smoke.log", text replace
set more off
adopath ++ "C:/qresid-research-program/qresid"
which qresid
findfile qresid.ado
findfile qresid.sthlp
sysuse auto, clear
regress price mpg
capture drop qr_smoke
qresid qr_smoke
describe qr_smoke
summarize qr_smoke
capture noisily qresid qr_seed, seed(123)
display "EXPECTED_API_MISMATCH_RC=" _rc
log close
exit, clear
