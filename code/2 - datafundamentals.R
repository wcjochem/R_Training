#
# R script + Notes to accompany Introduction to R Statistical Software
# Part 2 - data fundamentals
# 
# March 2020
# Chris Jochem
#

# In this part of the session we will set up a workflow for cleaning and processing a data file.

# packages used in the analyses
# I prefer to load all the these at the beginning of a script
library(lubridate)

# Loading files
# How do you find the path to the data? You can find the path in the Files tab.
# All R scripts also have a "working directory"
getwd()  # This is the current working directory path. setwd()
# Rather than setting a working directory, I prefer store the paths to my folders as a character.
input_path <- "C:/Users/Admin/Documents/Github/R_Training"  # notice the direction of slashes
# This path will be different on your computer. Change it to the location where
# you downloaded the files.

# The data we will use is a comma-separated data file with multiple columns.
# We need a new function to read it.
surveydf <- read.csv(paste(input_path, "data/portal/combined.csv", sep="/"))
# This also demonstrates another new function paste(). Paste combines two or more strings.
# For example...
paste(input_path, "/NEW STRING/", sep=" ")  # combine these strings with a space as separator

# There is now a new object called "survey" with a new data structure.
class(surveydf)  # this a "data.frame"
# Dataframes are the most combine form for tabular data in R. 
# Most commonly each row of the table is an observation, and each column is an attribute.

# Dataframes have several other functions to inspect them.
dim(surveydf)  # The dimensions as vector: rows  columns
nrow(surveydf)  # Number of rows
ncol(surveydf)  # Number of columns

names(surveydf)  # The names of each column as a character vector
rownames(surveydf)  # The list of row names as a vector

str(surveydf)  # The structure of the dataset. Each column, its type, size, etc.
head(surveydf)  # A quick view of the first 6 lines. Or you can add a second argument for more lines.
tail(surveydf)  # A quick view of the last 6 lines of the dataframe.

## Factors ##
# Looking back at the results of str(), we see a new data type that we haven't encountered before.
str(surveydf)  # For example, columns species_id, sex, genus, species, etc. are "Factors"
head(surveydf)
# Factors are used for categorical variables. The different categories (called levels in R) have
# an integer value (which you don't see) and a label (which you do see), like "M" or "F".
# Factors can make certain analysis steps easier. 
# Let's make an example factor based on a character vector of some data.
example_factor <- factor(c("male", "female", "female", "female", "male"))
levels(example_factor)
nlevels(example_factor)
as.numeric(example_factor)  # Converting a factor to a numeric value. This shows the underlying level.
# we can specify the order the levels
new_factor <- factor(c("male", "female", "female", "female", "male"), levels=c("male","female"))
new_factor  # see the results
# we can relabel the levels
levels(new_factor) <- c("MALE", "FEMALE")
new_factor

# Side note: R tries to automatically assign objects as factors in the read.csv() function. You can
# prevent that with an option: read.csv("path/to/file", stringsAsFactors=FALSE)

## Subsetting the dataframes ##

# Similar to what we saw previously with vectors, we can index and subset rows and columns.
surveydf[ , 2]  # get the second column but return all the rows
surveydf[, 3:4]  # get the third to the fourth columns
surveydf[,"species"]  # access a column by one name
surveydf[, c("genus", "species")]  # or multiple names as a vector using c()
# We don't have to use brackets. R allows access to columns with the '$' marker
surveydf$year
surveydf$species  # returns the species column as a vector
# Because we return a vector we can perform operations on it
surveydf$year[1:10]  # extract part of the vector
mean(surveydf$year)  # and this will not modify the original object

# The first part, before the comma, in the square brackets is for rows.
surveydf[1:3, ]  # get the first three rows, but get all the columns
# As we saw with subsetting vectors, we can use logical statements to select on conditions.
# This will return all the records (rows) where the year is later than 2000
surveydf[surveydf$year > 2000, ]  # notice how we used a conditional vector in the rows.
# Don't forget the comma in the above statement!

