/*******************************************************************************
Project: CSDUL
Authors:  M. Sene; G. Notten 
Latest update: 19-11-2025
Purpose: Create PPP indices and import them into the T1FF data via a postal code correspondance file to create PPP-adjusted income quintiles

Data:   mbm_2011to2015.xls (obtained from StatsCan website - 2008-base MBM)
        postal_codes.xlsx (obtained by email from StatsCan - 2008-base MBM)
        1.income_pooled.dta

Output: 2.mbm_2011to2015.dta
        2.postal_codes.dta
        2.postal_codes_mbm
        2.income_pooled_mbm

********************************************************************************
TABLES OF CONTENT

   - 0. Setup
   - 1. Prepare data 
   - 2. PPP index
   - 3. Merging database
   - 4. Creating income quintiles


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
log using "log\2.mbm_2011to2015.log", replace


**#=============================================================================

                            *1.Prepare Data

**#=============================================================================

import excel "data\mbm_2011to2015.xlsx", firstrow clear

reshape long y, i(region) j(year)
rename y mbm
destring mbm, replace

// Below, we make sure the region format is the same as the one in the correspondance file 
gen province = ""
gen rural = 0
gen city_size = ""
gen city= ""

replace province = "Newfoundland and Labrador" if regexm(region, "Newfoundland and Labrador")
replace province = "Prince Edward Island" if regexm(region, "Prince Edward Island")
replace province = "Nova Scotia" if regexm(region, "Nova Scotia")
replace province = "New Brunswick" if regexm(region, "New Brunswick")
replace province = "Quebec" if regexm(region, "Quebec|Québec")
replace province = "Ontario" if regexm(region, "Ontario")
replace province = "Manitoba" if regexm(region, "Manitoba")
replace province = "Saskatchewan" if regexm(region, "Saskatchewan")
replace province = "Alberta" if regexm(region, "Alberta")
replace province = "British Columbia" if regexm(region, "British Columbia")
replace province = "Yukon" if regexm(region, "Yukon")
replace province = "Northwest Territories" if regexm(region, "Northwest Territories")
replace province = "Nunavut" if regexm(region, "Nunavut")


replace rural = 1 if regexm(region, "rural")

replace city_size = "Population under 30,000" if regexm(region, "population under 30,000")
replace city_size = "Population 30,000 to 99,999" if regexm(region, "population 30,000 to 99,999")
replace city_size = "Population 100,000 to 499,999" if regexm(region, "population 100,000 to 499,999")
replace city_size = "Population 500,000 and over" if regexm(region, "population 500,000 and over")

replace city = "St Johns" if regexm(region, "St. John's")
replace city = "Charlottetown" if regexm(region, "Charlottetown")
replace city = "Halifax" if regexm(region, "Halifax")
replace city = "Cape Breton" if regexm(region, "Cape Breton")
replace city = "Fredericton" if regexm(region, "Fredericton")
replace city = "Saint John" if regexm(region, "Saint John")
replace city = "Moncton" if regexm(region, "Moncton")
replace city = "Quebec" if regexm(region, "Québec")
replace city = "Montreal" if regexm(region, "Montréal")
replace city = "Ottawa-Gatineau" if regexm(region, "Ottawa-Gatineau") // the correspondance file doesnt have gatineau
replace city = "Hamilton/Burlington" if regexm(region, "Hamilton/Burlington") // doesn't have burlington either
replace city = "Toronto" if regexm(region, "Toronto")
replace city = "Brandon" if regexm(region, "Brandon")
replace city = "Winnipeg" if regexm(region, "Winnipeg")
replace city = "Saskatoon" if regexm(region, "Saskatoon")
replace city = "Regina" if regexm(region, "Regina")
replace city = "Edmonton" if regexm(region, "Edmonton")
replace city = "Calgary" if regexm(region, "Calgary")
replace city = "Vancouver" if regexm(region, "Vancouver")
replace city = "Whitehorse" if regexm(region, "Whitehorse")
replace city = "Yellowknife" if regexm(region, "Yellowknife")
replace city = "Iqaluit" if regexm(region, "Iqaluit")

br

* Replacing the region names to make them match with the MBM correspondance file
gen region_clean = ""

  * For region names made of the population size and the province
replace region_clean = city_size + ", " + province if city_size != ""

  * For region names made of "Rural" and the province 
replace region_clean = "Rural, " + province if rural == 1

  * For region names made of the city and the province
replace region_clean = city + ", " + province if city != "" & city_size == ""


// the only ones that did not format properly were:  Northwest Territories and Nunavut but MBM data are missing for these anyways

drop if province=="Yukon"| province=="Northwest Territories" | province=="Nunavut" // the MBM values are missing because the territories were not included in the MBM calculations before 2018. When they were added, the methodology differs. + CSDUL focuses on urban area. 

*Replacing region names for Ottawa-Gatineau by Ottawa, and Hamilton/Burlington by Hamilton , since they have the same MBM, and the correspondance file does not have Gatineau nor Burlington
replace region_clean="Ottawa, Ontario" if region_clean=="Ottawa-Gatineau, Ontario"

replace region_clean="Hamilton, Ontario" if region_clean=="Hamilton/Burlington, Ontario"

**#=============================================================================

*                      2. PPP index (based on MBM for Ottawa-Gatineau) 

**#=============================================================================
codebook mbm
bys year: tab mbm  if city=="Ottawa-Gatineau" 
gen mbm_ref=.
replace mbm_ref = mbm if city == "Ottawa-Gatineau"

bysort year (mbm_ref): replace mbm_ref = mbm_ref[_n-1] if mbm_ref==. // Here, I'm sorting by year, then putting the mbm reference first, so that every missing will take the value of the reference for that year

gen ppp_index = .
replace ppp_index = mbm / mbm_ref 
 
 sum ppp_index
 tab ppp_index if city=="Toronto" &  year==2011
 tab ppp_index if city=="Quebec"
 
 
* checking for missing 
  codebook ppp_index
  br region year ppp_index // missing MBM: Newfoundland and Labrador, population 30,000 to 99,999; Ontario, population 500,000 and over; Manitoba, population 30,000 to 99,999
 

save "data\2.mbm_2011to2015.dta", replace   


**#=============================================================================

*                      3. Merging databases

**#=============================================================================
clear all

*-------------------------------------------------------------------------------
* 3.1 Merging the  MBM file to the Excel Correspondance file to know in which MBM region each postal code belongs
*-------------------------------------------------------------------------------

import excel "T:\Projet 10629\node4\postal code mbm\postal_codes.xlsx", firstrow
rename MarketBasketMeasureRegion2 region_clean

save "T:\Projet 10629\node4\stata\data\2.postal_codes.dta", replace

use "T:\Projet 10629\node4\stata\data\2.mbm_2011to2015.dta" , clear

joinby region_clean using "T:\Projet 10629\node4\stata\data\2.postal_codes.dta",  unmatched(both)

*cheking the unmatched variables
 tab _merge
 tab region_clean if _merge==2 // All the unmatched regions (only in using data) are in the 3 territories (MBM North), which were dropped previously due to missing MBM. We drop them too in the using dataset 

drop if region_clean=="MBM North"
 
 tab region_clean if _merge==1 //  unmatched:  Newfoundland and Labrador, population 30,000 to 99,999; Ontario, population 500,000 and over; Manitoba, population 30,000 to 99,999, which have no MBM as there were no region of this size during the 2011-2015 MBM calculations 
 
 rename _merge _merge_postal

rename PostalCode fpsco
 codebook fpsco

save "T:\Projet 10629\node4\stata\data\2.postal_codes_mbm.dta", replace

*-------------------------------------------------------------------------------
* 3.2 Merging the MBM/Postal Codes file into the T1FF
*-------------------------------------------------------------------------------

use "T:\Projet 10629\node4\stata\data\1.income_pooled.dta", clear 
 codebook fpsco // missing: those who did not agree to link their tax data
 
merge m:m year fpsco using "T:\Projet 10629\node4\stata\data\2.postal_codes_mbm.dta"

*cheking the unmatched variables
 tab _merge 
 drop if _merge==2 //these are postal codes from using which are not matched with observations in our income data
 tab _merge if family_income!=. // less than 2.5% of the families with T1FF data were not merged
 tab fpsco if _merge==1 & family_income!=. // no particular pattern in the unmached postal codes
 

* checking the unmatched by province

/* Province (fprov) code:

- 10 = Newfoundland and Labrador
- 11 = Price Edward Island
- 12 = Nova Scotia
- 13 = New Brunswick
- 24 = Quebec
- 35 = Ontario
- 46 = Manitoba
- 47 = Saskatchewan 
- 48 = Alberta
- 59 = British Columbia
- 60 = Yukon
- 61 = North-West Territories
- 62 = Nunavut 
- 70 = Outside of Canada
*/  

