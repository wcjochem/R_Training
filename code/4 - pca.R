#
# R script + Notes to accompany Environmental Statistics with R
# Part 4 - Principal Components Analysis Example
# 
# April 2020
# Chris Jochem
#

# Store the path to the data files for loading [CHANGE FOR YOUR COMPUTER]
input_path <- "C:/Users/Admin/Documents/Github/R_Training"

## Example - species cover at different field sites
# Load the dataset
varespec <- readRDS(paste0(input_path, "/data/species/varespec.rds"))

# Inspect the data
  dim(varespec)
  summary(varespec)  # notice the scales of the data
  str(varespec)
  head(varespec)

# Helper function for plotting PCA variance
# Notice that nothing happens when we run this code. It is stored in R.
# We can then "call" this function with "arguments" as the parameters.
# Source: http://ecology.msu.montana.edu/labdsv/R/labs/lab7/lab7.html
varplot.pca <- function(pca, dim=10)  {
    var <- pca$sdev^2
    totdev <- sum(pca$sdev^2)
    barplot(var[1:dim], ylab="Variance")
    readline("Hit Return to Continue\n")
    barplot(cumsum(var/totdev)[1:dim], ylab="Cumulative Variance")
}

# Run the PCA analysis
result <- prcomp(varespec, retx=TRUE, center=TRUE, scale.=TRUE)
?prcomp  # To get help or see details in the documentation

# what do we get from the function?
names(result)
# sdev - standard deviation of the components (square this to get variance [sdev^2])
# rotation - matrix of "loadings" for each component
# center - variable means
# scale - variable standard deviations
# x - matrix of new coordinates - each observation to the principal components

# You can access any of these results
result$center

# view the summary of components  
summary(result)

# Examine the loadings of the first 5 components
round(result$rotation[,1:5], 3)

# In particular notice the proportion of variance and cumulative explained

# How many components are needed to summarise the data?
# Default plot - screeplot
plot(result, type="lines")
screeplot(result, type="lines")
# Alternative function (above) with cumulative variation
varplot.pca(result)

# Plot the components for the observations 
# Similar observations would be expected to cluster in the plot
plot(result$x[,1], result$x[,2]) # first two PCs
text(result$x[,1], result$x[,2], row.names(result$x), cex=0.6, pos=4, col="red") 

plot(result$x[,4], result$x[,5]) # 4th and 5th (note just changing the column)
text(result$x[,4], result$x[,5], row.names(result$x), cex=0.6, pos=4, col="red") 

# Plot the loadings of the components
biplot(result)  # also includes the PCA score (and scale adjusted)
# The length of the arrows shows a variable's influence on that PC
# There are alternative packages for visualisation, like ggbiplot (on Github)

