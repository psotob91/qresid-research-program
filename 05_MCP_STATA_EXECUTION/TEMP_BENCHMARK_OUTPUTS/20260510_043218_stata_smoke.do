version 19
log using "C:\qresid-research-program\05_MCP_STATA_EXECUTION\STATA_EXECUTION_LOGS\20260510_043218_stata_smoke.log", text replace
display c(stata_version)
clear
set obs 3
generate double x = _n
summarize x
log close
exit
