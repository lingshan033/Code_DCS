% Computes call option price under the NGARCH(1,1)-N model of Engle and Ng
% by Monte Carlo simulation method
function [cPrice] = cPrice_DVSDJ(S_t,K,h_z0,h_y0,h_zt,h_yt,rF,tau,param)

lambda_z = param(1);    lambda_y = param(2);    w_z = param(3);     w_y = param(4);
b_z = param(5);     b_y = param(6);     a_z = param(7);     a_y = param(8);
c_z = param(9);     c_y = param(10);    d_z = param(11);    d_y = param(12);
e_z = param(13);    e_y = param(14);    theta = param(15);  delta = param(16);

Lambda_y = solveLambda_y(lambda_y,theta,delta);

% Risk-Neutral Parameter Mapping
Pi = exp(Lambda_y^2*delta^2/2+Lambda_y*theta);
theta_s = theta + Lambda_y*delta^2;
xi_s = exp(delta^2/2+theta_s)-1;
w_ys = w_y*Pi;  a_ys = a_y*Pi;  c_ys = c_y+lambda_z;    c_zs = c_z+lambda_z;    d_ys = d_y*Pi;

maxJump = 25;

simStockPrice = zeros(100000,tau+1);
simStockPrice(:,1) = S_t(1);
simVariance = zeros(100000,tau+1);
simVariance(:,1) = h_z0;
simJumpIntensity = zeros(100000,tau+1);
simJumpIntensity(:,1) = h_y0*Pi;

simRandNormal = randn(100000,tau+1);
simJumpNormal = randn(100000,maxJump*(tau+1));
y_t = zeros(100000,tau+1);

numJumps = poissrnd(simJumpIntensity(:,1));
for j = 1:100000
   y_t(j,1) = theta_s*numJumps(j) + delta*sum(simJumpNormal(j,1:numJumps(j)));
end
 
% Simulate stock prices up to maximum tau
for i = 1:tau
  simVariance(:,i+1) = max(0.01*h_zt,w_z + b_z*simVariance(:,i) + (a_z./simVariance(:,i)).*(sqrt(simVariance(:,i)).*simRandNormal(:,i)-c_zs*simVariance(:,i)).^2 + d_z*(y_t(:,i)-e_z).^2);
  simJumpIntensity(:,i+1) = max(0.01*h_yt*Pi,w_ys + b_y*simJumpIntensity(:,i) + (a_ys./simJumpIntensity(:,i)).*(sqrt(simVariance(:,i)).*simRandNormal(:,i)-c_ys*simVariance(:,i)).^2 + d_ys*(y_t(:,i)-e_y).^2);  

  numJumps = poissrnd(simJumpIntensity(:,i+1));
  for j = 1:100000
      y_t(j,i+1) = theta_s*numJumps(j) + delta*sum(simJumpNormal(j,maxJump*i+1:maxJump*i+numJumps(j)));
  end
  
  simRet = rF - 0.5*simVariance(:,i+1) - xi_s*simJumpIntensity(:,i+1) + sqrt(simVariance(:,i+1)).*simRandNormal(:,i+1) + y_t(:,i+1);
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