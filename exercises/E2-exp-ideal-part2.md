# Empirical Exercise 2, Part 2

In this exercise, we'll use Stata's `rnormal()` command to generate draws from a normally-distributed random variable.  This approach - simulating data 
according to a known data-generating process - is an incredibly useful tool in empirical microeconomics (both for checking your econometric intuitions and 
your anlayis code).  

We'll use "locals" (also know as "local macros") to easily change the number of observations and other parameters of our data set.  This will allow us to 
explore the properties of randomly-assigned treatment groups in larger and smaller samples.   

Please upload your answers to gradescope after completing the exercise.  You can also download the entire activity 
as a [do file](https://pjakiela.github.io/ECON523/exercises/E2B-questions.do).  

<br>

## Getting Started 

Start a do file with the standard code at the top (making sure to save your do file where you can find it later):

```
// PRELIMINARIES

** start with a clean workspace
clear all
set more off 
set seed 12345 
version 16.1 
```

The `set seed` and `version` commands are particularly important here, because we are going to be generating data using Stata's pseudo-random number generator.  Setting the 
seed and specifying the version of Stata that the computer should use will guarantee that your results are the same whenever (and wherever) you run your code.  

Now we are going to generate a data set that contains 500 observations of two normally-distributed variables, `y` and `z`.  We'll start by defining a **local macro** `myobs` that indicates the number of observations we want in our data set.  You can type `help macros` to learn more about local and global macros, but the short version (according to the help file) is that macros are "the variables of Stata programs."  We can use a local macro in a do file to set a parameter (like the number of observations, or the name of our dependent variable) that will be used repeatedly throughout the program.  We can define the macro at the top of the do file, and then - if we want to change it - we need only update the do file in a single place.

Here, we define the local macro `myobs`, setting it equal to 500.  If we want to see that we've defined the local correctly, we can use the `display` command (putting the local in two sets of quotes).
```
** define a local to indicate the number of observations
local myobs = 500
display "`myobs`"
```

Having defined our local, we can use it in place of the number 500.  Use the `set obs` command to set the number of observations (i.e. rows) in an otherwise empty data set.  The `count` command tells us that we've succeeded in creating a data set with 500 observations.
```
** create an empty data set with N=myobs rows
set obs `myobs'
count
```

Now, we'll use Stata's `rnormal()` function to create a variable, `y`, that is normally-distributed with mean zero and variance one (i.e. a standard normal).  We can also scale the a standard normal to create a variable with a different mean and/or variance.
```
** define some variables
gen y = rnormal()
gen z = 5*rnormal() + 10
```

Use the `sum`, `ci means`, `ttest`, and `histogram` commands to familiarize yourself with `y` and `z`.  What is the estimated mean of each variable?  What is the estimated standard deviation? What is the standard error associated with the estimate of the mean of each variable?  

Use the `histogram` command to plot a histogram of each variable.  Does this look like a normal distribution?  Rerun your do file, changing the number of observations from 500 to 50,000.  How do the histograms of `y` and `z` change as you increase the sample size?  What happens to the estimates of the mean, the standard deviation, and the standard error of the sample mean as you increase the sample?  

<br> 

## Empirircal Exercise

Set the sample size back to 500 and rerun your code.  

### Question 1 

What is the mean of `z`?  

### Question 2 

Use the command `egen mean_z = mean(z)` to generate a new variable equal to the mean of `z`.  What is the standard deviation of your new variable, `mean_z`?

### Question 3

Generate another variable, `diff_z`, equal to the difference between `z` and `mean_z`.  What is the mean of this variable?

### Question 4 

Generate yet another new variable, this one equal to `diff_z` squared.  Call this variable `diff2_z`.  Now use the code below to calculate the sum of `diff2_z` across all observations, and to transform that sum into the standard deviation of `z` by dividing by the number of observations and then taking the square root.  
```
egen sd_z = total(diff2_z)
replace sd_z = sd_z / (`myobs'-1)
replace sd_z = sqrt(sd_z)
```

What is the mean of `sd_z`?  It should be nearly identical to the standard deviation of `z` as reported by the `sum` or `ttest` commands.  

### Question 5 

Our estimator of the **population** mean of `z` is the **sample** mean of `z`, and the standard error of that estimator is the sample standard deviation (that you calculated above) divided by the square root of the number of observations in your sample.  Write a line of code to generate a new variable, `se_mean_z`, equal to the standard error of the mean of `z`.  

### Question 6 

What is the standard error of the mean of `z`?  Confirm that the answer generated by the code you wrote for Question 5 is the same as the answer you'd get from the `ci means z` or `ttest z = 0` commands.

### Question 7 

What happens when we randomly assign treatment?  Random assignment should generate two groups (a treatment group and a control group) that look similar in terms of their observable characteristics.  We can use the code below to assign half the observations in our sample to a treatment group.
```
** assign half the sample (observations 1 to N/2) to treatment
count
return list 
local cutoff = (r(N)/1)/2
gen treatment = 1 in 1/`cutoff'
replace treatment = 0 if treatment==.
```

If we were randomly assigning treatment in a data set that we had not just generated, we would first want to sort our data into a random order - but here, that is not necessary since `y` and `z` are randomly-generated to begin with.  

Now that you have generated a treatment dummy variable, test the hypothesis that the mean of `z` is the same in the treatment group and the comparison group.  What is the p-value associated with this hypothesis test?  