destring fprov, replace
label define province 10 "Newfoundland and Labrador" 11 "Price Edward Island" 12 "Nova Scotia" 13 "New Brunswick" 24 "Quebec" 35 "Ontario" 46 "Manitoba" 47 "Saskatchewan"  48  "Alberta" 59 "British Columbia" 60 "Yukon" 61 "North-West Territories" 62 "Nunavut" 70 "Outside of Canada"
label val fprov province

 tab  fprov if _merge==1 & family_income!=. //half of unmatched are in the 3 territories or outside Canada. Ontario has about 6% of unmatched
 tab _merge if  family_income!=. & fprov!=60  & fprov!=61  & fprov!=62  & fprov!=70 
 bys year: tab _merge if  family_income!=. & fprov!=60  & fprov!=61  & fprov!=62  & fprov!=70 

 //NOTE MS: When excluding the North MBM, we are down to a very low percentage of unmached (0.5). I don't think there is any straightforward way to reduce it more. There is a higher number of unmatched in the year 2015 (corresponds with changes in methodology?)
 
 *dropping the territories and outside Canada observations, and un
 drop if fprov==60  | fprov==61  | fprov==62  | fprov==70 

 
**#=============================================================================

                     *4. Creating income quintiles

**#============================================================================= 
 
** Creating national income quintiles based on equivalized income

