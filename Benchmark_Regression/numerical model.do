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
