# Empirical Exercise 1

This exercise makes use of the data set [E1-CohenEtAl-data.dta](https://pjakiela.github.io/ECON523/exercises/E1-CohenEtAl-data.dta), 
a subset of the data used in the 
paper [Price Subsidies, Diagnostic Tests, and Targeting of Malaria Treatment: Evidence from a Randomized Controlled Trial](https://www.aeaweb.org/articles?id=10.1257/aer.20130267) 
by Jessica Cohen, Pascaline Dupas, and Simone Schaner, published in the _American Economic Review_ in 2015.  The authors examine behavioral responses to 
various discounts ("subsidies") for malaria treatment, called "artemisinin combination therapy" or "ACT."  An overview of the randomized evalaution is available [here](https://www.povertyactionlab.org/sites/default/files/publication/2011.12.15-Subsidizing-Malaria.pdf). 

<br>

## Getting Started 

Create a `do` file that contains the following preliminaries:

```
// ECON 523:  PROGRAM EVALUATION FOR INTERNATIONAL DEVELOPMENT
// PROFESSOR PAMELA JAKIELA

/* preliminary stuff*/
clear all 
set more off
set seed 12345
```

You'll also want to include a command to **change the working directory** so that any outputs are saved where you can find them later.

```
** change working directory as appropriate to where you want to save
cd "C:\Users\CookieMonster\Dropbox\ECON-523\exercises\E1-why-evaluate-etc"
```

Because the data set is available on github, you can simply download it every time you want to use it.  The following code in the do file will do this:  

```
** load the data from the course website
webuse set https://pjakiela.github.io/ECON523/exercises
webuse E1-CohenEtAl-data.dta
```

If you prefer, you can instead download the data set using the link above and save it directly to your computer.  In that case, you would use the `use` command to open the data set in Stata.  

<br>




