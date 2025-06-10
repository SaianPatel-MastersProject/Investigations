%% Closest LA Point Check

matFilePath = "D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP03_24\2025_FYP03_24_D4_R02.mat";

load(matFilePath)

%% Using (0,0) as the reference point, find the distance of the car

% Get final position
posFinal = [runStruct.data.posX(end), runStruct.data.posY(end)];
xFinal = posFinal(1);
yFinal = posFinal(2);

% Calculate distance to (0,0)
d = sqrt(xFinal^2 + yFinal^2);