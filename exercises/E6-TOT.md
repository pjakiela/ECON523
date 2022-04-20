# Empirical Exercise 6  

In this exercise, we'll be using data from the paper [The Miracle of Microfinance?  Evidence from a Randomized Evaluation](https://www.jstor.org/stable/43189512?seq=1) by 
Abhijit Banerjee, Esther Duflo, Rachel Glennerster, and Cynthia Kinnan.  The paper reports the results of one of the first randomized evaluations of a microcredit 
intervention.  The authors worked with an Indian MFI (microfinance institution) called Spandana that was expanding into the city of Hyderabad.  Spandana 
identified 104 neighborhoods where it would be willing to open branches.  They couldn't open branches in all the neighborhoods simultaneously, so they worked with 
the researchers to assign half of them to a treatment group where branches would be opened immediately.  Spandana held off on opening branches in 
the control neighborhoods until after the study.  

Before getting started, take a look at this [J-PAL policy brief on the impacts of microfinance](https://www.povertyactionlab.org/policy-insight/microcredit-impacts-and-limitations).  We'll be using a small slice of the data from the paper by Banerjee, Duflo, Glennerster, and Kinnan to explore the use of **instrumental variables** techniques to estimate impacts of **treatment on the treated** - and to think about when such methods are appropriate.

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
set scheme s1mono
set seed 314159
cd "C:\Users\pj\Dropbox\econ523-2022\exercises\E6-IV"
webuse set https://pjakiela.github.io/ECON523/exercises/
webuse E6-BanerjeeEtAl-data.dta
```

We are going to make use of the variables treatment, spandana_1, bizprofit_1, `bizrev_1`, `bizassets_1`, and `any_biz_1`.  Before you begin, 
add a line to your do file that drops any observations with one of these variables missing.

<br>

## The Mechanics of IV

Our first step is to review the mechanics of treatment-on-the-treated estimation using instrumental variables.  There are three ways to arrive at 
an estimate of the impact of treatment (access to loans from Spandana) on individuals who take it up (by taking out a Spandana microloan):

1. We can calculate the impact of treatment on an outcome of interest (say, microenterprise profits), and then take the ratio of this coefficient to the estimated impact of treatment on take-up of Spandana microloans
2. We can estimate the impact of treatment on take-up of microloans and then regress our outcome of interest on **predicted** take-up of microloans
3. We can use the `ivregress 2sls` command in Stata to implement two-stage least squares (as in 2, except using a single Stata command)

We will start by reviewing all three approaches to confirm that they lead to identical estimates of the impact of treatment on the treated

### Question 1

Estimate the impact of `treatment` on the likelihood of taking a loan from Spandana (the variable `spandana_1`).  What is the estimated coefficient on `treatment`?  Because treatment is randomly assigned at the neighborhood level, we need to cluster our standard errors by neighborhood.  Add the option `, cluster(areaid)` to the end of your regression command to do this.  This is the **first stage** regression.

### Question 2

Now extend your do file so that you also run the **reduced form** regression of microenterprise profits (the variable `bizprofit_1`) on `treatment`.  What is the estimated impact of being randomly assigned to a treatment (at the neighborhood level) on business profits?

### Question 3 

Based on your answers to Questions 1 and 2, what is the **treatment-on-the-treated** impact of random assignment to Spandana access on business profits?

### Question 4 

Confirm that your answer is correct by estimating an **instrumental variables** (IV) regression of `bizprofit_1` on `spandana_1`, instrumenting for `spandana_1` with the `treatment` dummy.  Make sure you remember to cluster your standard errors!  Your estimated coefficient should be identical to your answer to Question 3.

### Question 5 

As we discussed in class, you can also calculate the treatment-on-the-treated estimate by regressing `spandana_1` on `treatment`, storing the predicted values from that regression, and regressing `bizprofit_1` on your predicted values.  To do this, you will need to rerun your first stage regression (from Question 1) and then use Stata's `predict` command (without the `, resid` option that we used last week).  Again, your estimated coefficient should match your answers to Questions 3 and 4.  How do the standard errors compare?  
