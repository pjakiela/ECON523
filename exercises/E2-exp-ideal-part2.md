# Empirical Exercise 2, Part 1

In this exercise, we'll use Stata's `rnormal()` command to generate draws from a normally-distributed random variable.  This approach - simulating data 
according to a known data-generating process - is an incredibly useful tool in empirical microeconomics (both for checking your econometric intuitions and 
your anlayis code).  

We'll use "locals" (also know as "local macros") to easily change the number of observations and other parameters of our data set.  This will allow us to 
explore the properties of randomly-assigned treatment groups in larger and smaller samples.   

Please upload your answers to gradescope after completing the exercise.  You can also download the entire activity 
as a [do file](https://pjakiela.github.io/ECON523/exercises/E2B-questions.do).  

<br>

## Getting Started 

Start a do file with the standard code at the top:

```
// PRELIMINARIES

** start with a clean workspace
clear all
set more off // setting more off prevents your code from stopping halfway through
set seed 12345 // setting the seed makes pseudo-random draws replicable
version 16.1 // make sure you use a specific version of Stata (for replicability)
```

The `set seed` and `version` commands are particularly important here, because we are going to be generating data using Stata's pseudo-random number generator.  Setting the 
seed and specifying the version of Stata that the computer should use will guarantee that your results are the same whenever (and wherever) you run your code.  
