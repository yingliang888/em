% This m code plots Figure 5 of BCLL Management Science.

filename = 'alphapre.csv';
importalpha;
plot(x,y,'r','LineWidth',2)
hold on
plot(r,y,'b','LineStyle','-.','LineWidth',2)
legend('Implied Earnings Response \alpha(.)','Observed Earnings Response \gamma(.)','Location','northwest','FontSize',12)
xlabel('Earnings Surprise')
ylabel('Earnings Response')

clear
filename = 'alphapost.csv';
hold off
importalpha;
plot(x,y,'r','LineWidth',2)
hold on
plot(r,y,'b','LineStyle','-.','LineWidth',2)
legend('Implied Earnings Response \alpha(.)','Observed Earnings Response \gamma(.)','Location','northwest','FontSize',16)
xlabel('Earnings Surprise')
ylabel('Earnings Response')