# Empirical Exercise 9

This is the first of two exercises on power calculations in indiviudal-level randomizations. In this exercise, 
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

##### Question 1

Your are designing an intervention intended to increase knowledge about malaria transmission.  Your 
main outcome variable of interest is `b_knowledge_correct`.  Summarize this variable using 
the `sum` command with the `detail` option.  What is the estimated **standard deviation** of 
`b_knowledge_correct`?

##### Question 2

What is the estimated **variance** of `b_knowledge_correct`?

##### Question 3

Using the formula for the minimum detectable effect, calculate the MDE given your sample size 
if you assume equally-sized treatment and comparison groups (so P in the formula = 0.5).  What 
is the MDE?

##### Question 4 

Now use the `sampsi` command to calculate the sample size you would need to detect an MDE equal 
to your answer to Question 3, given the standard deviation of the outcome variable.  What sample 
size does `sampsi` indicate that you need?

##### Question 5

The treatment dummy in the original study is `act_any`.  Based on this variable, what is the ratio 
of treated obesrvations to control observations?  

##### Question 6

Use the formula to calculate the MDE in the study (if you used the same outcome variable as above, 
`b_knowledge_correct`) given the actual ratio of treatment to control observations.  What is the MDE?

##### Question 7

Now use the `sampsi` command to check your answer.  The `ratio()` option allows you to indicate a ratio of treatment:comparison observations 
that differs from one (note that this is not the same as the proportion of observations that are treated).  What is the 
required sample size that you would need to detect an impact as large as your answer to Question 6?

##### Question 8

One way to increase power is to include controls that explain the observed variation in the outcome variable.  When you plan to include 
controls, the standard deviation used in the MDE calculuation is the standard deviation of the the **residuals** after regressing 
the outcome on the controls.  Replace the missing values of the variables `b_acres` with zeroes.  Then, 
regress `b_knowledge_correct` on `b_h_edu`, `b_hh_size`, `b_acres`, and `b_dist_km`.  Use the post-estimation command 
`predict` to predict the residuals, generating the new variable `yresid`.  Then summarize `yresid`.  What is the standard 
deviation of the outcome variable **after regressing on the controls**?

##### Question 9 

Using the standard deviation of the residualized outcome variable, calculate the MDE (using the assumptions about 
the ratio of treatment and control observations that you used in Question 6).  What is the MDE?

##### Question 10

What is the mean of the outcome variable, `b_knowledge_correct`?

##### Question 11

Express the MDE as a perecentage of the outcome variable of interest:  how large of a (percent) change in `b_knowledge_correct` would we need to anticipate if we wanted to have power of 0.8 to detect it?

##### Question 12

Now we will consider a completely different data set: the data on access to microfinance that we used in Empirical Exercise 8.  The data comes from the paper [The Miracle of Microfinance?  Evidence from a Randomized Evaluation](https://www.jstor.org/stable/43189512?seq=1) by 
Abhijit Banerjee, Esther Duflo, Rachel Glennerster, and Cynthia Kinnan.  The paper reports the results of one of the first randomized evaluations of a microcredit intervention.  The authors worked with an Indian MFI (microfinance institution) called Spandana that was expanding into the city of Hyderabad.  Spandana identified 104 neighborhoods where it would be willing to open branches.  They couldn't open branches in all the neighborhoods simultaneously, so they worked with the researchers to assign half of them to a treatment group where branches would be opened immediately.  Spandana held off on opening branches in the control neighborhoods until after the study. 

Use the code below to read the data into Stata and drop the observations where our outcome variable of interest, `bizprofit_1`, is missing:

```
clear
webuse set https://pjakiela.github.io/ECON379/exercises/E8-TOT/
webuse E8-BanerjeeEtAl-data.dta
drop if bizprofit_1==.
```

Look at a histogram of the `bizprofit_1` variable.  What do you notice about its distribution?  Now use the `sum` command with the `detail` option.  What 
is the mean of `bizprofit_1`?

##### Question 13

What is the standard deviation of `bizprofit_1`?

##### Question 14

Given the size of this data set and the standard deviation of `bizprofit_1`, what is the MDE if you wanted to have power of 0.8 (assuming treatment and comparison groups of equal size)?  

##### Question 15

How does this MDE compare to the mean of the outcome variable?  How large of a percent change in the outcome would you need to anticipate if you wanted to have power of at least 0.8?  

