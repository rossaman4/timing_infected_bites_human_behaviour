
* Human behaviour data preparation


import delimited "SI5_human_movement_data.csv", clear 


* drop urban hamlets (to match ento data which only has rural hamlets)
gen clusterno = -9
replace clusterno = 1 if hh_id>900 & hh_id<1000
replace clusterno = 2 if hh_id>800 & hh_id<900
replace clusterno = 3 if hh_id>500 & hh_id<600
replace clusterno = 4 if hh_id>700 & hh_id<800
replace clusterno = 5 if hh_id>600 & hh_id<700
replace clusterno = 6 if hh_id>400 & hh_id<500
drop if clusterno == -9


* drop if Away
drop if activity == "Away" | location == "Away"

** recoding
replace activity = "Stories in net" if activity == "Story in net"
replace activity = "Sleeping in net" if activity == "sleeping in net"

** likely error
tabu tot_people people
replace people=1 if people==11



*** coding time
gen seqtime = 0, after(time)
replace seqtime = 1 if time == "1800-1829"
replace seqtime = 2 if time == "1830-1859"
replace seqtime = 3 if time == "1900-1929"
replace seqtime = 4 if time == "1930-1959"
replace seqtime = 5 if time == "2000-2029"
replace seqtime = 6 if time == "2030-2059"
replace seqtime = 7 if time == "2100-2129"
replace seqtime = 8 if time == "2130-2159"
replace seqtime = 9 if time == "2200-2229"
replace seqtime = 10 if time == "2230-2259"
replace seqtime = 11 if time == "2300-2329"
replace seqtime = 12 if time == "2330-2359"
replace seqtime = 13 if time == "0000-0029"
replace seqtime = 14 if time == "0030-0059"
replace seqtime = 15 if time == "0100-0129"
replace seqtime = 16 if time == "0130-0159"
replace seqtime = 17 if time == "0200-0229"
replace seqtime = 18 if time == "0230-0259"
replace seqtime = 19 if time == "0300-0329"
replace seqtime = 20 if time == "0330-0359"
replace seqtime = 21 if time == "0400-0429"
replace seqtime = 22 if time == "0430-0459"
replace seqtime = 23 if time == "0500-0529"
replace seqtime = 24 if time == "0530-0559"
replace seqtime = 25 if time == "0600-0629"
replace seqtime = 26 if time == "0630-0659"

gen seqhr = 0, after(seqtime)
replace seqhr = 1 if seqtime == 1 | seqtime == 2
replace seqhr = 2 if seqtime == 3 | seqtime == 4
replace seqhr = 3 if seqtime == 5 | seqtime == 6
replace seqhr = 4 if seqtime == 7 | seqtime == 8
replace seqhr = 5 if seqtime == 9 | seqtime == 10
replace seqhr = 6 if seqtime == 11 | seqtime == 12
replace seqhr = 7 if seqtime == 13 | seqtime == 14
replace seqhr = 8 if seqtime == 15 | seqtime == 16
replace seqhr = 9 if seqtime == 17 | seqtime == 18
replace seqhr = 10 if seqtime == 19 | seqtime == 20
replace seqhr = 11 if seqtime == 21 | seqtime == 22
replace seqhr = 12 if seqtime == 23 | seqtime == 24
replace seqhr = 13 if seqtime == 25 | seqtime == 26


*** dropping time after 6AM to match ento data
drop if seqhr == 13




*** expanded dataset by population
expand people
drop people 

sort hh_id seqtime location age 


*** coding age and gender
gen agecode = 0, after(age)
replace agecode = 1 if age == "?6"
gen gencode = 0, after(gender)
replace gencode = 1 if gender == "Male"



*** coding locations of activities (loctn_actvty; 1 = Outdoors, 2 = Indoors, 3 = Indoors in bed w/o net, 4 = Indoors in bed under net, 5 = Outdoors under net)
gen loctn_actvty = 5 if location == "Outdoors" & activity == "Sleeping in net", after(activity)
replace loctn_actvty = 5 if location == "Outdoors" & activity == "Stories in net"
replace loctn_actvty = 4 if location == "Indoor" & activity == "Sleeping in net"
replace loctn_actvty = 4 if location == "Indoor" & activity == "Stories in net"
replace loctn_actvty = 3 if location == "Indoor" & activity == "Sleeping no net"
replace loctn_actvty = 2 if location == "Indoor" & loctn_actvty == .
replace loctn_actvty = 1 if location == "Outdoors" & loctn_actvty == .



*** generating total half hours spent in a location within an hour
bysort hh_id clusterno agecode seqhr: gen halfhrs_per_hr = _N


*** collapsing half hours by clusterno hhid halfhrs_per_hr agecode loctn_actvty seqhr 
gen halfhrs = 1, after(activity)  
collapse (sum) halfhrs, by(clusterno hh_id agecode seqhr halfhrs_per_hr loctn_actvty)

sort clusterno hh_id seqhr agecode 



*** reshaping dataset by halfhours to generate new variables with half hours spent on activities in different locations
reshape wide halfhrs, i(clusterno hh_id agecode seqhr halfhrs_per_hr) j(loctn_actvty)

sort hh_id seqhr agecode

rename halfhrs1 outdoors
rename halfhrs2 inoutofbed
rename halfhrs3 inbednonet
rename halfhrs4 inbedinnet
rename halfhrs5 outinnet

replace outdoors = 0 if outdoors == .
replace inoutofbed = 0 if inoutofbed == .
replace inbednonet = 0 if inbednonet == .
replace inbedinnet = 0 if inbedinnet == .
replace outinnet = 0 if outinnet==.


sort hh_id seqhr agecode

gen allout = outdoors, before(outdoors)
gen inbed = inbednonet+inbedinnet, before(inbednonet)
gen indoors = inoutofbed+inbed, after(allout)

drop outdoors
rename allout outdoors

save "3Humanbehaviour.dta", replace







