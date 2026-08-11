/*******************************************************************************
Project: CSDUL
Authors:  M. Sene; G. Notten
Latest update: 19-11-2025
Purpose: Descriptive statistics based on the adjusted income quintiles

Data:   2.income_pooled_mbm.dta

Output: 3.descriptives.dta

********************************************************************************
TABLES OF CONTENT

   - 0. Setup
   - 1. Overview
   - 2. Quintile movements
   - 3. Income differences
   - 4. Correlations
   - 5. Inequalities
   - 6. Bottom and top ends of the distribution
   - 7. Health 
   


*******************************************************************************/

* 0. Setup
*-------------------------------------------------------------------------------
//global settings 
clear all
set more off

//set directory
cd "T:\Projet 10629\node4\stata"

//open log 
cap log close
log using "log\3.descriptives.log", replace

//open datase
use "T:\Projet 10629\node4\stata\data\2.income_pooled_mbm.dta", clear

**#=============================================================================

                            *1.Overview

**#=============================================================================

* Describing income quintiles
 codebook eq_income_quintile if family_income!=.      // national distribution
 codebook eq_prov_income_quintile if family_income!=. // provincial distribution
 codebook ppp_income_quintile if family_income!=.     // ppp-adjusted distribution 
 
 bys year: tab eq_income_quintile [aw=WTS_SDLE]
 bys year: tab eq_prov_income_quintile [aw=WTS_SDLE]
 bys year: tab ppp_income_quintile [aw=WTS_SDLE]
 
//note: some quintile not exactly equal to 20.00% due to ties (all family members share the same income + weights) 
 
* Comparing quintiles concepts with the others

 tab ppp_income_quintile eq_income_quintile [aw=WTS_SDLE], cell nofreq
 tab ppp_income_quintile eq_prov_income_quintile [aw=WTS_SDLE], cell nofreq
 tab eq_prov_income_quintile eq_income_quintile  [aw=WTS_SDLE], cell nofreq
 
 bys year: tab ppp_income_quintile eq_income_quintile [aw=WTS_SDLE], cell nofreq 
 bys year: tab ppp_income_quintile eq_prov_income_quintile [aw=WTS_SDLE], cell nofreq
 bys year: tab eq_prov_income_quintile eq_income_quintile  [aw=WTS_SDLE], cell nofreq
 
// Observation: when adjusting for PPP, individuals move up or down by no more than +/-1 quintile (compared to national and provincial quintiles). When using provincial income quintiles, individuals move by up to +/- 2 quintiles, with most moving only 1 quintile. This suggests that the differences between provincial and national quintiles are larger than between PPP adjusted quintiles and nationa/provincial quintiles.   

* Assessing proportion of individuals who switched quintiles

   * Provincial quintiles

      //any movement
   tab eq_prov_income_quintile if eq_prov_income_quintile!=eq_income_quintile   [aw=WTS_SDLE]
   // upward movement 
   tab eq_prov_income_quintile if eq_prov_income_quintile>eq_income_quintile [aw=WTS_SDLE]
   // downard movement
   tab eq_prov_income_quintile if eq_prov_income_quintile<eq_income_quintile [aw=WTS_SDLE]
   
   //any movement
   bys year: tab eq_prov_income_quintile if eq_prov_income_quintile!=eq_income_quintile   [aw=WTS_SDLE]
   // upward movement 
   bys year: tab eq_prov_income_quintile if eq_prov_income_quintile>eq_income_quintile [aw=WTS_SDLE]
   // downard movement
   bys year: tab eq_prov_income_quintile if eq_prov_income_quintile<eq_income_quintile [aw=WTS_SDLE]


   * PPP-adjusted quintiles
   
   //any movement
   tab ppp_income_quintile if ppp_income_quintile!=eq_income_quintile [aw=WTS_SDLE]
   // upward movement 
   tab ppp_income_quintile if ppp_income_quintile>eq_income_quintile [aw=WTS_SDLE]
   // downard movement
   tab ppp_income_quintile if ppp_income_quintile<eq_income_quintile [aw=WTS_SDLE]
   
   //any movement
   bys year: tab ppp_income_quintile if ppp_income_quintile!=eq_income_quintile [aw=WTS_SDLE]
   // upward movement 
   bys year: tab ppp_income_quintile if ppp_income_quintile>eq_income_quintile [aw=WTS_SDLE]
   // downard movement
   bys year: tab ppp_income_quintile if ppp_income_quintile<eq_income_quintile [aw=WTS_SDLE]

