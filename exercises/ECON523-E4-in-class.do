
// ECON 523:  PROGRAM EVALUATION FOR INTERNATIONAL DEVELOPMENT
// PROFESSOR PAMELA JAKIELA
// EMPIRICAL EXERCISE 4:  IN-CLASS ACTIVITY

/*****************************************************************************
In this exercise, we're going to be replicating specifications from "Does a ban 
on informal health providers save lives? Evidence from Malawi" by Professor 
Susan Godlonton and Dr. Edward Okeke.  The data set E5-GodlontonOkeke-data.dta 
contains information (from the 2010 Malawi Demographic and Health Survey) on 
19,680 live births between July 2005 and September 2010.  Each observation 
represents a birth.  Before getting started, you will need to download the data 
set onto your laptop.  
******************************************************************************/

// PRELIMINARIES

clear all
set more off
set scheme s1mono
set seed 123456

cd "C:\mypath\ECON-523\topics\4-DD2\stata"
use "data\E4-GodlontonOkeke-data.dta"

exit

// QUESTIONS

// 1. To implement difference-in-differences, we need: a dummy variable for the post treatment period, a dummy variable for the treatment group, and an interaction between the two. The post variable is already present in the data set. What is the mean of the post variable? What fraction of the observations in the data set occur in the post-treatment period?

// 2. The time variable indicates the month and year in which a birth took place. If you type the command desc time, you'll see information about how the variable time is formatted.  Notice that the time variable is formatted in Stata's date format: it is stored as a number, but appears as a month and year when you describe or tabulate it.


// 3. Use the tab command to see how Professor Godlonton and Dr. Okeke define the post-treatment time period in their analysis. What is the first treated month?


// 4. We need to define an indicator for the treatment group. Professor Godlonton and Dr. Okeke define the treatment group as DHS clusters (i.e. communities) that were at or above the 75th percentile in terms of use of TBAs prior to the ban. Data on use of TBAs comes from the DHS question "Who assisted with the delivery?"  Responses have been converted into a set of different variables representing the different types of attendants who might have been present at the birth. Tabulate (using the tab command) the m3g variable, which indicates whether a woman indicated that a TBA was present at a birth. What pattern of responses do you observe?

// 5. We want to generate a dummy variable that is equal to one if a TBA was present at a particular birth, equal to zero if a TBA was not present, and equal to missing if a woman did not answer the question about TBAs.  There are several different ways to do this in Stata. One is to use the recode command (below).  This generates a new variable, tba, that is the same as the m3g variable except that tba is equal to missing for all observations where m3g is equal to 9. (It is usually better to generate a new variable instead of modifying the variables in your raw data set, because you don't want to make mistakes that you cannot undo.)  

recode m3g (9=.), gen(tba)

// 6. Confirm that your new variable, tba, is a dummy variable. Use the tab command to tabulate the observed values of tba (the m option tells Stata to tabulate the number of missing values in addition to the other values).


// 7. We want to generate a treatment dummy - an indicator for DHS clusters where use of TBAs was at or above the 75th percentile prior to the ban. How should we do it? The variable dhsclust is an ID number for each DHS cluster. How many clusters are there in the data set?


// 8. We can use the egen command to generate a variable equal to the mean of another variable, and we can use egen with the bysort option to generate a variable equal to the mean within different groups:

bysort dhsclust:  egen meantba = mean(tba)

// 9. However, this tells us the mean use of TBAs within a DHS cluster over the entire sample period, but we only want a measure of the mean in the pre-ban period. How can we modify the code above to calculate the level of TBA use prior to the ban?


// 10. Summarize your meantba variable using the detail or d option after the sum command so that you can calculate the 75th percentile of TBA use in the pre-ban period. As we've seen in earlier exercises, you can use the return list command to see which locals are saved when you run the summarize command.  Define a local macro cutoff equal to the 75th percentile of the variable meantba.  Then immediately create a new variable high_exposure that is an indicator for DHS clusters where the level of TBA use prior to the ban exceeded the cutoff we just calculated. 


// 11. At this point, meantba is only non-missing for births (ie observations) in the pre-treatment period. Modify the code so that you only define high_exposure for births where the meantba variable is non-missing.  Then we need to replace the missing values of high_exposure in the post-treatment period with the correct ones (based on the values in the same cluster in the pre-treatment period),  Here are three lines of code that will fix it:

bys dhsclust:  egen maxtreat = max(high_exposure)
replace high_exposure = maxtreat if high_exposure==. & post==1 & tba!=.
drop maxtreat

// 12. Tabulate your high_exposure variable to make sure that it is only missing for observations with the tba variable missing. What is the mean of high_exposure?


// 13. The last variable we need to conduct difference-in-differences analysis is an interaction between our treatment variable, high_exposure, and the post variable. Generate such a variable. I suggest calling it highxpost. You should also label your three variables:  high_exp, post, and highxpost.


// 14. Now you are ready to run a regression.  Regress the tba dummy on high_exp, post, and highxpost.  What is the difference-in-differences estimate of the treatment effect of the TBA ban on use of informal birth attendants?  How do your results compare to those in Table 5, Panel A, Column 1 of the paper?


// 15. Read the notes below Table 5.  See if you can modify your regression command so that your results are precisely identical to those in the paper.







