# Empirical Exercise 5

In this exercise, we'll be using a data set on school enrollment in 15 African countries that eliminated primary 
school fees between 1990 and 2015.  Raw data on primary and secondary school enrollment comes from the World Bank's 
[World Development Indicators Database](https://databank.worldbank.org/source/world-development-indicators).  The 
data set that we'll use is posted at [here](https://pjakiela.github.io/TWFE/WDI-FPE-data.dta).  We'll be using 
this data set to estimate the two-way fixed effects estimator of the impact of eliminating school fees on enrollment.  Since 
this policy was phased in by different countries at different time, it is a useful setting for exploring the potential pitfalls 
of two-way fixed effects.

<br>

## Getting Started

Start by creating your own do file that downloads the data from the course website.  Your 
code will look something like this:

```
// ECON 523
// EMPIRICAL EXERCISE 5
clear all 
set scheme s1mono 
set more off
set seed 12345
webuse set https://pjakiela.github.io/TWFE/
webuse WDI-FPE-data.dta
```

The data set only contains eight variables:  `country`, `year`, `ccode`, `id`, `primary`, `secondary`, 
`fpe_year`, and `treatment`.  The variables `country` and `year` are self-explanatory.  `id` is a unique 
numeric identifier for each of the 15 individual countries in the data set, and `ccode' is the Wold Bank's three-letter 
code for each country.  

The data set also contains the the variables `primary` and `secondary` which 
indicate gross enrollment in primary and secondary school, respectively.  The **gross primary enrollment ratio** 
is 100 times the number of students enrolled in primary school divided by the number of primary-school aged 
children.  This number can be greater than 100 when over-age children are enrolled in primary school - which 
often happens when school fees are eliminated.  The **gross secondary enrollment ratio** is defined analagously.

The variable `fpe_year` 
indicates the year in which a given country made primary schooling free to all eligible children.  Malawi 
was the first country in the data set that eliminated primary school fees (in 1994), while Namibia was the 
last (in 2013).  The countries in the data set and the timing of school fee elination is summarized in the table below.

ID|Country|Implementation of Free Primary Education
--|-------|----------------------------------------
27|Malawi|1994
17|Ethiopia|1995
20|Ghana|1996
46|Uganda|1997
7|Cameroon|2000
44|Tanzania|2001
47|Zambia|2002
35|Rwanda|2003
23|Kenya|2003
5|Burundi|2005
31|Mozambique|2005
24|Lesotho|2006
2|Benin|2006
4|Burkina Faso|2007
32|Namibia|2013

The data set contains 15 countries, but only 13 distinct "timing groups" - since Kenya and Rwanda both 
eliminated primary school fees in 2003, while Benin and Lesotho both eliminated fees in 2006.  



Start by familiarizing yourself with the data set.  What are the first and last years included in the sample?  Which 
countries eliminated school fees in the 1990s?  How many countries eliminated primary school fees after 2010?

We are going to be looking at the outcome variable `gross_enroll`, but this variable is missing for some 
country-years.  How many?  Go ahead and drop those observations to make your life easier.

<br>
