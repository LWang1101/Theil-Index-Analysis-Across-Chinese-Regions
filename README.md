# 📊 Theil Index Panel Data Analysis for Chinese Regions (2005–2021)

This repository contains a Stata-based panel data analysis focused on **inequality across Chinese provinces**, using the **Theil Index** as a measure of income disparity. The dataset spans the years **2005 to 2021**, and the analysis includes baseline regressions, robustness checks, and regional heterogeneity.

> ⚠️ **Note**: The dataset and variable names are in **Chinese**, so basic knowledge of Chinese may be required to interpret the data.

---

## 📁 Project Structure

```plaintext
📂 D:/stata_tables/
├── 2005-2021泰尔指数.xlsx         # Raw dataset (in Chinese)
├── theil_analysis.do             # Main Stata analysis script
├── baseline.rtf                  # Output from baseline regressions
├── robustness.rtf                # Output from robustness checks
├── west_results.rtf              # Output from western region regressions
├── coef_plot.png                 # Regional coefficient comparison plot
├── trend.png                     # Theil index trend over time
```
🧾 Methodology
1️⃣ Data Preparation
   - Import Excel sheet "数据" using:
```
stata
Copy
Edit
import excel "2005-2021泰尔指数.xlsx", sheet("数据") firstrow case(lower) clear
```
   - Rename and convert variables:
```
stata
Copy
Edit
rename 行政区划代码 id
rename 年份 year
destring id year, replace
```
Generate key variables:
   - lnPGDP: Log of per capita disposable income
   - urban_ratio: Urban population share
   - income_ratio: Urban-rural income ratio
   - ln_pop: Log of year-end population

2️⃣ Baseline Regressions
   - Pooled OLS Regression:
```
stata
Copy
Edit
reg 泰尔指数 lnPGDP urban_ratio income_ratio ln_pop
```
   - Two-way Fixed Effects Regression:
```
stata
Copy
Edit
xtset id year
xtreg 泰尔指数 lnPGDP urban_ratio income_ratio ln_pop i.year, fe
```
- Results saved to: baseline.rtf

3️⃣ Robustness Checks
   - Replace core variable with lnPGDP_alt
   - Add lagged dependent variable L1_泰尔指数
   - Subsample: only post-2010 data
   - Example:
```
stata
Copy
Edit
xtreg 泰尔指数 lnPGDP_alt urban_ratio income_ratio ln_pop i.year, fe
```
   - Results saved to: robustness.rtf

4️⃣ Regional Heterogeneity
   - Classify regions:
      - East: ID 110000–370000
      - Central: ID 410000–460000
      - West: ID 500000–650000
   - Run fixed effects regressions for each region:
```
stata
Copy
Edit
xtreg 泰尔指数 lnPGDP urban_ratio income_ratio ln_pop i.year if region == 3, fe
```
   - Save western region output to: west_results.rtf
   - Plot coefficient comparison:
```
stata
Copy
Edit
coefplot east central west, ///
    keep(lnPGDP urban_ratio income_ratio) ///
    xline(0, lcolor(red)) ///
    title("Regional Differences") ///
    legend(label(1 "East") label(2 "Central") label(3 "West")) ///
    mcolor(blue green purple) ciopts(lcolor(gs10))
Export to: coef_plot.png
```
5️⃣ Time Trend Visualization
   - Plot Theil index trends across all provinces:
```
stata
Copy
Edit
xtline 泰尔指数, overlay ///
    title("Theil Index Trends by Province") ///
    ytitle("Theil Index") legend(off)
Export to: trend.png
```
📚 Data Source
   -File: 2005-2021泰尔指数.xlsx
   - Language: Chinese
   - Content: Provincial-level data on income, population, urbanization, and Theil index values from 2005–2021.
   - Source: Compiled from Chinese official statistical yearbooks.

🛠 Requirements
   - Stata 15.1 or later
   - Install required packages via:
```
stata
Copy
Edit
ssc install estout, replace
ssc install asdoc, replace
ssc install coefplot, replace
```
📜 License
   - This project is for academic and research purposes only.   
   - If you use the dataset or the code, please cite the original data source and this repository.
