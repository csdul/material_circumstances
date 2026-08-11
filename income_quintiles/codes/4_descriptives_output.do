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
   - 1. Overview
   - 2. Quintile movements
   - 3. Income differences
   - 4. Correlations
   - 5. Inequalities
   - 6. Bottom and top ends of the distribution   


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
log using "log\4.descriptives_output.log", replace

//open dataset
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear

// installing xcontract command
do "do\xcontract.do"
do "do\freqtop.do"



*===============================================================================

**#                           *1.Overview

*===============================================================================
 

  tab year if family_income<.
  tab year if family_income<. [aw=WTS_SDLE]
  tab year if family_income<. [iw=WTS_SDLE]
  
** Count of people by province (rounded)
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear
tab year if family_income<. [aw=WTS_SDLE]
xcontract year if family_income<. [aw=WTS_SDLE], fast nomiss p(percent)
drop percent
gen freq_rounded = round(_freq, 1000)
format freq_rounded  %12.0g
drop _freq
export excel "table\4.1.income_quintile.xls", firstrow(varlabels) sheet("Descriptives - totals", replace)  

** Count of people by province (unrounded)
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear
tab year if family_income<. [aw=WTS_SDLE]
xcontract year if family_income<. [aw=WTS_SDLE], fast nomiss p(percent)
drop percent
export excel "table\4.1.income_quintile_unrounded.xls", firstrow(varlabels) sheet("Descriptives - totals", replace)  

** Count of people by province (rounded)
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear
bys year: tab fprov [aw=WTS_SDLE]
xcontract fprov [aw=WTS_SDLE], fast by(year) nomiss p(percent)
gen flag=.
replace flag=1 if _freq<15
format percent  %9.1f
gen freq_rounded = round(_freq, 1000)
format freq_rounded  %12.0g
drop _freq
export excel "table\4.1.income_quintile.xls", firstrow(varlabels) sheet("Descriptives - by province", replace)    
  
** Count of people by province (unrounded)
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear
bys year: tab fprov [aw=WTS_SDLE]
xcontract fprov [aw=WTS_SDLE], fast by(year) nomiss p(percent)
gen flag=.
replace flag=1 if _freq<15
format _all  %9.1f
export excel "table\4.1.income_quintile_unrounded.xls", firstrow(varlabels) sheet("Descriptives - by province", replace)  
  

** Describing income quintiles (by prov)

 // Quintiles - by province
 * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear
bys year: tab fprov eq_income_quintile [aw=WTS_SDLE], cell nofreq
xcontract fprov eq_income_quintile [aw=WTS_SDLE], fast by(year eq_income_quintile) nomiss p(percent)
drop _freq
format _all  %9.1f
export excel "table\4.1.income_quintile.xls", firstrow(varlabels) sheet("Quintiles - by province", replace)

 * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear
bys year: tab fprov eq_income_quintile , cell nofreq
xcontract fprov eq_income_quintile, fast by(year eq_income_quintile) nomiss p(percent)
drop percent
gen flag=.
replace flag=1 if _freq<15
export excel "table\4.1.income_quintile_freq.xls", firstrow(varlabels) sheet("Quintiles - by province", replace)

 //PPP quintiles - by province
 * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear
bys year: tab fprov ppp_income_quintile [aw=WTS_SDLE], cell nofreq
xcontract fprov ppp_income_quintile [aw=WTS_SDLE], fast by(year ppp_income_quintile) nomiss p(percent)
drop _freq
format _all  %9.1f
export excel "table\4.1.income_quintile.xls", firstrow(varlabels) sheet("PPP quintiles - by province", replace)
 
 * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear
