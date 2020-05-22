%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%  The following codes replicate the main analysis of %%%%%%%%
%%%%%%%%% Table 3, 4, 9 and 10 in BCLL Management Science     %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% mle is the main test -- results are reported in Table 3
clear
filename= 'Sample_presox.csv';
importcsv;
[Xstar,  obj, bias ]=estimate_likelihood(e,gamma1,gamma2);
tab=[Xstar obj bias];

filename = 'Sample_postsox.csv';
importcsv;
[Xstar, obj, bias ]=estimate_likelihood(e,gamma1,gamma2);
tab=[tab;Xstar obj bias];
tab2 = [1./tab(:,1) tab(:,2:end)]; 
% tab2 stores the estimates in the sequence of:
% theta, mean of x, std of x and average earnings management

%% Table 9 

clear
filename= 'Sample_presox.csv';
importcsv;
[Xstar,  obj, bias ]=estimate_mm(e,gamma1,gamma2);
tab_mm=[Xstar obj bias];



filename = 'Sample_postsox.csv';
importcsv;
[Xstar, obj, bias ]=estimate_mm(e,gamma1,gamma2);
tab_mm=[tab_mm;Xstar obj bias];
tab_mm2 = [1./tab_mm(:,1) tab_mm(:,2:end)]; 
% tab_mm2 stores the estimates.
