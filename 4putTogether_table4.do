

* Get calculated variables and CI 
* uses random draws from the estimated distributions for parameter values to estimate uncertainty in the combined variables

clear


set seed 12345

* biting
* read in estimates 
clear
import delim using "1biting_estd_hrly_rates.csv", delim(",")




set obs 1000
* number of random draws is 1000
* location code in/out (1=in, 0=out)


keep ang_out_logm ang_out_logse ang_in_logm ang_in_logse  /*
*/   anf_out_logm anf_out_logse anf_in_logm anf_in_logse                                  
 
* get random draws
forval x = 1/12 {
    gen b_in_ang`x' = exp( rnormal(ang_in_logm[`x'], ang_in_logse[`x']) )
	gen b_out_ang`x' = exp( rnormal(ang_out_logm[`x'], ang_out_logse[`x']) )
	
	gen b_in_anf`x' = exp( rnormal(anf_in_logm[`x'], anf_in_logse[`x']) )
	gen b_out_anf`x' = exp( rnormal(anf_out_logm[`x'], anf_out_logse[`x']) )
}

drop ang_out_logm ang_out_logse ang_in_logm ang_in_logse  /*
*/  anf_out_logm anf_out_logse anf_in_logm anf_in_logse                                  
 
save "4samp_biting.dta", replace




* sporozoite rates
use "2sporoz_propInfected_ests.dta", clear

* get random draws from distributions
set obs 1000

forval x = 1/12 {
    quietly gen s_anf_out_p`x' = rnormal(anf_out_p[`x'], anf_out_se[`x'])
	quietly gen s_ang_out_p`x' = rnormal(ang_out_p[`x'], ang_out_se[`x'])
	quietly gen s_anf_in_p`x' = rnormal(anf_in_p[`x'], anf_in_se[`x'])
	quietly gen s_ang_in_p`x' = rnormal(ang_in_p[`x'], anf_in_se[`x'])
	* avoid negative values just in case
	quietly replace s_anf_out_p`x' = 0.0 if s_anf_out_p`x'<=0
	quietly replace s_ang_out_p`x' = 0.0 if s_ang_out_p`x'<=0
	quietly replace s_anf_in_p`x' = 0.0 if s_anf_in_p`x'<=0
	quietly replace s_ang_in_p`x' = 0.0 if s_ang_in_p`x'<=0
}

drop seqhr anf_out_p anf_out_se ang_in_p ang_in_se ang_out_p  ang_out_se anf_in_p anf_in_se 

save "4samp_sporoz.dta", replace




* human behaviour estimates

use "3human_behaviour_ests.dta", clear

set obs 1000

*under 6y
*proportions in bed under net per hour
*proportion indoors in bed not under net
*proportion indoors not in bed
*proportion outdoors


forval x = 1/12 {
	quietly gen h_inbedinnetu6p_`x' = rnormal(inbedinnetu6[`x'], inbedinnetu6_se[`x'])
	quietly gen h_outdoorsu6p_`x' = rnormal(outdooru6[`x'], outdooru6_se[`x'])
    quietly gen h_inoutofbedu6p_`x' = rnormal(inoutofbedu6[`x'], inoutofbedu6_se[`x'])
    quietly gen h_inbedu6p_`x' = rnormal(inbedu6[`x'], inbedu6_se[`x'])
	quietly gen h_inbednonetu6p_`x' = rnormal(inbednonetu6[`x'], inbednonetu6_se[`x'])

	quietly replace h_inbedinnetu6p_`x' = 0.0 if h_inbedinnetu6p_`x'<0
	quietly replace h_inbedinnetu6p_`x' = 1.0 if h_inbedinnetu6p_`x'>1
	quietly replace h_outdoorsu6p_`x' = 0.0 if h_outdoorsu6p_`x'<0
	quietly replace h_outdoorsu6p_`x' = 1.0 if h_outdoorsu6p_`x'>1
    quietly replace h_inoutofbedu6p_`x' = 0.0 if h_inoutofbedu6p_`x'<0
	quietly replace h_inoutofbedu6p_`x' = 1.0 if h_inoutofbedu6p_`x'>1
	quietly replace h_inbedu6p_`x' = 0.0 if h_inbedu6p_`x'<0
	quietly replace h_inbedu6p_`x' = 1.0 if h_inbedu6p_`x'>1
	quietly replace h_inbednonetu6p_`x' = 0.0 if h_inbednonetu6p_`x'<0
	quietly replace h_inbednonetu6p_`x' = 1.0 if h_inbednonetu6p_`x'>1
}

