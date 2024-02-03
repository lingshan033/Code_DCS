%% Option Valuation with Long-run and Short-run Volatility Components, Journal of Financial Economics 2008

LoadData; % load model parameter values and option input variable

callPrice_CGARCH = cPrice_CGARCH_IFT(S,K,[0.1*BSvol^2/365 BSvol^2/365],rFree,tau,param_CGARCH); % CGARCH model Call option price with spot (q_t-h_t) being 10% of spot Long-run component
callPrice_PCGARCH = cPrice_PCGARCH_IFT(S,K,[0.1*BSvol^2/365 BSvol^2/365],rFree,tau,param_PCGARCH); % Persistenr CGARCH model Call option price

cPriceDiff_CGARCH = callPrice_CGARCH - callPrice_BS;
cPriceDiff_PCGARCH = callPrice_PCGARCH - callPrice_BS;

% Plots the differences
figure('units','normalized','outerposition',[0 0 1 1],'Color',[1 1 1])
plot(S,cPriceDiff_CGARCH,'-b',S,cPriceDiff_PCGARCH,'-g');
title('GARCH Model Price Less Black-Scholes Price for Call Option with Strike Price of 100','FontSize',16);
xlabel('Spot stock price','FontSize',16);
legend('Component GARCH','Persistent Component GARCH','Location','NorthWest');