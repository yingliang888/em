library(splines)
library(ggplot2)
setwd("C:\\Users\\Ying\\Dropbox\\Github")
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
write.csv(datapost,file =file2,na = "")



######################################################################################################
#Step2: Plot figures

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
p1combine <- ggplot(fittedpred, aes(x=s*100)) +   
  geom_line(aes(y = ypre*100,linetype="Pre-SOX"),size = 1 , colour = "blue")+
  geom_line(aes(y = ypost*100,linetype="Post-SOX" ),size = 1, colour = "green")+ theme_bw(base_size=13) +
  labs(x="Earnings Surprises (¢)", y=expression(paste("Earnings Response ",gamma," (%)")))+
  theme(panel.border = element_blank(), panel.grid.major = element_blank(),panel.grid.minor = element_blank(), 
        axis.line = element_line(colour = "black"),legend.position=c(0.2,0.8))
p1combine