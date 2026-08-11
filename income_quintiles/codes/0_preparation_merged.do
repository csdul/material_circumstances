/*******************************************************************************
Project: CSDUL
Authors: M. Sene; G. Notten 
Latest update: 18-07-2025
Purpose: data preparation by year

Data: dad_nacrs_cchs_t1ff_2011_f3_v1.dta
      dad_nacrs_cchs_t1ff_2012_f3_v1.dta
	  dad_nacrs_cchs_t1ff_2013_f3_v1.dta
	  dad_nacrs_cchs_t1ff_2014_f3_v1.dta
	  dad_nacrs_cchs_t1ff_2015_f3_v1.dta
	  
	  cchs_share_link_2011_f3_v1.dta
	  cchs_share_link_2012_f3_v1.dta
	  cchs_share_link_2013_f3_v1.dta
	  cchs_share_link_2014_f3_v1.dta
	  cchs_share_link_2015_f3_v1.dta
	  
	  
Output: 0.preparation_2011.dta
		dad_nacrs_cchs_t1ff_2011_f3_v1_reduced.dta
		cchs_t1ff_2011.dta
		
		0.preparation_2012.dta
		dad_nacrs_cchs_t1ff_2012_f3_v1_reduced.dta
		cchs_t1ff_2012.dta
		
		0.preparation_2013.dta
        dad_nacrs_cchs_t1ff_2013_f3_v1_reduced.dta
		cchs_t1ff_2013.dta 
		
		0.preparation_2014 
		dad_nacrs_cchs_t1ff_2014_f3_v1_reduced.dta
		cchs_t1ff_2014.dta 
		
		0.preparation_2015 
		dad_nacrs_cchs_t1ff_2015_f3_v1_reduced.dta
		cchs_t1ff_2015.dta
		 

********************************************************************************
TABLES OF CONTENT

   - 0. Setup
   - 2011
   - 2012
   - 2013
   - 2014
   - 2015
   - 1. Pooling data from 2011 to 2015
   - 2. Preparing income variables


*******************************************************************************/

* 0. Setup
*-------------------------------------------------------------------------------
//global settings  
  clear all
  set more off, permanently
  
//set directory
  cd "T:\Projet 10629\node4\stata"

//open log 
  cap log close
  log using "log\0.preparation_merged.log", replace
  
//program to clean STC_ID

cap program drop clean_id
program define clean_id
    version 18
    syntax varname

    di ">>> Checking for duplicates in STC_ID"
    codebook STC_ID
    duplicates list STC_ID
    duplicates drop STC_ID, force
    di ">>> Done cleaning duplicates for STC_ID"
end
  

**#=============================================================================

                                       *2011 

**#=============================================================================

** Loading data (T1FF) and keep relevant variables only

use "T:\Projet 10629\node4\stata\data\dad_nacrs_cchs_t1ff_2011_f3_v1.dta" ,clear
 
 duplicates list recnum  // Extremely few record numbers are represented twice. For each recnum that is represented twice, all values are the same except for STC_ID and LWTS_T1PMF_DRD 
 duplicates list STC_ID // No duplicates in using
 

keep STC_ID  recnum frecnum faftnc FALIM_SQRT fxti fprov fsize FCMA11 FCT11 fpsco LWTS_T1PMF_DRD  

save "\\mcg-main\equipes\Projet 10629\node4\stata\data\dad_nacrs_cchs_t1ff_2011_f3_v1_reduced.dta", replace


** Loading data master (CCHS) and keep relevant variables only

use "T:\Projet 10629\node4\stata\data\cchs_share_link_2011_f3_v1.dta", clear 

keep STC_ID LWTS_CCHS_DRD CCHS_ID WTS_SDLE CCHS_ID GEO_PRV GEODPC DHH_AGE SAMDSHR SAMDLNK INC_3 INC_2 INCFIMP DHHDHSZ GEN_01 GEN_02B GEN_07

  rename DHHDHSZ dhhdhsz
  rename GEODPC geodpc
  rename SAMDLNK samdlnk
  rename SAMDSHR samdshr
  rename GEN_02B GEN_05 // var name for perceived mental health in other rounds
  rename GEN_07 GEN_10 //  var name for perceived life stress in other rounds

save "T:\Projet 10629\node4\stata\data\cchs_share_link_2011_f3_v1_reduced.dta", replace

** Merge into master using linkage variable "STC_ID"

use "\\mcg-main\equipes\Projet 10629\node4\stata\data\cchs_share_link_2011_f3_v1_reduced.dta", clear
clean_id STC_ID //  extremely few variables had duplicates in "STC_ID". Since it's not clear which one is correct, we drop them. 

 codebook CCHS_ID // // no missing; all unique values


