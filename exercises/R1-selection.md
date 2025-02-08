# Empirical Exercise 1 in R

This empirical exercise makes use of the data set [E1-CohenEtAl-data.dta](https://pjakiela.github.io/ECON523/exercises/E1-CohenEtAl-data.dta), a subset 
of the data used in the paper [Price Subsidies, Diagnostic Tests, and Targeting of Malaria Treatment: Evidence from a Randomized Controlled Trial](https://www.aeaweb.org/articles?id=10.1257/aer.20130267) by 
Jessica Cohen, Pascaline Dupas, and Simone Schaner, published in the _American Economic Review_ in 2015. The authors examine behavioral responses 
to various discounts (“subsidies”) for malaria treatment, called “artemisinin combination therapy” or “ACT.” An overview of the randomized evalaution 
is available [here](https://www.povertyactionlab.org/sites/default/files/publication/2011.12.15-Subsidizing-Malaria.pdf).

The goal of this exercise is to review the different approaches to testing for differences in means across groups defined by a dummy variable, for example 
a randomly-assigned treatment.   

<br>
  
## Getting Started

Create an R script that contains the following preliminaries:
```
# preliminaries ----------------------------------------------------------------

## libraries

#install.packages("tidyverse")
#install.packages("haven") # load dta files
install.packages("fixest") # OLS w/ robust SEs

library(tidyverse)
library(haven)
library(fixest)
```
Your R scripts should always start with code that installs and loads important packages. At a minimum, you will always want to 
load [tidyverse](https://www.tidyverse.org/), a suite of related packages that facilitate data processing and analysis. Here, 
we also load [haven](https://haven.tidyverse.org/) so that we can read in stata data files in `.dta` format.  

Notice that I have used the `#` symbol to include comments throughout the code so that future-me will understand the purpose of each line of code.  

You will also want to include a line that specifies a file path for you to save output to later. Notice that we use `<-` to define things in R. Here, for example, 
we define our chosen file path.
```
## file path
mypath <- "C:/ECON-523/E1/"
```
The data for this empirical exercise is available on github, so you can load it directly from there. The haven package 
includes `read_dta()`, a tool that allows you to read stata data files directly into R. The following code loads a stata data set 
from the course github page and stores it as the data frame (actually a tibble) `e1data`:
```
urlfile <- 'https://pjakiela.github.io/ECON523/exercises/E1-CohenEtAl-data.dta'
e1data <- read_dta(urlfile)
```

<br>

## In-Class Activity

## Question 1
How many variables are in the data set?  

For any dataframe `df`, you can use `head(df)` and `glimpse(df)` to familiarize yourself with the data. `summary(df)` provides a summary 
of the means, medians, etc. of all the numeric columns of the data frame `df`. The code below ilustrates how to use these commands to explore the data for this exercise.
```
head(e1data)
glimpse(e1data)
summary(e1data)
```
## Question 2
How many observations are in the data set?  

Hint: you should be able to read off the answer from the output above.  

## Question 3
The variable `act_any` is a treatment dummy. What values does it take on?   

The code below shows how you can tabulate the values of a column of a data frame using `count()`.
```
count(e1data, act_any)
```

## Question 4
How many people received subsidized malaria treatment?  You should be able to answer this question by looking at the output from Question 3.  

## Question 5
What is the mean of `act_any` to three decimal places?  

In the code below, we use `round()` and `mean()` to report the mean of `act_any` to three decimal places. To select a single column within a data frame, 
we use the dollar sign, as in `mean(df$colname)`.  
```
round(mean(e1data$act_any), 3)
```
## Question 6
The variable `c_act` indicates whether a respondent used ACTs as treatment the last time they had malaria. What values does the variable `c_act` take on?  

Hint: use the same approach as in Question 3.

## Question 7

What is the mean of `c_act`?  

Hint: use the same approach as Question 5.  

## Question 8

What is the standard deviation of the variable `c_act`?  

Hint: use the same code as above, but with `sd()` instead of `mean()`.  

## Question 9
What is the standard error of the mean of `c_act`?  

Hint: the standard error is the standard deviation divided by the square root of the number of observations. You can find the number of rows in dataframe `df` with `nrow(df)` and you can find the length of a column vector with `length(df$colname)`.  
 
## Question 10
What is the mean level of ACT use among those assigned to the treatment group?  

`df[df$x == 1]` filters ("subsets") the data frame `df` to select only those rows where `x` equals 1, so `df$colname[df$x == 1]` is the values of the `colname` variable from only those rows where `x` equals 1. Thus, the code below calculates the mean of `c_act` among observations with `act_any` equal to 1.  
 ```
round(mean(e1data$c_act[e1data$act_any == 1]), 3)
```

We could also do this calculation using **the pipe**, a tidyverse tool that allows you to execute multiple steps on the same data frame in sequence. The code below illustrates how to use the pipe.  
```
e1data %>%
  filter(act_any == 1) %>%
  summarize(mean = mean(c_act))
```

## Question 11
Variables starting with `b_` are baseline characteristics (measured before the RCT). How many baseline variables are included in the data set? Which ones are missing data for some households in the sample?  

`names(df)` gives a list of the names of the columns in a data frame. You can use this to see how many baseline variables there are. You can then create a `baseline_vars` data frame that includes only the baseline data. `summary(df)` will allow you to see the means, medians, minima, maxima, and number of missing observations for the (numeric) variables in your data frame. The code below illustrates this.  
 ```
names(e1data)

# looks like there are 7 baseline variables
bl_vars <- e1data[, 1:7]
head(bl_vars)

# summary will indicate the number of NAs
summary(bl_vars)
```

A more elegant way to do this is to define a tibble that contains the column names from your data frame as well as counts of the number of NAs for each column. `is.na(df)` creates a data frame where each value if replaced with an indicator for missing values in the original data frame, and `colSums(df)` sums each column  of a data frame.  
```
tibble(variable = names(bl_vars), na_count = colSums(is.na(bl_vars)))
```

## Question 12
We're going to look at selection bias by comparing the level of educational attainment among households that choose to use ACT treatment when they have malaria versus those that do not use ACT treatment.  

Extend the code below to obtain the mean and standard error of `b_h_edu` when `c_act==1` and when `c_act==0` and then calculate the t-statistic associated with a test of the hypothesis that the two means are equal.  

The code uses `mean()`, `var()`, `sum()`, and `is.na()` The last one (`is.na()`) is necessary because the number of observations is not equal to the number of rows in the data frame when data is missing for some observations.  
 ```
# calculate the mean when c_act == 1, when c_act == 0, and the difference
mean_1 <- mean(e1data$b_h_edu[e1data$c_act==1], na.rm = TRUE)
## define mean_0 here
mean_diff <- mean_1 - mean_0
print(mean_diff)

# calculate the standard error of the difference
var_1 <- var(e1data$b_h_edu[e1data$c_act==1],na.rm = TRUE)
n_1 <- sum(e1data$c_act == 1) - sum(is.na(e1data$b_h_edu[e1data$c_act==1]))
## define var_0 and n_0 here
se_diff <- sqrt((var_1 / n_1) + (var_0 / n_0))
print(se_diff)

# calculcate the t-statistic
t <- mean_diff / se_diff
print(t)
```

## Question 13
Now compare your results to what you obtain using `t.test()`.  

Notice: the first argument of `t.test()` is a formula, `y ~ x` where `y` is the outcome variable and `x` is the treatment dummy, and the second argument is a data frame (since we could have multiple data frames active at the same time).
 ```
t.test(b_h_edu ~ c_act, data = e1data)
```

## Question 14
Now compare the results of your t-test to a linear regression of `b_h_edu` on `c_act`. How are they similar? How are they different?  

One simple way to run OLS in R is to use `lm()` (linear model). The code below regresses `b_h_edu` on `c_act` and a constant. Notice that the formula is again specified using `~`: `y ~ x`. `summary()` is a simple way to view the regression results after you estimate the model.  
```
ols <- lm(b_h_edu ~ c_act, data = e1data)
summary(ols)
```

## Question 15

The `t.test` t-statistic differed from the OLS t-statistic because when we ran OLS, we were implicitly assuming homoskedastic errors. By default, `t.test()` allows the variance of `y` to differ across groups in a two-sample t-test. Setting `var.equal` to `TRUE` will yield the same t-statistic that we obtained by running the regression.  
 
**However, it is never a good idea to assume that errors are homoskedastic.**  One way to run a regression with heteroskedasticity-robust standard errors is to use `feols()` from the `fixest` package. Setting the variance-covariance matrix option `vcov` to `hetero` (see below) of `hc1` replicates stata's robust standard errors.  
```
feols(b_h_edu ~ c_act==1, data = e1data, vcov = 'hetero')
```

The t-statistic is still not identical to the one from the t-test (in Questions 12 and 13). There are a number of different types of heteroskedasticity-robust standard errors: stata's default is to use what are known as HC1 standard errors, but to match the results of a t-test with unequal variances, we need to use HC2 standard errors.  

The code below illustrates how to recover the standard error that you calculated by hand in Question 12, though you probably never need to use this approach to variance-covariance estimation again.  
```
# install the sandwich package for more standard errors
install.packages("sandwich")
library(sandwich)
# estimate the HC2 variance-covariance matrics from our OLS regression
vmat <- vcovHC(lm(b_h_edu ~ c_act==1, data = e1data), type = "HC2")
# take the square root of the second diagonal term to get the SE
newse <- sqrt(vmat[2,2])
print(newse)
```

<br>