// VARIABLES NEEDED FOR ANALYSIS

recode m3g (9=.), gen(tba)
bys dhsclust:  egen meantba = mean(tba) if post==0

sum meantba, d
local cutoff = r(p75)
gen high_exposure = meantba>=`cutoff' if post==0

bys dhsclust:  egen maxtreat = max(high_exposure)
replace high_exposure = maxtreat if high_exposure==. & post==1 
drop maxtreat

gen highxpost = high_exposure*post


// TABLE 2, COLUMNS 1 AND 2

/*
keep if post==0
egen trend = group(time)

gen highxtrend = high_exp * trend

reg tba high_exp trend highxtrend i.district, cluster(district)
*/

// TABLE 4

areg twin i.dist high_exp post highxpost, absorb(time) cluster(district)


exit


// REPLICATING ONE COEFFICIENT

reg tba high_exp post highxpost

reg tba i.time i.district highxpost high_exp

reg tba i.time i.district highxpost high_exp, cluster(district)


// EMPIRICAL EXERCISE

** In the remainder of this exercise, we will be estimating the impact of Malawi's ban on traditional birth attendants on the use of formal sector providers (aka skilled birth attendants or SBAs). The variable sba is an indicator for use of (wait for it) an SBA. Estimates of the impact of the TBA ban on use of SBAs are reported in Panel B of Table 5 in Godlonton and Okeke (2015).

** Before we begin, we're going to set up an Excel file where we can record our results. Our coefficient of interest is the highxpost variable, which is the interaction between the post dummy and the high_exposure dummy. Our regression table will only record this coefficient. Add the following Stata code to your do file to set up your Excel file that will receive your coefficient estimates.

putexcel set E4-DD-table.xlsx, replace
putexcel B1="(1)", hcenter bold border(top)
putexcel C1="(2)", hcenter bold border(top)
putexcel D1="(2)", hcenter bold border(top)
putexcel A2="High Exposure x Post", bold
putexcel A4="Observations", bold border(bottom)


// QUESTION 1

** Test the hypothesis that the proportion of women giving birth in the presence of a skilled birth attendant increased after Malawi introduced the ban on TBAs. What is the t-statistic associated with this hypothesis test?

ttest sba, by(post)


// QUESTION 2

** Estimate a simple 2x2 difference-in-differences specification to measure the impact of Malawi's TBA ban on the use of SBAs.  Your regression should include the `post` dummy, the `high-exposure` (i.e. treatment) dummy, and the `highxpost` interaction term (and no other independent variables).  What is the estimated coefficient of interest (ie the coefficient on `highxpost`)?  

reg sba post high_exp highxpost
display _b[highxpost] // answer:  0.145

exit

// QUESTION 3

** To export our regression coefficients to Excel, we first need to save our regression results to a matrix in Stata. We will do this with the command

matrix V = r(table)

** The r(table) refers to Stata's default way of storing regression results; the command defines a matrix V containing the regression results. Type matrix list V into the command window to see this matrix.

** You can see that the matrix is 9 rows tall. The number of columns is one plus the number of variables included in our regression. The first row contains the coefficient estimates, the second row contains the standard errors, the third row contains the t-statistics, and the fourth row contains the p-values.

** If we estimated our regression using the command

reg sba post high_exp highxpost
matrix V = r(table)

** then our coefficient of interest is the third variable in the regression. This means that the coefficient estimate, standard error, etc. are stored in the third column of the matrix V. To export the coefficient estimate to cell B2 in Excel, we can use the commands:

local my_coef = round(V[1,3],0.001)
putexcel B2 = "`my_coef'", hcenter

** where V[1,3] refers to the cell of the matrix V in the first column and the third row. Implement this code, making sure that you are successfully exporting your regression coefficient of interest.


// QUESTION 4

** Now write the standard error associated with the regression coefficient on highxpost to cell B3 in your Excel file.

local my_se = round(V[2,3],0.001)
putexcel B3 = "(`my_se')", hcenter


// QUESTION 5

** Use the code below (after your regression) to export the number of observations to cell B4 in your Excel file:

putexcel B4 = `e(N)', hcenter


// QUESTION 6

** Now re-run your diff-in-diff estimation replacing the post variable with time fixed effects. What is the estimated coefficient on high_exposure now? Write your coefficient on highxpost, the associated standard error, and the number of observations to Column C in your Excel file.

reg sba high_exp highxpost i.time

local my_coef = round(V[1,1],0.001)
putexcel c2 = "`my_coef'", hcenter

local my_se = round(V[2,1],0.001)
putexcel C3 = "(`my_se')", hcenter

putexcel C4 = `e(N)', hcenter


// QUESTION 7

// As we saw above, Professor Godlonton and Dr. Okeke also include district 
//		fixed effects.  Re-run your diff-in-diff estimation including these 
//		as well.  What is the estimated coefficient on highxpost now?

reg sba high_exp highxpost i.time i.district

local my_coef = round(V[1,1],0.001)
putexcel D2 = "`my_coef'", hcenter

local my_se = round(V[2,1],0.001)
putexcel D3 = "(`my_se')", hcenter

putexcel D4 = `e(N)', hcenter