# We can select and save records into a new data frame.
# This is an important concept and a step you will likely do often with your data
subset_sample <- surveydf[surveydf$year > 2000, c("plot_id","genus","species")]
  dim(subset_sample)  # 3732 rows with 3 columns
  head(subset_sample)
# Side note: we can remove objects from R.
rm(subset_sample)
  head(subset_sample)  # error not found
  
# Subsetting data with conditions, introduces a new issue - missing data.
# Unlike many programming languages, R is designed to work with datasets and many datasets have
# data which are missing or are incomplete. So R has the concept of an "NA" value.
  head(surveydf)  # Notice the values of 'hindfoot_length'
# We will run into some problems if we try to form a condition with NA values.
head(surveydf[surveydf$hindfoot_length > 30,])  # There are NA rows in the data. 
# We can find only rows with valid data. This step will combine several commands.
NA  # is recognised by R
test_vector <- c(1, 3, 5, 7, NA, 11)
test_vector  # note the missing value
mean(test_vector)  ## no result. Because there is a NA value. Must tell R how to handle these.
mean(test_vector, na.rm=TRUE)  # remove NA values before taking the mean

# Let's try to subset the data agin, but this time only data and omit the NA values
surveydf[!is.na(surveydf$hindfoot_length), ]
# There is a new function here: is.na(). It takes a vector as an argument and returns a logical vector.
is.na(surveydf$hindfoot_length)
# The ! symbol is a logical operator. It means "NOT" and it takes the inverse of the logical vector.
# So if the values of is.na() is TRUE, then NOT returns FALSE. We want values which are NOT NA values.

# We can also combine this function to subset the survey data by hindfoot length
subset_sample <- surveydf[!is.na(surveydf$hindfoot_length) & surveydf$hindfoot_length > 30, ]
  dim(subset_sample)  # 15935 rows and 13 columns
  head(subset_sample)
# In the most extreme case, we might want to keep only records with data in every column.
drop_all <- surveydf[complete.cases(surveydf),]  ## drop all the records with NA in any column
  dim(drop_all)
  head(drop_all)
  

## Data manipulation and cleaning workflow ##

# Before we start, let's quickly clean up our environment of all the unnecessary files we've made.
rm(list=setdiff(ls(), "surveydf"))  # keeps only surveydf. To keep multiple, group names with c().
# We've seen rm() before. ls() lists everything in the environment, and setdiff() takes difference between
# the two arguments, in this case the vector of objects and the one we want to keep.
  head(surveydf)  # Here again is our data.
  str(surveydf)
  
# Take only a rodents to create a new dataframe object
rodents <- subset(surveydf, taxa == "Rodent")  # This is a new function to learn.
?subset  # It can easily extract records from a data frame, basedon the value in the taxa column.
  dim(rodents)
  head(rodents)

# Create a new column - showing two different ways
# 1. This will create an indicator for "big" rodents
rodents$big_rodents <- ifelse(rodents$weight > 48, 1, 0)  # If(CONDITION, TRUE value, False value)
  head(rodents, 20)  # Note that NAs are still NA in the new column
# 2. Create a new column indicating old survey plots
rodents[rodents$year < 1990, "old_svy"] <- 1  # add a new column and set it to 1 
# This only works if the year meets the condition. All other records will be NA
  head(rodents)
  tail(rodents)
# They can be reclassified in a separate step.
rodents[rodents$year >= 1990, "old_svy"] <- 0
  tail(rodents)  # now the NA values are reclassified to zero

# Creating a "date" data type
# Our data frame has date information, but in separate columns. It's also common for data to have
# dates as strings (e.g. "2020-03-18"), but these are difficult to work with and calculate time.
# Conver the strings into a date that R understands
?ymd  # check the lubridate::ymd() help 
date_test <- ymd("2020-03-18")  # it looks the same, but internally it is different
  date_test
class(date_test)
# Create a new column in the rodents data frame which holds a survey date
# Use the paste() to combine the columns together. It works with vectors as well as single values.
rodents$date <- ymd(paste(rodents$year, rodents$month, rodents$day, sep="-"))
  str(rodents)
  head(rodents)

