


* set working directory
* cd 

use "biting_data.dta", clear

*******Total catches of mosquitoes
****arabiensis
sum Angambiae
di r(sum)
****arabiensis
sum Anfunestus
di r(sum)

** total number of villages
by clusterno, sort: gen nvals = _n==1
count if nvals

** total number of houses with catches
drop nvals
by houseid, sort: gen nvals = _n==1
count if nvals

** total number of dates
drop nvals
by day, sort: gen nvals = _n==1
count if nvals




**********CODE FOR TABLE 2 *****************

** biting rates for Table 2 are estimated in biting_getHrlyEsts_table2.r 
* and written to biting_estd_hrly_rates.csv
** numbers of HLC are below



*****indoors (location_code == 0)
gen catch = 1

***************INDOOR HLC**********************************

** Number of HLC collections 
** by hour 
preserve
keep if location_code == 1
tabstat catch, by(seqhr) statistic(sum)
restore

** total 
count if location_code == 1
 


***************OUTDOOR HLC**********************************

** Number of HLC collections 
** by hour 
preserve
keep if location_code == 0
tabstat catch, by(seqhr) statistic(sum)
restore

** total 
count if location_code == 0

   

 
 
 
