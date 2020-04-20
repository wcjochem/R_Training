#
# R script + Notes to accompany Environmental Statistics with R
# Part 5 - Spatial autocorrelation
# 
# April 2020
# Chris Jochem
#

# R packages for reading/writing spatial data
library(sf)  # rgdal
library(raster)

library(ape)  # easy to use Moran's I test
library(ncf)  # easy to use correlogram function

# Store the path to the data files for loading
input_path <- "C:/Users/Admin/Documents/Github/R_Training"

# Read a shapefile of point locations
sites <- st_read(paste0(input_path, "/data/sim/sites.shp"))
# inspect the spatial data
  class(sites)
  str(sites)
  head(sites)
  summary(sites$counts)
  
  plot(sites, pch=16, axes=T) # simple, quick plot

# Side note: how to create a spatial data file 
# when all you have is a text file with coordinates.
dat <- readRDS(paste0(input_path, "/data/sim/sites.rds"))
  head(dat)
  
datSpatial <- st_as_sf(dat, coords=c("x","y"))
  class(datSpatial)
  plot(datSpatial, axes=T)
# If I had a projection or coordinate reference system, 
# I could add it by using another function: st_set_crs(datSpatial) <- st_crs(...)

# we will use the first shapefile. Remove this one
rm(datSpatial, dat)  # remove two objects from R's memory

# Load raster (gridded) data
var1 <- raster(paste0(input_path, "/data/sim/var1.tif")) # geotiff format
  var1 
  plot(var1)
  image(var1)  # alternatively, use plot(var1)
  
var2 <- raster(paste0(input_path, "/data/sim/var2.tif"))
  var2  
  
  image(var2)
  plot(sites, add=T)

# Extract "covariates" at each site point location
sites$var1 <- extract(var1, sites)
  head(sites) # new column called "var1" added
  summary(sites$var1)

sites$var2 <- extract(var2, sites)
  head(sites)
  summary(sites$var2)
    
  
## Models 
# To demonstrate the presence of correlated residuals, we will
# fit some simple models using OLS.

m1 <- lm(log1p(counts) ~ var1 + I(var1^2), data=sites) # Note the use of I(...)
  class(m1)
  summary(m1) # table of regression coefficients
  
# Inspect some features of the residuals... showing some structure
  par(mfrow = c(2, 2))
  plot(m1)
  par(mfrow=c(1,1))
  
# Test the model residuals for spatial autocorrelation
# Using Moran's I test for global autocorrelation

# Moran's I needs a definition of "neighbours" for testing.
# This could be defined by a fixed distance, inverse weighting of 
# all distances, by a set number of closest sites, or by contiguity
# of sites (works when you have areal unit data). For this test
# we will use inverse distance weights matrix
  
coords <- st_coordinates(sites)
dists <- as.matrix(dist(cbind(coords[,1], coords[,2])))
invD <- 1/dists
diag(invD) <- 0 # set the diagonal to zero
  invD[1:10, 1:10] # examine the first 10 rows/cols of matrix

m1.mi <- Moran.I(m1$residuals, invD, alternative="two.sided")
  m1.mi # small, positive spatial autocorrelation
  
# Spatial autocorrelation can arise from model misspecification.
# Here is the true model form used to simulate the data
m2 <- lm(log1p(counts) ~ var1 + I(var1^2) + var2, data=sites)
  summary(m2)
  
# Compare these tests on the residuals
  par(mfrow = c(2, 2))
  plot(m2)
  par(mfrow=c(1,1))
# aand checking Moran's I
m2.mi <- Moran.I(m2$residuals, invD)
  m2.mi  # no longer significant
  
# Moran's I is a global measure, but we might want to investigate
# correlation at different distances. Either create multiple neighbour
# definitions, or run a correlogram test.

count.corr <- correlog(coords[,1], coords[,2], sites$counts, increment=5, resamp=100)
  plot(count.corr) # unsurprisingly, the data are spatial correlated

m1.corr <- correlog(coords[,1], coords[,2], m1$residuals, increment=5, resamp=100)
  plot(m1.corr) # shows significant correlation at short ranges (dark circles)
  
m2.corr <- correlog(coords[,1], coords[,2], m2$residuals, increment=5, resamp=100)
  plot(m2.corr) # no longer significant, fully explained by the model
  
# If you weren't able to explain the spatial autocorrelation in the residuals of model 1
# you would probably want to explore other model forms. There are many options and
# ways to address this issue. They can include chosing some more robust model forms,
# using other estimation stratgies like GLS, GEE, geostatistical model or other ways 
# of modelling a covariance structure. 

