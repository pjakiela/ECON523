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
#install.packages("haven") # to load data in Stata's .dta form
install.packages("fixest") # to run OLS with robust SEs

library(tidyverse)
library(haven)
library(fixest)
```
Your R scripts should always start with code that installs and loads important packages. At a minimum, you will always want to 
load [tidyverse](https://www.tidyverse.org/), a suite of related packages that facilitate data processing and analysis. Here, 
we also load [haven](https://haven.tidyverse.org/) so that we can read in stata data files in `.dta` format.  

Notice that I have used the `#` symbol to include comments throughout the code so that future-me will understand the purpose of each line of code.  

You will also want to include a line that specifies a file path for you to save output to later.   
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

## In-Class Activity



