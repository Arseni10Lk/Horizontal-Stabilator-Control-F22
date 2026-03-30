% 1. Providing the required data

d = 1.36124; % m
a = 1.37276; % m

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
plot(extension*100, deflection, 'black', LineWidth=2);
ylabel('Deflection (degrees)');
xlabel('Actuator Extension (cm)');
xlim([min(extension*100) max(extension*100)])
title('Deflection vs. Actuator Extension');
grid on;

% 6. Save the figure

script_dir = fileparts(mfilename('fullpath'));

% Build the relative path to the Media folder
save_path = fullfile(script_dir, '..', 'Report', 'Media', 'Actuator_Deflection.png');

exportgraphics(gcf, save_path);