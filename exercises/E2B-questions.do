
// ECON 523:  PROGRAM EVALUATION FOR INTERNATIONAL DEVELOPMENT
// PROFESSOR PAMELA JAKIELA
// EMPIRICAL EXERCISE 2, PART 2:  SELECTION BIAS AND THE EXPERIMENTAL IDEAL


/***************************************************************************
In this exercise, we'll use Stata's rnormal() command to generate draws from 
a normally-distributed random variable.  This approach - simulating data 
according to a known data-generating process - is an incredibly useful tool 
in empirical microeconomics (both for checking your econometric intuitions and 
your anlayis code).  

We'll use "locals" (also know as "local macros") to easily change the number of 
observations and other parameters of our data set.  This will allow us to 
explore the way the properties of randomly-assigned treatment groups in 
larger and smaller samples.

******************************************************************************/


// PRELIMINARIES

** start with a clean workspace
clear all
set more off // setting more off prevents your code from stopping halfway through
set seed 12345 // setting the seed makes pseudo-random draws replicable
version 16.1 // make sure you use a specific version of Stata (for replicability)

** save your do file to a local directory no (do this by hand, not in code)


// GENERATE A DATA SET

** define a local that we'll use to indicate the number of observations
local myobs = 500
display "`myobs`"

** use the local to create an empty data set with N=myobs rows
set obs `myobs'

** define some variables
gen y = rnormal()
gen z = 5*rnormal() + 10




// EMPIRICAL EXERCISE

// Question 1 

** What is the mean of `z`?  



// Question 2 

** Use the command `egen mean_z = mean(z)` to generate a new variable equal to the mean of `z`.  What is the standard deviation of your new variable, `mean_z`?



// Question 3

** Generate another variable, `diff_z`, equal to the difference between `z` and `mean_z`.  What is the mean of this variable?



// Question 4 

** Generate yet another new variable, this one equal to `diff_z` squared.  Call this variable `diff2_z`.  Now use the code below to calculate the sum of `diff2_z` across all observations, and to transform that sum into the standard deviation of `z` by dividing by the number of observations and then taking the square root.  

egen sd_z = total(diff2_z)
replace sd_z = sd_z / (`myobs' - 1)
replace sd_z = sqrt(sd_z)

** What is the mean of `sd_z`?




// Question 5 

**Our estimator of the **population** mean of `z` is the sample mean of `z`, and the standard error of that estimator is the sample standard deviation (that you calculated above) divided by the square root of the number of observations in your sample.  Write a line of code to generate a new variable, `se_mean_z`, equal to the standard error of the mean of `z`.


// Question 6 

** What is the standard error of the mean of `z`?  Confirm that the answer generated by the code you wrote for Question 5 is the same as the answer you'd get from the `ci means z` or `ttest z = 0` commands.



// Question 7 

** What happens when we randomly assign treatment?  Random assignment should generate two groups (a treatment group and a control group) that look similar in terms of their observable characteristics.  We can use the code below to assign half the observations in our sample to a treatment group.


** assign half the sample (observations 1 to N/2) to treatment
count
return list 
local cutoff = (r(N)/1)/2
gen treatment = 1 in 1/`cutoff'
replace treatment = 0 if treatment==.


** If we were randomly assigning treatment in a data set that we had not just generated, we would first want to sort our data into a random order - but here, that is not necessary since `y` and `z` are randomly-generated to begin with.  

** Now that you have generated a treatment dummy variable, test the hypothesis that the mean of `z` is the same in the treatment group and the comparison group.  What is the p-value associated with this hypothesis test?  









