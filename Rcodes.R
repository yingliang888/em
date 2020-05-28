library(splines)
library(ggplot2)
setwd("C:\\Users\\leung\\Dropbox (Personal)\\Github")
rm(list = ls())
#################################################################################################
#Step 1. Use smoothing spline to fit stock price response to earnings 
# e is ROE surprise. and car is the three-day size-adjusted abnormal return.
# the code calls the csv file that stores earnings (e) and stock return (car), and stores:
# (1) gamma1 -- the first derivative of the fitted response function and 
# (2) gamma2 -- the second derivative of the fitted response function. 
# Both gamma1 and gamma2 will be used in our later estimation. 

file1='Sample_presox.csv'
datapre <- read.csv(file=file1)
fit1 <- smooth.spline(datapre$e, datapre$car, spar = 1.35, all.knots = FALSE)
datapre$gamma1=predict(fit1,datapre$e,deriv=1)$y
datapre$gamma2=predict(fit1,datapre$e,deriv=2)$y
write.csv(datapre,file =file1,na = "",row.names=FALSE)


file2='Sample_postsox.csv'
datapost <- read.csv(file=file2)
fit2 <- smooth.spline(datapost$e, datapost$car, spar = 1.3, all.knots = FALSE)
datapost$gamma1=predict(fit2,datapost$e,deriv=1)$y
datapost$gamma2=predict(fit2,datapost$e,deriv=2)$y
write.csv(datapost,file =file2,na = "",row.names=FALSE)
#Please save if you would like to create bootstrap samples. 
save.image("fitted.RData")
######################################################################################################
#Step2: Use Matlab to call 'Sample_presox.csv'/'Sample_postsox.csv' to run main_est.m
######################################################################################################


#####################################################################################
#####Create bootstrap samples to calculate standard errors (and figures)
#####################################################################################
rm(list = ls())

#define 200*500 matrics:
# presox/postsox_gamma_mat is a 200*500 matrix that collects fitted value of gamma per value of s 
# presox/postsox_gamma1_mat is a 200*500 matrix with first derivative per value of s.
# presox/postsox_gamma2_mat is a 200*500 matrix that stores second derivatives of s.
postsox_gamma_mat<- matrix(nrow=200, ncol=500)
postsox_gamma1_mat <- matrix(nrow=200, ncol=500)
postsox_gamma2_mat<- matrix(nrow=200, ncol=500)

presox_gamma_mat<- matrix(nrow=200, ncol=500)
presox_gamma1_mat <- matrix(nrow=200, ncol=500)
presox_gamma2_mat<- matrix(nrow=200, ncol=500)

ofilename = 'Sample_presox.csv'
data <- read.csv(file=ofilename,header=TRUE) 
s = seq(from = -0.069, to = 0.043, length.out = 500)
setwd('./boot_samples')
x <- subset(data,select=c(gvkey,e,car))
unigvkey <- unique(x$gvkey, incomparables = FALSE)
for (i in 1:200){
  filename <- paste("presox_",i,".csv",sep="")
  samplekey <- sample(unigvkey,size=length(unigvkey),replace=TRUE)
  selected <- data.frame(gvkey=integer(), e=double(), car=double()) 
  for (j in 1:length( samplekey)){
    selected1=x[x$gvkey==samplekey[j],]
    selected <- rbind(selected,selected1)
  }
  fit <- smooth.spline(selected$e, selected$car, spar = 1.35, all.knots = FALSE)
  selected$gamma = predict(fit,selected$e)$y
  selected$gamma1=predict(fit,selected$e,deriv=1)$y
  selected$gamma2=predict(fit,selected$e,deriv=2)$y
  selected<- subset(selected, select=c(e, gamma1,gamma2,gamma))
  write.csv(selected,file =filename,na = "")  
  #Also create matrices for confidence interval calculation. (Note that the input is "s",not actual data)  presox_gamma_mat[i,] = predict(fit,s)$y
  presox_gamma1_mat[i,]=predict(fit,s,deriv=1)$y
  presox_gamma2_mat[i,]=predict(fit,s,deriv=2)$y
}

