# Empirical Exercise 2

This exercise makes use of the data set [E2-BanerjeeEtAl-data.dta](https://pjakiela.github.io/ECON523/exercises/E2-BanerjeeEtAl-data.dta), 
a subset of the data used in the 
paper [A multifaceted program causes lasting progress for the very poor: Evidence from six countries](https://www.science.org/doi/abs/10.1126/science.1260799) 
by Abhijit Banerjee, Esther Duflo, Nathanael Goldberg, Dean Karlan, William Pariente, 
Jeremy Shapiro, Bram Thuysbaert, and Chris Udry, published in the _Science_ in 2015.  

The authors examine the impacts of a "graduation" program first designed by 
the Bangladeshi NGO BRAC.  The program offers extremely poor households an 
asset transfer, temporary consumption support, skills training, home visits, 
and access to savings technologies.  The program was evaluated through a 
randomized trial in six countries.  

In this exercise, we use data on the program's impacts on food security to 
explore the mechanics of fixed effects.

<br>

## Getting Started 

Create an R script that contains the following preliminaries:

```
# preliminaries -----------------------------------------

## libraries

#install.packages("tidyverse")
#install.packages("haven") # load dta files
#install.packages("fixest") # OLS w/ robust SEs

library(tidyverse)
library(haven)
library(fixest)

## load data 

urlfile <- 'https://pjakiela.github.io/ECON523/exercises/E2-BanerjeeEtAl-data.dta'
e2data <- read_dta(urlfile)
```

<br>

## In-Class Activity

Extend your script as you answer the following questions, so that you can run the code from start to finish and re-generate all your answers.  

### Question 1  

Familiarize yourself with the data set.  How many countries are included in the study, 
and how many observations are there in each country?  What fraction of the observations from each country were treated?  

Hint: use `count()` to count the number of observations from each country, use `table()` to do a cross-tabulation of two variables, and use `group_by()` followed by `summarize()` to calculate the mean value of `treatment` in each each country.  

### Question 2  

Take a look at the outcome variable `e_foodsec`.  What is the mean value in each country?  What is the mean value **in the treatment group** 
in each country?  What does a histogram of the food security index look like?  

Hint: use `hist()` to make a simple histogram.  

### Question 3

Regress food security on treatment.  What do you find?  How should we interpret this coefficient?  

Hint: use `feols()`, as we did in Exercise 1. The general syntax is: 
```
feols(y ~ x, data = df, vcov = 'hc1')
```  

### Question 4

Now regress food security on treatment controlling for country fixed effects.  How do the results change?  

Hint: to add fixed effects for categorical variable `z` to your `feols` regression equation, use the syntax `y ~ x | z`.

### Question 5

What if we regress food security on treatment separately for each country?  In how many 
of the six countries do we see a positive and statistically significant treatment effect?

Hint: `e2data[e2data$country == 1]` will identify the subset of the rows of `e2data` with `country` equal to 1.

### Question 6 

The regression including country fixed effects is equivalent to a regression where we first subtract off 
country-specific means and then regress de-meaned (or normalized) food security on normalized treatment.  Show 
that this is the case: generate variables `mean_t` and `mean_fs` capturing the within-country means of treatment and food security, 
and then generate `norm_t` and `norm_fs` capturing the normalized values (calculated by subtracting the country-specific mean). Regress 
`norm_fs` on `norm_t` without country fixed effects to confirm that the regression coefficient from Question 4.

Hint: use `group_by()`, then `mutate()` to generate the variables `mean_t` and `mean_fs`, and then `ungroup()` to return the data frame to one where the unit of observation is an individual rather than a country.  

### Question 7 

The regression including country fixed effects is also equivalent to a regression of residualized food security 
(predicted from a regression of food security on country fixed effects) on residualized treatment 
(predicted the same way).  Show that this is the case by generating new variables `fs_resid` and `t_resid` that capture 
the residuals from regressions of food security and treatment on the country fixed effects. Regress `fs_resid` on `t_resid` 
and compare your results to the coefficients from Questions 4 and 6.  

Hint: the example below illustrates how to capture the residuals from a regression:

```
model <- feols(y ~ x, data = df, vcov = 'hc1')
y_resid <- model$residuals
```

### Question 8 

The regression including country fixed effects is also equivalent to a weighted average of the country-specific 
treatment effects.  The weights are proportional to `N*p*(1-p)` where `N` is the number of observations in a country 
and `p` is the proportion treated in that country.  The weights are normalized by dividing by the sum of 
all the weights.  Extend the program below to calculate the treatment effect that you would get from 
a regression controlling for fixed effects.

```
## check: what values should your new variables take on?
e2data %>% group_by(country, treatment) %>% 
  summarize(mean = mean(e_foodsec))

## calculate the weights and the regression coefficient
e2data %>% group_by(country) %>% 
  summarize(mean_fs_t = mean(e_foodsec[treatment == 1], na.rm = TRUE)) %>% 
  mutate(weight = n*mean_t*(1-mean_t) / sum(n*mean_t*(1-mean_t)))
```

<br>

## Empirical Exercise

For this part of the exercise, we're going to drop 
all the observations in the treatment group, and then simulate alternative 
scenarios to better understand how fixed effects work.  Create a new R script that begins with the code below, and 
then extend your program as you answer the questions. Make sure you unerstand what the code below does before proceeding.  

```
# preliminaries ---------------------------------

## libraries

#install.packages("tidyverse")
#install.packages("haven") # load dta files
#install.packages("fixest") # OLS w/ robust SEs

library(tidyverse)
library(haven)
library(fixest)

## load data 

urlfile <- 'https://pjakiela.github.io/ECON523/exercises/E2-BanerjeeEtAl-data.dta'
e2dataraw <- read_dta(urlfile)

## drop treatment group, randomly assign observations to four groups
e2data <- e2dataraw %>% 
  filter(treatment != 1) %>% 
  select(!treatment) %>% 
  mutate(randnum = runif(n())) %>%  
  arrange(country, randnum) %>%  
  group_by(country) %>%
  mutate(within_id = row_number(),  
         group = (within_id %% 4)) %>%  
  mutate(group = ifelse(group == 0, 4, group)) %>% 
  ungroup()
```

### Question 1:  fixed effects when `p` is constant across countries

#### Part (a)

Create a treatment variable `t1` and assign observations in groups 1 and 2 to treatment.  Then, 
create a variable `impact1` that is equal to 2 for observations in the treatment group and 0 otherwise.  This is the treatment effect 
for the purposes of this (first) simulation.  Generate an outcome variable `y1` that is endline foodsecurity (`e_foodsec`) 
plus `impact1`.  Now regress `y1` on `t1` with and without country fixed effects.  How do the estimated treatments effects 
and the levels of statistical significance compare across the two specifications?

#### Part (b)

When the probability of treatment does not vary across countries, including country fixed effects is not necessary - but it may increase 
statistical power. In the example above, fixed effects did not improve statistical power much because the mean of the outcome variable 
does not vary across countries (it is normalized to zero in the control group in every country).  Change this by increasing 
`y1` by 10 in two countries and decreasing `y1` by 20 in two other countries.  Now rerun your two regressions 
(with and without fixed effects).  You should see that including fixed effects now changes the standard error 
on your estimated treatment effect substantially (though it still should not impact your estimated coefficient much).

#### Part (c)

The estimated coefficient from a regression with fixed effects is a weighted average of the estimated country-specific 
treatment effects (i.e. the within-country differences in means between treatment and control).  The weights are proportional to the sample size within 
each country.  Given this, if you increased the treatment effect in Peru from 2 to 11, what you expect the treatment effect to be?  Calculate the expected 
regression coefficient by hand (using R as a calculator) and then adjust your code and run the fixed effects regression to confirm your result.

### Question 2:  When are fixed effects necessary?

Fixed effects are needed when treatment probabilities vary across countries **and** the mean of the outcome variable also varies 
across countries (because then treatment is correlated with the outcome, even in the absence of a treatment effect).  To see this, 
generate a variable `t2` that is equal to 1 for all observations in group 1 plus the observations in group 2 in 
Ethiopia, Ghana, and Honduras (countries 1, 2, and 3).  In this simulation, we are not going to add any treatment effect.  Generate 
an outcome variable `y2` that is equal to food security, and then add 5 to it in Ethiopia, Ghana, and Honduras 
(for observations in the treatment and control groups in those countries).  How do the results of regressions 
with and without country fixed effects compare?

### Question 3:  How observations are weighted with fixed effects.

For the last question, we need to have the same number of observations in each country.  The code below does this.  You can see 
that we now have equal numbers of observations from groups 1, 2, 3, and 4 in each country as well. 

```
keep if within<=360 // 360 obs per country
tab country group 
```

Now generate a treatment variable `t3`.  `t3` should be equal to one for observations in group 1 in 
Ethiopia and Ghana.  `t3` should be equal to one for observations in groups 1 and 2 in Honduras and India.  `t3` should 
be equal to 1 for observations in groups 1, 2, and 3 in Pakistan and Peru. Given this, what is the proportion treated in each country?

#### Part (a) 

First, consider what happens when we **only** have a treatment effect in the countries with the lowest proportion treated. Create 
a variable `impact3` that is equal to 10 for treated observations in Ethiopia and Ghana, and equal to zero for everybody else. Then, 
create an outcome variable `y3a` that is the sum of `e_foodsec` and `impact3a`.  You can see the average treatment effect across 
all the treated observations in the sample summarizing impact3a among all treated individuals.  How does that compare to 
the results of regressions with and without fixed effects, or to the results from a regression that only includes data from Ethiopia and Ghana?

#### Part (b)

Now replicate the exercise above, but have the treatment effect occur in Honduras and India (where the proportion treated is one half) 
rather than in Ethiopia and Ghana (where the proportion treated is one quarter).  Generate new variables `impact3b` and `y3b` and repeat your analysis.

#### Part (c)

Now replicate the exercise again, but have the treatment effect occur in Pakistan and Peru (where the proportion treated is three quarters) 
rather than in Honduras and India (where the proportion treated is one half).  Generate new variables `impact3c` and `y3c` and repeat your analysis.

### Question 4:  Takeaways.

Based on the above, which countries received relatively low weight in the analysis of Banerjee et al. because the proportion treated was relatively low?  How do you think that might have impacted their results?  

<br>

 ---
 
 This exercise is part of the module [Revisiting Regression](https://pjakiela.github.io/ECON523/M2-regression.html).
