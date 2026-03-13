# Empirical Exercise 5 in R

In this exercise, we'll be using a data set on primary school enrollment and 
completion in 18 African countries that eliminated primary school fees 
between 1990 and 2019. Raw data on country-level enrollment and completion rates 
comes from the World Bank's [World Development Indicators Database](https://databank.worldbank.org/source/world-development-indicators). The data set that we'll use is posted [here](https://pjakiela.github.io/ECON523/exercises/E5-fpedata-1981-to-2019.dta). We will use this data set to generate two-way fixed effects (TWFE) estimates of the impact of eliminating school fees on enrollment 
and completion. Since this policy was phased in by different countries at 
different times, it is a useful setting for exploring the strengths and 
weaknesses of TWFE.

<br>

## Getting Started

Before you begin, create an R script (with all the standard stuff at the top) that downloads [the data set](https://pjakiela.github.io/ECON523/exercises/E5-fpedata-1981-to-2019.dta). Make sure to load the `haven` library, since the data is in stata format. Familiarize yourself with the data.  What years does it cover?   

<br>

## In-Class Activity

The **gross primary enrollment ratio** is 100 times the number of students enrolled in primary school divided by the number of primary-school-aged children. This number can be greater than 100 when over-age children are enrolled in primary school - which often happens when school fees are eliminated.  What was the average level of primary school enrollment in 1981 (at the beginning of the data set)?  What was the average level of primary school enrollment in the last year for which data is available?  In how many country-years is the gross primary enrollment ratio above 100?

In the first activity, we'll be using `enroll` as our outcome variable.  Drop country-years for which `enroll` is missing. 

### Question 1

Generate a treatment dummy `fpe` that is equal to one for years where where primary school is free (i.e. all years starting from the year when FPE was implemented in a particular country).  What is the mean of this variable across all country-years in the data set?

### Question 2

Regress gross enrollment on `fpe` controlling for country and year fixed effects. What is the estimated impact of eliminating school fees on enrollment?

### Question 3

Next we are going to construct the TWFE estimate of the impact of FPE "by hand" using the residuals.  

#### Part (a)

Regress `fpe` on country and year fixed effects, and generate a variable `tresid` (short for treatment residual) equal to the residuals from the regression  (make sure that you drop the country-years with missing values of the outcome variable before you do this).   

#### Part (b)

Regress `enroll` on country and year fixed effects, and generate a variable `yresid` that contains the residuals from that regression. Make sure that you restrict the sample to observations with `fpe` not equal to missing.    

#### Part (c)

Regress `yresid` on `tresid`.  Confirm that you recover your TWFE estimate from Question 2. Your standard errors should not match those from Question 2, but they should be reasonably close. 

#### Part (d)

What fraction of the treated country-years received negative weight in our TWFE regression?

#### Part (e)

**Optional.** The TWFE coefficient is a linear combination of the observed values of the outcome variable, with each value of Y weighted by the associated residualized value of treatment (`tresid`) divided by the sum of all the squared values of `tresid`.  Confirm that this is correct by:  

1. Calculating a variable `tr2` equal to the square of `tresid`,
2. Calculating a variable `denom` equal to the sum of `tr2` across all observations,
3. Generating a `weight` variable equal to `tresid` divided by `denom`,
4. Generating a variable `yxweight` that is equal to the observed value of `enroll` (the outcome variable) times the regression `weight`, and 
5. Calculating the TWFE coefficient as the sum of `yxweight` across all observations.
  
Now that you know you can do this by hand, we will never do it again. Drop `yresid`, `tresid`, `tr2`, `weight`, `yxweight`, and `betahat` from the data frame.

<br>

## Empirical Exercise

Next, we're going to estimate the impact of eliminating primary school fees on primary school completion.  Create a new R script (with all the standard stuff at the top) that downloads [the data set](E5-fpedata-1981-to-2019.dta).  The variable `complete` indicates the primary school completion rate.  What was the mean level of primary school completion (across countries in the sample) in 1981?  What was the level of primary school completion in 2019?  Drop any country-years that are missing data on the primary school completion rate.  Extend your script as you answer the questions below.  

### Question 1

Estimate a TWFE regression of primary school completion on fpe controlling for country and year fixed effects. Cluster your standard errors at the country level. Store your results (for example, in a `results` data frame) so that you can export them to Excel later.

### Question 2

Given what you know about TWFE, and given the nature of the policy and outcome under consideration, why might you have expected the coefficient (on fpe) in in the regression above to be biased down? 

### Question 3

Install the `did2s` package and load the library so that you can implement the imputation-based estimator proposed by Gardner et al (2024). Regress primary school completion on `fpe` controlling for country and year fixed effects using `did2s`. Store your estimates, and then export the results from both of your regression results to word or excel. Save the resulting table as a pdf.  

 ---
 
This exercise is part of the module [Two-Way Fixed Effects](https://pjakiela.github.io/ECON523/M5-TWFE.html).
