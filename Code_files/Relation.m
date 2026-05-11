%% If you need images change plotting vars to 1

draw_stabilator = 0;
plot_data_ = 1;
draw_stabilator = draw_stabilator == 1;
should_plot_data = plot_data_ == 1;

if exist("Running_in_Simulink", 'var') && Running_in_Simulink
    draw_stabilator = 0;
    should_plot_data = 0;
    Running_in_Simulink = 0;
end

if should_plot_data
    step_d = 0.1;
    step_v = 1;
else
    step_d = 1;
    step_v = 5;
end

%% 1. Providing the required data

d = 1.36124; % m
a = 1.37276; % m

%% 2. Calculating stuff

alpha = rad2deg(asin(d/a));
r = sqrt(a^2 - d^2);

% 3. Defining deflection limits

deflection_max = 30; % deg
deflection_min = -25; % deg
deflection = deflection_min:step_d:deflection_max;

% 4. Finding corresponding actuator extension

extension = sqrt(a^2 + r^2 - 2.*a.*r.*cos(deg2rad(alpha-deflection))) - d;

% -----------------------------------------------------------------------
%% Now, reactions

stab_area = 6.315; % m2 
pivot_axis_pos = 1.982; % m from root chord LE

[MAC, density, V_max, V_min, Re_max, Re_min, ~, ~, MAC_offset, m_stab, CG_x, CG_y, I_cg] = Re_calculations(draw_stabilator);
arm_aerodynamic = MAC_offset+MAC*0.25-pivot_axis_pos; % m
arm_weight = CG_x - pivot_axis_pos; % m
velocity = [V_min:step_v:V_max V_max]; % m/s
velocity = velocity';

% Interpolation
velocity_fraction = (velocity - V_min)/(V_max-V_min);

q = 0.5 .* density .* velocity .^ 2; % kg / m2 / s2   

import_aerodynamic_coefficients
CL_lRe = interp1(airfoil_data_lRE.alpha, airfoil_data_lRE.CL, deflection, 'linear', 'extrap');
CL_hRe = interp1(airfoil_data_hRE.alpha, airfoil_data_hRE.CL, deflection, 'linear', 'extrap');
CL = CL_lRe + velocity_fraction .* (CL_hRe - CL_lRe);
CD_lRe = interp1(airfoil_data_lRE.alpha, airfoil_data_lRE.CD, deflection, 'linear', 'extrap');
CD_hRe = interp1(airfoil_data_hRE.alpha, airfoil_data_hRE.CD, deflection, 'linear', 'extrap');
CD = CD_lRe + velocity_fraction .* (CD_hRe - CD_lRe);

Cm_lRe = interp1(airfoil_data_lRE.alpha, airfoil_data_lRE.Cm, deflection, 'linear', 'extrap');
Cm_hRe = interp1(airfoil_data_hRE.alpha, airfoil_data_hRE.Cm, deflection, 'linear', 'extrap');
Cm = Cm_lRe + velocity_fraction .* (Cm_hRe - Cm_lRe);

%% Calculation
% Forces applied at 25% MAC from the leading edge
F_y_stab = CL .* stab_area .* q; % [N]
F_x_stab = CD .* stab_area .* q; % [N]
M_stab = Cm .* stab_area .* MAC .* q;   % [N m]

% Moment acting on a pivot shaft, forces are equal to F_y_stab and F_x_stab
M_pivot = M_stab + ...
    F_y_stab .* arm_aerodynamic .* cosd(deflection) + ...
    F_x_stab .* arm_aerodynamic .* sind(deflection) + ...
    m_stab * 9.81 * arm_weight .* cosd(deflection); % [N m]

% Force acting on the actuator assuming actuator is weightless

semi_P = (d + extension + a + r)/2;
triangle_area = sqrt(semi_P.*(semi_P-d-extension).*(semi_P-a).*(semi_P-r));
lever_arm_actuator = 2 .* triangle_area ./ (d+extension); 
F_act = M_pivot ./ lever_arm_actuator; % [N] 

%% Simscape equivalent mass 

I_pivot = I_cg + m_stab * (arm_weight^2);

m_rod = 28.1; % [kg]
M_eq_array = I_pivot ./ (lever_arm_actuator.^2) + m_rod; % [kg]

%% Blowdown limits 

F_max_comp = 670297; % [N]
F_max_tensile = -541998; % [N]

max_controlled_deflection = zeros(length(velocity), 1);
min_controlled_deflection = zeros(length(velocity), 1);

max_allowed_deflection = zeros(length(velocity), 1);
min_allowed_deflection = zeros(length(velocity), 1);

SF = 1.2; % safety factor
% if the blowdown limit is reached the system becomes unstable
for i = 1:length(velocity)
    possible_idx = find(F_max_tensile <= F_act(i, :) & F_act(i, :) <= F_max_comp);
    allowed_idx = find(F_max_tensile/SF <= F_act(i, :) & F_act(i, :) <= F_max_comp/SF);

    if ~isempty(allowed_idx)
        max_controlled_deflection(i) = max(deflection(possible_idx));
        min_controlled_deflection(i) = min(deflection(possible_idx));

        max_allowed_deflection(i) = max(deflection(allowed_idx));
        min_allowed_deflection(i) = min(deflection(allowed_idx));
    elseif ~isempty(possible_idx)
        max_controlled_deflection(i) = max(deflection(possible_idx));
        min_controlled_deflection(i) = min(deflection(possible_idx));

        max_allowed_deflection(i) = 0;
        min_allowed_deflection(i) = 0;
    else
        max_controlled_deflection(i) = 0;
        min_controlled_deflection(i) = 0;

        max_allowed_deflection(i) = 0;
        min_allowed_deflection(i) = 0;
    end
end

if should_plot_data
    plot_data(deflection, extension, F_act, CL, CD, Cm, F_x_stab, F_y_stab, ...
        M_stab, Re_min, Re_max, velocity, max_controlled_deflection, min_controlled_deflection, ...
        max_allowed_deflection, min_allowed_deflection)
end