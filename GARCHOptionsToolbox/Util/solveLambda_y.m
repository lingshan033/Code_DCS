% Solves the equation (22) in JFE paper
function [Lambda_y] = solveLambda_y(lambda_y,theta,delta)

options  = optimset('display','none','MaxIter',2000,'TolFun',1e-5,'MaxFunEvals',1e+06,'TolX',1e-20);
Lambda_y = fminsearch(@(Lambda_y)computeX(Lambda_y,lambda_y,theta,delta),-1,options);

function [fVal] = computeX(Lambda_y,lambda_y,theta,delta)

x = lambda_y - (exp(0.5*delta^2+theta)-1) - exp(Lambda_y^2*0.5*delta^2+Lambda_y*theta)*(1-exp((0.5+Lambda_y)*delta^2+theta));
fVal = x^2;