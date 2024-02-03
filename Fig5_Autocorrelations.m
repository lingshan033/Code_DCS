%% Figure 5. Autocorrelations of Returns and Realized Components

clear;
clc;
close all;

load ./Data/date20070501_20220507_r_RS_RV.mat

r = series_20070501_20220507.r;
RV = series_20070501_20220507.RV;
RS = series_20070501_20220507.RS;

figure(2);
set(gca,'color','none','FontSize',13);

% Plot Autocorrelations of Return
subplot(3,1,1) ;
n = length(r) ;
[ACF,lags,bounds] = autocorr(r,'NumLags',60,'NumSTD',2) ;
hold on;
plot(lags(1:60),ACF(1:60),'k', 'LineWidth', 2) ;
plot(lags(1:60),bounds(1)*ones(size(lags(1:60))),'--k', 'LineWidth', 0.5) ;
plot(lags(1:60),bounds(2)*ones(size(lags(1:60))),'--k', 'LineWidth', 0.5) ;
hold off;
xlabel('Lag Order,$$\tau$$','Interpreter','latex','FontSize', 13);
box on
title('Graph A. Corr($$r_{t},r_{t-\tau}$$)','Interpreter','latex','FontSize', 14) ;

% Plot Autocorrelations of Realized Volatility
subplot(3,1,2) ;
n = length(r) ;
[ACF,lags,bounds] = autocorr(RV,'NumLags',60,'NumSTD',2) ;
hold on;
plot(lags(1:60),ACF(1:60),'k', 'LineWidth', 2) ;
plot(lags(1:60),bounds(1)*ones(size(lags(1:60))),'--k', 'LineWidth', 0.5) ;
plot(lags(1:60),bounds(2)*ones(size(lags(1:60))),'--k', 'LineWidth', 0.5) ;
hold off;
xlabel('Lag Order,$$\tau$$','Interpreter','latex','FontSize', 13);
axis([0,60,-0.1,1]);
box on
title('Graph B. Corr($$\widetilde{RV}_{t},\widetilde{RV}_{t-\tau}$$)','Interpreter','latex','FontSize', 14) ;

% Plot Autocorrelations of Realized Skewness
subplot(3,1,3) ;
n = length(r) ;
[ACF,lags,bounds] = autocorr(RS,'NumLags',60,'NumSTD',2) ;
hold on;
plot(lags(1:60),ACF(1:60),'k', 'LineWidth', 2) ;
plot(lags(1:60),bounds(1)*ones(size(lags(1:60))),'--k', 'LineWidth', 0.5) ;
plot(lags(1:60),bounds(2)*ones(size(lags(1:60))),'--k', 'LineWidth', 0.5) ;
hold off;
xlabel('Lag Order,$$\tau$$','Interpreter','latex','FontSize', 13);
axis([0,60,-0.1,1]);
box on
title('Graph C. Corr($$\widetilde{RS}_{t},\widetilde{RS}_{t-\tau}$$)','Interpreter','latex','FontSize', 14) ;