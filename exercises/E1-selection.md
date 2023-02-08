# Empirical Exercise 1

This exercise makes use of the data set [E1-CohenEtAl-data.dta](https://pjakiela.github.io/ECON523/exercises/E1-CohenEtAl-data.dta), 
a subset of the data used in the 
paper [Price Subsidies, Diagnostic Tests, and Targeting of Malaria Treatment: Evidence from a Randomized Controlled Trial](https://www.aeaweb.org/articles?id=10.1257/aer.20130267) 
by Jessica Cohen, Pascaline Dupas, and Simone Schaner, published in the _American Economic Review_ in 2015.  The authors examine behavioral responses to 
various discounts ("subsidies") for malaria treatment, called "artemisinin combination therapy" or "ACT."  An overview of the randomized evalaution is available [here](https://www.povertyactionlab.org/sites/default/files/publication/2011.12.15-Subsidizing-Malaria.pdf).  

The goal of this exercise is to review the different approaches to testing for differences in means across groups defined by a dummy variable, for example a randomly-assigned treatment.  We will review the Stata command `ttest`, `regress`, and `ci`.  

You can access the in-class activity (below) as a [do file](https://github.com/pjakiela/ECON523/tree/gh-pages/exercises/in-class1.do) or [pdf](h[ttps://pjakiela.github.io/exercises/](https://github.com/pjakiela/ECON523/tree/gh-pages/exercises/)ECON-523-in-class1.pdf).  

You can also access the main empirical exercise (also below) as a [do file](https://github.com/pjakiela/ECON523/tree/gh-pages/exercises/E1-questions.do) or [pdf](https://github.com/pjakiela/ECON523/tree/gh-pages/exercises/ECON-523-ex1.pdf).

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
cd "C:\Users\CookieMonster\Dropbox\ECON-523\exercises\E1-selection"
```

Because the data set is available on github, you can simply download it every time you want to use it.  The following code in the do file will do this:  

```
** load the data from the course website
webuse set https://pjakiela.github.io/ECON523/exercises
webuse E1-CohenEtAl-data.dta
```

If you prefer, you can instead download the data set using the link above and save it directly to your computer.  In that case, you would use the `use` command to open the data set in Stata.  

<br>

## In-Class Activity

Extend your do file as you answer the following questions, so that you can run the code from start to finish and re-generate all your answers.

### Question 1  

How many variables are in the data set?  (hint: use `describe`, or `desc` for short)

### Question 2  

How many observations are in the data set?  (hint: use `count`)

### Question 3

What does the variable `act_any` measure?  (hint: use `describe` or `codebook`)

### Question 4

What is the mean of `act_any` to three decimal places?  (hint: use `summarize`, or `sum` for short)

### Question 5

How many people received subsidized malaria treatment? (hint:  use `tabulate`, or `tab` for short)

### Question 6

What does the variable `c_act` measure?

### Question 7

What is the mean of the variable `c_act`?

### Question 8 

What is the standard deviation of the variable `c_act`?

### Question 9

What is the standard error of the mean of `c_act`? (hint: use the `ci means` command)

### Question 10  

What is the mean level of ACT use among those assigned to the treatment group?  (hint:  use an `if` statement)

### Question 11

Variables starting with `b_` are baseline characteristics (measured before the RCT).  Use the summarize command to familiarize yourself with these variables.  How many baseline variables are included in the data set?  Which ones are missing data for some households in the sample? (hint:  use `sum b_*`)

### Question 12

We're going to look at selection bias by comparing the level of educational attainment among households that choose to use ACT treatment when they have malaria.  Use the `ci means` command to obtain the mean and standard error of `b_h_edu` when `c_act==1` and when `c_act==0`.  Using these quantities, calculate the estimated difference in means and its standard error.

### Question 13

Now compare your results to what you obtain using the the `ttest` command.

### Question 14

Why does the standard error you calculated using the output from `ci means` not match the results of the `ttest` command? How can you modify the `ttest` command so that your results line up with your answer to Question 12?  (hint:  look at the help file for `ttest` if needed)

### Question 15

Confirm that you can also replicate your results from Q12 using the regress command withe the `, vce(hc2)` option.

<br>

## Empirical Exercise

<br>

 ---
 
 This exercise is part of the module [Selection Bias and the Experiental Ideal](https://pjakiela.github.io/ECON523/M1-selection.html).


