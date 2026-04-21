% Initialization script for the FPVM-EHA Simulink Model. Everything is
% initialized to 1

%% 1. Motor Dynamics
L = 1;         % Motor inductance [H]
R = 1;            % Motor resistance [Ohm]
K_t = 1;          % Motor torque constant [N.m/A]
K_e = 1;          % Motor back-EMF / speed constant [V/(rad/s)]
J = 1;         % Total inertia of motor and pump [kg.m^2]
T_f = 1;          % Motor static friction [N.m] (T_s in table)
T_c = 1;          % Motor coulomb friction [N.m]
K_vism = 1;    % Motor viscous friction coefficient [N.m/(rad/s)]

%% 2. Pump Flow Equations
% Displacement converted from ml/rev to m^3/rad for standard SI computation
D_ml_rev = 1; 
D = 1; % Pump displacement [m^3/rad]

K_elp = 1;      % Pump external leakage coefficient [(m^3/s)/Pa]
K_ilp = 1;      % Pump internal leakage coefficient [(m^3/s)/Pa]

%% 3. Refeeding Circuit and Accumulator
% Volumes converted from ml to m^3, Pressure from MPa to Pa
P_aci = 1;      % Initial accumulator pressure [Pa]
V_gasi = 1;    % Initial volume of gas in accumulator [m^3]
k = 1;            % Polytropic exponent of gas [-]

%% 4. Hydraulic Jack and Load Balance
% Area converted from cm^2 to m^2, Volumes from ml to m^3
A = 1;          % Piston active area [m^2]
B = 1;          % Oil bulk modulus [N/m^2]
V_10 = 1;      % Initial volume in chamber 1 [m^3]
V_20 = 1;      % Initial volume in chamber 2 [m^3]
K_ilj = 1;      % Hydraulic jack internal leakage coeff [(m^3/s)/Pa]
M = 1;           % Equivalent mass of piston and load [kg]

%% 5. Friction Model
F_c = 1;           % Piston Coulomb friction [N]
F_s = 1;           % Piston maximum static friction [N]
K_vis = 1;        % Piston viscous friction coefficient [N/(m/s)]

% Reference speeds for the continuous Stribeck friction model (tanh smoothing)
% These are typical values to prevent numerical algebraic loops near zero velocity
alpha = 1;      % Stribeck shape factor [m/s]
beta = 1;       % Tanh smoothing factor [m/s]