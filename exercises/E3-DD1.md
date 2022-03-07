# Empirical Exercise 3
   
In this exercise, we're going to analyze data from Ignaz Semmelweis' handwashing intervention in the maternity hospital in Vienna.  The data come from 
Semmelweis' (1861) book, and [some helpful person put them on Wikipedia](https://en.wikipedia.org/wiki/Historical_mortality_rates_of_puerperal_fever#Yearly_mortality_rates_for_birthgiving_women_1784%E2%80%931849). 
We'll be reading them in from excel using the import excel command.

We're going to be exporting estimation results to Excel using the `putexcel` command, and we'll also be making figures.  Before doing so, 
make sure you have the `blindschemes` package installed.  To do this, type `findit blindschemes` in the Stata command window.  When you do, 
a window that looks like this will pop up:

![blindschemes-window](blindschemes.png)
  
Click the first link, and then scroll down until you see the blue text that says **click here to install**.  That should install the `blindschemes package.  
  
<br> 

## Getting Started  

Data on maternal mortality rates in Vienna are contained in the Excel file [E3-Semmelweis1861-data.xlsx](E3-Semmelweis1861-data.xlsx).  The spreadsheet 
inlcudes annual data from 1833 (when the Vienna Maternity Hospital opened its second clinic) through 1858.  Mortality rates are reported for Division 1 
(where expectant mothers were treated by doctors and medical students) and Division 2 (where expectant mothers were treated by midwives and trainee midwives from 1841 on). 
In Semmelweis' difference-in-differences analysis, Division 1 was the (ever-)treated group.  

Our first task is to import this Excel file 
into Stata using the `import excel` command.  The `do` file `E3-in-class.do` does this:  after the usual top-of-the-do-file preliminaries, it includes the 
command:

```
import excel using E3-Semmelweis1861-data.xlsx, ///
   sheet("ViennaBothClinics") first
```

The option `sheet` tells Stata which worksheet within the Excel file `E3-Semmelweis1861-data.xlsx` to select.  The option 
`first' indicates that the first row of the spreadsheet should be treated as variable names and not one of the observations.  

After importing the data, the `do` file then adds labels to all the variables using the `label variable` command (which can be 
abbreviated as `la var`).  Use the `describe` and `summarize` commands to familiarize yourself with the data set.  Which variable 
records the maternal mortality rate in Division 1 of the hospital?  What is the average maternal mortality rate in Division 1?  What is 
the average maternal mortality rate in Division 2?

The last lines of the code in the `do` file save the data in Stata format, and then graph maternal mortality rates in Division 1 
and Division 2.  If you have important the data correctly and installed the `blindschemes` package, Stata should generate a figure that looks like this:

![all-data-plot](vienna-by-wing-fig1.png)

What patterns do you notice in this figure?  How do maternal mortality rates in the two divisions of the hospital compare?

Use the `list` command to list the the notes contained in the data set by year.  If you only want to list the rows of data 
that include a note (i.e. where the `Note` variable is non-missing), you can add `if Note!=""`) at the end of the command.  Add 
your list command to your 

In what year did the hospital first move to the system where patients in Division 1 were treated by doctors and patients in Division 2 
were treated by midwives?  Drop the observations (years) before this happened using the drop command.

_Make sure that you record this an all your subsequent commands in your do file, so that you can re-run your code later._

Generate a `post` variable equal to one for years after the handwashing policy was implemented (and zero otherwise).  What is the mean 
postpartum mortality rate in the doctors' wing (Division 1) prior to the implementation of the handwashing policy?

Now let's put this result in a table!  We're going to use the `putexcel` command to write our results into an Excel file.  `putexcel` 
is a simple command that allows you to write Stata output to a particular cell or set of cells in an Excel file.  Before getting started 
with `putexcel`, use the `pwd` ("print working directory") command in the Stata command window to make sure that you are writing your 
results to an appropriate file.  Then set up the Excel file that will receive your results using the commands:

```
putexcel set E3-DD-table1.xlsx, replace
putexcel B1="Treatment", bold border(top)
putexcel C1="Control", bold border(top)
putexcel D1="Difference", bold border(top)
putexcel A2="Before Handwashing", bold
putexcel A4="After Handwashing", bold
```

Now we can add the mean of the variable `Rate1` for the years prior to the introduction of handwashing.  Remember that you can always use the `return list` command after a command like `summarize` to see what statistics the summarize command stored in Stata's short-term memory as locals.  Any of these statistics can be exported to Excel.

```
sum Rate1 if post==0
return list
putexcel B2=`r(mean)', nformat(#.##)
```

Notice that the local macro being exported to Excel appears in single quotes.  The `nformat()` option tells Stata how many digits to export.

We can calculate the standard error of the mean by taking the standard deviation (reported by the `sum` command) and dividing it by the square root of the number of 
observartions (also reported by the `sum` command).  What is the standard error of the mean postpartum mortality rate in the doctors' wing prior to Semmelweis' handwashing 
intervention?

```
sum Rate1 if post==0
return list
local temp_se = r(sd)/sqrt(r(N)) 
putexcel B2="(`temp_se')", nformat(#.##)
```

At this point, it is worth opening your Excel file to make sure that you are writing to it successfully.  


