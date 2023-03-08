# Empirical Exercise 5

In this exercise, we'll be using a data set on primary school enrollment and 
completion in 35 African countries, 15 if which eliminated primary school fees 
between 1990 and 2015. Raw data on country-level enrollment and completion rates 
comes from the World Bank's [World Development Indicators Database](https://databank.worldbank.org/source/world-development-indicators). The data set 
that we'll use is posted [here](https://pjakiela.github.io/ECON523/exercises/E5-fpedata.dta). We will use this data set to generate two-way fixed 
effects (TWFE) estimates of the impact of eliminating school fees on enrollment 
and completion. Since this policy was phased in by different countries at 
different times, it is a useful setting for exploring the strengths and 
weaknesses of TWFE.

You can access the in-class activity as a [do file](ECON523-E5-in-class.do) or [pdf](ECON523-E5-in-class.pdf).

You can also access the empirical exercise as a [do file](ECON523-E5-questions.do) or [pdf](ECON523-E5-questions.pdf).

<br>

## Getting Started

Before you begin, create a do file (with all the standard stuff at the top) that downloads [the data set](https://pjakiela.github.io/ECON523/exercises/E5-fpedata.dta).  Familiarize yourself with the data.  What years does it cover?  What variable indicates the year in which a country implemented free primary education (FPE)?  How many countries implemented FPE?  

<br>

## In-Class Activity

The **gross primary enrollment ratio** is 100 times the number of students enrolled in primary school divided by the number of primary-school-aged children. This number can be greater than 100 when over-age children are enrolled in primary school - which often happens when school fees are eliminated.  What was the average level of primary school enrollment in 1981 (at the beginning of the data set)?  What was the average year of primary school enrollment in the last year for which data is available?  In how many country-years is the gross primary enrollment ratio above 100?

In the first activity, we'll be using `enroll` as our outcome variable.  Drop country-years for which `enroll` is missing. 

### Question 1

Generate a treatment dummy `fpe` that is equal to one for years where where primary school is free (i.e. all years starting from the year when FPE was implemented in  a particular country).  Label this variable "Free primary education".  What is the mean of this variable across all country-years in the data set?

### Question 2

Regress gross enrollment on `fpe` controlling for country and year fixed effects.  Restrict the sample to countries that eventually implemented FPE (an easy way to do this is to go back up a few lines in your do file and make `fpe` missing for observations in countries that never implemented free primary).  Cluster your standard errors at the country level.  What is the estimated impact of eliminating school fees on enrollment?

### Question 3

Next we are going to construct the TWFE estimate of the impact of FPE "by hand" using the residuals. 

#### Part (a)

Regress `fpe` on country and year fixed effects, and generate a variable `tresid` (short for treatment residual) equal to the residuals from the regression (make sure that you drop the country-years with missing values of the outcome variable before you do this).

#### Part (b)

Regress `enroll` on country and year fixed effects, and generate a variable `yresid` that contains the residuals from that regression.

#### Part (c)

Regress `yresid` on `tresid`.  Confirm that you recover your TWFE estimate from Question 2.

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

Now rerun your TWFE regression including the never-treated countries.  How many treated country-years are negatively weighted now?

<br>

## Empirical Exercise

Create a new do file (with all the standard stuff at the top) that downloads the data set [the data set](https://pjakiela.github.io/ECON523/exercises/E5-fpedata.dta).  Drop any country-years that are missing data on the primary school completion rate.  Extend your do file as you answer the questions below.

### Question 1

Estimate two TWFE regressions of primary school completion on `fpe` controlling for country and year fixed effects.  In your first regression, include only the countries that eventually implemented free primary; include all the countries in the data set in your second regression.  Cluster your standard errors at the country level.  Export your regression results to word, and take a screen shot of your resulting (nice looking) table.

### Question 2

Given what you know about TWFE, and given the nature of the policy and outcome under consideration, why might you have expected the coefficient (on `fpe`) in Column 1 to be smaller than the coefficient in Column 2?  

### Question 3:  Negative weights.

#### Part (a)

What proportion of treated country years receive negative weighting in the TWFE estimation when you exclude the never treated countries?  You can answer this question by generating and then summarizing a variable that is 1 for treated observations (i.e. country-years) receiving negative weight in TWFE, 0 for treated observations receiving positive weight in TWFE, and missing for untreated country-years.

#### Part (b)

What proportion of treated country years receive negative weighting in the TWFE estimation when you include the never treated countries?

### Question 4:  Event studies.

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

Now implement the event study design by regressing complete on country and year fixed effects as well as the `minus_*` and `plus_*` variables.  What patterns of significance do you observe among the `plus_*` variables?  Is there ever a statistically significant impact of FPE on primary school completion?  What patterns of significance do you observe among the `minus_*` variables?  Is there evidence that the assumption of common trends is violated?

#### Part (e)

Adapt the code from the do file [ECON523-E5-event-study-example.do](ECON523-E5-event-study-example.do) to make an event study graph of your results.  Save the graph as a pdf or png file (so that you can upload it later).  What does the graph suggest about your TWFE model?

### Question 5:  Trimming

#### Part (a)

Rerun your event study regressions.  Use the post-estimation `test` command to test whether you can reject the hypothesis that `minus_2` is equal to 0.  (You should not be able to).  Now test the joint hypothesis that `minus_2` and `minus_3` are both equal to 0.  Continue adding additional pre-treatment terms to your join test until you can reject the hypothesis that they are all zero at the 90 percent level.

#### Part (b)

Use the results from Question 5a to exclude some pre-treatment observations (where common trends appears to be violated).  In other words, drop observations based on their relative time, so that you can implement an event study design where none of your pre-FPE terms is statistically significant.

#### Part (c)

Make a new event study plot that presents the results in your trimmed (i.e. restricted sample). 

#### Part (d)

Make a table that reports the results of two TWFE regressions of primary school completion rates on the FPE dummy.  In Column 1, include only the countries that eventually implemented free primary.  In Column 2, include all the countries in the sample.  Cluster your standard errors at the country level, report standard errors rather than t-statistics, and make your table look as professional as possible.  Export your results to  word, and take a screen shot of your finished table (so that you can upload it later). 

### Question 6 

From a statistical perspective, do you think it is good or bad that we trimmed the data by including only eight years prior to the implementation of free primary?  Justify your answer (in no more than 2 or 3 sentences).

 ---
 
This exercise is part of the [Two-Way Fixed Effects](https://pjakiela.github.io/ECON523/M5-TWFE.html)  module.
