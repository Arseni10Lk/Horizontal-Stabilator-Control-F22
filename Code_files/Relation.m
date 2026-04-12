%% If you need images change plotting vars to 1

draw_stabilator = 0;
plot_data_ = 1;
draw_stabilator = (draw_stabilator == 1) && ~exist("Running_in_Simulink", 'var');
should_plot_data = (plot_data_ == 1) && ~exist("Running_in_Simulink", 'var');

%% 1. Providing the required data

d = 1.36124; % m
a = 1.37276; % m

%% 2. Calculating stuff

alpha = rad2deg(asin(d/a));
r = sqrt(a^2 - d^2);

% 3. Defining deflection limits

deflection_max = 30; % deg
deflection_min = -25; % deg
deflection = deflection_min:0.01:deflection_max;

% 4. Finding corresponding actuator extension

extension = sqrt(a^2 + r^2 - 2.*a.*r.*cos(deg2rad(alpha-deflection))) - d;

% -----------------------------------------------------------------------
%% Now, reactions

stab_area = 6.315; % m2 
pivot_axis_pos = 1.982; % m from root chord LE

[MAC, rho_alt, rho_SL, V_alt, V_SL, Re_Alt, Re_SL, ~, ~, MAC_offset, V_stall_Alt, V_max_Alt] = Re_calculations(draw_stabilator);
arm = MAC_offset-MAC*0.25-pivot_axis_pos; % m 
density = [rho_SL; rho_alt]; % kg/m3
velocity = [V_SL; V_alt]; % m/s

q = 0.5 .* density .* velocity .^ 2; % kg / m2 / s2   

import_aerodynamic_coefficients
CL = [interp1(airfoil_data_lRE.alpha, airfoil_data_lRE.CL, deflection); ...
      interp1(airfoil_data_hRE.alpha, airfoil_data_hRE.CL, deflection)];
CD = [interp1(airfoil_data_lRE.alpha, airfoil_data_lRE.CD, deflection); ...
      interp1(airfoil_data_hRE.alpha, airfoil_data_hRE.CD, deflection)];
Cm = [interp1(airfoil_data_lRE.alpha, airfoil_data_lRE.Cm, deflection); ...
      interp1(airfoil_data_hRE.alpha, airfoil_data_hRE.Cm, deflection)];

%% Calculation
% Forces applied at 25% MAC from the leading edge
F_y_stab = CL .* stab_area .* q; % [N]
F_x_stab = CD .* stab_area .* q; % [N]
M_stab = Cm .* stab_area .* MAC .* q;   % [N m]

% Moment acting on a pivot shaft, forces are equal to F_y_stab and F_x_stab
M_pivot = M_stab + ...
    F_y_stab .* arm .* cosd(deflection) + ...
    F_x_stab .* arm .* sind(deflection); % [N m]

% Force acting on the actuator assuming actuator is weightless

semi_P = (d + extension + a + r)/2;
triangle_area = sqrt(semi_P.*(semi_P-d-extension).*(semi_P-a).*(semi_P-r));
lever_arm_actuator = 2 .* triangle_area ./ (d+extension); 
F_act = M_pivot ./ lever_arm_actuator; % [N]

if should_plot_data
    plot_data(deflection, extension, F_act, CL, CD, Cm, F_x_stab, F_y_stab, M_stab, Re_SL, Re_Alt)
end