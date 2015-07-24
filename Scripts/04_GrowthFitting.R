# AFS Portland 16-Aug-15

library(FSA)                     # for headtail(), filterD(), vbModels(), vbStart(), vbFuns()
library(nlstools)                # for nlsBoot()

d <- read.csv("data/TroutBR.csv",header=TRUE)
rbt <- filterD(d,species=="Rainbow")
str(rbt)

xlbl <- "Age (yrs)"
ylbl <- "Total Length (in)"
clr <- rgb(0,0,0,0.05)

vbModels()

vb <- vbFuns("typical")
vb

svb.bad <- vbStarts(tl~age,data=rbt,type="typical",plot=TRUE)             # Left
svb <- vbStarts(tl~age,data=rbt,type="typical",meth0="yngAge",plot=TRUE)  # Right
unlist(svb)   # unlist() only to save space

# Dynamically approximately fit the function -- Can't be shown in a handout
vbStarts(tl~age,data=rbt,type="typical",dynamicPlot=TRUE)
svb2 <- list(Linf=28.7,K=0.52,t0=1.62)

fit1 <- nls(tl~vb(age,Linf,K,t0),data=rbt,start=svb)
summary(fit1)
( cf <- coef(fit1) )
confint(fit1)

boot1 <- nlsBoot(fit1,niter=200)   # niter should be nearer 1000
confint(boot1)

ageX <- 8
predict(fit1,data.frame(age=ageX))

headtail(boot1$coefboot)
pv <- apply(boot1$coefboot,MARGIN=1,FUN=vb,t=ageX)
quantile(pv,c(0.025,0.975))

plot(tl~age,data=rbt,xlab=xlbl,ylab=ylbl,pch=16,col=clr)
curve(vb(x,cf),from=3,to=10,n=500,lwd=2,col="red",add=TRUE)


# Script created at 2015-07-23 20:05:44