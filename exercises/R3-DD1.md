# Empirical Exercise 3 in R
   
In this exercise, we're going to analyze data from Ignaz Semmelweis' handwashing intervention in the maternity hospital in Vienna.  The data come from 
Semmelweis' (1861) book, and [some helpful person put them on Wikipedia](https://en.wikipedia.org/wiki/Historical_mortality_rates_of_puerperal_fever#Yearly_mortality_rates_for_birthgiving_women_1784%E2%80%931849).  

We'll review the different ways to estimate simple difference-in-differences models.  We'll also learn how to make simple graphs using `ggplot` and export regression results to excel using `openxls`. 
  
<br> 

## Getting Started  

Data on maternal mortality rates in Vienna are contained in the Excel file [E3-Semmelweis1861-data.xlsx](E3-Semmelweis1861-data.xlsx). The spreadsheet inlcudes annual data from 1833 (when the Vienna Maternity Hospital opened its second clinic) through 1858.  Mortality rates are reported for Division 1 
(where expectant mothers were treated by doctors and medical students) and Division 2 (where expectant mothers were treated by midwives and trainee midwives from 1841 on). In Semmelweis' difference-in-differences analysis, Division 1 was the (ever-)treated group.  

Our first task is to import this Excel file into Stata using the `openxlsx` package.  Create R script that begins with the usual preliminaries, installs the package `openxlsx` and loads it as one of the libraries, and then imports the Semmelweis data directly from github using the following code:
```
url <- "https://pjakiela.github.io/ECON523/exercises/E3-Semmelweis1861-data.xlsx"
e3data <- tibble(read.xlsx(url, sheet = "ViennaBothClinics"))
```
The option `sheet` tells R which worksheet within the excel file `E3-Semmelweis1861-data.xlsx` to select. After importing the data, you should observe the following columns in the `e3data` data frame:

| Columns | Description |
|------------|------------|
| Births1 | Births in Division 1 (Treatment Group) |
| Deaths1 | Deaths in Division 1 (Treatment Group) |
| Rate1 | Mortality Rate in Division 1 (Treatment Group) |
| Births2 | Births in Division 2 (Comparison Group) |
| Deaths2 | Deaths in Division 2 (Comparison Group) |
| Rate2 | Mortality Rate in Division 2 (Comparison Group) |

Now familiarize yourself with the data set. What is the average maternal mortality rate in Division 1?  What is the average maternal mortality rate in Division 2?

## In-Class Activity

### Question 1

Use R's `ggplot` package to make a graph of maternal mortality in the two wings of the hospital. First, use the following code to define the dark blue and dar orange color's from the Okabe-Ito colorblind-friendly palette
```
oiblue <- "#0072B2"
oiverm <- "#D55E00"
```
This will allow you to use the colors `oiblue` and `oiverm`, as shown in the sample code. Adapt the code to make your graph as possible to the one below.
```
ggplot(e3data, aes(x = Year, y = Rate1)) + 
  geom_point(color = oiblue, shape = 16, size = 0.8) +
  geom_line(aes(color = 'Doctors'), linewidth = 0.32) +
  geom_point(aes(y = Rate2), color = oiblue, shape = 16, size = 0.8) +
  geom_line(aes(y = Rate2, color = 'Midwives'), linewidth = 0.32) +
  xlab(" ") +
  ylab("Maternal Mortality (Percent)") + 
  scale_x_continuous(n.breaks=6) +
  scale_color_manual(name=' ',
                     breaks=c('Doctors',
                              'Midwives'),
                     values=c('Doctors' = oiverm,
                              'Midwives' = oiblue)) 
```
Your finished graph should look something like this:
![all-data-plot](R-semmelweis-plot.png)

What patterns do you notice in this figure?  How do maternal mortality rates in the two divisions of the hospital compare?