ofilename ='Sample_postsox.csv'
data <- read.csv(file=ofilename,header=TRUE)
setwd('./boot_samples')
s = seq(from = -0.069, to = 0.043, length.out = 500)
x <- subset(data,select=c(gvkey,e,car))
unigvkey <- unique(x$gvkey, incomparables = FALSE)
for (i in 1:200){
  filename <- paste("postsox_",i,".csv",sep="")
  samplekey <- sample(unigvkey,size=length(unigvkey),replace=TRUE)
  selected <- data.frame(gvkey=integer(), e=double(), car=double()) 
  for (j in 1:length( samplekey)){
    selected1=x[x$gvkey==samplekey[j],]
    selected <- rbind(selected,selected1)
  }
  fit <- smooth.spline(selected$e, selected$car, spar = 1.3, all.knots = FALSE)
  selected$gamma = predict(fit,selected$e)$y
  selected$gamma1=predict(fit,selected$e,deriv=1)$y
  selected$gamma2=predict(fit,selected$e,deriv=2)$y
  selected<- subset(selected, select=c(e, gamma1,gamma2,gamma))
  write.csv(selected,file =filename,na = "") 
  #Also create matrices for confidence interval calculation.
  postsox_gamma_mat[i,] = predict(fit,s)$y
  postsox_gamma1_mat[i,]=predict(fit,s,deriv=1)$y
  postsox_gamma2_mat[i,]=predict(fit,s,deriv=2)$y
}
setwd('../')
save.image("boot.RData")


######################################################################################################
#Plot figures
######################################################################################################
### Figure 2. Fitted Price Response to Earnings
load('fitted.RData')
load("boot.RData")
s = seq(from = -0.069, to = 0.043, length.out = 500)
pred1 <- data.frame(predict(fit1, s))
first.deriv1 <- data.frame(predict(fit1, s, deriv = 1))
second.deriv1<- data.frame(predict(fit1,s,deriv=2))

pred2 <- data.frame(predict(fit2, s))
first.deriv2 <- data.frame(predict(fit2, s, deriv = 1))
second.deriv2<- data.frame(predict(fit2,s,deriv=2))

fittedpred=data.frame(s)
fittedpred$ypre=pred1$y
fittedpred$ypost=pred2$y

#Obtain standard deviations.
presox_sd_gamma <- apply(presox_gamma_mat, 2, sd)
presox_sd_gamma1<-apply(presox_gamma1_mat, 2, sd)
presox_sd_gamma2<- apply(presox_gamma2_mat, 2, sd)

postsox_sd_gamma <- apply(postsox_gamma_mat, 2, sd)
postsox_sd_gamma1<-apply(postsox_gamma1_mat, 2, sd)
postsox_sd_gamma2<- apply(postsox_gamma2_mat, 2, sd)

#calculate confidence interval.
for (i in 1:500){
  fittedpred$pre_ci_u[i] = fittedpred$ypre[i]+presox_sd_gamma[i] 
  fittedpred$pre_ci_b[i] = fittedpred$ypre[i] -presox_sd_gamma[i] 
  fittedpred$post_ci_u[i] = fittedpred$ypost[i]+postsox_sd_gamma[i] 
  fittedpred$post_ci_b[i] = fittedpred$ypost[i] - postsox_sd_gamma[i] 
}

write.csv(fittedpred,file ='f2_gamma.csv',na = "",row.names = FALSE) 
# We prefer Matlab figures. 'f2_gamma.csv' stores both the pre-sox and post-sox fitted price response y,
# confidence intervals of ys. 

### Figure 4. Implied Earnings Managment 
## According to the estimates in Table 3
## theta pre = 0.0068 theta post= 0.0054 
####Implied earnings management b= theta*gamma'(r)/2 ###########################

