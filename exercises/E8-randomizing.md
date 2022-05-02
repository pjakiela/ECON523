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
gen randnum = runiform()
sort randnum
egen treatment = seq(), from(0) to(1)
```
