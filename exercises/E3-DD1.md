# Empirical Exercise 3
   
In this exercise, we're going to analyze data from Ignaz Semmelweis' handwashing intervention in the maternity hospital in Vienna.  The data come from 
Semmelweis' (1861) book, and [some helpful person put them on Wikipedia](https://en.wikipedia.org/wiki/Historical_mortality_rates_of_puerperal_fever#Yearly_mortality_rates_for_birthgiving_women_1784%E2%80%931849). 
We'll be reading them in from Excel using the `import excel` command.

In this exercise, we'll review the different ways to estimate simple difference-in-differences models.  We'll also learn how to export results to word, excel, or latex using Stata's `esttab` and `putexcel` commands.  The `putexcel` command is more customizable, but it also takes more work (i.e. coding).  `esttab` is a very straightforward tool for getting basic regression results out of stata and into pretty much any format.   

You can access the in-class activity (below) as a [do file](https://github.com/pjakiela/ECON523/tree/gh-pages/exercises/ECON-523-in-class.do) or [pdf](https://github.com/pjakiela/ECON523/tree/gh-pages/exercises/ECON-523-E3-in-class.pdf).

You can also access the main empirical exercise (also below) as a [do file](https://github.com/pjakiela/ECON523/tree/gh-pages/exercises/ECON-523-E3-questions.do) or [pdf](https://github.com/pjakiela/ECON523/tree/gh-pages/exercises/ECON-523-E3-questions.pdf).
  
<br> 

## Getting Started  

Data on maternal mortality rates in Vienna are contained in the Excel file [E3-Semmelweis1861-data.xlsx](E3-Semmelweis1861-data.xlsx).  The spreadsheet 
inlcudes annual data from 1833 (when the Vienna Maternity Hospital opened its second clinic) through 1858.  Mortality rates are reported for Division 1 
(where expectant mothers were treated by doctors and medical students) and Division 2 (where expectant mothers were treated by midwives and trainee midwives from 1841 on). In Semmelweis' difference-in-differences analysis, Division 1 was the (ever-)treated group.  

Our first task is to import this Excel file into Stata using the `import excel` command.  The 
`do` file [`E3-questions.do`](E3-questions.do) does this:  after the usual top-of-the-do-file preliminaries, it includes the 
command:

```
import excel using E3-Semmelweis1861-data.xlsx, ///
   sheet("ViennaBothClinics") first
```

The option `sheet` tells Stata which worksheet within the Excel file `E3-Semmelweis1861-data.xlsx` to select.  The option 
`first` indicates that the first row of the spreadsheet should be treated as variable names and not as one of the observations.  

After importing the data, the `do` file then adds labels to all the variables using the `label variable` command (which can be 
abbreviated as `label var`).  Use the `describe` and `summarize` commands to familiarize yourself with the data set.  Which variable 
records the maternal mortality rate in Division 1 of the hospital?  What is the average maternal mortality rate in Division 1?  What is 
the average maternal mortality rate in Division 2?

The next lines of the code in the `do` file save the data in Stata format, and then graph maternal mortality rates in Division 1 
and Division 2.  If you have important the data correctly, Stata should generate a figure that looks like this:

![all-data-plot](vienna-by-wing-fig1.png)

What patterns do you notice in this figure?  How do maternal mortality rates in the two divisions of the hospital compare?

<br>

## In-Class Activity

### Question 1

Use the `list` command to list the the notes contained in the data set by year.  If you only want to list the rows of data 
that include a note (i.e. where the `Note` variable is non-missing), you can add `!missing(Note)` at the end of the command.  

### Question 2

In what year did the hospital first move to the system where patients in Division 1 were treated by doctors and patients in Division 2 
were treated by midwives?  Drop the observations (years) before this happened using the drop command.

_Make sure that you record this and all your subsequent commands in your do file, so that you can re-run your code later._

### Question 3

Generate a `post` variable equal to one for years after the handwashing policy was implemented (and zero otherwise).  

### Question 4

What is the mean postpartum mortality rate in the doctors' wing (Division 1) prior to the implementation of the handwashing policy?

### Question 5

Now let's put this result in a table.  We're going to use the `putexcel` command to write our results into an Excel file.  `putexcel` 
is a simple command that allows you to write Stata output to a particular cell or set of cells in an Excel file.  Before getting started 
with `putexcel`, use the `pwd` ("print working directory") command in the Stata command window to make sure that you are writing your 
results to an appropriate file.  Use the `cd` command to change your file path if necessary (add this to your do file).  Then set up the Excel file that will 
receive your results using the commands:

```
putexcel set E3-DD-table1.xlsx, replace
putexcel B1="Treatment", hcenter bold border(top)
putexcel C1="Control", hcenter bold border(top)
putexcel D1="Difference", hcenter bold border(top)
putexcel A2="Before Handwashing", bold
putexcel A4="After Handwashing", bold
```

At this point, it is worth opening your Excel file to make sure that you are writing to it successfully.  **Be sure to close the file after you look at it**; Stata won't write over an open Excel file.  The column and row labels should all appear in bold font (the `bold` option), and the column headings in cells B1, C1, and D1 should be centered (the `hcenter` option) and have a border above them (the `border()` option).  

### Question 6

Now that we know that `putexcel` is working, we can add the mean of the variable `Rate1` (the maternal mortality rate in Division 1) for the years prior to the introduction of handwashing.  You can use the `return list` command after a command like `summarize` to see what statistics the summarize command stored in Stata's short-term memory as locals.  Any of these statistics can be exported to Excel.  

```
sum Rate1 if post==0
return list
```

We're going to put the mean maternal mortality rate in Division 1 prior to the handwashing intervention in cell B2:  the **Treatment** column, in the **Before Handwashing** row.

```
local temp_mean = string(r(mean),"%03.2f")
putexcel B2=`temp_mean', hcenter 
```

The `string` command in the first line creates a local macro containing a string that is the mean calculated the last time you used the `summarize` command, rounded to 2 decimal places.  The second line writes that local macro in our Excel file.  Notice that the local macro being exported to Excel appears in single quotes.  If you are just writing a local macro to Excel using the `putexcel` command, it does not need to appear in (double) quotes, but sequences of letters and numbers do need double quotes.  The `hcenter` option tells Excel to center the number within the column.  

We can calculate the standard error of the mean by taking the standard deviation (reported by the `sum` command) and dividing it by the square root of the number of 
observartions (also reported by the `sum` command).  What is the standard error of the mean postpartum mortality rate in the doctors' wing prior to Semmelweis' handwashing 
intervention?

### Question 7

We can calculate the standard error of the mean by taking the standard deviation (reported by the `sum` command) and dividing it by the square root of the number of observations (also reported by the `sum` command).  What is the standard error of the mean postpartum mortality rate in the doctors' wing prior to Semmelweis' handwashing intervention?  Use the code below to add this to your table.

```
local temp_se = string(r(sd)/sqrt(r(N)),"%03.2f")
putexcel B3="(`temp_se')", hcenter 
```

### Question 8

We can also use the `ci means` command to calculate the mean and standard error of a variable.  Use 
`return list` to see what statistics are saved after `ci means`.  Use `ci means` and `putexcel` to add 
the mean and standard error of `Rate1` in the post-treatment period to your table.

### Question 9

Calculate the difference (between the mean of `Rate1` in the pre-treatment period and the mean of `Rate1` in the post-treatment period) and the associated standard error by hand using the formula (and the `display` command).

### Question 10

Now confirm that you get the same result using the `ttest` command.  How would you export the results of the `ttest` command into your table using `putexcel`?

### Question 11 (SKIP THIS IN CLASS)

Now complete the table. 

<br> 

## Empirical Exercise

Create a do file that reads in your copy of Semmelweis' data and restricts attention to the period 
when doctors worked in the first clinic and midwives worked in the second clinic.  All your do files 
should start with the same set of commands at the top.

```
clear all 
set scheme s1mono 
set more off
set seed 314159

** change working directory as appropriate to where you want to save
cd "C:\Users\pj\Dropbox\ECON-523\topics\3-DD1\stata"

** load data
use E3-semmelweis-vienna-by-wing.dta
drop if Year<1840
```

### Question 1

Use the following `reshape` command to convert your data into a panel data set containing a variable `Rate` and a variable `clinic` that indicates whether an observation comes from Clinic 1 (doctors) or Clinic 2 (midwives).  How many observations are there in the data set now?  How many from each clinic?  

reshape long Rate, j(clinic) i(Year)

### Question 2

Generate a `post` variable equal to one for years after the handwashing policy was implemented (and zero otherwise) and a `treatment` variable equal to one for the doctors' wing (and zero otherwise).

### Question 3

Generate the interaction term you need to estimate a difference-in-differences model in a regression framework.

### Question 4

Use the `label variable` command to give your variables short, easy to interpret labels.

### Question 5

Implement difference-in-differences in an OLS regression framework.  Use the command `eststo clear` immediately before your `regression` command, and then use the command `eststo` (estimates store) immediately after.  This will save your results.

### Question 6

You can use the `esttab` command to make a table of your regression results.  Try it by typing `esttab` in the command window.  The command `esttab using clinic-regs.rtf` will save your table as a word document.  Look through the `esttab` options to make your table look more professional.  Report standard errors rather than t-statistics in parentheses below your coefficients.  Have your variable labels appear in place of variable names, and make sure your first column is wide enough to accommodate the labels you have given your variables.  Make the column with your regression coefficients say OLS at the top using `esttab`'s `mtitle` option.  You can learn more about making tables in `esttab` [here](https://pjakiela.github.io/stata/regression-table.html). 

### Question 7

Take a screenshot of your finished regression table and upload it to gradescope.

### Question 8

Which coefficient in the regression table (i.e. the coefficient on which variable) is the difference-in-differences estimate of the treatment effect of handwashing on maternal mortalty?

### Question 9

Which regression coefficient is the estimate of the degree of selection bias?

### Question 10

Which regression coefficient is the estimate of the time trend in the absence of treatment?


 ---
 
This exercise is part of [Module 3:  Difference-in-Differences 1](https://pjakiela.github.io/ECON523/M3-DD1.html).
