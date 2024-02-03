%% Table 1: Summary Statistics of Returns and Realized Components

clear;
clc;

load date20070501_20220507_r_RS_RV.mat

r = series_20070501_20220507.r;
RV = series_20070501_20220507.RV;
RS = series_20070501_20220507.RS;

r_ar1 = aryule(r,1);
r_ar1 = -r_ar1(2);
RV_ar1 = aryule(sqrt(RV),1);
RV_ar1 = -RV_ar1(2);
RS_ar1 = aryule(sqrt(RS),1);
RS_ar1 = -RS_ar1(2);

table_stats = [mean(r*100*252), median(r*100*252), std(r*100*sqrt(252)), skewness(r),kurtosis(r),r_ar1; ...
    mean(sqrt(RV*10000*252)), median(sqrt(RV*10000*252)), std(sqrt(RV*10000*252)), skewness(sqrt(RV)),kurtosis(sqrt(RV)),RV_ar1;
    mean(sqrt(RS*10000*252)), median(sqrt(RS*10000*252)), std(sqrt(RS*10000*252)), skewness(sqrt(RS)),kurtosis(sqrt(RS)),RS_ar1];

