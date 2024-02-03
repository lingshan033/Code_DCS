% Computes call option price undparams(25)er the AGARCH(1,1)-GED(C) model
% by Monte Carlo simulation method
function [cPrice] = cPrice_AGARCH_GEDC(S_t,K,h_0,h_t,q_t,rF,tau,param)

lambda = param(1);  alpha = param(2);   beta = param(3);   gamma_1 = param(4);
                    phi = param(5);     rho = param(6);    gamma_2 = param(7);  nu = param(8);

w = h_0*(1-rho); % Variance targeting where h_0 denotes the long-run variance
b_nu = linApproxGED(nu);

simStockPrice = zeros(20*5000,tau+1);
simStockPrice(:,1) = S_t(1);
simVariance = zeros(20*5000,tau+1);
simVariance(:,1) = h_t;
simLongVariance = zeros(20*5000,tau+1);
simLongVariance(:,1) = q_t;

% Generate 5000 by 20 Noraml random numbers using Sobol sequence
simRandNormal = zeros(20*5000,tau+1);
sobolNum = sobolset(20,'Skip',1e+3);

for i = 1:tau+1
    % Apply scrambling
    randU = scramble(sobolNum,'MatousekAffineOwen');
    randU = net(randU,5000);
    % Convert randU to standard normal random variables
    randN = norminv(randU);
    randN = reshape(randN,[],1);
    simRandNormal(:,i) = randN;
end

% Simulate stock prices up to maximum tau
for i = 1:tau
  eta_t = gedinv(normcdf(simRandNormal(:,i)-(lambda/b_nu+0.5*b_nu)*sqrt(simVariance(:,i))),nu);
  simLongVariance(:,i+1) = w + rho*simLongVariance(:,i) + phi*(eta_t.^2-1-2*gamma_2*sqrt(simVariance(:,i)).*eta_t);  
  simVariance(:,i+1) = simLongVariance(:,i+1) + beta*(simVariance(:,i)-simLongVariance(:,i)) + alpha*(eta_t.^2-1-2*gamma_1*sqrt(simVariance(:,i)).*eta_t);  
  eta_t1 = gedinv(normcdf(simRandNormal(:,i+1)-(lambda/b_nu+0.5*b_nu)*sqrt(simVariance(:,i+1))),nu);
  simRet = rF + lambda*simVariance(:,i+1) + sqrt(simVariance(:,i+1)).*eta_t1;
  simStockPrice(:,i+1) = simStockPrice(:,i).*exp(simRet);
end

% Duan and Simonato (1998)'s Empirical Martingale Simulation Adjustment
ZMat = zeros(20*5000,tau+1);
simStockEMS = zeros(20*5000,tau+1);

simStockEMS(:,1) = S_t(1);

for i = 1:tau
    ZMat(:,i+1) = simStockEMS(:,i).*simStockPrice(:,i+1)./simStockPrice(:,i);
    Z0 = exp(-rF*i)*mean(ZMat(:,i+1));
    simStockEMS(:,i+1) = S_t(1)*ZMat(:,i+1)/Z0;
end

simFinalRet = simStockEMS(:,end)/S_t(1);
simStockFinal = S_t*simFinalRet';

callPayoff = max(simStockFinal-K*ones(1,numel(simFinalRet)),0);
cPrice = exp(-rF*tau)*mean(callPayoff,2);