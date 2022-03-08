
// ECON 523:  PROGRAM EVALUATION FOR INTERNATIONAL DEVELOPMENT
// PROFESSOR PAMELA JAKIELA
// EMPIRICAL EXERCISE 3 (IN-CLASS WARM-UP ACTIVITY)

/*****************************************************************************
In this exercise, we're going to analyze data from Ignaz Semmelweis' handwashing
intervention in the maternity hospital in Vienna.  The data come from 
Semmelweis' (1861) book, and some helpful person put them on Wikipedia.
We'll be reading them in from excel using the import excel command.
******************************************************************************/

// INSTALL BLINDSCHEMES IF YOU HAVE NOT ALREADY
* findit blindschemes // comment this out once it is installed
* exit


// IMPORT RAW DATA FROM EXCEL - ONLY NEED TO RUN THE FIRST TIME

clear all 
set scheme s1mono 
set more off
set seed 314159
version 16.1

** change working directory as appropriate to where you want to save
cd "C:\Users\pj\Dropbox\econ523-2022\exercises\E3-DD1"

** load the data from the course website
import excel using E3-Semmelweis1861-data.xlsx, sheet("ViennaBothClinics") first

** label the variables
la var Births1 "Births in Division 1 (Treatment Group)"
la var Deaths1 "Deaths in Division 1 (Treatment Group)"
la var Rate1 "Mortality Rate in Division 1 (Treatment Group)"
la var Births2 "Births in Division 2 (Comparison Group)"
la var Deaths2 "Deaths in Division 2 (Comparison Group)"
la var Rate2 "Mortality Rate in Division 2 (Comparison Group)"

** save the data locally as a stata dta file 
** this is also a good time to save your do file
save E3-semmelweis-vienna-by-wing.dta, replace

/*
twoway (connected Rate1 Year, color(vermillion) msymbol(o) msize(small) lw(thin)) /// 
	(connected Rate2 Year, color(sea) msymbol(t) msize(small) lw(thin)), ///
	ylabel(0(5)20) ytitle("Maternal Mortality (Percent)" " ") ///
	xlabel(1830(5)1860) xtitle(" ") ///
	legend(label(1 "Doctors' Wing") label(2 "Midwives' Wing") col(1) ring(0) pos(2))
*graph export vienna-by-wing-fig1.png, replace
*/


// TO BE DONE TOGETHER IN CLASS

 
// Use the list command to list the the notes contained in the data set by year.   If you only want to list the rows of data that include a note (i.e. where the `Note` variable is non-missing), you can add `if Note!=""`) at the end of the command.  



// In what year did the hospital first move to the system where patients in Division 1 were treated by doctors and patients in Division 2 were treated by midwives?  Drop the observations (years) before this happened using the drop command.


// Generate a "post" variable equal to one for years after the handwashing policy was implemented (and zero otherwise).  What is the mean postpartum mortality rate in the doctors' wing prior to the implementation of the handwashing policy?


// Now let's put this result in a table!  We're going to use the `putexcel` command to write our results into an Excel file.  `putexcel` is a simple command that allows you to write Stata output to a particular cell or set of cells in an Excel file.  Before getting started with `putexcel`, use the `pwd` ("print working directory") command in the Stata command window to make sure that you are writing your results to an appropriate file.  Then set up the Excel file that will receive your results using the commands:

putexcel set E3-DD-table1.xlsx, replace
putexcel B1="Treatment", hcenter bold border(top)
putexcel C1="Control", hcenter bold border(top)
putexcel D1="Difference", hcenter bold border(top)
putexcel A2="Before Handwashing", bold
putexcel A4="After Handwashing", bold
putexcel A6="Difference", bold

// Now we can add the mean of the variable `Rate1` for the years prior to the introduction of handwashing.  Remember that you can always use the "return list" command after a command like "summarize" to see what statistics the summarize command stored in Stata's short-term memory as locals.  Any of these statistics can be exported to Excel.

