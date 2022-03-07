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
import excel using E3-Semmelweis1861-data.xlsx, sheet("ViennaBothClinics") first
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


