# Regression Discontinuity Designs in Python

<br> 

Using the data set [ECON523-E8-meyersson-data.dta](ECON523-E8-meyersson-data.dta), replicate Table 1, Table 2 (Panel A, Columns 1 through 8), and Figure 2a 
from [Islamic Rule and the Empowerment of the Poor and Pious](https://onlinelibrary.wiley.com/doi/abs/10.3982/ECTA9878) 
by Erik Meyersson. Upload pdfs of your finished tables and figure to gradescope, together with the code that generates them.

**Extra credit:** replicate Figure 2b and upload it to gradescope.

<br>

## Hints and Suggestions

**1.** When replicating Table 1, it will save time to write a program that produces a single row when you supply it 
with a variable name.  

**2.** Use `matplotlib` to make the histogram.  Play around with the bin width to replicate Dr. Meyersson's table to the extent possible.

**3.** You do not need to format the titles of Table 2 exactly the way Dr. Meyersson has.  Since all of your columns have the same outcome variable 
and the same age range, you can omit those labels.  You do not need to use h-hat to indicate the Imbens-Kalyanaraman optimal bandwidth; 
you can just refer to it as "IK Bandwidth" or something similar.

**4.** The paper reports the Imbens-Kalyanaraman optimal bandwidth in approximate terms. You can play around with the bandwidth in each column so that your sample sizes match the ones 
reported in the paper.
	
**5.** When you use the quadratic control function in an RD, you need to include both the running variable (above and below 
the discontinuity) and the square of those two terms.  When you used the cubic control function, you need to include those terms 
plus cubic functions of the running variable.
	
**6.** The TA and I are not going to help you with the extra credit, and it is a tough one.  You can read about kernel density plots [here](https://clauswilke.com/dataviz/histograms-density-plots.html) and 
[here](https://datavizcatalogue.com/methods/density_plot.html). When you estimate 
the kernel densities separately above and below the discontinuity, they will have different scales, because the area under a kernel density 
is one.  You will need to figure out how to rescale them so that they line up (try plotting them on top of the density estimates 
for the pooled sample to help you think through this).  You will also need to calculate the number of observations 
in each of 100 bins to overlay the scatter plot.  These counts will also need to be rescaled so that they reflect the same units 
as the density plots.  Again, this is all quite challenging.  Good luck to those who attempt it! 

<br>

 ---

This exercise is part of the module [Regression Discontinuity Designs](https://pjakiela.github.io/ECON523/M8-RD.html).
