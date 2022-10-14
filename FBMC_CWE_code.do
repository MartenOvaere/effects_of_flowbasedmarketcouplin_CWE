// The effect of flow-based market coupling on cross-border exchange volumes and price convergence in Central Western European electricity markets
// Marten Ovaere, Michiel Kenis & Kenneth Van den Bergh - October 2022

version 14
clear
cls
graph drop _all
program drop _all
set more off
cd "..." //Change this to your own directory 
set matsize 5000

****************************************************************
// Table 1: Summary Statistics dependent variables
****************************************************************

use FBMC_CWE_data, clear

// Drop data before 2015 because generation unavailability data only start on 1/1/2015. As such, all variants can be compared on the same sample
drop if Year<=2014 

balancetable FBMC NEP NEP_abs_BE NEP_abs_DE NEP_abs_FR NEP_abs_NL imports* exports* ///
dp dp_benl dp_befr dp_defr dp_denl dp_bede dp_frnl PricesDA_BE PricesDA_DE PricesDA_FR PricesDA_NL using tables/Table1.tex ///
, wide(mean sd pval) ctitles("Average before FBMC" "std. dev. before FBMC" "Average after FBMC" "std. dev. after FBMC" "p-value of difference in means") replace ///
varlabels booktabs displayformat nonumbers pvalues pval(fmt(%5.2f) nopar) staraux noobs //

****************************************************************
// Figure 2: Plots of price developments in each country
****************************************************************

use FBMC_CWE_data, clear
collapse (mean) PricesDA_BE* PricesDA_NL* PricesDA_DE* PricesDA_FR* (min) months, by(Year Month)
//drop if months <= -5

graph twoway (line PricesDA_BE months, lwidth(medthick)) (line PricesDA_FR months, lwidth(medthick)) (line PricesDA_DE months, lwidth(medthick)) (line PricesDA_NL months, lwidth(medthick)) ///
, xline(0) ytitle("Monthly average price [€/MWh]") graphregion(color(white)) bgcolor(white) xtitle("Months before and after the introduction of FBMC") ///
yla(, ang(h)) xscale(range(-4 31)) xlabel(-30(5)30)  legend(row(1) region(col(white)) lab(1 "Belgium") lab(2 "France") lab(3 "Germany") lab(4 "Netherlands"))
graph export figures/Figure2.eps, replace
graph export figures/Figure2.png, replace
graph export figures/Figure2.pdf, replace

// graph twoway (line PricesDA_BE months, lwidth(medthick)) ///
// , xline(0) ytitle("Monthly average price in Belgium [€/MWh]") graphregion(color(white)) bgcolor(white) xtitle("Months before and after the introduction of FBMC") ///
// yla(, ang(h)) xscale(range(-4 31)) xlabel(-5(5)30) 
// graph export figures/Figure2a.eps, replace
// graph export figures/Figure2a.png, replace
// graph export figures/Figure2a.pdf, replace
//
// graph twoway (line PricesDA_NL months, lwidth(medthick)) ///
// , xline(0) ytitle("Monthly average price in Belgium [€/MWh]") graphregion(color(white)) bgcolor(white) xtitle("Months before and after the introduction of FBMC") ///
// yla(, ang(h)) xscale(range(-4 31)) xlabel(-5(5)30) 
// graph export figures/Figure2b.eps, replace
// graph export figures/Figure2b.png, replace
// graph export figures/Figure2b.pdf, replace
//
// graph twoway (line PricesDA_FR months, lwidth(medthick)) ///
// , xline(0) ytitle("Monthly average price in Belgium [€/MWh]") graphregion(color(white)) bgcolor(white) xtitle("Months before and after the introduction of FBMC") ///
// yla(, ang(h)) xscale(range(-4 31)) xlabel(-5(5)30) 
// graph export figures/Figure2c.eps, replace
// graph export figures/Figure2c.png, replace
// graph export figures/Figure2c.pdf, replace
//
// graph twoway (line PricesDA_DE months, lwidth(medthick)) ///
// , xline(0) ytitle("Monthly average price in Belgium [€/MWh]") graphregion(color(white)) bgcolor(white) xtitle("Months before and after the introduction of FBMC") ///
// yla(, ang(h)) xscale(range(-4 31)) xlabel(-5(5)30) 
// graph export figures/Figure2d.eps, replace
// graph export figures/Figure2d.png, replace
// graph export figures/Figure2d.pdf, replace

