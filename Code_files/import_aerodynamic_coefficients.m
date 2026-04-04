%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 5);

% Specify range and delimiter
opts.DataLines = [11, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["alpha", "CL", "CD", "CDp", "Cm"];
opts.VariableTypes = ["double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
airfoil_data = readtable("airfoil_analysis\NACA0010_re4e+7.csv", opts);

airfoil_data = rmmissing(airfoil_data);
%% Clear temporary variables
clear opts