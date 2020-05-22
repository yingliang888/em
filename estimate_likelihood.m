function [ Xstar, objsol, bias ] = estimate_likelihood( e,gamma1,gamma2)
%ESTIMATE_LIKELIHOOD Summary of this function goes here
%   Detailed explanation goes here
% Fixed Cost, MLE Method
% X: cost, mu_true eings, std_true eings

m0=mean(e);
std0=std(e); 
cb=max(gamma2)/2;

% likelihood method

obj=@(X) -mean(log(max(0,2.*X(1)-gamma2)/(2.*X(1)).*normpdf((e-1./(2.*X(1))*gamma1),X(2),X(3)))+10^9.*min(X(1)-cb,0));
[Xstar objsol]=particleswarm(obj,3,[cb -0.5 0.00001],[1000 0.5 0.5]);
[Xstar objsol1]=fminsearch(obj,Xstar);

objsol=-objsol;
bias=mean(e)-Xstar(2);

end 

