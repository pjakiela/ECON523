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

### Question 2

In what year did the hospital first move to the system where patients in Division 1 were treated by doctors and patients in Division 2 were treated by midwives?  Drop the observations (years) before this happened.  

Hint: Hint: use `print(df, n = 100)` to print the first 100 rows of data frame `df`. Then use `select()` to keep the correct rows.

### Question 3

Generate a `post` variable equal to one for years after the handwashing policy was implemented (and zero otherwise).  

### Question 4

What is the mean postpartum mortality rate in the doctors' wing (Division 1) prior to the implementation of the handwashing policy?

### Question 5

Now we're going make a table showing the difference-in-differences estimate of the treatment effect of hand washing on maternal mortality. The table 
will show the mean mortality rate (maternal deaths per 100 births) in the Treatment and Comparison wings before and after Semmelweis' policy was implemented. Your table will look something like this, except with the actual means, standard errors, and differences instead of ones and zeroes:  

|             | Treatment | Comparison | Difference | 
|-------------|-----------|---------|------------|
| Before Handwashing | 1.00 | 1.00 | 1.00 |
| | (0.00) | (0.00) | (0.00) |
| After Handwashing | 1.00 | 1.00 | 1.00 |
| | (0.00) | (0.00) | (0.00) |
| Difference | 1.00 | 1.00 | 1.00 |
| | (0.00) | (0.00) | (0.00) |


We'll write to an excel file using `openxlsx` `saveWorkbook()`,  a simple command that allows you to write a data frame to an excel file.  Before getting started with `saveWorkbook()`, we will define a simple data frame that contains our desired column and row headings as well as placeholders for the results we want to report. Use the code below to do this. Notice that the second, third, anf fourth columns of the tibble that we create are named **Treatment**, **Comparison**, and **Difference**.  
```
labels <- c("Before Handwashing", 
            " ", 
            "After Handwashing", 
            " ", 
            "Difference", 
            " ")
temp_column <- c("111", "000", "111", "000", "111", "000")
e3_results <- tibble(" " = labels, 
                     "Treatment" = temp_column, 
                     "Comparison" = temp_column, 
                     "Difference" = temp_column)
print(e3_results)
```

Now we use `createWorkbook()`, `addWorksheet()`, `writeData()`, and `saveWorkbook()` to write the data frame `e3_results` to excel. In addition to those key steps, the code below uses `setColWidths()` and `addStyle()` to format the table. Adjust the formatting parameters as desired. 
```
wb <- createWorkbook()
addWorksheet(wb, "Results")
# create a header style
hs1 <- createStyle(halign = "CENTER", textDecoration = "Bold", border = "BottomTop")
# write the results to the table
writeData(wb, "Results", e3_results, headerStyle = hs1)
# adjust column widths
e3_widths <- c(18, 12, 12, 12)
setColWidths(wb, "Results", cols = 1:4, widths = e3_widths)
# center the content of the table
center_style <- createStyle(halign = "CENTER")
addStyle(wb, "Results", center_style, cols = 2:4, rows = 1:7, gridExpand = TRUE, stack = TRUE)
# create a bottom border
bottom_style <- createStyle(border = "Bottom")
addStyle(wb, "Results", bottom_style, cols = 1:4, rows = 7, gridExpand = TRUE, stack = TRUE)
# save workbook
saveWorkbook(wb, file = paste0(pjpath, "/R3-DD1.xlsx"), overwrite = TRUE)
```

At this point, it is worth opening your excel file to make sure that you are writing to it successfully.  **Be sure to close the file after you look at it**; R won't write over an open excel file.  The column and row labels should all appear in bold font, and there should be borders at the top and bottom of the table.  
