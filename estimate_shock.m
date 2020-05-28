function [ paraest,para,t_sta,V,fv, Chi_sta,Pvalue]=estimate_np2(epre,epost,gamma1pre,gamma1post,cbpre,cbpost)
% NP with shock to c

% momentsb 
% r is the number of parameters, length(X)
para=[];
W1=eye(3);
mom1=@(X) epre-(1./(2.*X(1)).*gamma1pre)-(epost-(1./(2.*X(2)).*gamma1post));
mom2=@(X) (epre-(1./(2.*X(1)).*gamma1pre)).^2-(epost-(1./(2.*X(2)).*gamma1post)).^2;
mom3=@(X) (epre-(1./(2.*X(1)).*gamma1pre)).^3-(epost-(1./(2.*X(2)).*gamma1post)).^3;
H=@(X) [mom1(X)';mom2(X)';mom3(X)'];  %H is r*N dimension;
h=@(X) mean(H(X),2); %h is r*1
obj=@(X) h(X)'*W1*h(X)-10^6*min(0,X(1)-cbpre)-10^5*min(0,X(2)-cbpost);
[Xstar,objsol]=fmincon(obj,[cbpre+10 cbpost+100],[],[],[],[],[cbpre cbpost], [10000 15000])
para(1,:)=Xstar;
fv(1)=objsol;



mom=feval(H,para(1,:)); % r*N
Shat=mom*mom'/length(epre); %r*r
W=pinv(Shat);% r*r
obj=@(X) h(X)'*W*h(X)-10^6*min(0,X(1)-cbpre)-10^5*min(0,X(2)-cbpost);
[para(2,:),fv(2)]=fmincon(obj,para(1,:),[],[],[],[],[cbpre cbpost], [10000 10000]);
paraest=para(2,:);
    
mom2 = feval(H,paraest); % r*N
Shat2= W'*(mom2)*(mom2')*W/length(epre); %r*r
W2= pinv(Shat2);
obj = @(X) h(X)'*W2*h(X)-10^6*min(0,X(1)-cbpre)-10^5*min(0,X(2)-cbpost);
[para(3,:),fv(3)]=fmincon(obj,para(2,:),[],[],[],[],[cbpre cbpost], [10000 10000]);
paraest = para(3,:);


% mom3 = feval(H,paraest); % r*N
% Shat3= W'*(mom3)*(mom3)'*W/length(epre); %r*r
% W3= pinv(Shat3);
% obj = @(X) h(X)'*W3*h(X)-10^6*min(0,X(1)-cbpre)-10^5*min(0,X(2)-cbpost);
% [para(4,:),fv(4)]=fmincon(obj,paraest,[],[],[],[],[cbpre cbpost], [10000 10000]);
% paraest = para(4,:);
f0=feval(h,paraest); %r*1


for j=1:2
        a=zeros(1,2);
        eps=max(paraest(j)*1e-4,1e-5);
        a(j)=eps;
        M(:,j)=(feval(h,paraest+a)-f0)/eps; %r*2
end


V=pinv(M'*W2*M)/length(epre);
stderror=sqrt(diag(V));
t_sta=paraest'./(stderror);
% Chi_sta=fv(2);
Chi_sta=length(epre)*fv(3);
Pvalue=1-chi2cdf(Chi_sta,1);
end
