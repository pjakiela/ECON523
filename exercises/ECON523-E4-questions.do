// ECON 523:  PROGRAM EVALUATION FOR INTERNATIONAL DEVELOPMENT
// PROFESSOR PAMELA JAKIELA
// EMPIRICAL EXERCISE 4

/*****************************************************************************
In this exercise, we're going to be replicating specifications from "Does a ban 
on informal health providers save lives? Evidence from Malawi" by Professor 
Susan Godlonton and Dr. Edward Okeke.  The data set E5-GodlontonOkeke-data.dta 
contains information (from the 2010 Malawi Demographic and Health Survey) on 
19,680 live births between July 2005 and September 2010.  Each observation 
represents a birth.  Before getting started, you will need to download the data 
set onto your laptop.  Use your answers to the in-class activity to extend the 
do file by generating and labeling the high_exposure and highxpost variables 
needed for analysis. 
******************************************************************************/

// PRELIMINARIES

clear all
set more off
set scheme s1mono
set seed 123456

cd "C:\mypath\ECON-523\topics\4-DD2\stata"
use "data\E4-GodlontonOkeke-data.dta"


// VARIABLES NEEDED FOR ANALYSIS

** insert your code here


// 1. Replicating Column 1 from Tables 5 and 6

// 1a. Estimate a difference-in-differences specification that replicates Table 5, Panel A, Column 1.  Store your results using the eststo command.  


// 1b. Now replicate Table 5, Panel B, Column 1 (the same specification with the sba dummy as the outcome variable) and store your results.


// 1c. Recode the m3h variable to generate a dummy for having a friend or relative as the birth attendant.  Use this variable to replicate Table 6, Panel A, Column 1.  Store your results.


// 1d. Now generate a variable alone that is equal to one minus the maximum of the tba, sba, and friend variables. Use this variable to replicate Table 6, Panel B, Column 1.  Store your results. 


// 1e. Now export your results to word as a nicely formatted table.  Report the R-squared for each specification, and do not report coefficients on the district and time fixed effects (use the indicate option to report which columns include fixed effects, or indicate which fixed effects are used in the table notes).  Report standard errors rather than t-statistics.  Make sure all variables and columns are clearly labeled, and that your labels are not cut off (because they are too long).  


// 2. Next, assess the validity of the common trends assumption by replicating the first two columns of Table 2 (we don't have the outcome data needed to replicate Columns 3 and 4).  

// 2a. Drop the observations from after the ban was in place.  Then generate a trend variable by using the egen command's group option (with the time variable).  Interact the trend variable with the high_exposure variable, and label all of your variables.


// 2b. Replicate columns 1 and 2 to the best of your ability (note:  they will not replicate perfectly).  Store your coefficient estimates.


// 2c. Export your results to word as a nicely formatted table (all of the guidance from Question 1 still applies).  


// 3. How does your replication of Columns 1 and 2 of Table 2 compare to the version that is published in the paper?  Looking at the published version, what might you have noticed about the coefficient(s) that would have suggested that a(n inconsequential) part of the table wouldn't replicate?
