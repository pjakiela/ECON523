
// ECON 523:  PROGRAM EVALUATION FOR INTERNATIONAL DEVELOPMENT
// PROFESSOR PAMELA JAKIELA
// EMPIRICAL EXERCISE 2:  THE EXPERIMENTAL IDEAL

/***************************************************************************
This exercise makes use of the data set E1-CohenEtAl-data.dta, 
a subset of the data used in the paper "Price Subsidies, 
Diagnostic Tests, and Targeting of Malaria Treatment: Evidence from a 
Randomized Controlled Trial" by Jessica Cohen, Pascaline Dupas, and Simone 
Schaner, published in the American Economic Review in 2015.  

The authors examine behavioral responses to various discounts (""subsidies) 
for malaria treatment, called "artemisinin combination therapy" 
or "ACT."
******************************************************************************/

// LOAD DATA

clear all 
set more off
set seed 12345
version 16.1 // feel free to use version 17.0 instead

** change working directory as appropriate to where you want to save
cd "C:\Users\pj\Dropbox\econ523-2022\exercises\E2-experimental-ideal-part1"

** load the data from the course website
webuse set https://pjakiela.github.io/ECON523/exercises
webuse E1-CohenEtAl-data.dta

** save the raw data so that you have a local copy
save E2-CohenEtAl-data-my-raw-data-copy, replace


// GETTING STARTED (TO BE DONE TOGETHER AS A CLASS)

/*

key variables (review):

- variables starting with b_ are baseline characteristics (measured before the RCT)
		use the command sum b_* to familiarize yourself with them

- act_any is a treatment dummy; act_any==0 is the control group

- c_act is a dummy for using ACT treatment the last time a HH member had malaria

*/

** We are going to test whether individuals *in the control group* who use ACT when they have malaria (i.e. individuals with `c_act==1`) differ from those in the control group who do not use ACT (i.e. those with `c_act==0`) in terms of observable characteristics.  To focus on individuals in the control group, we'll want to restrict ourselves to data points with `act_any==0` when answer the following questions.  

// Question 1  

 ** Use the `ttest` command to test whether individuals in the control group who use ACT when they have malaria (i.e. individuals with `c_act==1`) differ from those in the control group who do not use ACT when they have malaria in terms of the educational attainment of their head of household.  What Stata command would you use to do this?  
 


// Question 2  

** What is the mean level of (household head) educational attainment among individuals in the control gorup who **did not** use ACT the last time they had malaria?



// Question 3  

** What is the mean level of (household head) educational attainment among individuals in the control gorup who **did** use ACT the last time they had malaria?



// Question 4  

** What is the standard deviation of the level of (household head) educational attainment among individuals in the control group who **did** use ACT the last time they had malaria?  



// Question 5  

** Is there a statistically significant difference in educational attainment between those (in the control group) who used ACT the last time they had malaria and those who did not?  What is the p-value associated with this hypothesis test?



// Question 6  

** What is the estimated difference in educational attainment between those (in the control group) who used ACT the last time they had malaria and those who did not?  



// Question 7  

** What is the standard error associated with the estimated difference in educational attainment between those (in the control group) who used ACT the last time they had malaria and those who did not?  


// Question 8  

** To understand where this standard error comes from, remember that the mean value of `b_h_edu` among people who do (or do not) have `c_act==1` is a random variable, as is the difference in means between those who have `c_act==1` and those who have `c_act==0`.  The variance of the **difference** of two independent random variables is the **sum** of their individual variances, so the variance of the difference in `b_h_edu` between those with `c_act==1` and those with `c_act==0` is the sum of the variances of the subgroup means.  (And, of course, the standard error is the square root of the variance.)  If you used the results of your `ttest` command to calculate the standard error of the difference in means "by hand" (by which I mean, using Stata to do arithmetic instead of using the `ttest` command), what answer would you arrive at?



// Question 9 

** If you have answered Question 8 correctly, you be wondering why the standard error you just calculated differs (slightly) from the one reported by the `ttest` command.  The answer is that our "by hand" calculation did not assume that the variance of `b_h_edu` was the same in both groups, but Stata's `ttest` command does impose that assumption -- unless you add the `unequal` option.  Trying redoing your `ttest` with `unequal` at the end.  What is the estimated standard error on the difference in means now?



// Question 10  

** We can also test whether the mean of a variable (`b_h_edu`) is the same in two groups by regressing it on a dummy characterizing the two groups.  What command would you use to regress `b_h_edu` on `c_act`, restricting the sample to the control group in the RCT?




// Question 11  

** When you run this regression, what is the estimated coefficient on `c_act`?  



// Question 12 

** What is the estimated standard error associated with the coefficient on `c_act`?  



// Question 13 

** How does the standard error from your regression compare to the standard error you got when you used the `ttest` command?


// Question 14

** When we run a simple OLS regression, Stata assumes that errors are **homoskedastic** (the variance of the error term does not vary across observations).  As an alternative, we can add `, robust` at the end of our regression command to tell Stata to calculated heteroskedasticity-robust standard errors (which are the default in most applied microeconomic research).  Rerun your regression, adding `, robust` at the end.  What is the estimated standard error associated with the coefficient on `c_act` now? 


// Question 15 

** You might (quite reasonably) be surprised to learn that the standard error reported after an OLS regression with robust standard errors is **not** the same as the one we calculated ourselves using the formula.  So, now we have three different standard errors!  The **robust** standard error from Question 14 differs from the standard error that you calculated by hand in Question 8 because of a degrees of freedom correction -- Stata's robust standard errors are but one of several different variants of the Huber-Eicker-White heteoskedasticity robust standard error.  Type 

reg b_h_edu c_act if act_any==0, vce(hc2)

**and confirm that your standard error matches the answer to Question 8.  What is that standard error? 



