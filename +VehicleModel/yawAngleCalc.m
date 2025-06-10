%% Calculate heading from yaw rate
yawAngle = zeros([numel(obj.data(1).lapData.tLap), 1]);

yawRate = obj.data(1).lapData.steerAngle  .* -1.5;

% yawAngle = cumsum(yawRate) * 0.01;

%%

for i = 2:numel(yawAngle)

    yawAngle(i,1) = 0.5*0.01*(obj.data(2).lapData.steerAngle(i) + obj.data(2).lapData.steerAngle(i-1))*225*-1.5;


end

%% Forward Euler Integration
for i = 2:numel(yawAngle)

    % yawAngle(i,1) = yawAngle(i-1) + yawRate(i-1) * 0.01;
    
    yawAngle(i,1) = yawAngle(i-1) + yawRate(i-1) * 0.01;


end

%%
dX = [0; diff(obj.data(1).lapData.posX)];
dY = [0; diff(obj.data(1).lapData.posY)];
thetaV = atan2(dY, dX);

%%
figure;
scatter(obj.data(1).lapData.posX, obj.data(1).lapData.posY);
hold on
for i = 1:numel(yawAngle)
xN(i) = obj.data(1).lapData.posX(i) + 40 * cos(thetaV(i)) * 0.01;
yN(i) = obj.data(1).lapData.posY(i) + 40 * sin(thetaV(i)) * 0.01;
end
scatter(xN, yN)
axis equal
