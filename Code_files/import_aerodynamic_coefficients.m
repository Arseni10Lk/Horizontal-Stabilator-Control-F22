%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 5);

% Specify range and delimiter
opts.DataLines = [12, Inf];
opts.Delimiter = [",", " "];
opts.LeadingDelimitersRule = "ignore";
opts.ConsecutiveDelimitersRule = 'join';

% Specify column names and types
opts.VariableNames = ["alpha", "CL", "CD", "CDp", "Cm"];
opts.VariableTypes = ["double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
airfoil_data_lRE = readtable("airfoil_analysis\1.63e+07results.csv", opts);

airfoil_data_lRE = rmmissing(airfoil_data_lRE);

airfoil_data_hRE = readtable("airfoil_analysis\1.0516e+08results.csv", opts);

airfoil_data_hRE = rmmissing(airfoil_data_hRE);
%% Clear temporary variables
clear opts