
// ECON 523:  PROGRAM EVALUATION FOR INTERNATIONAL DEVELOPMENT
// PROFESSOR PAMELA JAKIELA
// EMPIRICAL EXERCISE 2:  REGRESSION

/***************************************************************************

This exercise makes use of the data set E2-BanerjeeEtAl-data.dta, 
a subset of the data used in the paper "A multifaceted program causes 
lasting progress for the very poor:  Evidence from six countries" by Abhijit 
Banerjee, Esther Duflo, Nathanael Goldberg, Dean Karlan, William Pariente, 
Jeremy Shapiro, Bram Thuysbaert, and Chris Udry, published in Science in 2015.  

The authors examine the impacts of a "graduation" program first designed by 
the Bangladeshi NGO BRAC.  The program offers extremely poor households an 
asset transfer, temporary consumption support, skills training, home visits, 
and access to savings technologies.  The program was evaluated through a 
randomized trial in six countries.  

In this exercise, we use data on the program's impacts on food security to 
explore the mechanics of fixed effects.

******************************************************************************/

** preliminaries
clear all 
set more off
set seed 12345

** load the data from the course website
webuse set https://pjakiela.github.io/ECON523/exercises
webuse E2-BanerjeeEtAl-data.dta

exit


// IN-CLASS ACTIVITY

// 1. Familiarize yourself with the data set.  How many countries are included in the study, and how many observations are there in each country?  What fraction of the observations from each country were treated?

// 2. Take a look at the outcome variable e_foodsec.  What is the mean value in each country?  What is the mean value *in the treatment group* in each country?  What does a histogram of the food security index look like?


// 3. Regress food security on treatment.  What do you find?  How should we interpret this coefficient?


// 4. Now regress food security on treatment controlling for country fixed effects (by adding i.country) to the regression.  How do the results change?


// 5. What if we regress food security on treatment separately for each country?  In how many of the six countries do we see a positive and statistically significant treatment effect?  


// 6. (SKIP THIS ONE.)  The regression including country fixed effects is equivalent to a regression where we first subtract off country-specific means and then regress de-meaned (or normalized) food security on normalized treatment.  Show that this is the case.  (hint:  use egen)


// 7. (SKIP THIS ONE TOO.) The regression including country fixed effects is also equivalent to a regression of residualized food security (predicted from a regression of food security on country fixed effects) on residualized treatment (predicted the same way).  Show that this is the case.  (hint:  use predict)


// 8.  The regression including country fixed effects is also equivalent to a weighted average of the country-specific treatment effects.  The weights are proportional to N*p*(1-p) where N is the number of observations in a country and p is the proportion treated in that country.  The weights are normalized by dividing by the sum of all the weights.  Extend the program below to calculate the treatment effect that you would get from a regression controlling for fixed effects.

gen T_mean = .
gen C_mean = .
gen p = .
gen N = .

forvalues i = 1/6 {
	sum e_foodsec if treatment==1 & country==`i'
	replace T_mean = r(mean) in `i'
	sum e_foodsec if treatment==0 & country==`i'
	replace C_mean = r(mean) in `i'
	sum treatment if country==`i'
	replace p = r(mean) in `i'
	count if country==`i'
	replace N = r(N) in `i'
}

gen weight = N*p*(1-p)
egen sum_weights = total(weight)
replace weight = weight / sum_weights
drop sum_weights


