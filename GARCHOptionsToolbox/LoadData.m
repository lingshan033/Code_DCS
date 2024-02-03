% Plots the difference between GARCH option models and Black-Scholes price as a function of spot stock price.
% 1. Default model parameters of each model are taken directly from published version of each paper.
% 2. Unconditional mean of volatility is fixed to be comparable to Black-Scholes implied volatility level.
% 3. Risk-free rate is fixed at 5% for annum.
% 4. Option maturity is fixed at 60 days.
% 5. Strike price is fixed at 100.
clc; clear all;
addpath('cPrice')
addpath('Util')
addpath('Parameters')

% Set default option terms
rFree = 0.05/365; % Annual risk-free rate is fixed at 5%
tau = 60; % Time to Maturity
BSvol = 0.21; % Black-Scholes implied volatility
S = [81:0.5:120]'; % Spot stock price
K = 100*ones(numel(S),1); % Strike price vector

% Load model parameters from published paper
load param_GARCH_Opt

callPrice_BS = blsprice(S,K,rFree*365,tau/365,BSvol); % Black-Scholes Call option price