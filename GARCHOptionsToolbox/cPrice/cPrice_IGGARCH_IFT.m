% Computes the call option price using quadl numerical integration 
% Code for IGGARCH Model
% S_t = d vector of spot stock prices
% K = d vector of Strike Prices
% tau = d vector of time to maturity
% h_t = d vector of variance processes
function [c] = cPrice_IGGARCH_IFT(S_t,K,h_t,rF,tau,param)

t_Hk = @(u)imag(CF_IGGARCH(u-1i,S_t,h_t,tau,param).*exp(-1i.*u.*log(K))./(1i*u+1))./u;

c = 0.5*S_t + exp(-rF*tau)/pi.*integral(t_Hk,0,1000,'ArrayValued',true);

% u is a N-column vector
% tau is a d-column vector of maturities
% Output is N by d matrix
function [Psi] = CF_IGGARCH(u,S_t,h_t,tau,param)

rF = 0.05/365;

u1 = 1i*u;
N = numel(u);
T = max(tau);
AMat1 = zeros(N,T);
BMat1 = zeros(N,T);

mu = param(1);  omega = param(2);   b = param(3);   a = param(4);   c = param(5);   eta = param(6);

% A and B and time T-1
AMat1(:,1) = u1*rF;
BMat1(:,1) = mu*u1 + 1/eta^2 - (1/eta^2)*sqrt(1-2*eta*u1);

% Recursion back to time t
for t = 2:T
    AMat1(:,t) = AMat1(:,t-1) + u1*rF + BMat1(:,t-1)*omega - 0.5*log(1-2*a*eta^4*BMat1(:,t-1));
    BMat1(:,t) = b*BMat1(:,t-1) + mu*u1 + 1/eta^2 - (1/eta^2)*sqrt((1-2*a*eta^4*BMat1(:,t-1))*(1-2*c*BMat1(:,t-1)-2*eta*u1));  
end

Psi = exp(log(S_t).*u1 + AMat1(:,tau) + BMat1(:,tau).*repmat(h_t',N,1));