merge m:1 STC_ID using "\\mcg-main\equipes\Projet 10629\node4\stata\data\dad_nacrs_cchs_t1ff_2011_f3_v1_reduced.dta", keep(match master)

save "T:\Projet 10629\node4\stata\data\cchs_t1ff_2011.dta", replace // some were not matched

** Some checks focusing on non-linked files and income

use "\\mcg-main\equipes\Projet 10629\node4\stata\data\cchs_t1ff_2011.dta", clear
 tab _merge // some of CCHS participants don't have T1FF information. These are mostly youth:

 count if _merge==1 & DHH_AGE<25
 count if _merge==3 & DHH_AGE<25
 count if DHH_AGE<25

 *checking if each observation corresponds to a different individual:
duplicates list recnum if recnum!=. // no duplicates in recnum anymore

 * checks to confirm income information from t1ff is missing indeed for those who were not matched
 tab FALIM_SQRT
 sum faftnc, detail
   
 sum INC_3, detail //No missing income but that's because if respondent didn't provide an estimate, an income value was imputed (flag variable: INCFIMP).
 tab INCFIMP

 tab INCFIMP if DHH_AGE<25 // Those with lower incomes and ages above 24 are not that big of a big group of (likely) non-filers and thus not in t1ff.
 count if _merge==1 & DHH_AGE>24 & DHH_AGE!=. & INC_3<30000

drop _merge
gen year=2011
save "T:\Projet 10629\node4\stata\data\0.preparation_2011.dta", replace 

**#=============================================================================

                                       *2012 

**#=============================================================================
 
** Loading data (T1FF) and keep relevant variables only

use "T:\Projet 10629\node4\stata\data\dad_nacrs_cchs_t1ff_2012_f3_v1.dta" , clear 


 duplicates list recnum  // extremely few record numbers are represented twice. For each recnum that is represented twice, all values are the same except for  STC_ID and LWTS_T1PMF_DRD 
 duplicates list STC_ID // No duplicates in using

keep STC_ID  recnum frecnum faftnc FALIM_SQRT fxti fprov fsize FCMA11 FCT11 fpsco LWTS_T1PMF_DRD 

save "\\mcg-main\equipes\Projet 10629\node4\stata\data\dad_nacrs_cchs_t1ff_2012_f3_v1_reduced.dta", replace


** Loading data master and keep relevant variables only
use "T:\Projet 10629\node4\stata\data\cchs_share_link_2012_f3_v1.dta", clear 

keep STC_ID LWTS_CCHS_DRD CCHS_ID WTS_SDLE CCHS_ID GEO_PRV geodpc DHH_AGE  samdshr samdlnk INC_3 INC_2 INCFIMP4  dhhdhsz GEN_01 GEN_02B GEN_07

  rename GEN_02B GEN_05 // var name for perceived mental health in other rounds
  rename GEN_07 GEN_10 //  var name for perceived life stress in other rounds

save "T:\Projet 10629\node4\stata\data\cchs_share_link_2012_f3_v1_reduced.dta", replace

** Merge using into master

use "\\mcg-main\equipes\Projet 10629\node4\stata\data\cchs_share_link_2012_f3_v1_reduced.dta", clear
clean_id STC_ID // extremely few variables had duplicates in "STC_ID". Since it's not clear which one is correct, we drop them. 

 codebook CCHS_ID // no missing; all unique values

merge m:1 STC_ID using "\\mcg-main\equipes\Projet 10629\node4\stata\data\dad_nacrs_cchs_t1ff_2012_f3_v1_reduced.dta", keep(match master) 

save "T:\Projet 10629\node4\stata\data\cchs_t1ff_2012.dta", replace 

** Some checks focusing on non-linked files and income

use "\\mcg-main\equipes\Projet 10629\node4\stata\data\cchs_t1ff_2012.dta", clear
 tab _merge

 count if _merge==1 & DHH_AGE<25
 count if _merge==3 & DHH_AGE<25
 count if DHH_AGE<25

 *checking if each observation corresponds to a different individual:
 duplicates list recnum if recnum!=. // no duplicates

 * checks to confirm income information from t1ff is missing indeed for those who were not matched
 tab FALIM_SQRT
 sum faftnc, detail

 sum INC_3, detail
 tab INCFIMP4 //--> need to check the label

 tab INCFIMP4 if DHH_AGE<25

 count if _merge==1 & DHH_AGE>24 & DHH_AGE!=. & INC_3<30000

