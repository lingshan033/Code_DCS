% Computes linear approximation of inverse GED CDF
% nu = degree of freedom of GED
function [b_nu] = linApproxGED(nu)

% Define grid of z values to be used
z = [-5.001:0.01:4.999];
zGEDInv = gedinv(normcdf(z),nu);

b_nu = mean(zGEDInv./z);

end