forvalues i = 1/5 {
	xtile eq_income_quintile_201`i' = equivalized_income [aw=WTS_SDLE] if year==201`i', nq(5)
} 

gen eq_income_quintile=.
forvalues i = 1/5 {
	replace eq_income_quintile= eq_income_quintile_201`i'  if year==201`i'
}

 codebook eq_income_quintile // missing: those who did not link their T1FF data 
 bys eq_income_quintile: sum equivalized_income [aw=WTS_SDLE]
 bys year: tab eq_income_quintile [aw=WTS_SDLE]

** Creating provincial income quintiles based on equivalized income

gen eq_prov_income_quintile = .
destring fprov, replace
 tab fprov year // in 2015, Yukon (60), North-West Territories (61) and Nunavut (62) have less than 5 observations, making it impossible to create quintiles. Therefore, we merge the 3 values for this year
 tab fprov if year==2015 & (fprov==61 | fprov==62)
replace fprov=60 if year==2015 & (fprov==61 | fprov==62)
 tab fprov year

forvalues i = 1/5 {
    levelsof fprov if year==201`i', local(provs)
    foreach p of local provs {
        xtile tmp_quintile = equivalized_income [aw=WTS_SDLE] if year==201`i' & fprov==`p', nq(5)
        replace eq_prov_income_quintile = tmp_quintile if year==201`i' & fprov==`p'
        drop tmp_quintile
    }
}

 codebook eq_prov_income_quintile
 bys year: tab eq_prov_income_quintile [aw=WTS_SDLE]

 * A few checks
 tab eq_prov_income_quintile [aw=WTS_SDLE]
 tab eq_prov_income_quintile year [aw=WTS_SDLE]
 bys eq_prov_income_quintile: sum equivalized_income [aw=WTS_SDLE]

 bys year: tab eq_prov_income_quintile [aw=WTS_SDLE]
 bys year: tab eq_income_quintile eq_prov_income_quintile [aw=WTS_SDLE]
 bys year: tab eq_income_quintile eq_prov_income_quintile [aw=WTS_SDLE] if fprov==59 // British Columbia
 bys year: tab eq_income_quintile eq_prov_income_quintile [aw=WTS_SDLE] if fprov==24 // Quebec
 

** Creating PPP-adjusted income quintiles

 * Check MBM for missing values  
 codebook mbm if family_income!=.
 codebook mbm if family_income!=. & _merge!=1 // no missing
 
// Notes: besides the missing values coming from people who did not agree to linkages, the only few remaining missing observations come from those whose postal code was not matched with an MBM region 

 * Generate PPP-adjusted income
 codebook ppp_index
 codebook ppp_index if mbm!=. // no missing 
gen ppp_income= equivalized_income/ppp_index 


 * Generate PPP-adjusted income quintiles 
forvalues i = 1/5 {
	xtile ppp_income_quintile_201`i' = ppp_income [pw=WTS_SDLE] if year==201`i', nq(5)
} 

gen ppp_income_quintile=.
forvalues i = 1/5 {
	replace ppp_income_quintile= ppp_income_quintile_201`i'  if year==201`i'
}

 codebook ppp_income_quintile 
 codebook ppp_income_quintile if ppp_index!=. 

bys year: tab ppp_income_quintile [aw=WTS_SDLE]



*-------------------------------------------------------------------------------

save "T:\Projet 10629\node4\stata\data\2.income_pooled_mbm.dta", replace
log close

