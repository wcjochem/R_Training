# Simulating spatially autocorrelated abundance dataset
# Source: https://rpubs.com/jguelat/autocorr2

library(raster)
library(gstat)
library(lattice)

set.seed(100)

# Define function to draw random samples from a multivariate normal
# distribution
rmvn <- function(n, mu = 0, V = matrix(1)) {
    p <- length(mu)
    if (any(is.na(match(dim(V), p)))) 
        stop("Dimension problem!")
    D <- chol(V)
    t(matrix(rnorm(n * p), ncol = p) %*% D + rep(mu, rep(n, p)))
}

# Set up a square lattice region
simgrid <- expand.grid(1:50, 1:50)
n <- nrow(simgrid)

# Set up distance matrix
distance <- as.matrix(dist(simgrid))
# Generate random variable
delta <- 0.05
X <- rmvn(1, rep(0, n), exp(-delta * distance))

# Visualize results
Xraster <- rasterFromXYZ(cbind(simgrid[, 1:2] - 0.5, X))
par(mfrow = c(1, 2))
plot(1:100, exp(-delta * 1:100), type = "l", xlab = "Distance", ylab = "Correlation")
  plot(Xraster)
  
elev <- raster(matrix(rnorm(n), 50, 50), xmn = 0, xmx = 50, ymn = 0, ymx = 50)

  plot(elev, main = "Elevation")

# Define coefficients of the abundance-elevation regression
beta0 <- 0.1
beta1 <- 2
beta2 <- -2

# Abundance as a quadratic function of elevation
lambda1 <- exp(beta0 + beta1 * values(elev) + beta2 * values(elev)^2)

# Abundance as a quadratic function of elevation (+ the other spatially
# autocorrelated covariate)
lambda2 <- exp(beta0 + beta1 * values(elev) + beta2 * values(elev)^2 + 2 * values(Xraster))

# Plot the results
par(mfrow = c(1, 2))
plot(values(elev), lambda1, cex = 0.5, main = expression(lambda == f(covariate)))
plot(values(elev), lambda2, cex = 0.5, main = expression(lambda == f(covariate, X)))  

counts <- rpois(n, lambda2)
counts <- rasterFromXYZ(cbind(coordinates(elev), counts))

plot(counts, main = "Abundance distribution")

id <- sample(1:n, 200)
coords <- coordinates(counts)[id, ]

dat <- data.frame(coords, elev = extract(elev, coords), Xvar = extract(Xraster, 
    coords), counts = extract(counts, coords))
head(dat)

plot(counts, main = "Abundance distribution with sampling sites")
points(coords, pch = 16)

# save data
  head(dat)
saveRDS(dat[,c("x","y","counts")], 
        "C:/Users/Admin/Documents/GitHub/R_Training/data/sim/sites.rds")
library(sf)
shp <- st_as_sf(dat[,c("x","y","counts")], coords=c("x","y"))
st_write(shp, "C:/Users/Admin/Documents/GitHub/R_Training/data/sim/sites.shp", append=F)

writeRaster(elev, "C:/Users/Admin/Documents/GitHub/R_Training/data/sim/var1.tif")
writeRaster(Xraster, "C:/Users/Admin/Documents/GitHub/R_Training/data/sim/var2.tif")
# 
# m1 <- lm(log1p(counts) ~ elev + I(elev^2), data = dat)
#   par(mfrow = c(2, 2))
#   plot(m1)
#   par(mfrow=c(1,1))
# 
# # library(spdep)
# # moran.test(m1$residuals)
# 
# library(ape)
# dists <- as.matrix(dist(cbind(dat$y, dat$x)))
# invD <- 1/dists
# diag(invD) <- 0
#   invD
# Moran.I(m1$residuals, invD)
# Moran.I(dat$counts, invD)
# 
# library(ncf)
# m1.c <- correlog(dat$x, dat$y, dat$counts, increment=5, resamp=100)
#   plot(m1.c)
# 
# m1.r <- correlog(dat$x, dat$y, m1$residuals, increment=5, resamp=100)
#   plot(m1.r)
#   m1.r
