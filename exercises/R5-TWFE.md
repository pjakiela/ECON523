# Empirical Exercise 5 in R

In this exercise, we'll be using a data set on primary school enrollment and 
completion in 35 African countries, 15 if which eliminated primary school fees 
between 1990 and 2015. Raw data on country-level enrollment and completion rates 
comes from the World Bank's [World Development Indicators Database](https://databank.worldbank.org/source/world-development-indicators). The data set 
that we'll use is posted [here](https://pjakiela.github.io/ECON523/exercises/E5-fpedata.dta). We will use this data set to generate two-way fixed 
effects (TWFE) estimates of the impact of eliminating school fees on enrollment 
and completion. Since this policy was phased in by different countries at 
different times, it is a useful setting for exploring the strengths and 
weaknesses of TWFE.

<br>

## Getting Started

Before you begin, create an R script (with all the standard stuff at the top) that downloads [the data set](https://pjakiela.github.io/ECON523/exercises/E5-fpedata.dta). Make sure to load 
the `haven` library, since the data is in stata format. Familiarize yourself with the data.  What years does it cover?   

<br>

## In-Class Activity

The variable `fpe_year` indicates the year in which a country implemented free primary education (FPE).  How many countries implemented FPE?  

The **gross primary enrollment ratio** is 100 times the number of students enrolled in primary school divided by the number of primary-school-aged children. This number 
can be greater than 100 when over-age children are enrolled in primary school - which often happens when school fees are eliminated.  What was the average level of primary school enrollment 
in 1981 (at the beginning of the data set)?  What was the average level of primary school enrollment in the last year for which data is available?  In how many country-years 
is the gross primary enrollment ratio above 100?

In the first activity, we'll be using `enroll` as our outcome variable.  Drop country-years for which `enroll` is missing. 

### Question 1

Generate a treatment dummy `fpe` that is equal to one for years where where primary school is free (i.e. all years starting from the year when 
FPE was implemented in a particular country).  What is the mean of this variable across all country-years in the data set?

### Question 2

Regress gross enrollment on `fpe` controlling for country and year fixed effects.  Restrict the sample to countries that eventually implemented FPE. Though we would normally cluster 
our standard errors at the country level, do not do so in this case.  What is the estimated impact of eliminating school fees on enrollment?

Hint: an an easy way to do this is to create a data frame `fpe_sample` that includes only data from countries that eventually implemented free primary.  

### Question 3

Next we are going to construct the TWFE estimate of the impact of FPE "by hand" using the residuals.  

#### Part (a)

Regress `fpe` on country and year fixed effects, and generate a variable `tresid` (short for treatment residual) equal to the residuals from the regression (make sure that you drop the country-years with missing values of the outcome variable before you do this).  

#### Part (b)

Regress `enroll` on country and year fixed effects, and generate a variable `yresid` that contains the residuals from that regression. Make sure that you restrict the sample to obesrvations with `fpe` not equal to missing.  

#### Part (c)

Regress `yresid` on `tresid`.  Confirm that you recover your TWFE estimate from Question 2.  

Your standard errors should not match those from Question 2, but they should be reasonably close. Confirm that the standard error from Question 2 multiplied by the square root of 555/502 (the ratio of the degrees of freedom in the two regressions) matches the standard error above **exactly**.  

#### Part (d)

What fraction of the treated country-years received negative weight in our TWFE regression?

#### Part (e)

The TWFE coefficient is a linear combination of the observed values of the outcome variable, with each value of Y weighted by the associated residualized value of treatment (`tresid`) divided by the sum of all the squared values of `tresid`.  Confirm that this is correct by:  

1. Calculating a variable `tr2` equal to the square of `tresid`,
2. Using `egen`'s `sum` option to calculate a variable `tvar` equal to the sum of `tr2` across all observations,
3. Generating a `weight` variable equal to `tresid` divided by `tvar`,
4. Generating a variable `yxweight` that is equal to the observed value of `enroll` (the outcome variable) times the regression `weight`, and 
5. Calculating the TWFE coefficient as the sum of `yxweight` across all observations.

#### Part (f)

Now that you know you can do this by hand, we will never do it again. Drop `yresid`, `tresid`, `tr2`, `weight`, `yxweight`, and `betahat`.

### Question 4

Now rerun your TWFE regression including the never-treated countries.  How many treated country-years are negatively weighted now?  How much does eliminating negative weights change your coefficient of interest?

<br>

## Empirical Exercise

Next, we're going to estimate the impact of eliminating primary school fees on primary school completion.  Create a new do file (with all the standard stuff at the top) that downloads [the data set](E5-fpedata.dta).  The variable `complete` indicates the primary school completion rate.  What was the mean level of primary school completion (across countries in the sample) in 1981?  What was the level of primary school completion in 2020?  Drop any country-years that are missing data on the primary school completion rate.  Extend your do file as you answer the questions below.

### Question 1

Estimate two TWFE regressions of primary school completion on `fpe` controlling for country and year fixed effects.  In your first regression, include only the countries that eventually implemented free primary; include all the countries in the data set in your second regression.  Cluster your standard errors at the country level.  Export your regression results to word or excel, and take a screen shot of your resulting (nicely formatted) table.  As a reminder, guidance on how to make nice looking tables is available [here](https://pjakiela.github.io/stata/regression-table.html).

### Question 2

Given what you know about TWFE, and given the nature of the policy and outcome under consideration, why might you have expected the coefficient (on `fpe`) in Column 1 to be smaller than the coefficient in Column 2?  

### Question 3:  negative weights

#### Part (a)

What proportion of treated country-years (i.e. country-years with `fpe` equal to one) receive negative weighting in the TWFE estimation when you exclude the never-treated countries?  

#### Part (b)

What proportion of treated country-years receive negative weighting in the TWFE estimation when you include the never treated countries?

### Question 4:  event studies

#### Part (a)

Generate a relative time variable `rel_time` that indicates the difference between the (current, for each observation) year and the year in which FPE was implemented in that country.

#### Part (b)

Summarize the `rel_time` variable.  What is the maximum number of years that we observe **before** a country implements free primary (among countries that eventually implement it)?  Use the loop below to generate variables `minus_2`, `minus_3`, `minus_4` etc that are dummies equal to one for country-years (respectively) 2, 3, 4 etc. years before a country implements free primary.  For countries that never implement free primary, these variables should be equal to 0 for all years.  
```
forvalues i = 2/27 {
 gen minus_`i' = (fpe_year - year==`i' & nevertreated==0)
}
```

#### Part (c)

What is the maximum number of years that we observe **after** a country implements free primary (among countries that eventually implement it)?  Generate variables `plus_0`, `plus_1`, `plus_2` etc that are dummies equal to one for country-years (respectively) 0, 1, 2 etc. years after a country implements free primary.  The variable `plus_0` indicates the year FPE was first implemented.  For countries that never implement free primary, these variables should be equal to 0 for all years.

#### Part (d) 

Now implement the event study design by regressing `complete` on country and year fixed effects as well as the `minus_*` and `plus_*` variables.  What patterns of significance do you observe among the `plus_*` variables?  Is there ever a statistically significant impact of FPE on primary school completion?  What patterns of significance do you observe among the `minus_*` variables?  Is there evidence that the assumption of common trends is violated?

#### Part (e)

Adapt the code from the do file [ECON523-E5-event-study-example.do](ECON523-E5-event-study-example.do) to make an event study graph of your results.  Save the graph as a pdf or png file (so that you can upload it later).  What does the graph suggest about your TWFE model?

### Question 5:  restricting the sample

#### Part (a)

Rerun your event study regression in a restricted sample. To decide how to do this, first tabulate the observed values of the the `rel_time` variable: at what points do you observe a marked drop off in the number of observations? In other words, at what values of positive and negative relative time do you start to see evidence that effects would be based on only a restricted set of countries? Keep a restricted subsample of your data such that your event-time effects are estimated off of a broadly comparable set of countries, and then restrict the years of data on never-treated countries that you include to match the years observed among the (eventually) treated countries. Restrict the sample in other ways as you see fit (you will have to explain your choices when you submit your work).  

#### Part (b)

Make a new event study plot that presents the results in your trimmed (i.e. restricted sample). Highlight the pre-treatment periods in a color that is distinct from the post-treatment periods. Make your figure look as professional as possible and savie it as a pdf or png file.  

 ---
 
This exercise is part of the module [Two-Way Fixed Effects](https://pjakiela.github.io/ECON523/M5-TWFE.html).
