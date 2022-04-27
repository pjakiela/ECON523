# Empirical Exercise 7

In this exercise, we'll use data from Joshua Angrist and Victor Lavy's paper 
[Using Maimonides' Rule to Estimate the Effect of Class Size on Scholastic Achievement](https://www.jstor.org/stable/2587016), 
which was published in the _Quarterly Journal of Economics_ in 1999.  The paper makes use of the fact that class size in Israeli public 
schools ise capped at 40.  Thus, if there are 40 students in a grade within a school, they are likely to be grouped into a single class; 
but if there are 41 students, the school must divide the grade into two classes taught by different teachers.  This creates a discontinuity in 
class size as a function of grade-level cohort size.  

<br>

## Getting Started

Some of the data used in the paper are available [here](E7-AngristLavy-data.html).  Download the data set and create a do file that 
reads in your data (or create a do file that reads the data directly from the web).  If you are unsure how to do this, 
go back and review some of [the earlier empirical exercises](https://pjakiela.github.io/ECON523/exercises/index.html).  

Use the `describe`, `summarize`, and `codebook` commands to familiarize yourself with the data.  How many variables are there?  What 
grade level (or levels) are included in the data set?  Use the `histogram` commands to look at the distribution of scores on the 
standardized math and reading tests (the variables `math_score` and `verbal_score`, respectively).  

Through our regression discontinuity analysis, we are interested in testing the hypothesis that smaller classes (i.e. a 
higher teacher-to-student ratio) lead to improved learning outcomes (as measured through test scores).  Before proceeding 
to that step, we can first examine the correlation between test scores and learning outcomes in the cross-section (i.e. looking at 
our entire data set, without trying to use any identification strategy).  To do this, regress `math_score` on `class_size`.  What 
is the estimated OLS coefficient?  Is it statistically significant?  Now add controls for overall cohort size (`cohort_size`), which 
proxies for the size of the school and the community it is in, the percentage of the cohort that is male (`pct_boys`), and the percentage 
of the cohort that comes from disadvantaged households (`pct_dis`).  How does the addition of these controls change the 
estimated association between class size and student test scores?

<br>

## Using Maimonides' Rule to Predict Class Size

This figure, Figure I in Angrist and Lavy's paper, summarizes their identification strategy:  cohorts that have exactly 40 students 
can be taught in a single classroom, but those that have 41 students must be split into two (smaller) classes; likewise, cohorts that have 
exactly 80 students can be divided into two classes, while cohorts with 81 students must be divided into three (smaller) classes.  This requirement 
creates the sawtooth pattern in the figure below, because class size is not a monotonic function of cohort size.
![Angrist & Lavy Figure I](AL-FigI.png)
