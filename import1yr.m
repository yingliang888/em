%% Setup the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 9);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["gvkey", "car2", "e2", "car1", "e1", "gamma1pre", "gamma2pre", "gamma1post", "gamma2post"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
tbl = readtable(filename, opts);

%% Convert to output type
gvkey = tbl.gvkey;
car2 = tbl.car2;
e2 = tbl.e2;
car1 = tbl.car1;
e1 = tbl.e1;
gamma1pre = tbl.gamma1pre;
gamma2pre = tbl.gamma2pre;
gamma1post = tbl.gamma1post;
gamma2post = tbl.gamma2post;

%% Clear temporary variables
clear opts tbl