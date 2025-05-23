/*===== 基础设置 =====*/
version 15.1
clear all
set more off
ssc install estout, replace  // 安装结果输出包
ssc install asdoc, replace

/*===== 数据准备 =====*/
cd "D:/stata_tables"
import excel "2005-2021泰尔指数.xlsx", sheet("数据") firstrow case(lower) clear

/* 变量处理 */
rename 行政区划代码 id
rename 年份 year
destring id year, replace

// 生成核心变量
gen lnPGDP = ln(全体居民人均可支配收入)
gen urban_ratio = 城镇人口/(城镇人口 + 乡村人口)  // 城镇化率
gen income_ratio = 城镇居民人均可支配收入/农村居民人均可支配收入  // 城乡收入比
gen ln_pop = ln(年末常住人口)

/*===== 基准回归 =====*/
// 混合OLS
reg 泰尔指数 lnPGDP urban_ratio income_ratio ln_pop
est store m1

// 双向固定效应模型
xtset id year
xtreg 泰尔指数 lnPGDP urban_ratio income_ratio ln_pop i.year, fe
est store m2

// 结果输出
esttab m1 m2 using baseline.rtf, replace ///
    b(%6.3f) se(%6.3f) ///
    star(* 0.1 ** 0.05 *** 0.01) ///
    stats(r2 N, fmt(%9.3f %9.0g)) ///
    title("基准回归结果")

/*===== 稳健性检验 =====*/
// 检验1：替换核心解释变量
gen lnPGDP_alt = ln(城镇居民人均可支配收入)  // 改用城镇收入
xtreg 泰尔指数 lnPGDP_alt urban_ratio income_ratio ln_pop i.year, fe
est store robust1

// 检验2：加入滞后项
gen L1_泰尔指数 = L.泰尔指数
xtreg 泰尔指数 L1_泰尔指数 lnPGDP urban_ratio income_ratio ln_pop i.year, fe
est store robust2

// 检验3：子样本分析（2010年后）
xtreg 泰尔指数 lnPGDP urban_ratio income_ratio ln_pop i.year if year>=2010, fe
est store robust3

// 输出稳健性结果
esttab robust1 robust2 robust3 using robustness.rtf, replace ///
    b(%6.3f) se(%6.3f) ///
    star(* 0.1 ** 0.05 *** 0.01) ///
    title("稳健性检验结果")

/*===== 异质性分析（修正后） =====*/

// 重新定义西部地区（以实际省份ID为准）
gen region = 1 if inrange(id, 110000, 370000)  // 东部
replace region = 2 if inrange(id, 410000, 460000)  // 中部
replace region = 3 if inrange(id, 500000, 650000)  // 西部（重庆、四川、贵州等）

// 剔除关键变量缺失的观测
drop if missing(泰尔指数, lnPGDP, urban_ratio, income_ratio, ln_pop)

// 西部回归（简化模型）
xtreg 泰尔指数 lnPGDP urban_ratio i.year if region == 3, fe
est store west

// 输出结果
esttab west using west_results.rtf, replace ///
    b(%6.3f) se(%6.3f) ///
    star(* 0.1 ** 0.05 *** 0.01) ///
    stats(r2 N, fmt(%9.3f %9.0g)) ///
title("西部地区回归结果")

// 先运行回归模型
xtreg 泰尔指数 lnPGDP urban_ratio income_ratio ln_pop i.year if region==1, fe
estimates store east

xtreg 泰尔指数 lnPGDP urban_ratio income_ratio ln_pop i.year if region==2, fe
estimates store central

xtreg 泰尔指数 lnPGDP urban_ratio income_ratio ln_pop i.year if region==3, fe
estimates store west

// 绘制系数对比图
coefplot east central west, ///
    keep(lnPGDP urban_ratio income_ratio) ///
    xline(0, lcolor(red)) ///
    title("核心变量区域差异") ///
    legend(label(1 "东部") label(2 "中部") label(3 "西部")) ///
    mcolor(blue green purple) ///
    ciopts(lcolor(gs10))
graph export coef_plot.png, width(2000) replace

// 泰尔指数趋势图
xtline 泰尔指数, overlay ///
    title("各省泰尔指数变化趋势") ///
    ytitle("泰尔指数") ///
    legend(off)
graph export trend.png, replace


/*
/* 设置工作路径（需修改为实际路径） */
cd "D:/stata_tables"

/* 导入泰尔指数数据（自动检测数据范围） */
import excel "2005-2021泰尔指数.xlsx", sheet("数据") firstrow case(lower) clear

/* 处理变量名并转换为数值型 */
rename 行政区划代码 id
rename 年份 year
destring id year, replace
label variable id "行政区划代码"
label variable year "年份"

/* 生成新变量 */
gen lnPGDP = ln(全体居民人均可支配收入)  // 居民收入对数
gen Lnf = ln(年末常住人口)               // 人口规模对数

/* 变量标签 */
label variable 泰尔指数 "泰尔指数"
label variable lnPGDP "人均GDP对数"
label variable Lnf "人口规模对数"

/* 数据检查 */
count
sum 泰尔指数 lnPGDP Lnf

/* 生成描述性统计表 */
asdoc sum 泰尔指数 lnPGDP Lnf, replace ///
stats(N mean sd min max) ///
title(描述性统计) font("宋体") ///
save(summary_table.doc), replace
*/