forval x = 1/12 {
	quietly gen h_inbedinneto6p_`x' = rnormal(inbedinneto6[`x'], inbedinneto6_se[`x'])
	quietly gen h_outdoorso6p_`x' = rnormal(outdooro6[`x'], outdooro6_se[`x'])
    quietly gen h_inoutofbedo6p_`x' = rnormal(inoutofbedo6[`x'], inoutofbedo6_se[`x'])
    quietly gen h_inbedo6p_`x' = rnormal(inbedo6[`x'], inbedo6_se[`x'])
	quietly gen h_inbednoneto6p_`x' = rnormal(inbednoneto6[`x'], inbednoneto6_se[`x'])

	quietly replace h_inbedinneto6p_`x' = 0.0 if h_inbedinneto6p_`x'<0
	quietly replace h_inbedinneto6p_`x' = 1.0 if h_inbedinneto6p_`x'>1
	quietly replace h_outdoorso6p_`x' = 0.0 if h_outdoorso6p_`x'<0
	quietly replace h_outdoorso6p_`x' = 1.0 if h_outdoorso6p_`x'>1
    quietly replace h_inoutofbedo6p_`x' = 0.0 if h_inoutofbedo6p_`x'<0
	quietly replace h_inoutofbedo6p_`x' = 1.0 if h_inoutofbedo6p_`x'>1
	quietly replace h_inbedo6p_`x' = 0.0 if h_inbedo6p_`x'<0
	quietly replace h_inbedo6p_`x' = 1.0 if h_inbedo6p_`x'>1
	quietly replace h_inbednoneto6p_`x' = 0.0 if h_inbednoneto6p_`x'<0
	quietly replace h_inbednoneto6p_`x' = 1.0 if h_inbednoneto6p_`x'>1
}



drop inbedinneto6 inbedinneto6_ll inbedinneto6_ul inbedinneto6_se seqhr /*                            
*/ outdooro6 outdooro6_ll outdooro6_ul outdooro6_se /*                    
*/ inoutofbedo6 inoutofbedo6_ll inoutofbedo6_ul inoutofbedo6_se /*
*/ inbedo6 inbedo6_ll inbedo6_ul inbedo6_se /*                      
*/ inbedinnetu6 inbedinnetu6_ll inbedinnetu6_ul inbedinnetu6_se /*                 
*/ outdooru6 outdooru6_ll outdooru6_ul outdooru6_se /*                    
*/ inoutofbedu6 inoutofbedu6_ll inoutofbedu6_ul inoutofbedu6_se /*                  
*/ inbedu6 inbedu6_ll inbedu6_ul inbedu6_se    /*
*/ inbednonetu6 inbednonetu6_ll inbednonetu6_ul inbednonetu6_se  


save "4samp_humanBehav.dta", replace






* combine sampled draws for biting rates and proportion infected into one dataset

use "4samp_biting.dta", clear
merge 1:1 _n using "4samp_sporoz.dta"
drop _merge
merge 1:1 _n using "4samp_humanBehav.dta"
drop _merge

* infective bites per hour

* combine biting and sporoz rate to get sampling of the distribution of infected bite per hour
forval x = 1/12 {
	gen infb_in_ang`x' = b_in_ang`x' * s_ang_in_p`x'
	gen infb_in_anf`x' = b_in_anf`x' * s_anf_in_p`x'
	gen infb_out_ang`x' = b_out_ang`x' * s_ang_out_p`x'
    gen infb_out_anf`x' = b_out_anf`x' * s_anf_out_p`x'	
    gen infb_in_tot`x' = infb_in_anf`x'  + infb_in_ang`x' 
    gen infb_out_tot`x' = infb_out_anf`x'  + infb_out_ang`x' 
}
 
 
 
 * extract estimates for mean and 95% CI by hour 
* infective bites per hour by species and location
gen estInfb_in_ang = .
gen estInfb_in_ang_lb = .
gen estInfb_in_ang_ub = .
gen estInfb_in_anf = .
gen estInfb_in_anf_lb = .
gen estInfb_in_anf_ub = .
gen estInfb_in_tot = .
gen estInfb_in_tot_lb = .
gen estInfb_in_tot_ub = .

