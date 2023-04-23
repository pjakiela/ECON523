# Empirical Exercise 8

In this exercise, we'll be learning how to randomly assign treatment status in a way 
that is transparent and reproducible.  After assigning treatments, we'll check 
whether we've succeeded in creating a treatment group and a control group 
that are comparable in terms of their observable characteristics.  

<br>

## In-Class Activity

Start by creating a new do file that runs the following Stata code:
```
clear
set obs 4
gen id = _n 
gen rand_num = rnormal()
sort rand_num
egen treatment = seq(), from(0) to(1)
sort id
```
What happens when you run the code?  Use Stata's data editor to view the (very small) data set you 
created.  Which ID numbers are assigned to treatment?  Run the code several times.  Are 
the same ID numbers assigned to treatment each time?  

The code above contains the three key parts of every randomization do file:  

1. A command that generates a pseudo-random number 
2. A command that sorts the data based on that random number
3. A command that assigns treatment based on that random sort order

The idea behind random assignment is that we can generate a variable 
using Stata's pseudo-random number generator and then sort the data set based on that 
variable; when we do this, the observations in the data set are listed in a 
random order.  If we want to randomly assign observations to treatment and comparison groups, 
we can assign every other observation to treatment - after we've sorted them based on 
our random `x` variable.

The command 
```
egen treatment = seq(), from(0) to(1)
``` 
generates a repeating sequence from 0 to 1:  the first row (observation) in 
the data set will get a 0, the second row will get a 1, the third row will get a 0, 
and so on.  Familiarize yourself with this command.  How might you assign observations 
in your data set to four different treatment groups?

In the example above, we failed to set the seed, so each time we run our code, we get a 
completely new random treatment assignment.  Insert the command 
```
set seed 1234 
```
between `clear` and `set obs 4`.  This will guarantee that Stata uses the 
same sequence of pseudo-random numbers every time you run the file.  Run the file 
a few times to confirm that this is the case. 

<br>









<br>

## Empirical Exercise

We're going to use the same data set on potential microfinance clients in urban India 
that we worked with in [Empirical Exericse 6](https://pjakiela.github.io/ECON523/exercises/E6-TOT.html). The 
data set contains information on 6,853 households.  We'll only use a subset of the data:  eight variables measuring 
entrepreneurial activity.  

Use the code below to load the data set:  
```
clear all
version 17.0
set more off
set scheme s1mono
set seed 314159
cd "C:\insert-path-here"
webuse set https://pjakiela.github.io/ECON523/exercises/
webuse E6-BanerjeeEtAl-data.dta
keep anymfi_1 anybank_1 anyinformal_1 bizassets_1 ///
	bizinvestment_1 bizrev_1 bizprofit_1 any_biz_1
 ```
Notice that do files assigning treatment always specify both the 
version (of Stata) and the seed. This will ensure that the treatment assignment process is 
replicable:  when the code is re-run on any machine at any time, 
it will always assign the same observations to treatment (and control).  

Before you do anything else, add a line to your do file that creates a unique ID number for 
each observation (using the same code as above).  Then, familiarize yourself with 
the variables in the data set.  How many are dummy variables?  Do the other variables 
look like they are approximately normal?  Why or why not?

### Question 1

Extend your do file so that you randomly assign observations in the data set to either the 
treatment group or a control group.  

### Question 2

Next, we want to check whether randomly assigning treatment has created treatment and comparison 
groups that look similar in terms of observable characteristics.  Create a variable `pvalue` that 
is missing for all observations.  Then, test whether the mean of the variabl `anymfi_1` is the same 
in your treatment and comparison groups.  Save the resulting p-value from your hypothesis test 
as the `pvalue` variable for the observation with `id==1`.  You could do this, for example, by running 
the commands:
```
ttest anymfi_1, by(treatment)
replace pvalue = `r(p)' if id==1
```
Now test the other seven variables included in the data set.  Can you do this by writing a loop 
using `foreach`?  When you test the hypothesis (hypotheses?) that your treatment and control 
groups are similar in terms of covariates, how many statistically significant differences do you 
see?

### Question 3 

With a large number of baseline covariates, we expect that some of them will differ between the 
treatment and comparison groups - just by chance.  To guarantee that important covariates are 
balanced, we often **stratify** our treatment assignments.  This just means that, instead of sorting 
by `treatment`, we first sort our data into groups and then randomly assign treatment 
within each group.  We would like to stratify treatment assignments by `anymfi_1` and `any_biz_1`.  To do this, 
we want to create a variable `stratum` that takes on values 1 through 4, reflecting the four possible 
combinations of our two stratification variables.  Then, before we assign tratment, we sort 
by our `stratum` variable (first) and our `random` variable (second) using a single `sort` command.  Extend 
your do file to do this and then randomly assign treatment (creating a new treatment variable, `t2`).  

How do your stratified-assignment treatment groups compare in terms of the variables that we stratified 
on?  How do the differences that we observe compare to those that we saw when we did not stratify?

Once you have randomly assigned treatment status, we will typically want to check whether 
our treatment and comparison groups look similar in terms of observable characteristics.  

<br>
 
## Extensions


 
Sometimes we want to assign treatment at the group rather than the individual level - for example, 
when a policy might have spillovers from one individual to another.  So, for instance, educational 
interventions such as textbooks or teacher training are often randomized at the school level, 
and health interventions are often randomized at the clinic or community level.  We refer to 
such larger units as **clusters**, and studies that are randomized at the cluster level are 
called cluster-randomized trials.  

The microfinance program that we studied in 
[Empirical Exericse 6](https://pjakiela.github.io/ECON523/exercises/E6-TOT.html) is an example 
of a cluster-randomized trial:  neighborhoods rather than households were assigned to treatment 
and control.  How might you go about this?
 
 

