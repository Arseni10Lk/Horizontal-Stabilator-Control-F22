Relation

% 1. Geometric Requirements
max_extension = max(extension);
min_extension = min(extension);
total_stroke = max_extension - min_extension; % Total travel required [m]

fprintf('Total Stroke Required: %.4f m (%.2f mm)\n', total_stroke, total_stroke*1000);

% 2. Load Requirements
max_tension_load = max(F_act, [], 'all'); % [N]
max_compression_load = abs(min(F_act, [], 'all')); % [N]
fprintf('Max Tensile Load: %.2f N (%.2f lbf) \nMax Compressive Load: %.2f N (%.2f lbf)\n', ...
    max_tension_load, max_tension_load * 0.2248, ...
    max_compression_load, max_compression_load * 0.2248);

% 3. Dynamic Requirements
% Assuming angular rate of 60 deg/s
target_angular_rate = 60; % [deg/s]

% Calculate linear rate: (change in extension / change in angle) * angular rate
d_ext_d_def = diff(extension) ./ diff(deflection); % [m/deg]
max_linear_rate = max(abs(d_ext_d_def)) * target_angular_rate; % [m/s]

fprintf('Max Slew Rate (assuming %d deg/s): %.4f m/s (%.2f mm/s)\n', target_angular_rate, max_linear_rate, max_linear_rate*1000);

% 4. Power Calculation
max_load = max(max_tension_load, max_compression_load); % [N]

% Peak mechanical power (Force x Velocity)
max_mech_power = max_load * max_linear_rate; % [W]

% Assumed efficiencies (UPDATE LATER)
pump_efficiency = 0.85; % Assumed
motor_efficiency = 0.90; % Assumed

% Peak electrical power required from the aircraft bus
max_elec_power = max_mech_power / (pump_efficiency * motor_efficiency); % [W]

fprintf('\n--- Power Requirements ---\n');
fprintf('Max Mechanical Power: %.2f W (%.2f kW)\n', max_mech_power, max_mech_power/1000);
fprintf('Max Electrical Power (Assuming %.0f%% pump & %.0f%% motor efficiency): %.2f W (%.2f kW)\n', ...
    pump_efficiency*100, motor_efficiency*100, max_elec_power, max_elec_power/1000);

