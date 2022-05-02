# Empirical Exercise 8

In this exercise, we'll be learning how to randomly assign treatment status in a way 
that is transparent and reproducible.  After assigning treatments, we'll check 
whether we've succeeded in creating a treatment group and a control group 
that are comparable in terms of their observable characteristics.  

<br>

## Getting Started

Start by creating a new do file that runs the following Stata code:
```
clear
set obs 4
gen id = _n 
gen rand_num = runiform()
sort rand_num
egen treatment = seq(), from(0) to(1)
sort id
```
What happens when you run the code?  Use Stata's data editor (the button that looks like 
a spreadsheet with a magnifying glass over it) to view the (very small) data set you 
created.  Which ID numbers are assigned to treatment?  Run the code several times:  are 
the same ID numbers assigned to treatment each time?  

The code above contains the three key parts of every randomization do file:  

1. A command that generates a pseudo-random number 
2. A command that sorts the data based on that random number
3. A command that assigns treatment based on that random sort order

However, we failed to set the seed, so each time we run our code, we get a 
completely new random treatment assignment.  Insert the command 
```
set seed 1234 
```
between `clear` and `set obs 4`.  This will guarantee that Stata uses the 
same sequence of pseudo-random numbers every time you run the file.  Run the file 
a few times to confirm that this is the case. 

<br>

## Random Assignment in Stata

The code above uses the command `runiform()` to generate a variable that assigns 
each observation a different draw from a standard uniform random variable, which 
takes values between 0 and 1.  What happens when you create a large data set of such 
draws from a standard uniform?  What happens as you increase the number 
of observations?  Use the code below to find out:
```
clear
set obs 100
gen x = runiform()
sum x
hist x, bin(50) fraction
```
Now re-run the code using the `rnormal()` command instead of the `runiform()` command.  

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
will generate a repeating sequence from 0 to 1.  So, the first row (observation) in 
the data set will get a 0, the second row will get a 1, the third row will get a 0, 
and so on.  Familiarize yourself with this command.  How might you assign observations 
in your data set to four different treatment groups?

Once you have randomly assigned treatment status, we will typically want to check whether 
our treatment and comparison groups look similar in terms of observable characteristics.  How 
might you extend the do file above to do this?

<br>

## Empirical Exercise

Now that we know how to assign treatment, let's see how it works in practice.  We're 
going to use the same data set on potential microfinance clients in urban India 
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
cd "C:\Users\pj\Dropbox\econ523-2022\exercises\E8-randomizing"
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
the variables in the data set.  How many are dummy variables?   
 
 <br>
 
## Even More Fun with Stata
 
We often wish to assign treatment at the group rather than the individual level - for example, 
when a policy might have spillovers from one individual to another.  So, for instance, educational 
interventions such as textbooks or teacher training are often randomized at the school level, 
and health interventions are often randomized at the clinic or community level.  We refer to 
such larger units as **clusters**, and studies that are randomized at the cluster level are 
called cluster-randomized trials.  

The microfinance program that we studied in 
[Empirical Exericse 6](https://pjakiela.github.io/ECON523/exercises/E6-TOT.html) is an example 
of a cluster-randomized trial:  neighborhoods rather than households were assigned to treatment 
and control.  
 
 

