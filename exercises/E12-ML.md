# Empirical Exercise 12

In this exercise, we use data form the paper 
[Enhancing Young Children's Language Acquisition Through Parent-Child Book Sharing: a Randomized Trial in Rural Kenya](https://reader.elsevier.com/reader/sd/pii/S0885200619300031?token=1F2F65360247614DE641216A687BF6FBCB686DE10A672999342CF31DF27B5E7DB348624A0CC87FD6A6528E06CDD2E8FE) 
by Lia C.H. Fernald, Heather A. Knauer, Pamela Jakiela, and Owen Ozier.  The study 
examines the short-term impact of dialogic reading training combined with mother 
tongue storybooks.  The authors use data from this short-term study to calculate the statistical power of a subsequent cluster-randomized trial, 
as described in [Evaluating the Effect of an Early Literacy Intervention](https://pjakiela.github.io/research/EMERGE-registered-report-accepted.pdf).  Because 
child outcomes are highly correlated over time, selecting the right covariates can increase statistical power substantially.

<br> 

## Getting Started 

Begin by creating a do file that reads in the data set `E12-storybooks-data.dta1`.  Familiarize yourself with the dataset and 
the range of baseline variables included in it.  The key outcome variable is `e_zstoryexp`, a measure of the 
expressive vocabulary children might have picked up from the storybooks.  The data 
set also contains a large set of baseline covariates.  Extend your do file as you answer the following questions.

<br> 

## Empirical Exercise

### Question 1

Regress the outcome `e_zstoryexp` on `treatment`.  What is the p-value associated with the test of the hypothesis 
that treatment has no impact on children's vocabulary?

### Question 2

Predict the residuals from the regression above.  What is the variance of the residuals?

### Question 3

Use `lasso` to identify the baseline covariates that predict `treatment`.  Use cross-validation to choose the tuning parameter, lambda.  Which variables 
does lasso select as predictors of `treatment`?  Store the selected variables in a local named `Tvars`.

### Question 4

Use `lasso` to identify the baseline covariates that predict `e_zstoryexp`.  Use cross-validation to choose the tuning parameter, 
lambda.  Make sure you tell lasso to always include the `treatment` variable.  Which variables does lasso select as predictors 
of the outcome?  Store the selected variables in a local named `Yvars`.

### Question 5

Regress the outcome `e_zstoryexp` on treatment including all the controls selected by lasso.  What is the p-value 
associated with the test of the hypothesis that treatment has no impact on children's vocabulary?

### Question 6

Predict the residuals from the regression that includes the controls selected by lasso.  What is the variance of these residuals?

<br>

 ---
 
This exercise is part of the module [Choosing Covariates](https://pjakiela.github.io/ECON523/M12-covariates.html).