gen estInfb_out_ang = .
gen estInfb_out_ang_lb = .
gen estInfb_out_ang_ub = .
gen estInfb_out_anf = .
gen estInfb_out_anf_lb = .
gen estInfb_out_anf_ub = .
gen estInfb_out_tot = .
gen estInfb_out_tot_lb = .
gen estInfb_out_tot_ub = .

forval x = 1/12 {
	* indoors
	quietly centile infb_in_ang`x', centile(2.5 50 97.5)
	quietly replace estInfb_in_ang_lb = r(c_1) if _n==`x'
	quietly replace estInfb_in_ang_ub = r(c_3) if _n==`x'
	summ infb_in_ang`x'
	quietly replace estInfb_in_ang = r(mean) if _n==`x'
		
	quietly centile infb_in_anf`x', centile(2.5 50 97.5)
	quietly replace estInfb_in_anf_lb = r(c_1) if _n==`x'
	quietly replace estInfb_in_anf_ub = r(c_3) if _n==`x'
	summ infb_in_anf`x'
	quietly replace estInfb_in_anf = r(mean) if _n==`x'
	
	quietly centile infb_in_tot`x', centile(2.5 50 97.5)
	quietly replace estInfb_in_tot_lb = r(c_1) if _n==`x'
	quietly replace estInfb_in_tot_ub = r(c_3) if _n==`x'
	summ infb_in_tot`x'
	quietly replace estInfb_in_tot = r(mean) if _n==`x'
	
	
	* outdoors
	quietly centile infb_out_ang`x', centile(2.5 50 97.5)
	quietly replace estInfb_out_ang_lb = r(c_1) if _n==`x'
	quietly replace estInfb_out_ang_ub = r(c_3) if _n==`x'
	summ infb_out_ang`x'
	quietly replace estInfb_out_ang = r(mean) if _n==`x'
	
	quietly centile infb_out_anf`x', centile(2.5 50 97.5)
	quietly replace estInfb_out_anf_lb = r(c_1) if _n==`x'
	quietly replace estInfb_out_anf_ub = r(c_3) if _n==`x'
	summ infb_out_anf`x'
	quietly replace estInfb_out_anf = r(mean) if _n==`x'
	
	quietly centile infb_out_tot`x', centile(2.5 50 97.5)
	quietly replace estInfb_out_tot_lb = r(c_1) if _n==`x'
	quietly replace estInfb_out_tot_ub = r(c_3) if _n==`x'	
	summ infb_out_tot`x'
	quietly replace estInfb_out_tot = r(mean) if _n==`x'
}


** table 4 - infective bites by hour, species & location
list estInfb_in_ang estInfb_in_ang_lb estInfb_in_ang_ub in 1/12, clean
list estInfb_in_anf estInfb_in_anf_lb estInfb_in_anf_ub in 1/12, clean
list estInfb_in_tot estInfb_in_tot_lb estInfb_in_tot_ub in 1/12, clean

list estInfb_out_ang estInfb_out_ang_lb estInfb_out_ang_ub in 1/12, clean
list estInfb_out_anf estInfb_out_anf_lb estInfb_out_anf_ub in 1/12, clean
list estInfb_out_tot estInfb_out_tot_lb estInfb_out_tot_ub in 1/12, clean




 
* proportion of infective bites beween 10pm and 5am (needed later)
* indoors
gen infb_in_night = infb_in_tot1 + infb_in_tot2 + infb_in_tot3 + infb_in_tot4 + infb_in_tot5 + infb_in_tot6 + infb_in_tot7 + /*
*/                    infb_in_tot8 + infb_in_tot9 + infb_in_tot10 + infb_in_tot11 + infb_in_tot12

gen infb_in_10to5 = infb_in_tot5 + infb_in_tot6 + infb_in_tot7 + infb_in_tot8 + /*
*/                    infb_in_tot9 + infb_in_tot10 + infb_in_tot11

gen infb_in_not10to5 = infb_in_tot1 + infb_in_tot2 + infb_in_tot3 + infb_in_tot4 + infb_in_tot12 

