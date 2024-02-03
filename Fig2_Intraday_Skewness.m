%% Figure 2. Intraday Pattern of Cumulative Realized Skewness: A Decline Followed by Recovery

clear;
clc;
close all;

% Calculate total number of intervals from 9:30 to 16:00
intervalMinutes = 1;  % Interval in minutes
totalIntervals = floor((16*60 - 9.5*60) / intervalMinutes);

% Load data
dataPath = "D:\Folder_of_the_Project\data\primary_data\SPX_1min.txt";
data = readmatrix(dataPath, 'OutputType', 'string');
data = data(:, 1:5);

tickTimes = split(data(:, 1), {' ', '-', ':'});
tickTimes = str2double(join(tickTimes, ''));
prices = str2double(data(:, 5));
priceMatrix = [tickTimes, prices];
priceMatrix = priceMatrix((priceMatrix(:, 1) <= 160000) & (priceMatrix(:, 1) >= 93000), :);
tradingDates = unique(priceMatrix(:, 1), 'rows');

% Initialize variables for cumulative calculations
cumulativeReturns = zeros(totalIntervals, 1);
cumulativeRVU = zeros(totalIntervals, 1);
cumulativeRVD = zeros(totalIntervals, 1);
cumulativeRS = zeros(totalIntervals, 1);
cumulativeCumsumRS = zeros(totalIntervals, 1);
countValidDays = 0;

for currentDate = tradingDates'
    dayPrices = priceMatrix(priceMatrix(:, 1) == currentDate, 2);
    
    if ~isempty(dayPrices)
        countValidDays = countValidDays + 1;
        dayReturns = diff(log(dayPrices));
        dayReturns(end + 1:totalIntervals) = 0;  % Pad day returns to match total intervals

        % Calculate RVU and RVD
        RVU = zeros(size(dayReturns));
        RVD = zeros(size(dayReturns));
        RVU(dayReturns >= 0) = dayReturns(dayReturns >= 0).^2;
        RVD(dayReturns < 0) = dayReturns(dayReturns < 0).^2;

        % Calculate RS and cumulative RS
        RS = RVU - RVD;
        cumsumRS = cumsum(RVD);

        % Update cumulative statistics
        cumulativeReturns = cumulativeReturns + dayReturns;
        cumulativeRVU = cumulativeRVU + [RVU; zeros(length(cumulativeRVU) - length(RVU), 1)];
        cumulativeRVD = cumulativeRVD + [RVD; zeros(length(cumulativeRVD) - length(RVD), 1)];
        cumulativeRS = cumulativeRS + [RS; zeros(length(cumulativeRS) - length(RS), 1)];
        cumulativeCumsumRS = cumulativeCumsumRS + [cumsumRS; zeros(length(cumulativeCumsumRS) - length(cumsumRS), 1)];
    end
end

% Calculate averages
averageReturns = cumulativeReturns / countValidDays;
averageRVU = cumulativeRVU / countValidDays;
averageRVD = cumulativeRVD / countValidDays;
averageRS = cumulativeRS / countValidDays * totalIntervals * 252;
averageCumsumRS = cumulativeCumsumRS / countValidDays;

% Plotting
figure(1);
set(gcf, 'color', 'white');
hold on;

plot(0:length(averageReturns), [0; cumsum(averageRS)], 'k', 'LineWidth', 2.5);

timePoints = [93000, 100000, 103000, 110000, 113000, 120000, ...
              123000, 130000, 133000, 140000, 143000, 150000, 153000, 160000];
[~, timePointIndices] = ismember(timePoints, tickTimes);
timeTicks = find(timePointIndices ~= 0) - 1;

ylabel('Cumulative Realized Skewness', 'FontSize', 18, 'FontWeight', 'bold', 'Interpreter', 'latex');
xlabel('Time', 'FontSize', 18, 'FontWeight', 'bold', 'Interpreter', 'latex');
set(gca, 'XTick', tick);
set(gca, 'XTickLabel', {'9:30', '10:00', '10:30', '11:00', ...
    '11:30', '12:00', '12:30', '13:00', ...
    '13:30', '14:00', '14:30', '15:00', ...
    '15:30', '16:00'}, 'FontSize', 15);