drop _merge
gen year=2012

save "T:\Projet 10629\node4\stata\data\0.preparation_2012.dta", replace



**#=============================================================================

                                       *2013 

**#=============================================================================

** Loading data (T1FF) and keep relevant variables only
use "T:\Projet 10629\node4\stata\data\dad_nacrs_cchs_t1ff_2013_f3_v1.dta" , clear 
 duplicates list recnum  // extremely few record numbers are represented twice. For each recnum that is represented twice, all values are the same except for  STC_ID and LWTS_T1PMF_DRD 
 duplicates list STC_ID // no duplicates in using

keep STC_ID  recnum frecnum faftnc FALIM_SQRT fxti fprov fsize FCMA11 FCT11 fpsco LWTS_T1PMF_DRD
 
save "\\mcg-main\equipes\Projet 10629\node4\stata\data\dad_nacrs_cchs_t1ff_2013_f3_v1_reduced.dta", replace


** Loading data master (CCHS) and keep relevant variables only

use "T:\Projet 10629\node4\stata\data\cchs_share_link_2013_f3_v1.dta", clear 

keep STC_ID LWTS_CCHS_DRD CCHS_ID WTS_SDLE CCHS_ID GEO_PRV geodpc DHH_AGE  samdshr samdlnk INC_3 INC_2 INCFIMP4  dhhdhsz GEN_01 GEN_02B GEN_07

  rename GEN_02B GEN_05 // var name for perceived mental health in other rounds
  rename GEN_07 GEN_10 //  var name for perceived life stress in other rounds

save "T:\Projet 10629\node4\stata\data\cchs_share_link_2013_f3_v1_reduced.dta", replace

** Merge using  master

use "\\mcg-main\equipes\Projet 10629\node4\stata\data\cchs_share_link_2013_f3_v1_reduced.dta", clear
clean_id STC_ID // extremely few variables had duplicates in "STC_ID". Since it's not clear which one is correct, we drop them. 
codebook CCHS_ID // no missing; all unique values


merge m:1 STC_ID using "\\mcg-main\equipes\Projet 10629\node4\stata\data\dad_nacrs_cchs_t1ff_2013_f3_v1_reduced.dta", keep(match master) 

save "T:\Projet 10629\node4\stata\data\cchs_t1ff_2013.dta", replace 

** Some checks focusing on non-linked files and income

use "\\mcg-main\equipes\Projet 10629\node4\stata\data\cchs_t1ff_2013.dta", clear
 tab _merge

 count if _merge==1 & DHH_AGE<25 
 count if _merge==3 & DHH_AGE<25
 count if DHH_AGE<25

*checking if each observation corresponds to a different individual:
 duplicates list recnum if recnum!=. // no duplicates

 sum INC_3, detail
 tab INCFIMP4

 tab INCFIMP4 if DHH_AGE<25

 // Those with lower incomes and ages above 24 are not that big of a big group of (likely) non-filers and thus not in t1ff.
 count if _merge==1 & DHH_AGE>24 & DHH_AGE!=. & INC_3<30000

drop _merge
gen year=2013

save "T:\Projet 10629\node4\stata\data\0.preparation_2013.dta", replace

**#=============================================================================

                                       *2014 

**#=============================================================================
 
** Loading data (T1FF) and keep relevant variables only
use "T:\Projet 10629\node4\stata\data\dad_nacrs_cchs_t1ff_2014_f3_v1.dta" , clear 

 duplicates list recnum  // extremely few record numbers are represented twice. For each recnum that is represented twice, all values are the same except for  STC_ID and LWTS_T1PMF_DRD 
 duplicates list STC_ID // no duplicates in using

keep STC_ID  recnum frecnum faftnc FALIM_SQRT fxti fprov fsize FCMA11 FCT11 fpsco LWTS_T1PMF_DRD 
save "\\mcg-main\equipes\Projet 10629\node4\stata\data\dad_nacrs_cchs_t1ff_2014_f3_v1_reduced.dta", replace


** Loading data (CCHS) and keep relevant variables only

use "T:\Projet 10629\node4\stata\data\cchs_share_link_2014_f3_v1.dta", clear 

keep STC_ID LWTS_CCHS_DRD CCHS_ID WTS_SDLE CCHS_ID GEO_PRV geodpc DHH_AGE  samdshr samdlnk INC_3 INC_2 INCFIMP4 dhhdhsz GEN_01 GEN_02B GEN_07

 rename GEN_02B GEN_05
 rename GEN_07 GEN_10

save "T:\Projet 10629\node4\stata\data\cchs_share_link_2014_f3_v1_reduced.dta", replace