//Observation: more movement is observed between national and provincial distributions, more movement into middle quintiles (2, 3, 4).

**#=============================================================================

                            *2.Quintiles movements

**#=============================================================================

* Proportion and absolute number of people moving up/down

  * with provincial distribution
gen move_prov= eq_prov_income_quintile - eq_income_quintile
tab move_prov if family_income!=., m

tab move_prov [aw=WTS_SDLE] 
tab move_prov if move_prov<0  [aw=WTS_SDLE]
tab move_prov if move_prov>0  [aw=WTS_SDLE]
tab move_prov if move_prov!=0 [aw=WTS_SDLE]

bys year: tab move_prov [aw=WTS_SDLE] 
bys year: tab move_prov if move_prov<0  [aw=WTS_SDLE]
bys year: tab move_prov if move_prov>0  [aw=WTS_SDLE]
bys year: tab move_prov if move_prov!=0 [aw=WTS_SDLE]

 
  * with ppp-adjusted distribution
gen move_ppp= ppp_income_quintile - eq_income_quintile
tab move_ppp if family_income!=., m

tab move_ppp [aw=WTS_SDLE]
tab move_ppp if move_ppp<0  [aw=WTS_SDLE]
tab move_ppp if move_ppp>0  [aw=WTS_SDLE]
tab move_ppp if move_ppp!=0 [aw=WTS_SDLE]

bys year: tab move_ppp [aw=WTS_SDLE]
bys year: tab move_ppp if move_ppp<0  [aw=WTS_SDLE]
bys year: tab move_ppp if move_ppp>0  [aw=WTS_SDLE]
bys year: tab move_ppp if move_ppp!=0 [aw=WTS_SDLE]

//Observation: overall, the share of people moving up is similar to the one of people moving down. This happens by construction because quintiles are equally sized weighted population shares.

 * by income quintile

bys eq_income_quintile: tab move_prov [aw=WTS_SDLE] 
bys eq_income_quintile: tab move_ppp [aw=WTS_SDLE] 
 
bys year eq_income_quintile: tab move_prov [aw=WTS_SDLE] 
bys year eq_income_quintile: tab move_ppp [aw=WTS_SDLE] 

//Observation: most movement is observed in quintiles 2,3,4. 


* Analysis by province
tab fprov eq_income_quintile [aw=WTS_SDLE], cell nofreq
bys year: tab fprov eq_income_quintile [aw=WTS_SDLE], cell nofreq

  * using provincial distribution
 bys fprov: tab move_prov [aw=WTS_SDLE]
 
 bys year fprov: tab move_prov [aw=WTS_SDLE]
 bys year: tab fprov if move_prov>0 [aw=WTS_SDLE]
 bys year: tab fprov if move_prov<0 [aw=WTS_SDLE]
 bys year fprov: tab eq_income_quintile eq_prov_income_quintile [aw=WTS_SDLE]
 
