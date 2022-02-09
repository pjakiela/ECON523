# Empirical Exercise 1

This exercise makes use of the data set [E1-CohenEtAl-data.dta](https://pjakiela.github.io/ECON523/exercises/E1-CohenEtAl-data.dta), 
a subset of the data used in the 
paper [Price Subsidies, Diagnostic Tests, and Targeting of Malaria Treatment: Evidence from a Randomized Controlled Trial](https://www.aeaweb.org/articles?id=10.1257/aer.20130267) 
by Jessica Cohen, Pascaline Dupas, and Simone Schaner, published in the _American Economic Review_ in 2015.  The authors examine behavioral responses to 
various discounts ("subsidies") for malaria treatment, called "artemisinin combination therapy" or "ACT."  An overview of the randomized evalaution is available [here](https://www.povertyactionlab.org/sites/default/files/publication/2011.12.15-Subsidizing-Malaria.pdf).

The aim of this empirical exercise is to review key Stata commands.  Please upload your answers to gradescope after completing the exercise.  You can also download the activity 
as a [do file](https://pjakiela.github.io/ECON523/E1-intro/E1-questions.do) or a [pdf](https://pjakiela.github.io/ECON523/E1-intro/E1-questions.pdf).

## Getting Started 

There are two ways to get started.  One option is to start by downloading the `do` file linked above, saving it to a file on your computer, and opening it in Stata.  Alternatively, you can open a new `do` file in Stata and add the necessary commands yourself.

The `do` file should start with the following preliminaries:

```
// ECON 523:  PROGRAM EVALUATION FOR INTERNATIONAL DEVELOPMENT
// PROFESSOR PAMELA JAKIELA

/* preliminary stuff*/
clear all 
set scheme s1mono 
set more off
set seed 12345
version 16.1
```

You'll also want to include a command to **change the working directory** so that any outputs are saved where you can find them later.

```
** change working directory as appropriate to where you want to save
cd "C:\Users\CookieMonster\Dropbox\econ523-2022\exercises\E1-why-evaluate-etc"
```

Because the data set is available on github, you can simply download it every time you want to use it.  The following code in the do file will do this:  

```
** load the data from the course website
webuse set https://pjakiela.github.io/ECON523/exercises
webuse E1-CohenEtAl-data.dta
```

If you prefer, you can instead download the data set using the link above and save it directly to your computer.  In that case, you would use the `use` command to open the data set in Stata.

### Question 1

How many observations are in the data set?  


This exercise is part of [Module 1:  Why Evaluate?](https://pjakiela.github.io/ECON523/M1-why-evaluate.html).