****************************************************************
// Table 2: Summary Statistics control variables
****************************************************************

use FBMC_CWE_data, clear

// Drop data before 2015 because generation unavailability data only start on 1/1/2015. As such, all variants can be compared on the same sample
drop if Year<=2014 

// Load
balancetable FBMC LoadDA_BE LoadDA_DE LoadDA_FR LoadDA_NL using tables/Table2a.tex ///
, wide(mean sd pval) ctitles("Average before FBMC" "std. dev. before FBMC" "Average after FBMC" "std. dev. after FBMC" "p-value of difference in means") replace ///
varlabels booktabs displayformat nonumbers pvalues pval(fmt(%5.2f) nopar) staraux noobs //

// Wind power generation and solar power generation
balancetable FBMC WindDA_BE WindDA_DE WindDA_FR WindDA_NL SolarDA_BE SolarDA_DE SolarDA_FR SolarDA_NL using tables/Table2b.tex ///
, wide(mean sd pval) ctitles("Average before FBMC" "std. dev. before FBMC" "Average after FBMC" "std. dev. after FBMC" "p-value of difference in means") replace ///
varlabels booktabs displayformat nonumbers pvalues pval(fmt(%5.2f) nopar) staraux noobs //

// Gas power generation
balancetable FBMC gen_gas_BE gen_gas_DE gen_gas_FR gen_gas_NL using tables/Table2c.tex ///
, wide(mean sd pval) ctitles("Average before FBMC" "std. dev. before FBMC" "Average after FBMC" "std. dev. after FBMC" "p-value of difference in means") replace ///
varlabels booktabs displayformat nonumbers pvalues pval(fmt(%5.2f) nopar) staraux noobs //

// Coal power generation
balancetable FBMC gen_coal_BE gen_coal_DE gen_coal_FR gen_coal_NL using tables/Table2d.tex ///
, wide(mean sd pval) ctitles("Average before FBMC" "std. dev. before FBMC" "Average after FBMC" "std. dev. after FBMC" "p-value of difference in means") replace ///
varlabels booktabs displayformat nonumbers pvalues pval(fmt(%5.2f) nopar) staraux noobs //

// Nuclear power generation
balancetable FBMC gen_nuclear_BE gen_nuclear_DE gen_nuclear_FR gen_nuclear_NL using tables/Table2e.tex ///
, wide(mean sd pval) ctitles("Average before FBMC" "std. dev. before FBMC" "Average after FBMC" "std. dev. after FBMC" "p-value of difference in means") replace ///
varlabels booktabs displayformat nonumbers pvalues pval(fmt(%5.2f) nopar) staraux noobs //

// Unavailable capacity: nuclear power in France, nuclear power in Belgium, coal power in Germany, and gas power in Germany
balancetable FBMC gen_unav_nuclear_FR gen_unav_nuclear_BE gen_unav_coal_DE gen_unav_gas_DE using tables/Table2f.tex ///
, wide(mean sd pval) ctitles("Average before FBMC" "std. dev. before FBMC" "Average after FBMC" "std. dev. after FBMC" "p-value of difference in means") replace ///
varlabels booktabs displayformat nonumbers pvalues pval(fmt(%5.2f) nopar) staraux noobs //

// Commodity prices: coal, gas and carbon price
balancetable FBMC Coal Gas Carbon using tables/Table2g.tex ///
, wide(mean sd pval) ctitles("Average before FBMC" "std. dev. before FBMC" "Average after FBMC" "std. dev. after FBMC" "p-value of difference in means") replace ///
varlabels booktabs displayformat nonumbers pvalues pval(fmt(%5.2f) nopar) staraux noobs //