gen prop10to5in = infb_in_10to5 / infb_in_night
gen propnot10to5in = infb_in_not10to5 / infb_in_night
centile prop10to5in, centile(2.5 50 97.5)



* outdoors
gen infb_out_night = infb_out_tot1 + infb_out_tot2 + infb_out_tot3 + infb_out_tot4 + infb_out_tot5 + infb_out_tot6 + infb_out_tot7 + /*
*/                    infb_out_tot8 + infb_out_tot9 + infb_out_tot10 + infb_out_tot11 + infb_out_tot12

gen infb_out_10to5 = infb_out_tot5 + infb_out_tot6 + infb_out_tot7 + infb_out_tot8 + /*
*/                    infb_out_tot9 + infb_out_tot10 + infb_out_tot11

gen infb_out_before10 = infb_out_tot1 + infb_out_tot2 + infb_out_tot3 + infb_out_tot4
gen infb_out_after5 = infb_out_tot12 

gen infb_out_not10to5 = infb_out_tot1 + infb_out_tot2 + infb_out_tot3 + infb_out_tot4 + infb_out_tot12 

gen prop10to5out = infb_out_10to5 / infb_out_night
gen propnot10to5out = infb_out_not10to5 / infb_out_night

centile prop10to5out, centile(2.5 50 97.5)
*centile propnot10to6out, centile(2.5, 50, 97.5)


* estimate EIR
gen eir = (infb_out_night + infb_in_night)*365.25 /2
summ eir

   

* proportion of infective bites by location by age-group
* for fig 4 and also in text
    
* under 5
gen infb_h_in_allu6 = 0
gen infb_h_out_allu6 = 0
gen infb_h_inbedinnet_allu6 = 0
gen infb_h_inbednonet_allu6 = 0
gen infb_h_inoutofbed_allu6 = 0


* need all 4 categories for fig 4 (not summed, just hourly)
* outdoors, inbedinnet, inbednonet, innotinbed

