# Empirical Exercise 3 in R
   
In this exercise, we're going to analyze data from Ignaz Semmelweis' handwashing intervention in the maternity hospital in Vienna.  The data come from 
Semmelweis' (1861) book, and [some helpful person put them on Wikipedia](https://en.wikipedia.org/wiki/Historical_mortality_rates_of_puerperal_fever#Yearly_mortality_rates_for_birthgiving_women_1784%E2%80%931849).  

We'll review the different ways to estimate simple difference-in-differences models.  We'll also learn how to make simple graphs using `ggplot` and export regression results to excel using `openxls`. 
  
<br> 

## Getting Started  

Data on maternal mortality rates in Vienna are contained in the Excel file [E3-Semmelweis1861-data.xlsx](E3-Semmelweis1861-data.xlsx). The spreadsheet inlcudes 
annual data from 1833 (when the Vienna Maternity Hospital opened its second clinic) through 1858.  Mortality rates are reported for Division 1 
(where expectant mothers were treated by doctors and medical students) and Division 2 (where expectant mothers were treated by midwives and trainee midwives from 1841 on). 
In Semmelweis' difference-in-differences analysis, Division 1 was the (ever-)treated group.  

Our first task is to import this Excel file into R using the `import excel` command.  Create a do file that begins with the usual 
preliminaries and then imports the Semmelweis data directly from github using the follow code:
```
import excel ///
"https://pjakiela.github.io/ECON523/exercises/E3-Semmelweis1861-data.xlsx", /// 
sheet("ViennaBothClinics") first
```
The option `sheet` tells Stata which worksheet within the excel file `E3-Semmelweis1861-data.xlsx` to select.  The option 
`first` indicates that the first row of the spreadsheet should be treated as variable names and not as one of the observations.  

After importing the data, assign the variables the following labels using the `label var` command:

| Variable | Label to Assign |
|------------|------------|
| Births1 | Births in Division 1 (Treatment Group) |

Use the `describe` and `summarize` commands to familiarize yourself with the data set.  Which variable 
records the maternal mortality rate in Division 1 of the hospital?  What is the average maternal mortality rate in Division 1?  What is 
the average maternal mortality rate in Division 2?
