
// ECON 523:  PROGRAM EVALUATION FOR INTERNATIONAL DEVELOPMENT
// PROFESSOR PAMELA JAKIELA
// EMPIRICAL EXERCISE 1:  THE EXPERIMENTAL IDEAL

/***************************************************************************

This exercise makes use of the data set E1-CohenEtAl-data.dta, 
a subset of the data used in the paper "Price Subsidies, 
Diagnostic Tests, and Targeting of Malaria Treatment: Evidence from a 
Randomized Controlled Trial" by Jessica Cohen, Pascaline Dupas, and Simone 
Schaner, published in the American Economic Review in 2015.  

The authors examine behavioral responses to various discounts ("subsidies") 
for malaria treatment, called "artemisinin combination therapy" 
or "ACT."

******************************************************************************/

// PRELIMINARIES

clear all 
set scheme s1mono 
set more off
set seed 12345

** change working directory as appropriate to where you want to save
cd "C:\Users\pj\Dropbox\ECON-523\topics\1-selection\stata\results"

** load the data from the course website
webuse set https://pjakiela.github.io/ECON523/exercises
webuse E1-CohenEtAl-data.dta


// ONE TREATMENT DUMMY

// 1a. Summarize the mean level of ART use (the variable c_act) in the randomly assigned treatment group (act_any==1) and the randomly assigned comaprisong group (act_any==0).  


// 1b. Conduct a t-test of the hypothesis that treatment (act_any) does not impact the likelihood of using ARTs (using the ttest command).  


// 1c. Test the hypothesis that treatment (act_any) does not impact the likelihood of using ARTs using the regress command.


// MULTIPLE TREATMENTS

// 2a. The variable coartemprice indicates the randomly-assigned ACT price (and, implicitly, the associated level of price subsidy).  What price/subsidy levels are included in the experiment?


// 2b. If you place the code "bysort coartemprice: " before the summarize command, Stata will summarize your value of interest separately for each observed value of the variable coartemprice.  What is the mean level of ART use at each subsidy level, and how do these levels compare to the level observed in the control group?  


// 2c.  Now regress c_act on the dummies act40, act60, and act100, which indicate the three different randomly-assigned subsidy levels in the RCT.  What do you expect the regression coefficients to be (based on your answer to 2b).  Do they observed coefficients match your expectations?



// POOLING TREATMENT ARMS

// 3a.  Can you figure out a way to get Stata to tell you how many treated observations are in each (of the three) treatment arms using a single line of Stata code?


// 3b. Stata's "display" command is useful for doing arithmetic.  Calculate a weighted average of the regression coefficients from Question 2c, where the weights are the proportion of treated observations in each of the three arms.  


// 3c. Where have you seen this coefficient before?