# Calculate an age from January 1st to the survey date for each record. 
rodents$date_diff <- ymd("2020-01-01") - rodents$date
  head(rodents)
  
# Drop unneeded columns using a procedure similar to how we clean the workspace.
rodents <- rodents[, setdiff(names(rodents), c("month","day","year"))]
  dim(rodents)
  head(rodents)

# Clean up our factor for missing labels in the levels
levels(rodents$sex)  # the first labels is blank. That's not helpful for analyses
levels(rodents$sex) <- c("Unk","Female",)

levels(rodents$sex)[1] <- "Unknown"  # we can adjust only the first level
levels(rodents$sex)

# Remove all missing cases
rodents <- rodents[complete.cases(rodents), ]
  head(rodents)
  dim(rodents)
  

## Exploratory data analyses ##
# Now that we have a cleaned and subset dataset, we can begin exploring the dataset.
# We can get basic summary statistics of the data frame.
summary(rodents)  # This will be applied to all columns, but that doesn't make sense for factors or dates.
summary(rodents[,c("hindfoot_length","weight")])
# For categorical data, we may want to tabulate or count the values in the groups.
table(rodents$sex)  # This function uses the factor levels
table(rodents$species)  # Notice the values of 0. Those are levels from the full dataset, not rodents.
# This is why it's often good to examine your data closely
# We can remove these levels
rodents$species <- droplevels(rodents$species)
table(rodents$species)

table(rodents$sex, rodents$big_rodents)  # Cross-tabulation based on rows x columns
# To get the proportions in each category
prop.table(table(rodents$sex, rodents$big_rodents))
prop.table(table(rodents$sex, rodents$big_rodents), margin=1)  # Margins by rows
prop.table(table(rodents$sex, rodents$big_rodents), margin=2)  # Margins by columns
# TO count the number of observations by year
table(year(rodents$date))  # we use the year() from lubridate to extract part of the date

# Get group-level summaries
by(rodents$weight, rodents$sex, FUN=mean)  # Return the average weight by sex class
# Test the differences in mean foot length between female and male rodents
t.test(rodents[rodents$sex=="Female", "hindfoot_length"], 
       rodents[rodents$sex=="Male", "hindfoot_length"])

# Some simple exploratory plots of the data. This will use the functions available in "base" R.
# In later sessions I hope we can focus on data visualisation. There are many more plotting tools.
# The plot should appear in the Plots pane in the lower right. Click on the Zoom button to see
# the image in a separate window. The plot can also be exported.
# 1. Scatterplot
plot(rodents$weight,  # X-axis variable
     rodents$hindfoot_length,  # Y-axis variable
     col=rodents$species,  # add colours by a factor
     xlab="Weight", ylab="Hindfoot length"  # labels
    )

# 2. Boxplots to compare differences by group
boxplot(weight ~ sex, data=rodents)  # This function introduces an important notation.
# This notation using the tilde (~) is how R express regressions. The lefthand side is the dependent variable
# while the righthand side is the independent variable. We include the data frame with the data argument.
boxplot(weight ~ sex + species, data=rodents)  # This is an ugly plot, but it shows how to include groups.

# 3. Histograms to show the frequency of a variable
hist(rodents$hindfoot_length)
hist(rodents$hindfoot_length, breaks=40)  # with 40 categories
hist(rodents$hindfoot_length, 
     breaks=c(0,5,10,15,20,30,50,55,60,80))  # Specific breakpoints


## Data export ##

# We can write out the R objects to new files. There are many options, we'll look at two.
# 1. A .csv file (similar to what we read in)
write.csv(rodents, file="C:/Users/Admin/Documents/Github/R_Training/data/rodents.csv")

# 2 A special R file which can be quickly and easily read. This will save data types, like factors.
saveRDS(rodents, file="C:/Users/Admin/Documents/Github/R_Training/data/rodents.rds")  # note the file extension
# To open this file use readRDS()

# END PART 2
