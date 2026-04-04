function plot_data(deflection, extension, F_act) 

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

% 5. Plotting
figure('Name', 'Force on the Actuator vs Deflection Relation')
plot(deflection, F_act, 'black', LineWidth=2);
ylabel('Force on the Actuator (Newtons)');
xlabel('Deflection (degrees)');
xlim([min(deflection) max(deflection)])
title('Force on the Actuator vs Deflection Relation');
grid on;

% 6. Save the figure

save_path = fullfile(script_dir, '..', 'Report', 'Media', 'Force_on_Actuator.png');

exportgraphics(gcf, save_path);