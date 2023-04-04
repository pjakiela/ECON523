
// ECON 523:  PROGRAM EVALUATION FOR INTERNATIONAL DEVELOPMENT
// PROFESSOR PAMELA JAKIELA
// EMPIRICAL EXERCISE 6:  EMPIRICAL EXERCISE

/*****************************************************************************
In this exercise, we'll be using data from the paper The Miracle of Microfinance? Evidence from a Randomized Evaluation by Abhijit Banerjee, Esther Duflo, Rachel Glennerster, and Cynthia Kinnan. The paper reports the results of one of the first randomized evaluations of a microcredit intervention. The authors worked with an Indian MFI (microfinance institution) called Spandana that was expanding into the city of Hyderabad. Spandana identified 104 neighborhoods where it would be willing to open branches. They couldn't open branches in all the neighborhoods simultaneously, so they worked with the researchers to assign half of them to a treatment group where branches would be opened immediately. Spandana held off on opening branches in the control neighborhoods until after the study.

We'll be using a small slice of the data to explore the use of instrumental variables techniques to estimate impacts of treatment on the treated - and to think about when such methods are appropriate.

******************************************************************************/


// PRELIMINARIES

clear all
set more off
set scheme s1mono
set seed 314159

cd "C:\Users\pj\Dropbox\ECON-523\topics\6-TOT\stata"

webuse set https://pjakiela.github.io/ECON523/exercises/
webuse E6-BanerjeeEtAl-data.dta


// We are going to make use of the variables treatment, spandana_1, bizprofit_1, bizrev_1, bizassets_1, and any_biz_1.  Before you begin, add a line to your do file that drops any observations with one of these variables missing.


// QUESTIONS

// Question 1:  Implementing 2SLS

// Use two-stage least squares (2SLS) to estimate an instrumental variables (IV) regression of bizprofit_1 on spandana_1, instrumenting for spandana_1 with the treatment dummy.  Cluster your standard errors at the neighborhood level.   Your estimated coefficient should be identical to your answer from the In-Class Activity.

// Question 2:  2SLS Results

// Now make a table that reports TOT estimates of the impact of Spandana loans on microenterprise profits (the variable bizprofit_1), microenterprise revenues (the variable bizrev_1), microenterprise assets (the variable bizassets_1), and the likelihood of operating a microenterprise (the variable any_biz_1). 

// Part (a)

//  Write the code to set up an excel file that will hold the results of your regressions.  Give the table a title.  Leave space to report the coefficient estimate, the standard error, and the p-value for both the Spandana coefficient and the constant.  Leave space to report the number of observations in each column.

// Part (b) 

// Now modify the program from the In-Class Activity to produce the results needed for your table.  


// Question 3:  The Control Function Approach

// Now make another table that replicates the treatment-on-the treated estimation from Question 2 using the control function approach.  


// Question 4

// Print each of your tables to pdf so that you can upload your finished product(s) to gradescope.

// Question 5 

// Using instrumental variables to estimate treatment effects on the treated makes sense when random assignment to treatment (i.e. inviting someone to participate in a program) has no impact on those who choose not to take up treatment.  Does this approach make sense in the context of microfinance?  Why or why not? 




