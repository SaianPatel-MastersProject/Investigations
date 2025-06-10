%% Read in training data
trainingData = readtable("D:\Users\Saian\Workspace\NeuralNetworks\FFNN\Iteration66\TrainingData.csv", 'VariableNamingRule', 'preserve');

%% For each kappa, calculate steering angle if following the racing line perfectly
v = 40;
k = -1.5;

nPoints = size(trainingData.lookAhead1, 1);

perfectSteering = (trainingData.lookAhead1 .* v) ./ k;

%% Plot results
figure;
scatter(trainingData.steerAngle, trainingData.lookAhead1, '.', 'SizeData', 4, 'MarkerEdgeColor', 'b')
hold on
scatter(perfectSteering, trainingData.lookAhead1, '.', 'SizeData', 4, 'MarkerEdgeColor', 'r')

%% Plot 3D Scatter with derivative of absolute curvature
absKappa = abs(trainingData.curvature);
dKappa = [0; diff(absKappa)];

figure;
scatter3()


