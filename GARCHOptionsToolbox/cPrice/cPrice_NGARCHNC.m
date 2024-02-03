% Computes call option price under the NGARCH(1,1)-N(C) model
% by Monte Carlo simulation method
function [cPrice] = cPrice_NGARCHNC(S_t,K,h_0,h_t,q_t,rF,tau,param)

lambda = param(1);  alpha = param(2);   beta = param(3);   gamma_1 = param(4);
                    phi = param(5);     rho = param(6);    gamma_2 = param(7);

w = h_0*(1-rho); % Variance targeting where h_0 denotes the long-run variance

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
  simLongVariance(:,i+1) = w + rho*simLongVariance(:,i) + phi*simVariance(:,i).*(simRandNormal(:,i).^2-2*(gamma_2+lambda)*simRandNormal(:,i)+2*gamma_2*lambda+lambda^2-1);
  simVariance(:,i+1) = simLongVariance(:,i+1) + beta*(simVariance(:,i)-simLongVariance(:,i)) + alpha*simVariance(:,i).*(simRandNormal(:,i).^2-2*(gamma_1+lambda)*simRandNormal(:,i)+2*gamma_1*lambda+lambda^2-1);
  simRet = rF - 0.5*simVariance(:,i+1) + sqrt(simVariance(:,i+1)).*simRandNormal(:,i+1);
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