# Empirical Exercise 6  

In this exercise, we'll be using data from the paper [The Miracle of Microfinance?  Evidence from a Randomized Evaluation](https://www.jstor.org/stable/43189512?seq=1) by 
Abhijit Banerjee, Esther Duflo, Rachel Glennerster, and Cynthia Kinnan.  The paper reports the results of one of the first randomized evaluations of a microcredit 
intervention.  The authors worked with an Indian MFI (microfinance institution) called Spandana that was expanding into the city of Hyderabad.  Spandana 
identified 104 neighborhoods where it would be willing to open branches.  They couldn't open branches in all the neighborhoods simultaneously, so they worked with 
the researchers to assign half of them to a treatment group where branches would be opened immediately.  Spandana held off on opening branches in 
the control neighborhoods until after the study.  

Before getting started, take a look at this [J-PAL policy brief on the impacts of microfinance](https://www.povertyactionlab.org/policy-insight/microcredit-impacts-and-limitations).  We'll be using a small slice of the data from the paper by Banerjee, Duflo, Glennerster, and Kinnan to explore the use of **instrumental variables** techniques to estimate impacts of **treatment on the treated** - and to think about when such methods are appropriate.

Our first step is to review the mechanics of treatment-on-the-treated estimation.  There are four ways to arrive at 
an estimate of the impact of treatment (access to loans from Spandana) on individuals who take it up (by taking out a Spandana microloan):
1. We can calculate the impact of treatment on an outcome of interest (say, microenterprise profits), and then take the ratio of this coefficient to the estimated impact of treatment on take-up of Spandana microloans
2. We can estimate the impact of treatment on take-up of microloans and then regress our outcome of interest on **predicted** take-up of microloans
3. We can use the `ivregress 2sls` command in Stata to implement two-stage least squares (as in 2, except using a single Stata command)
4. We can estimate the impact of Spandana loans on our outcome of interest controlling for the residuals in our first-stage regression (the **control function** approach)

<br>

## Getting Started

The data that we will use in this exercise is available [here](https://pjakiela.github.io/ECON523/exercises/E6-BanerjeeEtAl-data.dta).  The data set 
contains information on 6,863 households in 104 neighborhoods in Hyderabad; these households were randomly sampled form 
the local population, so not all of them will have chosen to take out loans from an MFI. Half of the neighborhoods (52 of 104) were randomly assigned 
to treatment (and the rest to control).  The variable `treatment` indicates treatment status, and the variable `areaid` is a neighborhood identifier.  

We will be using the following outcome variables:

- `spandana_1` is an indicator for taking out a loan from Spandana 
- `bizprofit_1` is a measure of microenterprise profits
- `bizrev_1` is a measure of microenterprise revenues
- `bizassets_1` is a measure of assets owned by one's microenterprise
- `any_biz_1` is an indicator for operating a microenterprise

To get started, create a do file that reads the data into Stata - you can either download the data and open it from your computer, or you can use code like this 
to open the data directly from the web:
```
clear all
set more off
set seed 12345
cd "C:\myfilepath"
webuse set https://pjakiela.github.io/ECON523/exercises/
webuse E6-BanerjeeEtAl-data.dta
```

We are going to make use of the variables `treatment`, `spandana_1`, and `bizprofit_1`.  Before you begin, 
add a line to your do file that drops any observations with one of these variables missing.

<br>

## In-Class Activity

### Question 1

Estimate the impact of `treatment` on the likelihood of taking a loan from Spandana (the variable `spandana_1`).  What is the estimated coefficient on `treatment`?  Because treatment is randomly assigned at the neighborhood level, we need to cluster our standard errors by neighborhood.  Do this.  This is the **first stage** regression.

### Question 2

Now extend your do file so that you also run the **reduced form** regression of microenterprise profits (the variable `bizprofit_1`) on `treatment`.  What is the estimated impact of being randomly assigned to a treatment (at the neighborhood level) on business profits?

### Question 3 

Based on your answers to Questions 1 and 2, what is the **treatment-on-the-treated** impact of random assignment to Spandana access on business profits?  Write this down somewhere.

### Question 4 

Now we want to output our results to Excel.

#### Part (a)

We're going to use the `putexcel` command to write our results into an Excel file. `putexcel` is a simple command that allows you to write Stata output to a particular cell or set of cells in an Excel file. Before getting started with `putexcel`, use the `pwd` ("print working directory") command in the Stata command window to make sure that you are writing your results to an appropriate file. Use the `cd` command to change your file path if necessary. Then set up the Excel file that will receive your results using the command `putexcel set`.  Use the code below to setup a blank Excel table where you can store your results:
```
putexcel set E6-TOT-in-class.xlsx, replace
putexcel A1=" ", hcenter border(top) 
putexcel A2=" ", hcenter border(bottom)
putexcel B1="Borrowed", hcenter bold border(top)
putexcel B2="(1)", hcenter bold border(bottom)
putexcel C1="Profits", hcenter bold border(top)
putexcel C2="(2)", hcenter bold border(bottom)
putexcel A3="Treatment", bold
putexcel A6="Observations", bold border(bottom)
```

#### Part (b)

At this point, it is worth opening your Excel file to make sure that you are writing to it successfully. Be sure to close the file after you look at it; Stata won't write over an open Excel file. The column and row labels should all appear in bold font (the `bold` option), and the column headings in cells B1 and C1 should be centered (the `hcenter` option) and have a border above them (the `border()` option).

The next step is to write your regression results to Excel.  We are going to do this by writing a program.  We've already seen that we can store our regression results in a Stata matrix using the command 
```
mat V = r(table)
```
after running a regression.  This allows us to extract both the standard error and the p-value associated with each regression coefficient (something that is difficult to do using `esttab`).  The program below adds a column to our Excel file containing the results of an additional regression.  Review the code below carefully to make sure that you understand each line.  Then add two lines to the program to write the p-value associated with the regression coefficient in Row 5 of the spreadsheet.  Put the p-value in square brackets rather than parentheses. 

```
cap program drop tabcolumn
program define tabcolumn // tabrow var columnletter
	reg `1' treatment, cluster(areaid) 
	mat V = r(table)
	local beta = string(V[1,1],"%04.3f")
	local se = string(V[2,1],"%04.3f")
	putexcel `2'3="`beta'", hcenter 
	putexcel `2'4="(`se')", hcenter 
	putexcel `2'6=`e(N)', hcenter border(bottom)
end

tabcolumn spandana_1 B 
tabcolumn bizprofit_1 C 
```

#### Part (c) is optional.

You may want to set the widths of the columns in your Excel file.  Unfortunately, there is no way to do this using `putexcel`.  The code below invokes Stata's mata programming language to adjust the column widths.  You can also just adjust them as needed by hand before you print your table to a pdf.

```
mata
b = xl()
b.load_book("E6-TOT-in-class.xlsx")
b.set_sheet("Sheet1")
b.set_column_width(1,1,20) // make variable name column widest
b.set_column_width(2,3,16) // width for subsequent columns
b.set_row_height(7,7,32)
b.close_book()
end
```

#### Part (d)

Add a note at the bottom of your table that explains the contents of the table.  

<br>

## Empirical Exercise

Start a new do file for the main part of the empirical exercise.  We are going to make use of the variables `treatment`, `spandana_1`, `bizprofit_1`, `bizrev_1`, `bizassets_1`, and `any_biz_1`.  Before you begin, add a line to your do file that drops any observations with one of these variables missing.

### Question 1:  Implementing 2SLS

Use two-stage least squares (2SLS) to estimate an instrumental variables (IV) regression of bizprofit_1 on spandana_1, instrumenting for spandana_1 with the treatment dummy.  Cluster your standard errors at the neighborhood level.   Your estimated coefficient should be identical to your answer from the In-Class Activity.

### Question 2:  2SLS Results

Now make a table that reports TOT estimates of the impact of Spandana loans on microenterprise profits (the variable `bizprofit_1`), microenterprise revenues (the variable `bizrev_1`), microenterprise assets (the variable `bizassets_1`), and the likelihood of operating a microenterprise (the variable `any_biz_1`). 

#### Part (a)

Write the code to set up an excel file that will hold the results of your regressions.  Give the table a title.  Leave space to report the coefficient estimate, the standard error, and the p-value for both the Spandana coefficient and the constant.  Leave space to report the number of observations in each column.

#### Part (b) 

Now modify the program from the In-Class Activity to produce the results needed for your table.  

### Question 3:  The Control Function Approach

Now make another table that replicates the treatment-on-the treated estimation from Question 2 using the control function approach. 

### Question 4

Print each of your tables to pdf so that you can upload your finished product(s) to gradescope.
 
### Question 5 

Using instrumental variables to estimated treatment effects on the treated makes sense when random assignment to treatment (i.e. inviting someone to participate in a program) has no impact on those who choose not to take up treatment.  Does this approach make sense in the context of microfinance?  Why or why not?

<br>

## More Fun with Stata

The relatively low take-up rates for microfinance loans can be interpreted as evidence that not everyone wants to be an entrepreneur, and several studies have found that access to credit is more effective at helping people expand their businesses than at encouraging non-entrepreneurs to start new businesses.  The variable `any_old_biz` is an indicator for operating a microenterprise prior to the start of the study.  Restrict your sample to those who were already operating microenterprises before Spandana's expansion, and estimate the impact of Spandana loans on microenterprise profits, revenues, and assets in this restricted sample.  Store your results in an Excel table (but don't over-write your earlier work).  What do these results suggest about the impacts of microfinance?
