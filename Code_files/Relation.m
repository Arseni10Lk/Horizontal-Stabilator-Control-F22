% 1. Providing the required data

d = 1.36124; % m
a = 1.37276; % m

% 2. Calculating stuff

alpha = rad2deg(asin(d/a));
r = sqrt(a^2 - d^2);

% 3. Defining deflection limits

deflection_max = 30; % deg
deflection_min = -25; % deg
deflection = deflection_min:0.01:deflection_max;

% 4. Finding corresponding actuator extension

extension = sqrt(a^2 + r^2 - 2.*a.*r.*cos(deg2rad(alpha-deflection))) - d;

% 5. Plotting
if ~exist('Running_in_Simulink', 'var') || ~Running_in_Simulink
    figure('Name', 'Actuator vs Deflection Relation')
    plot(extension*100, deflection, 'black', LineWidth=2);
    ylabel('Deflection (degrees)');
    xlabel('Actuator Extension (cm)');
    xlim([min(extension*100) max(extension*100)])
    title('Deflection vs. Actuator Extension');
    grid on;
end

Running_in_Simulink = 0;

% 6. Save the figure

script_dir = fileparts(mfilename('fullpath'));

% Build the relative path to the Media folder
save_path = fullfile(script_dir, '..', 'Report', 'Media', 'Actuator_Deflection.png');

exportgraphics(gcf, save_path);

% -----------------------------------------------------------------------
% Now, reactions

stab_area = 6.315; % m2 

% All the following parameters must be changed later, I guessed all of them:
MAC = 2.5; % m 
arm = 0.35*MAC; % m 
density = 1; % kg/m3
velocity = 300; % m/s

q = 0.5 * density * velocity^2; % kg / m2 / s2

CL = interp1(airfoil_Re40_000.alpha, airfoil_Re40_000.CL, deflection);
CD = interp1(airfoil_Re40_000.alpha, airfoil_Re40_000.CD, deflection);
Cm = interp1(airfoil_Re40_000.alpha, airfoil_Re40_000.Cm, deflection);

% Forces applied at 25% MAC from the leading edge
F_y_stab = CL .* stab_area * q; % [N]
F_x_stab = CD .* stab_area * q; % [N]
M_stab = Cm .* stab_area * MAC * q;   % [N m]

% Moment acting on a pivot shaft, forces are equal to F_y_stab and F_x_stab
M_pivot = M_stab + ...
    F_y_stab .* arm .* cosd(deflection) + ...
    F_x_stab .* arm .* sind(deflection); % [N m]

% Force acting on the actuator assuming actuator is weightless

semi_P = (d + extension + a + r)/2;
triangle_area = sqrt(semi_P.*(semi_P-d-extension).*(semi_P-a).*(semi_P-r));
lever_arm_actuator = 2 .* triangle_area ./ (d+extension); 
F_act = M_pivot ./ lever_arm_actuator; % [N]