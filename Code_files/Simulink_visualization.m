set(groot, 'defaultTextInterpreter', 'latex', ...
    'defaultAxesTickLabelInterpreter', 'latex', ...
    'defaultLegendInterpreter', 'latex');

time = ds.getElement(9).Values.Time;

% Deflection
d_real = ds.getElement(9).Values.Data;
d_des = ds.getElement(11).Values.Data;

% Pressures
p_A = ds.getElement(4).Values.Data;
p_B = ds.getElement(5).Values.Data;
p_aci = ds.getElement(3).Values.Data;

% Dynamics
t_volt = ds.getElement(8).Values.Time;
slew = ds.getElement(1).Values.Data;
volt = ds.getElement(8).Values.Data;

% Loads
loads = ds.getElement(10).Values.Data;

vel = ds.getElement(7).Values.Data;

% --- Figure 1: Deflection ---
figure('Name', 'Deflection Tracking', 'Color', 'w');
yyaxis left;
plot(time, d_des, 'k--', 'LineWidth', 1.5); hold on; grid on;
plot(time, d_real, 'b-', 'LineWidth', 1.5);
ylabel('Deflection [deg]');
ax = gca; ax.YColor = 'k'; 

yyaxis right;
plot(time, vel, 'r-', 'LineWidth', 1.2);
ylabel('Velocity [m/s]');
ax.YColor = 'r';

% Shared Elements
xlabel('Time [s]');
legend('Commanded Target', 'Actual Position', 'Velocity', 'Location', 'best');

script_dir = fileparts(mfilename('fullpath'));
save_path = fullfile(script_dir, '..', 'Report', 'Media', 'Deflection_Tracking_Simulink.png');
exportgraphics(gcf, save_path);

% --- Figure 2: Pressures ---
figure('Name', 'System Pressures', 'Color', 'w');
plot(time, p_A, 'r-', time, p_B, 'b-', time, p_aci, 'k--', 'LineWidth', 1.2);
grid on; xlabel('Time [s]'); ylabel('Pressure [Pa]');
legend('Chamber A', 'Chamber B', 'Accumulator', 'Location', 'best');

script_dir = fileparts(mfilename('fullpath'));
save_path = fullfile(script_dir, '..', 'Report', 'Media', 'System_Pressures_Simulink.png');
exportgraphics(gcf, save_path);

% --- Figure 3: Dynamics (Subplots) ---
figure('Name', 'Control Dynamics', 'Color', 'w');
subplot(2,1,1);
plot(t_volt, volt, 'm-', 'LineWidth', 1.2); grid on;
ylabel('Voltage [V]'); legend('Controller Output');
subplot(2,1,2);
plot(time, slew, 'g-', 'LineWidth', 1.2); grid on;
xlabel('Time [s]'); ylabel('Slew Rate [m/s]'); legend('Actuator Velocity');

script_dir = fileparts(mfilename('fullpath'));
save_path = fullfile(script_dir, '..', 'Report', 'Media', 'Control_Dynamics_Simulink.png');
exportgraphics(gcf, save_path);

% --- Figure 4: Loads ---
figure('Name', 'Aerodynamic Loads', 'Color', 'w');
plot(time, loads, 'r-', 'LineWidth', 1.5); grid on;
xlabel('Time [s]'); ylabel('Force [N]');
legend('Actuator Load', 'Location', 'best');

script_dir = fileparts(mfilename('fullpath'));
save_path = fullfile(script_dir, '..', 'Report', 'Media', 'Aerodynamic_Loads_Simulink.png');
exportgraphics(gcf, save_path);