// Temperature
balancetable FBMC temperature_be temperature_fr temperature_nl temperature_de using tables/Table2h.tex ///
, wide(mean sd pval) ctitles("Average before FBMC" "std. dev. before FBMC" "Average after FBMC" "std. dev. after FBMC" "p-value of difference in means") replace ///
varlabels booktabs displayformat nonumbers pvalues pval(fmt(%5.2f) nopar) staraux noobs //

// Exchanges with non-CWE-countries
balancetable FBMC ch_de de_ch ch_fr fr_ch sl_de de_sl es_fr fr_es it_fr fr_it uk_fr fr_uk uk_nl nl_uk no_nl nl_no se_de de_se hu_de de_hu it_de de_it dk_de de_dk cz_de de_cz pl_de de_pl temperature_fr temperature_nl temperature_de using tables/Table2i.tex ///
, wide(mean sd pval) ctitles("Average before FBMC" "std. dev. before FBMC" "Average after FBMC" "std. dev. after FBMC" "p-value of difference in means") replace ///
varlabels booktabs displayformat nonumbers pvalues pval(fmt(%5.2f) nopar) staraux noobs //

***************************************************************************
// Figure 3: Short term effect on cross-border exchange volumes 
***************************************************************************

use FBMC_CWE_data, clear
local bw=720 // 30 days bandwidth around the discontinuity 

