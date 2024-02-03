%% Volatility Components, Affine Restrictions, and Nonnormal Components, Journal of Business & Economic Statistics 2010

LoadData; % load model parameter values and option input variable

% GED Models
callPrice_AGARCH_GED = cPrice_AGARCH_GED(S,K,BSvol^2/365,BSvol^2/365,rFree,tau,param_AGARCHGED);
callPrice_AGARCH_GEDC = cPrice_AGARCH_GEDC(S,K,BSvol^2/365,0.9*BSvol^2/365,BSvol^2/365,rFree,tau,param_AGARCHGEDC);
callPrice_NGARCH_GED = cPrice_NGARCH_GED(S,K,BSvol^2/365,BSvol^2/365,rFree,tau,param_NGARCHGED);
callPrice_NGARCH_GEDC = cPrice_NGARCH_GEDC(S,K,BSvol^2/365,0.9*BSvol^2/365,BSvol^2/365,rFree,tau,param_NGARCHGEDC);

cPriceDiff_AGARCH_GED = callPrice_AGARCH_GED - callPrice_BS;
cPriceDiff_AGARCH_GEDC = callPrice_AGARCH_GEDC - callPrice_BS;
cPriceDiff_NGARCH_GED = callPrice_NGARCH_GED - callPrice_BS;
cPriceDiff_NGARCH_GEDC = callPrice_NGARCH_GEDC - callPrice_BS;

% Plots the differences
figure('units','normalized','outerposition',[0 0 1 1],'Color',[1 1 1])
plot(S,cPriceDiff_AGARCH_GED,'-b',S,cPriceDiff_AGARCH_GEDC,'-g',S,cPriceDiff_NGARCH_GED,'-r',S,cPriceDiff_NGARCH_GEDC,'-m');
title('GARCH Model Price Less Black-Scholes Price for Call Option with Strike Price of 100','FontSize',16);
xlabel('Spot stock price','FontSize',16);
legend('Affine GARCH-GED(1,1)','Affine GARCH-GED(Component)','NGARCH-GED(1,1)','NGARCH-GED(Component)','Location','NorthWest');