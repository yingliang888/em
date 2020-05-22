function [Xstar, objsol, bias]=estimate_mm(earn,gamma1,gamma2)


% Method of Moments

% debias moments
% X(1) is cost, X(2) is the mean of true earnings x,
% X(3) is the std of x.


cb=max(gamma2)/2;

mom1=@(X) mean(earn-(1./(2.*X(1)).*gamma1))-X(2);
mom2=@(X) std(earn-(1./(2.*X(1)).*gamma1))-X(3);
mom3=@(X) median(earn-(1./(2.*X(1)).*gamma1))-mean(earn-(1./(2.*X(1)).*gamma1));
obj1=@(X) (mom1(X)).^2 +(mom2(X)).^2 +(mom3(X)).^2 - min(X(1)-cb,0)*10^5;

[Xstar, objsol]=particleswarm(obj1,3);

bias=mean(earn)-Xstar(2);


end