fittedim=data.frame(s)
fittedim$ypre=0.0067584/2*first.deriv1$y
fittedim$ypost=0.005387/2*first.deriv2$y

# import bootstrapped estimates.

bootest_pre <- read.csv(file='boot_est_pre.csv')
bootest_post <- read.csv(file='boot_est_post.csv')

# calculate implied earnings management for each bootstrap sample.
bim_pre <- matrix(nrow=200,ncol = 500)
bim_post <- matrix(nrow=200,ncol = 500)
for (i in 1:200){ 
  for (j in 1:500){
    bim_pre[i,j]= presox_gamma1_mat[i,j]/2/bootest_pre$c[i]
    bim_post[i,j]= postsox_gamma1_mat[i,j]/2/bootest_post$c[i]
  }
}
# get the standard deviation.
sd_im_presox<-apply(bim_pre, 2, sd)
sd_im_postsox<-apply(bim_post, 2, sd)

# calculate fitted implied manipulation ci.
for (i in 1:500){
  fittedim$pre_ci_u[i] = fittedim$ypre[i] +sd_im_presox[i] 
  fittedim$pre_ci_b[i] = fittedim$ypre[i] -sd_im_presox[i] 
  fittedim$post_ci_u[i] = fittedim$ypost[i] +sd_im_postsox[i] 
  fittedim$post_ci_b[i] = fittedim$ypost[i] -sd_im_postsox[i] 
}
write.csv(fittedim,file ='f4_im.csv',na = "",row.names = FALSE) 
# Run Matlab code main_plot.m

#############################################################
######## #Figure 5. Plot Alpha ##############################
##### plot alpha and gamma
boot_etrue_pre <- matrix(nrow=200,ncol = 500)
boot_etrue_post <- matrix(nrow=200,ncol = 500)
#get true earnings: reported earnings minus the implied manipulation.
for (i in 1:200){
  for (j in 1:500){
    boot_etrue_pre[i,j]= s[j]-bim_pre[i,j]
    boot_etrue_post[i,j]=s[j]-bim_post[i,j]
  }
}

bcar_post <- matrix(nrow=200,ncol = 500)
bcar_pre <- matrix(nrow=200,ncol = 500)

for (i in 1:200){
  fitb1 <- smooth.spline(boot_etrue_post[i,], postsox_gamma_mat[i,],all.knots = FALSE)
  bcar_post[i,] <- data.frame(predict(fitb1, s))$y
  fitb2 <- smooth.spline(boot_etrue_pre[i,], presox_gamma_mat[i,],all.knots = FALSE)
  bcar_pre[i,] <- data.frame(predict(fitb2, s))$y
}

sd_bcar_presox<-apply(  bcar_pre, 2, sd)
sd_bcar_postsox<-apply( bcar_post, 2, sd)

agpre <- data.frame("x"= fittedpred$s,"etrue"=fittedim$s-fittedim$ypre,"gamma"= fittedpred$ypre,"gamma_ci_u"=fittedpred$pre_ci_u,"gamma_ci_b"=fittedpred$pre_ci_b)
agpost <- data.frame("x"= fittedpred$s,"etrue"=fittedim$s-fittedim$ypost,"gamma"= fittedpred$ypost,"gamma_ci_u"=fittedpred$post_ci_u,"gamma_ci_b"=fittedpred$post_ci_b)
fit_a1 <- smooth.spline(agpre$etrue, agpre$gamma,all.knots = FALSE)
agpre$alpha = data.frame(predict(fit_a1, s))$y
# Here the assumption is that alpha and gamma share the same std. 
agpre$alpha_ci_u = agpre$alpha + sd_bcar_presox 
agpre$alpha_ci_b = agpre$alpha - sd_bcar_presox 
write.csv(agpre,file ='f5_ag_pre.csv',na = "",row.names = FALSE)  
#Note that fit_a1 and fit_a2 use true earnings fitting on car.
fit_a2 <- smooth.spline(agpost$etrue, agpost$gamma,all.knots = FALSE)
agpost$alpha = data.frame(predict(fit_a2, s))$y
agpost$alpha_ci_u = agpost$alpha + sd_bcar_postsox 
agpost$alpha_ci_b = agpost$alpha - sd_bcar_postsox 
write.csv(agpost,file ='f5_ag_post.csv',na = "",row.names = FALSE) 