sum Rate1 if post==0
return list
putexcel B2=`r(mean)', hcenter nformat(#.##)


// We can calculate the standard error of the mean by taking the standard deviation (reported by the `sum` command) and dividing it by the square root of the number of observartions (also reported by the `sum` command).  What is the standard error of the mean postpartum mortality rate in the doctors' wing prior to Semmelweis' handwashing intervention?

local temp_se = r(sd)/sqrt(r(N)) 
putexcel B3=`temp_se', hcenter nformat(#.##)

// If we wanted to have our standard error appear in parentheses, we'd need to format the number correctly before exporting. We could do this using the following commands, which generate a local macro in string rather than numeric format:

local temp_se = string(r(sd)/sqrt(r(N)),"%03.2f")
putexcel B3="(`temp_se')", hcenter nformat(#.##)


// EMPIRICAL EXERCISE

// NOTE:  This empirical exercise differs from previous ones in that you will be graded based on your (Stata) code and your final output (the Excel table).  You will not be asked to enter any numbers into gradescope (but you do need to upload your do file and Excel output there after you finish the exercise).


// Question 1

//	You can also get the standard error of a mean using Stata's `ci means` command.  Use the command `ci means Rate1 if post==0` to confirm that your standard error calculation (above) is correct.   What local macros are stored after you run the `ci means` command?


// Question 2

// Use the `ci means` command to calculate the mean and standard error for the other three cells required for difference-in-differences analysis:  the treatment group in the post-treatment period, the control group in the pre-treatment period, and the control gorup in the post-treatment period.  Export these results to Excel using the `putexcel' command.


// Question 3

// Now run a t-test of the hypothesis that the mean maternal mortality rate in Division 1 was the same in the pre-treatment and post-treatment periods (using the `t-test` command).  You will need to calculate the difference in means as the difference between the locals `r(mu_1)` and `r(mu_2)`, which are stored in Stata after the `ttest` command.  Export the estimated difference in means and the estimated standard error of the difference in means to Excel.



// Question 4

// Now do the same for Division 2:  run a t-test of the hypothesis that the mean maternal mortality rate in Division 2 was the same in the pre-treatment and post-treatment periods, and Export your estimated difference in means to Excel together with the associated standard error.
 


// Question 5 

// Next, we want to test the hypothesis that the mean maternal mortality rate was the same in Division 1 and Division 2 prior to the handwashing intervention.  One approach is to do the calculations ourselves using the formulas.  We know the sample mean of the `Rate1` variable in the pre-treatment period, and we know how to use Stata to find the standard error of that mean (and, in fact, we have already recorded this standard error in our Excel table).  We also know the mean of the Rate2 variable and the associated standard error for the pre-treatment period.  Since these two means are independendent random variables, we know that the standard error of the estimated difference in means is the square root of the squared standard errors of the individual means.  Write a few lines of Stata code that would generate locals equal to the estimated difference in means and the standard error of that estimated difference.



// Question 6

// We can also use the ttest command to test that the means of two variables are equal - you can read about this in the help file for `ttest`.  Confirm that the command `ttest Rate1 = Rate2 if post==0, unpaired unequal` yields the same estimated difference in means and standard error that you calculated in Question 5. Then export your estimated difference in means and standard error to Excel.



// Question 7

// Now use the `ttest` command to calculate the estimated difference in maternal mortality between Division 1 and Division 2 in the post-treatment period.  Export your difference in means and the associated standard error to Excel.



// Question 8

// Write Stata code to calculate the difference-in-differences estimator of the treatment effect of handwashing and export your results to Excel. 



// Question 9 

// Write Stata code to calculate the standard error of the difference-in-differences estimator of the treatment effect of handwashing and export your results to Excel.  Assume that the four cell means (treatment X pre, treatment X post, control X pre, control X post) are independent random variables.