** Merge  into master

use "\\mcg-main\equipes\Projet 10629\node4\stata\data\cchs_share_link_2014_f3_v1_reduced.dta", clear
clean_id STC_ID //extremely few variables had duplicates in "STC_ID". Since it's not clear which one is correct, we drop them. 
codebook CCHS_ID // no missing; all unique values


merge m:1 STC_ID using "\\mcg-main\equipes\Projet 10629\node4\stata\data\dad_nacrs_cchs_t1ff_2014_f3_v1_reduced.dta", keep(match master)

save "T:\Projet 10629\node4\stata\data\cchs_t1ff_2014.dta", replace

** Some checks focusing on non-linked files and income

use "\\mcg-main\equipes\Projet 10629\node4\stata\data\cchs_t1ff_2014.dta", clear
 tab _merge

 count if _merge==1 & DHH_AGE<25
 count if _merge==3 & DHH_AGE<25
 count if DHH_AGE<25

*checking if each observation corresponds to a different individual:
 duplicates list recnum if recnum!=. // no duplicates

tab FALIM_SQRT
sum faftnc, detail

sum INC_3, detail
tab INCFIMP4 //--> need to double check what this is.

tab INCFIMP4 if DHH_AGE<25
count if _merge==1 & DHH_AGE>24 & DHH_AGE!=. & INC_3<30000

drop _merge
gen year=2014

save "T:\Projet 10629\node4\stata\data\0.preparation_2014.dta", replace


**#=============================================================================

                                       *2015 

**#=============================================================================

** Loading data (T1FF) and keep relevant variables only
use "T:\Projet 10629\node4\stata\data\dad_nacrs_cchs_t1ff_2015_f3_v1.dta" , clear 

 duplicates list recnum  // extremely few record numbers are represented twice. For each recnum that is represented twice, all values are the same except for  STC_ID and LWTS_T1PMF_DRD 
 duplicates list STC_ID // no duplicates in using

 keep STC_ID  recnum frecnum faftnc FALIM_SQRT fxti fprov fsize FCMA16 FCT16 fpsco LWTS_T1PMF_DRD

save "\\mcg-main\equipes\Projet 10629\node4\stata\data\dad_nacrs_cchs_t1ff_2015_f3_v1_reduced.dta", replace

** Loading data master and keep relevant variables only
use "T:\Projet 10629\node4\stata\data\cchs_share_link_2015_f3_v1.dta", clear 

 keep STC_ID LWTS_CCHS_DRD CCHS_ID WTS_SDLE CCHS_ID GEO_PRV  DHH_AGE  samdvshr samdvlnk incdvhh INC_015 INCFIMP4  dhhdvhsz GEN_005 GEN_015 GEN_020

 rename dhhdvhsz dhhdhsz
 rename samdvlnk samdlnk
 rename samdvshr samdshr
 rename GEN_005 GEN_01
 rename GEN_015 GEN_05
 rename GEN_020 GEN_10


save "T:\Projet 10629\node4\stata\data\cchs_share_link_2015_f3_v1_reduced.dta", replace

** Merge using into master

use "\\mcg-main\equipes\Projet 10629\node4\stata\data\cchs_share_link_2015_f3_v1_reduced.dta", clear
clean_id STC_ID // extremely few variables had duplicates in "STC_ID". Since it's not clear which one is correct, we drop them. 
 codebook CCHS_ID // no missing; all unique values

merge m:1 STC_ID using "\\mcg-main\equipes\Projet 10629\node4\stata\data\dad_nacrs_cchs_t1ff_2015_f3_v1_reduced.dta", keep(match master)

save "T:\Projet 10629\node4\stata\data\cchs_t1ff_2015.dta", replace 

** Some checks focusing on non-linked files and income

use "\\mcg-main\equipes\Projet 10629\node4\stata\data\cchs_t1ff_2015.dta", clear
 tab _merge

 count if _merge==1 & DHH_AGE<25
 count if _merge==3 & DHH_AGE<25
 count if DHH_AGE<25

*checking if each observation corresponds to a different individual:
duplicates list recnum if recnum!=. // no duplicates

 tab FALIM_SQRT
 sum faftnc, detail

 sum incdvhh, detail
 tab INCFIMP4


 tab INCFIMP4 if DHH_AGE<25
 count if _merge==1 & DHH_AGE>24 & DHH_AGE!=. & incdvhh<30000

drop _merge
gen year=2015

save "T:\Projet 10629\node4\stata\data\0.preparation_2015.dta", replace

*-------------------------------------------------------------------------------

log close






