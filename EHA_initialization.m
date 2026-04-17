% Initialization script for the FPVM-EHA Simulink Model

%% 1. Motor Dynamics
L = 2.3e-3;         % Motor inductance [H]
R = 1.5;            % Motor resistance [Ohm]
K_t = 0.2;          % Motor torque constant [N.m/A]
K_e = 0.2;          % Motor back-EMF / speed constant [V/(rad/s)]
J = 1.2e-3;         % Total inertia of motor and pump [kg.m^2]
T_f = 0.5;          % Motor static friction [N.m] (T_s in table)
T_c = 0.3;          % Motor coulomb friction [N.m]
K_vism = 4.2e-4;    % Motor viscous friction coefficient [N.m/(rad/s)]

%% 2. Pump Flow Equations
% Displacement converted from ml/rev to m^3/rad for standard SI computation
D_ml_rev = 1.2; 
D = (D_ml_rev * 1e-6) / (2*pi); % Pump displacement [m^3/rad]

K_elp = 1e-13;      % Pump external leakage coefficient [(m^3/s)/Pa]
K_ilp = 1e-13;      % Pump internal leakage coefficient [(m^3/s)/Pa]

%% 3. Refeeding Circuit and Accumulator
% Volumes converted from ml to m^3, Pressure from MPa to Pa
P_aci = 2.5e6;      % Initial accumulator pressure [Pa]
V_gasi = 150e-6;    % Initial volume of gas in accumulator [m^3]
k = 1.3;            % Polytropic exponent of gas [-]

%% 4. Hydraulic Jack and Load Balance
% Area converted from cm^2 to m^2, Volumes from ml to m^3
A = 19e-4;          % Piston active area [m^2]
B = 6.5e8;          % Oil bulk modulus [N/m^2]
V_10 = 152e-6;      % Initial volume in chamber 1 [m^3]
V_20 = 152e-6;      % Initial volume in chamber 2 [m^3]
K_ilj = 1e-13;      % Hydraulic jack internal leakage coeff [(m^3/s)/Pa]
M = 2000;           % Equivalent mass of piston and load [kg]

%% 5. Friction Model
F_c = 25;           % Piston Coulomb friction [N]
F_s = 15;           % Piston maximum static friction [N]
K_vis = 150;        % Piston viscous friction coefficient [N/(m/s)]

% Reference speeds for the continuous Stribeck friction model (tanh smoothing)
% These are typical values to prevent numerical algebraic loops near zero velocity
alpha = 0.005;      % Stribeck shape factor [m/s]
beta = 0.001;       % Tanh smoothing factor [m/s]