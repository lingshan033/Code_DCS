% Computes the call option price using quadl numerical integration
% Sample code for DCS Model
% S_t = d vector of spot stock prices
% K = d vector of Strike Prices
% tau = d vector of time to maturity
% hs_t = d by 2 matrix of variance process and skewness process
function [c] = cPrice_DCS_IFT(S_t,K,hs_t,rF,tau,param)

t_Hk = @(v_1)imag(CF_DCS(v_1-1i,S_t,hs_t,tau,param).*exp(-1i.*v_1.*log(K))./(1i*v_1+1))./v_1;

c = 0.5*S_t + exp(-rF*tau)/pi.*integral(t_Hk,0.01,1000,'ArrayValued',true);

% v_1 is a N-column vector
% tau is a d-column vector of maturities
% Output is N by d matrix
function [Psi] = CF_DCS(v_1,S_t,hs_t,tau,param)

u1 = 1i*v_1;
h_t  = hs_t(:,1);
s_t = hs_t(:,2);
N = numel(v_1);
T = max(tau);
C1Mat1 = zeros(N,T);
C2Mat1 = zeros(N,T);
DMat1 = zeros(N,T);

% C and D for maturity 1
[C1Mat1(:,1) C2Mat1(:,1) DMat1(:,1)] = A12B(u1,zeros(N,1),zeros(N,1),param);

% Recursion up to M
for t = 2:T
    [C1Mat1(:,t) C2Mat1(:,t) DMat1(:,t)] = A12B(u1,C1Mat1(:,t-1),C2Mat1(:,t-1),param);
    DMat1(:,t) = DMat1(:,t) + DMat1(:,t-1);
end

Psi = exp(log(S_t).*u1 + C1Mat1(:,tau).*repmat(h_t',N,1) + C2Mat1(:,tau).*repmat(s_t',N,1) + DMat1(:,tau)); 

% v_1,v_2,v_3 are N-column vectors
function [A1 A2 B] = A12B(v_1,v_2,v_3,param)

% Set rF = 0.05/365 for the ease of computation
rF = 0.05/365;

% paraQ = [eta_1_Q,omega,beta,alpha,gamma_Q,rho,w_Q,b,c_Q,xi_Q];
eta_1 = param(1);
omega = param(2);
beta = param(3);
alpha = param(4);
gamma = param(5);
rho = param(6);
w = param(7);
b = param(8);
c = param(9);
xi_Q = param(10);

m1 = v_2*alpha*rho^2./(1-2*v_2*alpha*(1-rho^2));
m2 = v_1-2*rho*gamma*v_2*alpha./(1-2*v_2*alpha*(1-rho^2));
m3 = gamma^2*v_2*alpha./(1-2*v_2*alpha*(1-rho^2));

A1 = -v_1*1/2 + v_2*beta + m3 + m2^2/2/(1-2*m1);
A2 = -v_1*xi_Q + v_3*b + 2 - sqrt(1-2*v_1*eta_1) - sqrt(1-2*v_3*c);
B  = v_1*rF + v_2*omega + v_3*w -1/2*log(1-2*v_2*alpha*(1-rho^2))-1/2*log(1-2*m1);