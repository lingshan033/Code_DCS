%% Option Pricing with Dynamic Conditional Skewness

LoadData; % load model parameter values and option input variable

param_DCS = [0;1e-6;0.95;1e-7;500;0.2;0;0;10;0];

% Journal of Financial and Quantitative Analysis 2014
callPrice_ARV = cPrice_ARV_IFT(S,K,BSvol^2/365,rFree,tau,param_ARV); % ARV model Call option price
% Journal of Econometrics 2006
callPrice_IGGARCH = cPrice_IGGARCH_IFT(S,K,BSvol^2/365,rFree,tau,param_IGGARCH); % IGGARCH model Call option price
% Journal of Futures Markets (Revise and Resubmit) 2024
callPrice_DCS = cPrice_DCS_IFT(S,K,[BSvol^2/365,BSvol^2/365],rFree,tau,param_DCS); % DCS model Call option price

cPriceDiff_ARV = callPrice_ARV - callPrice_BS;
cPriceDiff_IGGARCH = callPrice_IGGARCH - callPrice_BS;
cPriceDiff_DCS = callPrice_DCS - callPrice_BS;

% Plots the differences
figure('units','normalized','outerposition',[0 0 1 1],'Color',[1 1 1])
plot(S,cPriceDiff_ARV,'--k',S,cPriceDiff_IGGARCH,'-.k',S,cPriceDiff_DCS,'-k','LineWidth',2);
title('DCS Model and Benchmark Model Price Less Black-Scholes Price for Call Option with Strike Price of 100','FontSize',18);
xlabel('Spot stock price','FontSize',16,'Interpreter','latex');
legend('ARV','IG','DCS','Location','NorthWest','Interpreter','latex');