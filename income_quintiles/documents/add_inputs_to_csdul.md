
# CSDUL – Form to Add Indicators or Models

## Basic Information

**Request date (YYYY-MM-DD):**  
2026-08-11

**Researcher (name and affiliation):**  
[TO COMPLETE]

**Node Lead (name and affiliation):**  
[TO COMPLETE]

**Indicator/Model Name:**  
Adult-Equivalent Income Quintiles

---

## 1. CSDUL Environment

### 1.1. Will you share the inputs through CSDUL-RDC, CSDUL-OUT, or both?

**Proposed answer:** Both.

Restricted linked microdata and any non-releasable intermediate files should remain
in CSDUL-RDC. Approved code, documentation, public supporting data, and
disclosure-cleared results can be stored in CSDUL-OUT.

---

## 2. Explanation of the Indicator

### 2.1. In simple words, explain what the indicator to be added consists of.

The indicator classifies CCHS respondents into income quintiles using after-tax
census-family income from the T1FF. Family income is first adjusted for family size
using the square-root equivalence scale.

Three related versions are constructed:

1. national adult-equivalent income quintiles;
2. provincial adult-equivalent income quintiles; and
3. national adult-equivalent income quintiles after a regional cost-of-living
   adjustment based on MBM thresholds.

### 2.2. Are there assumptions associated with the indicator?

Yes. The main assumptions are:

- T1FF after-tax family income is used as the income measure.
- Census-family size is used to equivalize income.
- The square-root equivalence scale is used.
- Quintiles are based on population-weighted distributions.
- The national indicator uses the Canadian distribution.
- The provincial indicator uses province-specific distributions.
- The MBM-adjusted indicator treats relative MBM thresholds as a practical proxy for
  regional purchasing-power differences.
- Ottawa-Gatineau is the reference MBM region in the pseudo-PPP calculation.
- Respondents without linked T1FF income are excluded from the main construction.

### 2.3. How is the indicator derived?

Adult-equivalent income is:

$$
AEI_{it} = \frac{Y_{it}}{\sqrt{S_{it}}}
$$

where $Y_{it}$ is after-tax census-family income and $S_{it}$ is census-family size.

For the national indicator, the population-weighted annual distribution of $AEI$ is
divided into quintiles.

For the provincial indicator, the same procedure is performed separately within each
province.

For the MBM-adjusted indicator:

$$
PPP^{MBM}_{rt} =
\frac{MBM_{rt}}{MBM_{Ottawa-Gatineau,t}}
$$

and:

$$
AEI^{adj}_{it} =
\frac{AEI_{it}}{PPP^{MBM}_{rt}}
$$

Annual national quintiles are then constructed from the weighted distribution of the
adjusted income.

### 2.4. What geographic unit(s) are the indicators built on?

The unit of analysis is the individual CCHS respondent.

Geography enters the indicators in two ways:

- province for the provincial income distribution; and
- MBM region, assigned using postal code, for the cost-of-living adjustment.

### 2.5. How can the indicator be integrated with other datasets?

The CCHS and T1FF records are linked using `STC_ID`. Because the resulting indicator
is attached to CCHS respondents, it can be incorporated into CSDUL person-level
analyses and linked to health outcomes and other individual or contextual indicators
available in the CSDUL environment.

### 2.6. What are the boundaries of the indicator?

- Reference years: 2011–2015.
- Main quintile construction: respondents aged 18 and older.
- Respondents without linked T1FF family income are excluded from the primary
  construction.
- The MBM-adjusted version does not include the territories for 2011–2015 because
  territorial MBM thresholds are unavailable for this period.
- The CCHS excludes some populations and its geographic/sample design varies across
  cycles.
- The 2015 CCHS redesign limits direct comparability with earlier cycles.

### 2.7. Is this associated with a hypothesis?

**N/A.** These are constructed indicators rather than a hypothesis-testing model.

### 2.8. What is the interpretation of the values?

For all three versions:

- `1` = lowest income quintile;
- `2` = second income quintile;
- `3` = middle income quintile;
- `4` = fourth income quintile;
- `5` = highest income quintile.

The reference population differs across versions. National quintiles indicate relative
position in the national distribution; provincial quintiles indicate relative position
within a province; MBM-adjusted national quintiles indicate national relative position
after adjusting income for regional differences in MBM thresholds.

### 2.9. Potential weaknesses

Potential limitations include:

- exclusion of respondents who do not consent to tax-file linkage;
- differences between the T1FF census-family concept and the CCHS economic-household
  concept;
- sensitivity to the chosen equivalence scale;
- coverage limitations in the CCHS;
- changes to the CCHS methodology in 2015;
- incomplete postal-code matching to MBM regions;
- lack of MBM values for the territories during 2011–2015;
- use of MBM thresholds as a pseudo-PPP rather than a direct regional price index;
- possible error if income is later imputed for non-linked respondents.

---

## 3. Other Mathematical or Computational Versions

Alternative approaches include:

- the modified OECD equivalence scale instead of the square-root scale;
- self-reported CCHS household-income measures;
- income imputation for respondents without linked T1FF income;
- tax-simulator-based imputation;
- direct regional PPP adjustments for periods where suitable PPP estimates are
  available.

### 3.1. Why is this version proposed?

The square-root equivalence scale is widely used and is supported in the supplied
technical documentation as appropriate in the Canadian context.

T1FF income is preferred to self-reported CCHS income because it is based on tax
records and provides after-tax family income.

The provincial and MBM-adjusted variants add geographic context to the national
income ranking.

For 2011–2015, the MBM approach provides a practical way to account for local
cost-of-living differences when a directly applicable regional PPP series is not
available.

---

## 4. Potential Improvements

Possible future improvements include:

- imputation for respondents without linked T1FF income;
- use of tax simulators to improve imputation;
- sensitivity analysis using alternative equivalence scales;
- extension beyond 2015;
- use of Northern MBM values for years in which they are available;
- comparison with direct regional PPP measures for later years;
- validation against area-level income measures;
- development of the separate LAD-based dissemination-area median after-tax income
  indicator proposed for Node 4.

---

# Inputs to Be Added to CSDUL

- [x] **Raw datasets or intermediate datasets**  
  Required for construction, but restricted microdata should remain in CSDUL-RDC.

- [x] **Codes**  
  Data preparation and indicator-construction scripts.

- [x] **Documentation**  
  Technical documentation, methodological notes, codebook, and this completed form.

- [x] **Results**  
  Disclosure-cleared indicator files and validation tables.

- [x] **Support files**  
  Relevant methodological references and MBM support documentation.

---

# References

See the technical documentation supplied with this indicator package for the complete
reference list.
