function plot_data(deflection, extension, F_act, CL, CD, CM, F_x_stab, F_y_stab, M_stab, Re_high, Re_low)

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
plot(deflection, F_act(1, :), 'black', LineStyle = '-', LineWidth=2);
hold on
plot(deflection, F_act(2, :), 'black', LineStyle = '--', LineWidth=2);
ylabel('Force on the Actuator (Newtons)');
xlabel('Deflection (degrees)');
xlim([min(deflection) max(deflection)])
legend(sprintf('Re = %.2E', Re_high), sprintf('Re = %.2E', Re_low), Location='best')
title('Force on the Actuator vs Deflection Relation');
grid on;

% 2.2 Save the figure

save_path = fullfile(script_dir, '..', 'Report', 'Media', 'Force_on_Actuator.png');

exportgraphics(gcf, save_path);

% 3.1 Plotting
figure('Name', 'Aerodynamic Coefficients')
yyaxis left
plot(deflection, CL(1, :), 'black', LineStyle="-", LineWidth=2);
hold on
plot(deflection, CL(2, :), 'black', LineStyle="--", LineWidth=2);
ylabel('C_L');
yyaxis right
plot(deflection, CD(1, :), LineStyle="-", Color=[1, 0.5, 0], LineWidth=2);
plot(deflection, CD(2, :), LineStyle="--", Color=[1, 0.5, 0], LineWidth=2);
plot(deflection, CM(1, :), 'red', LineStyle="-", LineWidth=2);
plot(deflection, CM(2, :), 'red', LineStyle="--", LineWidth=2);
ylabel('C_D and C_M');
xlabel('Deflection (degrees)');
xlim([min(deflection) max(deflection)])
legend(sprintf('C_L (Re = %.2E)', Re_high), sprintf('C_L (Re = %.2E)', Re_low), ...
    sprintf('C_D (Re = %.2E)', Re_high), sprintf('C_D (Re = %.2E)', Re_low), ...
    sprintf('C_M (Re = %.2E)', Re_high), sprintf('C_M (Re = %.2E)', Re_low), ...
    Location='northwest')
title('Aerodynamic Coefficients vs Deflection Relation');
grid on;

% 3.2 Save the figure

save_path = fullfile(script_dir, '..', 'Report', 'Media', 'Aerodynamic_coefficients.png');

exportgraphics(gcf, save_path);

% 4.1 Plotting
figure('Name', 'External Loads')
yyaxis left
plot(deflection, F_y_stab(1, :), 'black', LineStyle="-", LineWidth=2);
hold on
plot(deflection, F_y_stab(2, :), 'black', LineStyle="--", LineWidth=2);
ylabel('C_L');
yyaxis right
plot(deflection, F_x_stab(1, :), LineStyle="-", Color=[1, 0.5, 0], LineWidth=2);
plot(deflection, F_x_stab(2, :), LineStyle="--", Color=[1, 0.5, 0], LineWidth=2);
plot(deflection, M_stab(1, :), 'red', LineStyle="-", LineWidth=2);
plot(deflection, M_stab(2, :), 'red', LineStyle="--", LineWidth=2);
ylabel('C_D and C_M');
xlabel('Deflection (degrees)');
xlim([min(deflection) max(deflection)])
legend(sprintf('F_y (Re = %.2E)', Re_high), sprintf('F_y (Re = %.2E)', Re_low), ...
    sprintf('F_x (Re = %.2E)', Re_high), sprintf('F_x (Re = %.2E)', Re_low), ...
    sprintf('M (Re = %.2E)', Re_high), sprintf('M (Re = %.2E)', Re_low), ...
    Location='south')
title('External Loads vs Deflection Relation');
grid on;

% 4.2 Save the figure

save_path = fullfile(script_dir, '..', 'Report', 'Media', 'External_Loads.png');

exportgraphics(gcf, save_path);