/*******************************************************************************
Project: CSDUL
Authors:  M. Sene; G. Notten
Latest update: 19-11-2025
Purpose: Extracting descriptive statistics

Data:   3.descriptives.dta

Output: 4.descriptives_output.dta
        stata\table\4.*.xlsx

********************************************************************************
TABLES OF CONTENT

   - 0. Setup
   - 2. Quintile movements
   - 3. Income differences
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
log using "log\4.descriptives_output_new.log", replace

//open dataset
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear

// installing xcontract command
do "do\xcontract.do"
do "do\freqtop.do"


*===============================================================================

**#                        *2.Quintiles movements

*===============================================================================

* Proportion and absolute number of people moving up/down

  
 // national vs provincial distribution 
    *percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear
bys year: tab move_prov [iw=WTS_SDLE] 
xcontract move_prov [aw=WTS_SDLE], fast by(year) nomiss  p(percent)
gen flag=1 if _freq<15
drop if flag==1
drop _freq
format _all  %9.1f
export excel "table\4.2.quintile_movement.xlsx", firstrow(varl) sheet("Provincial vs national", replace)  

    * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear
bys year: tab move_prov 
xcontract move_prov , fast by(year) nomiss  p(percent)
drop percent
gen flag=1 if _freq<15
drop if flag==1
export excel "table\4.2.quintile_movement_freq.xlsx", firstrow(varl) sheet("Provincial vs national", replace)  
 
  // national vs ppp-adjusted distribution
  
    * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear
bys year: tab move_ppp [iw=WTS_SDLE]
xcontract move_ppp [aw=WTS_SDLE], fast by(year) nomiss p(percent)
gen flag=1 if _freq<15
drop if flag==1
drop _freq
format _all  %9.1f
export excel "table\4.2.quintile_movement.xlsx", firstrow(varl) sheet("PPP vs national", replace)   

   * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear
bys year: tab move_prov 
xcontract move_prov, fast by(year) nomiss  p(percent)
drop percent
gen flag=1 if _freq<15
drop if flag==1
export excel "table\4.2.quintile_movement_freq.xlsx", firstrow(varl) sheet("PPP vs national", replace)

 * by income quintile
 
  // national vs provincial distribution
   * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear
bys year eq_income_quintile: tab move_prov [iw=WTS_SDLE]
xcontract move_prov [aw=WTS_SDLE], fast by(year eq_income_quintile) nomiss p(percent)
gen flag=1 if _freq<15
drop if flag==1
drop _freq
format _all  %9.1f
export excel "table\4.2.quintile_movement.xlsx", firstrow(varl) sheet("Prov vs national - by quintile", replace)

   * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear
bys year eq_income_quintile: tab move_prov 
xcontract move_prov, fast by(year eq_income_quintile) nomiss  p(percent)
drop percent
gen flag=1 if _freq<15
drop if flag==1
export excel "table\4.2.quintile_movement_freq.xlsx", firstrow(varl) sheet("Prov vs national - by quintile ", replace)

// national vs ppp-adjusted distribution
   * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear
bys year eq_income_quintile: tab move_ppp [iw=WTS_SDLE] 
xcontract move_ppp [aw=WTS_SDLE], fast by(year eq_income_quintile) nomiss p(percent)
gen flag=1 if _freq<15
drop if flag==1
drop _freq
format _all  %9.1f
export excel "table\4.2.quintile_movement.xlsx", firstrow(varl) sheet("PPP vs national - by quintile", replace) 

   * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear
bys year eq_income_quintile: tab move_ppp 
xcontract move_ppp , fast by(year eq_income_quintile) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
drop if flag==1
export excel "table\4.2.quintile_movement_freq.xlsx", firstrow(varl) sheet("PPP vs national - by quintile", replace) 

* Analysis by province

  // national vs provincial distribution
  
    * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear
bys year fprov: tab move_prov [iw=WTS_SDLE]  
xcontract move_prov [aw=WTS_SDLE], fast by(year fprov) nomiss p(percent)
gen flag=1 if _freq<15
drop if flag==1
drop _freq
format _all  %9.1f
export excel "table\4.2.quintile_movement.xlsx", firstrow(varl) sheet("Prov vs national - by province", replace)

   * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear
bys year fprov: tab move_prov   
xcontract move_prov , fast by(year fprov) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
drop if flag==1
export excel "table\4.2.quintile_movement_freq.xlsx", firstrow(varl) sheet("Prov vs national - by province", replace)

   // national vs ppp-adjusted distribution 
     
	 * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear  
bys year fprov: tab move_ppp [iw=WTS_SDLE]
xcontract move_ppp [aw=WTS_SDLE], fast by(year fprov) nomiss p(percent)
gen flag=1 if _freq<15
drop if flag==1
drop _freq
format _all  %9.1f
export excel "table\4.2.quintile_movement.xlsx", firstrow(varl) sheet("PPP vs national - by province", replace)

    * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear
bys year fprov: tab move_ppp  
xcontract move_ppp, fast by(year fprov) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
drop if flag==1
export excel "table\4.2.quintile_movement_freq.xlsx", firstrow(varl) sheet("PPP vs national - by province", replace)

*Analysis by city

  // national vs provincial distribution
    * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear
bys year city: tab move_prov [iw=WTS_SDLE]  
xcontract move_prov [aw=WTS_SDLE] if city=="Montreal" | city== "Vancouver" | city=="Toronto" , fast by(year city) nomiss p(percent)
gen flag=1 if _freq<15
drop if flag==1
drop _freq
format percent  %9.1f
export excel "table\4.2.quintile_movement.xlsx", firstrow(varl) sheet("Prov vs national - by city", replace)

   * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear
bys year city: tab move_prov   
xcontract move_prov  if city=="Montreal" | city== "Vancouver" | city=="Toronto", fast by(year city) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
drop if flag==1
export excel "table\4.2.quintile_movement_freq.xlsx", firstrow(varl) sheet("Prov vs national - by city", replace)

   // national vs ppp-adjusted distribution 
   *percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear  
bys year city: tab move_ppp [iw=WTS_SDLE]
xcontract move_ppp [aw=WTS_SDLE]  if city=="Montreal" | city== "Vancouver" | city=="Toronto", fast by(year city) nomiss p(percent)
gen flag=1 if _freq<15
drop if flag==1
drop _freq
format percent  %9.1f
export excel "table\4.2.quintile_movement.xlsx", firstrow(varl) sheet("PPP vs national - by city", replace) 

   * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear  
bys year city: tab move_ppp 
xcontract move_ppp  if city=="Montreal" | city== "Vancouver" | city=="Toronto", fast by(year city) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
drop if flag==1
export excel "table\4.2.quintile_movement_freq.xlsx", firstrow(varl) sheet("PPP vs national - by city", replace)   
 
*===============================================================================

**#                        *3.Income differences

*===============================================================================

// Note : for the measures below, I always collapsed to report the average differences


* Average differences between nominal income and ppp-adjusted income

 // Overall
  *percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear  
xcontract income_dif_ppp [aw=WTS_SDLE], fast by(year) nomiss p(percent)
collapse  income_dif_ppp, by(year)
gen income_diff_ppp_rounded = round(income_dif_ppp, 100)
drop income_dif_ppp
format _all  %9.1f
export excel "table\4.3.income_differences.xlsx", firstrow(varl) sheet("Average diff (absolute)", replace)

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear  
xcontract income_dif_ppp , fast by(year) nomiss p(percent)
collapse (count) income_dif_ppp, by(year)  
export excel "table\4.3.income_differences_freq.xlsx", firstrow(varl) sheet("Average diff (absolute)", replace)  


  // By quintile
  * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear  
xcontract income_dif_ppp [aw=WTS_SDLE], fast by(year eq_income_quintile) nomiss p(percent)
collapse income_dif_ppp, by(year eq_income_quintile) 
gen income_diff_ppp_rounded = round(income_dif_ppp, 100)
drop income_dif_ppp
format _all  %9.1f
export excel "table\4.3.income_differences.xlsx", firstrow(varl) sheet("Average (absolute)- by quintile", replace)


  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear  
xcontract income_dif_ppp, fast by(year eq_income_quintile) nomiss p(percent)
collapse (count) income_dif_ppp, by(year eq_income_quintile)
export excel "table\4.3.income_differences_freq.xlsx", firstrow(varl) sheet("Average (absolute)- by quintile", replace) 
  

* Relative differences between nominal income and ppp-adjusted income
 //Overall
  * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear  
xcontract relative_income_diff [aw=WTS_SDLE], fast by(year) nomiss p(percent)
collapse relative_income_diff, by(year)
format _all  %9.1f
export excel "table\4.3.income_differences.xlsx", firstrow(varl) sheet("Average diff (Relative) ", replace)

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear  
xcontract relative_income_diff, fast by(year) nomiss p(percent)
collapse (count) relative_income_diff, by(year) 
export excel "table\4.3.income_differences_freq.xlsx", firstrow(varl) sheet("Average diff (Relative)", replace)

 // By quintile
  * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear  
xcontract relative_income_diff eq_income_quintile [aw=WTS_SDLE], fast by(year eq_income_quintile) nomiss p(percent)
collapse relative_income_diff, by(year eq_income_quintile)
format _all  %9.1f
export excel "table\4.3.income_differences.xlsx", firstrow(varl) sheet("Relative diff - by quintile", replace)

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear  
xcontract relative_income_diff eq_income_quintile, fast by(year eq_income_quintile) nomiss p(percent)
collapse (count) relative_income_diff, by(year eq_income_quintile)
export excel "table\4.3.income_differences_freq.xlsx", firstrow(varl) sheet("Relative diff - by quintile", replace)
  
  
   //by province
     * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear  
bys year fprov: sum relative_income_diff [iw=WTS_SDLE]
xcontract relative_income_diff [aw=WTS_SDLE], fast by(year fprov) nomiss p(percent)
collapse relative_income_diff, by(year fprov)
format _all  %9.1f
export excel "table\4.3.income_differences.xlsx", firstrow(varl) sheet("Relative diff - by province", replace) 

     * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear  
bys year fprov: sum relative_income_diff
xcontract relative_income_diff, fast by(year fprov) nomiss p(percent)
collapse (count) relative_income_diff, by(year fprov)
export excel "table\4.3.income_differences_freq.xlsx", firstrow(varl) sheet("Relative diff - by province", replace) 
	


*===============================================================================

**#                      *7. Health

*===============================================================================
 
** Overview
 // health
 * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year : tab health  [aw=WTS_SDLE]
xcontract health [aw=WTS_SDLE] , fast by(year) nomiss p(percent)
gen flag=1 if _freq<15
drop if flag==1
drop _freq
format _all  %9.1f
export excel  "table\4.7.health.xlsx", firstrow(varl) sheet("Summary - health", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year : tab health
xcontract health , fast by(year) nomiss p(percent)
gen flag=1 if _freq<15
drop if flag==1
drop percent
export excel  "table\4.7.health_freq.xlsx", firstrow(varl) sheet("Summary - health", replace) 

 // mental health

  * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year : tab mental_health  [aw=WTS_SDLE]
xcontract mental_health [aw=WTS_SDLE] , fast by(year) nomiss p(percent)
gen flag=1 if _freq<15
drop if flag==1
drop _freq
format _all  %9.1f
export excel  "table\4.7.health.xlsx", firstrow(varl) sheet("Summary - mental health", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year : tab health
xcontract mental_health , fast by(year) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
drop if flag==1
export excel  "table\4.7.health_freq.xlsx", firstrow(varl) sheet("Summary - mental health", replace) 

 // stress
  * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year : tab stress  [aw=WTS_SDLE]
xcontract stress [aw=WTS_SDLE] , fast by(year) nomiss p(percent)
gen flag=1 if _freq<15
drop if flag==1
drop _freq
format _all  %9.1f
export excel  "table\4.7.health.xlsx", firstrow(varl) sheet("Summary - stress", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year : tab stress
xcontract stress , fast by(year) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
drop if flag==1
export excel  "table\4.7.health_freq.xlsx", firstrow(varl) sheet("Summary - stress", replace) 



** Health and income (national distr)
 
 // health
 * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year : tab health eq_income_quintile [aw=WTS_SDLE]
xcontract health eq_income_quintile [aw=WTS_SDLE] , fast by(year) nomiss p(percent)
gen flag=1 if _freq<15
drop if flag==1
drop _freq
format _all  %9.1f
export excel  "table\4.7.health.xlsx", firstrow(varl) sheet("health by quintile", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year : tab health eq_income_quintile
xcontract health eq_income_quintile, fast by(year) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
drop if flag==1
export excel  "table\4.7.health_freq.xlsx", firstrow(varl) sheet("health by quintile", replace) 

 //mental health
 * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year : tab mental_health eq_income_quintile [aw=WTS_SDLE]
xcontract mental_health eq_income_quintile [aw=WTS_SDLE] , fast by(year) nomiss p(percent)
gen flag=1 if _freq<15
drop if flag==1
drop _freq
format _all  %9.1f
export excel  "table\4.7.health.xlsx", firstrow(varl) sheet("mental health by quintile", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year : tab mental_health eq_income_quintile
xcontract mental_health eq_income_quintile, fast by(year) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
drop if flag==1
export excel  "table\4.7.health_freq.xlsx", firstrow(varl) sheet("mental health by quintile", replace) 

//stress

 * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year : tab stress eq_income_quintile [aw=WTS_SDLE]
xcontract stress eq_income_quintile [aw=WTS_SDLE] , fast by(year) nomiss p(percent)
gen flag=1 if _freq<15
drop if flag==1
drop _freq
format _all  %9.1f
export excel  "table\4.7.health.xlsx", firstrow(varl) sheet("stress by quintile", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year : tab stress eq_income_quintile
xcontract stress eq_income_quintile, fast by(year) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
drop if flag==1
export excel  "table\4.7.health_freq.xlsx", firstrow(varl) sheet("stress by quintile", replace) 

** Health and income (PPP distr)

 // health
  * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year : tab health ppp_income_quintile  [aw=WTS_SDLE]
xcontract health ppp_income_quintile [aw=WTS_SDLE] , fast by(year) nomiss p(percent)
gen flag=1 if _freq<15
drop if flag==1
drop _freq
format _all  %9.1f
export excel  "table\4.7.health.xlsx", firstrow(varl) sheet("health by PPP quintile", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year : tab health ppp_income_quintile
xcontract health ppp_income_quintile, fast by(year) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
drop if flag==1
export excel  "table\4.7.health_freq.xlsx", firstrow(varl) sheet("health by PPP quintile", replace) 

 // mental health

  * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year : tab mental_health ppp_income_quintile  [aw=WTS_SDLE]
xcontract mental_health ppp_income_quintile [aw=WTS_SDLE] , fast by(year) nomiss p(percent)
gen flag=1 if _freq<15
drop if flag==1
drop _freq
format _all  %9.1f
export excel  "table\4.7.health.xlsx", firstrow(varl) sheet("mental health by PPP quintile", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year : tab mental_health ppp_income_quintile
xcontract mental_health ppp_income_quintile, fast by(year) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
drop if flag==1
export excel  "table\4.7.health_freq.xlsx", firstrow(varl) sheet("mental health by PPP quintile", replace) 

 // stress

  * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year : tab stress ppp_income_quintile [aw=WTS_SDLE]
xcontract stress ppp_income_quintile [aw=WTS_SDLE] , fast by(year) nomiss p(percent)
gen flag=1 if _freq<15
drop if flag==1
drop _freq
format _all  %9.1f
export excel  "table\4.7.health.xlsx", firstrow(varl) sheet("stress by PPP quintile", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year : tab stress ppp_income_quintile
xcontract stress ppp_income_quintile, fast by(year) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
drop if flag==1
export excel  "table\4.7.health_freq.xlsx", firstrow(varl) sheet("stress by PPP quintile", replace) 


* Health and income by province (national distr)
 // health 
 * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year fprov: tab health eq_income_quintile [aw=WTS_SDLE]
xcontract health eq_income_quintile [aw=WTS_SDLE] , fast by(year fprov) nomiss p(percent)
gen flag=1 if _freq<15
drop if flag==1
drop _freq
format _all  %9.1f
export excel  "table\4.7.health.xlsx", firstrow(varl) sheet("health by quintile - prov", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year fprov: tab health eq_income_quintile
xcontract health eq_income_quintile, fast by(year fprov) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
drop if flag==1
export excel  "table\4.7.health_freq.xlsx", firstrow(varl) sheet("health by quintile - prov", replace) 

 // mental health

 * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year fprov: tab mental_health eq_income_quintile [aw=WTS_SDLE]
xcontract mental_health eq_income_quintile [aw=WTS_SDLE] , fast by(year fprov) nomiss p(percent)
gen flag=1 if _freq<15
drop if flag==1
drop _freq
format _all  %9.1f
export excel  "table\4.7.health.xlsx", firstrow(varl) sheet("mental health by quint - prov", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year fprov: tab mental_health eq_income_quintile
xcontract mental_health eq_income_quintile, fast by(year fprov) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
drop if flag==1
export excel  "table\4.7.health_freq.xlsx", firstrow(varl) sheet("mental health by quint- prov", replace) 

 // stress

  * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year fprov: tab health ppp_income_quintile  [aw=WTS_SDLE]
xcontract health ppp_income_quintile [aw=WTS_SDLE] , fast by(year fprov) nomiss p(percent)
gen flag=1 if _freq<15
drop if flag==1
drop _freq
format _all  %9.1f
export excel  "table\4.7.health.xlsx", firstrow(varl) sheet("health by PPP quintile - prov", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year fprov: tab health ppp_income_quintile
xcontract health ppp_income_quintile, fast by(year fprov) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
drop if flag==1
export excel  "table\4.7.health_freq.xlsx", firstrow(varl) sheet("health by PPP quintile - prov", replace) 

* Health and income by province (PPP distr)
 // health 
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year fprov: tab health ppp_income_quintile  [aw=WTS_SDLE]
xcontract health ppp_income_quintile [aw=WTS_SDLE] , fast by(year fprov) nomiss p(percent)
gen flag=1 if _freq<15
drop if flag==1
drop _freq
format _all  %9.1f
export excel  "table\4.7.health.xlsx", firstrow(varl) sheet(" health PPP quint - prov", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year fprov: tab health ppp_income_quintile
xcontract health ppp_income_quintile, fast by(year fprov) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
drop if flag==1
export excel  "table\4.7.health_freq.xlsx", firstrow(varl) sheet("health PPP quint- prov", replace)

 // mental health
  * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year fprov: tab mental_health ppp_income_quintile  [aw=WTS_SDLE]
xcontract mental_health ppp_income_quintile [aw=WTS_SDLE] , fast by(year fprov) nomiss p(percent)
gen flag=1 if _freq<15
drop if flag==1
drop _freq
format _all  %9.1f
export excel  "table\4.7.health.xlsx", firstrow(varl) sheet("mental health PPP quint - prov", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year fprov: tab mental_health ppp_income_quintile
xcontract mental_health ppp_income_quintile, fast by(year fprov) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
drop if flag==1
export excel  "table\4.7.health_freq.xlsx", firstrow(varl) sheet("mental health PPP quint- prov", replace) 

 
 // stress

  * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year fprov: tab stress ppp_income_quintile [aw=WTS_SDLE]
xcontract stress ppp_income_quintile [aw=WTS_SDLE] , fast by(year fprov) nomiss p(percent)
gen flag=1 if _freq<15
drop if flag==1
drop _freq
format _all  %9.1f
export excel  "table\4.7.health.xlsx", firstrow(varl) sheet("stress by PPP quintile - prov", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year fprov: tab stress ppp_income_quintile
xcontract stress ppp_income_quintile, fast by(year fprov) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
drop if flag==1
export excel  "table\4.7.health_freq.xlsx", firstrow(varl) sheet("stress by PPP quintile - prov ", replace) 


** Health and income by city (national distr)

 //health
 * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year city: tab health eq_income_quintile [aw=WTS_SDLE]
xcontract health eq_income_quintile [aw=WTS_SDLE]  if city=="Montreal" | city== "Vancouver" | city=="Toronto", fast by(year city) nomiss p(percent)
gen flag=1 if _freq<15
drop if flag==1
drop _freq
format percent  %9.1f
export excel  "table\4.7.health.xlsx", firstrow(varl) sheet("health by quintile - city", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year city: tab health eq_income_quintile
xcontract health eq_income_quintile  if city=="Montreal" | city== "Vancouver" | city=="Toronto", fast by(year city) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
drop if flag==1
export excel  "table\4.7.health_freq.xlsx", firstrow(varl) sheet("health by quintile - city", replace) 

 // mental health

 * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year city: tab mental_health eq_income_quintile [aw=WTS_SDLE]
xcontract mental_health eq_income_quintile [aw=WTS_SDLE]  if city=="Montreal" | city== "Vancouver" | city=="Toronto", fast by(year city) nomiss p(percent)
gen flag=1 if _freq<15
drop if flag==1
drop _freq
format percent  %9.1f
export excel  "table\4.7.health.xlsx", firstrow(varl) sheet("mental health by quint - city", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year city: tab mental_health eq_income_quintile
xcontract mental_health eq_income_quintile  if city=="Montreal" | city== "Vancouver" | city=="Toronto", fast by(year city) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
drop if flag==1
export excel  "table\4.7.health_freq.xlsx", firstrow(varl) sheet("mental health by quint- city", replace) 

 // stress
 * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year city: tab stress eq_income_quintile [aw=WTS_SDLE]
xcontract stress eq_income_quintile [aw=WTS_SDLE]  if city=="Montreal" | city== "Vancouver" | city=="Toronto", fast by(year city) nomiss p(percent)
gen flag=1 if _freq<15
drop if flag==1
drop _freq
format percent  %9.1f
export excel  "table\4.7.health.xlsx", firstrow(varl) sheet("stress by quintile - city", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year city: tab stress eq_income_quintile
xcontract stress eq_income_quintile  if city=="Montreal" | city== "Vancouver" | city=="Toronto", fast by(year city) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
drop if flag==1
export excel  "table\4.7.health_freq.xlsx", firstrow(varl) sheet("stress by quintile - city", replace) 

** Health and income by city (PPP distr)

 // health
  * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year city: tab health ppp_income_quintile  [aw=WTS_SDLE]
xcontract health ppp_income_quintile [aw=WTS_SDLE]  if city=="Montreal" | city== "Vancouver" | city=="Toronto", fast by(year city) nomiss p(percent)
gen flag=1 if _freq<15
drop if flag==1
drop _freq
format percent  %9.1f
export excel  "table\4.7.health.xlsx", firstrow(varl) sheet("health by PPP quintile - city", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year city: tab health ppp_income_quintile
xcontract health ppp_income_quintile  if city=="Montreal" | city== "Vancouver" | city=="Toronto", fast by(year city) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
drop if flag==1
export excel  "table\4.7.health_freq.xlsx", firstrow(varl) sheet("health by PPP quintile - city", replace) 

 // mental health

  * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year city: tab mental_health ppp_income_quintile  [aw=WTS_SDLE]
xcontract mental_health ppp_income_quintile [aw=WTS_SDLE]  if city=="Montreal" | city== "Vancouver" | city=="Toronto", fast by(year city) nomiss p(percent)
gen flag=1 if _freq<15
drop if flag==1
drop _freq
format percent  %9.1f
export excel  "table\4.7.health.xlsx", firstrow(varl) sheet("mental health PPP quint - city", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year fprov: tab mental_health ppp_income_quintile
xcontract mental_health ppp_income_quintile  if city=="Montreal" | city== "Vancouver" | city=="Toronto", fast by(year city) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
drop if flag==1
export excel  "table\4.7.health_freq.xlsx", firstrow(varl) sheet("mental health PPP quint- city", replace) 

 //stress

  * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year fprov: tab stress ppp_income_quintile [aw=WTS_SDLE]
xcontract stress ppp_income_quintile [aw=WTS_SDLE]  if city=="Montreal" | city== "Vancouver" | city=="Toronto", fast by(year city) nomiss p(percent)
gen flag=1 if _freq<15
drop if flag==1
drop _freq
format percent  %9.1f
export excel  "table\4.7.health.xlsx", firstrow(varl) sheet("stress by PPP quintile - city", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year fprov: tab stress ppp_income_quintile
xcontract stress ppp_income_quintile  if city=="Montreal" | city== "Vancouver" | city=="Toronto", fast by(year city) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
drop if flag==1
export excel  "table\4.7.health_freq.xlsx", firstrow(varl) sheet("stress by PPP quintile - city ", replace) 




*-----------------------------------------------------------------------------

log close


