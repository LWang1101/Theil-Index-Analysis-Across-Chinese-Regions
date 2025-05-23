# Theil Index Analysis Across Chinese Regions (2005–2021)

This repository contains a Stata-based statistical analysis of **Theil Index data from Chinese administrative regions**, covering the years **2005 to 2021**. The data file and some variables are in **Chinese**, and variable labels are preserved for clarity.

## 📂 Project Structure

- `2005-2021泰尔指数.xlsx`: **Raw dataset (in Chinese)** containing regional per capita income, population, and Theil index values.
- `analysis.do`: Main Stata script for data import, cleaning, transformation, and descriptive statistics.
- `summary_table.doc`: Output of summary statistics generated with `asdoc` in Word format.

> ⚠️ **Note**: The dataset and some variable names are in Chinese. Basic knowledge of Chinese is helpful for interpretation.

## 🧾 Variables and Processing

The following steps are performed in the script:

1. **Data Import**  
   Imports the Excel file with first-row variable names and converts select variables to numeric.

2. **Variable Renaming & Labeling**
   - `id`: Administrative region code (原始变量名：行政区划代码)
   - `year`: Year (年份)
   - `lnPGDP`: Log of per capita disposable income (对原始中文变量“全体居民人均可支配收入”取对数)
   - `Lnf`: Log of year-end resident population (对“年末常住人口”取对数)
   - `泰尔指数`: Theil index

3. **Descriptive Statistics**
   - Count and summarize key variables.
   - Generate a formatted Word report using `asdoc`.

## 📊 Output

The output includes a Word document (`summary_table.doc`) containing descriptive statistics for:
- Theil Index
- Log per capita income (`lnPGDP`)
- Log population (`Lnf`)

```stata
asdoc sum 泰尔指数 lnPGDP Lnf, replace ///
stats(N mean sd min max) ///
title(描述性统计) font("宋体") ///
save(summary_table.doc), replace
```
🧪 Requirements
  - Stata 14 or later
  - asdoc package (install via: ssc install asdoc)
  - Chinese system fonts (e.g., 宋体) for proper rendering of labels in Word output

📜 License
  - This project is intended for academic and research use.
  - If you use this repository or the data, please provide appropriate attribution.
