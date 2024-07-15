


*set directory
*cd ".."


**** Get numbers of HH and dates
use "3Humanbehaviour.dta", clear


* Number of different households
 by hh_id, sort: gen nvals = _n == 1
 count if nvals
 drop nvals
  
* Number of different dates
* by day, sort: gen nvals = _n == 1
* count if nvals
* drop nvals
  

  
 
 
use "3Humanbehaviour.dta", clear
 
***
*** Number of observations in different locations
*** Altogether for all ages
*** Outdoors (excluding outinnet)
sum outdoors
di r(sum)

*** Indoors
sum indoors
di r(sum)

*** indoors and outdoors altogether (total observations)
preserve
collapse(sum) indoors outdoors
list
di indoors+outdoors
restore





******************** CODE FOR TABLE 5 *****************************


use "3Humanbehaviour.dta", clear

**reshaping data 

rename outdoors halfhrs1 
rename inoutofbed halfhrs2 
rename inbed halfhrs3 

* not using m and seasoncode here
reshape long halfhrs, i(hh_id seqhr clusterno agecode) j(location) 



*******Proportion of time at different locations each hour of the night

***Under 6s (pre-school-age) 

gen outdooru6 = .
gen outdooru6_ll = .
gen outdooru6_ul = .
gen outdooru6_se = .
gen inoutofbedu6 = .
gen inoutofbedu6_ll = .
gen inoutofbedu6_ul = .
gen inoutofbedu6_se = .
gen inbedu6 = .
gen inbedu6_ll = .
gen inbedu6_ul = .
gen inbedu6_se = .

keep if agecode == 0

svyset hh_id [pweight=halfhrs]
svy: proportion location 
levelsof seqhr, local(i)
foreach i in 1 2 3 4 5 6 7 8 9 10 11 12 {
   quietly svy: proportion location if seqhr == `i' 
   *matrix list r(table)
   scalar outdoors = r(table)[1,1]
   scalar outdoors_ll = r(table)[5,1]
   scalar outdoors_ul = r(table)[6,1]
   scalar outdoors_se = r(table)[2,1]
   scalar inoutofbed = r(table)[1,2]
   scalar inoutofbed_ll = r(table)[5,2]
   scalar inoutofbed_ul = r(table)[6,2]
   scalar inoutofbed_se = r(table)[2,2]
   scalar inbed = r(table)[1,3]
   scalar inbed_ll = r(table)[5,3]
   scalar inbed_ul = r(table)[6,3]
   scalar inbed_se = r(table)[2,3]

   quietly replace outdooru6 = outdoors in `i' 
   quietly replace outdooru6_ll = outdoors_ll in `i' 
   quietly replace outdooru6_ul = outdoors_ul in `i' 
   quietly replace outdooru6_se = outdoors_se in `i' 
   quietly replace outdooru6_se = 0 if outdooru6_se==.
      
   quietly replace inoutofbedu6 = inoutofbed in `i'
   quietly replace inoutofbedu6_ll = inoutofbed_ll in `i'
   quietly replace inoutofbedu6_ul = inoutofbed_ul in `i'
   quietly replace inoutofbedu6_se = inoutofbed_se in `i'
   quietly replace inoutofbedu6_se = 0 if inoutofbed_se==.
   
   quietly replace inbedu6 = inbed in `i'
   quietly replace inbedu6_ll = inbed_ll in `i'
   quietly replace inbedu6_ul = inbed_ul in `i'
   quietly replace inbedu6_se = inbed_se in `i'
   quietly replace inbedu6_se = 0 if inbed_se==.
       
   local i = `i'+1
 }
 
 
* save estimates to merge to s_humanBehav.dta
keep outdooru6 outdooru6_ll outdooru6_ul outdooru6_se /*
*/   inoutofbedu6  inoutofbedu6_ll inoutofbedu6_ul inoutofbedu6_se /*
*/   inbedu6 inbedu6_ll inbedu6_ul inbedu6_se 
gen seqhr = _n
drop if _n>12
sort seqhr
save "temp_hum1.dta", replace
 

 
use "3Humanbehaviour.dta", replace

****reshaping data to make it amenable to modelling approach
rename outdoors halfhrs1 
rename inoutofbed halfhrs2 
rename inbednonet halfhrs3
rename inbedinnet halfhrs4

