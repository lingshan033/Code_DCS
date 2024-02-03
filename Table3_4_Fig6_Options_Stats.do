********************************************************************************
************************** Options Stata Code **********************************

* This Stata do file generates summary statistics and implied volatility plots
* for S&P 500 Index Option Data. It categorizes the data by moneyness and days to maturity (DTM),
* and saves the results into Excel files.
********************************************************************************

cd "D:\Research\Skewness\Data\Derived_data"
use OptionData.dta, clear

********************************************************************************
********** Table 3. Summary Statistics of S&P 500 Index Option Data  ***********
********************************************************************************
gen moneyness = "<0.94" if S0_over_K < 0.94
replace moneyness = "0.94-0.97" if S0_over_K >= 0.94 & S0_over_K < 0.97
replace moneyness = "0.97-1.00" if S0_over_K >= 0.97 & S0_over_K < 1.00
replace moneyness = "1.00-1.03" if S0_over_K >= 1.00 & S0_over_K < 1.03
replace moneyness = "1.03-1.06" if S0_over_K >= 1.03 & S0_over_K < 1.06
replace moneyness = ">=1.06" if S0_over_K >= 1.06

gen DTM = "<30" if T < 30
replace DTM = "30-60" if T >= 30 & T < 60
replace DTM = "60-90" if T >= 60 & T < 90
replace DTM = "90-120" if T >= 90 & T < 120
replace DTM = "120-150" if T >= 120 & T < 150
replace DTM = "150-180" if T >= 150


logout, save(Table1_option_price_bas.xlsx) excel replace: ///
  tabulate moneyness DTM, summarize(option_price) means
logout, save(Table1_option_bas.xlsx) excel replace: ///
  tabulate moneyness DTM, summarize(bid_ask_spread) means
logout, save(Table1_option_num.xlsx) excel replace: ///
  tabulate moneyness DTM

********************************************************************************
********** Table 4. Implied Volatility, In-sample and Out-of-sample  ***********
********************************************************************************
tostring date, gen(date_str)
gen year_str = substr(date_str, 1, 4)
destring year_str, gen(year)

logout, save(Table2_option_IV_in_sample) excel replace: ///
  tabulate moneyness DTM if year < 2019, summarize(impl_volatility) means 
logout, save(Table2_option_num_in_sample) excel replace: ///
  tabulate moneyness DTM if year < 2019
logout, save(Table2_option_IV_out_of_sample) excel replace: ///
  tabulate moneyness DTM if year == 2019, summarize(impl_volatility) means 
logout, save(Table2_option_num_out_of_sample) excel replace: ///
  tabulate moneyness DTM if year == 2019
  
********************************************************************************
************************ Figure 6. Implied Volatility Curves  ******************
********************************************************************************
foreach period in "<30" ">=30" {
  local title "In-sample Implied Volatility (T`period')"
  if "`period'" == ">=30" local title "Out-of-sample Implied Volatility (T`period')"
  
  twoway scatter impl_volatility S0_over_K if(year < 2019 & T `period'), ///
    msize(small) sort(S0_over_K) xlabel(0.5(0.2)1.7) scheme(qlean) legend(col(1)) ///
    xtitle("S/K") ytitle("Implied Volatility")
}