// Panel (a): Pre/post
egen mean_pre = mean(NEP) if (Time_normalized > -`bw' & Time_normalized < 0)
egen mean_post = mean(NEP) if (Time_normalized < `bw' & Time_normalized > 0)
graph twoway (scatter NEP Time_plot if abs(Time_normalized)<`bw') (line mean_pre Time_plot if Time_normalized<0 & abs(Time_normalized)<`bw', lwidth(vthick)) ///
(line mean_post Time_plot if Time_normalized>0 & abs(Time_normalized)<`bw', lwidth(vthick) ), xline(0) ytitle(Hourly exchanges in CWE [MWh]) ///
xtitle(Days before and after the introduction of FBMC) legend(off) graphregion(color(white)) bgcolor(white) xlabel(-30(10)30) 
graph export figures/Figure3a.eps, replace
graph export figures/Figure3a.png, replace
graph export figures/Figure3a.pdf, replace

// Panel (b): Local linear
graph twoway (scatter NEP Time_plot if abs(Time_normalized)<`bw') (lfit NEP Time_plot if Time_normalized<0 & abs(Time_normalized)<`bw', lwidth(vthick)) ///
(lfit NEP Time_plot if Time_normalized>0 & abs(Time_normalized)<`bw', lwidth(vthick) ), xline(0) ytitle(Hourly exchanges in CWE [MWh]) ///
xtitle(Days before and after the introduction of FBMC) legend(off) graphregion(color(white)) bgcolor(white) xlabel(-30(10)30)
graph export figures/Figure3b.eps, replace
graph export figures/Figure3b.png, replace
graph export figures/Figure3b.pdf, replace

// Panel (c): Augmented local linear
qui reg NEP i.Month i.Hour i.Dow
predict NEPhat, xb
gen delta_NEP = NEP-NEPhat
graph twoway (scatter delta_NEP Time_plot if abs(Time_normalized)<`bw') (lfit delta_NEP Time_plot if Time_normalized<0 & abs(Time_normalized)<`bw', lwidth(vthick)) ///
(lfit delta_NEP Time_plot if Time_normalized>0 & abs(Time_normalized)<`bw', lwidth(vthick) ), xline(0) ytitle(Hourly exchanges in CWE [MWh]) ///
xtitle(Days before and after the introduction of FBMC) legend(off) graphregion(color(white)) bgcolor(white) xlabel(-30(10)30)
graph export figures/Figure3c.eps, replace
graph export figures/Figure3c.png, replace
graph export figures/Figure3c.pdf, replace

***************************************************************************
// Figure 4: Short term effect on weighted price difference
***************************************************************************

use FBMC_CWE_data, clear
local bw=720 // 30 days bandwidth around the discontinuity 
drop if Time_normalized < -`bw'

// Panel (a): Pre/post
egen mean_pre = mean(dp) if (Time_normalized > -`bw' & Time_normalized < 0)
egen mean_post = mean(dp) if (Time_normalized < `bw' & Time_normalized > 0)
graph twoway (scatter dp Time_plot if abs(Time_normalized)<`bw') (line mean_pre Time_plot if Time_normalized<0 & abs(Time_normalized)<`bw', lwidth(vthick)) ///
(line mean_post Time_plot if Time_normalized>0 & abs(Time_normalized)<`bw', lwidth(vthick) ), xline(0) ytitle(Hourly price difference (dp) [€/MWh]) ///
xtitle(Days before and after the introduction of FBMC) legend(off) graphregion(color(white)) bgcolor(white) xlabel(-30(10)30) 
graph export figures/Figure4a.eps, replace
graph export figures/Figure4a.png, replace
graph export figures/Figure4a.pdf, replace

// Panel (b): Local linear
graph twoway (scatter dp Time_plot if abs(Time_normalized)<`bw') (lfit dp Time_plot if Time_normalized<0 & abs(Time_normalized)<`bw', lwidth(vthick)) ///
(lfit dp Time_plot if Time_normalized>0 & abs(Time_normalized)<`bw', lwidth(vthick) ), xline(0) ytitle(Hourly price difference (dp) [€/MWh]) ///
xtitle(Days before and after the introduction of FBMC) legend(off) graphregion(color(white)) bgcolor(white) xlabel(-30(10)30)
graph export figures/Figure4b.eps, replace
graph export figures/Figure4b.png, replace
graph export figures/Figure4b.pdf, replace

// Panel (c): Augmented local linear
qui reg dp i.Month i.Hour i.Dow // Estimation of time-fixed effects
predict dphat, xb
gen delta_dp = dp-dphat // Residual after subtracting time-fixed effects
graph twoway (scatter delta_dp Time_plot if abs(Time_normalized)<`bw') (lfit delta_dp Time_plot if Time_normalized<0 & abs(Time_normalized)<`bw', lwidth(vthick)) ///
(lfit delta_dp Time_plot if Time_normalized>0 & abs(Time_normalized)<`bw', lwidth(vthick) ), xline(0) ytitle(Hourly price difference (dp) [€/MWh]) ///
xtitle(Days before and after the introduction of FBMC) legend(off) graphregion(color(white)) bgcolor(white) xlabel(-30(10)30)
graph export figures/Figure4c.eps, replace
graph export figures/Figure4c.png, replace
graph export figures/Figure4c.pdf, replace

***************************************************************************
// Section 4.1.1: Short term effect on cross-border exchange volumes 
***************************************************************************

use FBMC_CWE_data, clear
local bw=720 // 30 days bandwidth around the discontdays inuity 

// Pre/post 
reg NEP FBMC if abs(Time_normalized) < `bw' // The coefficient with 'FBMC' is the treatment effect (beta_FBMC in the manuscript)
	
// Local linear 
qui reg NEP Time_normalized if (Time_normalized > -`bw' & Time_normalized < 0)
matrix b = e(b)
gen constant1 = b[1,2] // alpha_{0,pre} in the manuscript
qui reg NEP Time_normalized if (Time_normalized < `bw' & Time_normalized > 0)
matrix b = e(b)
gen constant2 = b[1,2] // alpha_{0,post} in the manuscript
gen diff = constant2 - constant1
sum diff // the treatment effect beta_FBMC in the manuscript
drop diff constant1 constant2

// Augmented local linear 
qui reg NEP i.Month i.Hour i.Dow // Estimation of time-fixed effects
predict NEPhat, xb
gen delta_NEP = NEP-NEPhat // Residual after subtracting time-fixed effects
qui reg delta_NEP Time_normalized if (Time_normalized > -`bw' & Time_normalized < 0)
matrix b = e(b)
gen constant1 = b[1,2] // alpha_{0,pre} in the manuscript
qui reg delta_NEP Time_normalized if (Time_normalized < `bw' & Time_normalized > 0)
matrix b = e(b)
gen constant2 = b[1,2] // alpha_{0,post} in the manuscript
gen diff = constant2 - constant1
sum diff // the treatment effect beta_FBMC in the manuscript
drop diff constant1 constant2

***************************************************************************
// Section 4.1.2: Short term effect on weighted price difference
***************************************************************************

use FBMC_CWE_data, clear
local bw=720 // 30 days bandwidth around the discontdays inuity 

// Pre/post 
reg dp FBMC if abs(Time_normalized) < `bw' // The coefficient with 'FBMC' is the treatment effect (beta_FBMC in the manuscript)
	
// Local linear 
qui reg dp Time_normalized if (Time_normalized > -`bw' & Time_normalized < 0)
matrix b = e(b)  
gen constant1 = b[1,2] // alpha_{0,pre} in the manuscript
qui reg dp Time_normalized if (Time_normalized < `bw' & Time_normalized > 0)
matrix b = e(b)
gen constant2 = b[1,2] // alpha_{0,post} in the manuscript
gen diff = constant2 - constant1
sum diff // the treatment effect beta_FBMC in the manuscript
drop diff constant1 constant2 

// Augmented local linear 
qui reg dp i.Month i.Hour i.Dow // Estimation of time-fixed effects
predict dphat, xb
gen delta_dp = dp-dphat // Residual after subtracting time-fixed effects
reg delta_dp Time_normalized if (Time_normalized > -`bw' & Time_normalized < 0)
matrix b = e(b)
gen constant1 = b[1,2] // alpha_{0,pre} in the manuscript
reg delta_dp Time_normalized if (Time_normalized < `bw' & Time_normalized > 0)
matrix b = e(b)
gen constant2 = b[1,2] // alpha_{0,post} in the manuscript
gen diff = constant2 - constant1
sum diff // the treatment effect beta_FBMC in the manuscript
drop diff constant1 constant2


****************************************************************
// Figure 5a: Long term effect on cross-border exchange volumes 
****************************************************************

use FBMC_CWE_data, clear

// Create local group variables for the sake of clarity 
local Load LoadDA_BE LoadDA_DE LoadDA_FR LoadDA_NL
local SolarDA SolarDA_BE SolarDA_DE SolarDA_FR SolarDA_NL
local WindDA WindDA_BE WindDA_DE WindDA_FR WindDA_NL
local GenerationDA gen_gas_BE gen_gas_DE gen_gas_FR gen_gas_NL gen_nuclear_BE gen_nuclear_DE gen_nuclear_FR gen_nuclear_NL gen_coal_BE gen_coal_DE gen_coal_FR gen_coal_NL
local Commodities Coal Gas Carbon
local Generation_unav gen_unav_nuclear* gen_unav_gas* gen_unav_coal* 
local temperature temperature_be temperature_nl temperature_fr temperature_de
local NonFBMCexchange ch_de de_ch ch_fr fr_ch sl_de de_sl es_fr fr_es it_fr fr_it uk_fr fr_uk uk_nl nl_uk no_nl nl_no se_de de_se hu_de de_hu it_de de_it dk_de de_dk cz_de de_cz pl_de de_pl 

// Filter out the time-fixed effects
local x = 720
local i = 0
reg NEP i.Month i.Hour i.Dow if Time_normalized < 0
predict NEPhat, xb
gen deltaNEP=NEP-NEPhat

// Drop data before 2015 because generation unavailability data only start on 1/1/2015. As such, all variants can be compared on the same sample
drop if Year<=2014  

// While-loop that increases time span after the introduction of FBMC, starting after 30 days (= 720 hours/samples) up until 956 days (= 22944 hours/samples)
while `x' < 22944 { 

  local i = `i' + 1

  // Blue line: no controls
  reg NEP FBMC if Time_normalized > -8760 & Time_normalized < `x' 
  matrix A = r(table)
  local blue_avg`i' = A[1,1] // Average value of beta_X
  local blue_lowerbound`i' = A[5,1] // Lower limit of 95% confidence interval of beta_X
  local blue_upperbound`i' = A[6,1] // Upper limit of 95% confidence interval of beta_X
  
  // Red line: controls for market conditions
  reg deltaNEP FBMC `Load' `SolarDA' `WindDA' `GenerationDA' `Commodities' `Generation_unav' `temperature' `NonFBMCexchange' if Time_normalized > -8760 & Time_normalized < `x' 
  matrix A = r(table)
  local red_avg`i' = A[1,1] // Average value of beta_X
  local red_lowerbound`i' = A[5,1] // Lower limit of 95% confidence interval of beta_X
  local red_upperbound`i' = A[6,1] // Upper limit of 95% confidence interval of beta_X

  local x`i' = `x'
  local x = `x' + 168
  
}

// Define the vectors where the useful information will be stored
capture set obs `i'
gen x = .
gen blue_avg = .
gen blue_lowerbound = .
gen blue_upperbound = .
gen red_avg = .
gen red_lowerbound = .
gen red_upperbound = .

// For-loop that assigns the information on beta_X in the related vectors
forval j = 1/`i' {

  replace x = `x`j'' in `j'
  replace blue_avg = `blue_avg`j'' in `j'
  replace blue_lowerbound = `blue_lowerbound`j'' in `j'
  replace blue_upperbound = `blue_upperbound`j'' in `j'
  replace red_avg = `red_avg`j'' in `j'
  replace red_lowerbound = `red_lowerbound`j'' in `j'
  replace red_upperbound = `red_upperbound`j'' in `j'

}

// For graphical interpretation purposes, set the running variables in 'Days' instead of 'Hours'
replace x=x/24

// Plot and export Figure 5a
graph twoway (rarea red_lowerbound red_upperbound x, color(cranberry)) (rarea blue_lowerbound blue_upperbound x, color(navy)) (scatteri 1318 30 1318 960, recast(line) lcolor(black) lpattern(dash)) ///
, yline(0, lcolor(black)) ytitle("Change of hourly cross-border exchange volume (X)" "compared to pre-FBMC [MWh/h]") graphregion(color(white)) bgcolor(white) xtitle(Days after the introduction of Flow-Based Market Coupling) ///
legend(off)
graph export figures/Figure5a.eps, replace
graph export figures/Figure5a.png, replace
graph export figures/Figure5a.pdf, replace

****************************************************************
// Figure 5b: Long term effect on weighted price difference 
****************************************************************
	
use FBMC_CWE_data, clear

// Create local group variables for the sake of clarity 
local Load LoadDA_BE LoadDA_DE LoadDA_FR LoadDA_NL
local SolarDA SolarDA_BE SolarDA_DE SolarDA_FR SolarDA_NL
local WindDA WindDA_BE WindDA_DE WindDA_FR WindDA_NL
local GenerationDA gen_gas_BE gen_gas_DE gen_gas_FR gen_gas_NL gen_nuclear_BE gen_nuclear_DE gen_nuclear_FR gen_nuclear_NL gen_coal_BE gen_coal_DE gen_coal_FR gen_coal_NL
local Commodities Coal Gas Carbon
local Generation_unav gen_unav_nuclear* gen_unav_gas* gen_unav_coal* 
local temperature temperature_be temperature_nl temperature_fr temperature_de
local NonFBMCexchange ch_de de_ch ch_fr fr_ch sl_de de_sl es_fr fr_es it_fr fr_it uk_fr fr_uk uk_nl nl_uk no_nl nl_no se_de de_se hu_de de_hu it_de de_it dk_de de_dk cz_de de_cz pl_de de_pl 


// Filter out the time-fixed effects
local x = 720
local i = 0
reg dp i.Month i.Hour i.Dow if Time_normalized < 0
predict dphat, xb
gen deltadp=dp-dphat

// Drop data before 2015 because generation unavailability data only start on 1/1/2015. As such, all variants can be compared on the same sample
drop if Year<=2014 

// While-loop that increases time span after the introduction of FBMC, starting after 30 days (= 720 hours/samples) up until 956 days (= 22944 hours/samples)
while `x' < 22944 { 

  local i = `i' + 1

  // Blue line: no controls
  reg dp FBMC if Time_normalized > -8760 & Time_normalized < `x' 
  matrix A = r(table)
  local blue_avg`i' = A[1,1] // Average value of beta_dp
  local blue_lowerbound`i' = A[5,1] // Lower limit of 95% confidence interval of beta_dp
  local blue_upperbound`i' = A[6,1] // Upper limit of 95% confidence interval of beta_dp
  
  // Red line: controls for market conditions
  reg deltadp FBMC `Load' `SolarDA' `WindDA' `GenerationDA' `Commodities' `Generation_unav' `temperature' `NonFBMCexchange' if Time_normalized > -8760 & Time_normalized < `x' 
  matrix A = r(table)
  local red_avg`i' = A[1,1] // Average value of beta_dp
  local red_lowerbound`i' = A[5,1] // Lower limit of 95% confidence interval of beta_dp
  local red_upperbound`i' = A[6,1] // Upper limit of 95% confidence interval of beta_dp

  local x`i' = `x'
  local x = `x' + 168
  
}

// Define the vectors where the useful information will be stored
capture set obs `i'
gen x = .
gen blue_avg = .
gen blue_lowerbound = .
gen blue_upperbound = .
gen red_avg = .
gen red_lowerbound = .
gen red_upperbound = .

// For-loop that assigns the information on beta_dp in the related vectors
forval j = 1/`i' {

  replace x = `x`j'' in `j'
  replace blue_avg = `blue_avg`j'' in `j'
  replace blue_lowerbound = `blue_lowerbound`j'' in `j'
  replace blue_upperbound = `blue_upperbound`j'' in `j'
  replace red_avg = `red_avg`j'' in `j'
  replace red_lowerbound = `red_lowerbound`j'' in `j'
  replace red_upperbound = `red_upperbound`j'' in `j'

}

// For graphical interpretation purposes, set the running variables in 'Days' instead of 'Hours'
replace x=x/24

// Plot and export Figure 5b
graph twoway (rarea red_lowerbound red_upperbound x, color(cranberry))  (rarea blue_lowerbound blue_upperbound x, color(navy)) (scatteri -6.36 30 -6.36 960, recast(line) lcolor(black) lpattern(dash)) ///
, yline(0, lcolor(black)) ytitle("Change of hourly weighted price difference ({&Delta}P)" "compared to pre-FBMC [€/MWh]") graphregion(color(white)) bgcolor(white) xtitle(Days after the introduction of Flow-Based Market Coupling) legend(off)
graph export figures/Figure5b.eps, replace
graph export figures/Figure5b.png, replace
graph export figures/Figure5b.pdf, replace	
	
****************************************************************
// Figure 6: Remaining Available Margin over time (moving average)
****************************************************************
	
use FBMC_CWE_data, clear

// There are no data on RAMs before introduction of FBMC because it did not exist yet
drop if Year <= 2014

// For the sake of clarity, round off the days
replace days = round(days)

// Plot and export Figure 6
graph twoway (line ram_movingaverage days, lwidth(medthick)) ///
, xline(0) ytitle("Moving average RAM [MW]") graphregion(color(white)) bgcolor(white) xtitle("Days after the introduction of FBMC") ///
yla(, ang(h)) xscale(range(-140 955)) xlabel(0(150)955)
graph export figures/Figure6.eps, replace
graph export figures/Figure6.png, replace 
graph export figures/Figure6.pdf, replace
	
****************************************************************
// Table A1: Summary Statistics control variables within short term time span
****************************************************************

use FBMC_CWE_data, clear

drop if days < -30
drop if days > 30

// Load
balancetable FBMC LoadDA_BE LoadDA_DE LoadDA_FR LoadDA_NL using tables/TableA1a.tex ///
, wide(mean sd pval) ctitles("Average before FBMC" "std. dev. before FBMC" "Average after FBMC" "std. dev. after FBMC" "p-value of difference in means") replace ///
varlabels booktabs displayformat nonumbers pvalues pval(fmt(%5.2f) nopar) staraux noobs //

// Wind power generation and solar power generation
balancetable FBMC WindDA_BE WindDA_DE WindDA_FR WindDA_NL SolarDA_BE SolarDA_DE SolarDA_FR SolarDA_NL using tables/TableA1b.tex ///
, wide(mean sd pval) ctitles("Average before FBMC" "std. dev. before FBMC" "Average after FBMC" "std. dev. after FBMC" "p-value of difference in means") replace ///
varlabels booktabs displayformat nonumbers pvalues pval(fmt(%5.2f) nopar) staraux noobs //

// Gas power generation
balancetable FBMC gen_gas_BE gen_gas_DE gen_gas_FR gen_gas_NL using tables/TableA1c.tex ///
, wide(mean sd pval) ctitles("Average before FBMC" "std. dev. before FBMC" "Average after FBMC" "std. dev. after FBMC" "p-value of difference in means") replace ///
varlabels booktabs displayformat nonumbers pvalues pval(fmt(%5.2f) nopar) staraux noobs //

// Coal power generation
balancetable FBMC gen_coal_BE gen_coal_DE gen_coal_FR gen_coal_NL using tables/TableA1d.tex ///
, wide(mean sd pval) ctitles("Average before FBMC" "std. dev. before FBMC" "Average after FBMC" "std. dev. after FBMC" "p-value of difference in means") replace ///
varlabels booktabs displayformat nonumbers pvalues pval(fmt(%5.2f) nopar) staraux noobs //

// Nuclear power generation
balancetable FBMC gen_nuclear_BE gen_nuclear_DE gen_nuclear_FR gen_nuclear_NL using tables/TableA1e.tex ///
, wide(mean sd pval) ctitles("Average before FBMC" "std. dev. before FBMC" "Average after FBMC" "std. dev. after FBMC" "p-value of difference in means") replace ///
varlabels booktabs displayformat nonumbers pvalues pval(fmt(%5.2f) nopar) staraux noobs //

// Unavailable nuclear power capacity
balancetable FBMC gen_unav_nuclear_BE gen_unav_nuclear_DE gen_unav_nuclear_FR gen_unav_nuclear_NL using tables/TableA1f.tex ///
, wide(mean sd pval) ctitles("Average before FBMC" "std. dev. before FBMC" "Average after FBMC" "std. dev. after FBMC" "p-value of difference in means") replace ///
varlabels booktabs displayformat nonumbers pvalues pval(fmt(%5.2f) nopar) staraux noobs //

// Unavailable gas power capacity
balancetable FBMC gen_unav_gas_BE gen_unav_gas_DE gen_unav_gas_FR gen_unav_gas_NL using tables/TableA1g.tex ///
, wide(mean sd pval) ctitles("Average before FBMC" "std. dev. before FBMC" "Average after FBMC" "std. dev. after FBMC" "p-value of difference in means") replace ///
varlabels booktabs displayformat nonumbers pvalues pval(fmt(%5.2f) nopar) staraux noobs //

// Unavailable coal power capacity
balancetable FBMC gen_unav_coal_BE gen_unav_coal_DE gen_unav_coal_FR gen_unav_coal_NL  using tables/TableA1h.tex ///
, wide(mean sd pval) ctitles("Average before FBMC" "std. dev. before FBMC" "Average after FBMC" "std. dev. after FBMC" "p-value of difference in means") replace ///
varlabels booktabs displayformat nonumbers pvalues pval(fmt(%5.2f) nopar) staraux noobs //

// Commodity prices: coal, gas and carbon price
balancetable FBMC Coal Gas Carbon using tables/TableA1i.tex ///
, wide(mean sd pval) ctitles("Average before FBMC" "std. dev. before FBMC" "Average after FBMC" "std. dev. after FBMC" "p-value of difference in means") replace ///
varlabels booktabs displayformat nonumbers pvalues pval(fmt(%5.2f) nopar) staraux noobs //








