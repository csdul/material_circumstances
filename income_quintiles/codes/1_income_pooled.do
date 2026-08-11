/*******************************************************************************
Project: CSDUL
Authors:M. Sene; G. Notten 
Latest update: 21-10-2025
Purpose: Creating income quintiles

Data: dad_nacrs_cchs_t1ff_2011_f3_v1.dta

Output: 1.pooled.dta
        1.income_pooled.dta



********************************************************************************
TABLES OF CONTENT

    - 0. Setup
    - 1. Pooling data from 2011 to 2015
    - 2. Preparing income variable
	- 3. Preparing income quintiles


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
log using "T:\Projet 10629\node4\stata\log\1.income_pooled.log", replace


**#=============================================================================

                     *1. Pooling data from 2011 to 2015

**#=============================================================================

use "T:\Projet 10629\node4\stata\data\0.preparation_2011.dta"
forvalues i = 2/5 {
	append using  "T:\Projet 10629\node4\stata\data\0.preparation_201`i'.dta"
}

 tab year, m
 duplicates list STC_ID year // no duplicates


**#=============================================================================

                     *2. Preparing income variables

**#=============================================================================

** Dropping family sizes equal to 0
// each year, very few observations have a family size of 0, which will prevent us from diving income by the equivalence scale. Given the small number, we drop them.

bysort year: count if fsize==0 
drop if fsize==0

** Creating equivalized income 
// renaming variables
 clonevar family_income=faftnc 
 codebook family_income // missing: those who did not link their T1FF data
 clonevar family_income_bt=fxti
 codebook family_income_bt // missing: those who did not link their T1FF data

// generate equivalence scale (= square root of family size)
codebook fsize
gen eq_scale=sqrt(fsize)
codebook eq_scale

// generate adult equivalent income
gen equivalized_income= family_income/eq_scale 

 sum equivalized_income, detail
 codebook equivalized_income // missing: those who did not link their T1FF data


 
 
*-------------------------------------------------------------------------------

save "T:\Projet 10629\node4\stata\data\1.income_pooled.dta", replace
log close
