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

% Set max and min LA distances
dMin = 6;
dMax = 30;
Z_min = dMin;
Z_max = dMax;

% Define look-ahead distance function
k1 = 300;      % Controls decay due to absolute curvature
k2 = 2000;      % Controls decay when derivative is positive
k3 = 5000;    % Controls increase when derivative is negative
% Z = (dMax - dMin) ./ (1 + k1 * abs(X) + k2 * abs(Y)) + dMin;  % Look-ahead distance
% Z = dMin + (dMax - dMin) .* exp(- (k1 * X.^2 + k2 * Y.^2));
% Z = dMin + (dMax - dMin) .* exp(- (k1 * abs(X) - k2 * abs(Y)));
% Compute look-ahead distance
% Z = dMin + (dMax - dMin) .* exp(- (k1 * X + k2 * max(Y, 0))) .* (1 + k3 * min(Y, 0));
% Z = Z_min + (Z_max - Z_min) .* exp(- k1 * X) .* exp(- k2 * max(Y, 0)) .* (1 + k3 * min(Y, 0));
% Z = dMin + (dMax - dMin) ./ (1 + exp(200 * (X - 0.01))) .* exp(- k2 * max(Y, 0)) .* (1 + k3 * min(Y, 0));
% Compute look-ahead distance using sigmoid functions for both X and Y
Z = dMin + (dMax - dMin) ./ (1 + exp(200 * (X - 0.01))) ./ (1 + exp(2e5 * Y));

%%
a0 = -20;    % Base steepness of sigmoid
b = -5;      % Modulation factor for sigmoid steepness based on Y
% Compute the steepness factor based on Y
A = a0 + b * Y;

% Compute look-ahead distance using sigmoid function with modulated steepness
Z = dMin + (dMax - dMin) ./ (1 + exp(A .* (X - 0.01)));

%% Plot the surface
figure;
surf(X, Y, Z);
xlabel('Curvature (X)');
ylabel('Derivative of Absolute Curvature (Y)');
zlabel('Look-ahead Distance (Z)');
title('Look-ahead Distance Surface');
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
% LA = dMin + (dMax - dMin) .* exp(- (k1 * (kappaInterp).^2 + k2 * dKappa.^2));
% LA = dMin + (dMax - dMin) .* exp(- (k1 * abs(kappaInterp) + k2 * abs(dKappa)));
LA = dMin + (dMax - dMin) ./ (1 + exp(200 * (absKappa - 0.01))) ./ (1 + exp(2e5 * dKappa));

plot(LA)