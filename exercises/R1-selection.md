# Empirical Exercise 1 in R

This empirical exercise makes use of the data set [E1-CohenEtAl-data.dta](https://pjakiela.github.io/ECON523/exercises/E1-CohenEtAl-data.dta), a subset 
of the data used in the paper [Price Subsidies, Diagnostic Tests, and Targeting of Malaria Treatment: Evidence from a Randomized Controlled Trial](https://www.aeaweb.org/articles?id=10.1257/aer.20130267) by 
Jessica Cohen, Pascaline Dupas, and Simone Schaner, published in the _American Economic Review_ in 2015. The authors examine behavioral responses 
to various discounts (“subsidies”) for malaria treatment, called “artemisinin combination therapy” or “ACT.” An overview of the randomized evalaution 
is available [here](https://www.povertyactionlab.org/sites/default/files/publication/2011.12.15-Subsidizing-Malaria.pdf).

The goal of this exercise is to review the different approaches to testing for differences in means across groups defined by a dummy variable, for example 
a randomly-assigned treatment.   
  
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
  
## In-Class Activity

## Question 1
How many variables are in the data set?  

For any dataframe `df`, you can use `head(df)` and `glimpse(df)` to familiarize yourself with the data. `summary(df)` provides a summary 
of the means, medians, etc. of all the numeric columns of the data frame `df`.
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



