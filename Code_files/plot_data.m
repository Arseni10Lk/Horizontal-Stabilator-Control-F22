function plot_data(deflection, extension, F_act, CL, CD, CM, F_x_stab, ...
    F_y_stab, M_stab, Re_high, Re_low, velocity, max_controlled_deflection, min_controlled_deflection, ...
    max_allowed_deflection, min_allowed_deflection)

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
plot(deflection, F_act(end, :), 'black', LineStyle = '--', LineWidth=2);
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
plot(deflection, CL(end, :), 'black', LineStyle="--", LineWidth=2);
ylabel('C_L');
yyaxis right
plot(deflection, CD(1, :), LineStyle="-", Color=[1, 0.5, 0], LineWidth=2);
plot(deflection, CD(end, :), LineStyle="--", Color=[1, 0.5, 0], LineWidth=2);
plot(deflection, CM(1, :), 'red', LineStyle="-", LineWidth=2);
plot(deflection, CM(end, :), 'red', LineStyle="--", LineWidth=2);
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
plot(deflection, F_y_stab(end, :), 'black', LineStyle="--", LineWidth=2);
ylabel('N');
plot(deflection, F_x_stab(1, :), LineStyle="-", Color='blue', LineWidth=2);
plot(deflection, F_x_stab(end, :), LineStyle="--", Color='blue', LineWidth=2);
yyaxis right
plot(deflection, M_stab(1, :), 'red', LineStyle="-", LineWidth=2);
plot(deflection, M_stab(end, :), 'red', LineStyle="--", LineWidth=2);
ylabel('Nm');
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

% 5.1 3D Plotting now

figure('Name', 'Actuator Loads')
surf(velocity, deflection, F_act', EdgeAlpha=0.01)
set(gca, 'XDir', 'reverse', 'YDir', 'reverse')
xlabel('Velocity [m/s]');
ylabel('Deflection [deg]');
zlabel('Actuator Load [N]');
title('Actuator Load as a function of velocity and deflection');
ylim([deflection(1) deflection(end)])
xlim([velocity(1) velocity(end)])
colorbar
grid on;

% 5.2 Save the 3D plot figure
save_path = fullfile(script_dir, '..', 'Report', 'Media', 'Actuator_Loads_3D.png');
exportgraphics(gcf, save_path);

% 6.1 Blowdown limits

figure('Name', 'Blowdown Limits');

X_fill = [velocity; flipud(velocity)];
Y_allowed = [max_allowed_deflection; flipud(min_allowed_deflection)];
Y_possible = [max_controlled_deflection; flipud(min_controlled_deflection)];

hp = fill(X_fill, Y_possible, [0.941, 0.922, 0.506], 'EdgeColor', 'none');
hold on;
ha = fill(X_fill, Y_allowed, [0.6, 1, 0.522], 'EdgeColor', 'none');
plot(velocity, max_allowed_deflection, 'k', 'LineWidth', 2);
plot(velocity, min_allowed_deflection, 'k', 'LineWidth', 2);
plot(velocity, max_controlled_deflection, 'k', LineWidth=2);
plot(velocity, min_controlled_deflection, 'k', LineWidth=2);
yline(30, '--k', 'Upper Structural Limit (30^\circ)', ...
    LabelHorizontalAlignment='center', LabelVerticalAlignment='top');
yline(-25, '--k', 'Lower Structural Limit (-25^\circ)', ...
    LabelHorizontalAlignment='center', LabelVerticalAlignment='bottom');
grid on;
xlabel('Velocity [m/s]');
ylabel('Allowed Deflection [\circ]');
title('F-22 Stabilator Blowdown Limits Envelope');
legend([ha hp], 'Allowed deflection', 'Controlled deflection', 'Location', 'west');
ylim([-30 35]);
xlim([min(velocity) max(velocity)])

% 6.2 Save blowdown limits
save_path = fullfile(script_dir, '..', 'Report', 'Media', 'Blowdown_limits.png');
exportgraphics(gcf, save_path);