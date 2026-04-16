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