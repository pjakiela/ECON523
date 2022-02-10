# Empirical Exercise 1

This exercise makes use of the data set [E1-CohenEtAl-data.dta](https://pjakiela.github.io/ECON523/exercises/E1-CohenEtAl-data.dta), 
a subset of the data used in the 
paper [Price Subsidies, Diagnostic Tests, and Targeting of Malaria Treatment: Evidence from a Randomized Controlled Trial](https://www.aeaweb.org/articles?id=10.1257/aer.20130267) 
by Jessica Cohen, Pascaline Dupas, and Simone Schaner, published in the _American Economic Review_ in 2015.  The authors examine behavioral responses to 
various discounts ("subsidies") for malaria treatment, called "artemisinin combination therapy" or "ACT."  An overview of the randomized evalaution is available [here](https://www.povertyactionlab.org/sites/default/files/publication/2011.12.15-Subsidizing-Malaria.pdf).

The aim of this empirical exercise is to review key Stata commands.  Please upload your answers to gradescope after completing the exercise.  You can also download the activity 
as a [do file](https://pjakiela.github.io/ECON523/exercises/E1-questions.do) or a [pdf](https://pjakiela.github.io/ECON523/exercises/E1-questions.pdf).  

<br>

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

<br>

## Stata Commands  

In this exercise, we'll use the Stata commands `count`, `summarize` (`sum` for short), `tabulate` (`tab` for short), and `regress` (`reg` for short).  If you are unfamiliar with any of these commands, use type `help` followed by the name of the command (for example, `help sum`) to link to the relevant help page.  

You may also want to use the `display` command (`di` for short) to do simple math in Stata.  For example, if you type 
```
di 24/8
```
Stata will return the number 3 in answer to your question.  

<br>

## Empirical Exercise  
  
### Question 1

How many observations are in the data set?  

### Question 2  

What is the mean of the variable act_any (to three decimal places)?  

### Question 3  

The variable `act_any` is a dummy for assignment to any treatment (positive subsidy).  How many people received a positive subsidy?  

### Question 4  

What is the standard deviation of the variable `c_act`?  

### Question 5  

The variable `c_act` is a dummy for using ACT treatment during a malaria episode.  How many respondents report using ACT treatment for malaria?  

### Question 6  

Regress `c_act` on `act_any`.  What is the R-squared?  

### Question 7  

What is the coefficient associated with the `act_any` variable?  

### Question 8  

What is the associated standard error?  

### Question  

What do you get when you divide the coefficient by the standard error?  

### Question 10  

What is the t-statistic associated with the `act_any` variable?  

<br>

## Even More Fun with Stata  

Use the `describe`, `summarize`, and `tabulate` commands to familiarize yourself with the other variables in the data set.   What are the mean and median levels of education among household heads?  What proportion of households live more than 2 km from the nearest chemist? For how many obesrvations is information on household size, the education level of the household head, and distance to the nearest chemist missing?
  
Calculate the mean of `c_act` in the treatment group (observations with `act_any==1`) and in the comparison group (observations with `act_any==0`).  How do these means relate to your regression results above, when you regressed `c_act` on `act_any`?  

Now use the `ttest` command to test the hypothesis that the mean of `c_act` is the same in the treatment and comparison groups.  How do these results compare to your regression results?  

The variable `coartemprice` indicates the randomly-assigned ACT price (and, implicitly, the associated level of price subsidy).  What price/subsidy levels are included in the experiment?  

The variables `act40`, `act60`, `act100`, and `act500` are dummies for individual randomly assigned prices/treatments.  Summarize the mean level of `c_act` in each of the treatment arms (you already summarized the mean of `c_act` in the treatment group above).  

Regress `c_act` on the dummies for the three subsidy levels (`act40`, `act60`, `act100`).  How do the regression results compare to the means that you calculated for each treatment group?

Convince yourself that the OLS coefficient from Question 7 is the weighted average of the coefficients from the regression you just estimated.  What are the weights? 

<br>

   ---
  
This exercise is part of [Module 1:  Why Evaluate?](https://pjakiela.github.io/ECON523/M1-why-evaluate.html).
