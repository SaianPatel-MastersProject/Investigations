%% Investigating LA Curvature for a Fixed LA Point

%% Read in AIW Data
AIW_Table = Utilities.fnLoadAIW('INT');
AIW_Data = [AIW_Table.x, AIW_Table.y];

% Get the curvature, kappa
[kappa, ~] = PostProcessing.PE.fnCalculateCurvature([AIW_Table.x, AIW_Table.y]);

spacing = 0.1;
method = 'spline';

xInterp = Utilities.fnInterpolateByDist(AIW_Data, AIW_Table.x, spacing, method);
yInterp = Utilities.fnInterpolateByDist(AIW_Data, AIW_Table.y, spacing, method);
kappaInterp = Utilities.fnInterpolateByDist(AIW_Data, kappa, spacing, method);

AIW_Data = [xInterp, yInterp];

%% Discretise the curvature into n Segments
maxKappa = max(abs(kappaInterp));
nSegments = 5;
kappaSegments = linspace(0, maxKappa, nSegments+1);
%% Read in run data

obj = Plotting.multiPlotter();

%% SUZ
% obj = obj.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP02_10\2025_FYP02_10_D1_R02.mat', true, [2:4]);
% obj = obj.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP02_03\2025_FYP02_03_D1_R02.mat', true, [2:31]);

%% INT
obj = obj.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP03_24\2025_FYP03_24_D4_R05', true, []);
obj = obj.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP03_24\2025_FYP03_24_D4_R06', true, []);

%% Set the run of interest
runData = obj.runData(2).runData;

closestWaypoints = zeros([size(runData, 1), 1]);

for i = 1:size(runData,1)

    xV = runData.posX(i);
    yV = runData.posY(i);

    % Find nearest AIW waypoint using Euclidean distance
    d = sqrt((AIW_Data(:,1) - xV).^2 + (AIW_Data(:,2) -yV).^2);
    [~, closestWaypointIdx] = min(d);
    closestWaypoints(i,1) = closestWaypointIdx;

end

%% Shuffle curvature and check alignment of Steering Angle with Curvature
lookAheadDistances = (0:1:60)';
nLookAheadDistances = numel(lookAheadDistances);
correlations = zeros([nLookAheadDistances, 4]);
correlations(:,1) = lookAheadDistances;
for k = 1:length(kappaSegments) - 1

    % Get the segment data
    segmentIdx = and(abs(runData.kappa) >= kappaSegments(k), abs(runData.kappa) < kappaSegments(k+1));
    segmentData = runData(segmentIdx, :);
    segmentWaypoints = closestWaypoints(segmentIdx);

    
    for i = 1:nLookAheadDistances
    
        lookAheadKappa = zeros([size(segmentData,1), 1]);
    
        for j = 1:size(segmentData,1)
    
            % Look Ahead in Kappa
            lookAheadKappa(j) = Utilities.fnGetLookAheadValues(kappaInterp, segmentWaypoints(j), lookAheadDistances(i)/0.1, 1);
    
        end
    
        
    
        correlations(i,k+1) = corr((segmentData.steerAngle), -(lookAheadKappa));
    end
end

%% Plotting
figure;
grid on;
grid minor;
hold on;
legendCell = {};

for i = 1:nSegments

    plot(correlations(:,1), correlations(:, i + 1))
    legendCell{i,1} = sprintf('Segment %i', i);

end

legend(legendCell);