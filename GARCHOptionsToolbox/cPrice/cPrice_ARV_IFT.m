% Computes the call option price using quadl numerical integration
% Sample code for ARV Model
% S_t = d vector of spot stock prices
% K = d vector of Strike Prices
% tau = d vector of time to maturity
% h_t = d by 2 matrix of variance processes
function [c] = cPrice_ARV_IFT(S_t,K,h_t,rF,tau,param)

t_Hk = @(u)imag(CF_ARV(u-1i,S_t,h_t,tau,param).*exp(-1i.*u.*log(K))./(1i*u+1))./u;

c = 0.5*S_t + exp(-rF*tau)/pi.*integral(t_Hk,0,1000,'ArrayValued',true);

% u is a N-column vector
% tau is a d-column vector of maturities
% Output is N by d matrix
function [Psi] = CF_ARV(u,S_t,h_t,tau,param)

u1 = 1i*u;
N = numel(u);
T = max(tau);
C2Mat1 = zeros(N,T);
DMat1 = zeros(N,T);

% C and D for maturity 1
[C2Mat1(:,1) DMat1(:,1)] = A12B(u1,zeros(N,1),param);

% Recursion up to M
for t = 2:T
    [C2Mat1(:,t) DMat1(:,t)] = A12B(u1,C2Mat1(:,t-1),param);
    DMat1(:,t) = DMat1(:,t) + DMat1(:,t-1);
end

Psi = exp(log(S_t).*u1 + C2Mat1(:,tau).*repmat(h_t',N,1) + DMat1(:,tau)); 

% u,w_R,w_RV are N-column vectors
function [A2 B] = A12B(u,w_RV,param)

% Set rF = 0.05/365 for the ease of computation
rF = 0.05/365;

alpha_2 = param(1);    beta_2 = param(2);   gamma_2 = param(3);
rho = param(4);        h_0 = param(5);

omega_2 = (1-(beta_2+alpha_2*gamma_2^2))*h_0-alpha_2;

w_2 = w_RV*alpha_2;

a = (w_2*rho^2)./(1-2*w_2*(1-rho^2));
b = u - (2*rho*gamma_2*w_2)./(1-2*w_2*(1-rho^2));
c = ((gamma_2^2)*w_2)./(1-2*w_2*(1-rho^2));

A2 = c + (b.^2)./(2*(1-2*a)) - 0.5*u + w_RV*beta_2;
B  = -0.5*log(1-2*w_2*(1-rho^2)) - 0.5*log(1-2*a) + u*rF + w_RV*omega_2;