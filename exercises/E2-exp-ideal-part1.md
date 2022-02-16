# Empirical Exercise 2, Part 1

Like Empirical Exercise 1, this exercise makes use of the data set [E1-CohenEtAl-data.dta](https://pjakiela.github.io/ECON523/exercises/E1-CohenEtAl-data.dta), 
a subset of the data used in the 
paper [Price Subsidies, Diagnostic Tests, and Targeting of Malaria Treatment: Evidence from a Randomized Controlled Trial](https://www.aeaweb.org/articles?id=10.1257/aer.20130267) 
by Jessica Cohen, Pascaline Dupas, and Simone Schaner, published in the _American Economic Review_ in 2015.  The authors examine behavioral responses to 
various discounts ("subsidies") for malaria treatment, called "artemisinin combination therapy" or "ACT."  An overview of the randomized evalaution is available [here](https://www.povertyactionlab.org/sites/default/files/publication/2011.12.15-Subsidizing-Malaria.pdf).

This exercise has three objectives.  The first is to review the idea of selection bias by showing that individuals who choose to take up a treatment (in this case, 
artemisinin combination treatment, or ACT, for malaria) often differ from those who do not take up treatment (when treatment is not randomized).  In doing so, we will also 
review the different approaches to testing whether the mean of a(n outcome) variable is the same in two groups (defined by another variable).    

Please upload your answers to gradescope after completing the exercise.  You can also download the entire activity 
as a [do file](https://pjakiela.github.io/ECON523/exercises/E2-questions.do).  

<br>

## Getting Started 

The variable `act_any` is a treatment dummy equal to 1 for observations in the treatment group and equal to zero otherwise.  The variable `c_act` is an indicator 
for having used ACT when they last had malaria.  The data set also includes several variables capturing the baseline (i.e. pre-treatment) characteristics of the households in the sample.  These variables all begin with `b_`.  Familiarize yourself with these variables by typing
```
sum b_*
```
to summarize all the variables in the data set that begin with `b_`.

   ---
  
This exercise is part of [Module 2:  Selection Bias and the Experimental Ideal](https://pjakiela.github.io/ECON523/M2-selection-bias.html).
