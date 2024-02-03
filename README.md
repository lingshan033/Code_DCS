# Option Pricing with Dynamic Conditional Skewness

## Introduction
This repository contains the MATLAB and Stata code accompanying the paper _Option Pricing with Dynamic Conditional Skewness_. The code includes implementations for calculating option prices using the Dynamic Conditional Skewness model, as well as scripts for generating various figures and tables presented in the paper.

## Contents
- `Data/`: Folder containing the datasets used in the models. Due to database access restrictions, the file `date20070501_20220507_r_RS_RV.mat` and file concerning option data are not publicly available. However, we provide data of Cboe SKEW Index and Cboe Volatility Index.
- `GARCHOptionsToolbox/`: MATLAB toolbox for GARCH option pricing models. This toolbox is primarily sourced from Professor Peter Christoffersen's official website https://christoffersen.com/. We have added `JFMrr2024.m`, which directly displays pricing using the DCS model, and `cPrice_DCS_IFT`, which contains the pricing code for the DCS model.
- `Calcu_RMSE/`: Script for calculating the Root Mean Square Error (RMSE) of model predictions, including Implied Volatility Root Mean Square Error and Vega-Weighted Pricing Root Mean Square Error.
- `Fig1_Dynamics_Skewness_Volatility.m`: MATLAB script for generating Figure 1, which illustrates the dynamics of Cboe SKEW Index and Cboe Volatility Index.
- `Fig2_Intraday_Skewness.m`: MATLAB script for generating Figure 2, showing the process of constructing intraday skewness.
- `Fig3_Densities.m`: MATLAB script for generating Figure 3, depicting histogram of historical returns, and the densities of normal distribution, inverse Gaussian distribution, and the sum of normal distribution and inverse Gaussian distribution.
- `Fig4_Historical_Series.m`: MATLAB script for generating Figure 4, historical series of returns and realized components.
- `Fig5_Autocorrelations.m`: MATLAB script for generating Figure 5, which analyzes autocorrelations of historical returns and realized components.
- `Table1_Summary_Stats.m`: MATLAB script for generating Table 1, summarizing the statistics of historical returns and realized components.
- `Table3_4_Fig6_Options_Stats.do`: Stata do-file for generating Table 3 (concerning bid-ask spread, price, and number of contracts), 4 (concerning in-sample and out-of-sample implied volatility) and Figure 6 (implied volatility curves), related to options dataset.

## Requirements
- MATLAB (version 2021b or later)
- Stata (version 17 or later)

## Usage
Each script is self-contained and can be run independently to reproduce the figures and tables in the paper. The scripts require the dataset `date20070501_20220507_r_RS_RV.mat` which is not included in this repository due to database access restrictions. Users may generate a similar `.mat` file to run the scripts.

## License
This project is licensed under the [MIT License](LICENSE).

## Citation
If you find this code useful for your research, please cite our paper:

```bibtex
@article{Liang2024,
  title={Option Pricing with Dynamic Conditional Skewness},
  author={Fang Liang, Lingshan Du},
  journal={Working Paper},
  year={2024}
}
