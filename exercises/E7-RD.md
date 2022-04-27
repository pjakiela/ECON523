# Empirical Exercise 7

In this exercise, we'll use data from Joshua Angrist and Victor Lavy's paper 
[Using Maimonides' Rule to Estimate the Effect of Class Size on Scholastic Achievement](https://www.jstor.org/stable/2587016), 
which was published in the _Quarterly Journal of Economics_ in 1999.  The paper makes use of the fact that class size in Israeli public 
schools is capped at 40.  So, if there are 40 students in a grade within a school, they are likely to be grouped into a single class; 
but if there are 41 students, the school must divide the grade into two classes taught by different teachers.  This creates a discontinuity in 
class size as a function of grade-level cohort size.  Angrist and Lavy use data on student test scores to estimate the impact of smaller classes on 
student achievement using a regression discontinuity (RD) design.

<br>

## Getting Started

Some of the data used in the paper are available [here](E7-AngristLavy-data.html).  Download the data set and create a do file that 
reads your data into Stata (or create a do file that reads the data directly from the web).  If you are unsure how to do this, 
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
creates the sawtooth pattern in the figure below, because class size is not a monotonic function of cohort size.  Cohorts that are very similar 
in terms of overall size end up with quite differently sized classes, through the plausibly exogenous variation that results from 
Maimonides' Rule.
![Angrist & Lavy Figure I](AL-FigI.png)

### Question 1 

We would like to recreate Figure I from Angrist and Lavy's paper.  As a first step, use the command
```
twoway scatter class_size cohort_size
```
to plot the relationship between class size and cohort size.  The `twoway` command is Stata's general tool for 
plotting the relationships between two variables, `scatter` is one of the options for types of `twoway` plots.  

When you use the command above, does your graph look like Figure I?  (A:  No, it doesn't.)  One problem is that 
we are showing too much data:  instead of plotting the values of `class_size` for every data point, we want to calculate 
the average value of `class_size` for each value of `cohort_size`.  We can use the `mean` function of the `egen` command 
to do this:
```
bys cohort_size:  egen mean_class = mean(class_size)
```
Now redo your scatter plot using `mean_class` instead of `class_size` as your dependent variable.  It 
should look better.  You can further refine your graph by playing around with the `msymbol` and `mcolor` options 
in twoway (take a look at Stata's help file for `twoway` to explore the possibilities).  You can also try making a 
`line` plot rather than a `scatter` plot using twoway.

To fully replicate Figure I from Angrist and Lavy, we need to include both the actual relationship between class size and 
cohort size (which we've done) and the relationship predicted by Maimonides' Rule.  The first step to doing this 
is to calculate the number of classes a school would need to have under Maimonides' Rule:  if the cohort size is 
between 1 and 40, the predicted number of classes is 1; if the cohort size is between 41 and 80, the predicted number of 
classes is 2; if the cohort size is between 81 and 120, the predicted number of classes is 3; and so on.  Generate a variable 
`pred_classes` using this formula.  You might want to use the `ceil()` function to do this.  Then generate a variable 
`pred_size` that is the overall cohort size divided by the predicted number of classes.  Now, you should have something that looks 
a lot like Figure I from the paper.  Make sure that all of your code for generating your figure is recorded in your do file, 
and then use the `graph export` command to save your figure so that you can upload it later.  

<br>

## Implementing RD

### Question 2 

The figure suggests that relationship between predicted class size and actual class size is strongest around the discontinuity 
at 40, so we will focus our analysis there.  Add a line to your code dropping observations with cohort sizes above 80.

### Question 3 

Our running variable is `cohort_size`, but we need to center it around our discontinuity.  Do this by generating a variable 
`running_var` equal to `cohort_size` minus 40.  Then generate separate variables `running_below` and `running_above`:  `running_below` 
is equal to the running variable for cohorts of 40 or fewer students, and equal to zero otherwise; `running_above` is equal to the running variable 
for cohorts of 41 or more students, and equal to zero otherwise.  

### Question 4 

The last variable we need is an indicator for having a cohort size of 41 or above.  Call this variable `over40`.  

### Question 5

Now regress `class_size` on `over40`, `running_below`, and `running_above`.  This is our regression discontinuity specification, 
but what we are estimating is effectively a first-stage regression.  How much lower are class sizes just above the discontinuity, 
as compared to those just below it?  

### Question 6 

Now implement the same RD specification, but using `math_score` as the outcome variable.  What is the estimated impact of being 
above the discontinuity on math test scores?  

### Question 7 

We can also use our `over40` variable as an instrument for class size, controlling for `running_below` and `running_above`.  Estimate 
this IV regression using the `ivregress 2sls` command.  The coefficient on class size tells us the causal impact of increasing class size 
by one, assuming that our RD design is valid.  What is the estimated coefficient on `class_size` from our IV regression?

### Question 8 

The `binscatter` command allows us to plot the data from an RD design.  Use the commands:
```
ssc install binscatter
binscatter class_size cohort_size, rd(40) discrete
```
to look at the data on the first-stage relationship between cohort size and class size.  Then extend your code 
so that you also produce `binscatter` plots of `math_score` and `verbal_score`.  

### Question 9 

As discussed in class, using too large of a window (bandwidth) around the discontinuity can lead to mispecification.  Replicate your 
IV regression from Question 7, but use only the data for cohorts with between 20 and 60 students.  How do your results change 
when you use the smaller cohort?

### Question 10 

As we discussed in class, if our RD design is valid, we would not expect pre-treatment characteristics to "jump" at the 
discontinuity.  Use the `binscatter` command to plot the relationship between `cohort_size` and percent disadvantaged 
(the variable `pct_dis`).  Does it look like the proportion disadvantaged jumps at the discontinuity?  You can also 
conduct a formal statistical test by replicating your reduced form RD specification from Questions 5 and 6 using 
`pct_dis` as the outcome variable.

### Question 11

The assumption underlying RD designs is that there is no manipulation of the running variable near the discontinuity; in other words, 
individuals (or schools) cannot determine whether they are just above or just below the discontinuity.  If this assumption is valid, 
the histogram of the running variable should look smooth near the cutoff.  Use the `histogram` command to test whether this is the case 
in our data.  You may want to use the `discrete` option since the variable `cohort_size` only takes on whole number values.  What patterns 
do you observe in the histogram, and how does this influence your view of the analysis above?




