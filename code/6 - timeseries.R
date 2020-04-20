#
# R script + Notes to accompany Environmental Statistics with R
# Part 6 - Time series models
# 
# April 2020
# Chris Jochem
#

# Based on the tutorial here: http://environmentalcomputing.net/forecasting-time-series/

library(forecast)

# create the data on forest loss manually
Area <- c(1650,730,580,440,409,333,333,797,320,273,576,216,244,189,212,156,158,271,124,63,107,61,49,40,52)
Year <- c(1988:2012)

# Create a "time series" class object
Area_loss <- ts(Area, start = 1988, end = 2012, frequency = 1)
  Area_loss  # inspect the object
  class(Area_loss)  # note the type here

# Automatic plotting functions exist for ts objects  
  plot(Area_loss)
  
# To select parts of the time series, we can use the window() function
?window
# For instance, we can select sections to be "training" and "testing" data
# to evaluate how models fit.
Area_loss_train <- window(Area_loss, start = 1988, end = 2009, frequency = 1)
# keep the last 3 years for testing/validation
Area_loss_test <- window(Area_loss, start = 2010, end = 2012, frequency = 1)

# These are also ts objects
class(Area_loss_test)
  plot(Area_loss_test) # very short time span
  
# Fit a simple exponential smoothing model
  ?ets
fit1 <- ets(Area_loss_train, model = "ANN")  #
  class(fit1)
# NOTE: the model setting "additive errors (A), no assumed trend (N) and no seasonality (N)
  plot(fit1)
  summary(fit1)

# Use the first model to predict 3 time steps into the future
fit1_forecast <- forecast(fit1, h = 3) 
  fit1_forecast # see the forecasts with high/low predictions (very wide)

# Default plotting of a forecast gives observed and forecast values!
  plot(fit1_forecast)
  
# Add the observed values to the plot
  points(Year[23:25], Area[23:25], lty = 1, col = "black", lwd = 3, pch = 0)

# Model 2, add a trend component
fit2 <- ets(Area_loss_train, model = "AAN") 
  plot(fit2)
  summary(fit2)

fit2_forecast <- forecast(fit2, h = 3)
  plot(fit2_forecast)
  points(Year[23:25], Area[23:25], lty = 1, col = "black", lwd = 4, pch = 0)

# Model 3, automatic selection by minimising AIC
fit3 <- ets(Area_loss_train)  # Note: no longer including a model term
  summary(fit3)
# what model was selected?
fit3$method  # This has multiplicative errors (M), but no overall trend (N) or seasonality (N)
  plot(fit3)

fit3_forecast <- forecast(fit3, h = 3)
  plot(fit3_forecast)
  points(Year[23:25], Area[23:25], lty = 1, col = "black", lwd = 4, pch = 0)

## Example 2 - Lake levels in Lake Huron
data("LakeHuron")
  class(LakeHuron)
  LakeHuron
  
  plot(LakeHuron)

# Correlation structure, compared with its own time lags
Acf(LakeHuron)  # decreases with longer time lags
# If there were multiple peaks, this might imply seasonal variation
# the 'q' component for ARIMA

# Partial autocorrelation function
# controls for the lags, like looking for correlation in the residuals
Pacf(LakeHuron)
# Which observations are most informative on the recent observation?
# We can use these functions to build towards an ARIMA model
# the 'p' component for ARIMA

# Differencing
dLake <- diff(LakeHuron)
  plot(dLake)
Acf(dLake)  
Pacf(dLake)

# ARIMA tests
# model 1
ar1 <- auto.arima(LakeHuron)
  summary(ar1) # view the model summary
# check the residuals
acf(resid(ar1))

f.ar1 <- forecast(ar1) 
  plot(f.ar1)  

# model 2 - setting your own parameters
ar2 <- Arima(LakeHuron, order=c(1,0,0))
  summary(ar2)
acf(resid(ar2))

f.ar2 <- forecast(ar2)
  plot(f.ar2)
  