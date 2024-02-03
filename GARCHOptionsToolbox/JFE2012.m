%% Dynamic Jump Intensities and Risk Premiums: Evidence from S&P500 Returns and Options

LoadData; % load model parameter values and option input variable

% Journal of Financial Economics 2012
h_DVCJ = BSvol^2/252*0.9792;
h_DVDJ = BSvol^2/252*0.8772;
h_z_DVSDJ = BSvol^2/252*0.7955;
h_y_DVSDJ = (BSvol^2/252*0.2045)/(param_DVSDJ(15)^2+param_DVSDJ(16)^2);

callPrice_DVCJ = cPrice_DVCJ(S,K,h_DVCJ,h_DVCJ,rFree,tau,param_DVCJ);
callPrice_DVDJ = cPrice_DVDJ(S,K,h_DVDJ,h_DVDJ,rFree,tau,param_DVDJ);
callPrice_DVSDJ = cPrice_DVSDJ(S,K,h_z_DVSDJ,h_y_DVSDJ,h_z_DVSDJ,h_y_DVSDJ,rFree,tau,param_DVSDJ);

cPriceDiff_DVCJ = callPrice_DVCJ - callPrice_BS;
cPriceDiff_DVDJ = callPrice_DVDJ - callPrice_BS;
cPriceDiff_DVSDJ = callPrice_DVSDJ - callPrice_BS;

% Plots the differences
figure('units','normalized','outerposition',[0 0 1 1],'Color',[1 1 1])
plot(S,cPriceDiff_DVCJ,'-b',S,cPriceDiff_DVDJ,'-g',S,cPriceDiff_DVSDJ,'-r');
title('GARCH Model Price Less Black-Scholes Price for Call Option with Strike Price of 100','FontSize',16);
xlabel('Spot stock price','FontSize',16);
legend('DVCJ','DVDJ','DVSDJ');