function [MAC, Re_SL, Re_Alt] = calculate_F22_stabilator_Re()
  
    c_root = 3.739; 
    c_tip  = 1.261; 
    lambda = c_tip / c_root;
    MAC = (2/3) * c_root * ((1 + lambda + lambda^2) / (1 + lambda));

    
    %% Extreme Case 1: (Max Dynamic Pressure)

    rho_SL = 1.225;        % Air density [kg/m^3]
    mu_SL  = 1.789e-5;     % Dynamic viscosity [kg/(m*s)]
    a_SL   = 340.3;        % Speed of sound at sea level [m/s]
    V_SL   = 1.5 * a_SL;   % Flight velocity [m/s]
    Re_SL = (rho_SL * V_SL * MAC) / mu_SL; %re 1
    
    %% Extreme Case 2: (High Altitude Supercruise 60kft(18.288 km) elevation)

    rho_alt = 0.116;       % Air density [kg/m^3]
    mu_alt  = 1.422e-5;    % Dynamic viscosity [kg/(m*s)]
    a_alt   = 295.2;       % Speed of sound at 18.288 km [m/s]
    V_alt   = 2.25 * a_alt; % Flight velocity [m/s]
    Re_Alt = (rho_alt * V_alt * MAC) / mu_alt;
   
    fprintf('--- F-22 Stabilator Aerodynamic Parameters ---\n');
    fprintf('Root Chord (c_root)  : %.3f m\n', c_root);
    fprintf('Tip Chord (c_tip)    : %.3f m\n', c_tip);
    fprintf('Taper Ratio (lambda) : %.3f\n', lambda);
    fprintf('Mean Aero Chord (MAC): %.3f m\n\n', MAC);
    
    fprintf('--- Extreme Case 1: Sea Level, Mach 1.5 ---\n');
    fprintf('Velocity             : %.2f m/s\n', V_SL);
    fprintf('Reynolds Number (Re) : %.2e\n\n', Re_SL);
    
    fprintf('--- Extreme Case 2: 60k ft (18.288 km), Mach 2.25 ---\n');
    fprintf('Velocity             : %.2f m/s\n', V_alt);
    fprintf('Reynolds Number (Re) : %.2e\n', Re_Alt);
    fprintf('----------------------------------------------\n');
end