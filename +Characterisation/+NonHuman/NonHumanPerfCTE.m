%% CTE Performance - Compare Humans to a Non-Human Reference


%% Load Raw Runs & Laps
obj = Plotting.multiPlotter();

obj = obj.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP02_03\2025_FYP02_03_D1_R02.mat', true, [2:31]); % SP
obj = obj.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP03_31\2025_FYP03_31_D5_R08.mat', true, [1:21]); % BX
obj = obj.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP03_31\2025_FYP03_31_D5_R05.mat', true, [2:20]); % LZ
obj = obj.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP04_14\2025_FYP04_14_D5_R02.mat', true, [2:4]); % PID

obj = obj.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP02_03\2025_FYP02_03_D1_R02.mat', 31); % SP
obj = obj.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP03_31\2025_FYP03_31_D5_R08.mat', 21); % BX
obj = obj.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP03_31\2025_FYP03_31_D5_R05.mat', 20); % LZ
obj = obj.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP04_14\2025_FYP04_14_D5_R02.mat', 4); % PID

obj.plottingTools.legendCell = {'Driver A', 'Driver B', 'Driver C', 'PID'};

metricsComp = obj.fnMetricsComparison(1, [2, 3, 4]);

%% Load Average Laps
objAvg = Plotting.multiPlotter();

objAvg = objAvg.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP02_03\2025_FYP02_03_D1_R02_AvgLap.mat', true, []); % SP
objAvg = objAvg.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP03_31\2025_FYP03_31_D5_R08_AvgLap.mat', true, []); % BX
objAvg = objAvg.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP03_31\2025_FYP03_31_D5_R05_AvgLap.mat', true, []); % LZ
objAvg = objAvg.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP04_14\2025_FYP04_14_D5_R02.mat', true, [2:4]); % PID

objAvg = objAvg.addAverageLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP02_03\2025_FYP02_03_D1_R02_AvgLap.mat'); % SP
objAvg = objAvg.addAverageLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP03_31\2025_FYP03_31_D5_R08_AvgLap.mat'); % BX
objAvg = objAvg.addAverageLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP03_31\2025_FYP03_31_D5_R05_AvgLap.mat'); % LZ
objAvg = objAvg.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP04_14\2025_FYP04_14_D5_R02.mat', 4); % PID

objAvg.plottingTools.legendCell = {'Driver A', 'Driver B', 'Driver C', 'PID'};

metricsCompAvg = objAvg.fnMetricsComparison(1, [2, 3, 4]);

%% CTE Triplet Plots
figure('Name', 'CTE Triplet Bar Plot')
cteTriplet = metricsComp(1).avgMetricsVals(12:14, 2);
cteTripletArray = (table2array(cteTriplet))';
b = bar(obj.plottingTools.legendCell, cteTripletArray, 'stacked', 'FaceColor', 'flat');
xlabel('Driver')
ylabel('Percentage (%)')
ylim([0, 100])
legend('Reducing CTE', 'Worsening CTE', 'Held CTE');
b(1,1).CData = [0, 1, 0];
b(1,2).CData = [1, 0, 0];
b(1,3).CData = [0, 0, 1];

%% Scatter Plots
figure('Name', 'CTE Triplet Scatter')
hold on

for i = 1:size(obj.runData, 2)

    x = obj.runData(i).metricsCTE.rCTE_pct;
    y = obj.runData(i).metricsCTE.wCTE_pct;
    z = obj.runData(i).metricsCTE.hCTE_pct;
    scatter3(x, y, z, 6, 'filled')
    xlabel('Reducing CTE');
    ylabel('Worsening CTE');
    zlabel('Held CTE');
    grid on;
    grid minor;



end


%% CTE Triplet Plots Avg
figure('Name', 'CTE Triplet Bar Plot (AVG)')
cteTriplet = metricsCompAvg(1).avgMetricsVals(12:14, 2);
cteTripletArray = (table2array(cteTriplet))';
b = bar(obj.plottingTools.legendCell, cteTripletArray, 'stacked', 'FaceColor', 'flat');
xlabel('Driver')
ylabel('Percentage (%)')
ylim([0, 100])
legend('Reducing CTE', 'Worsening CTE', 'Held CTE');
b(1,1).CData = [0, 1, 0];
b(1,2).CData = [1, 0, 0];
b(1,3).CData = [0, 0, 1];

%% Scatter Plots
figure('Name', 'CTE Triplet Scatter (AVG)')
hold on

for i = 1:size(objAvg.runData, 2)

    x = objAvg.runData(i).metricsCTE.rCTE_pct;
    y = objAvg.runData(i).metricsCTE.wCTE_pct;
    z = objAvg.runData(i).metricsCTE.hCTE_pct;
    scatter3(x, y, z, 36, 'filled')
    xlabel('Reducing CTE');
    ylabel('Worsening CTE');
    zlabel('Held CTE');
    grid on;
    grid minor;



end