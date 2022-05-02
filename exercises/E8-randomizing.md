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

The idea behind random assignment is that we can sort our data set generate a variable 
using Stata's pseudo-random number generator and then sort the data set based on that 
variable; when we do this, the observations in the data set are listed in a 
random order.  If we want to randomly assign observations to treatment and comparison groups, 
we can assign every other observation to treatment - once we've scrambled the observations 
in the data set by sorting them using a randomly-generated variable.

<br>

## Generating Data 

Stata's `runiform()` and `rnormal()` commands can also be used to generate 
simulated data sets.  