############################################################
#### Counterfactual ########################################

# Calculate change of total implied earnings management and change only due to theta.
#Table 4

# T4-1
datapre$im=0.0067584/2*datapre$gamma1
mean(datapre$im)


# T4-2
datapost$im=0.005387/2*datapost$gamma1
mean(datapost$im)
# T4-3
mean(datapost$im)-mean(datapre$im)

datapost$etrue = datapost$e - datapost$im
datapre$etrue = datapre$e - datapre$im
datapost$alphap_pre <- data.frame(predict(fit_a1,datapost$etrue,deriv=1))$y
fitR <- smooth.spline(agpre$etrue,agpre$x,all.knots = FALSE)
datapost$Rprime <- data.frame(predict(fitR,datapost$etrue,deriv=1))$y
datapost$counter_im=0.005387/2 * (datapost$alphap_pre/datapost$Rprime )
# T4-4
mean(datapost$counter_im)
# T4-5
mean(datapost$counter_im)-mean(datapre$im)

#####################################################################
#### Table 9 Fit
#####################################################################
rm(list = ls())
filename='oneyear.csv'
data <- read.csv(file=filename,header=TRUE)
s = seq(from = min(data$e1), to = max(data$e1), length.out = 500)
fit <- smooth.spline(data$e1, data$car1, spar = 1.2, all.knots = FALSE) 
pred <- data.frame(predict(fit, s))
first.deriv1 <- data.frame(predict(fit, s, deriv = 1))
second.deriv2<- data.frame(predict(fit,s,deriv=2))
data$gamma1pre=predict(fit,data$e1,deriv=1)$y
data$gamma2pre=predict(fit,data$e1,deriv=2)$y

s = seq(from = min(data$e2), to = max(data$e2), length.out = 500)
fit2 <- smooth.spline(data$e2, data$car2, spar = 1.25, all.knots = FALSE) 
pred <- data.frame(predict(fit2, s))
first.deriv2 <- data.frame(predict(fit2, s, deriv = 1))
second.deriv2<- data.frame(predict(fit2,s,deriv=2))
data$gamma1post=predict(fit2,data$e2,deriv=1)$y
data$gamma2post=predict(fit2,data$e2,deriv=2)$y
write.csv(data,file =filename,na = "",row.names = FALSE) 

# bootstrap
data <- read.csv(file='oneyear.csv')
x<- subset(data,select=c(gvkey,e1,car1,e2,car2))
setwd('./boot_samples')
for (i in 1:200){
  filename <- paste("1yr",i,".csv",sep="")
  samplekey <- sample(data$gvkey,size=length(data$gvkey),replace=TRUE)
  selected <- data.frame(gvkey=integer(), e1=double(), car1=double(), e2=double(),car2=double()) 
  for (j in 1:length( samplekey)){
    selected1=x[x$gvkey==samplekey[j],]
    selected <- rbind(selected,selected1)
  }
  fit1 <- smooth.spline(data$e1, data$car1, spar = 1.2, all.knots = FALSE)
  fit2 <- smooth.spline(data$e2, data$car2, spar = 1.25, all.knots = FALSE)
  selected$gamma11=predict(fit1,data$e1,deriv=1)$y
  selected$gamma12=predict(fit1,data$e1,deriv=2)$y
  selected$gamma21=predict(fit2,data$e2,deriv=1)$y
  selected$gamma22=predict(fit2,data$e2,deriv=2)$y
  write.csv(selected,file =filename,na = "")  
}
setwd('../')