forval x = 1/12 {
	     quietly gen infb_h_outu6_`x' = infb_out_tot`x' * h_outdoorsu6p_`x' 
         quietly replace infb_h_out_allu6 = infb_h_out_allu6 + infb_h_outu6_`x'

		 quietly gen infb_h_inu6_`x' = infb_in_tot`x' * (1-h_outdoorsu6p_`x')
		 quietly replace infb_h_in_allu6 = infb_h_in_allu6 + infb_h_inu6_`x'
		
		 quietly gen infb_h_inbedinnetu6_`x' = infb_in_tot`x' * h_inbedinnetu6p_`x' 
		 quietly replace infb_h_inbedinnet_allu6 = infb_h_inbedinnet_allu6 + infb_h_inbedinnetu6_`x'
		 
		 quietly gen infb_h_inbednonetu6_`x' = infb_in_tot`x' *  h_inbednonetu6p_`x' 
		 quietly replace infb_h_inbednonet_allu6 = infb_h_inbednonet_allu6 + infb_h_inbednonetu6_`x'
		 	 
         quietly gen infb_h_inoutofbedu6_`x' = infb_in_tot`x' * h_inoutofbedu6p_`x' 
		 quietly replace infb_h_inoutofbed_allu6 = infb_h_inoutofbed_allu6 + infb_h_inoutofbedu6_`x'
		 
}
 


* proportion of inf bites when under an ITN (with current behaviour patterns)
gen infb_h_allu6 = infb_h_in_allu6 + infb_h_out_allu6 

gen p_ITNu6 = infb_h_inbedinnet_allu6 / infb_h_allu6
centile p_ITNu6, centile(2.5, 50, 97.5)

gen p_outu6 = infb_h_out_allu6 / infb_h_allu6
centile p_outu6, centile(2.5, 50, 97.5)

gen p_inoutofbedu6 = infb_h_inoutofbed_allu6 / infb_h_allu6
centile p_inoutofbedu6, centile(2.5, 50, 97.5)

gen p_inbednonetu6 = infb_h_inbednonet_allu6 / infb_h_allu6
centile p_inbednonetu6, centile(2.5, 50, 97.5)





*proportions per hour - for fig4
*infective bites outdoors
*infective bites indoors in bed (and under a net)
*infective bites indoors not in bed 
*infective bites indoors in bed and not under a net
gen estInfb_h_outu6 = .
gen estInfb_h_outu6_lb = .
gen estInfb_h_outu6_ub = .
gen estInfb_h_inbedinnetu6 = .
gen estInfb_h_inbedinnetu6_lb = .
gen estInfb_h_inbedinnetu6_ub = .
gen estInfb_h_inbednonetu6 = .
gen estInfb_h_inbednonetu6_lb = .
gen estInfb_h_inbednonetu6_ub = .
gen estInfb_h_inoutofbedu6 = .
gen estInfb_h_inoutofbedu6_lb = .
gen estInfb_h_inoutofbedu6_ub = .

forval x =  1/12 { 
    quietly centile infb_h_outu6_`x', centile(2.5 50 97.5)
	quietly replace estInfb_h_outu6 = r(c_2) if _n==`x'
	quietly replace estInfb_h_outu6_lb = r(c_1) if _n==`x'
	quietly replace estInfb_h_outu6_ub = r(c_3) if _n==`x'
		
	quietly centile infb_h_inbedinnetu6_`x', centile(2.5 50 97.5)
	quietly replace estInfb_h_inbedinnetu6 = r(c_2) if _n==`x'
	quietly replace estInfb_h_inbedinnetu6_lb = r(c_1) if _n==`x'
	quietly replace estInfb_h_inbedinnetu6_ub = r(c_3) if _n==`x'
	
	quietly centile infb_h_inbednonetu6_`x', centile(2.5 50 97.5)
	quietly replace estInfb_h_inbednonetu6 = r(c_2) if _n==`x'
	quietly replace estInfb_h_inbednonetu6_lb = r(c_1) if _n==`x'
	quietly replace estInfb_h_inbednonetu6_ub = r(c_3) if _n==`x'

	quietly centile infb_h_inoutofbedu6_`x', centile(2.5 50 97.5)
	quietly replace estInfb_h_inoutofbedu6 = r(c_2) if _n==`x'
	quietly replace estInfb_h_inoutofbedu6_lb = r(c_1) if _n==`x'
	quietly replace estInfb_h_inoutofbedu6_ub = r(c_3) if _n==`x'
}
 
list estInfb_h_outu6 estInfb_h_outu6_lb estInfb_h_outu6_ub in 1/12, clean
list estInfb_h_inbedinnetu6 estInfb_h_inbedinnetu6_lb estInfb_h_inbedinnetu6_ub in 1/12, clean
list estInfb_h_inbednonetu6 estInfb_h_inbednonetu6_lb estInfb_h_inbednonetu6_ub in 1/12, clean
list estInfb_h_inoutofbedu6 estInfb_h_inoutofbedu6_lb estInfb_h_inoutofbedu6_ub in 1/12, clean





**** repeat for over6s 
gen infb_h_in_allo6 = 0
gen infb_h_out_allo6 = 0
gen infb_h_inbedinnet_allo6 = 0
gen infb_h_inbednonet_allo6 = 0
gen infb_h_inoutofbed_allo6 = 0


forval x = 1/12 {
	     quietly gen infb_h_outo6_`x' = infb_out_tot`x' * h_outdoorso6p_`x' 
         quietly replace infb_h_out_allo6 = infb_h_out_allo6 + infb_h_outo6_`x'

		 quietly gen infb_h_ino6_`x' = infb_in_tot`x' * (1-h_outdoorso6p_`x')
		 quietly replace infb_h_in_allo6 = infb_h_in_allo6 + infb_h_ino6_`x'
		
		 quietly gen infb_h_inbedinneto6_`x' = infb_in_tot`x' * h_inbedinneto6p_`x' 
		 quietly replace infb_h_inbedinnet_allo6 = infb_h_inbedinnet_allo6 + infb_h_inbedinneto6_`x'
		 
		 quietly gen infb_h_inbednoneto6_`x' = infb_in_tot`x' * h_inbednoneto6p_`x' 
		 quietly replace infb_h_inbednonet_allo6 = infb_h_inbednonet_allo6 + infb_h_inbednoneto6_`x'
		 
         quietly gen infb_h_inoutofbedo6_`x' = infb_in_tot`x' * h_inoutofbedo6p_`x' 
		 quietly replace infb_h_inoutofbed_allo6 = infb_h_inoutofbed_allo6 + infb_h_inoutofbedo6_`x'
		 
}
 
 

 
 
