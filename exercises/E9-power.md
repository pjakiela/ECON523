# Empirical Exercise 9

This is the first of two exercises on power calculations. In this exercise, 
we'll learn how to calculate the **minimum detectable effect** as a function of sample size 
(or the required sample size as a function of the minimum detectable effect).

<br>

## Getting Started

We'll be using data from two experiments that we've already studied.  The first of these is the 
impact evaluation of malaria treatment that we studied in the first week of class.  The data set 
[E1-CohenEtAl-data.dta](https://pjakiela.github.io/ECON379/exercises/E1-intro/E1-CohenEtAl-data.dta) contains 
(some of  the) data from [Price Subsidies, Diagnostic Tests, and Targeting of Malaria Treatment: Evidence from a Randomized Controlled Trial](https://www.aeaweb.org/articles?id=10.1257/aer.20130267) by Jessica Cohen, Pascaline Dupas, and Simone Schaner, a paper that appeared 
in the _American Economic Review_ in 2015.  The authors examine behavioral responses to various 
discounts ("subsidies") for malaria treatment, called "artemisinin combination therapy" or "ACT."  The J-PAL summary of the experiment and the findings is [here](https://www.povertyactionlab.org/publication/balancing-act).


Create a new do file that downloads the data using the following code (or write a do file that reads the data in from your hard drive, if you've saved it on your computer):
```
webuse set https://pjakiela.github.io/ECON523/exercises
webuse E1-CohenEtAl-data.dta
```

The **minimum detectable effect** or MDE is the smallest impact that we can detect with probability 0.8.  The MDE 
depends on the sample size (N), the proportion of the sample assigned to treatment (P), and the 
standard deviation of our outcome of interest.  We can calculate the MDE using the formula:
![mde](https://pjakiela.github.io/ECON523/exercises/MDE-eq1.png)  

### Question 1

Your are designing an intervention intended to increase knowledge about malaria transmission.  Your 
main outcome variable of interest is the variable `b_knowledge_correct`, which measures beliefs about how malaria 
is transmitted and what can be done to treat it.  Familiarize yourself with this variable:  what is 
its mean, and what are the maximum and minimum values observed in the sample?

Write Stata code that summarizes `b_knowledge_correct`, using the `sum` command with the `detail` option 
so that the standard deviation is saved as a local after you run the command.  What is the estimated **standard deviation** of 
`b_knowledge_correct`?  Write an additional line of code to display the MDE given the standard deviation of 
`b_knowledge_correct` and the sample size, if you assume that the treatment and comparison groups are 
the same size (so P in the formula = 0.5).  What is the MDE?

### Question 2 

You can calculate the sample size needed to detect a particular MDE using Stata `sampsi` command.  Type 
the command:
```
sampsi 0 0.11651129, power(0.8) sd(0.4989005)
```
What sample size does Stata suggest, and how does it compare to the actual sample size (that you used 
to calculate the MDE in Question 1)?

### Question 3

The treatment dummy in the original study is `act_any`.  Based on this variable, what is the ratio 
of treated obesrvations to control observations?  What proportion of the sample was assigned to treatment?

Use the formula to calculate the MDE in the study (if you used the same outcome variable as above, 
`b_knowledge_correct`) given the actual ratio of treatment to control observations.  What is the MDE?

### Question 4

Now use the `sampsi` command to check your answer.  The `ratio()` option allows you to indicate a ratio of treatment:comparison observations 
that differs from one (note that this is not the same as the proportion of observations that are treated).  

### Question 5

How large of a sample size would need to detect the MDE that you calculated in Question 1?

### Question 6

One way to increase power is to include controls that explain the observed variation in the outcome variable.  When you plan to include 
controls, the standard deviation used in the MDE calculuation is the standard deviation of the the **residuals** after regressing 
the outcome on the controls.  Replace the missing values of the variables `b_acres` and `b_dist_km` with the means of those variables.  Then, 
regress `b_knowledge_correct` on `b_h_edu`, `b_hh_size`, `b_acres`, and `b_dist_km`.  Use the post-estimation command 
`predict` to predict the residuals, generating the new variable `yresid`.  Then summarize `yresid`.  What is the standard 
deviation of the outcome variable **after regressing on the controls**?  How does it compare to the standard deviation 
of `b_knowledge_correct` without controls?

### Question 7 

Using the standard deviation of the residualized outcome variable, calculate the MDE (using the assumptions about 
the ratio of treatment and control observations that you used in Question 6).  What is the MDE?

### Question 8

What is the mean of the outcome variable, `b_knowledge_correct`?  Express the MDE as a perecentage of the outcome variable of interest:  how large of a (percent) change in `b_knowledge_correct` would we need to anticipate if we wanted to have power of 0.8 to detect it?

<br>

## More Fun with Stata

Now we will consider a completely different data set: the data on access to microfinance that we used in Empirical Exercise 6 and again in Empirical Exercise 8.  The data comes from the paper [The Miracle of Microfinance?  Evidence from a Randomized Evaluation](https://www.jstor.org/stable/43189512?seq=1) by 
Abhijit Banerjee, Esther Duflo, Rachel Glennerster, and Cynthia Kinnan.  The data comes from a randomized evaluation of a microfinance intervention.  We are particularly interested in the variable `bizprofit_1`, which measures microenterprise profits.  Unlike the knowledge variable used above, the standard deviation of `bizprofit_1` is large relative to its mean.  We will also look at the dummy variable `any_biz_1`, an indicator for operating a microenterprise.

Use the code below to read the data into Stata and drop the observations where our outcome variable of interest, `bizprofit_1`, is missing:
```
clear
webuse set https://pjakiela.github.io/ECON523/exercises/
webuse E6-BanerjeeEtAl-data.dta
keep bizprofit_1 any_biz_1
drop if bizprofit_1==.
```

Look at a histogram of the `bizprofit_1` variable.  What do you notice about its distribution?  Now use the `sum` command with the `detail` option.  What 
is the mean of `bizprofit_1`?  What is the standard deviation of `bizprofit_1`?

Given the size of this data set and the standard deviation of `bizprofit_1`, what is the MDE if you wanted to have power of 0.8 (assuming treatment and comparison groups of equal size)?  How does this MDE compare to the mean of the outcome variable?  How large of a percent change in the outcome would you need to anticipate if you wanted to have power of at least 0.8?  

Now calculate the MDE if you wanted to have power of 0.8 to detect impacts on `any_biz_1`, assuming the treatment and comparison groups are equally sized?  How large of a percent change in the outcome would you need to anticipate if you wanted to have power of at least 0.8?  