/* Observations: 
provinces where some people have stayed in their quintiles, some moved up and others moved down are: British Columbia, Manitoba, Ontario, Newfoundland & Labrador, Prince Edward Island

provinces where people have stayed in their quintiles or moved up are: New Brunswick, Nova Scotia, Quebec

provinces where people have stayed in their quintiles or moved down are: Alberta, Saskatchewan */

 bys prov: tab move_prov [aw=WTS_SDLE] //Overall, across the 5 years, Alberta is the province where the most people have gone down a quintile (over 40% !)
 
   * using ppp-adjusted distribution
 bys year fprov: tab move_ppp [aw=WTS_SDLE]
 bys year: tab fprov if move_ppp>0 [aw=WTS_SDLE]
 bys year: tab fprov if move_ppp<0 [aw=WTS_SDLE]
 bys year fprov: tab eq_income_quintile ppp_income_quintile [aw=WTS_SDLE]
 
// Observations: In all provinces, most people have stayed in their quintiles, some moved up and others moved down (at least for some years) EXCEPT for QC where all people have either stayed in their quintiles or moved up.
 
 bys prov: tab move_ppp [aw=WTS_SDLE] //Overall, across years, QC and ON are the ones where the most individuals have moved quintile, which makes sense since they have the largest population shares. 
 
 
*Analysis by city
 tab city if city!=""
 bys city: tab move_ppp [aw=WTS_SDLE]
 bys year city: tab move_ppp [aw=WTS_SDLE]
 bys city: tab eq_income_quintile if move_ppp>0 [aw=WTS_SDLE]
 bys year city: tab eq_income_quintile if move_ppp>0 [aw=WTS_SDLE]
 bys year city: tab eq_income_quintile if move_ppp<0 [aw=WTS_SDLE]
 bys city: tab eq_income_quintile if move_ppp<0 [aw=WTS_SDLE]
// Observations: Many people have moved down in Toronto, Vancouver and Ottawa-Gatineau. Many people have moved up in Quebec, Montreal, Brandon (and a larger proportion of those not living in cities). In New Brunswick it matters whether you live in Fredericton (move down) or Moncton / Saint John (move up). Similar difference between cities can be seen for Ontario and Quebec.
 

 
**#=============================================================================

                            *3.Income differences

**#=============================================================================

* Average differences between nominal income and ppp-adjusted income
gen income_dif_ppp= ppp_income - equivalized_income
bys year: sum income_dif_ppp [aw=WTS_SDLE], detail
bys eq_income_quintile: sum income_dif_ppp [aw=WTS_SDLE] // Pooling across years still quicker to spot main trend but with the limitation that prices are not held constant.
bys year eq_income_quintile: sum income_dif_ppp [aw=WTS_SDLE] // the average absolute difference is the smallest in the 1st quintile and the largest in the 5th quintile (due to the mean being more sensitive to outliers, which are largest in the 5th quintile). 


* Relative differences between nominal income and ppp-adjusted income
gen relative_income_diff= income_dif_ppp/equivalized_income
sum relative_income_diff [aw=WTS_SDLE], detail
bys year: sum relative_income_diff [aw=WTS_SDLE], detail
bys eq_income_quintile: sum relative_income_diff [aw=WTS_SDLE]
bys year eq_income_quintile: sum relative_income_diff [aw=WTS_SDLE] // the relative difference is the smallest in the 5th quintile, and the largest in Q2 and Q3. 

   *by province

 bys year prov: sum relative_income_diff [aw=WTS_SDLE]
 bys prov: sum relative_income_diff [aw=WTS_SDLE] 
 bys prov: sum relative_income_diff [aw=WTS_SDLE] if relative_income_diff>0 
 bys prov: sum relative_income_diff [aw=WTS_SDLE]  if relative_income_diff<0 

/*Observations: 
//Across all years, Quebec, Alberta and British Columbia are the provinces with the largest relative income differences  Quebec, Ontario and Manitoba have the largest positive differences while Ontario, BC and Newfoundland & Labrador are the ones with the largest negative. Thus, Ontario has both the largest positive and negative differences suggestion a broader spatial variation in prices. */
    
	
	*by city
 bys city: sum relative_income_diff [aw=WTS_SDLE]
 bys city: sum relative_income_diff [aw=WTS_SDLE] if relative_income_diff>0 
 bys city: sum relative_income_diff [aw=WTS_SDLE] if relative_income_diff<0 

 bys year city: sum relative_income_diff [aw=WTS_SDLE]
 bys year city: sum relative_income_diff [aw=WTS_SDLE] if relative_income_diff>0 
 bys year city: sum relative_income_diff [aw=WTS_SDLE] if relative_income_diff<0 
 //Observations: Brandon, Cape Breton, Quebec City & Montreal have the largest positive change, while Toronto, Vancouver and Calary are the only ones having a negative relative change, which is modest.


