# Empirical Exercise 6 in R  

In this exercise, we'll be using data from the paper [The Miracle of Microfinance?  Evidence from a Randomized Evaluation](https://www.jstor.org/stable/43189512?seq=1) by 
Abhijit Banerjee, Esther Duflo, Rachel Glennerster, and Cynthia Kinnan.  The paper reports the results of one of the first randomized evaluations of a microcredit 
intervention.  The authors worked with an Indian MFI (microfinance institution) called Spandana that was expanding into the city of Hyderabad.  Spandana 
identified 104 neighborhoods where it would be willing to open branches.  They couldn't open branches in all the neighborhoods simultaneously, so they worked with 
the researchers to assign half of them to a treatment group where branches would be opened immediately.  Spandana held off on opening branches in 
the control neighborhoods until after the study.  

Before getting started, take a look at this [J-PAL policy brief on the impacts of microfinance](https://www.povertyactionlab.org/policy-insight/microcredit-impacts-and-limitations).  We'll 
be using a small slice of the data from the paper by Banerjee, Duflo, Glennerster, and Kinnan to explore the use of **instrumental variables** techniques to estimate impacts of 
**treatment on the treated** - and to think about when such methods are appropriate.

Our first step is to review the mechanics of treatment-on-the-treated estimation.  There are four ways to arrive at 
an estimate of the impact of treatment (access to loans from Spandana) on individuals who take it up (by taking out a Spandana microloan):
1. We can calculate the impact of treatment on an outcome of interest (say, microenterprise profits), and then take the ratio of this coefficient to the estimated impact of treatment on take-up of Spandana microloans
2. We can estimate the impact of treatment on take-up of microloans and then regress our outcome of interest on **predicted** take-up of microloans
3. We can use `feols` to implement two-stage least squares (as in 2, except using a single step)
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

To get started, create a script that reads the data into R directly from the web:
```
## ECON 523: In-Class Activity 6
## A. Student
library(tidyverse)
library(haven)
library(fixest)
mypath <- "C:\myfilepath"
urlfile <- 'https://pjakiela.github.io/ECON523/exercises/E6-BanerjeeEtAl-data.dta'
e6data <- read_dta(urlfile)
```

We are going to make use of the variables `treatment`, `spandana_1`, and `bizprofit_1`.  Before you begin, 
add a line to your do file that drops any observations with one of these variables missing.  

Hint:  the code
```
filter(df, !if_any(c(x1, x2), is.na))
```
drops any rows with either `x1` or `x2` missing from the data frame `df`.

<br>

## In-Class Activity

### Question 1

Estimate the impact of `treatment` on the likelihood of taking a loan from Spandana (the variable `spandana_1`).  What is the estimated coefficient on `treatment`?  Because treatment is randomly assigned at the neighborhood level, we need to cluster our standard errors by neighborhood (`areaid` indexes neighborhoods).  Do this.  This is the **first stage** regression.  

Save the coefficient on `treatment` as `beta_fs`.  

### Question 2

Now extend your code so that you also run the **reduced form** regression of microenterprise profits (the variable `bizprofit_1`) on `treatment`.  What is the estimated impact of being randomly assigned to a treatment (at the neighborhood level) on business profits?  

Save the coefficient on `treatment` as `beta_rf`.  

### Question 3 

Based on your answers to Questions 1 and 2, what is the **treatment-on-the-treated** impact of random assignment to Spandana access on business profits?  Use `beta_fs` and `beta_rf` to calculate this quantity (in your script).

### Question 4 

Now we want to output our results to excel. To do this, we will create a data frame called `results` that contains the results that we wish to export, formatted appropriately.

#### Part (a)

The code below defines a function `reshape_regs()` that formats the results from a regression in a column, with the `term` column indicating the variable whose coefficient is being reported and the `type` column indicating whether the row contains a coefficient estimate or a standard error in parentheses.  Review the code below carefully to make sure that you understand each line. Then extend the code to include the p-value in the row below the standard error. Put the p-value in square brackets rather than parentheses.  
```
reshape_regs <- function(myresults){
  olsresults <- tidy(myresults)
  olsresults$index <- 1:nrow(olsresults)
  olsresults <- olsresults %>% 
  filter(!term == "(Intercept)") %>% 
  mutate(across(c(estimate, std.error), ~ sprintf("%.3f", .))) %>% 
  mutate(across(c(estimate, std.error), ~ as.character(.))) %>% 
  mutate(std.error = str_c("(", std.error, ")")) %>% 
  select(term, estimate, std.error, index) %>% 
  arrange(index) %>% 
  pivot_longer(c(estimate, std.error), 
               names_to = "type", 
               values_to = "est") %>% 
  select(term, type, est)
  return(olsresults)
}
```

#### Part (b)

Use the `reshape_regs()` function to store the results from the first stage and reduced form regressions. You can also adapt the code below to store the number of observations and the R-squared.
```
N_fs <- as.character(fs$nobs)
R2_fs <- as.character(round(r2(fs)[2],3))
```

#### Part (c) 

Now you need to merge the results from your first stage and reduced form regressions into a single data frame that you can export to excel. The code below does this. Make sure that you understand what every line is doing, and then use the code to generate the data frame `results`.  
```
results <- left_join(fs_results, rf_results, by = c("term", "type")) %>% 
  mutate(term = if_else(type == "estimate", term, "")) %>% 
  mutate(term = if_else(term == "treatment" & type == "estimate", "Treatment", "")) %>% 
  add_row(term = "Observations", C1 = N_fs, C2 = N_rf) %>% 
  rename(" " = term, 
         "Borrowed" = C1, 
         "Profits" = C2) %>% 
  select(!type) 
print(results)
```

#### Part (d) 

The last step is to export your results to excel. Here, we adapt the code from Empirical Exercise 5 to export our results to an excel file called `R6-in-class.xlsx`. Before doing this, make sure you have loaded the `openxlsx` library and defined your filepath correctly (so that you will be able to locate your results).  
```
wbname <- "In-Class"
wb <- createWorkbook()
addWorksheet(wb, wbname)
# create a header style
hs1 <- createStyle(halign = "CENTER", textDecoration = "Bold", border = "BottomTop")
# write the results to the table
writeData(wb, wbname, results, headerStyle = hs1)
# adjust column widths
my_widths <- c(20, 16, 16)
setColWidths(wb, wbname, cols = 1:3, widths = my_widths)
my_heights <- c(rep(16, 1), rep(20, 4))
setRowHeights(wb, wbname, rows = 1:5, heights = my_heights)
# center the content of the table
center_style <- createStyle(halign = "CENTER")
addStyle(wb, wbname, center_style, cols = 2:3, rows = 1:5, gridExpand = TRUE, stack = TRUE)
# create a bottom border
bottom_style <- createStyle(border = "Bottom")
addStyle(wb, wbname, bottom_style, cols = 1:3, rows = 5, gridExpand = TRUE, stack = TRUE)
# save workbook
saveWorkbook(wb, file = paste0(mypath, "R6-in-class.xlsx"), overwrite = TRUE)
```

<br>
