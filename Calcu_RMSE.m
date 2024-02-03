%% This function helps to calculate Implied Volatility Root Mean Square Error of Each Subgroup

function [TotalSE,PanelA,PanelB,PanelC] = Calcu_RMSE(S0,K,T_op,rf_op,op,IV_MKT,moneyness,VIX,optionMODPrice,optionMKTPrice,vega)

op_MOD = abs(op);
IV_MOD = blsimpv(S0,K,rf_op*365,T_op/365, op_MOD);

IVerror = abs(IV_MOD - IV_MKT);
Perror = (optionMODPrice-optionMKTPrice)./vega;

% total
IVRMSE = sqrt(mean(IVerror.^2)) * 100;
PRMSE = sqrt(mean(Perror.^2));

[TotalSE] = [IVRMSE,PRMSE];
array_delta = zeros(6,1); 
array_T = array_delta; 
array_VIX = array_delta;

% Sorted by Delta
array_delta(1,1) = sqrt(mean((IVerror(moneyness<0.94)).^2)) * 100; 
array_delta(2,1) = sqrt(mean((IVerror(moneyness>=0.94 & moneyness<0.97)).^2)) * 100;
array_delta(3,1) = sqrt(mean((IVerror(moneyness>=0.97 & moneyness<1)).^2)) * 100; 
array_delta(4,1) = sqrt(mean((IVerror(moneyness>=1 & moneyness<1.03)).^2)) * 100; 
array_delta(5,1) = sqrt(mean((IVerror(moneyness>=1.03 & moneyness<1.06)).^2)) * 100; 
array_delta(6,1) = sqrt(mean((IVerror(moneyness>1.06)).^2)) * 100; 

array_delta(1,2) = sqrt(mean((Perror(moneyness<0.94)).^2)); 
array_delta(2,2) = sqrt(mean((Perror(moneyness>=0.94 & moneyness<0.97)).^2));
array_delta(3,2) = sqrt(mean((Perror(moneyness>=0.97 & moneyness<1)).^2)); 
array_delta(4,2) = sqrt(mean((Perror(moneyness>=1 & moneyness<1.03)).^2)); 
array_delta(5,2) = sqrt(mean((Perror(moneyness>=1.03 & moneyness<1.06)).^2)); 
array_delta(6,2) = sqrt(mean((Perror(moneyness>1.06)).^2)); 

PanelA = array_delta;

% Sorted by Maturity
array_T(1,1) = sqrt(mean((IVerror(T_op<30)).^2)) * 100; 
array_T(2,1) = sqrt(mean((IVerror(T_op>=30 & T_op<60)).^2)) * 100; 
array_T(3,1) = sqrt(mean((IVerror(T_op>=60 & T_op<90)).^2)) * 100; 
array_T(4,1) = sqrt(mean((IVerror(T_op>=90 & T_op<120)).^2)) * 100; 
array_T(5,1) = sqrt(mean((IVerror(T_op>=120 & T_op<150)).^2)) * 100; 
array_T(6,1) = sqrt(mean((IVerror(T_op>=150)).^2)) * 100; 

array_T(1,2) = sqrt(mean((Perror(T_op<30)).^2)); 
array_T(2,2) = sqrt(mean((Perror(T_op>=30 & T_op<60)).^2)); 
array_T(3,2) = sqrt(mean((Perror(T_op>=60 & T_op<90)).^2)); 
array_T(4,2) = sqrt(mean((Perror(T_op>=90 & T_op<120)).^2)); 
array_T(5,2) = sqrt(mean((Perror(T_op>=120 & T_op<150)).^2)); 
array_T(6,2) = sqrt(mean((Perror(T_op>=150)).^2)); 

PanelB = array_T;

% Sorted by VIX
array_VIX(1,1) = sqrt(mean((IVerror(VIX<12)).^2)) * 100; 
array_VIX(2,1) = sqrt(mean((IVerror(VIX>=12 & VIX<15)).^2)) * 100; 
array_VIX(3,1) = sqrt(mean((IVerror(VIX>=15 & VIX<18)).^2)) * 100; 
array_VIX(4,1) = sqrt(mean((IVerror(VIX>=18 & VIX<21)).^2)) * 100; 
array_VIX(5,1) = sqrt(mean((IVerror(VIX>=21 & VIX<24)).^2)) * 100; 
array_VIX(6,1) = sqrt(mean((IVerror(VIX>=24)).^2)) * 100; 

array_VIX(1,2) = sqrt(mean((Perror(VIX<12)).^2)); 
array_VIX(2,2) = sqrt(mean((Perror(VIX>=12 & VIX<15)).^2)); 
array_VIX(3,2) = sqrt(mean((Perror(VIX>=15 & VIX<18)).^2)); 
array_VIX(4,2) = sqrt(mean((Perror(VIX>=18 & VIX<21)).^2)); 
array_VIX(5,2) = sqrt(mean((Perror(VIX>=21 & VIX<24)).^2)); 
array_VIX(6,2) = sqrt(mean((Perror(VIX>=24)).^2)); 

PanelC = array_VIX;
end