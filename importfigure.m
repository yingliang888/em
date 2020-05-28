%% Import data from text file
% Script for importing data from the following text file:
%% Setup the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 7);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["s", "ypre", "ypost", "pre_ci_u", "pre_ci_b", "post_ci_u", "post_ci_b"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
tbl = readtable(filename, opts);

%% Convert to output type
s = tbl.s;
ypre = tbl.ypre;
ypost = tbl.ypost;
pre_ci_u = tbl.pre_ci_u;
pre_ci_b = tbl.pre_ci_b;
post_ci_u = tbl.post_ci_u;
post_ci_b = tbl.post_ci_b;

%% Clear temporary variables
clear opts tbl