* proportion of bites when under an ITN (with current behaviour patterns)
gen infb_h_allo6 = infb_h_in_allo6 + infb_h_out_allo6 
gen p_ITNo6 = infb_h_inbedinnet_allo6 / infb_h_allo6
centile p_ITNo6, centile(2.5, 50, 97.5)

gen p_outo6 = infb_h_out_allo6 / infb_h_allo6
centile p_outo6, centile(2.5, 50, 97.5)

gen p_inoutofbedo6 = infb_h_inoutofbed_allo6 / infb_h_allo6
centile p_inoutofbedo6, centile(2.5, 50, 97.5)

gen p_inbednoneto6 = infb_h_inbednonet_allo6 / infb_h_allo6
centile p_inbednoneto6, centile(2.5, 50, 97.5)





*proportions per hour - for fig4
gen estInfb_h_outo6 = .
gen estInfb_h_outo6_lb = .
gen estInfb_h_outo6_ub = .
gen estInfb_h_inbedinneto6 = .
gen estInfb_h_inbedinneto6_lb = .
gen estInfb_h_inbedinneto6_ub = .
gen estInfb_h_inbednoneto6 = .
gen estInfb_h_inbednoneto6_lb = .
gen estInfb_h_inbednoneto6_ub = .
gen estInfb_h_inoutofbedo6 = .
gen estInfb_h_inoutofbedo6_lb = .
gen estInfb_h_inoutofbedo6_ub = .

forval x =  1/12 { 
    quietly centile infb_h_outo6_`x', centile(2.5 50 97.5)
	quietly replace estInfb_h_outo6 = r(c_2) if _n==`x'
	quietly replace estInfb_h_outo6_lb = r(c_1) if _n==`x'
	quietly replace estInfb_h_outo6_ub = r(c_3) if _n==`x'
		
	quietly centile infb_h_inbedinneto6_`x', centile(2.5 50 97.5)
	quietly replace estInfb_h_inbedinneto6 = r(c_2) if _n==`x'
	quietly replace estInfb_h_inbedinneto6_lb = r(c_1) if _n==`x'
	quietly replace estInfb_h_inbedinneto6_ub = r(c_3) if _n==`x'
	
	quietly centile infb_h_inbednoneto6_`x', centile(2.5 50 97.5)
	quietly replace estInfb_h_inbednoneto6 = r(c_2) if _n==`x'
	quietly replace estInfb_h_inbednoneto6_lb = r(c_1) if _n==`x'
	quietly replace estInfb_h_inbednoneto6_ub = r(c_3) if _n==`x'

	quietly centile infb_h_inoutofbedo6_`x', centile(2.5 50 97.5)
	quietly replace estInfb_h_inoutofbedo6 = r(c_2) if _n==`x'
	quietly replace estInfb_h_inoutofbedo6_lb = r(c_1) if _n==`x'
	quietly replace estInfb_h_inoutofbedo6_ub = r(c_3) if _n==`x'
}
 
 
list estInfb_h_outo6 estInfb_h_outo6_lb estInfb_h_outo6_ub in 1/12, clean
list estInfb_h_inbedinneto6 estInfb_h_inbedinneto6_lb estInfb_h_inbedinneto6_ub in 1/12, clean
list estInfb_h_inbednoneto6 estInfb_h_inbednoneto6_lb estInfb_h_inbednoneto6_ub in 1/12, clean
list estInfb_h_inoutofbedo6 estInfb_h_inoutofbedo6_lb estInfb_h_inoutofbedo6_ub in 1/12, clean





* human risk eir
gen humeiro6 = (infb_h_allo6 - infb_h_inbedinnet_allo6) * 365.25 
gen humeiru6 = (infb_h_allu6 - infb_h_inbedinnet_allu6) * 365.25 

summ humeiro6 humeiru6




* save estimates to file to use in fig4.r
drop if _n>12
keep  estInfb_h_outu6 estInfb_h_inoutofbedu6 estInfb_h_inbedinnetu6 estInfb_h_inbednonetu6 estInfb_h_outo6 estInfb_h_inoutofbedo6 estInfb_h_inbedinneto6 estInfb_h_inbednoneto6 
save fig4_ests.dta, replace




 
