#
# R script + Notes to accompany Introduction to R Statistical Software
# Example: merge all .csv files in a folder
#
# Chris Jochem
# March 2020
#

# Set the path to the folder
folderPath <- "C:/Users/Admin/Documents/Github/R_Training/data/csv"

# Get the list of all files
file_list <- list.files(path=folderPath, pattern="\\.csv$", full.names=TRUE)
  file_list
# Use the list of files, read each
input_files <- lapply(file_list, read.csv)  # lapply() is a looping function
# Combine all into a single dataframe
df <- do.call("rbind", input_files)  # do.call repeats a function
  dim(df)
  head(df)
# I added a column with a file identifier to the three sample .csv files
# We can check they were all added:
  table(df$cs)
