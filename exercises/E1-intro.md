# Empirical Exercise 1

This exercise makes use of the data set [E1-CohenEtAl-data.dta](https://pjakiela.github.io/ECON523/exercises/E1-CohenEtAl-data.dta), 
a subset of the data used in the 
paper [Price Subsidies, Diagnostic Tests, and Targeting of Malaria Treatment: Evidence from a Randomized Controlled Trial](https://www.aeaweb.org/articles?id=10.1257/aer.20130267) 
by Jessica Cohen, Pascaline Dupas, and Simone Schaner, published in the _American Economic Review_ in 2015.  The authors examine behavioral responses to 
various discounts ("subsidies") for malaria treatment, called "artemisinin combination therapy" or "ACT."  An overview of the randomized evalaution is available [here](https://www.povertyactionlab.org/sites/default/files/publication/2011.12.15-Subsidizing-Malaria.pdf).

The aim of this empirical exercise is to review key Stata commands.  Please upload your answers to gradescope after completing the exercise.  You can also download the activity 
as a [do file](https://pjakiela.github.io/ECON523/E1-intro/E1-questions.do) or a [pdf](https://pjakiela.github.io/ECON523/E1-intro/E1-questions.pdf).

## Getting Started 

There are two ways to get started.  One option is to start by downloading the `do' file linked above and opening it in Stata.  The `do` file starts with the following preliminaries:

```
clear all 
set scheme s1mono 
set more off
set seed 12345
version 16.1
```

Because the data set is available on github, you can simply download it every time you want to use it.

```
** load the data from the course website
webuse set https://pjakiela.github.io/ECON523/exercises
webuse E1-CohenEtAl-data.dta
```


### Question 1

How many observations are in the data set?  


This exercise is part of [Module 1:  Why Evaluate?](https://pjakiela.github.io/ECON523/M1-why-evaluate.html).