bys year: tab fprov ppp_income_quintile , cell nofreq
xcontract fprov ppp_income_quintile , fast by(year ppp_income_quintile) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
export excel "table\4.1.income_quintile_freq.xls", firstrow(varlabels) sheet("PPP quintiles - by province", replace)  
 

 
* Comparing quintiles distributions with the others (who's moving up/down)

 // PPP vs national
 
 * percentages
 use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear
 bys year: tab ppp_income_quintile eq_income_quintile [iw=WTS_SDLE], cell nofreq
 xcontract ppp_income_quintile eq_income_quintile [aw=WTS_SDLE], fast by(year)  nomiss  p(percent)
 drop _freq
 format _all  %9.1f
 export excel "table\4.1.quintile_comparison.xls", firstrow(varl) sheet("PPP vs national", replace)
 
 * frequencies
 use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear
 bys year: tab ppp_income_quintile eq_income_quintile, cell nofreq
 xcontract ppp_income_quintile eq_income_quintile, fast by(year)  nomiss  p(percent)
 drop percent
 gen flag=1 if _freq<15
 export excel "table\4.1.quintile_comparison_freq.xls", firstrow(varl) sheet("PPP vs national", replace)
 
 // PPP vs provincial 
 
 * percentages
 use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear
 tab ppp_income_quintile eq_prov_income_quintile [aw=WTS_SDLE], cell nofreq 
 xcontract ppp_income_quintile eq_prov_income_quintile [aw=WTS_SDLE], fast by(year)  nomiss p(percent)
 drop _freq
 format _all  %9.1f
 export excel "table\4.1.quintile_comparison.xls", firstrow(varl) sheet("PPP vs provincial", replace)
 
 * frequencies
 use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear
 tab ppp_income_quintile eq_prov_income_quintile , cell nofreq 
 xcontract ppp_income_quintile eq_prov_income_quintile, fast by(year)  nomiss p(percent)
 drop percent
 gen flag=1 if _freq<15
 export excel "table\4.1.quintile_comparison_freq.xls", firstrow(varl) sheet("PPP vs provincial", replace) 
 
// Provincial vs national  

 * percentages 
 use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear
 tab eq_prov_income_quintile eq_income_quintile [aw=WTS_SDLE], cell nofreq 
 xcontract eq_prov_income_quintile eq_income_quintile [aw=WTS_SDLE], fast by(year)  nomiss p(percent)
 drop _freq
 format _all  %9.1f
 export excel "table\4.1.quintile_comparison.xls", firstrow(varl) sheet("Provincial vs national", replace)

 * frequencies 
 use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear
 tab eq_prov_income_quintile eq_income_quintile , cell nofreq 
 xcontract eq_prov_income_quintile eq_income_quintile, fast by(year)  nomiss p(percent)
 drop percent
 gen flag=1 if _freq<15
 export excel "table\4.1.quintile_comparison_freq.xls", firstrow(varl) sheet("Provincial vs national", replace)
 
 

*===============================================================================

**#                        *2.Quintiles movements

*===============================================================================

* Proportion and absolute number of people moving up/down

  
 // national vs provincial distribution 
    *percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear
bys year: tab move_prov [iw=WTS_SDLE] 
xcontract move_prov [aw=WTS_SDLE], fast by(year) nomiss  p(percent)
drop _freq
format _all  %9.1f
export excel "table\4.2.quintile_movement.xlsx", firstrow(varl) sheet("Provincial vs national", replace)  

    * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear
bys year: tab move_prov 
xcontract move_prov , fast by(year) nomiss  p(percent)
drop percent
gen flag=1 if _freq<15
export excel "table\4.2.quintile_movement_freq.xlsx", firstrow(varl) sheet("Provincial vs national", replace)  
 
  // national vs ppp-adjusted distribution
  
    * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear
bys year: tab move_ppp [iw=WTS_SDLE]
xcontract move_ppp [aw=WTS_SDLE], fast by(year) nomiss p(percent)
drop _freq
format _all  %9.1f
export excel "table\4.2.quintile_movement.xlsx", firstrow(varl) sheet("PPP vs national", replace)   

   * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear
bys year: tab move_prov 
xcontract move_prov, fast by(year) nomiss  p(percent)
drop percent
gen flag=1 if _freq<15
export excel "table\4.2.quintile_movement_freq.xlsx", firstrow(varl) sheet("PPP vs national", replace)

 * by income quintile
 
  // national vs provincial distribution
   * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear
bys year eq_income_quintile: tab move_prov [iw=WTS_SDLE]
xcontract move_prov [aw=WTS_SDLE], fast by(year eq_income_quintile) nomiss p(percent)
drop _freq
format _all  %9.1f
export excel "table\4.2.quintile_movement.xlsx", firstrow(varl) sheet("Prov vs national - by quintile", replace)

   * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear
bys year eq_income_quintile: tab move_prov 
xcontract move_prov, fast by(year eq_income_quintile) nomiss  p(percent)
drop percent
gen flag=1 if _freq<15
export excel "table\4.2.quintile_movement_freq.xlsx", firstrow(varl) sheet("Prov vs national - by quintile ", replace)

// national vs ppp-adjusted distribution
   * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear
bys year eq_income_quintile: tab move_ppp [iw=WTS_SDLE] 
xcontract move_ppp [aw=WTS_SDLE], fast by(year eq_income_quintile) nomiss p(percent)
drop _freq
format _all  %9.1f
export excel "table\4.2.quintile_movement.xlsx", firstrow(varl) sheet("PPP vs national - by quintile", replace) 

   * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear
bys year eq_income_quintile: tab move_ppp 
xcontract move_ppp , fast by(year eq_income_quintile) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
export excel "table\4.2.quintile_movement_freq.xlsx", firstrow(varl) sheet("PPP vs national - by quintile", replace) 

* Analysis by province

  // national vs provincial distribution
  
    * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear
bys year fprov: tab move_prov [iw=WTS_SDLE]  
xcontract move_prov [aw=WTS_SDLE], fast by(year fprov) nomiss p(percent)
drop _freq
format _all  %9.1f
export excel "table\4.2.quintile_movement.xlsx", firstrow(varl) sheet("Prov vs national - by province", replace)

   * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear
bys year fprov: tab move_prov   
xcontract move_prov , fast by(year fprov) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
export excel "table\4.2.quintile_movement_freq.xlsx", firstrow(varl) sheet("Prov vs national - by province", replace)

   // national vs ppp-adjusted distribution 
     
	 * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear  
bys year fprov: tab move_ppp [iw=WTS_SDLE]
xcontract move_ppp [aw=WTS_SDLE], fast by(year fprov) nomiss p(percent)
drop _freq
format _all  %9.1f
export excel "table\4.2.quintile_movement.xlsx", firstrow(varl) sheet("PPP vs national - by province", replace)

    * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear
bys year fprov: tab move_ppp  
xcontract move_ppp, fast by(year fprov) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
export excel "table\4.2.quintile_movement_freq.xlsx", firstrow(varl) sheet("PPP vs national - by province", replace)

*Analysis by city

  // national vs provincial distribution
    * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear
bys year city: tab move_prov [iw=WTS_SDLE]  
xcontract move_prov [aw=WTS_SDLE] if city=="Montreal" | city== "Vancouver" | city=="Toronto" , fast by(year city) nomiss p(percent)
drop _freq
format percent  %9.1f
export excel "table\4.2.quintile_movement.xlsx", firstrow(varl) sheet("Prov vs national - by city", replace)

   * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear
bys year city: tab move_prov   
xcontract move_prov  if city=="Montreal" | city== "Vancouver" | city=="Toronto", fast by(year city) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
export excel "table\4.2.quintile_movement_freq.xlsx", firstrow(varl) sheet("Prov vs national - by city", replace)

   // national vs ppp-adjusted distribution 
   *percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear  
bys year city: tab move_ppp [iw=WTS_SDLE]
xcontract move_ppp [aw=WTS_SDLE]  if city=="Montreal" | city== "Vancouver" | city=="Toronto", fast by(year city) nomiss p(percent)
drop _freq
format percent  %9.1f
export excel "table\4.2.quintile_movement.xlsx", firstrow(varl) sheet("PPP vs national - by city", replace) 

   * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear  
bys year city: tab move_ppp 
xcontract move_ppp  if city=="Montreal" | city== "Vancouver" | city=="Toronto", fast by(year city) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
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
	
	//by city
	  * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear  
bys year city: sum income_dif_ppp [iw=WTS_SDLE]
xcontract relative_income_diff [aw=WTS_SDLE]  if city=="Montreal" | city== "Vancouver" | city=="Toronto", fast by(year city) nomiss p(percent)
collapse relative_income_diff, by(year city)
format relative_income_diff  %9.1f
export excel "table\4.3.income_differences.xlsx", firstrow(varl) sheet("Relative diff - by city", replace)	
	
    * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear  
bys year city: sum income_dif_ppp
xcontract relative_income_diff  if city=="Montreal" | city== "Vancouver" | city=="Toronto", fast by(year city) nomiss p(percent)
collapse (count) relative_income_diff, by(year city)
export excel "table\4.3.income_differences_freq.xlsx", firstrow(varl) sheet("Relative diff - by city", replace)	
 
  
	// to think about --> how different would these results be if the referece PPP index was not based on Ottawa? (For ottawa, the difference is 0) + we can test outside of rdc what happens if we change benchmark
	
*===============================================================================

**#                         *4.Correlations

*===============================================================================


use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear  
cd "T:\Projet 10629\node4\stata"

*Quintiles
 putexcel set "table\4.4.spearman.xls", sheet(national vs prov) modify
 putexcel A1= "Year"
 putexcel B1 = "Spearman's rho"
 putexcel C1 = "Prob"
 putexcel A2= "2011"
 putexcel A3= "2012"
 putexcel A4= "2013"
 putexcel A5= "2014"
 putexcel A6= "2015"
 
 gen years=.
 
 forvalues i=2011/2015 {
 	replace years=`i'-2009 if year==`i'
 }

forvalues i=2/6 {
 spearman eq_income_quintile eq_prov_income_quintile if years==`i'
 putexcel B`i'= `r(rho)'
 putexcel C`i' = `r(p)'

}

 putexcel set "table\4.4.spearman.xls", sheet(national vs PPP) modify
 putexcel A1= "Year"
 putexcel B1 = "Spearman's rho"
 putexcel C1 = "Prob"
 putexcel A2= "2011"
 putexcel A3= "2012"
 putexcel A4= "2013"
 putexcel A5= "2014"
 putexcel A6= "2015"

 forvalues i=2/6 {
 spearman eq_income_quintile ppp_income_quintile if years==`i'
 putexcel B`i'= `r(rho)'
 putexcel C`i' = `r(p)'

}

 putexcel set "table\4.4.spearman.xls", sheet(prov vs PPP) modify
 putexcel A1= "Year"
 putexcel B1 = "Spearman's rho"
 putexcel C1 = "Prob"
 putexcel A2= "2011"
 putexcel A3= "2012"
 putexcel A4= "2013"
 putexcel A5= "2014"
 putexcel A6= "2015"
 
  forvalues i=2/6 {
 spearman eq_prov_income_quintile ppp_income_quintile if years==`i'
 putexcel B`i'= `r(rho)'
 putexcel C`i' = `r(p)'

}
 
 
 *Income
 putexcel set "table\4.4.spearman.xls", sheet(prov vs PPP) modify
 putexcel A1= "Year"
 putexcel B1 = "Spearman's rho"
 putexcel C1 = "Prob"
 putexcel A2= "2011"
 putexcel A3= "2012"
 putexcel A4= "2013"
 putexcel A5= "2014"
 putexcel A6= "2015"
 
  forvalues i=2/6 {
 spearman ppp_income equivalized_income if years==`i'
 putexcel B`i'= `r(rho)'
 putexcel C`i' = `r(p)'

}
 
 // note: weights not allowed with spearman

*===============================================================================

**#                        *5.Inequalities

*===============================================================================
do "do\ineqdeco.do" 

* National level 

forvalues i=2011/2015 {
   di `i'
   di "Regular income"
   ineqdeco equivalized_income [aw=WTS_SDLE] if year==`i'
   putexcel set "table\4.5.ineqdeco.xls", sheet(national - `i', replace) modify
   
putexcel A1= "Statistics"
putexcel A2= "Gini"
putexcel A2= "A(2)"
putexcel A3= "A(1)"
putexcel A4= "A(0.5)"
putexcel A5= "GE(2)"
putexcel A6= "GE(1)"
putexcel A7= "GE(0)"
putexcel A8= "GE(-1)"
putexcel A9= "Gini"
putexcel A10= "p75p50"
putexcel A11= "p25p50"
putexcel A12= "p10p50"
putexcel A13= "p90p50"
putexcel A14= "p75p25"

putexcel B1= "Value"
putexcel B2= `r(a2)'
putexcel B3= `r(a1)'
putexcel B4= `r(ahalf)'
putexcel B5= `r(ge2)'
putexcel B6= `r(ge1)'
putexcel B7= `r(ge0)'
putexcel B8= `r(gem1)'
putexcel B9= `r(gini)'
putexcel B10= `r(p75p50)'
putexcel B11= `r(p25p50)'
putexcel B12= `r(p10p50)'
putexcel B13= `r(p90p50)'
putexcel B14= `r(p75p25)'  
 
   di "PPP-adjusted income"
   ineqdeco ppp_income [aw=WTS_SDLE] if year==`i'
   putexcel set "table\4.5.ineqdeco.xls", sheet(PPP - `i', replace) modify
putexcel A1= "Statistics"
putexcel B1= "Value"
   
putexcel A1= "Statistics"
putexcel A2= "Gini"
putexcel A2= "A(2)"
putexcel A3= "A(1)"
putexcel A4= "A(0.5)"
putexcel A5= "GE(2)"
putexcel A6= "GE(1)"
putexcel A7= "GE(0)"
putexcel A8= "GE(-1)"
putexcel A9= "Gini"
putexcel A10= "p75p50"
putexcel A11= "p25p50"
putexcel A12= "p10p50"
putexcel A13= "p90p50"
putexcel A14= "p75p25"

putexcel B1= "Value"
putexcel B2= `r(a2)'
putexcel B3= `r(a1)'
putexcel B4= `r(ahalf)'
putexcel B5= `r(ge2)'
putexcel B6= `r(ge1)'
putexcel B7= `r(ge0)'
putexcel B8= `r(gem1)'
putexcel B9= `r(gini)'
putexcel B10= `r(p75p50)'
putexcel B11= `r(p25p50)'
putexcel B12= `r(p10p50)'
putexcel B13= `r(p90p50)'
putexcel B14= `r(p75p25)' 
}


* supporting frequencies
forvalues i=2011/2015 {
   di `i'
   di "Regular income"
   ineqdeco equivalized_income  if year==`i'
   putexcel set "table\4.5.ineqdeco_freq.xls", sheet(national - `i', replace) modify
putexcel A1= "Count"
putexcel B1= "Value"

putexcel A2= "p95"
putexcel A3= "p90"
putexcel A4= "p75"
putexcel A5= "p50"
putexcel A6= "p25"
putexcel A7= "p10"
putexcel A8= "p5"
putexcel A9= "N"


putexcel B2= `r(p95)'
putexcel B3= `r(p90)'
putexcel B4= `r(p75)'
putexcel B5= `r(p50)'
putexcel B6= `r(p25)'
putexcel B7= `r(p10)'
putexcel B8= `r(p5)'
putexcel B9= `r(N)'
   
   di "PPP-adjusted income"
   ineqdeco ppp_income if year==`i'
   putexcel set "table\4.5.ineqdeco_freq.xls", sheet(PPP - `i', replace) modify
putexcel A1= "Count"
putexcel B1= "Value"

putexcel A2= "p95"
putexcel A3= "p90"
putexcel A4= "p75"
putexcel A5= "p50"
putexcel A6= "p25"
putexcel A7= "p10"
putexcel A8= "p5"
putexcel A9= "N"


putexcel B2= `r(p95)'
putexcel B3= `r(p90)'
putexcel B4= `r(p75)'
putexcel B5= `r(p50)'
putexcel B6= `r(p25)'
putexcel B7= `r(p10)'
putexcel B8= `r(p5)'
putexcel B9= `r(N)'
}



* inequality across vs in-between provinces

forvalues i=2011/2015 {
   di `i'
   di "Regular income"
   ineqdeco equivalized_income [aw=WTS_SDLE] if year==`i' , bygroup(fprov) 
   putexcel set "table\4.5.ineqdeco_by_prov.xls", sheet(national distr- `i', replace) modify
   
putexcel A1= "Statistics"
putexcel A2= "Gini"

putexcel A2= "Between - A(2)"
putexcel A3= "Between - A(1)"
putexcel A4= "Between - A(0.5)"
putexcel A5= "Within - A(2)"
putexcel A6= "Within - A(1)"
putexcel A7= "Within - A(0.5)"
putexcel A8= "A(2) - British Columbia"
putexcel A9= "A(1) - British Columbia"
putexcel A10= "A(0.5) - British Columbia"
putexcel A11= "A(2) - Alberta"
putexcel A12= "A(1) - Alberta"
putexcel A13= "A(0.5) - Alberta"
putexcel A14= " A(2) - Saskachewan"
putexcel A15= " A(1) - Saskachewan"
putexcel A16= " A(0.5) - Saskachewan"
putexcel A17= " A(2) - Manitoba"
putexcel A18= " A(1) - Manitoba"
putexcel A19= " A(0.5) - Manitoba"
putexcel A20= "A(2) - Ontario"
putexcel A21= "A(1) - Ontario"
putexcel A22= "A(0.5) - Ontario"
putexcel A23= "A(2) - Quebec"
putexcel A24= "A(1) - Quebec"
putexcel A25= "A(0.5) - Quebec"
putexcel A26= "A(2) - New Brunswick"
putexcel A27= "A(1) - New Brunswick"
putexcel A28= "A(0.5) - New Brunswick"
putexcel A29= "A(2) - Nova Scotia"
putexcel A30= "A(1) - Nova Scotia"
putexcel A31= "A(0.5) - Nova Scotia"
putexcel A32= "A(2) - Prince Edward Island"
putexcel A33= "A(1) - Prince Edward Island"
putexcel A34= "A(0.5) - Prince Edward Island"
putexcel A35= "A(2) - Newfoundland and Labrador"
putexcel A36= "A(1) -  Newfoundland and Labrador"
putexcel A37= "A(0.5) -  Newfoundland and Labrador"
putexcel A38= "Between GE(2)"
putexcel A39= "Between GE(1)"
putexcel A40= "Between GE(0)"
putexcel A41= "Between GE(-1)"
putexcel A42= "Within GE(2)"
putexcel A43= "Within GE(1)"
putexcel A44= "Within GE(0)"
putexcel A45= "Within GE(-1)"
putexcel A46= "sumw British Columbia "
putexcel A47= "Pop. share British Columbia"
putexcel A48= "lambda British Columbia "
putexcel A49= "theta British Columbia "
putexcel A50= "lgmean British Columbia"
putexcel A51= "mean British Columbia"
putexcel A52= "gini British Columbia "
putexcel A53= "GE(2) British Columbia "
putexcel A54= "GE(1) British Columbia "
putexcel A55= "GE(0) British Columbia"
putexcel A56= "GE(-1) British Columbia" 
putexcel A57= "sumw Alberta"
putexcel A58= "Pop. share Alberta "
putexcel A59= "theta Alberta "
putexcel A60= "lgmean Alberta" 
putexcel A61= "mean Alberta "
putexcel A62= "gini Alberta" 
putexcel A63= "GE(2) Alberta"
putexcel A64= "GE(1) Alberta "
putexcel A65= "GE(0) Alberta "
putexcel A66= "GE(-1) Alberta "
putexcel A67= "sumw Saskatchewan" 
putexcel A68= "Pop. share Saskatchewan "
putexcel A69= "lambda Saskatchewan" 
putexcel A70= "theta Saskatchewan"
putexcel A71= "lgmean Saskatchewan" 
putexcel A72= "mean Saskatchewan "
putexcel A73= "gini Saskatchewan" 
putexcel A74= "GE(2) Saskatchewan"
putexcel A75= "GE(1) Saskatchewan "
putexcel A76= " GE(0) Saskatchewan "
putexcel A77= "GE(-1) Saskatchewan"
putexcel A78= "sumw Manitoba" 
putexcel A79= "Pop. share Manitoba "
putexcel A80= "lambda Manitoba "
putexcel A81= "theta Manitoba "
putexcel A82= "lgmean Manitoba"
putexcel A83= "mean Manitoba "
putexcel A84= "gini Manitoba "
putexcel A85= "GE(2) Manitoba "
putexcel A86= "GE(1) Manitoba "
putexcel A87= "GE(0) Manitoba"
putexcel A88= "GE(-1) Manitoba"
putexcel A89= "sumw Ontario" 
putexcel A90= "Pop. share Ontario "
putexcel A91= "lambda Ontario "
putexcel A92= "theta Ontario "
putexcel A93= "lgmean Ontario" 
putexcel A94= "mean Ontario "
putexcel A95= "gini Ontario "
putexcel A96= "GE(2) Ontario "
putexcel A97= "GE(1) Ontario "
putexcel A98= "GE(0) Ontario "
putexcel A99= "GE(-1) Ontario "
putexcel A100= "sumw Quebec" 
putexcel A101= "Pop. share Quebec "
putexcel A102= "lambda Quebec" 
putexcel A103= "theta Quebec"
putexcel A104= "lgmean Quebec" 
putexcel A105= "mean Quebec "
putexcel A106= "gini Quebec "
putexcel A107= "GE(2) Quebec "
putexcel A108= "GE(1) Quebec"
putexcel A109= "GE(0) Quebec "
putexcel A110= "GE(-1) Quebec "
putexcel A111= "sumw New Brunswick" 
putexcel A112= "Pop. share New Brunswick "
putexcel A113= "lambda New Brunswick "
putexcel A114= "theta New Brunswick "
putexcel A115= "lgmean New Brunswick" 
putexcel A116= "mean New Brunswick "
putexcel A117= "gini New Brunswick "
putexcel A118= "GE(2) New Brunswick "
putexcel A119= "GE(1) New Brunswick"
putexcel A120= "GE(0) New Brunswick "
putexcel A121= "GE(-1) New Brunswick" 
putexcel A122= "sumw Nova Scotia" 
putexcel A123= "Pop. share Nova Scotia "
putexcel A124= "lambda Nova Scotia "
putexcel A125= "theta Nova Scotia "
putexcel A126= "lgmean Nova Scotia" 
putexcel A127= "mean Nova Scotia "
putexcel A128= "gini Nova Scotia "
putexcel A129= "GE(2) Nova Scotia "
putexcel A130= "GE(1) Nova Scotia "
putexcel A131= "GE(0) Nova Scotia "
putexcel A132= "GE(-1) Nova Scotia" 
putexcel A133= "sumw Prince Edward Island "
putexcel A134= "Pop. share Prince Edward Island "
putexcel A135= "lambda Prince Edward Island" 
putexcel A136= "theta Prince Edward Island"
putexcel A137= "lgmean Prince Edward Island" 
putexcel A138= "mean Prince Edward Island"
putexcel A139= "gini Prince Edward Island"
putexcel A140= "GE(2) Prince Edward Island "
putexcel A141= "GE(1) Prince Edward Island "
putexcel A142= "GE(0) Prince Edward Island "
putexcel A143= "GE(-1) Prince Edward Island" 
putexcel A144= "sumw Newfoundland and Labrador"
putexcel A145= "Pop. share Newfoundland and Labrador "
putexcel A146= "lambda Newfoundland and Labrador "
putexcel A147= "theta Newfoundland and Labrador "
putexcel A148= "lgmean Newfoundland and Labrador" 
putexcel A149= "mean Newfoundland and Labrador "
putexcel A150= "gini Newfoundland and Labrador"
putexcel A151= "GE(2) Newfoundland and Labrador "
putexcel A152= "GE(1) Newfoundland and Labrador "
putexcel A153= "GE(0) Newfoundland and Labrador "
putexcel A154= "GE(-1) Newfoundland and Labrador"



putexcel B1= "Value"
putexcel B2= `r(between_a2)'
putexcel B3= `r(between_a1)'
putexcel B4= `r(between_ahalf)'
putexcel B5= `r(within_a2)'
putexcel B6= `r(within_a1)'
putexcel B7= `r(within_ahalf)'
putexcel B8= `r(a2_59)'
putexcel B9= `r(a1_59)'
putexcel B10= `r(ahalf_59)'
putexcel B11= `r(a2_48)'
putexcel B12= `r(a1_48)'
putexcel B13= `r(ahalf_48)'
putexcel B14= `r(a2_47)'
putexcel B15= `r(a1_47)'
putexcel B16= `r(ahalf_47)'
putexcel B17= `r(a2_46)'
putexcel B18= `r(a1_46)'
putexcel B19= `r(ahalf_46)'
putexcel B20= `r(a2_35)'
putexcel B21= `r(a1_35)'
putexcel B22= `r(ahalf_35)'
putexcel B23= `r(a2_24)'
putexcel B24= `r(a1_24)'
putexcel B25= `r(ahalf_24)'
putexcel B26= `r(a2_13)'
putexcel B27= `r(a1_13)'
putexcel B28= `r(ahalf_13)'
putexcel B29= `r(a2_12)'
putexcel B30= `r(a1_12)'
putexcel B31= `r(ahalf_12)'
putexcel B32= `r(a2_11)'
putexcel B33= `r(a1_11)'
putexcel B34= `r(ahalf_11)'
putexcel B35= `r(a2_10)'
putexcel B36= `r(a1_10)'
putexcel B37= `r(ahalf_10)'
putexcel B38= `r(between_ge2)'
putexcel B39= `r(between_ge1)'
putexcel B40= `r(between_ge0)'
putexcel B41= `r(between_gem1)'
putexcel B42= `r(within_ge2)'
putexcel B43= `r(within_ge1)'
putexcel B44= `r(within_ge0)'
putexcel B45= `r(within_gem1)'
putexcel B46= `r(sumw_59) '
putexcel B47= `r(v_59)'
putexcel B48= `r(lambda_59) '
putexcel B49= `r(theta_59) '
putexcel B50= `r(lgmean_59)'
putexcel B51= `r(mean_59)'
putexcel B52= `r(gini_59) '
putexcel B53= `r(ge2_59) '
putexcel B54= `r(ge1_59) '
putexcel B55= `r(ge0_59)'
putexcel B56= `r(gem1_59)' 
putexcel B57= `r(sumw_48)'
putexcel B58= `r(v_48) '
putexcel B59= `r(theta_48) '
putexcel B60= `r(lgmean_48)' 
putexcel B61= `r(mean_48) '
putexcel B62= `r(gini_48)' 
putexcel B63= `r(ge2_48)'
putexcel B64= `r(ge1_48) '
putexcel B65= `r(ge0_48) '
putexcel B66= `r(gem1_48) '
putexcel B67= `r(sumw_47)' 
putexcel B68= `r(v_47) '
putexcel B69= `r(lambda_47)' 
putexcel B70= `r(theta_47)'
putexcel B71= `r(lgmean_47)' 
putexcel B72= `r(mean_47) '
putexcel B73= `r(gini_47)' 
putexcel B74= `r(ge2_47)'
putexcel B75= `r(ge1_47) '
putexcel B76= `r(ge0_47) '
putexcel B77= `r(gem1_47)'
putexcel B78= `r(sumw_46)' 
putexcel B79= `r(v_46) '
putexcel B80= `r(lambda_46) '
putexcel B81= `r(theta_46) '
putexcel B82= `r(lgmean_46)'
putexcel B83= `r(mean_46) '
putexcel B84= `r(gini_46) '
putexcel B85= `r(ge2_46) '
putexcel B86= `r(ge1_46) '
putexcel B87= `r(ge0_46)'
putexcel B88= `r(gem1_46)'
putexcel B89= `r(sumw_35)' 
putexcel B90= `r(v_35) '
putexcel B91= `r(lambda_35) '
putexcel B92= `r(theta_35) '
putexcel B93= `r(lgmean_35)' 
putexcel B94= `r(mean_35) '
putexcel B95= `r(gini_35) '
putexcel B96= `r(ge2_35) '
putexcel B97= `r(ge1_35) '
putexcel B98= `r(ge0_35) '
putexcel B99= `r(gem1_35) '
putexcel B100= `r(sumw_24)' 
putexcel B101= `r(v_24) '
putexcel B102= `r(lambda_24)' 
putexcel B103= `r(theta_24)'
putexcel B104= `r(lgmean_24)' 
putexcel B105= `r(mean_24) '
putexcel B106= `r(gini_24) '
putexcel B107= `r(ge2_24) '
putexcel B108= `r(ge1_24)'
putexcel B109= `r(ge0_24) '
putexcel B110= `r(gem1_24) '
putexcel B111= `r(sumw_13)' 
putexcel B112= `r(v_13) '
putexcel B113= `r(lambda_13) '
putexcel B114= `r(theta_13) '
putexcel B115= `r(lgmean_13)' 
putexcel B116= `r(mean_13) '
putexcel B117= `r(gini_13) '
putexcel B118= `r(ge2_13) '
putexcel B119= `r(ge1_13)'
putexcel B120= `r(ge0_13) '
putexcel B121= `r(gem1_13)' 
putexcel B122= `r(sumw_12)' 
putexcel B123= `r(v_12) '
putexcel B124= `r(lambda_12) '
putexcel B125= `r(theta_12) '
putexcel B126= `r(lgmean_12)' 
putexcel B127= `r(mean_12) '
putexcel B128= `r(gini_12) '
putexcel B129= `r(ge2_12) '
putexcel B130= `r(ge1_12) '
putexcel B131= `r(ge0_12) '
putexcel B132= `r(gem1_12)' 
putexcel B133= `r(sumw_11) '
putexcel B134= `r(v_11) '
putexcel B135= `r(lambda_11)' 
putexcel B136= `r(theta_11)'
putexcel B137= `r(lgmean_11)' 
putexcel B138= `r(mean_11)'
putexcel B139= `r(gini_11)'
putexcel B140= `r(ge2_11) '
putexcel B141= `r(ge1_11) '
putexcel B142= `r(ge0_11) '
putexcel B143= `r(gem1_11)' 
putexcel B144= `r(sumw_10)'
putexcel B145= `r(v_10) '
putexcel B146= `r(lambda_10) '
putexcel B147= `r(theta_10) '
putexcel B148= `r(lgmean_10)' 
putexcel B149= `r(mean_10) '
putexcel B150= `r(gini_10)'
putexcel B151= `r(ge2_10) '
putexcel B152= `r(ge1_10) '
putexcel B153= `r(ge0_10) '
putexcel B154= `r(gem1_10)'



 
   di "PPP-adjusted income"
   ineqdeco ppp_income [aw=WTS_SDLE] if year==`i', bygroup(fprov) 
   putexcel set "table\4.5.ineqdeco_by_prov.xls", sheet(PPP - `i', replace) modify

   putexcel A1= "Statistics"
putexcel A2= "Between - A(2)"
putexcel A3= "Between - A(1)"
putexcel A4= "Between - A(0.5)"
putexcel A5= "Within - A(2)"
putexcel A6= "Within - A(1)"
putexcel A7= "Within - A(0.5)"
putexcel A8= "A(2) - British Columbia"
putexcel A9= "A(1) - British Columbia"
putexcel A10= "A(0.5) - British Columbia"
putexcel A11= "A(2) - Alberta"
putexcel A12= "A(1) - Alberta"
putexcel A13= "A(0.5) - Alberta"
putexcel A14= " A(2) - Saskachewan"
putexcel A15= " A(1) - Saskachewan"
putexcel A16= " A(0.5) - Saskachewan"
putexcel A17= " A(2) - Manitoba"
putexcel A18= " A(1) - Manitoba"
putexcel A19= " A(0.5) - Manitoba"
putexcel A20= "A(2) - Ontario"
putexcel A21= "A(1) - Ontario"
putexcel A22= "A(0.5) - Ontario"
putexcel A23= "A(2) - Quebec"
putexcel A24= "A(1) - Quebec"
putexcel A25= "A(0.5) - Quebec"
putexcel A26= "A(2) - New Brunswick"
putexcel A27= "A(1) - New Brunswick"
putexcel A28= "A(0.5) - New Brunswick"
putexcel A29= "A(2) - Nova Scotia"
putexcel A30= "A(1) - Nova Scotia"
putexcel A31= "A(0.5) - Nova Scotia"
putexcel A32= "A(2) - Prince Edward Island"
putexcel A33= "A(1) - Prince Edward Island"
putexcel A34= "A(0.5) - Prince Edward Island"
putexcel A35= "A(2) - Newfoundland and Labrador"
putexcel A36= "A(1) -  Newfoundland and Labrador"
putexcel A37= "A(0.5) -  Newfoundland and Labrador"
putexcel A38= "Between GE(2)"
putexcel A39= "Between GE(1)"
putexcel A40= "Between GE(0)"
putexcel A41= "Between GE(-1)"
putexcel A42= "Within GE(2)"
putexcel A43= "Within GE(1)"
putexcel A44= "Within GE(0)"
putexcel A45= "Within GE(-1)"
putexcel A46= "sumw British Columbia "
putexcel A47= "Pop. share British Columbia"
putexcel A48= "lambda British Columbia "
putexcel A49= "theta British Columbia "
putexcel A50= "lgmean British Columbia"
putexcel A51= "mean British Columbia"
putexcel A52= "gini British Columbia "
putexcel A53= "GE(2) British Columbia "
putexcel A54= "GE(1) British Columbia "
putexcel A55= "GE(0) British Columbia"
putexcel A56= "GE(-1) British Columbia" 
putexcel A57= "sumw Alberta"
putexcel A58= "Pop. share Alberta "
putexcel A59= "theta Alberta "
putexcel A60= "lgmean Alberta" 
putexcel A61= "mean Alberta "
putexcel A62= "gini Alberta" 
putexcel A63= "GE(2) Alberta"
putexcel A64= "GE(1) Alberta "
putexcel A65= "GE(0) Alberta "
putexcel A66= "GE(-1) Alberta "
putexcel A67= "sumw Saskatchewan" 
putexcel A68= "Pop. share Saskatchewan "
putexcel A69= "lambda Saskatchewan" 
putexcel A70= "theta Saskatchewan"
putexcel A71= "lgmean Saskatchewan" 
putexcel A72= "mean Saskatchewan "
putexcel A73= "gini Saskatchewan" 
putexcel A74= "GE(2) Saskatchewan"
putexcel A75= "GE(1) Saskatchewan "
putexcel A76= " GE(0) Saskatchewan "
putexcel A77= "GE(-1) Saskatchewan"
putexcel A78= "sumw Manitoba" 
putexcel A79= "Pop. share Manitoba "
putexcel A80= "lambda Manitoba "
putexcel A81= "theta Manitoba "
putexcel A82= "lgmean Manitoba"
putexcel A83= "mean Manitoba "
putexcel A84= "gini Manitoba "
putexcel A85= "GE(2) Manitoba "
putexcel A86= "GE(1) Manitoba "
putexcel A87= "GE(0) Manitoba"
putexcel A88= "GE(-1) Manitoba"
putexcel A89= "sumw Ontario" 
putexcel A90= "Pop. share Ontario "
putexcel A91= "lambda Ontario "
putexcel A92= "theta Ontario "
putexcel A93= "lgmean Ontario" 
putexcel A94= "mean Ontario "
putexcel A95= "gini Ontario "
putexcel A96= "GE(2) Ontario "
putexcel A97= "GE(1) Ontario "
putexcel A98= "GE(0) Ontario "
putexcel A99= "GE(-1) Ontario "
putexcel A100= "sumw Quebec" 
putexcel A101= "Pop. share Quebec "
putexcel A102= "lambda Quebec" 
putexcel A103= "theta Quebec"
putexcel A104= "lgmean Quebec" 
putexcel A105= "mean Quebec "
putexcel A106= "gini Quebec "
putexcel A107= "GE(2) Quebec "
putexcel A108= "GE(1) Quebec"
putexcel A109= "GE(0) Quebec "
putexcel A110= "GE(-1) Quebec "
putexcel A111= "sumw New Brunswick" 
putexcel A112= "Pop. share New Brunswick "
putexcel A113= "lambda New Brunswick "
putexcel A114= "theta New Brunswick "
putexcel A115= "lgmean New Brunswick" 
putexcel A116= "mean New Brunswick "
putexcel A117= "gini New Brunswick "
putexcel A118= "GE(2) New Brunswick "
putexcel A119= "GE(1) New Brunswick"
putexcel A120= "GE(0) New Brunswick "
putexcel A121= "GE(-1) New Brunswick" 
putexcel A122= "sumw Nova Scotia" 
putexcel A123= "Pop. share Nova Scotia "
putexcel A124= "lambda Nova Scotia "
putexcel A125= "theta Nova Scotia "
putexcel A126= "lgmean Nova Scotia" 
putexcel A127= "mean Nova Scotia "
putexcel A128= "gini Nova Scotia "
putexcel A129= "GE(2) Nova Scotia "
putexcel A130= "GE(1) Nova Scotia "
putexcel A131= "GE(0) Nova Scotia "
putexcel A132= "GE(-1) Nova Scotia" 
putexcel A133= "sumw Prince Edward Island "
putexcel A134= "Pop. share Prince Edward Island "
putexcel A135= "lambda Prince Edward Island" 
putexcel A136= "theta Prince Edward Island"
putexcel A137= "lgmean Prince Edward Island" 
putexcel A138= "mean Prince Edward Island"
putexcel A139= "gini Prince Edward Island"
putexcel A140= "GE(2) Prince Edward Island "
putexcel A141= "GE(1) Prince Edward Island "
putexcel A142= "GE(0) Prince Edward Island "
putexcel A143= "GE(-1) Prince Edward Island" 
putexcel A144= "sumw Newfoundland and Labrador"
putexcel A145= "Pop. share Newfoundland and Labrador "
putexcel A146= "lambda Newfoundland and Labrador "
putexcel A147= "theta Newfoundland and Labrador "
putexcel A148= "lgmean Newfoundland and Labrador" 
putexcel A149= "mean Newfoundland and Labrador "
putexcel A150= "gini Newfoundland and Labrador"
putexcel A151= "GE(2) Newfoundland and Labrador "
putexcel A152= "GE(1) Newfoundland and Labrador "
putexcel A153= "GE(0) Newfoundland and Labrador "
putexcel A154= "GE(-1) Newfoundland and Labrador"



putexcel B1= "Value"
putexcel B2= `r(between_a2)'
putexcel B3= `r(between_a1)'
putexcel B4= `r(between_ahalf)'
putexcel B5= `r(within_a2)'
putexcel B6= `r(within_a1)'
putexcel B7= `r(within_ahalf)'
putexcel B8= `r(a2_59)'
putexcel B9= `r(a1_59)'
putexcel B10= `r(ahalf_59)'
putexcel B11= `r(a2_48)'
putexcel B12= `r(a1_48)'
putexcel B13= `r(ahalf_48)'
putexcel B14= `r(a2_47)'
putexcel B15= `r(a1_47)'
putexcel B16= `r(ahalf_47)'
putexcel B17= `r(a2_46)'
putexcel B18= `r(a1_46)'
putexcel B19= `r(ahalf_46)'
putexcel B20= `r(a2_35)'
putexcel B21= `r(a1_35)'
putexcel B22= `r(ahalf_35)'
putexcel B23= `r(a2_24)'
putexcel B24= `r(a1_24)'
putexcel B25= `r(ahalf_24)'
putexcel B26= `r(a2_13)'
putexcel B27= `r(a1_13)'
putexcel B28= `r(ahalf_13)'
putexcel B29= `r(a2_12)'
putexcel B30= `r(a1_12)'
putexcel B31= `r(ahalf_12)'
putexcel B32= `r(a2_11)'
putexcel B33= `r(a1_11)'
putexcel B34= `r(ahalf_11)'
putexcel B35= `r(a2_10)'
putexcel B36= `r(a1_10)'
putexcel B37= `r(ahalf_10)'
putexcel B38= `r(between_ge2)'
putexcel B39= `r(between_ge1)'
putexcel B40= `r(between_ge0)'
putexcel B41= `r(between_gem1)'
putexcel B42= `r(within_ge2)'
putexcel B43= `r(within_ge1)'
putexcel B44= `r(within_ge0)'
putexcel B45= `r(within_gem1)'
putexcel B46= `r(sumw_59) '
putexcel B47= `r(v_59)'
putexcel B48= `r(lambda_59) '
putexcel B49= `r(theta_59) '
putexcel B50= `r(lgmean_59)'
putexcel B51= `r(mean_59)'
putexcel B52= `r(gini_59) '
putexcel B53= `r(ge2_59) '
putexcel B54= `r(ge1_59) '
putexcel B55= `r(ge0_59)'
putexcel B56= `r(gem1_59)' 
putexcel B57= `r(sumw_48)'
putexcel B58= `r(v_48) '
putexcel B59= `r(theta_48) '
putexcel B60= `r(lgmean_48)' 
putexcel B61= `r(mean_48) '
putexcel B62= `r(gini_48)' 
putexcel B63= `r(ge2_48)'
putexcel B64= `r(ge1_48) '
putexcel B65= `r(ge0_48) '
putexcel B66= `r(gem1_48) '
putexcel B67= `r(sumw_47)' 
putexcel B68= `r(v_47) '
putexcel B69= `r(lambda_47)' 
putexcel B70= `r(theta_47)'
putexcel B71= `r(lgmean_47)' 
putexcel B72= `r(mean_47) '
putexcel B73= `r(gini_47)' 
putexcel B74= `r(ge2_47)'
putexcel B75= `r(ge1_47) '
putexcel B76= `r(ge0_47) '
putexcel B77= `r(gem1_47)'
putexcel B78= `r(sumw_46)' 
putexcel B79= `r(v_46) '
putexcel B80= `r(lambda_46) '
putexcel B81= `r(theta_46) '
putexcel B82= `r(lgmean_46)'
putexcel B83= `r(mean_46) '
putexcel B84= `r(gini_46) '
putexcel B85= `r(ge2_46) '
putexcel B86= `r(ge1_46) '
putexcel B87= `r(ge0_46)'
putexcel B88= `r(gem1_46)'
putexcel B89= `r(sumw_35)' 
putexcel B90= `r(v_35) '
putexcel B91= `r(lambda_35) '
putexcel B92= `r(theta_35) '
putexcel B93= `r(lgmean_35)' 
putexcel B94= `r(mean_35) '
putexcel B95= `r(gini_35) '
putexcel B96= `r(ge2_35) '
putexcel B97= `r(ge1_35) '
putexcel B98= `r(ge0_35) '
putexcel B99= `r(gem1_35) '
putexcel B100= `r(sumw_24)' 
putexcel B101= `r(v_24) '
putexcel B102= `r(lambda_24)' 
putexcel B103= `r(theta_24)'
putexcel B104= `r(lgmean_24)' 
putexcel B105= `r(mean_24) '
putexcel B106= `r(gini_24) '
putexcel B107= `r(ge2_24) '
putexcel B108= `r(ge1_24)'
putexcel B109= `r(ge0_24) '
putexcel B110= `r(gem1_24) '
putexcel B111= `r(sumw_13)' 
putexcel B112= `r(v_13) '
putexcel B113= `r(lambda_13) '
putexcel B114= `r(theta_13) '
putexcel B115= `r(lgmean_13)' 
putexcel B116= `r(mean_13) '
putexcel B117= `r(gini_13) '
putexcel B118= `r(ge2_13) '
putexcel B119= `r(ge1_13)'
putexcel B120= `r(ge0_13) '
putexcel B121= `r(gem1_13)' 
putexcel B122= `r(sumw_12)' 
putexcel B123= `r(v_12) '
putexcel B124= `r(lambda_12) '
putexcel B125= `r(theta_12) '
putexcel B126= `r(lgmean_12)' 
putexcel B127= `r(mean_12) '
putexcel B128= `r(gini_12) '
putexcel B129= `r(ge2_12) '
putexcel B130= `r(ge1_12) '
putexcel B131= `r(ge0_12) '
putexcel B132= `r(gem1_12)' 
putexcel B133= `r(sumw_11) '
putexcel B134= `r(v_11) '
putexcel B135= `r(lambda_11)' 
putexcel B136= `r(theta_11)'
putexcel B137= `r(lgmean_11)' 
putexcel B138= `r(mean_11)'
putexcel B139= `r(gini_11)'
putexcel B140= `r(ge2_11) '
putexcel B141= `r(ge1_11) '
putexcel B142= `r(ge0_11) '
putexcel B143= `r(gem1_11)' 
putexcel B144= `r(sumw_10)'
putexcel B145= `r(v_10) '
putexcel B146= `r(lambda_10) '
putexcel B147= `r(theta_10) '
putexcel B148= `r(lgmean_10)' 
putexcel B149= `r(mean_10) '
putexcel B150= `r(gini_10)'
putexcel B151= `r(ge2_10) '
putexcel B152= `r(ge1_10) '
putexcel B153= `r(ge0_10) '
putexcel B154= `r(gem1_10)'
}


* supporting frequencies
forvalues i=2011/2015 {
   di `i'
   di "Regular income"
   ineqdeco equivalized_income  if year==`i', bygroup(fprov) 
   putexcel set "table\4.5.ineqdeco_by_prov_freq.xls", sheet(national distr- `i', replace) modify
putexcel A1= "Count"
putexcel B1= "Value"

putexcel A2= "p95"
putexcel A3= "p90"
putexcel A4= "p75"
putexcel A5= "p50"
putexcel A6= "p25"
putexcel A7= "p10"
putexcel A8= "p5"
putexcel A9= "N"


putexcel B2= `r(p95)'
putexcel B3= `r(p90)'
putexcel B4= `r(p75)'
putexcel B5= `r(p50)'
putexcel B6= `r(p25)'
putexcel B7= `r(p10)'
putexcel B8= `r(p5)'
putexcel B9= `r(N)'
   
   di "PPP-adjusted income"
   ineqdeco ppp_income if year==`i' , bygroup(fprov) 
   putexcel set "table\4.5.ineqdeco_by_prov_freq.xls", sheet(PPP - `i', replace) modify
putexcel A1= "Count"
putexcel B1= "Value"

putexcel A2= "p95"
putexcel A3= "p90"
putexcel A4= "p75"
putexcel A5= "p50"
putexcel A6= "p25"
putexcel A7= "p10"
putexcel A8= "p5"
putexcel A9= "N"


putexcel B2= `r(p95)'
putexcel B3= `r(p90)'
putexcel B4= `r(p75)'
putexcel B5= `r(p50)'
putexcel B6= `r(p25)'
putexcel B7= `r(p10)'
putexcel B8= `r(p5)'
putexcel B9= `r(N)'
}


* inequality across vs in-between cities



forvalues i=2011/2015 {
   di `i'
   di "Regular income"
   ineqdeco equivalized_income [aw=WTS_SDLE] if year==`i' , bygroup(cities) 
   putexcel set "table\4.5.ineqdeco_by_city.xls", sheet(national distr- `i', replace) modify
         putexcel A1 = "Statistics"
		  putexcel A2 = "between A(2) "
         putexcel A3 = "between  A(1)"
      putexcel A4 = "between A(0.5)"
          putexcel A5 = "within A(2)"
          putexcel A6= "within  A(1)"
       putexcel A7 = "within A(0.5)"  
              putexcel A8 = " A(2) Winnipeg"  
              putexcel A9 = " A(1) Winnipeg"  
           putexcel A10 = "A(0.5) Winnipeg"  
              putexcel A11 = " A(2) Vancouver"  
              putexcel A12 = " A(1) Vancouver"  
           putexcel A13 = "A(0.5) Vancouver"  
              putexcel A14 = " A(2) Toronto"  
              putexcel A15 = " A(1) Toronto"  
           putexcel A16 = "A(0.5) Toronto"  
              putexcel A17 = " A(2) St Johns"  
              putexcel A18 = " A(1) St Johns"  
           putexcel A19 = "A(0.5) St Johns"  
              putexcel A20 = " A(2) Saskatoon"  
              putexcel A21 = " A(1) Saskatoon"
           putexcel A22= "A(0.5) Saskatoon"
              putexcel A23 = " A(2) Saint John"
              putexcel A24 = " A(1) Saint John"  
           putexcel A25 = "A(0.5) Saint John"
              putexcel A26 = " A(2) Regina"
              putexcel A27 = " A(1) Regina"  
           putexcel A28 = "A(0.5) Regina" 
              putexcel A29 = " A(2) Quebec" 
              putexcel A30 = " A(1) Quebec"
           putexcel A31 = "A(0.5) Quebec" 
              putexcel A32 = " A(2) Ottawa-Gatineau" 
              putexcel A33 = " A(1) Ottawa-Gatineau"  
           putexcel A34 = "A(0.5) Ottawa-Gatineau"
              putexcel A35 = " A(2) Montreal" 
              putexcel A36 = " A(1) Montreal"
           putexcel A37 = "A(0.5) Montreal"  
               putexcel A38 = " A(2) Hamilton/Burlington"  
               putexcel A39 = " A(1) Hamilton/Burlington" 
            putexcel A40 = "A(0.5) Hamilton/Burlington"  
               putexcel A41 = " A(2) 8"  
               putexcel A42 = " A(1) 8"  
            putexcel A43= "A(0.5) 8"  
               putexcel A44 = " A(2) Halifax"  
               putexcel A45 = " A(1) Halifax"  
            putexcel A46 = "A(0.5) Halifax"  
               putexcel A47 = " A(2) Fredericton" 
               putexcel A48 = " A(1) Fredericton"  
            putexcel A49= "A(0.5) Fredericton"  
               putexcel A50 = " A(2) Edmonton"  
               putexcel A51 = " A(1) Edmonton"  
            putexcel A52 = "A(0.5) Edmonton"  
               putexcel A53 = " A(2) Charlottetown" 
               putexcel A54 = " A(1) Charlottetown"  
            putexcel A55 = "A(0.5) Charlottetown" 
               putexcel A56 = " A(2) Cape Areton"  
               putexcel A57 = " A(1) Cape Areton"
            putexcel A58 = "A(0.5) Cape Areton"  
               putexcel A59 = " A(2) Calgary"  
               putexcel A60 = " A(1) Calgary" 
            putexcel A61 = "A(0.5) Calgary" 
               putexcel A62 = " A(2) Arandon" 
               putexcel A63 = " A(1) Arandon" 
            putexcel A64 = "A(0.5) Arandon"
        putexcel A65 = "between ge2" 
        putexcel A66 = "between ge1" 
        putexcel A67 = "between ge0"
       putexcel A68= "between gem1"
         putexcel A69 = "within ge2"
         putexcel A70 = "within ge1" 
         putexcel A71 = "within ge0" 
        putexcel A72 = "within gem1"  
            putexcel A73 = "sumw Winnipeg"  
               putexcel A74 = "v Winnipeg"  
          putexcel A75 = "lambda Winnipeg"  
           putexcel A76 = "theta Winnipeg"  
          putexcel A77 = "lgmean Winnipeg"  
            putexcel A78 = "mean Winnipeg" 
            putexcel A79= "gini Winnipeg"  
             putexcel A80 = "ge2 Winnipeg"  
             putexcel A81 = "ge1 Winnipeg"
             putexcel A82 = "ge0 Winnipeg"  
            putexcel A83 = "gem1 Winnipeg"
            putexcel A84 = "sumw Vancouver"
               putexcel A85 = "v Vancouver"  
          putexcel A86 = "lambda Vancouver"  
           putexcel A87 = "theta Vancouver" 
          putexcel A88 = "lgmean Vancouver"  
            putexcel A89 = "mean Vancouver" 
            putexcel A90 = "gini Vancouver" 
             putexcel A91 = "ge2 Vancouver"
             putexcel A92 = "ge1 Vancouver" 
             putexcel A93 = "ge0 Vancouver"
            putexcel A94 = "gem1 Vancouver" 
            putexcel A95 = "sumw Toronto"  
               putexcel A96 = "v Toronto"
          putexcel A97 = "lambda Toronto" 
           putexcel A98 = "theta Toronto"  
          putexcel A99 = "lgmean Toronto" 
            putexcel A100 = "mean Toronto"
            putexcel A101 = "gini Toronto" 
             putexcel A102 = "ge2 Toronto"  
             putexcel A103 = "ge1 Toronto"  
             putexcel A104 = "ge0 Toronto"  
            putexcel A105 = "gem1 Toronto"  
            putexcel A106 = "sumw St Johns"  
               putexcel A107 = "v St Johns"
          putexcel A108 = "lambda St Johns"  
           putexcel A109 = "theta St Johns"  
          putexcel A110 = "lgmean St Johns"  
            putexcel A111 = "mean St Johns"  
            putexcel A112 = "gini St Johns" 
             putexcel A113 = "ge2 St Johns"  
             putexcel A114 = "ge1 St Johns"
             putexcel A115 = "ge0 St Johns"  
            putexcel A116= "gem1 St Johns"  
            putexcel A117 = "sumw Saskatoon" 
               putexcel A118 = "v Saskatoon"  
          putexcel A119 = "lambda Saskatoon"  
           putexcel A120 = "theta Saskatoon"  
          putexcel A121 = "lgmean Saskatoon"  
            putexcel A122 = "mean Saskatoon"  
            putexcel A123 = "gini Saskatoon"  
             putexcel A124 = "ge2 Saskatoon"  
             putexcel A125 = "ge1 Saskatoon"  
             putexcel A126 = "ge0 Saskatoon"  
            putexcel A127 = "gem1 Saskatoon"  
            putexcel A128 = "sumw Saint John"  
               putexcel A129 = "v Saint John" 
          putexcel A130 = "lambda Saint John"  
           putexcel A131 = "theta Saint John"  
          putexcel A132 = "lgmean Saint John"  
            putexcel A133 = "mean Saint John"  
            putexcel A134 = "gini Saint John"  
             putexcel A135 = "ge2 Saint John"  
             putexcel A136 = "ge1 Saint John"  
             putexcel A137 = "ge0 Saint John"  
            putexcel A138 = "gem1 Saint John"  
            putexcel A139 = "sumw Regina"  
               putexcel A140 = "v Regina"  
          putexcel A141 = "lambda Regina"  
           putexcel A142 = "theta Regina"  
          putexcel A143 = "lgmean Regina"  
            putexcel A144 = "mean Regina"  
            putexcel A145 = "gini Regina"  
             putexcel A146 = "ge2 Regina"  
             putexcel A147 = "ge1 Regina"  
             putexcel A148 = "ge0 Regina"  
            putexcel A149 = "gem1 Regina"  
            putexcel A150 = "sumw Quebec"  
               putexcel A151 = "v Quebec"  
          putexcel A152 = "lambda Quebec"  
           putexcel A153 = "theta Quebec"  
          putexcel A154 = "lgmean Quebec"  
            putexcel A155 = "mean Quebec"  
            putexcel A156= "gini Quebec"  
             putexcel A157 = "ge2 Quebec"  
             putexcel A158 = "ge1 Quebec"  
             putexcel A159 = "ge0 Quebec"  
            putexcel A160 = "gem1 Quebec" 
            putexcel A161 = "sumw Ottawa-Gatineau"  
               putexcel A162 = "v Ottawa-Gatineau"
          putexcel A163 = "lambda Ottawa-Gatineau" 
           putexcel A164 = "theta Ottawa-Gatineau" 
          putexcel A165 = "lgmean Ottawa-Gatineau"  
            putexcel A166 = "mean Ottawa-Gatineau" 
            putexcel A167 = "gini Ottawa-Gatineau"  
             putexcel A168 = "ge2 Ottawa-Gatineau"  
             putexcel A169 = "ge1 Ottawa-Gatineau" 
             putexcel A170 = "ge0 Ottawa-Gatineau"  
            putexcel A171 = "gem1 Ottawa-Gatineau" 
            putexcel A172 = "sumw Montreal" 
               putexcel A173 = "v Montreal"  
          putexcel A174 = "lambda Montreal" 
           putexcel A175 = "theta Montreal"  
          putexcel A176 = "lgmean Montreal"
            putexcel A177 = "mean Montreal" 
            putexcel A178 = "gini Montreal"  
             putexcel A179 = "ge2 Montreal"
             putexcel A180 = "ge1 Montreal"  
             putexcel A181 = "ge0 Montreal"  
            putexcel A182 = "gem1 Montreal"  
             putexcel A183 = "sumw Hamilton/Burlington"  
                putexcel A184 = "v Hamilton/Burlington" 
           putexcel A185 = "lambda Hamilton/Burlington"  
            putexcel A186 = "theta Hamilton/Burlington" 
           putexcel A187 = "lgmean Hamilton/Burlington"  
             putexcel A188 = "mean Hamilton/Burlington" 
             putexcel A189 = "gini Hamilton/Burlington"  
              putexcel A190 = "ge2 Hamilton/Burlington" 
              putexcel A191 = "ge1 Hamilton/Burlington"  
              putexcel A192 = "ge0 Hamilton/Burlington" 
             putexcel A193 = "gem1 Hamilton/Burlington"  
             putexcel A194 = "sumw 8"  
                putexcel A195 = "v 8"
           putexcel A196 = "lambda 8" 
            putexcel A197 = "theta 8" 
           putexcel A198 = "lgmean 8"  
             putexcel A199 = "mean 8"  
             putexcel A200 = "gini 8"  
              putexcel A201 = "ge2 8"  
              putexcel A202 = "ge1 8" 
              putexcel A203 = "ge0 8"  
             putexcel A204 = "gem1 8"  
             putexcel A205 = "sumw Halifax"  
                putexcel A206 = "v Halifax"  
           putexcel A207 = "lambda Halifax"  
            putexcel A208 = "theta Halifax" 
           putexcel A209 = "lgmean Halifax"  
             putexcel A210 = "mean Halifax"  
             putexcel A211 = "gini Halifax"  
              putexcel A212 = "ge2 Halifax"  
              putexcel A213 = "ge1 Halifax"  
              putexcel A214 = "ge0 Halifax"  
             putexcel A215 = "gem1 Halifax"  
             putexcel A216 = "sumw Fredericton"  
                putexcel A217 = "v Fredericton"  
           putexcel A218 = "lambda Fredericton"  
            putexcel A219 = "theta Fredericton"  
           putexcel A220 = "lgmean Fredericton"  
             putexcel A221 = "mean Fredericton"  
             putexcel A222 = "gini Fredericton"  
              putexcel A223 = "ge2 Fredericton"  
              putexcel A224 = "ge1 Fredericton"  
              putexcel A225 = "ge0 Fredericton"  
             putexcel A226 = "gem1 Fredericton"  
             putexcel A227 = "sumw Edmonton"  
                putexcel A228 = "v Edmonton"  
           putexcel A229 = "lambda Edmonton"  
            putexcel A230 = "theta Edmonton"  
           putexcel A231 = "lgmean Edmonton"  
             putexcel A232 = "mean Edmonton"  
             putexcel A233 = "gini Edmonton"  
              putexcel A234 = "ge2 Edmonton"  
              putexcel A235 = "ge1 Edmonton"  
              putexcel A236 = "ge0 Edmonton"  
             putexcel A327 = "gem1 Edmonton"  
             putexcel A238 = "sumw Charlottetown"  
                putexcel A239 = "v Charlottetown"  
           putexcel A240 = "lambda Charlottetown"  
            putexcel A241 = "theta Charlottetown"  
           putexcel A242 = "lgmean Charlottetown"  
             putexcel A243 = "mean Charlottetown"  
             putexcel A244 = "gini Charlottetown"  
              putexcel A245 = "ge2 Charlottetown"  
              putexcel A246 = "ge1 Charlottetown"  
              putexcel A247 = "ge0 Charlottetown"  
             putexcel A248 = "gem1 Charlottetown"  
             putexcel A249 = "sumw Cape Areton"  
                putexcel A250 = "v Cape Areton"  
           putexcel A251 = "lambda Cape Areton"  
            putexcel A252 = "theta Cape Areton"  
           putexcel A253 = "lgmean Cape Areton"  
             putexcel A254 = "mean Cape Areton"  
             putexcel A255 = "gini Cape Areton"  
              putexcel A256 = "ge2 Cape Areton"  
              putexcel A257 = "ge1 Cape Areton"  
              putexcel A258 = "ge0 Cape Areton"  
             putexcel A259 = "gem1 Cape Areton"  
             putexcel A260 = "sumw Calgary"  
                putexcel A261 = "v Calgary"  
           putexcel A262 = "lambda Calgary"  
            putexcel A263 = "theta Calgary"  
           putexcel A264 = "lgmean Calgary"  
             putexcel A265 = "mean Calgary"  
             putexcel A266 = "gini Calgary"  
              putexcel A267 = "ge2 Calgary"  
              putexcel A268 = "ge1 Calgary"  
              putexcel A269 = "ge0 Calgary"  
             putexcel A270 = "gem1 Calgary"  
             putexcel A271 = "sumw Arandon"  
                putexcel A272 = "v Arandon"  
           putexcel A273 = "lambda Arandon"  
            putexcel A274 = "theta Arandon"  
           putexcel A275 = "lgmean Arandon"  
             putexcel A276 = "mean Arandon"  
             putexcel A277 = "gini Arandon"
              putexcel A278 = "ge2 Arandon"
              putexcel A279= "ge1 Arandon"  
              putexcel A280 = "ge0 Arandon"  
             putexcel A281 = "gem1 Arandon"  
			 
			 putexcel B1 = "Value"
putexcel B2 = `r(between_a2)'
         putexcel B3 = `r(between_a1) '
      putexcel B4 = `r(between_ahalf) '
          putexcel B5 = `r(within_a2) '
          putexcel B6= `r(within_a1) '
       putexcel B7 = `r(within_ahalf) '  
              putexcel B8 = `r(a2_19) '  
              putexcel B9 = `r(a1_19) '  
           putexcel B10 = `r(ahalf_19) '  
              putexcel B11 = `r(a2_18) '  
              putexcel B12 = `r(a1_18) '  
           putexcel B13 = `r(ahalf_18) '  
              putexcel B14 = `r(a2_17) '  
              putexcel B15 = `r(a1_17) '  
           putexcel B16 = `r(ahalf_17) '  
              putexcel B17 = `r(a2_16) '  
              putexcel B18 = `r(a1_16) '  
           putexcel B19 = `r(ahalf_16) '  
              putexcel B20 = `r(a2_15) '  
              putexcel B21 = `r(a1_15) '
           putexcel B22= `r(ahalf_15) '
              putexcel B23 = `r(a2_14) '
              putexcel B24 = `r(a1_14) '  
           putexcel B25 = `r(ahalf_14) '
              putexcel B26 = `r(a2_13) '
              putexcel B27 = `r(a1_13) '  
           putexcel B28 = `r(ahalf_13) ' 
              putexcel B29 = `r(a2_12) ' 
              putexcel B30 = `r(a1_12) '
           putexcel B31 = `r(ahalf_12) ' 
              putexcel B32 = `r(a2_11) ' 
              putexcel B33 = `r(a1_11) '  
           putexcel B34 = `r(ahalf_11) '
              putexcel B35 = `r(a2_10) ' 
              putexcel B36 = `r(a1_10) '
           putexcel B37 = `r(ahalf_10) '  
               putexcel B38 = `r(a2_9) '  
               putexcel B39 = `r(a1_9) ' 
            putexcel B40 = `r(ahalf_9) '  
               putexcel B41 = `r(a2_8) '  
               putexcel B42 = `r(a1_8) '  
            putexcel B43= `r(ahalf_8) '  
               putexcel B44 = `r(a2_7) '  
               putexcel B45 = `r(a1_7) '  
            putexcel B46 = `r(ahalf_7) '  
               putexcel B47 = `r(a2_6) ' 
               putexcel B48 = `r(a1_6) '  
            putexcel B49= `r(ahalf_6) '  
               putexcel B50 = `r(a2_5) '  
               putexcel B51 = `r(a1_5) '  
            putexcel B52 = `r(ahalf_5) '  
               putexcel B53 = `r(a2_4) ' 
               putexcel B54 = `r(a1_4) '  
            putexcel B55 = `r(ahalf_4) ' 
               putexcel B56 = `r(a2_3) '  
               putexcel B57 = `r(a1_3) '
            putexcel B58 = `r(ahalf_3) '  
               putexcel B59 = `r(a2_2) '  
               putexcel B60 = `r(a1_2) ' 
            putexcel B61 = `r(ahalf_2) ' 
               putexcel B62 = `r(a2_1) ' 
               putexcel B63 = `r(a1_1) ' 
            putexcel B64 = `r(ahalf_1) '
        putexcel B65 = `r(between_ge2) ' 
        putexcel B66 = `r(between_ge1) ' 
        putexcel B67 = `r(between_ge0) '
       putexcel B68= `r(between_gem1) '
         putexcel B69 = `r(within_ge2) '
         putexcel B70 = `r(within_ge1) ' 
         putexcel B71 = `r(within_ge0) ' 
        putexcel B72 = `r(within_gem1) '  
            putexcel B73 = `r(sumw_19) '  
               putexcel B74 = `r(v_19) '  
          putexcel B75 = `r(lambda_19) '  
           putexcel B76 = `r(theta_19) '  
          putexcel B77 = `r(lgmean_19) '  
            putexcel B78 = `r(mean_19) ' 
            putexcel B79= `r(gini_19) '  
             putexcel B80 = `r(ge2_19) '  
             putexcel B81 = `r(ge1_19) '
             putexcel B82 = `r(ge0_19) '  
            putexcel B83 = `r(gem1_19) '
            putexcel B84 = `r(sumw_18) '
               putexcel B85 = `r(v_18) '  
          putexcel B86 = `r(lambda_18) '  
           putexcel B87 = `r(theta_18) ' 
          putexcel B88 = `r(lgmean_18) '  
            putexcel B89 = `r(mean_18) ' 
            putexcel B90 = `r(gini_18) ' 
             putexcel B91 = `r(ge2_18) '
             putexcel B92 = `r(ge1_18) ' 
             putexcel B93 = `r(ge0_18) '
            putexcel B94 = `r(gem1_18) ' 
            putexcel B95 = `r(sumw_17) '  
               putexcel B96 = `r(v_17) '
          putexcel B97 = `r(lambda_17) ' 
           putexcel B98 = `r(theta_17) '  
          putexcel B99 = `r(lgmean_17) ' 
            putexcel B100 = `r(mean_17) '
            putexcel B101 = `r(gini_17) ' 
             putexcel B102 = `r(ge2_17) '  
             putexcel B103 = `r(ge1_17) '  
             putexcel B104 = `r(ge0_17) '  
            putexcel B105 = `r(gem1_17) '  
            putexcel B106 = `r(sumw_16) '  
               putexcel B107 = `r(v_16) '
          putexcel B108 = `r(lambda_16) '  
           putexcel B109 = `r(theta_16) '  
          putexcel B110 = `r(lgmean_16) '  
            putexcel B111 = `r(mean_16) '  
            putexcel B112 = `r(gini_16) ' 
             putexcel B113 = `r(ge2_16) '  
             putexcel B114 = `r(ge1_16) '
             putexcel B115 = `r(ge0_16) '  
            putexcel B116= `r(gem1_16) '  
            putexcel B117 = `r(sumw_15) ' 
               putexcel B118 = `r(v_15) '  
          putexcel B119 = `r(lambda_15) '  
           putexcel B120 = `r(theta_15) '  
          putexcel B121 = `r(lgmean_15) '  
            putexcel B122 = `r(mean_15) '  
            putexcel B123 = `r(gini_15) '  
             putexcel B124 = `r(ge2_15) '  
             putexcel B125 = `r(ge1_15) '  
             putexcel B126 = `r(ge0_15) '  
            putexcel B127 = `r(gem1_15) '  
            putexcel B128 = `r(sumw_14) '  
               putexcel B129 = `r(v_14) ' 
          putexcel B130 = `r(lambda_14) '  
           putexcel B131 = `r(theta_14) '  
          putexcel B132 = `r(lgmean_14) '  
            putexcel B133 = `r(mean_14) '  
            putexcel B134 = `r(gini_14) '  
             putexcel B135 = `r(ge2_14) '  
             putexcel B136 = `r(ge1_14) '  
             putexcel B137 = `r(ge0_14) '  
            putexcel B138 = `r(gem1_14) '  
            putexcel B139 = `r(sumw_13) '  
               putexcel B140 = `r(v_13) '  
          putexcel B141 = `r(lambda_13) '  
           putexcel B142 = `r(theta_13) '  
          putexcel B143 = `r(lgmean_13) '  
            putexcel B144 = `r(mean_13) '  
            putexcel B145 = `r(gini_13) '  
             putexcel B146 = `r(ge2_13) '  
             putexcel B147 = `r(ge1_13) '  
             putexcel B148 = `r(ge0_13) '  
            putexcel B149 = `r(gem1_13) '  
            putexcel B150 = `r(sumw_12) '  
               putexcel B151 = `r(v_12) '  
          putexcel B152 = `r(lambda_12) '  
           putexcel B153 = `r(theta_12) '  
          putexcel B154 = `r(lgmean_12) '  
            putexcel B155 = `r(mean_12) '  
            putexcel B156= `r(gini_12) '  
             putexcel B157 = `r(ge2_12) '  
             putexcel B158 = `r(ge1_12) '  
             putexcel B159 = `r(ge0_12) '  
            putexcel B160 = `r(gem1_12) ' 
            putexcel B161 = `r(sumw_11) '  
               putexcel B162 = `r(v_11) '
          putexcel B163 = `r(lambda_11) ' 
           putexcel B164 = `r(theta_11) ' 
          putexcel B165 = `r(lgmean_11) '  
            putexcel B166 = `r(mean_11) ' 
            putexcel B167 = `r(gini_11) '  
             putexcel B168 = `r(ge2_11) '  
             putexcel B169 = `r(ge1_11) ' 
             putexcel B170 = `r(ge0_11) '  
            putexcel B171 = `r(gem1_11) ' 
            putexcel B172 = `r(sumw_10) ' 
               putexcel B173 = `r(v_10) '  
          putexcel B174 = `r(lambda_10) ' 
           putexcel B175 = `r(theta_10) '  
          putexcel B176 = `r(lgmean_10) '
            putexcel B177 = `r(mean_10) ' 
            putexcel B178 = `r(gini_10) '  
             putexcel B179 = `r(ge2_10) '
             putexcel B180 = `r(ge1_10) '  
             putexcel B181 = `r(ge0_10) '  
            putexcel B182 = `r(gem1_10) '  
             putexcel B183 = `r(sumw_9) '  
                putexcel B184 = `r(v_9) ' 
           putexcel B185 = `r(lambda_9) '  
            putexcel B186 = `r(theta_9) ' 
           putexcel B187 = `r(lgmean_9) '  
             putexcel B188 = `r(mean_9) ' 
             putexcel B189 = `r(gini_9) '  
              putexcel B190 = `r(ge2_9) ' 
              putexcel B191 = `r(ge1_9) '  
              putexcel B192 = `r(ge0_9) ' 
             putexcel B193 = `r(gem1_9) '  
             putexcel B194 = `r(sumw_8) '  
                putexcel B195 = `r(v_8) '
           putexcel B196 = `r(lambda_8) ' 
            putexcel B197 = `r(theta_8) ' 
           putexcel B198 = `r(lgmean_8) '  
             putexcel B199 = `r(mean_8) '  
             putexcel B200 = `r(gini_8) '  
              putexcel B201 = `r(ge2_8) '  
              putexcel B202 = `r(ge1_8) ' 
              putexcel B203 = `r(ge0_8) '  
             putexcel B204 = `r(gem1_8) '  
             putexcel B205 = `r(sumw_7) '  
                putexcel B206 = `r(v_7) '  
           putexcel B207 = `r(lambda_7) '  
            putexcel B208 = `r(theta_7) ' 
           putexcel B209 = `r(lgmean_7) '  
             putexcel B210 = `r(mean_7) '  
             putexcel B211 = `r(gini_7) '  
              putexcel B212 = `r(ge2_7) '  
              putexcel B213 = `r(ge1_7) '  
              putexcel B214 = `r(ge0_7) '  
             putexcel B215 = `r(gem1_7) '  
             putexcel B216 = `r(sumw_6) '  
                putexcel B217 = `r(v_6) '  
           putexcel B218 = `r(lambda_6) '  
            putexcel B219 = `r(theta_6) '  
           putexcel B220 = `r(lgmean_6) '  
             putexcel B221 = `r(mean_6) '  
             putexcel B222 = `r(gini_6) '  
              putexcel B223 = `r(ge2_6) '  
              putexcel B224 = `r(ge1_6) '  
              putexcel B225 = `r(ge0_6) '  
             putexcel B226 = `r(gem1_6) '  
             putexcel B227 = `r(sumw_5) '  
                putexcel B228 = `r(v_5) '  
           putexcel B229 = `r(lambda_5) '  
            putexcel B230 = `r(theta_5) '  
           putexcel B231 = `r(lgmean_5) '  
             putexcel B232 = `r(mean_5) '  
             putexcel B233 = `r(gini_5) '  
              putexcel B234 = `r(ge2_5) '  
              putexcel B235 = `r(ge1_5) '  
              putexcel B236 = `r(ge0_5) '  
             putexcel B327 = `r(gem1_5) '  
             putexcel B238 = `r(sumw_4) '  
                putexcel B239 = `r(v_4) '  
           putexcel B240 = `r(lambda_4) '  
            putexcel B241 = `r(theta_4) '  
           putexcel B242 = `r(lgmean_4) '  
             putexcel B243 = `r(mean_4) '  
             putexcel B244 = `r(gini_4) '  
              putexcel B245 = `r(ge2_4) '  
              putexcel B246 = `r(ge1_4) '  
              putexcel B247 = `r(ge0_4) '  
             putexcel B248 = `r(gem1_4) '  
             putexcel B249 = `r(sumw_3) '  
                putexcel B250 = `r(v_3) '  
           putexcel B251 = `r(lambda_3) '  
            putexcel B252 = `r(theta_3) '  
           putexcel B253 = `r(lgmean_3) '  
             putexcel B254 = `r(mean_3) '  
             putexcel B255 = `r(gini_3) '  
              putexcel B256 = `r(ge2_3) '  
              putexcel B257 = `r(ge1_3) '  
              putexcel B258 = `r(ge0_3) '  
             putexcel B259 = `r(gem1_3) '  
             putexcel B260 = `r(sumw_2) '  
                putexcel B261 = `r(v_2) '  
           putexcel B262 = `r(lambda_2) '  
            putexcel B263 = `r(theta_2) '  
           putexcel B264 = `r(lgmean_2) '  
             putexcel B265 = `r(mean_2) '  
             putexcel B266 = `r(gini_2) '  
              putexcel B267 = `r(ge2_2) '  
              putexcel B268 = `r(ge1_2) '  
              putexcel B269 = `r(ge0_2) '  
             putexcel B270 = `r(gem1_2) '  
             putexcel B271 = `r(sumw_1) '  
                putexcel B272 = `r(v_1) '  
           putexcel B273 = `r(lambda_1) '  
            putexcel B274 = `r(theta_1) '  
           putexcel B275 = `r(lgmean_1) '  
             putexcel B276 = `r(mean_1) '  
             putexcel B277 = `r(gini_1) '
              putexcel B278 = `r(ge2_1) '
              putexcel B279= `r(ge1_1) '  
              putexcel B280 = `r(ge0_1) '  



 
   di "PPP-adjusted income"
   ineqdeco ppp_income [aw=WTS_SDLE] if year==`i', bygroup(cities) 
   putexcel set "table\4.5.ineqdeco_by_city.xls", sheet(PPP - `i', replace) modify
         putexcel A1 = "Statistics"
		  putexcel A2 = "between A(2) "
putexcel A3 = "between  A(1)"
      putexcel A4 = "between A(0.5)"
          putexcel A5 = "within A(2)"
          putexcel A6= "within  A(1)"
       putexcel A7 = "within A(0.5)"  
              putexcel A8 = " A(2) Winnipeg"  
              putexcel A9 = " A(1) Winnipeg"  
           putexcel A10 = "A(0.5) Winnipeg"  
              putexcel A11 = " A(2) Vancouver"  
              putexcel A12 = " A(1) Vancouver"  
           putexcel A13 = "A(0.5) Vancouver"  
              putexcel A14 = " A(2) Toronto"  
              putexcel A15 = " A(1) Toronto"  
           putexcel A16 = "A(0.5) Toronto"  
              putexcel A17 = " A(2) St Johns"  
              putexcel A18 = " A(1) St Johns"  
           putexcel A19 = "A(0.5) St Johns"  
              putexcel A20 = " A(2) Saskatoon"  
              putexcel A21 = " A(1) Saskatoon"
           putexcel A22= "A(0.5) Saskatoon"
              putexcel A23 = " A(2) Saint John"
              putexcel A24 = " A(1) Saint John"  
           putexcel A25 = "A(0.5) Saint John"
              putexcel A26 = " A(2) Regina"
              putexcel A27 = " A(1) Regina"  
           putexcel A28 = "A(0.5) Regina" 
              putexcel A29 = " A(2) Quebec" 
              putexcel A30 = " A(1) Quebec"
           putexcel A31 = "A(0.5) Quebec" 
              putexcel A32 = " A(2) Ottawa-Gatineau" 
              putexcel A33 = " A(1) Ottawa-Gatineau"  
           putexcel A34 = "A(0.5) Ottawa-Gatineau"
              putexcel A35 = " A(2) Montreal" 
              putexcel A36 = " A(1) Montreal"
           putexcel A37 = "A(0.5) Montreal"  
               putexcel A38 = " A(2) Hamilton/Burlington"  
               putexcel A39 = " A(1) Hamilton/Burlington" 
            putexcel A40 = "A(0.5) Hamilton/Burlington"  
               putexcel A41 = " A(2) 8"  
               putexcel A42 = " A(1) 8"  
            putexcel A43= "A(0.5) 8"  
               putexcel A44 = " A(2) Halifax"  
               putexcel A45 = " A(1) Halifax"  
            putexcel A46 = "A(0.5) Halifax"  
               putexcel A47 = " A(2) Fredericton" 
               putexcel A48 = " A(1) Fredericton"  
            putexcel A49= "A(0.5) Fredericton"  
               putexcel A50 = " A(2) Edmonton"  
               putexcel A51 = " A(1) Edmonton"  
            putexcel A52 = "A(0.5) Edmonton"  
               putexcel A53 = " A(2) Charlottetown" 
               putexcel A54 = " A(1) Charlottetown"  
            putexcel A55 = "A(0.5) Charlottetown" 
               putexcel A56 = " A(2) Cape Areton"  
               putexcel A57 = " A(1) Cape Areton"
            putexcel A58 = "A(0.5) Cape Areton"  
               putexcel A59 = " A(2) Calgary"  
               putexcel A60 = " A(1) Calgary" 
            putexcel A61 = "A(0.5) Calgary" 
               putexcel A62 = " A(2) Arandon" 
               putexcel A63 = " A(1) Arandon" 
            putexcel A64 = "A(0.5) Arandon"
        putexcel A65 = "between ge2" 
        putexcel A66 = "between ge1" 
        putexcel A67 = "between ge0"
       putexcel A68= "between gem1"
         putexcel A69 = "within ge2"
         putexcel A70 = "within ge1" 
         putexcel A71 = "within ge0" 
        putexcel A72 = "within gem1"  
            putexcel A73 = "sumw Winnipeg"  
               putexcel A74 = "v Winnipeg"  
          putexcel A75 = "lambda Winnipeg"  
           putexcel A76 = "theta Winnipeg"  
          putexcel A77 = "lgmean Winnipeg"  
            putexcel A78 = "mean Winnipeg" 
            putexcel A79= "gini Winnipeg"  
             putexcel A80 = "ge2 Winnipeg"  
             putexcel A81 = "ge1 Winnipeg"
             putexcel A82 = "ge0 Winnipeg"  
            putexcel A83 = "gem1 Winnipeg"
            putexcel A84 = "sumw Vancouver"
               putexcel A85 = "v Vancouver"  
          putexcel A86 = "lambda Vancouver"  
           putexcel A87 = "theta Vancouver" 
          putexcel A88 = "lgmean Vancouver"  
            putexcel A89 = "mean Vancouver" 
            putexcel A90 = "gini Vancouver" 
             putexcel A91 = "ge2 Vancouver"
             putexcel A92 = "ge1 Vancouver" 
             putexcel A93 = "ge0 Vancouver"
            putexcel A94 = "gem1 Vancouver" 
            putexcel A95 = "sumw Toronto"  
               putexcel A96 = "v Toronto"
          putexcel A97 = "lambda Toronto" 
           putexcel A98 = "theta Toronto"  
          putexcel A99 = "lgmean Toronto" 
            putexcel A100 = "mean Toronto"
            putexcel A101 = "gini Toronto" 
             putexcel A102 = "ge2 Toronto"  
             putexcel A103 = "ge1 Toronto"  
             putexcel A104 = "ge0 Toronto"  
            putexcel A105 = "gem1 Toronto"  
            putexcel A106 = "sumw St Johns"  
               putexcel A107 = "v St Johns"
          putexcel A108 = "lambda St Johns"  
           putexcel A109 = "theta St Johns"  
          putexcel A110 = "lgmean St Johns"  
            putexcel A111 = "mean St Johns"  
            putexcel A112 = "gini St Johns" 
             putexcel A113 = "ge2 St Johns"  
             putexcel A114 = "ge1 St Johns"
             putexcel A115 = "ge0 St Johns"  
            putexcel A116= "gem1 St Johns"  
            putexcel A117 = "sumw Saskatoon" 
               putexcel A118 = "v Saskatoon"  
          putexcel A119 = "lambda Saskatoon"  
           putexcel A120 = "theta Saskatoon"  
          putexcel A121 = "lgmean Saskatoon"  
            putexcel A122 = "mean Saskatoon"  
            putexcel A123 = "gini Saskatoon"  
             putexcel A124 = "ge2 Saskatoon"  
             putexcel A125 = "ge1 Saskatoon"  
             putexcel A126 = "ge0 Saskatoon"  
            putexcel A127 = "gem1 Saskatoon"  
            putexcel A128 = "sumw Saint John"  
               putexcel A129 = "v Saint John" 
          putexcel A130 = "lambda Saint John"  
           putexcel A131 = "theta Saint John"  
          putexcel A132 = "lgmean Saint John"  
            putexcel A133 = "mean Saint John"  
            putexcel A134 = "gini Saint John"  
             putexcel A135 = "ge2 Saint John"  
             putexcel A136 = "ge1 Saint John"  
             putexcel A137 = "ge0 Saint John"  
            putexcel A138 = "gem1 Saint John"  
            putexcel A139 = "sumw Regina"  
               putexcel A140 = "v Regina"  
          putexcel A141 = "lambda Regina"  
           putexcel A142 = "theta Regina"  
          putexcel A143 = "lgmean Regina"  
            putexcel A144 = "mean Regina"  
            putexcel A145 = "gini Regina"  
             putexcel A146 = "ge2 Regina"  
             putexcel A147 = "ge1 Regina"  
             putexcel A148 = "ge0 Regina"  
            putexcel A149 = "gem1 Regina"  
            putexcel A150 = "sumw Quebec"  
               putexcel A151 = "v Quebec"  
          putexcel A152 = "lambda Quebec"  
           putexcel A153 = "theta Quebec"  
          putexcel A154 = "lgmean Quebec"  
            putexcel A155 = "mean Quebec"  
            putexcel A156= "gini Quebec"  
             putexcel A157 = "ge2 Quebec"  
             putexcel A158 = "ge1 Quebec"  
             putexcel A159 = "ge0 Quebec"  
            putexcel A160 = "gem1 Quebec" 
            putexcel A161 = "sumw Ottawa-Gatineau"  
               putexcel A162 = "v Ottawa-Gatineau"
          putexcel A163 = "lambda Ottawa-Gatineau" 
           putexcel A164 = "theta Ottawa-Gatineau" 
          putexcel A165 = "lgmean Ottawa-Gatineau"  
            putexcel A166 = "mean Ottawa-Gatineau" 
            putexcel A167 = "gini Ottawa-Gatineau"  
             putexcel A168 = "ge2 Ottawa-Gatineau"  
             putexcel A169 = "ge1 Ottawa-Gatineau" 
             putexcel A170 = "ge0 Ottawa-Gatineau"  
            putexcel A171 = "gem1 Ottawa-Gatineau" 
            putexcel A172 = "sumw Montreal" 
               putexcel A173 = "v Montreal"  
          putexcel A174 = "lambda Montreal" 
           putexcel A175 = "theta Montreal"  
          putexcel A176 = "lgmean Montreal"
            putexcel A177 = "mean Montreal" 
            putexcel A178 = "gini Montreal"  
             putexcel A179 = "ge2 Montreal"
             putexcel A180 = "ge1 Montreal"  
             putexcel A181 = "ge0 Montreal"  
            putexcel A182 = "gem1 Montreal"  
             putexcel A183 = "sumw Hamilton/Burlington"  
                putexcel A184 = "v Hamilton/Burlington" 
           putexcel A185 = "lambda Hamilton/Burlington"  
            putexcel A186 = "theta Hamilton/Burlington" 
           putexcel A187 = "lgmean Hamilton/Burlington"  
             putexcel A188 = "mean Hamilton/Burlington" 
             putexcel A189 = "gini Hamilton/Burlington"  
              putexcel A190 = "ge2 Hamilton/Burlington" 
              putexcel A191 = "ge1 Hamilton/Burlington"  
              putexcel A192 = "ge0 Hamilton/Burlington" 
             putexcel A193 = "gem1 Hamilton/Burlington"  
             putexcel A194 = "sumw 8"  
                putexcel A195 = "v 8"
           putexcel A196 = "lambda 8" 
            putexcel A197 = "theta 8" 
           putexcel A198 = "lgmean 8"  
             putexcel A199 = "mean 8"  
             putexcel A200 = "gini 8"  
              putexcel A201 = "ge2 8"  
              putexcel A202 = "ge1 8" 
              putexcel A203 = "ge0 8"  
             putexcel A204 = "gem1 8"  
             putexcel A205 = "sumw Halifax"  
                putexcel A206 = "v Halifax"  
           putexcel A207 = "lambda Halifax"  
            putexcel A208 = "theta Halifax" 
           putexcel A209 = "lgmean Halifax"  
             putexcel A210 = "mean Halifax"  
             putexcel A211 = "gini Halifax"  
              putexcel A212 = "ge2 Halifax"  
              putexcel A213 = "ge1 Halifax"  
              putexcel A214 = "ge0 Halifax"  
             putexcel A215 = "gem1 Halifax"  
             putexcel A216 = "sumw Fredericton"  
                putexcel A217 = "v Fredericton"  
           putexcel A218 = "lambda Fredericton"  
            putexcel A219 = "theta Fredericton"  
           putexcel A220 = "lgmean Fredericton"  
             putexcel A221 = "mean Fredericton"  
             putexcel A222 = "gini Fredericton"  
              putexcel A223 = "ge2 Fredericton"  
              putexcel A224 = "ge1 Fredericton"  
              putexcel A225 = "ge0 Fredericton"  
             putexcel A226 = "gem1 Fredericton"  
             putexcel A227 = "sumw Edmonton"  
                putexcel A228 = "v Edmonton"  
           putexcel A229 = "lambda Edmonton"  
            putexcel A230 = "theta Edmonton"  
           putexcel A231 = "lgmean Edmonton"  
             putexcel A232 = "mean Edmonton"  
             putexcel A233 = "gini Edmonton"  
              putexcel A234 = "ge2 Edmonton"  
              putexcel A235 = "ge1 Edmonton"  
              putexcel A236 = "ge0 Edmonton"  
             putexcel A327 = "gem1 Edmonton"  
             putexcel A238 = "sumw Charlottetown"  
                putexcel A239 = "v Charlottetown"  
           putexcel A240 = "lambda Charlottetown"  
            putexcel A241 = "theta Charlottetown"  
           putexcel A242 = "lgmean Charlottetown"  
             putexcel A243 = "mean Charlottetown"  
             putexcel A244 = "gini Charlottetown"  
              putexcel A245 = "ge2 Charlottetown"  
              putexcel A246 = "ge1 Charlottetown"  
              putexcel A247 = "ge0 Charlottetown"  
             putexcel A248 = "gem1 Charlottetown"  
             putexcel A249 = "sumw Cape Areton"  
                putexcel A250 = "v Cape Areton"  
           putexcel A251 = "lambda Cape Areton"  
            putexcel A252 = "theta Cape Areton"  
           putexcel A253 = "lgmean Cape Areton"  
             putexcel A254 = "mean Cape Areton"  
             putexcel A255 = "gini Cape Areton"  
              putexcel A256 = "ge2 Cape Areton"  
              putexcel A257 = "ge1 Cape Areton"  
              putexcel A258 = "ge0 Cape Areton"  
             putexcel A259 = "gem1 Cape Areton"  
             putexcel A260 = "sumw Calgary"  
                putexcel A261 = "v Calgary"  
           putexcel A262 = "lambda Calgary"  
            putexcel A263 = "theta Calgary"  
           putexcel A264 = "lgmean Calgary"  
             putexcel A265 = "mean Calgary"  
             putexcel A266 = "gini Calgary"  
              putexcel A267 = "ge2 Calgary"  
              putexcel A268 = "ge1 Calgary"  
              putexcel A269 = "ge0 Calgary"  
             putexcel A270 = "gem1 Calgary"  
             putexcel A271 = "sumw Arandon"  
                putexcel A272 = "v Arandon"  
           putexcel A273 = "lambda Arandon"  
            putexcel A274 = "theta Arandon"  
           putexcel A275 = "lgmean Arandon"  
             putexcel A276 = "mean Arandon"  
             putexcel A277 = "gini Arandon"
              putexcel A278 = "ge2 Arandon"
              putexcel A279= "ge1 Arandon"  
              putexcel A280 = "ge0 Arandon"  
             putexcel A281 = "gem1 Arandon"  
			 
			 putexcel B1 = "Value"
putexcel B2 = `r(between_a2)'
         putexcel B3 = `r(between_a1) '
      putexcel B4 = `r(between_ahalf) '
          putexcel B5 = `r(within_a2) '
          putexcel B6= `r(within_a1) '
       putexcel B7 = `r(within_ahalf) '  
              putexcel B8 = `r(a2_19) '  
              putexcel B9 = `r(a1_19) '  
           putexcel B10 = `r(ahalf_19) '  
              putexcel B11 = `r(a2_18) '  
              putexcel B12 = `r(a1_18) '  
           putexcel B13 = `r(ahalf_18) '  
              putexcel B14 = `r(a2_17) '  
              putexcel B15 = `r(a1_17) '  
           putexcel B16 = `r(ahalf_17) '  
              putexcel B17 = `r(a2_16) '  
              putexcel B18 = `r(a1_16) '  
           putexcel B19 = `r(ahalf_16) '  
              putexcel B20 = `r(a2_15) '  
              putexcel B21 = `r(a1_15) '
           putexcel B22= `r(ahalf_15) '
              putexcel B23 = `r(a2_14) '
              putexcel B24 = `r(a1_14) '  
           putexcel B25 = `r(ahalf_14) '
              putexcel B26 = `r(a2_13) '
              putexcel B27 = `r(a1_13) '  
           putexcel B28 = `r(ahalf_13) ' 
              putexcel B29 = `r(a2_12) ' 
              putexcel B30 = `r(a1_12) '
           putexcel B31 = `r(ahalf_12) ' 
              putexcel B32 = `r(a2_11) ' 
              putexcel B33 = `r(a1_11) '  
           putexcel B34 = `r(ahalf_11) '
              putexcel B35 = `r(a2_10) ' 
              putexcel B36 = `r(a1_10) '
           putexcel B37 = `r(ahalf_10) '  
               putexcel B38 = `r(a2_9) '  
               putexcel B39 = `r(a1_9) ' 
            putexcel B40 = `r(ahalf_9) '  
               putexcel B41 = `r(a2_8) '  
               putexcel B42 = `r(a1_8) '  
            putexcel B43= `r(ahalf_8) '  
               putexcel B44 = `r(a2_7) '  
               putexcel B45 = `r(a1_7) '  
            putexcel B46 = `r(ahalf_7) '  
               putexcel B47 = `r(a2_6) ' 
               putexcel B48 = `r(a1_6) '  
            putexcel B49= `r(ahalf_6) '  
               putexcel B50 = `r(a2_5) '  
               putexcel B51 = `r(a1_5) '  
            putexcel B52 = `r(ahalf_5) '  
               putexcel B53 = `r(a2_4) ' 
               putexcel B54 = `r(a1_4) '  
            putexcel B55 = `r(ahalf_4) ' 
               putexcel B56 = `r(a2_3) '  
               putexcel B57 = `r(a1_3) '
            putexcel B58 = `r(ahalf_3) '  
               putexcel B59 = `r(a2_2) '  
               putexcel B60 = `r(a1_2) ' 
            putexcel B61 = `r(ahalf_2) ' 
               putexcel B62 = `r(a2_1) ' 
               putexcel B63 = `r(a1_1) ' 
            putexcel B64 = `r(ahalf_1) '
        putexcel B65 = `r(between_ge2) ' 
        putexcel B66 = `r(between_ge1) ' 
        putexcel B67 = `r(between_ge0) '
       putexcel B68= `r(between_gem1) '
         putexcel B69 = `r(within_ge2) '
         putexcel B70 = `r(within_ge1) ' 
         putexcel B71 = `r(within_ge0) ' 
        putexcel B72 = `r(within_gem1) '  
            putexcel B73 = `r(sumw_19) '  
               putexcel B74 = `r(v_19) '  
          putexcel B75 = `r(lambda_19) '  
           putexcel B76 = `r(theta_19) '  
          putexcel B77 = `r(lgmean_19) '  
            putexcel B78 = `r(mean_19) ' 
            putexcel B79= `r(gini_19) '  
             putexcel B80 = `r(ge2_19) '  
             putexcel B81 = `r(ge1_19) '
             putexcel B82 = `r(ge0_19) '  
            putexcel B83 = `r(gem1_19) '
            putexcel B84 = `r(sumw_18) '
               putexcel B85 = `r(v_18) '  
          putexcel B86 = `r(lambda_18) '  
           putexcel B87 = `r(theta_18) ' 
          putexcel B88 = `r(lgmean_18) '  
            putexcel B89 = `r(mean_18) ' 
            putexcel B90 = `r(gini_18) ' 
             putexcel B91 = `r(ge2_18) '
             putexcel B92 = `r(ge1_18) ' 
             putexcel B93 = `r(ge0_18) '
            putexcel B94 = `r(gem1_18) ' 
            putexcel B95 = `r(sumw_17) '  
               putexcel B96 = `r(v_17) '
          putexcel B97 = `r(lambda_17) ' 
           putexcel B98 = `r(theta_17) '  
          putexcel B99 = `r(lgmean_17) ' 
            putexcel B100 = `r(mean_17) '
            putexcel B101 = `r(gini_17) ' 
             putexcel B102 = `r(ge2_17) '  
             putexcel B103 = `r(ge1_17) '  
             putexcel B104 = `r(ge0_17) '  
            putexcel B105 = `r(gem1_17) '  
            putexcel B106 = `r(sumw_16) '  
               putexcel B107 = `r(v_16) '
          putexcel B108 = `r(lambda_16) '  
           putexcel B109 = `r(theta_16) '  
          putexcel B110 = `r(lgmean_16) '  
            putexcel B111 = `r(mean_16) '  
            putexcel B112 = `r(gini_16) ' 
             putexcel B113 = `r(ge2_16) '  
             putexcel B114 = `r(ge1_16) '
             putexcel B115 = `r(ge0_16) '  
            putexcel B116= `r(gem1_16) '  
            putexcel B117 = `r(sumw_15) ' 
               putexcel B118 = `r(v_15) '  
          putexcel B119 = `r(lambda_15) '  
           putexcel B120 = `r(theta_15) '  
          putexcel B121 = `r(lgmean_15) '  
            putexcel B122 = `r(mean_15) '  
            putexcel B123 = `r(gini_15) '  
             putexcel B124 = `r(ge2_15) '  
             putexcel B125 = `r(ge1_15) '  
             putexcel B126 = `r(ge0_15) '  
            putexcel B127 = `r(gem1_15) '  
            putexcel B128 = `r(sumw_14) '  
               putexcel B129 = `r(v_14) ' 
          putexcel B130 = `r(lambda_14) '  
           putexcel B131 = `r(theta_14) '  
          putexcel B132 = `r(lgmean_14) '  
            putexcel B133 = `r(mean_14) '  
            putexcel B134 = `r(gini_14) '  
             putexcel B135 = `r(ge2_14) '  
             putexcel B136 = `r(ge1_14) '  
             putexcel B137 = `r(ge0_14) '  
            putexcel B138 = `r(gem1_14) '  
            putexcel B139 = `r(sumw_13) '  
               putexcel B140 = `r(v_13) '  
          putexcel B141 = `r(lambda_13) '  
           putexcel B142 = `r(theta_13) '  
          putexcel B143 = `r(lgmean_13) '  
            putexcel B144 = `r(mean_13) '  
            putexcel B145 = `r(gini_13) '  
             putexcel B146 = `r(ge2_13) '  
             putexcel B147 = `r(ge1_13) '  
             putexcel B148 = `r(ge0_13) '  
            putexcel B149 = `r(gem1_13) '  
            putexcel B150 = `r(sumw_12) '  
               putexcel B151 = `r(v_12) '  
          putexcel B152 = `r(lambda_12) '  
           putexcel B153 = `r(theta_12) '  
          putexcel B154 = `r(lgmean_12) '  
            putexcel B155 = `r(mean_12) '  
            putexcel B156= `r(gini_12) '  
             putexcel B157 = `r(ge2_12) '  
             putexcel B158 = `r(ge1_12) '  
             putexcel B159 = `r(ge0_12) '  
            putexcel B160 = `r(gem1_12) ' 
            putexcel B161 = `r(sumw_11) '  
               putexcel B162 = `r(v_11) '
          putexcel B163 = `r(lambda_11) ' 
           putexcel B164 = `r(theta_11) ' 
          putexcel B165 = `r(lgmean_11) '  
            putexcel B166 = `r(mean_11) ' 
            putexcel B167 = `r(gini_11) '  
             putexcel B168 = `r(ge2_11) '  
             putexcel B169 = `r(ge1_11) ' 
             putexcel B170 = `r(ge0_11) '  
            putexcel B171 = `r(gem1_11) ' 
            putexcel B172 = `r(sumw_10) ' 
               putexcel B173 = `r(v_10) '  
          putexcel B174 = `r(lambda_10) ' 
           putexcel B175 = `r(theta_10) '  
          putexcel B176 = `r(lgmean_10) '
            putexcel B177 = `r(mean_10) ' 
            putexcel B178 = `r(gini_10) '  
             putexcel B179 = `r(ge2_10) '
             putexcel B180 = `r(ge1_10) '  
             putexcel B181 = `r(ge0_10) '  
            putexcel B182 = `r(gem1_10) '  
             putexcel B183 = `r(sumw_9) '  
                putexcel B184 = `r(v_9) ' 
           putexcel B185 = `r(lambda_9) '  
            putexcel B186 = `r(theta_9) ' 
           putexcel B187 = `r(lgmean_9) '  
             putexcel B188 = `r(mean_9) ' 
             putexcel B189 = `r(gini_9) '  
              putexcel B190 = `r(ge2_9) ' 
              putexcel B191 = `r(ge1_9) '  
              putexcel B192 = `r(ge0_9) ' 
             putexcel B193 = `r(gem1_9) '  
             putexcel B194 = `r(sumw_8) '  
                putexcel B195 = `r(v_8) '
           putexcel B196 = `r(lambda_8) ' 
            putexcel B197 = `r(theta_8) ' 
           putexcel B198 = `r(lgmean_8) '  
             putexcel B199 = `r(mean_8) '  
             putexcel B200 = `r(gini_8) '  
              putexcel B201 = `r(ge2_8) '  
              putexcel B202 = `r(ge1_8) ' 
              putexcel B203 = `r(ge0_8) '  
             putexcel B204 = `r(gem1_8) '  
             putexcel B205 = `r(sumw_7) '  
                putexcel B206 = `r(v_7) '  
           putexcel B207 = `r(lambda_7) '  
            putexcel B208 = `r(theta_7) ' 
           putexcel B209 = `r(lgmean_7) '  
             putexcel B210 = `r(mean_7) '  
             putexcel B211 = `r(gini_7) '  
              putexcel B212 = `r(ge2_7) '  
              putexcel B213 = `r(ge1_7) '  
              putexcel B214 = `r(ge0_7) '  
             putexcel B215 = `r(gem1_7) '  
             putexcel B216 = `r(sumw_6) '  
                putexcel B217 = `r(v_6) '  
           putexcel B218 = `r(lambda_6) '  
            putexcel B219 = `r(theta_6) '  
           putexcel B220 = `r(lgmean_6) '  
             putexcel B221 = `r(mean_6) '  
             putexcel B222 = `r(gini_6) '  
              putexcel B223 = `r(ge2_6) '  
              putexcel B224 = `r(ge1_6) '  
              putexcel B225 = `r(ge0_6) '  
             putexcel B226 = `r(gem1_6) '  
             putexcel B227 = `r(sumw_5) '  
                putexcel B228 = `r(v_5) '  
           putexcel B229 = `r(lambda_5) '  
            putexcel B230 = `r(theta_5) '  
           putexcel B231 = `r(lgmean_5) '  
             putexcel B232 = `r(mean_5) '  
             putexcel B233 = `r(gini_5) '  
              putexcel B234 = `r(ge2_5) '  
              putexcel B235 = `r(ge1_5) '  
              putexcel B236 = `r(ge0_5) '  
             putexcel B327 = `r(gem1_5) '  
             putexcel B238 = `r(sumw_4) '  
                putexcel B239 = `r(v_4) '  
           putexcel B240 = `r(lambda_4) '  
            putexcel B241 = `r(theta_4) '  
           putexcel B242 = `r(lgmean_4) '  
             putexcel B243 = `r(mean_4) '  
             putexcel B244 = `r(gini_4) '  
              putexcel B245 = `r(ge2_4) '  
              putexcel B246 = `r(ge1_4) '  
              putexcel B247 = `r(ge0_4) '  
             putexcel B248 = `r(gem1_4) '  
             putexcel B249 = `r(sumw_3) '  
                putexcel B250 = `r(v_3) '  
           putexcel B251 = `r(lambda_3) '  
            putexcel B252 = `r(theta_3) '  
           putexcel B253 = `r(lgmean_3) '  
             putexcel B254 = `r(mean_3) '  
             putexcel B255 = `r(gini_3) '  
              putexcel B256 = `r(ge2_3) '  
              putexcel B257 = `r(ge1_3) '  
              putexcel B258 = `r(ge0_3) '  
             putexcel B259 = `r(gem1_3) '  
             putexcel B260 = `r(sumw_2) '  
                putexcel B261 = `r(v_2) '  
           putexcel B262 = `r(lambda_2) '  
            putexcel B263 = `r(theta_2) '  
           putexcel B264 = `r(lgmean_2) '  
             putexcel B265 = `r(mean_2) '  
             putexcel B266 = `r(gini_2) '  
              putexcel B267 = `r(ge2_2) '  
              putexcel B268 = `r(ge1_2) '  
              putexcel B269 = `r(ge0_2) '  
             putexcel B270 = `r(gem1_2) '  
             putexcel B271 = `r(sumw_1) '  
                putexcel B272 = `r(v_1) '  
           putexcel B273 = `r(lambda_1) '  
            putexcel B274 = `r(theta_1) '  
           putexcel B275 = `r(lgmean_1) '  
             putexcel B276 = `r(mean_1) '  
             putexcel B277 = `r(gini_1) '
              putexcel B278 = `r(ge2_1) '
              putexcel B279= `r(ge1_1) '  
              putexcel B280 = `r(ge0_1) '  

}


* supporting frequencies
forvalues i=2011/2015 {
   di `i'
   di "Regular income"
   ineqdeco equivalized_income  if year==`i', bygroup(cities) 
   putexcel set "table\4.5.ineqdeco_by_prov_city_freq.xls", sheet(national distr- `i', replace) modify
putexcel A1= "Count"
putexcel B1= "Value"

putexcel A2= "p95"
putexcel A3= "p90"
putexcel A4= "p75"
putexcel A5= "p50"
putexcel A6= "p25"
putexcel A7= "p10"
putexcel A8= "p5"
putexcel A9= "N"


putexcel B2= `r(p95)'
putexcel B3= `r(p90)'
putexcel B4= `r(p75)'
putexcel B5= `r(p50)'
putexcel B6= `r(p25)'
putexcel B7= `r(p10)'
putexcel B8= `r(p5)'
putexcel B9= `r(N)'
   
   di "PPP-adjusted income"
   ineqdeco ppp_income if year==`i' , bygroup(cities) 
   putexcel set "table\4.5.ineqdeco_by_city_freq.xls", sheet(PPP - `i', replace) modify
putexcel A1= "Count"
putexcel B1= "Value"

putexcel A2= "p95"
putexcel A3= "p90"
putexcel A4= "p75"
putexcel A5= "p50"
putexcel A6= "p25"
putexcel A7= "p10"
putexcel A8= "p5"
putexcel A9= "N"


putexcel B2= `r(p95)'
putexcel B3= `r(p90)'
putexcel B4= `r(p75)'
putexcel B5= `r(p50)'
putexcel B6= `r(p25)'
putexcel B7= `r(p10)'
putexcel B8= `r(p5)'
putexcel B9= `r(N)'
}


*===============================================================================

**#                      *6.Bottom and top ends of the distribution

*===============================================================================

* Low-income measure

  // National distribution
  * percentages  
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear  
bys year:  tab lim [aw=WTS_SDLE]
xcontract lim [aw=WTS_SDLE], fast by(year) nomiss  p(percent)
drop _freq
format _all  %9.1f
drop if lim==0
export excel "table\4.6.tails_distribution.xlsx", firstrow(varl) sheet("LIM", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear  
bys year:  tab lim
xcontract lim , fast by(year) nomiss  p(percent)
drop percent
drop if lim==0
gen flag=1 if _freq<15
export excel "table\4.6.tails_distribution_freq.xlsx", firstrow(varl) sheet("LIM", replace)
  
  // PPP-adjusted distribution
  * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear  
bys year:  tab ppp_lim [aw=WTS_SDLE]
xcontract ppp_lim [aw=WTS_SDLE], fast by(year) nomiss  p(percent)
drop _freq
format _all  %9.1f
drop if ppp_lim==0
export excel "table\4.6.tails_distribution.xlsx", firstrow(varl) sheet("PPP LIM", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear  
bys year:  tab ppp_lim 
xcontract ppp_lim, fast by(year) nomiss  p(percent)
drop percent
drop if ppp_lim==0
gen flag=1 if _freq<15
export excel "table\4.6.tails_distribution_freq.xlsx", firstrow(varl) sheet("PPP LIM", replace) 

 // National vs PPP distribution: LIM comparison
  * percentages  
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear  
bys year:  tab ppp_lim lim [aw=WTS_SDLE]
xcontract ppp_lim lim [aw=WTS_SDLE], fast by(year) nomiss p(percent)
drop _freq
format _all  %9.1f
export excel "table\4.6.tails_distribution.xlsx", firstrow(varl) sheet("PPP LIM vs LIM", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear  
bys year:  tab ppp_lim lim
xcontract ppp_lim lim , fast by(year) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
export excel "table\4.6.tails_distribution_freq.xlsx", firstrow(varl) sheet("PPP LIM vs LIM", replace)   
  
  
  * analysis by province of residence
  
  //National distribution
  * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear  
bys year fprov:  tab lim [aw=WTS_SDLE]
xcontract lim [aw=WTS_SDLE], fast by(year fprov) nomiss p(percent)
drop _freq
format _all  %9.1f
drop if lim==0
export excel "table\4.6.tails_distribution.xlsx", firstrow(varl) sheet("LIM - By province", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear  
bys year fprov:  tab lim 
xcontract lim , fast by(year fprov) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
drop if lim==0
export excel "table\4.6.tails_distribution_freq.xlsx", firstrow(varl) sheet("LIM - By province", replace)   

 // PPP distribution
  
  * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear  
bys year fprov:  tab ppp_lim [aw=WTS_SDLE]
xcontract ppp_lim [aw=WTS_SDLE], fast by(year fprov) nomiss p(percent)
drop _freq
format _all  %9.1f
drop if ppp_lim==0
export excel "table\4.6.tails_distribution.xlsx", firstrow(varl) sheet("PPP LIM - By province", replace) 
 
  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear  
bys year fprov:  tab ppp_lim 
xcontract ppp_lim, fast by(year fprov) nomiss p(percent)
drop percent
drop if ppp_lim==0
gen flag=1 if _freq<15
export excel "table\4.6.tails_distribution_freq.xlsx", firstrow(varl) sheet("PPP LIM - By province", replace)   
  
  * analysis in cities 
  
  //National distribution
  * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear  
bys year city:  tab lim [aw=WTS_SDLE]
xcontract lim [aw=WTS_SDLE]  if city=="Montreal" | city== "Vancouver" | city=="Toronto", fast by(year city) nomiss p(percent)
drop _freq
format percent  %9.1f
drop if lim==0
export excel "table\4.6.tails_distribution.xlsx", firstrow(varl) sheet("LIM - By city", replace) 


  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear  
bys year city:  tab lim 
xcontract lim  if city=="Montreal" | city== "Vancouver" | city=="Toronto" , fast by(year city) nomiss p(percent)
drop if lim==0
gen flag=1 if _freq<15 
export excel "table\4.6.tails_distribution_freq.xlsx", firstrow(varl) sheet("LIM - By city", replace)   
  
  // PPP distribution
  * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear  
bys year city:  tab ppp_lim [aw=WTS_SDLE]
xcontract ppp_lim [aw=WTS_SDLE]  if city=="Montreal" | city== "Vancouver" | city=="Toronto", fast by(year city) nomiss p(percent)
drop _freq
format percent  %9.1f
drop if ppp_lim==0
export excel "table\4.6.tails_distribution.xlsx", firstrow(varl) sheet("PPP LIM - By city", replace) 
  
  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear  
bys year city:  tab ppp_lim 
xcontract ppp_lim  if city=="Montreal" | city== "Vancouver" | city=="Toronto", fast by(year city) nomiss p(percent)
drop percent
drop if ppp_lim==0
gen flag=1 if _freq<15
export excel "table\4.6.tails_distribution_freq.xlsx", firstrow(varl) sheet("PPP LIM - By city", replace)  


  
*  MBM deprivation (share of individuals with income below MBM)

 // national level
  * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year:  tab mbm_poor [aw=WTS_SDLE]
xcontract mbm_poor [aw=WTS_SDLE], fast by(year) nomiss p(percent)
drop _freq
format _all  %9.1f
drop if mbm_poor==0
export excel  "table\4.6.tails_distribution.xlsx", firstrow(varl) sheet("MBM poverty", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year:  tab mbm_poor
xcontract mbm_poor , fast by(year) nomiss p(percent)
drop percent
drop if mbm_poor==0
gen flag=1 if _freq<15
export excel  "table\4.6.tails_distribution_freq.xlsx", firstrow(varl) sheet("MBM poverty", replace) 

 // province level
  * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
xcontract mbm_poor [aw=WTS_SDLE], fast by(year fprov) nomiss p(percent)
drop _freq
format _all  %9.1f
drop if mbm_poor==0
export excel  "table\4.6.tails_distribution.xlsx", firstrow(varl) sheet("MBM poverty - by prov", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
xcontract mbm_poor , fast by(year fprov) nomiss p(percent)
drop percent
drop if mbm_poor==0
gen flag=1 if _freq<15
export excel  "table\4.6.tails_distribution_freq.xlsx", firstrow(varl) sheet("MBM poverty - by prov", replace) 


 // city level 
  * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
xcontract mbm_poor [aw=WTS_SDLE]  if city=="Montreal" | city== "Vancouver" | city=="Toronto", fast by(year city) nomiss p(percent)
drop _freq
format percent  %9.1f
drop if mbm_poor==0
export excel  "table\4.6.tails_distribution.xlsx", firstrow(varl) sheet("MBM poverty - by city", replace) 

  * frequencies  
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
xcontract mbm_poor  if city=="Montreal" | city== "Vancouver" | city=="Toronto", fast by(year city) nomiss p(percent)
drop percent
drop if mbm_poor==0
gen flag=1 if _freq<15
export excel  "table\4.6.tails_distribution_freq.xlsx", firstrow(varl) sheet("MBM poverty - by city", replace) 
  
* Richest 10% by province
  
  // National distribution
  * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year: tab fprov [aw=WTS_SDLE] if ppp_income_decile==10 
xcontract fprov [aw=WTS_SDLE] if ppp_income_decile==10 , fast by(year) nomiss p(percent)
drop _freq
format _all  %9.1f
export excel  "table\4.6.tails_distribution.xlsx", firstrow(varl) sheet("Top 10% by prov- national distr", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year: tab fprov  if ppp_income_decile==10 
xcontract fprov if ppp_income_decile==10 , fast by(year) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
export excel  "table\4.6.tails_distribution_freq.xlsx", firstrow(varl) sheet("Top 10% by prov- national distr", replace) 

  
* Richest 10% by city (lots of flags)
 // National distribution
  * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year: tab city [aw=WTS_SDLE] if eq_income_decile==10 
xcontract city [aw=WTS_SDLE] if eq_income_decile==10 &  city=="Montreal" | city== "Vancouver" | city=="Toronto", fast by(year) nomiss p(percent)
drop _freq
format percent  %9.1f
export excel  "table\4.6.tails_distribution.xlsx", firstrow(varl) sheet("Top 10% by city- national distr", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year: tab city  if eq_income_decile==10 
xcontract city if eq_income_decile==10  & city=="Montreal" | city== "Vancouver" | city=="Toronto", fast by(year) nomiss p(percent)
gen flag=1 if _freq<15
drop percent
export excel  "table\4.6.tails_distribution_freq.xlsx", firstrow(varl) sheet("Top 10% by city- national distr", replace)   
  
 // PPP-adjusted distribution
  * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year: tab city [aw=WTS_SDLE] if ppp_income_decile==10 
xcontract city [aw=WTS_SDLE] if ppp_income_decile==10  & city=="Montreal" | city== "Vancouver" | city=="Toronto", fast by(year) nomiss p(percent)
drop _freq
format percent  %9.1f
export excel  "table\4.6.tails_distribution.xlsx", firstrow(varl) sheet("Top 10% by city- PPP distr", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year: tab city if ppp_income_decile==10 
xcontract city if ppp_income_decile==10  & city=="Montreal" | city== "Vancouver" | city=="Toronto", fast by(year) nomiss p(percent)
gen flag=1 if _freq<15
drop percent
export excel  "table\4.6.tails_distribution_freq.xlsx", firstrow(varl) sheet("Top 10% by city- PPP distr", replace) 

*===============================================================================

**#                      *7. Health

*===============================================================================
 
** Overview
 // health
 * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year : tab health  [aw=WTS_SDLE]
xcontract health [aw=WTS_SDLE] , fast by(year) nomiss p(percent)
drop _freq
format _all  %9.1f
export excel  "table\4.7.health.xlsx", firstrow(varl) sheet("Summary - health", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year : tab health
xcontract health , fast by(year) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
export excel  "table\4.7.health_freq.xlsx", firstrow(varl) sheet("Summary - health", replace) 

 // mental health

  * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year : tab mental_health  [aw=WTS_SDLE]
xcontract mental_health [aw=WTS_SDLE] , fast by(year) nomiss p(percent)
drop _freq
format _all  %9.1f
export excel  "table\4.7.health.xlsx", firstrow(varl) sheet("Summary - mental health", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year : tab health
xcontract mental_health , fast by(year) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
export excel  "table\4.7.health_freq.xlsx", firstrow(varl) sheet("Summary - mental health", replace) 

 // stress
  * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year : tab stress  [aw=WTS_SDLE]
xcontract stress [aw=WTS_SDLE] , fast by(year) nomiss p(percent)
drop _freq
format _all  %9.1f
export excel  "table\4.7.health.xlsx", firstrow(varl) sheet("Summary - stress", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year : tab stress
xcontract stress , fast by(year) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
export excel  "table\4.7.health_freq.xlsx", firstrow(varl) sheet("Summary - stress", replace) 



** Health and income (national distr)
 
 // health
 * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year : tab health eq_income_quintile [aw=WTS_SDLE]
xcontract health eq_income_quintile [aw=WTS_SDLE] , fast by(year) nomiss p(percent)
drop _freq
format _all  %9.1f
export excel  "table\4.7.health.xlsx", firstrow(varl) sheet("health by quintile", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year : tab health eq_income_quintile
xcontract health eq_income_quintile, fast by(year) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
export excel  "table\4.7.health_freq.xlsx", firstrow(varl) sheet("health by quintile", replace) 

 //mental health
 * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year : tab mental_health eq_income_quintile [aw=WTS_SDLE]
xcontract mental_health eq_income_quintile [aw=WTS_SDLE] , fast by(year) nomiss p(percent)
drop _freq
format _all  %9.1f
export excel  "table\4.7.health.xlsx", firstrow(varl) sheet("mental health by quintile", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year : tab mental_health eq_income_quintile
xcontract mental_health eq_income_quintile, fast by(year) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
export excel  "table\4.7.health_freq.xlsx", firstrow(varl) sheet("mental health by quintile", replace) 

//stress

 * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year : tab stress eq_income_quintile [aw=WTS_SDLE]
xcontract stress eq_income_quintile [aw=WTS_SDLE] , fast by(year) nomiss p(percent)
drop _freq
format _all  %9.1f
export excel  "table\4.7.health.xlsx", firstrow(varl) sheet("stress by quintile", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year : tab stress eq_income_quintile
xcontract stress eq_income_quintile, fast by(year) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
export excel  "table\4.7.health_freq.xlsx", firstrow(varl) sheet("stress by quintile", replace) 

** Health and income (PPP distr)

 // health
  * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year : tab health ppp_income_quintile  [aw=WTS_SDLE]
xcontract health ppp_income_quintile [aw=WTS_SDLE] , fast by(year) nomiss p(percent)
drop _freq
format _all  %9.1f
export excel  "table\4.7.health.xlsx", firstrow(varl) sheet("health by PPP quintile", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year : tab health ppp_income_quintile
xcontract health ppp_income_quintile, fast by(year) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
export excel  "table\4.7.health_freq.xlsx", firstrow(varl) sheet("health by PPP quintile", replace) 

 // mental health

  * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year : tab mental_health ppp_income_quintile  [aw=WTS_SDLE]
xcontract mental_health ppp_income_quintile [aw=WTS_SDLE] , fast by(year) nomiss p(percent)
drop _freq
format _all  %9.1f
export excel  "table\4.7.health.xlsx", firstrow(varl) sheet("mental health by PPP quintile", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year : tab mental_health ppp_income_quintile
xcontract mental_health ppp_income_quintile, fast by(year) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
export excel  "table\4.7.health_freq.xlsx", firstrow(varl) sheet("mental health by PPP quintile", replace) 

 // stress

  * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year : tab stress ppp_income_quintile [aw=WTS_SDLE]
xcontract stress ppp_income_quintile [aw=WTS_SDLE] , fast by(year) nomiss p(percent)
drop _freq
format _all  %9.1f
export excel  "table\4.7.health.xlsx", firstrow(varl) sheet("stress by PPP quintile", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year : tab stress ppp_income_quintile
xcontract stress ppp_income_quintile, fast by(year) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
export excel  "table\4.7.health_freq.xlsx", firstrow(varl) sheet("stress by PPP quintile", replace) 


* Health and income by province (national distr)
 // health 
 * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year fprov: tab health eq_income_quintile [aw=WTS_SDLE]
xcontract health eq_income_quintile [aw=WTS_SDLE] , fast by(year fprov) nomiss p(percent)
drop _freq
format _all  %9.1f
export excel  "table\4.7.health.xlsx", firstrow(varl) sheet("health by quintile - prov", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year fprov: tab health eq_income_quintile
xcontract health eq_income_quintile, fast by(year fprov) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
export excel  "table\4.7.health_freq.xlsx", firstrow(varl) sheet("health by quintile - prov", replace) 

 // mental health

 * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year fprov: tab mental_health eq_income_quintile [aw=WTS_SDLE]
xcontract mental_health eq_income_quintile [aw=WTS_SDLE] , fast by(year fprov) nomiss p(percent)
drop _freq
format _all  %9.1f
export excel  "table\4.7.health.xlsx", firstrow(varl) sheet("mental health by quint - prov", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year fprov: tab mental_health eq_income_quintile
xcontract mental_health eq_income_quintile, fast by(year fprov) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
export excel  "table\4.7.health_freq.xlsx", firstrow(varl) sheet("mental health by quint- prov", replace) 

 // stress

  * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year fprov: tab health ppp_income_quintile  [aw=WTS_SDLE]
xcontract health ppp_income_quintile [aw=WTS_SDLE] , fast by(year fprov) nomiss p(percent)
drop _freq
format _all  %9.1f
export excel  "table\4.7.health.xlsx", firstrow(varl) sheet("health by PPP quintile - prov", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year fprov: tab health ppp_income_quintile
xcontract health ppp_income_quintile, fast by(year fprov) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
export excel  "table\4.7.health_freq.xlsx", firstrow(varl) sheet("health by PPP quintile - prov", replace) 

* Health and income by province (PPP distr)
 // health 
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year fprov: tab health ppp_income_quintile  [aw=WTS_SDLE]
xcontract health ppp_income_quintile [aw=WTS_SDLE] , fast by(year fprov) nomiss p(percent)
drop _freq
format _all  %9.1f
export excel  "table\4.7.health.xlsx", firstrow(varl) sheet(" health PPP quint - prov", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year fprov: tab health ppp_income_quintile
xcontract health ppp_income_quintile, fast by(year fprov) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
export excel  "table\4.7.health_freq.xlsx", firstrow(varl) sheet("health PPP quint- prov", replace)

 // mental health
  * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year fprov: tab mental_health ppp_income_quintile  [aw=WTS_SDLE]
xcontract mental_health ppp_income_quintile [aw=WTS_SDLE] , fast by(year fprov) nomiss p(percent)
drop _freq
format _all  %9.1f
export excel  "table\4.7.health.xlsx", firstrow(varl) sheet("mental health PPP quint - prov", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year fprov: tab mental_health ppp_income_quintile
xcontract mental_health ppp_income_quintile, fast by(year fprov) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
export excel  "table\4.7.health_freq.xlsx", firstrow(varl) sheet("mental health PPP quint- prov", replace) 

 
 // stress

  * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year fprov: tab stress ppp_income_quintile [aw=WTS_SDLE]
xcontract stress ppp_income_quintile [aw=WTS_SDLE] , fast by(year fprov) nomiss p(percent)
drop _freq
format _all  %9.1f
export excel  "table\4.7.health.xlsx", firstrow(varl) sheet("stress by PPP quintile - prov", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year fprov: tab stress ppp_income_quintile
xcontract stress ppp_income_quintile, fast by(year fprov) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
export excel  "table\4.7.health_freq.xlsx", firstrow(varl) sheet("stress by PPP quintile - prov ", replace) 


** Health and income by city (national distr)

 //health
 * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year city: tab health eq_income_quintile [aw=WTS_SDLE]
xcontract health eq_income_quintile [aw=WTS_SDLE]  if city=="Montreal" | city== "Vancouver" | city=="Toronto", fast by(year city) nomiss p(percent)
drop _freq
format percent  %9.1f
export excel  "table\4.7.health.xlsx", firstrow(varl) sheet("health by quintile - city", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year city: tab health eq_income_quintile
xcontract health eq_income_quintile  if city=="Montreal" | city== "Vancouver" | city=="Toronto", fast by(year city) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
export excel  "table\4.7.health_freq.xlsx", firstrow(varl) sheet("health by quintile - city", replace) 

 // mental health

 * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year city: tab mental_health eq_income_quintile [aw=WTS_SDLE]
xcontract mental_health eq_income_quintile [aw=WTS_SDLE]  if city=="Montreal" | city== "Vancouver" | city=="Toronto", fast by(year city) nomiss p(percent)
drop _freq
format percent  %9.1f
export excel  "table\4.7.health.xlsx", firstrow(varl) sheet("mental health by quint - city", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year city: tab mental_health eq_income_quintile
xcontract mental_health eq_income_quintile  if city=="Montreal" | city== "Vancouver" | city=="Toronto", fast by(year city) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
export excel  "table\4.7.health_freq.xlsx", firstrow(varl) sheet("mental health by quint- city", replace) 

 // stress
 * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year city: tab stress eq_income_quintile [aw=WTS_SDLE]
xcontract stress eq_income_quintile [aw=WTS_SDLE]  if city=="Montreal" | city== "Vancouver" | city=="Toronto", fast by(year city) nomiss p(percent)
drop _freq
format percent  %9.1f
export excel  "table\4.7.health.xlsx", firstrow(varl) sheet("stress by quintile - city", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year city: tab stress eq_income_quintile
xcontract stress eq_income_quintile  if city=="Montreal" | city== "Vancouver" | city=="Toronto", fast by(year city) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
export excel  "table\4.7.health_freq.xlsx", firstrow(varl) sheet("stress by quintile - city", replace) 

** Health and income by city (PPP distr)

 // health
  * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year city: tab health ppp_income_quintile  [aw=WTS_SDLE]
xcontract health ppp_income_quintile [aw=WTS_SDLE]  if city=="Montreal" | city== "Vancouver" | city=="Toronto", fast by(year city) nomiss p(percent)
drop _freq
format percent  %9.1f
export excel  "table\4.7.health.xlsx", firstrow(varl) sheet("health by PPP quintile - city", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year city: tab health ppp_income_quintile
xcontract health ppp_income_quintile  if city=="Montreal" | city== "Vancouver" | city=="Toronto", fast by(year city) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
export excel  "table\4.7.health_freq.xlsx", firstrow(varl) sheet("health by PPP quintile - city", replace) 

 // mental health

  * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year city: tab mental_health ppp_income_quintile  [aw=WTS_SDLE]
xcontract mental_health ppp_income_quintile [aw=WTS_SDLE]  if city=="Montreal" | city== "Vancouver" | city=="Toronto", fast by(year city) nomiss p(percent)
drop _freq
format percent  %9.1f
export excel  "table\4.7.health.xlsx", firstrow(varl) sheet("mental health PPP quint - city", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year fprov: tab mental_health ppp_income_quintile
xcontract mental_health ppp_income_quintile  if city=="Montreal" | city== "Vancouver" | city=="Toronto", fast by(year city) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
export excel  "table\4.7.health_freq.xlsx", firstrow(varl) sheet("mental health PPP quint- city", replace) 

 //stress

  * percentages
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year fprov: tab stress ppp_income_quintile [aw=WTS_SDLE]
xcontract stress ppp_income_quintile [aw=WTS_SDLE]  if city=="Montreal" | city== "Vancouver" | city=="Toronto", fast by(year city) nomiss p(percent)
drop _freq
format percent  %9.1f
export excel  "table\4.7.health.xlsx", firstrow(varl) sheet("stress by PPP quintile - city", replace) 

  * frequencies
use "T:\Projet 10629\node4\stata\data\3.descriptives.dta", clear 
bys year fprov: tab stress ppp_income_quintile
xcontract stress ppp_income_quintile  if city=="Montreal" | city== "Vancouver" | city=="Toronto", fast by(year city) nomiss p(percent)
drop percent
gen flag=1 if _freq<15
export excel  "table\4.7.health_freq.xlsx", firstrow(varl) sheet("stress by PPP quintile - city ", replace) 




*-----------------------------------------------------------------------------

log close