**#=============================================================================

                            *4.Correlations

**#=============================================================================

*Quintiles
 spearman eq_income_quintile eq_prov_income_quintile //Spearman's rho = 0.96
 spearman eq_income_quintile ppp_income_quintile //Spearman's rho = 0.97
 spearman eq_prov_income_quintile ppp_income_quintile //Spearman's rho = 0.96

*Income
 spearman ppp_income equivalized_income //Spearman's rho = 0.99

**#=============================================================================

                            *5.Inequalities

**#=============================================================================
do "do\ineqdeco.do" 


 *per year
forvalues i=2011/2015 {
   di `i'
   di "Regular income"
   ineqdeco equivalized_income if year==`i'
   di "PPP-adjusted income"
   ineqdeco ppp_income if year==`i'
}

 * across all 5 years
 ineqdeco equivalized_income
 ineqdeco ppp_income

/*Observations: 

Overall, for each year, the inequality measures are similar, but there is slighlty more inequality in the regular income measure, as apposed to the ppp-adjusted one:

i. The percentile ratios are slighlty higher when using the regular equivalized income, as opposed to the income which is pseudo PPP-adjusted.
ii. The Gini & Generalized Entropy indices are also slighly higher when using the regular income
iii. The Atksinson indeces are also slighly higher when using the regular income
*/

//@GN: I noticed that the ineqdeco does not have Theil but the command allows for subgroup decomposition (showing within-group vs between-group inequality). E.g.

ineqdeco equivalized_income, bygroup(fprov)
ineqdeco equivalized_income if year==2011, bygroup(fprov)

/* Observations: The within group inequality (within a province) is much larger than the between group inequality (between provinces). The latter is very close to 0*/

*by city:
   *city is a string var, so we must first make it numeric. Destring does not work due to non-numeric values 
   gen cities=.
   replace cities=1 if city== "Brandon"
   replace cities=2 if city=="Calgary"
   replace cities=3 if city=="Cape Breton"
   replace cities=4 if city=="Charlottetown"
   replace cities=5 if city=="Edmonton"
   replace cities=6 if city=="Fredericton"   
   replace cities=7 if city=="Halifax"
   replace cities=8 if city=="Hamilton/Burlington"
   replace cities=9 if city=="Moncton"
   replace cities=10 if city=="Montreal"
   replace cities=11 if city=="Ottawa-Gatineau"
   replace cities=12 if city=="Quebec"  
   replace cities=13 if city=="Regina"
   replace cities=14 if city=="Saint John"
   replace cities=15 if city=="Saskatoon"
   replace cities=16 if city=="St Johns"   
   replace cities=17 if city=="Toronto"
   replace cities=18 if city=="Vancouver"
   replace cities=19 if city=="Winnipeg"
tab cities
   
ineqdeco equivalized_income if year==2011, bygroup(cities)

/* Observations: Similarly, the within group inequality (within a city) is  larger than the between group inequality (between cities). The latter is close to 0*/

**#=============================================================================

                        *6.Bottom and top ends of the distribution

**#=============================================================================

* Low-income measure

  * based on national distribution

  gen lim=0 if equivalized_income!=.
  sum equivalized_income [aw=WTS_SDLE] , detail
  replace lim=1 if equivalized_income< r(p50)/2  
  tab lim [aw=WTS_SDLE]
  

  * based on ppp-adjusted distribtion
  gen ppp_lim=0 if ppp_income!=.
  sum ppp_income [aw=WTS_SDLE] , detail
  replace ppp_lim=1 if ppp_income<r(p50)/2 
  
  tab ppp_lim [aw=WTS_SDLE]
  
  tab ppp_lim lim [aw=WTS_SDLE]
  
  //Observation: the LIM rate is higher when using the PPP-adjusted LIM
  
  
  * analysis by province of residence

    levelsof fprov, local(provs)
    foreach p of local provs {
	di "-> fprov = `: label (fprov)`p''" 
       tab lim [aw=WTS_SDLE] if fprov==`p'
       tab ppp_lim [aw=WTS_SDLE]   if fprov==`p'
	   tab lim ppp_lim [aw=WTS_SDLE]   if fprov==`p'
    }

  //Observation: for each province, the LIM rate is higher when using the PPP-adjusted LIM by around 1-2 percentage points
  
  
  * analysis in cities
  
     levelsof city, local(cities)
    foreach c of local cities {
	di "`c'" 
       tab lim [aw=WTS_SDLE] if city=="`c'"
       tab ppp_lim [aw=WTS_SDLE]   if city=="`c'"
	   tab lim ppp_lim [aw=WTS_SDLE]   if city=="`c'"
    }
  
   //Observation: Similarly, in each city, the LIM rate is higher when using the PPP-adjusted LIM by around 1-2 percentage points
  
