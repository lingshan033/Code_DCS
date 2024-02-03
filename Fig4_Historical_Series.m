%% Figure 4. Historical Series of Returns and Realized Components

clear;
clc;
close all;


load ./Data/date20070501_20220507_r_RS_RV.mat

uniqueDates = series_20070501_20220507.date;
r = series_20070501_20220507.r;
RV = series_20070501_20220507.RV;
RS = series_20070501_20220507.RS;

figure(1);
set(gca,'color','none');

% Plot Square Root of Return
subplot(3,1,1)
x = [1:1:length(r)];
plot(x, r, 'k', 'LineWidth', 1);
year = floor(uniqueDates/10000);
tick = find(year(2:end)>year(1:end-1))+1;
set(gca,'XTick',tick)
set(gca,'XTickLabel',{'2008','2009','2010','2011','2012','2013','2014','2015','2016','2017','2018','2019','2020','2021','2022'})
set(gca,'xlim',[0 length(uniqueDates)])
set(gca,'FontSize',14)
set(gca,'box','off');
set(0,'defaultfigurecolor','w');
title('Graph A','Interpreter','latex');

box off
ax2 = axes('Position',get(gca,'Position'),...
'XAxisLocation','top',...
'YAxisLocation','right',...
'Color','none',...
'XColor','k','YColor','k');
set(ax2,'YTick', []);
set(ax2,'XTick', []);
box on

% Plot Square Root of Realized Volatiliy
subplot(3,1,2)
x = [1:1:length(r)];
plot(x, sqrt(RV), 'k', 'LineWidth', 1);
year = floor(uniqueDates/10000);
tick = find(year(2:end)>year(1:end-1))+1;
set(gca,'XTick',tick)
set(gca,'XTickLabel',{'2008','2009','2010','2011','2012','2013','2014','2015','2016','2017','2018','2019','2020','2021','2022'})
set(gca,'xlim',[0 length(uniqueDates)])
set(gca,'FontSize',14)
set(gca,'box','off');
set(0,'defaultfigurecolor','w');
title('Graph B','Interpreter','latex');

box off
ax2 = axes('Position',get(gca,'Position'),...
'XAxisLocation','top',...
'YAxisLocation','right',...
'Color','none',...
'XColor','k','YColor','k');
set(ax2,'YTick', []);
set(ax2,'XTick', []);
box on

% Plot Square Root of Realized Skewness
subplot(3,1,3)
x = [1:1:length(r)];
plot(x, sqrt(RS), 'k', 'LineWidth', 1);
year = floor(uniqueDates/10000);
tick = find(year(2:end)>year(1:end-1))+1;
set(gca,'XTick',tick)
set(gca,'XTickLabel',{'2008','2009','2010','2011','2012','2013','2014','2015','2016','2017','2018','2019','2020','2021','2022'})
set(gca,'xlim',[0 length(uniqueDates)])
set(gca,'FontSize',14)
set(gca,'box','off');
set(0,'defaultfigurecolor','w');
title('Graph C','Interpreter','latex');

box off
ax2 = axes('Position',get(gca,'Position'),...
'XAxisLocation','top',...
'YAxisLocation','right',...
'Color','none',...
'XColor','k','YColor','k');
set(ax2,'YTick', []);
set(ax2,'XTick', []);
box on