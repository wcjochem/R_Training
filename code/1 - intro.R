#
# R script + Notes to accompany Introduction to R Statistical Software
# Part 1 - basics of the R language and scripts
# 
# March 2020
# Chris Jochem
#

# Within an R script, everything to the right of '#' is a comment.
# R will ignore comments. It's a good idea to comment 'why' you do
# something, not just 'what' you are doing. 
# Use comments often. Your future self will thank you for them when
# you look at an old script you wrote.

# We can do basic math. Type the following directly in the Console.
# Or, put your cursor on the line and press CTRL + Enter 
# Or, highlight multiple lines of code and press CTRL + Enter
13 + 5  # adding
13 - 5  # subtraction
-1 * 7  # multiplcation
3 ** 2  # exponentiate
8 / 2  # division
9 %% 2  # modulus - get the remainder of division

# R uses objects (called 'variables' in other programming languages).
# You can assign a value to an object to store and reuse it.
# Try to use clear names for your objects.
testobject <- 10  # '<-' is the assignment operator.
testobject * 2  # use an object in a calculation.
testobject2 <- testobject - 1  # assign the result to a new object
# What do you think the value of testobject2 is now?

testobject2  # typing the name will print the value
# Notice also that these objects appear in the "Environment" tab (upper right).
# This pane will show all the data and objects that are current available to R.

# We can apply pre-made scripts to the data using functions.
# Functions are always indicated with a name followed by '()'.
# Anything inside the parentheses is an argument, or option that's passed.
sqrt(100)  # 'sqrt' is the name of the square root function, and 100 is the argument
sqrt()  # This results in an error (console message). 1 argument is required

testobject3 <- sqrt(144)  # Store the return value of a function
testobject3

# Some arguments are optional or have a 'default' value
round(2.71828)  # ommiting the second argument uses the default
round(2.71828, 2)  # multiple argument separated by comma
round(2.71828, 4)

# How will you know what arguments you have to supply?
# 1. Check the manual (we'll see this documentation later)
# 2. Use R's Help
?round # check the lower right pane in the Help tab.
help(round)

round(2.71828, digits=2) # specifying arguments by name
# Notice here that the argument uses '=' not '<-'

# We can combine and "nest" functions, too.
round(sqrt(17), 2)  # rounding the result of the square root of a number

# R has other data types, not just numeric. Two are the most common are:
var1 <- "hello" # character
var2 <- TRUE # logical (TRUE or FALSE)
# You can see what type something is using another function:
class(var1)
class(var2)

# So far we've had objects store only a single value. Next we will see another
# kind of data structure called a 'vector'. You create a vector by combining
# multiple values together with the form: c(..., ...).
datavector <- c(12, 3, -1, 239, 84 )  # This is a vector.
datavector
class(datavector)  # A numeric vector
length(datavector)  # With 5 items in it.

charvector <- c("hello", "world", "!") # This is a character vector.
charvector
class(charvector)  # Character vector
length(charvector)  # 3 items in the vector

logivector <- c(TRUE, FALSE, TRUE, TRUE) # A logical vector. Notice no quotes
logivector
class(logivector)

# We can try to mix data types.
mixvector <- c("hello", 12, 3, TRUE)
mixvector
class(mixvector) # But it all gets converted to a character vector

# We can add items to an existing vector
datavector <- c(datavector, 33, -128) # adds to the end of the vector
length(datavector)
datavector  # This has updated the stored value.

datavector <- c(0, datavector)  # Adds items to the beginning
# How long do you think datavector is now?
length(datavector)
datavector
# Vectors are incredibly important in R and they become the building blocks for
# some other data structures that we will work with a lot.
# The other important part of working with vectors is being able to select a subset
# of the items within them.

# Select items by an 'index' with square brackest. 
# In R the index counts from 1 to the maximum length.
datavector[2]  # get the second item
datavector[-3]  # omit the third item
datavector[10]  # What does this return? Why?

# To get a range of items, use a colon (':') or another vector, ie: c(,)
datavector[1:6]
datavector[c(1:3, 5, 7)] # combining range and single items
datavector[c(2,7,4)]  # Get three items out of order
datavector[-(1:3)]  # omit the first 3 items. Note the use of parentheses
# We can use a conditional test
datavector[datavector > 10]
# We haven't seen these tests before now.
# These operators include:
#  > greater than
#  < less than
#  >= greater than or equal to
#  <= less than or equal to
#  == equal to
# They return a logical vector (True/FALSE)
datavector > 10

# You can combine multiple logical tests with & (AND) as well as | (OR)
datavector > 10 & datavector < 100
datavector[datavector > 10 & datavector < 100]  # Both conditions must be true
datavector[datavector > 100 | datavector < 0]  # Either condition can be true
datavector[datavector == 0] # Notice the difference with '='. This is the logical test.

# These test work with character vectors as well
charvector <- c("apple", "pear", "grape", "banana", "peach", "orange") # make a new object
charvector[c(1,5:6)]  # Using the item indices
charvector[charvector == "orange" | charvector == "banana"]
# Or we can search for and compare multiple items in a list
charvector %in% c("pear", "grape", "orange")  # returning a logical vector
# which means we can use this to subset the vector
charvector[charvector %in% c("pear", "grape", "orange") ]

# Before we move onto working with actual datasets, let's take a last look at doing an
# operation with a vector. This will introuce some of the fundamental concepts of more
# complicated data structures.
# Adding (or subtracting, etc.) to a vector applies it to each element
datavector + 1
# Using the sum() function adds all items together to return a single value
sum(datavector)
mean(datavector)  # we will see more of these functions in the next parts.
# Other common functions include: mean(), min(), max(), sd() [standard deviation], var()

# END OF PART 1!

