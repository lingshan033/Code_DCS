%% Figure 3. Return Histogram and Innovation Densities

clear;
clc;
close all;

% load Return and Realized Components
load ./Data/date20070501_20220507_r_RS_RV.mat
r = series_20070501_20220507.r * 100;
RV = series_20070501_20220507.RV * 100;
RS = series_20070501_20220507.RS * 100;

figure(1)
nbins = 80;
min_r = min(r);
max_r = max(r);
edges = linspace(min_r, max_r, nbins+1);
[counts, ~] = histcounts(r, edges);
counts = counts/numel(r);
centerBins = (edges(1:end-1) + edges(2:end)) / 2;
bar(centerBins, counts, 'FaceColor', [0.7, 0.7, 0.7], 'EdgeColor', [0.7, 0.7, 0.7], 'FaceAlpha',0.3);
hold on;

% Plot Normal Distribution
mu = mean(r);
sigma = std(r);
f = @(x) exp(-(x-mu).^2/(2*sigma^2)) / (sigma*sqrt(2*pi));
normal_x_values = linspace(min_r, max_r, 1000);
normal_y_values = f(normal_x_values) * (max_r-min_r) / nbins;
plot(normal_x_values, normal_y_values, 'Color', 'k', 'LineWidth', 2, 'LineStyle','--');

% Plot Inverse Gaussian Distribution
alpha = -skewness(r);
z_min = -3 / alpha;
g = @(z, alpha) (1/sqrt(2*pi)) * (3./(3 + alpha * z)).^(3/2) .* exp(-3 * z.^2 ./ (2*(3 + alpha * z)));
IG_x_values = linspace(z_min, max(r), 1000);
IG_y_values = g(-IG_x_values, alpha) * (max_r-min_r) / nbins;
plot(IG_x_values, IG_y_values, 'Color', 'k', 'LineWidth', 2, 'LineStyle',':');

% Plot Sum of Normal Distribution and Inverse Gaussian Distribution
Normal = @(z) exp(-(z).^2/(2*sigma)) / (sqrt(sigma)*sqrt(2*pi));
eta = -skewness(r);
alpha = 1; % SIG
f = @(z) (Normal(z) +eta* g(-z, alpha)) * (max_r-min_r) / nbins;
z_min = -3 / alpha;
z_range = linspace(z_min, max(r), 1000);
plot(z_range,f(z_range),'Color','k','LineWidth',3);

legend('Data','$\mathcal{N}$','$IG$','$\mathcal{N}+IG$','Interpreter','latex','Fontsize',15);
xlabel('Return (\%)','Interpreter','latex','FontSize',15);
ylabel('Densities','Interpreter','latex','FontSize',15);
xlim([-6, 6]);
ylim([0 0.17])