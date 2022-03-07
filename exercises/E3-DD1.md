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
inlcudes annual data from 1833 (when the Vienna Maternity Hospital opened its second clinic) through 1858.  Our first task is to import this Excel file 
into Stata using the `import excel` command.  The `do` file `E3-in-class.do` does this:  after the usual top-of-the-do-file preliminaries, it includes the 
command:

```
import excel using E3-Semmelweis1861-data.xlsx, sheet("ViennaBothClinics") first
```

The option `sheet` tells Stata which worksheet within the Excel file `E3-Semmelweis1861-data.xlsx` to select.  The option 
`first' indicates that the first row of the spreadsheet should be treated as variable names and not one of the observations.  
