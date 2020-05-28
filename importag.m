%% Setup the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 8);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["x", "etrue", "gamma1", "gamma_ci_u", "gamma_ci_b", "alpha1", "alpha_ci_u", "alpha_ci_b"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
tbl = readtable(filename, opts);

%% Convert to output type
x = tbl.x;
etrue = tbl.etrue;
gamma1 = tbl.gamma1;
gamma_ci_u = tbl.gamma_ci_u;
gamma_ci_b = tbl.gamma_ci_b;
alpha1 = tbl.alpha1;
alpha_ci_u = tbl.alpha_ci_u;
alpha_ci_b = tbl.alpha_ci_b;

%% Clear temporary variables
clear opts tbl