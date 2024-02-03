% Computes the call option price using quadl numerical integration 
% Code for Persistent Component GARCH Model
% S_t = d vector of spot stock prices
% K = d vector of Strike Prices
% tau = d vector of time to maturity
% h_t = d vector of variance processes
function [c] = cPrice_PCGARCH_IFT(S_t,K,h_t,rF,tau,param)

t_Hk = @(u)imag(CF_PCGARCH(u-1i,S_t,h_t,tau,param).*exp(-1i.*u.*log(K))./(1i*u+1))./u;

c = 0.5*S_t + exp(-rF*tau)/pi.*integral(t_Hk,0,1000,'ArrayValued',true);

% u is a N-column vector
% tau is a d-column vector of maturities
% Output is N by d matrix
function [Psi] = CF_PCGARCH(u,S_t,h_t,tau,param)

rF = 0.05/365;

h_tSC = h_t(:,1); % Spot short-run component
h_tLC = h_t(:,2); % Spot long-run component

u1 = 1i*u;
N = numel(u);
T = max(tau);
AMat1 = zeros(N,T);
B1Mat1 = zeros(N,T);
B2Mat1 = zeros(N,T);

alpha = param(1);   beta = param(2);    gamma_1 = param(3);    gamma_2 = param(4);     
omega = param(5);   phi = param(6);

% A and B and time T-1
AMat1(:,1) = u1*rF;
B1Mat1(:,1) = -0.5*u1 + 0.5*u1.^2;
B2Mat1(:,1) = -0.5*u1 + 0.5*u1.^2;

% Recursion back to time t
for t = 2:T
    AMat1(:,t) = AMat1(:,t-1) + u1*rF - (alpha*B1Mat1(:,t-1) + phi*B2Mat1(:,t-1)) - 0.5*log(1-2*alpha*B1Mat1(:,t-1)-2*phi*B2Mat1(:,t-1)) + B2Mat1(:,t-1)*omega;
    B1Mat1(:,t) = beta*B1Mat1(:,t-1) - 0.5*u1 + (2*(alpha*gamma_1*B1Mat1(:,t-1) + phi*gamma_2*B2Mat1(:,t-1) - 0.5*u1).^2)./(1 - 2*alpha*B1Mat1(:,t-1) - 2*phi*B2Mat1(:,t-1));
    B2Mat1(:,t) = B2Mat1(:,t-1) - 0.5*u1 + (2*(alpha*gamma_1*B1Mat1(:,t-1) + phi*gamma_2*B2Mat1(:,t-1) - 0.5*u1).^2)./(1 - 2*alpha*B1Mat1(:,t-1) - 2*phi*B2Mat1(:,t-1));
end

Psi = exp(log(S_t).*u1 + AMat1(:,tau) + B1Mat1(:,tau).*repmat(h_tSC',N,1) + B2Mat1(:,tau).*repmat(h_tLC',N,1)); 