*  MBM deprivation (share of individuals with income below MBM)
  gen mbm_poor=0 if  equivalized_income!=.
  replace mbm_poor=1 if equivalized_income<mbm/2  // here we divide by 2 (sqr of 4) because the MBM is measured for a family of 4. We thus divide it by our equivalence scale.
  tab mbm_poor [aw=WTS_SDLE]
  
  gen ppp_mbm_poor=0 if  ppp_income!=.
  replace ppp_mbm_poor=1 if ppp_income<mbm_ref/2
  tab ppp_mbm_poor [aw=WTS_SDLE] // we get virtually the same result when using the PPP-adjusted income and reference MBM, with slight differences due to sample size difference
  
  
* Richest 10% 

 * Creating national income deciles based on equivalized income

forvalues i = 1/5 {
	xtile eq_income_decile_201`i' = equivalized_income [aw=WTS_SDLE] if year==201`i', nq(10)
} 

gen eq_income_decile=.
forvalues i = 1/5 {
	replace eq_income_decile= eq_income_decile_201`i'  if year==201`i'
}

bys year: tab eq_income_decile [aw=WTS_SDLE]


 * Creating PPP-adjusted income deciles

forvalues i = 1/5 {
	xtile ppp_income_decile_201`i' = ppp_income [pw=WTS_SDLE] if year==201`i', nq(10)
} 

gen ppp_income_decile=.
forvalues i = 1/5 {
	replace ppp_income_decile= ppp_income_decile_201`i'  if year==201`i'
}

bys year: tab ppp_income_decile [aw=WTS_SDLE]

 * checking where the richest 10% live
bys year: tab province if eq_income_decile==10 // richest 10 percent according to the national distribtion mostly live in Ontario, Alberta (increasingly), and BC 
bys year: tab city if eq_income_decile==10 // richest 10 percent according to the national distribtion mostly live in the cities of Toronto, Vancouver, Calgary and Edmonton

bys year: tab province if ppp_income_decile==10 // richest 10 percent when adjusting for PPP mostly live in Ontario, Alberta, and Quebec 
bys year: tab city if ppp_income_decile==10 // richest 10 percent when adjusting for PPP mostly live in the cities of Toronto, Montreal and Vancouver

**#=============================================================================

                        *7. Health

**#=============================================================================

 * Health perception
 
bys year: tab GEN_01 [aw=WTS_SDLE]
bys year: tab GEN_05 [aw=WTS_SDLE]
bys year: tab GEN_10 [aw=WTS_SDLE]

