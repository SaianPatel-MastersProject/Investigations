%% De-Quantize steering

%% Interpolation
dt = 0.01;
dtNew = 0.005;

nEntries = size(obj.data(1).lapData.steerAngle, 1);

tNew = (0:dtNew:(nEntries-1)*dt)';

% Re-interpolate steering
steeringInterp = interp1(obj.data(1).lapData.tLap, obj.data(1).lapData.steerAngle, tNew);

%% Plot
figure;
grid on;
grid minor;
hold on
xlabel('time')
ylabel('steer angle')
plot(obj.data(1).lapData.tLap, obj.data(1).lapData.steerAngle.*225);
plot(tNew, steeringInterp .*225)
plot(obj.data(1).lapData.tLap, movmean(obj.data(1).lapData.steerAngle.*225, 5));
plot(obj.data(2).lapData.tLap, obj.data(2).lapData.steerAngle.*225);

%% Scatter
figure;
dSteerHuman = [0; diff(obj.data(1).lapData.steerAngle.*225)] ./ 0.01;
derivsHuman = unique(round(dSteerHuman));

dSteerFFNN = [0; diff(obj.data(2).lapData.steerAngle.*225)] ./ 0.01;
derivsFFNN = unique(round(dSteerFFNN));