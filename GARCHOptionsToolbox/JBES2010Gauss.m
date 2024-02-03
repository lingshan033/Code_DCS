%% Volatility Components, Affine Restrictions, and Nonnormal Components, Journal of Business & Economic Statistics 2010

LoadData; % load model parameter values and option input variable

% Gaussian Models
callPrice_NGARCHN = cPrice_NGARCHN(S,K,BSvol^2/365,BSvol^2/365,rFree,tau,param_NGARCHN);
callPrice_NGARCHNC = cPrice_NGARCHNC(S,K,BSvol^2/365,0.9*BSvol^2/365,BSvol^2/365,rFree,tau,param_NGARCHNC);

cPriceDiff_NGARCHN = callPrice_NGARCHN - callPrice_BS;
cPriceDiff_NGARCHNC = callPrice_NGARCHNC - callPrice_BS;

% Plots the differences
figure('units','normalized','outerposition',[0 0 1 1],'Color',[1 1 1])
plot(S,cPriceDiff_NGARCHN,'-b',S,cPriceDiff_NGARCHNC,'-g');
title('GARCH Model Price Less Black-Scholes Price for Call Option with Strike Price of 100','FontSize',16);
xlabel('Spot stock price','FontSize',16);
legend('Gaussian NGARCH(1,1)','Gaussian NGARCH(Component)','Location','NorthWest');