% Initialization script for the FPVM-EHA Simulink Model. Everything is
% initialized to 1

%% 1. DC Motor
R = 3.9;         % Armature Resistance [Ohm]
L = 12e-6;            % Armature Inductance [Ohm]
K_e = 0.072e-3;          % Back EMF constant [V/rpm]
J = 0.01;         % Rotor Inertia [cm^2*g]
Damp_mtr= 0;          % Rotor Dampening [N*m*s/rad]
W_init = 0;          % Initial Rotor Speed [rpm]
K_vism = 1;    % Motor viscous friction coefficient [N.m/(rad/s)]
               % Fault detection is off 

%%  2. Double Acting Actuator 
A_cA = 0.01;    % Chamber A Area [m^2]
A_cB = 0.01;    % Chamber B Area [m^2]
Stroke = 0.1  ;   % [m]
V_deadA = 1e-5;    %Dead volume in A [m^3]
V_deadB = 1e-5;    %Dead volume in B [m^3]
%HARD STOP
Hard_s = 1e10;     % Hard Stop Stiffness Coefficient [N/m]
Hard_d = 1500;     %Hard stop Dampening Coefficent [N*s/m]
Trans = 0.1;       % Transition Region [mm]
%Cushioning disabled

% Friction
R_bc = 1.2;     %Breakaway to Coulomb Friction Force Ratio [-]
V_brk = 0.1;     %Breakaway friction velocity [m/s]
F_pre = 20;      %Preload Force [N]
C_fc =  1e-6;     %Coulomb Friction Force Coefficient [N/Pa]
C_fv =  100;      %Viscous Friction Coefficient [N*s/m]
%Leakage (with internal leakage on)
Clearance = 1e-4;  %Piston Cylinder Clearance  [m]
L_head   = 0.01;   %Piston Head Length  [m]
%Initial Conditions
d_ini = 0.05;      %Initial Piston Displacement from Chamber [m]
P_A = 1;           %Initial Liquid Pressure in chamber A [MPa]
P_B = 1;           %Initial Liquid Pressure in chamber B [MPa]

              
%% 3. Fixed Displacement Pump

D = 30; % Displacement [cm^3/rev] 
W_nom = 1800; % Nominal Shaft Angular Velocity [rpm]
P_nom = 10; % Nominal Pressure Gain [MPa]
eff_V = 0.92;      % Volumetric Efficiency at Nominal Conditions [-]
eff_M = 0.88;      % Mechanical Efficiency at Nominal Conditions [-]
T_NL = 0;      % No Load Torque [N*m]

%% 4. Gas Charged Accumulator
% Volumes converted from ml to m^3, Pressure from MPa to Pa
V_actot = 8e-3;    % Total Accumulator Volume [m^3]
V_gasmin = 4e-5;   %Minimum Gas Volume [m^3]
P_pre = 1;       %Precharge Pressure [Mpa]
hs = 1.4    ;      % Specific Heat Ratio [-]
S_hs = 1e4 ;       %Hard Stop Stiffness Coefficient [MPa/m^3]
                  %dynamic compressibility enabled
P_aci = 0.101325;      % Initial accumulator pressure [MPa]
V_gasi = 5e-3;    % Initial volume of gas in accumulator [m^3]
V_gasnom = 1;    %Nominal Volume of Liquid  [m^3]
P_acnom = 1;       %Nominal Pressure of Liquid Volume [MPa]


%% 5. Check Valve
P_crack = 0.01;          % Cracking Pressure Differential [MPa]
P_omax = 0.1;          % Maximum Opening Pressure Differential [MPa]
A_omax = 1e-4;      % Maximum Opening Area [m^2]
A_cleak = 1e-10;      % Leakage Area [m^2]
A_cAB = inf;      % Cross Sectional Area at A&B [m^2]
C_cdis = 0.64;           % Discharge Coefficient [-]
Re_crit = 150;          % Critical Reynolds Number [-]
F_sm = 0.01;           % Smoothing Factor [-] change to 0.05 to help matlab plz
%KEEP PRESSURE RECOVERY & OPENING DYNAMICS OFF.

%% 6. Pressure Relief Valve  (ALOT OF REPEATING CONSTANTS, GIVEN IN CASE OF CHANGE REQUIRED)
P_set = 0;           % Set Pressure Differential [MPa]  <-- CHANGE FROM DEFAULT IMMEDIATELY
P_reg = 0.1;           % Pressure Regulation Range [Mpa]
A_max = 1e-4;        % Maximum Opening Area [m^2]
A_pleak = 1e-10;     % Leakage Area [m^2]
A_pAB = inf;          %Cross Sectional Area at A&B [m^2]
C_pdis = 0.64;        %Discharge Coefficient [-]
Re_pcrit = 150;        %Critical Reynolds Number [-]
F_psm = 0.01;           %Smoothing Factor [-]
%AGAIN KEEP PRESSURE RECOVERY & OPENNG DYNAMICS OFF



%% ISOTHERMAL Liquid Properties [IL] incase some elvin forgets
IL_density = 998.21;   %Density at Atmospheric Pressure [kg/m^3]
IL_bulk = 2.1791e9 ;    %Bulk Modulus at AP [Pa]
IL_Kvs = 1.0034e-6;      %Kinemaitc Viscosity at AP [m^2/s]
AP = 0.101325;           % Atmospheric Pressure  [MPa]
P_minv = 1;               %Minimum Valid Pressure [Pa]


%% Miscellaneous 

Mass = 2000;    %[kg]
%add more if you want lol
