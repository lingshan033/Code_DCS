%% Figure 1:  Dynamics of Skewness and Volatility

clear;
clc;
close all;

SKEW_VIX = readmatrix(".\Data\SKEW_VIX.xlsx","OutputType","string");
dateObjs = datetime(SKEW_VIX(:,1), 'InputFormat', 'MM/dd/yyyy');
date = str2num(datestr(dateObjs, 'yyyymmdd'));

SKEW = str2double(SKEW_VIX(:,end-1));
VIX = str2double(SKEW_VIX(:,end));
year = floor(date/10000);
tick = find(year(2:end)>year(1:end-1))+1;

figure(1)
x = 1:1:length(SKEW);
hold on

yyaxis left;
ylim = 180;
plot(x, SKEW, 'Color','#3855A5', 'LineWidth', 1.5);

set(gca,'XTick',tick)
set(gca,'XTickLabel',{'1991','1992','1993','1994','1995','1996','1997','1998','1999','2000', ...
    '2001','2002','2003','2004','2005','2006','2007','2008','2009','2010', ...
    '2011','2012','2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023'});
set(gca,'xlim',[0 length(date)]);
set(gca,'ylim',[100 ylim]);
set(gca,'FontSize',12);
set(gca,'box','off');
set(0,'defaultfigurecolor','w');

yyaxis right;
plot(x, VIX, 'Color', 'k', 'LineWidth', 1, 'LineStyle','--');
box off
ax2 = axes('Position',get(gca,'Position'),...
    'XAxisLocation','top',...
    'YAxisLocation','right',...
    'Color','none',...
    'XColor','k','YColor','k');
set(ax2,'YTick', []);
set(ax2,'XTick', []);
box on
