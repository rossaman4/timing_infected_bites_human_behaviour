

*********************** FIGURE 3 *****************************

* change sub-directory
* cd "your subdir"

use 3humanbehaviour.dta, clear



*** Hourly proportion of time spent under ITNs out of the time spent outdoors and indoors

****reshaping data to make it amenable to modelling approach

rename outdoors halfhrs1
rename inoutofbed halfhrs2 
rename inbednonet halfhrs3 
rename inbedinnet halfhrs4


reshape long halfhrs, i(hh_id seqhr halfhrs_per_hr clusterno agecode) j(location) 


***Under 6s (pre-schoolage)
gen estp_itnu6 = .
gen estp_itnu6_ll = .
gen estp_itnu6_ul = .
gen hourcat = .

svyset hh_id [pweight=halfhrs]
levelsof seqhr, local(i)
foreach i in 1 2 3 4 5 6 7 8 9 10 11 12 {
   quietly svy: proportion location if seqhr == `i' & agecode==0
   scalar inbedinnet = r(table)[1,4]*100
   scalar inbedinnet_ll = r(table)[5,4]*100
   scalar inbedinnet_ul = r(table)[6,4]*100
   
   quietly replace estp_itnu6 = inbedinnet if _n == `i'
   quietly replace estp_itnu6_ll = inbedinnet_ll if _n == `i'
   quietly replace estp_itnu6_ul = inbedinnet_ul if _n == `i'
   
   replace hourcat = `i' if _n ==`i'
   local i = `i'+1
 }


*** older members
gen estp_itno6 = .
gen estp_itno6_ll = .
gen estp_itno6_ul = .

svyset hh_id [pweight=halfhrs]
levelsof seqhr, local(i)
foreach i in 1 2 3 4 5 6 7 8 9 10 11 12 {
   quietly svy: proportion location if seqhr == `i' & agecode==1
   *matrix list r(table)
   scalar inbedinnet = r(table)[1,4]*100
   scalar inbedinnet_ll = r(table)[5,4]*100
   scalar inbedinnet_ul = r(table)[6,4]*100

   quietly replace estp_itno6 = inbedinnet if _n == `i'
   quietly replace estp_itno6_ll = inbedinnet_ll if _n == `i'
   quietly replace estp_itno6_ul = inbedinnet_ul if _n == `i'
   local i = `i'+1
 }

 
 
gen hourcatplus = hourcat + 0.2
 
grstyle init
 * graph style commands
grstyle set horizontal
* set tick lanels horizontal
grstyle set plain, nogrid
grstyle set symbolsize small


twoway (scatter estp_itnu6 hourcat, color("cranberry")) (rcap estp_itnu6_ll estp_itnu6_ul hourcat, color("cranberry")) /*
*/     (scatter estp_itno6 hourcatplus, color("ebblue")) (rcap estp_itno6_ll estp_itno6_ul hourcatplus, color("ebblue")),/* */      ytitle("percentage") legend(off) xtitle("") xlabel(1 "6-7pm" 2 "7-8pm" 3 "8-9pm" 4 "9-10pm" 5 "10-11pm" 6 "11-12am" /* 
*/                                                 7 "12-1am" 8 "1-2am" 9 "2-3am" 10 "3-4am" 11 "4-5am" 12 "5-6am", labsize(small))
 
  
 grstyle clear
 
 graph export fig3.png, width(1000) height(700) replace