reshape long halfhrs, i(hh_id seqhr clusterno agecode) j(location) 

*******Proportion of time at different locations each hour of the night

gen inbedinnetu6 = .
gen inbedinnetu6_ll = .
gen inbedinnetu6_ul = .
gen inbedinnetu6_se = .

gen inbednonetu6 = .
gen inbednonetu6_ll = .
gen inbednonetu6_ul = .
gen inbednonetu6_se = .


***Under 6s (pre-schoolage) 
keep if agecode == 0

svyset hh_id [pweight=halfhrs]
svy: proportion location 
levelsof seqhr, local(i)
foreach i in 1 2 3 4 5 6 7 8 9 10 11 12 {
   quietly svy: proportion location if seqhr == `i' 
   *matrix list r(table)
   scalar inbedinnet = r(table)[1,4]
   scalar inbedinnet_ll = r(table)[5,4]
   scalar inbedinnet_ul = r(table)[6,4]
   scalar inbedinnet_se = r(table)[2,4]
   
   quietly replace inbedinnetu6 = inbedinnet in `i'
   quietly replace inbedinnetu6_ll = inbedinnet_ll in `i'
   quietly replace inbedinnetu6_ul = inbedinnet_ul in `i'
   quietly replace inbedinnetu6_se = inbedinnet_se in `i'
   quietly replace inbedinnetu6_se = 0 if inbedinnet_se == .
        		
   scalar inbednonet = r(table)[1,3]
   scalar inbednonet_ll = r(table)[5,3]
   scalar inbednonet_ul = r(table)[6,3]
   scalar inbednonet_se = r(table)[2,3]
   
   quietly replace inbednonetu6 = inbednonet in `i'
   quietly replace inbednonetu6_ll = inbednonet_ll in `i'
   quietly replace inbednonetu6_ul = inbednonet_ul in `i'
   quietly replace inbednonetu6_se = inbednonet_se in `i'
   quietly replace inbednonetu6_se = 0 if inbednonet_se==.
        		
   local i = `i'+1
 }
 

 
* save estimates (temp files to merge to human_behaviour_ests.dta)
keep inbedinnetu6 inbedinnetu6_ll inbedinnetu6_ul inbedinnetu6_se inbednonetu6 inbednonetu6_ll inbednonetu6_ul inbednonetu6_se 
gen seqhr = _n
drop if _n>12
sort seqhr
save "temp_hum2.dta", replace



** do same for older HH members

use "3Humanbehaviour.dta", replace

rename outdoors halfhrs1 
rename inoutofbed halfhrs2 
rename inbed halfhrs3 


** took m and ssncode out of here
reshape long halfhrs, i(hh_id seqhr clusterno agecode) j(location) 

*******Proportion of time at different locations each hour of the night

gen outdooro6 = .
gen outdooro6_ll = .
gen outdooro6_ul = .
gen outdooro6_se = .
gen inoutofbedo6 = .
gen inoutofbedo6_ll = .
gen inoutofbedo6_ul = .
gen inoutofbedo6_se = .
gen inbedo6 = .
gen inbedo6_ll = .
gen inbedo6_ul = .
gen inbedo6_se = .


***over 6s
keep if agecode == 1

