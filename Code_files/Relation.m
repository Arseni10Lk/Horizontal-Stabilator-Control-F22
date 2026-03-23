% 1. Providing the required data

d = 0.5; % m
a = 0.7; % m

% 2. Calculating stuff

alpha = rad2deg(asin(d/a));
r = sqrt(a^2 - d^2);

% 3. Defining deflection limits

deflection_min = 25; % deg
deflection_max = -30; % deg
deflection = deflection_max:0.01:deflection_min;

% 4. Finding corresponding actuator extension

extension = sqrt(a^2 + r^2 - 2.*a.*r.*cos(deg2rad(alpha+deflection))) - d;

% 5. Plotting

figure('Name', 'Actuator vs Deflection Relation')
plot(extension, deflection, 'black', LineWidth=2);
ylabel('Deflection (degrees)');
xlabel('Actuator Extension (m)');
xlim([min(extension) max(extension)])
title('Deflection vs. Actuator Extension');
grid on;