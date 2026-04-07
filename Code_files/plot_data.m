function plot_data(deflection, extension, F_act, CL, CD, CM) 

% 1.1 Plotting
figure('Name', 'Actuator vs Deflection Relation')
plot(extension*100, deflection, 'black', LineWidth=2);
ylabel('Deflection (degrees)');
xlabel('Actuator Extension (cm)');
xlim([min(extension*100) max(extension*100)])
title('Deflection vs. Actuator Extension');
grid on;

% 1.2 Save the figure

script_dir = fileparts(mfilename('fullpath'));

% Build the relative path to the Media folder
save_path = fullfile(script_dir, '..', 'Report', 'Media', 'Actuator_Deflection.png');

exportgraphics(gcf, save_path);

% 2.1 Plotting
figure('Name', 'Force on the Actuator vs Deflection Relation')
plot(deflection, F_act, 'black', LineWidth=2);
ylabel('Force on the Actuator (Newtons)');
xlabel('Deflection (degrees)');
xlim([min(deflection) max(deflection)])
title('Force on the Actuator vs Deflection Relation');
grid on;

% 2.2 Save the figure

save_path = fullfile(script_dir, '..', 'Report', 'Media', 'Force_on_Actuator.png');

exportgraphics(gcf, save_path);

% 3.1 Plotting
figure('Name', 'Aerodynamic Coefficients')
yyaxis left
plot(deflection, CL, 'black', LineWidth=2);
ylabel('C_L');
hold on
yyaxis right
plot(deflection, CD, LineStyle="-", LineWidth=2);
plot(deflection, CM, 'red', LineStyle="-", LineWidth=2);
ylabel('C_D and C_M');
xlabel('Deflection (degrees)');
xlim([min(deflection) max(deflection)])
legend('CL', 'CD', 'CM')
title('Aerodynamic Coefficients vs Deflection Relation');
grid on;

% 3.2 Save the figure

save_path = fullfile(script_dir, '..', 'Report', 'Media', 'Aerodynamic_coefficients.png');

exportgraphics(gcf, save_path);