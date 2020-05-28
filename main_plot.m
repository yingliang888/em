%% Figure 1 is plotted using the histogram command in Stata.
% Here we do not provide the codes since it is a realatively well
% documented fact.
%% Figure 2
% Import f2_gamma.csv 
filename='f2_gamma.csv';
importfigure;

figure
f= zeros(1,4)
hold on
f(1)=plot(s, ypre, 'LineWidth',2)
f(2)=plot(s, ypost, 'LineWidth',2,'LineStyle','-.')
f(3)=patch([s(:); flipud(s(:))]', [pre_ci_u; flipud(pre_ci_b)]', ...
    'k', 'FaceAlpha',0.2,'EdgeColor','none')   

f(4)=patch([s(:); flipud(s(:))]', [post_ci_u; flipud(post_ci_b)]', ...
    'k', 'FaceAlpha',0.2,'EdgeColor','none')  

legend(f(1:2),'Pre-SOX','Post-SOX')
xlabel('Earnings Surprise')
ylabel('Earnings Response \gamma')


%% Figure 3 is plotted using Stata. 
% Please copy the following code to Stata if you are interested.

% change directory to Github folder.
% import all.

%% Figure 4
clear 
% import f4_im.csv
filename='f4_im.csv';
importfigure;
% Panel A. Pre-SOX 
figure
hold off
g(1)= plot(s, ypre, 'LineWidth',2)
hold on
g(2)= patch([s(:); flipud(s(:))]', [pre_ci_u; flipud(pre_ci_b)]', ...
        'k', 'FaceAlpha',0.2,'EdgeColor','none')
xlabel('Earnings Surprise')
ylabel('Implied Manipulation')
legend(g(1),'Implied Manipulation')

% Panel B. Post-SOX
figure
hold off
h(1)= plot(s, ypost, 'LineWidth',2)
hold on
h(2)= patch([s(:); flipud(s(:))]', [post_ci_u; flipud(post_ci_b)]', ...
        'k', 'FaceAlpha',0.2,'EdgeColor','none')
xlabel('Earnings Surprise')
ylabel('Implied Manipulation')
legend(h(1),'Implied Manipulation')


%%  F5: alpha and gamma
% Panel A. Pre-SOX
clear 
filename='f5_ag_pre.csv';
importag
figure
hold off
j(1)=plot(x, gamma1, 'LineWidth',2)
hold on
j(2) = plot(x,alpha1, 'LineWidth',2,'LineStyle','--')

j(3) = patch([x(:); flipud(x(:))]',[gamma_ci_u; flipud(gamma_ci_b)]',...
    'k', 'FaceAlpha',0.2,'EdgeColor','none') 
j(4) = patch([x(:); flipud(x(:))]',[alpha_ci_u; flipud(alpha_ci_b)]',...
    'k', 'FaceAlpha',0.2,'EdgeColor','none') 
legend(j(1:2),'\gamma','\alpha')
xlabel('Earnings Surprise')
ylabel('Earnings Response')

% Panel B. Post-SOX
clear 
filename='f5_ag_post.csv';
importag
figure
hold off
k(1)=plot(x, gamma1, 'LineWidth',2)
hold on
k(2) = plot(x,alpha1, 'LineWidth',2,'LineStyle','--')

k(3) = patch([x(:); flipud(x(:))]',[gamma_ci_u; flipud(gamma_ci_b)]',...
    'k', 'FaceAlpha',0.2,'EdgeColor','none') 
k(4) = patch([x(:); flipud(x(:))]',[alpha_ci_u; flipud(alpha_ci_b)]',...
    'k', 'FaceAlpha',0.2,'EdgeColor','none') 
legend(k(1:2),'\gamma','\alpha')
xlabel('Earnings Surprise')
ylabel('Earnings Response')
