#----------------------------------------------------------------------
# Plot randomized kernel with specific mean and SD values.
#	
require(adehabitatHS) # For simulations of Levy walks
source("./functions/mykernel.R")    # Sourcing the kernel function.

# Different types of dispersal Kernels.
dd<- abs(rnorm(1000, mean = 32.7, sd = 415)) # Normal distrib.
dd<- rweibull(1000, shape= 1, scale = 3.5) # Weibull distrib.
dd<- rgamma(1000, scale= 100, shape= 10) # Gamma distrib.

dd<- as.data.frame(simm.levy(1:500, mu = 1.5, burst = "mu = 1.5")) # req. adehabitatHS
dd<- na.omit(dd$dist)

# With function mykernel.
source("./functions/mykernel.R")
mykernel(dd, bw= 20, h= 2000) # Extract the distances vector

# We can omit the truehist and step directly to the Kernel.
truehist(dd, xlim= c(0, max(dd)),
         # ylim=c(0,0.012),
         prob= T, h= 10, xlab= "Distance (m)",
         ylab= "Probability",col= rgb(0, 0, 1, 0.2),
         lty= 0)
rug(dd, side= 1, col= "red")

# Kernel --------------------------------------------------------------
d<-density(dd, bw=20, from=0, to=max(dd)) # add density estimate
# These are resampled (randomized) values to visualize a confidence envelope.
for (k in 1: 100) {
	di<- sample(dd, length(dd), replace = T, prob = NULL)
	ddi<-density(di, bw=20, from=0, to=max(dd)) # add density estimate
	lines(ddi,xlim=c(0, max(dd)), col="grey", lwd=0.2)
}
lines(d,xlim=c(0,max(dd)),col="blue") # Averaged rresampled kernel

# TDKs ----------------------------------------------------------------
# Model species-specific kernels with different means and variances.
# Dispersal Kernel
dd1<- abs(rnorm(1000, mean = 5, sd = 10))
dd2<- abs(rnorm(1000, mean = 20, sd = 40))
dd3<- abs(rnorm(1000, mean = 20, sd = 120))
dd4<- abs(rnorm(1000, mean = 40, sd = 445))
totd<- c(dd1,dd2,dd3,dd4)

dd1<- rgamma(1000, scale= 8, shape= 1)
dd2<- rgamma(1000, scale= 8, shape= 5)
dd3<- rgamma(1000, scale= 8, shape= 10)
dd4<- rgamma(1000, scale= 8, shape= 2)
totd<- c(dd1,dd2,dd3,dd4)

mykernel(dd4, 100, 1,4)

# Kernels
# Total kernel (histogram and rug)
truehist(totd, xlim= c(0,max(totd)),
         # ylim=c(0,0.012),
         prob= T, h= 5, xlab= "Distance (m)",
         ylab= "Probability", col= rgb(0, 0, 1, 0.2),
         lty= 0)
rug(totd, side= 1,col= "red")

# Species-specific kernels
d1<-density(dd1, bw= 5,from= 0,to= max(dd1)) # add density estimate
lines(d1,xlim= c(0, max(dd1)), col= "blue")
d2<-density(dd2, bw= 5, from= 0, to= max(dd2)) # add density estimate
lines(d2, xlim= c(0, max(dd2)), col= "orange")
d3<-density(dd3, bw= 5, from= 0, to= max(dd3)) # add density estimate
lines(d3, xlim= c(0, max(dd3)), col= "green")
d4<-density(dd4, bw= 5, from= 0, to= max(dd4)) # add density estimate
lines(d4, xlim= c(0, max(dd4)), col= "black")
rug(dd1, side= 1,col= "blue")

######################################################################
### LÉVY WALK CODE 
######################################################################
require(adehabitatHS)
set.seed(411)
w <- simm.levy(1:500, mu = 1.5, burst = "mu = 1.5")
w <- simm.levy(1:500, mu = 2, burst = "mu = 2")
w <- simm.levy(1:500, mu = 2.5, burst = "mu = 2.5")
w <- simm.levy(1:500, mu = 3, burst = "mu = 3")

#----------------------------------------------------------------------
# FUNCTION to trimm the dist values of simulated adehabitatHS paths
# Here I trimm the NA's from the simulated Levy values 
trimmadehabHS<- function (w) { # w is the object generated 
                               # by adehabitatHS, as in e.g., 
                               # w <- simm.levy(1:500, mu = 2, 
                               #                burst = "mu = 2")
    ww<- as.data.frame(w[!is.na(w)])
    # str(ww)
    summary(ww$dist)
    dd<- ww$dist[!is.na(ww$dist)] # dd holds the vector of distances
    # summary(dd) # dd holds just the distance vector
}
#----------------------------------------------------------------------
dd<- trimmadehabHS(w)
summary(dd)
mykernel(dd, 20000, h=100, bw= 100)

truehist(dd, xlim= c(0,5000),
    # ylim=c(0,0.012),
    prob= T, h= 50, xlab= "Distance (m)",
    ylab= "Probability",col= rgb(0, 0, 1, 0.2),
    lty= 0)
rug(dd, side= 1, col= "red")

# Kernel
d<-density(dd, bw= 20, from= 0, to= max(dd)) # add density estimate

# These are resampled (randomized) values to visualize a confidence envelope.
for (k in 1: 100) {
    di<- sample(dd, length(dd), replace = T, prob = NULL)
    ddi<-density(di, bw=20, from=0, to=max(dd)) # add density estimate
    lines(ddi,xlim=c(0, max(dd)), col="grey", lwd=0.2)
}
lines(d, xlim=c(0, max(dd)), col="blue") # Averaged resampled kernel

#----------------------------------------------------------------------
# NOTES
# Here I trimm the NA's from the simulated Levy values 
ww<- as.data.frame(w[!is.na(w)])
# str(ww)
summary(ww$dist)
dd<- ww$dist[!is.na(ww$dist)] # dd holds the vector of distances
summary(dd)









