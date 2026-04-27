% --- 1. GEOMETRY DEFINITION (Matches Re_calculations exactly) ---
y_stations = [0, 1.25, 2.5];        % [m] Spanwise locations
chords     = [3.739, 3.130, 1.261]; % [m] Exact chord lengths
b_total    = y_stations(end);
LE_lambda  = 44.74;                 % [deg] Calculated from LE geometry

% --- 2. MATERIAL PROPERTIES ---
t_ratio = 0.10;              % NACA 0010
rho_honeycomb = 150;         % [kg/m^3] Ti-3Al-2.5V core + Carbon skin
k_shell = 0.42;              % Airfoil centroid

M_shaft = 60;                % [kg] Shaft mass
Shaft_x = 0.25 * chords(1);  % Shaft at 25% of root chord
Shaft_y = 0.3;               % [m] Shaft spanwise penetration

% --- 3. MULTI-PANEL VOLUME & AREA INTEGRATION ---
S_total = 0;
V_total = 0;
sum_V_x = 0; % For CoG moments
sum_V_y = 0;

cross_section_factor = 0.685 * t_ratio; 

for i = 1:(length(y_stations)-1)
    c_root_i = chords(i);
    c_tip_i  = chords(i+1);
    b_i      = y_stations(i+1) - y_stations(i); 
    taper_i  = c_tip_i / c_root_i;
    
    % Panel Area
    S_i = (c_root_i + c_tip_i) / 2 * b_i;
    S_total = S_total + S_i;
    
    % Panel Volume
    V_i = cross_section_factor * b_i * (c_root_i^2 + c_root_i*c_tip_i + c_tip_i^2) / 3;
    V_total = V_total + V_i;
    
    % Local Panel Centroids
    Y_shell_local = (b_i * (1 + 2*taper_i + 3*taper_i^2)) / (4 * (1 + taper_i + taper_i^2));
    Y_shell_global = y_stations(i) + Y_shell_local;
    
    X_shell_global = (Y_shell_global * tand(LE_lambda)) + ...
                     (k_shell * c_root_i * (3 * (1 + taper_i + taper_i^2 + taper_i^3)) / (4 * (1 + taper_i + taper_i^2)));
                 
    % Moment accumulation for whole shell CoG
    sum_V_y = sum_V_y + (V_i * Y_shell_global);
    sum_V_x = sum_V_x + (V_i * X_shell_global);
end

% --- 4. MASS AND CG CALCULATIONS ---
M_shell = V_total * rho_honeycomb;
Y_shell_cg = sum_V_y / V_total;
X_shell_cg = sum_V_x / V_total;

M_total = M_shell + M_shaft;
X_cg_true = ((M_shell * X_shell_cg) + (M_shaft * Shaft_x)) / M_total;
Y_cg_true = ((M_shell * Y_shell_cg) + (M_shaft * Shaft_y)) / M_total;

% --- 5. CONSOLE OUTPUT ---
fprintf('--- Multi-Panel Stabilator Mass Analysis ---\n');
fprintf('Total Area:      %.3f m^2\n', S_total);
fprintf('Total Volume:    %.3f m^3\n', V_total);
fprintf('Shell Mass:      %.1f kg\n', M_shell);
fprintf('Shaft Mass:      %.1f kg\n', M_shaft);
fprintf('Total Mass:      %.1f kg\n', M_total);
fprintf('True Spanwise CoG (Y):  %.3f m from root\n', Y_cg_true);
fprintf('True Chordwise CoG (X): %.3f m aft of root LE\n', X_cg_true);