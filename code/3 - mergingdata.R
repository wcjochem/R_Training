#
# R script + Notes to accompany Introduction to R Statistical Software
# Part 3 - merging data
# 
# March 2020
# Chris Jochem
#

# Store the path to the data files for loading
input_path <- "C:/Users/Admin/Documents/Github/R_Training"

## Combining data ##
# The simplest method of combining columns from two data frames is cbind().
# cbind() or "Column bind" ignore the order of records
# We will look at an example with two fake data frames.
df1 <- data.frame(a=1:3, b=rnorm(3))  # note: rnorm() draws random numbers
  df1
  
df2 <- data.frame(a=c(2,1,4,3), c=rnorm(4))  # This data frame has 4 records
  df2
cb_test <- cbind(df1, df2) # this will produce an error because the number of records differs
# Change df2 by dropping the last row and try the cbind() again.
df2 <- df2[-nrow(df2),]  # What is this doing? Get the number of rows; negative to remove.
  df2  # Now three records are in the data frame.
cb_test <- cbind(df1, df2) 
  cb_test  # Notice that all the columns are present. Imagine if column 'a' was an identifier, 
# the records are now mixed up and you wouldn't be able to analyze the data.
# While cbind() is easy, there's a better function for more control over joining data.
  

# Load separate csv files from the Portal site data sets.
# These datasets are all separate, but related.
surveys <- read.csv(paste0(input_path, "/data/portal/surveys.csv"))
  dim(surveys)  # 35549 records
  head(surveys)
  
plots <- read.csv(paste0(input_path, "/data/portal/plots.csv"))
  dim(plots)  # 24 records    
  head(plots)
  
species <- read.csv(paste0(input_path, "/data/portal/species.csv"))
  dim(species)  # 54 records
  head(species)  

# Merging data
# In the previous exercise with the Portal data we worked with a single, combined data file.
# Often data may come in separate tables. Attributes need to be joined into a main file.

# We can add the species-level information and create a new data frame object.
# Unlike cbind(), merges adjust for the order of records, but you must specify a common column.
join_test <- merge(surveys, species, by="species_id")  # "by" indicates the ID column.

  dim(join_test)  # 34786 records -- this dropped 763 observations
# By default the merge() performs an "Inner" join, meaning that both tables must find a match.
# Any records not found in either table (e.g. surveys or species) are dropped.
# The number of species records is much smaller than the number of surveys. All the surveys
# with the same species ID are matched to the same species table record.
  ?merge  # check the documentation for th other options.

# We can keep all the surveys records
join_test2 <- merge(surveys, species, by="species_id", all.x=TRUE)
  dim(join_test2)  # 35549 
# However now we will have missing data.
head(join_test2[is.na(join_test2$species),])  # Here are ome examples
# The species_id is not found in the species table, but the survey data are present.

# Now join on the plot-level information to the survey-species data object
join_test3 <- merge(join_test2, plots, by="plot_id", all.x=T)
  dim(join_test3)  
  head(join_test3)  
# We can to a quick check for missing data
table(is.na(join_test3$plot_type))  # Choose a column found in the plots data frame
# All false, meaning no missing data

# By default the merge() function sorts the data. As a side note we can re-sort it.
join_test3 <- join_test3[order(join_test3$record_id),]  # ascending order of record_id values
  head(join_test3)
  
  
## Appending records ##
# At the beginning of this section we saw the cbind() function to merge columns.
# There is a similar function for combining rows, not surprisingly, called rbind().

# We will demonstrate this again with the fake data frames
# Remember what we have, still in memory with R.
df1
df2
# Combine by stacking the two data frames together.
rb_test <- rbind(df1, df2)  # This gives an error. Why?
# If you know the columns are the same data, you could change the names.
# Remember that 'names(df1) <- c(...)' will all you to modify the names
# Another way to correct the error is to add the missing columns to each data frame
df1$c <- NA  # Creating a new column and setting all observations to NA
df2$b <- NA  # R will automatically recycle this value to every record.

rb_test <- rbind(df1, df2)
# This works, but it leaves NA values and it would be time consuming if you have many columns.
# A workaround can add empty columns by testing for the differences in the names vectors
df1[setdiff(names(df2), names(df1))] <- NA
df2[setdiff(names(df1), names(df2))] <- NA
# But really, this sort of problem highlights the need for good data managements. 
# Consistent use of column names and record identifiers can help to avoid some of these steps.


# End part 3!


  