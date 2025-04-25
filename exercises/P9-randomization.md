# Empirical Exercise 9 in Python

In this exercise, we'll be learning how to randomly assign treatment status in a way 
that is transparent and reproducible.  After assigning treatments, we'll check 
whether we've succeeded in creating a treatment group and a control group 
that are comparable in terms of their observable characteristics.  

<br>

## In-Class Activity

Start by creating program that runs the following code:
```
import numpy as np
import pandas as pd

datasize = 4
data = pd.DataFrame({'id': np.arange(1, datasize + 1),
                     'rand_num': np.random.randn(datasize)})
data = data.sort_values(by = 'rand_num') 
num_treatments = 2
data['treatment'] = np.tile(np.arange(0, num_treatments), 
                            datasize)[0:datasize]
data = data.sort_values(by = 'id')

print(data)
```
What happens when you run the code? Which ID numbers are assigned to treatment?  Run the code several times.  Are 
the same ID numbers assigned to treatment each time?  

The code above contains the three key parts of every randomization do file:  

1. A command that generates a pseudo-random number 
2. A command that sorts the data based on that random number
3. A command that assigns treatment based on that random sort order

The idea behind random assignment is that we can generate a variable 
using Python's pseudo-random number generator and then sort the data set based on that 
variable; when we do this, the observations in the data set are listed in a 
random order.  If we want to randomly assign observations to treatment and comparison groups, 
we can assign every other observation to treatment - after we've sorted them based on 
our random `x` variable.

The command 
```
num_treatments = 2
data['treatment'] = np.tile(np.arange(0, num_treatments), 
                            datasize)[0:datasize]
``` 
generates a repeating sequence from 0 to 1:  the first row (observation) in 
the data set will get a 0, the second row will get a 1, the third row will get a 0, 
and so on.  How might you assign observations 
in your data set to four different treatment groups?

In the example above, we failed to set the seed, so each time we run our code, we get a 
completely new random treatment assignment.  Insert the line 
```
np.random.seed(8675309)
```
before you generate the random numbers.  This will guarantee that Python uses the 
same sequence of pseudo-random numbers every time you run the code. Run the code 
a few times to confirm that this is the case. 

<br>

## Empirical Exercise

We're going to use the same data set on potential microfinance clients in urban India 
that we worked with in [Empirical Exercise 6](https://pjakiela.github.io/ECON523/exercises/E6-TOT.html).   The data set 
comes from the paper [The Miracle of Microfinance?  Evidence from a Randomized Evaluation](https://www.jstor.org/stable/43189512?seq=1) by 
Abhijit Banerjee, Esther Duflo, Rachel Glennerster, and Cynthia Kinnan.  The authors worked with an 
Indian MFI (microfinance institution) called Spandana that was expanding into the city of Hyderabad.  Spandana 
identified 104 neighborhoods where it would be willing to open branches.  They couldn't open branches 
in all the neighborhoods simultaneously, so they worked with the researchers to assign half of them 
to a treatment group where branches would be opened immediately.  Spandana held off on opening branches in 
the control neighborhoods until after the study.  

The data set contains information on 6,853 households.  Suppose you want to work with a local NGO to 
offer business training and mentoring to microentrepeneurs, and you want to stratify treatment assignments 
by treatment status in the Spandana RCT to see whether impacts depend on the availability of microcredit.  

Write a program that reads the Spandana data from Empirical Exercise 6 into Python.  Then extend your code  
so that it randomizes treatment assignments, as described below.

### Question 1

You want to stratify treatment assignments in your evaluation by four variables:  

1. Treatment status in the original Banerjee et al. (2015) Spandana RCT
2. A new variable that you create indicating whether a household has taken a formal loan from either an MFI or a bank (by the time of Endline 1 in the original Spandana study) 
3. An indicator for operating a household business (by Endline 1)
4. An indicator for ever having been late with a loan repayment (by Endline 1) 

Construct stratification cells based on these four variables.  

Hint 1: drop observations that are missing values for any of the stratification variables.   

Hint 2: the code 
```
df['stratid'] = df.groupby(['x1', 
                            'x2']).ngroup()
```
generates ID numbers for the groups defined by all the observed combinations of the values of variables `x1` and `x2`.  

### Question 2

Now randomly assign the households in the sample to treatment and control, stratifying by the 
four variables described above.  

### Question 3 

Once you have randomly assigned treatment status, we will typically want to check whether 
our treatment and comparison groups look similar in terms of observable characteristics.  Make 
a **balance check table** that reports, for each of a set of covariates,

- The mean and standard deviation of the covariate in the entire sample
- The mean and standard deviation of the covariate in the treatment group
- The mean and standard deviation of the covariate in the control group
- The p-value from a t-test of the hypothesis that the mean does not differ between the treatment and comparison groups

To do this, you can adapt the code that you wrote for 
[Empirical Exercise 8](https://pjakiela.github.io/ECON523/exercises/P8-RD.html).  Report tests for balance for each of 
your stratification variables plus the variables capturing whether a household operates a business (as of Endline 1), 
the number of household businesses, business assets, business revenues, business expenses, business profits.  Save a copy of your finished 
balance check table as a pdf so that you can upload it to gradescope.

### Question 4

If you tested 1,000 baseline covariates for balance, how many of those variables would you expect to be imbalanced enough 
that you could reject the hypothesis that the mean in the treatment group was equal to be mean in the control group 
at the 95 percent confidence level?

<br>
 
## Extensions

1. How would you modify your code to stratify on baseline business revenues?
2. How would you modify your code to assign households to either a control group or one of three different treatment arms?
3. How would you modify your code to assign treatment at the neighborhood level, and then check for balance on household-level covariates?
 
 ---
 
This exercise is part of the module [Randomization in Practice](https://pjakiela.github.io/ECON523/M9-randomization.html). 

