version 18
log using "C:/qresid-research-program/05_MCP_STATA_EXECUTION/logs/20260510_050408_stata_smoke.log", replace text
set more off
display "STATA_VERSION_START"
display c(version)
display c(stata_version)
display "STATA_VERSION_END"
sysuse auto, clear
count
display "SMOKE_STATUS SMOKE_PASSED"
log close
exit, clear STATA
