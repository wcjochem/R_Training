#
# Examples of recoding data
# Chris Jochem
#

set.seed(102018)

# start by generating a fake dataset
n <- 2000 # number of records

df <- data.frame('id'=1:n, # unique ID
                 'age'=sample(c(13:37), size=n, replace=T),
                 'sex'=sample(c("F","M"), size=n, replace=T),
                 'score'=rnorm(n, mean=77, sd=23),
                 'group'=as.factor(sample(LETTERS[1:5], size=n, replace=T)))
  dim(df) # 2000 rows
# simulate missing age data to recode
df[sample(1:nrow(df), size=50, replace=F), "age"] <- -9999
  summary(df$age)
  table(df$age == -9999) # 50 are missing
 
  head(df)
  
# recoding methods, examples:
df[df$age==-9999, "age"] <- NA # fill "missing" codes with NA

df[df$age>=13 & df$age<20, "agegroup"] <- 1 ## DOES NOT WORK with missing data!
df[df$age>=13 & df$age<20 & !is.na(df$age), "agegroup"] <- 1 # this works, creates new variable
df[df$age>=20 & df$age<30 & !is.na(df$age), "agegroup"] <- 2
df[df$age>=30 & !is.na(df$age), "agegroup"] <- 3
# check the grouping
  table(df$age, df$agegroup, useNA="ifany") # 50 NAs remain
# using if/else to recode
df$female <- ifelse(df$sex=='F', 1, 0) # if/else works even with NAs
# dummy coding factors (note: includes all levels)
df <- cbind(df, model.matrix(~ group - 1, df)) # use '-1' to remove intercept
# center/scale variable
df$zscore <- scale(df$score, center=T, scale=T)
  summary(df$zscore)

  head(df)  
  
# simulate one simple outcome for demonstration
# set coefficients
a <- 0.1
b1 <- .5
b2 <- -1
b3 <- .2
e <- rnorm(n=n, 0, .1)
# linear predictor and probabilities
linpred <- with(df, a + b1*zscore + b2*female + b3*(zscore*female) + e)
pr <- exp(linpred) / (1+exp(linpred))
# simulate the outcome
df$outcome <- rbinom(n=n, size=1, prob=pr) 
  table(df$outcome)
  
# fit a model
m1 <- glm(outcome ~ female + zscore + I(female*zscore), 
          family=binomial(link="logit"), 
          data=df)
  summary(m1)
  
