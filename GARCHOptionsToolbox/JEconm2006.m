%% Option Valuation with Conditional Skewness, Journal of Econometrics 2006

LoadData; % load model parameter values and option input variable

callPrice_HN = cPrice_HN_IFT(S,K,BSvol^2/365,rFree,tau,param_HN); % Heston-Nandi Call option price
callPrice_IGGARCH = cPrice_IGGARCH_IFT(S,K,BSvol^2/365,rFree,tau,param_IGGARCH); % IGGARCH model Call option price

cPriceDiff_HN = callPrice_HN - callPrice_BS;
cPriceDiff_IGGARCH = callPrice_IGGARCH - callPrice_BS;

% Plots the differences
figure('units','normalized','outerposition',[0 0 1 1],'Color',[1 1 1])
plot(S,cPriceDiff_HN,'-b',S,cPriceDiff_IGGARCH,'-g');
title('GARCH Model Price Less Black-Scholes Price for Call Option with Strike Price of 100','FontSize',16);
xlabel('Spot stock price','FontSize',16);
legend('Heston-Nandi GARCH','Inverse Gauss GARCH','Location','NorthWest');