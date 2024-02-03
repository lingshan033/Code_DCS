%% The Economic Value of Realized Volatility: Using High-Frequency Returns for Option Valuation

LoadData; % load model parameter values and option input variable

% Journal of Financial and Quantitative Analysis 2014
callPrice_ARV = cPrice_ARV_IFT(S,K,BSvol^2/365,rFree,tau,param_ARV); % ARV model Call option price
callPrice_GARV = cPrice_GARV_IFT(S,K,ones(1,2)*BSvol^2/365,rFree,tau,param_GARV); % GARV model Call option price

cPriceDiff_ARV = callPrice_ARV - callPrice_BS;
cPriceDiff_GARV = callPrice_GARV - callPrice_BS;

% Plots the differences
figure('units','normalized','outerposition',[0 0 1 1],'Color',[1 1 1])
plot(S,cPriceDiff_ARV,'-b',S,cPriceDiff_GARV,'-g');
title('RV Model Price Less Black-Scholes Price for Call Option with Strike Price of 100','FontSize',16);
xlabel('Spot stock price','FontSize',16);
legend('ARV','GARV','Location','NorthWest');