svyset hh_id [pweight=halfhrs]
svy: proportion location 
levelsof seqhr, local(i)
foreach i in 1 2 3 4 5 6 7 8 9 10 11 12 {
   quietly svy: proportion location if seqhr == `i' 
   *matrix list r(table)
   scalar outdoors = r(table)[1,1]
   scalar outdoors_ll = r(table)[5,1]
   scalar outdoors_ul = r(table)[6,1]
   scalar outdoors_se = r(table)[2,1]
   scalar inoutofbed = r(table)[1,2]
   scalar inoutofbed_ll = r(table)[5,2]
   scalar inoutofbed_ul = r(table)[6,2]
   scalar inoutofbed_se = r(table)[2,2]
   scalar inbed = r(table)[1,3]
   scalar inbed_ll = r(table)[5,3]
   scalar inbed_ul = r(table)[6,3]
   scalar inbed_se = r(table)[2,3]

   
   quietly replace outdooro6 = outdoors in `i' 
   quietly replace outdooro6_ll = outdoors_ll in `i' 
   quietly replace outdooro6_ul = outdoors_ul in `i' 
   quietly replace outdooro6_se = outdoors_se in `i' 
   quietly replace outdooro6_se = 0 if outdoors_se==.
      
   quietly replace inoutofbedo6 = inoutofbed in `i'
   quietly replace inoutofbedo6_ll = inoutofbed_ll in `i'
   quietly replace inoutofbedo6_ul = inoutofbed_ul in `i'
   quietly replace inoutofbedo6_se = inoutofbed_se in `i'
   quietly replace inoutofbedo6_se = 0 if inoutofbed_se==.
   
   quietly replace inbedo6 = inbed in `i'
   quietly replace inbedo6_ll = inbed_ll in `i'
   quietly replace inbedo6_ul = inbed_ul in `i'
   quietly replace inbedo6_se = inbed_se in `i'
   quietly replace inbedo6_se = 0 if inbed_se==.    
       
   local i = `i'+1
 }
 
keep outdooro6 outdooro6_ll outdooro6_ul outdooro6_se /*
*/   inoutofbedo6  inoutofbedo6_ll inoutofbedo6_ul inoutofbedo6_se /*
*/   inbedo6 inbedo6_ll inbedo6_ul inbedo6_se 
gen seqhr = _n
drop if _n>12
sort seqhr
save "temp_hum3.dta", replace
 
 
* in bed in net (older ages) 

use "3Humanbehaviour.dta", replace

rename outdoors halfhrs1 
rename inoutofbed halfhrs2 
rename inbednonet halfhrs3
rename inbedinnet halfhrs4

reshape long halfhrs, i(hh_id seqhr clusterno agecode) j(location) 


gen inbedinneto6 = .
gen inbedinneto6_ll = .
gen inbedinneto6_ul = .
gen inbedinneto6_se = .

gen inbednoneto6 = .
gen inbednoneto6_ll = .
gen inbednoneto6_ul = .
gen inbednoneto6_se = .


***over 6s 
keep if agecode == 1

svyset hh_id [pweight=halfhrs]
svy: proportion location 
levelsof seqhr, local(i)
foreach i in 1 2 3 4 5 6 7 8 9 10 11 12 {
   quietly svy: proportion location if seqhr == `i' 
   *matrix list r(table)
  
   scalar inbedinnet = r(table)[1,4]
   scalar inbedinnet_ll = r(table)[5,4]
   scalar inbedinnet_ul = r(table)[6,4]
   scalar inbedinnet_se = r(table)[2,4]
   
   quietly replace inbedinneto6 = inbedinnet in `i'
   quietly replace inbedinneto6_ll = inbedinnet_ll in `i'
   quietly replace inbedinneto6_ul = inbedinnet_ul in `i'
   quietly replace inbedinneto6_se = inbedinnet_se in `i'
   quietly replace inbedinneto6_se = 0 if inbedinnet_se==.
   
   scalar inbednonet = r(table)[1,3]
   scalar inbednonet_ll = r(table)[5,3]
   scalar inbednonet_ul = r(table)[6,3]
   scalar inbednonet_se = r(table)[2,3]
   
   quietly replace inbednoneto6 = inbednonet in `i'
   quietly replace inbednoneto6_ll = inbednonet_ll in `i'
   quietly replace inbednoneto6_ul = inbednonet_ul in `i'
   quietly replace inbednoneto6_se = inbednonet_se in `i'
   quietly replace inbednoneto6_se = 0 if inbednonet_se==.
          
   local i = `i'+1
 }

 

 
**** save estimates (temp files to merge to human_behaviour_ests.dta)
keep inbedinneto6 inbedinneto6_ll inbedinneto6_ul inbedinneto6_se inbednoneto6 inbednoneto6_ll inbednoneto6_ul inbednoneto6_se 
gen seqhr = _n
drop if _n>12
sort seqhr
save "temp_hum4.dta", replace

* merge temp files together and save 

merge 1:1 seqhr using "temp_hum3.dta"
drop _merge
merge 1:1 seqhr using "temp_hum2.dta"
drop _merge
merge 1:1 seqhr using "temp_hum1.dta"
drop _merge

