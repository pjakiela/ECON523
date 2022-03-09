
// ECON 523:  PROGRAM EVALUATION FOR INTERNATIONAL DEVELOPMENT
// PROFESSOR PAMELA JAKIELA
// EMPIRICAL EXERCISE 4

/*****************************************************************************
In this exercise, we're going to be replicating specifications from "Does a ban on informal health providers save lives? Evidence from Malawi" by Professor Susan Godlonton and Dr. Edward Okeke.  The data set E5-GodlontonOkeke-data.dta is available on glow.  It contains information (from the 2010 Malawi Demographic and Health Survey) on 19,680 live births between July 2005 and September 2010.  Each observartion represents a birth.

FIX  The table summarizes the 
impact of Malawi's 2007 ban on the use of traditional birth attendants (TBAs) 
on birth outcomes, including both the use of formal sector providers and 
neonatal mortality.
******************************************************************************/

// PRELIMINARIES

clear all
set more off
set scheme s1mono
set seed 123456

cd "C:\Users\pj\Dropbox\econ523-2022\exercises\E4-DD2\"
use "C:\Users\pj\Dropbox\econ523-2022\exercises\E4-DD2\data\E4-GodlontonOkeke-data.dta"


// VARIABLES NEEDED FOR ANALYSIS

recode m3g (9=.), gen(tba)
bys dhsclust:  egen meantba = mean(tba) if post==0

sum meantba, d
local cutoff = r(p75)
gen high_exposure = meantba>=`cutoff' if tba!=. & post==0

bys dhsclust:  egen maxtreat = max(high_exposure)
replace high_exposure = maxtreat if high_exposure==. & post==1 & tba!=.
drop maxtreat

gen highxpost = high_exposure*post


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


// QUESTION 2

** Estimate a simple 2x2 difference-in-differences specification to measure the impact of Malawi's TBA ban on the use of SBAs.  Your regression should include the `post` dummy, the `high-exposure` (i.e. treatment) dummy, and the `highxpost` interaction term (and no other independent variables).  What is the estimated coefficient of interest (ie the coefficient on `highxpost`)?  


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


// QUESTION 5

** Use the code below (after your regression) to export the number of observations to cell B4 in your Excel file:

putexcel B4 = `e(N)', hcenter


// QUESTION 6

** Now re-run your diff-in-diff estimation replacing the post variable with time fixed effects. What is the estimated coefficient on high_exposure now? Write your coefficient on high_exposure, the associated standard error, and the number of observations to Column C in your Excel file.


// QUESTION 7

// As we saw above, Professor Godlonton and Dr. Okeke also include district 
//		fixed effects.  Re-run your diff-in-diff estimation including these 
//		as well.  What is the estimated coefficient on high_exp now?



