### timing_infected_bites_human_behaviour

Repository for data and code

A matter of timing: biting by malaria-infected <em>Anopheles</em> mosquitoes and the use of interventions during the night in rural south-eastern Tanzania <br><br>
<em>Namango I, Moore SJ, Marshall C, Saddler A, Kaftan D, Tenywa FC, Makungwa N, Limwagu JA, Mapua S, Odufuwa OG, Ligema G, Ngonyani G, Matanila I, Bharmal J, Moore J, Finda M, Okumu F, Hetzel MW, Ross A</em>

<br>

#### 1. Biting

The Stata dataset is <em>1biting_data.dta</em> <br>
The number of HLC for table 2 are summarized by <em>1biting_getNumberOfHLC_table2.do</em>.<br>
The hourly biting rates are estimated in R using <em>1biting_getHrlyEsts_table2.r</em> - and written to <em>1biting_estd_hrly_rates.csv</em>.<br><br>


#### 2. Sporozoites - proportion of bites infected

<em>2sporoz_propInfected_getEsts.do</em> reads in the data <em>2sporoz_data.dta</em>, calculates the estimated proportion of bites infected for hours and species and writes the estimates to <em>2sporoz_propInfected_ests.dta</em>



#### 3. Human behaviour - location and ITN use

The human behaviour data can be downloaded from Finda MF <em>et al</em> https://doi.org/10.1371/journal.pone.0217414,  Supporting Information 5.
The data is prepared using <em>3human_behaviour_data_prepare.do</em> and written to <em>3human_behaviour_data.dta</em>.
Estimates of the proportion of household members in different locations for each hour are calculated using <em>3human_behaviour_and_table_5.do</em> and written to <em>3human_behaviour_ests.dta</em>.














