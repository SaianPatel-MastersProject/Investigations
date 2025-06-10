%% Creating a surface for LA using kappa and dKappa
% We want LA distance to be low when: 1) Curvature is high, derivative of
% curvature is positive 2) Curvature is high, derivative of curvature is
% low.

% We want LA distance to be high when: 1) Curvature is low, derivative of
% curvature is small or 0, 2) Curvature is low, derivative of curvature is
% low.

%% Read in reference data
AIW_Table = Utilities.fnLoadAIW('SUZ');
AIW_Data = [AIW_Table.x, AIW_Table.y];

% Get the curvature, kappa
[kappa, ~] = PostProcessing.PE.fnCalculateCurvature([AIW_Table.x, AIW_Table.y]);


spacing = 0.1;
method = 'spline';

xInterp = Utilities.fnInterpolateByDist(AIW_Data, AIW_Table.x, spacing, method);
yInterp = Utilities.fnInterpolateByDist(AIW_Data, AIW_Table.y, spacing, method);
kappaInterp = Utilities.fnInterpolateByDist(AIW_Data, kappa, spacing, method);

AIW_Data = [xInterp, yInterp];

%% Get dKappa
absKappa = abs(kappaInterp);
dKappa = [0; diff(absKappa)];

%% Define the surface
x = linspace(0, max(absKappa), 100);
y = linspace(-max(abs(dKappa)), max(abs(dKappa)), 100);

% Create mesh grid
[X, Y] = meshgrid(x, y);

% Define parameters
dMin = 6;    % Minimum look-ahead distance (meters)
dMax = 30;   % Maximum look-ahead distance (meters)
X0 = 0.01;    % Sigmoid transition point
a = 200;     % Steepness of sigmoid function
c = 1e9;       % Quadratic coefficient for Y-Z relationship

% Compute look-ahead distance
Z = dMin + (dMax - dMin) ./ (1 + exp(a * (X - X0))) - c * Y.^2;

% Ensure look-ahead is bounded by dMin and dMax
Z = max(Z, dMin);
Z = min(Z, dMax);

%% Plot the surface
figure;
surf(X, Y, Z);
xlabel('Absolute Curvature (X)');
ylabel('Derivative of Absolute Curvature (Y)');
zlabel('Look-ahead Distance (Z)');
title('Look-ahead Distance with Sigmoid (X-Z) and Quadratic (Y-Z)');
colorbar;
shading interp;

%% Replay LA
figure;
subplot(4,1,1)
plot(kappaInterp)

subplot(4,1,2)
plot(absKappa)

subplot(4,1,3)
plot(dKappa)

subplot(4,1,4)
LA = dMin + (dMax - dMin) ./ (1 + exp(a * (absKappa - X0))) - c * dKappa.^2;

plot(LA)