* Generating health binary (poor-good)
gen health=. 
replace health=0 if GEN_01 == 4 | GEN_01==5 // poor health
replace health=1 if GEN_01==1 | GEN_01== 2 | GEN_01== 3 // good health
lab def good 1 Good 0 Bad
lab val health good
tab health [aw=WTS_SDLE], m

gen mental_health=.
replace mental_health=0 if GEN_05 ==4 | GEN_05==5 // poor health
replace mental_health=1 if GEN_05 ==1 | GEN_05==2 | GEN_05==3 // good health
lab val mental_health good
tab mental_health [aw=WTS_SDLE], m

gen stress=.
replace stress=1 if GEN_10==4 | GEN_10==5 // lot of stress
replace stress=0 if GEN_10==1 | GEN_10==2 | GEN_10==3 // not a lot of stress
lab def stress 1 "High stress" 0 "Low stress"
lab val stress stress 
tab stress [aw=WTS_SDLE], m

* Health and income
bys year: tab health eq_income_quintile [aw=WTS_SDLE]
bys year: tab health ppp_income_quintile [aw=WTS_SDLE]

bys year: tab mental_health eq_income_quintile [aw=WTS_SDLE]
bys year: tab mental_health ppp_income_quintile [aw=WTS_SDLE]

bys year: tab stress eq_income_quintile [aw=WTS_SDLE]
bys year: tab stress ppp_income_quintile [aw=WTS_SDLE]

// observation: Health and mental health both get better as we move up the income quintiles. On the other hand, stress follows a U-shape pattern, with highest levels of stress in the 5th quintile

   * by province
bys year fprov: tab health  [aw=WTS_SDLE]
bys year fprov: tab mental_health  [aw=WTS_SDLE]
bys year fprov: tab stress  [aw=WTS_SDLE]

//observation: Health is worse in NB and NS. Mental health is best in QC, but at the same time, stress is the worst in QC.
    
bys year fprov: tab health eq_income_quintile [aw=WTS_SDLE]
bys year fprov: tab health ppp_income_quintile [aw=WTS_SDLE]

bys year fprov: tab mental_health eq_income_quintile [aw=WTS_SDLE]
bys year fprov: tab mental_health ppp_income_quintile [aw=WTS_SDLE]

bys year fprov: tab stress eq_income_quintile [aw=WTS_SDLE]
bys year fprov: tab stress ppp_income_quintile [aw=WTS_SDLE]


   * by city
bys year city: tab health  [aw=WTS_SDLE]
bys year city: tab mental_health  [aw=WTS_SDLE]
bys year city: tab stress  [aw=WTS_SDLE]

//observation: Worst health:  Mocton and Cape Breton, and best health: Quebec city. Mental health is comparable everywhere but best in Quebec city and Montreal. Stress is highest in Montreal, Quebec city and Saint John (increasingly)  
    
bys year city: tab health eq_income_quintile [aw=WTS_SDLE]
bys year city: tab health ppp_income_quintile [aw=WTS_SDLE]

bys year city: tab mental_health eq_income_quintile [aw=WTS_SDLE]
bys year city: tab mental_health ppp_income_quintile [aw=WTS_SDLE]

bys year city: tab stress eq_income_quintile [aw=WTS_SDLE]
bys year city: tab stress ppp_income_quintile [aw=WTS_SDLE]


* Graphs

graph bar health [aw=WTS_SDLE], over(eq_income_quintile) 
graph bar health [aw=WTS_SDLE], over(ppp_income_quintile) 


graph bar mental_health [aw=WTS_SDLE], over(eq_income_quintile)
graph bar mental_health [aw=WTS_SDLE], over(ppp_income_quintile) 


graph bar stress [aw=WTS_SDLE], over(eq_income_quintile) 
graph bar stress [aw=WTS_SDLE], over(ppp_income_quintile) 

*-------------------------------------------------------------------------------

save "T:\Projet 10629\node4\stata\data\3.descriptives.dta", replace
log close

