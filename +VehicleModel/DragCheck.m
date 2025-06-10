%% Drag Check

%% Set Parameters
rho = 1.19;
CDA = 0.66;
m = 200;

aT_Gain = 1;
aB_Gain = 3;

%% Simulate Drag

% Apply 100% (1) throttle for n time steps
nSteps = 1000;
stepSize = 0.1;
rThrottle = ones([nSteps, 1]);
vCar = zeros([nSteps, 1]);
accel = zeros([nSteps, 3]);

aT = fnThrottleAccel(aT_Gain);

for i = 2:nSteps

    aD = fnDragCalc(rho, CDA, m, vCar(i-1));
    accel(i, 1:2) = [aT, aD];
    accel(i, 3) = aT + aD;
    vCar(i) = vCar(i-1) + (aT + aD)*stepSize;


end

%% Plot Results
figure;
subplot(2,1,1)
grid on;
grid minor;
plot(vCar)
xlabel('nPoints')
ylabel('vCar (m/s)')

subplot(2,1,2)
grid on;
grid minor;
hold on
plot(accel(:,3))
plot(accel(:,1))
plot(accel(:,2))
xlabel('nPoints')
ylabel('Acceleration (m/s^2)')
legend({'a', 'aT', 'aD'})

%% Functions for pedal accelerations
function aT = fnThrottleAccel(aT_Gain)

    aT = aT_Gain * 10;

end

function aB = fnBrakeAccel(aB_Gain)

    aB = aB_Gain * 10;

end

%% Function for drag
function aD = fnDragCalc(rho, CDA, m, v)

    aD = 0.5 * rho * v^2 * CDA * (1/m);
    aD = -aD;



end