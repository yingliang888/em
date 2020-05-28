%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%  The following codes replicate the main analysis of %%%%%%%%
%%%%%%%%% Table 3, 9, and 10, and Figure 6  %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% in BCLL Management Science     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
save table3.mat

% tab2 stores the estimates in the sequence of:
% theta, mean of x, std of x and average earnings management

%% Bootstrap
clear; clc;
cd ./pre_boot_samples
% Pre-SOX
dfiles = dir('presox*.csv');
tab_pre=[];
for i=1:200
    i
    filename=dfiles(i).name;
    importcsv;
    cd ../
    [Xstar,  obj, bias ]=estimate_likelihood(e,gamma1,gamma2);
%   Uncomment this for Table 9 se
%   [Xstar, obj, bias ]=estimate_mm(e,gamma1,gamma2);
    cd ./pre_boot_samples
    tab_pre=[tab_pre; Xstar obj bias];
    clearvars e gamma1 gamma2 
end
% store the bootstraped estimates for later plots.
Pre_Names={'c','mu','std'};
csvwrite('boot_est_pre.csv',Pre_Names)
csvwrite('boot_est_pre.csv',tab_pre(:,1:3),1,0)
tab2_pre = [1./tab_pre(:,1) tab_pre(:,2:end)]; 
se2_pre = std(tab2_pre(:,1:3));
clearvars -except se_pre tab_pre se2_pre tab2_pre

% Post-SOX
cd ../
cd ./post_boot_samples
tab_post =[];
for i=1:200
    i
    filename=dfiles(i).name;
    importcsv;
    cd ../
    [Xstar,  obj, bias ]=estimate_likelihood(e,gamma1,gamma2);
%   Uncomment this for Table 9 se
%   [Xstar, obj, bias ]=estimate_mm(e,gamma1,gamma2);
    cd ./post_boot_samples
    tab_post=[tab_post; Xstar obj bias];
    clearvars e gamma1 gamma2 
end
% store the bootstraped estimates for later plots.
Post_Names={'c','mu','std'};
csvwrite('boot_est_post.csv',Post_Names)
csvwrite('boot_est_post.csv',tab_post(:,1:3),1,0)

tab2_post = [1./tab_post(:,1) tab_post(:,2:end)]; 
se2_post = std(tab2_post(:,1:3));
clearvars -except se_* tab_* se2_* tab2_*
cd ../
save mle_se.mat



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
save table9.mat
% Refer to the above bootstrap codes to estimate standard errors.

%% Table 10 
clear; clc;
filename='oneyear.csv';
import1yr
cbpre=max(gamma2pre)/2;
cbpost=max(gamma2post)/2
[ paraest,para,t_sta,V,fv, Chi_sta,Pvalue]=estimate_shock(e1,e2,gamma1pre,gamma1post,cbpre,cbpost)
fv=fv(3);
theta=1./paraest
save table10.mat

clear; clc;
cd '.\boot_samples'
dfiles = dir('1yr*.csv');
tab=[];
obj=[];
for i=1:200
    i
    filename=dfiles(i).name;
    importcsv_1yr;
    cbpre=max(gamma2pre)/2;
    cbpost=max(gamma2post)/2;
    [paraest,para,t_sta,V,fv, Chi_sta,Pvalue]=estimate_np2(e1,e2,gamma1pre,gamma1post,cbpre,cbpost)
    tab=[tab;  paraest ];
    obj=[obj; fv(3)];
    clearvars e1 e2 gamma1pre gamma1post cbpre cbpost
end
se = std(tab);
tab2 = 1./tab; 
se2 = std(tab2);
clearvars -except se tab se2 tab2 obj
save table10_se.mat

% Figure 6. Plot unmanaged earnings:
impre= gamma1pre./(2.*paraest(1));
etruepre = e1 - impre;
impost = gamma1post ./(2.*paraest(2));
etruepost= e2-impost;
etruepre2 = trim(etruepre,[5 95]);
etruepost2 = trim(etruepost,[5,94]);
histogram(etruepost2, 50, 'normalization','pdf')
figure
histogram(etruepre2, 50, 'normalization','pdf')