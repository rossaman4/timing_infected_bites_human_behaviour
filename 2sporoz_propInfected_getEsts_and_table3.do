

** agregating by hour, species

* set working directory
*cd ".."

* read in data
use "2sporoz_data.dta", clear


* get overall proportions by species and location (in text)
collapse (sum) ntested positive, by(sp loc)
gen prop = positiv / ntested
list, clean


* get proportions  
* by hour, species and location
use "2sporoz_data.dta", clear
collapse(sum) ntested positive, by(seqhr sp loc)

* get proprtion infected, and se 
gen propn = positive/ntested
gen s_propn = positive/ntested
gen s_propn_se = sqrt(s_propn*(1-s_propn)/ntested)

* get exact binomial CI
gen estprop = .
gen estse = .
gen estlb = .
gen estub = .
forvalues i = 1/48 {
	 quietly cii proportions ntested[`i'] positive[`i'], exact
	 quietly replace estprop = r(proportion) in `i'
	 quietly replace estse = r(se) in `i'
	 quietly replace estlb = r(lb) in `i'
	 quietly replace estub = r(ub) in `i'
}

* table 3
* location: 1=indoors, 2=outdoors
* species: 1=An arabiensis, 2=An funestus     
list sp seqhr location ntested positive estprop estse estlb estub if location ==1 & sp==1, clean
list sp seqhr location ntested positive estprop estse estlb estub if location ==1 & sp==2, clean
list sp seqhr location ntested positive estprop estse estlb estub if location ==2 & sp==1, clean
list sp seqhr location ntested positive estprop estse estlb estub if location ==2 & sp==2, clean


* Pool hours to have at least around 1500 mosq per hrcat
* Indoors: 6-11pm,11-12, 2-1, 1-6 
* Outdoors: Altogether
* same for both species
gen hrcat = 1
replace hrcat = 2 if seqhr > 5
replace hrcat = 3 if seqhr > 6
replace hrcat = 4 if seqhr > 7
replace hrcat = 5 if location==2

* get proportions and se by hrcat
collapse(sum) ntested positive, by(hrcat sp loc)

sort sp loc hrcat

* move back to hours instead of hrcat
gen nrec = .
replace nrec = 5 if hrcat==1
replace nrec = 1 if hrcat==2
replace nrec = 1 if hrcat==3
replace nrec = 5 if hrcat==4
replace nrec = 12 if hrcat==5
expand nrec


sort sp loc hrcat

gen seqhr = mod(_n, 12)
replace seqhr = 12 if seqhr==0
* calculate estimated proportion and SE for the aggregated hour categories
gen s_propn = positive/ntested
gen s_propn_se = sqrt(s_propn*(1-s_propn)/ntested)


* reformat to get estimates side by side
keep sp location seqhr s_propn s_propn_se
save "temp2.dta", replace

keep if location==1 & sp==1
rename s_propn ang_in_p 
rename s_propn_se ang_in_se
drop sp location
save "temp2_1.dta", replace
use "temp2.dta", clear
keep if location==2 & sp==1
rename s_propn ang_out_p 
rename s_propn_se ang_out_se
drop sp location
save "temp2_2.dta", replace
use "temp2.dta", clear
keep if location==1 & sp==2
rename s_propn anf_in_p 
rename s_propn_se anf_in_se
drop sp location
save "temp2_3.dta", replace
use "temp2.dta", clear
keep if location==2 & sp==2
rename s_propn anf_out_p 
rename s_propn_se anf_out_se
drop sp location
save "temp2_4.dta", replace
quietly merge 1:1 seqhr using "temp2_1.dta"
drop _merge
quietly merge 1:1 seqhr using "temp2_2.dta"
drop _merge
quietly merge 1:1 seqhr using "temp2_3.dta"
drop _merge


* remove temporary files
rm temp2.dta
rm temp2_1.dta
rm temp2_2.dta
rm temp2_3.dta
rm temp2_4.dta


save "2sporoz_propInfected_ests.dta", replace