save "3human_behaviour_ests.dta", replace

rm temp_hum1.dta
rm temp_hum2.dta
rm temp_hum3.dta
rm temp_hum4.dta




* table 5

use "3human_behaviour_ests.dta", clear

list outdooru6 outdooru6_ll outdooru6_ul inoutofbedu6 inoutofbedu6_ll inoutofbedu6_ul inbedu6 inbedu6_ll inbedu6_ul, clean

list outdooro6 outdooro6_ll outdooro6_ul inoutofbedo6 inoutofbedo6_ll inoutofbedo6_ul inbedo6 inbedo6_ll inbedo6_ul, clean




* For fig 2
list outdooru6 inoutofbedu6 inbedu6 outdooro6 inoutofbedo6 inbedo6, clean
* use fig2.r




*** Proportion of time under ITN in bed out of total time in bed ***

use "3Humanbehaviour.dta", replace

*** ITN coverage (proportion of time spent under ITNs out of the time spent in bed)

rename inbednonet inbedin0
rename inbedinnet inbedin2

reshape long inbedin, i(hh_id seqhr clusterno agecode) j(location) 
drop if inbedin==0

** under 6s (pre-schoolage)
svyset hh_id [pweight=inbedin]
svy: proportion location if agecode == 0

** older members
svyset hh_id [pweight=inbedin]
svy: proportion location if agecode == 1





*******Proportion of time spent at different locations before 10PM, between 10PM to 5AM and after 5AM

use "3Humanbehaviour.dta", clear

rename outdoors halfhrs1 
rename inoutofbed halfhrs2 
rename inbed halfhrs3 

reshape long halfhrs, i(hh_id seqhr clusterno agecode) j(location) 

gen timecat2 = 1
replace timecat2 = 2 if seqhr > 4
replace timecat2 = 3 if seqhr > 11

***Under 5s 
preserve
keep if agecode == 0
svyset hh_id [pweight=halfhrs]
svy: proportion location 
levelsof timecat2, local(i)
foreach i in 1 2 3 {
   quietly svy: proportion location if timecat2 == `i' 
   matrix list r(table)
   scalar outdoors = r(table)[1,1]
   scalar inoutofbed = r(table)[1,2]
   scalar inbed = r(table)[1,3]
   di outdoors
   di inoutofbed
   di inbed
   local i = `i'+1
 }
 
restore

***Older members

preserve
keep if agecode == 1
svyset hh_id [pweight=halfhrs]
svy: proportion location 
levelsof timecat2, local(i)
foreach i in 1 2 3 {
   quietly svy: proportion location if timecat2 == `i' 
   matrix list r(table)
   scalar outdoors = r(table)[1,1]
   scalar inoutofbed = r(table)[1,2]
   scalar inbed = r(table)[1,3]
   di outdoors
   di inoutofbed
   di inbed
   local i = `i'+1
 }
 
restore




*******Proportion of time spent outdoors under ITNs

use "3Humanbehaviour.dta", clear

rename outdoors halfhrs1 
rename indoors halfhrs2 
rename outinnet halfhrs3 

reshape long halfhrs, i(hh_id seqhr clusterno agecode) j(location) 

***Under 6s (pre-school-age) 
preserve
keep if agecode == 0
svyset hh_id [pweight=halfhrs]
svy: proportion location 
quietly svy: proportion location 
   matrix list r(table)
   scalar outdoors = r(table)[1,3]
   scalar lb = r(table)[5,3]
   scalar ub = r(table)[6,3]
   di outdoors
   di lb
   di ub
restore



***Older members
preserve
keep if agecode == 1
svyset hh_id [pweight=halfhrs]
svy: proportion location 
quietly svy: proportion location 
   matrix list r(table)
   scalar outdoors = r(table)[1,3]
   scalar lb = r(table)[5,3]
   scalar ub = r(table)[6,3]
   di outdoors
   di lb
   di ub
restore

***all ages
preserve
svyset hh_id [pweight=halfhrs]
svy: proportion location 
quietly svy: proportion location 
   matrix list r(table)
   scalar outdoors = r(table)[1,3]
   scalar indoors = r(table)[5,3]
   scalar outinnet = r(table)[6,3]
   di outdoors
   di lb
   di ub
restore








