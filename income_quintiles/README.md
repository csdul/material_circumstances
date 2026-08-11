
# Adult-Equivalent Income Quintiles

## General Definition

The income quintile indicators classify Canadian Community Health Survey (CCHS) respondents according to their position in an income distribution constructed from after-tax family income reported in the T1 Family File (T1FF).

Income is first adjusted for census-family size using the square-root equivalence scale. The resulting adult-equivalent income is then used to construct three related indicators for each year from 2011 to 2015.

---

# Indicators

## 1. National Adult-Equivalent Income Quintile

Respondents aged 18 and older are ranked within the population-weighted national distribution of adult-equivalent after-tax family income for each year.

The adult-equivalent income measure is:

$$
AEI_{it} = \frac{Y_{it}}{\sqrt{S_{it}}}
$$

where:

- $AEI_{it}$ is adult-equivalent income for individual *i* in year *t*;
- $Y_{it}$ is after-tax census-family income from the T1FF; and
- $S_{it}$ is census-family size.

The weighted distribution is divided into five groups:

- **Quintile 1:** lowest 20 percent of the income distribution
- **Quintile 2:** second 20 percent
- **Quintile 3:** middle 20 percent
- **Quintile 4:** fourth 20 percent
- **Quintile 5:** highest 20 percent

---

## 2. Provincial Adult-Equivalent Income Quintile

This indicator uses the same adult-equivalent income measure but ranks respondents within the income distribution of their province rather than within the national distribution.

As a result, individuals with the same adult-equivalent income may be assigned to different quintiles if they live in different provinces.

---

## 3. MBM-Adjusted National Adult-Equivalent Income Quintile

The third indicator adjusts adult-equivalent income for regional differences in the cost of living using Market Basket Measure (MBM) thresholds as a practical pseudo-purchasing-power-parity adjustment.

For each MBM region *r* and year *t*, the adjustment index is:

$$
PPP^{MBM}_{rt} =
\frac{MBM_{rt}}{MBM_{Ottawa-Gatineau,t}}
$$

Adult-equivalent income is then adjusted as:

$$
AEI^{adj}_{it} =
\frac{AEI_{it}}{PPP^{MBM}_{rt}}
$$

National quintiles are constructed from the population-weighted distribution of this adjusted income for each year.

The MBM series used for 2011–2015 is the **2008-base, current-dollar series**.

**Ottawa-Gatineau** is used as the reference region.

---

# Purpose

These indicators provide alternative measures of relative income position for use in CSDUL analyses of health inequalities.

The three versions allow researchers to distinguish between:

- national relative income position;
- income position relative to others in the same province; and
- national income position after accounting for sub-provincial differences in the cost of basic goods and services.

---

# Data Sources

The indicator construction uses the following sources:

- **Canadian Community Health Survey (CCHS)**
- **T1 Family File (T1FF)**
- **DAD_NACRS_CCHS_T1FF linkage**
- **Market Basket Measure (MBM) thresholds**
- **Postal code correspondence file**

The technical documentation also discusses the **Longitudinal Administrative Databank (LAD)** in relation to Node 4's broader area-level income work.

The LAD-based dissemination-area median after-tax income indicator is conceptually distinct from the three individual-level quintile indicators documented here.

---

# Data Preparation

For 2011–2015, T1FF and CCHS records are merged using `STC_ID`.

The preparation workflow retains the variables needed to construct:

- family income;
- family size;
- respondent characteristics;
- geography;
- linkage permissions; and
- survey weights.

The technical documentation identifies the following working files:

```text
0.preparation.do
1.income_pooled.do
2.mbm_region.do
```

The actual code files should be added to the `codes/` folder once approved for CSDUL-RDC/CSDUL-OUT.

---

# Geographic and Population Coverage

- **Period:** 2011–2015
- **Unit of analysis:** individual CCHS respondent
- **Age for quintile construction:** 18 years and older
- **National indicator:** national weighted distribution
- **Provincial indicator:** province-specific weighted distributions
- **MBM-adjusted indicator:** national weighted distribution after assigning an MBM region through postal code

The MBM-adjusted indicator does not cover the territories for 2011–2015 because the corresponding MBM thresholds are not available for that period.

---

# Interpretation

For all three indicators, a higher quintile denotes a higher relative income position within the relevant reference distribution.

The reference distribution differs by indicator:

| Indicator | Reference Distribution |
|---|---|
| National adult-equivalent income quintile | Canada |
| Provincial adult-equivalent income quintile | Province |
| MBM-adjusted national adult-equivalent income quintile | Canada after regional cost-of-living adjustment |

The MBM adjustment should be interpreted as a **pseudo-PPP adjustment**, not as an official regional purchasing power parity series.

---

# Limitations and Special Considerations

Several limitations should be considered when using these indicators:

- Approximately one tenth of CCHS respondents in each year did not consent to linkage with their tax records and therefore do not have T1FF family income available for this construction.
- The T1FF uses the **census-family concept**, while the CCHS uses the **economic-household concept**.
- The square-root equivalence scale is a simplifying assumption and does not account for all differences in needs across household types.
- CCHS geographic coverage and age coverage vary across cycles.
- Methodological changes to the CCHS in 2015 affect comparability with earlier cycles.
- Postal-code matching to MBM regions is incomplete for a small share of records.
- MBM thresholds are used as a practical regional price adjustment because a directly applicable regional PPP series is not available for 2011–2015.
- The MBM-adjusted indicator excludes the territories for this period.

---

# Sample and Validation Information

The supplied sample-information document contains:

- rounded weighted population frequencies for 2011–2015;
- province-year distributions; and
- the provincial composition of national income quintiles.

These tables should be treated as validation and supporting outputs rather than as the main indicator dataset.

---

# Datasets

## Restricted RDC Inputs

The linked CCHS–T1FF microdata and related restricted files should remain in **CSDUL-RDC** and must not be uploaded to the public GitHub repository unless formally released.

## Public and Supporting Inputs

Public or releasable supporting files may include:

- MBM threshold tables;
- released metadata;
- released concordance or support files where permitted; and
- non-confidential documentation.

---

# Files

- [**Codes**](https://github.com/csdul/material_circumstances/tree/main/income_quintiles/codes): Contains the Stata dofiles and algorithms used to extract, classify, spatially aggregate, and calculate the indicators.

- [**Documents**](https://github.com/csdul/material_circumstances/tree/main/income_quintiles/documents): Includes detailed documentation describing the methodology, indicator development, assumptions, limitations, and codebook.

- [**Data**](https://github.com/csdul/material_circumstances/tree/main/income_quintiles/data): Contains the raw and/or processed data used if available in an open source.

- [**Results**](https://github.com/csdul/material_circumstances/tree/main/income_quintiles/results): Contains the indicators tables.

# References

Danieles, P. K., Heisz, A., & Lam, K. (2024). *Market Basket Measure research paper: An analysis of the equivalization method*. Statistics Canada.

Dudel, C., Garbuszus, J. M., & Schmied, J. (2021). Assessing differences in household needs: A comparison of approaches for the estimation of equivalence scales using German expenditure data. *Empirical Economics, 60*, 1629–1659.

Landry, B., Macdonald, R., Tarassoff, P., & Watt, J. (2025). *Purchasing power parities for consumption and household income across the Canadian provinces and territories*. Statistics Canada.

Statistics Canada. *Canadian Community Health Survey – Annual Component (CCHS)*.

Statistics Canada. *Annual Income Estimates for Census Families and Individuals (T1 Family File)*.

Statistics Canada. *Market Basket Measure (MBM)*.
