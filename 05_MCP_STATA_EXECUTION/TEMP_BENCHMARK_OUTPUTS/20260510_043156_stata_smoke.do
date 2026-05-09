version 19
log using "", text replace
display c(stata_version)
clear
set obs 3
generate double x = _n
summarize x
log close
exit
