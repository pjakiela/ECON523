
// ECON 523:  PROGRAM EVALUATION FOR INTERNATIONAL DEVELOPMENT
// PROFESSOR PAMELA JAKIELA
// EMPIRICAL EXERCISE 3:  DIFF-IN-DIFF1 (IN CLASS ACTIVITY)

/*****************************************************************************
In this exercise, we're going to analyze data from Ignaz Semmelweis' handwashing
intervention in the maternity hospital in Vienna.  The data come from 
Semmelweis' (1861) book, and some helpful person put them on Wikipedia.
We'll be reading them in from excel using the import excel command.
******************************************************************************/


// IMPORT RAW DATA FROM EXCEL - ONLY NEED TO RUN THE FIRST TIME

clear all 
set scheme s1mono 
set more off
set seed 314159

** change working directory as appropriate to where you want to save
cd "C:\Users\pj\Dropbox\ECON-523\topics\3-DD1\stata"

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


twoway (connected Rate1 Year, color(dkorange) msymbol(o) msize(small) lw(thin)) /// 
	(connected Rate2 Year, color(midblue) msymbol(t) msize(small) lw(thin)), ///
	ylabel(0(5)20) ytitle("Maternal Mortality (Percent)" " ") ///
	xlabel(1830(5)1860) xtitle(" ") ///
	legend(label(1 "Doctors' Wing") label(2 "Midwives' Wing") col(1) ring(0) pos(2))
graph export vienna-by-wing-fig1.png, replace

exit


// QUESTIONS

// 1. Use the list command to list the the notes contained in the data set by year.   If you only want to list the rows of data that include a note (i.e. where the `Note` variable is non-missing), you can add if Note!="" at the end of the command.  


// 2. In what year did the hospital first move to the system where patients in Division 1 were treated by doctors and patients in Division 2 were treated by midwives?  Drop the observations (years) before this happened using the drop command.


// 3. Generate a "post" variable equal to one for years after the handwashing policy was implemented (and zero otherwise).  


// 4. What is the mean postpartum mortality rate in the doctors' wing prior to the implementation of the handwashing policy?


// 5. Now let's put this result in a table.  We're going to use the `putexcel` command to write our results into an Excel file.  `putexcel` is a simple command that allows you to write Stata output to a particular cell or set of cells in an Excel file.  Before getting started with `putexcel`, use the `pwd` ("print working directory") command in the Stata command window to make sure that you are writing your results to an appropriate file.  Then set up the Excel file that will receive your results using the commands:

putexcel set E3-DD-table1.xlsx, replace
putexcel B1="Treatment", hcenter bold border(top)
putexcel C1="Control", hcenter bold border(top)
putexcel D1="Difference", hcenter bold border(top)
putexcel A2="Before Handwashing", bold
putexcel A4="After Handwashing", bold
putexcel A6="Difference", bold

// 6. Now we can add the mean of the variable `Rate1` for the years prior to the introduction of handwashing.  Remember that you can always use the "return list" command after a command like "summarize" to see what statistics the summarize command stored in Stata's short-term memory as locals.  Any of these statistics can be exported to Excel.

sum Rate1 if post==0
return list
local temp_mean = string(r(mean),"%03.2f")
putexcel B2=`temp_mean', hcenter 


// 7. We can calculate the standard error of the mean by taking the standard deviation (reported by the `sum` command) and dividing it by the square root of the number of observartions (also reported by the `sum` command).  What is the standard error of the mean postpartum mortality rate in the doctors' wing prior to Semmelweis' handwashing intervention?  Use the code below to add this to your table.

local temp_se = string(r(sd)/sqrt(r(N)),"%03.2f")
putexcel B3="(`temp_se')", hcenter 


// 8. We can also use the ci means command to calculate the mean and standard error of a variable.  Use return list to see what statistics are saved after ci means.  Use ci means and putexcel to add the mean and standard error of Rate1 in the post-treatment period to your table.


// 9. Calculate the difference (between the mean of Rate1 in the pre-treatment period and the mean of Rate1 in the psot-treatment period) and the associated standard error by hand using the formula (and the display command).


// 10. Now confirm that you get the same result using the ttest command.  How would you export the results of the ttest command into your table using putexcel?


// 11. (SKIP THIS STEP IN CLASS)  Now complete the table.  





