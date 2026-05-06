% Initialization script for the FPVM-EHA Simulink Model.

%% 1. DC Motor

% Pulled from the catalog
J = 0.205;          % Rotor Inertia [kg*m^2]
R = 0.017;          % Armature Resistance [Ohm]

% Interpolated based on smaller motors
L = 1.95e-5;        % Armature Inductance [H]
K_e = 0.132;        % Back EMF constant [V/rpm]

% Random constants
Damp_mtr= 0;        % Rotor Dampening [N*m*s/rad]
W_init = 0;         % Initial Rotor Speed [rpm]
K_vism = 1;         % Motor viscous friction coefficient [N.m/(rad/s)]

% Fault detection is off 
         
%% 2. Fixed Displacement Pump

% From the datasheet

D = 163.1;      % Displacement [cm^3/rev] 
P_nom = 42;     % Nominal Pressure Gain [MPa]

% The datasheet contains a range, this number is ours

W_nom = 2216;   % Nominal Shaft Angular Velocity [rpm] Can be adjusted

% Just some constants, left at default

eff_V = 0.92;   % Volumetric Efficiency at Nominal Conditions [-]
eff_M = 0.88;   % Mechanical Efficiency at Nominal Conditions [-]
T_NL = 0;       % No Load Torque [N*m]

%% 3. Gas Charged Accumulator
V_actot = 3e-3;         % Total Accumulator Volume [m^3]
V_gasmin = 1.5e-4;      % Minimum Gas Volume [m^3] Can be doubled if needed
P_pre = 14.25;          % Precharge Pressure [Mpa]
hs = 1.4;               % Specific Heat Ratio [-]
S_hs = 1e4;             % Hard Stop Stiffness Coefficient [MPa/m^3]
%dynamic compressibility enabled
P_acnom = 20.7;         %Nominal Pressure of Liquid Volume [MPa]
P_aci = P_acnom;        % Initial accumulator pressure [MPa]
V_gasnom = 2.06e-3;     % Nominal Volume of gas  [m^3]
V_gasi = V_gasnom;      % Initial volume of gas in accumulator [m^3]


%%  4. Double Acting Actuator 
A_cA = 0.0324;      % Chamber A Area [m^2] Circle area given 0.2032m bore
A_cB = 0.026222;    % Chamber B Area [m^2] Circle area given 0.2032m bore and 0.0889m rod
Stroke = 0.1636;    % [m] Just our requirement

% Just scaled this two a bit, can be changed later
V_deadA = 3e-5;     % Dead volume in A [m^3]
V_deadB = 3e-5;     % Dead volume in B [m^3]

% The next 5 are left at default

%HARD STOP
Hard_s = 1e10;      % Hard Stop Stiffness Coefficient [N/m]
Hard_d = 1500;      % Hard stop Dampening Coefficent [N*s/m]
Trans = 0.1;        % Transition Region [mm]
%Cushioning disabled

% Friction
R_bc = 1.2;         % Breakaway to Coulomb Friction Force Ratio [-]
V_brk = 0.1;        % Breakaway friction velocity [m/s]

% Based on the graphs from the catalog (KF seal, Low gland friction)

F_pre = (30 + 35) * 4.448;                          % Preload Force [N]
C_fc =  (480 - 30) * 4.448 / 3000 / 6894.76 ;       % Coulomb Friction Force Coefficient [N/Pa] Average slope
C_fv =  100;                                        % Viscous Friction Coefficient [N*s/m] 

% Leakage
Clearance = 1e-6;           % Piston Cylinder Clearance  [m]
L_head   = 0.01;            % Piston Head Length  [m]

%Initial Conditions
d_ini = 0.0885;             % Initial Piston Displacement from Chamber [m]
P_A = P_acnom * A_cB / A_cA;% Initial Liquid Pressure in chamber A [MPa]
P_B = P_acnom;              % Initial Liquid Pressure in chamber B [MPa]

%% 5. Check Valve
P_crack = 0.01;             % Cracking Pressure Differential [MPa]
P_omax = 0.1;               % Maximum Opening Pressure Differential [MPa]
A_omax = 1e-3;              % Maximum Opening Area [m^2]
A_cleak = 1e-10;            % Leakage Area [m^2]
A_cAB = inf;                % Cross Sectional Area at A&B [m^2]
C_cdis = 0.64;              % Discharge Coefficient [-]
Re_crit = 150;              % Critical Reynolds Number [-]
F_sm = 0.01;                % Smoothing Factor [-]

% KEEP PRESSURE RECOVERY & OPENING DYNAMICS OFF.

%% 6. Pilot Check Valves
P_diff_max = 0.1;           % Max opening pressure Differential [MPa]
Pilot_ratio = 1;            % Pilot ratio [1]
A_max = 1e-3;               % Maximum Opening Area [m^2]
A_pleak = 1e-10;            % Leakage Area [m^2]
A_pAB = inf;                % Cross Sectional Area at A&B [m^2]
C_pdis = 0.64;              % Discharge Coefficient [-]
Re_pcrit = 150;             % Critical Reynolds Number [-]
F_psm = 0.01;               % Smoothing Factor [-]

% AGAIN KEEP PRESSURE RECOVERY & OPENNG DYNAMICS OFF

%% ISOTHERMAL Liquid Properties [IL]
IL_density = 850;           % Density at Atmospheric Pressure [kg/m^3]
IL_bulk = 1.379e9 ;         % Bulk Modulus at AP [Pa]
IL_Kvs = 14.0e-6;           % Kinemaitc Viscosity at AP [m^2/s]

AP = 0.101325;              % Atmospheric Pressure  [MPa]
P_minv = 1;                 % Minimum Valid Pressure [Pa]
