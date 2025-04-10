# Empirical Exercise 6 in Python  

This empirical exercise is also available as a [google colab](https://colab.research.google.com/drive/1C05_ZpMNcROjKdEgb0weLrsLuNhD6uhV?usp=sharing).

In this exercise, we'll be using data from the paper [The Miracle of Microfinance?  Evidence from a Randomized Evaluation](https://www.jstor.org/stable/43189512?seq=1) by 
Abhijit Banerjee, Esther Duflo, Rachel Glennerster, and Cynthia Kinnan.  The paper reports the results of one of the first randomized evaluations of a microcredit 
intervention.  The authors worked with an Indian MFI (microfinance institution) called Spandana that was expanding into the city of Hyderabad.  Spandana 
identified 104 neighborhoods where it would be willing to open branches.  They couldn't open branches in all the neighborhoods simultaneously, so they worked with 
the researchers to assign half of them to a treatment group where branches would be opened immediately.  Spandana held off on opening branches in 
the control neighborhoods until after the study.  

Before getting started, take a look at this [J-PAL policy brief on the impacts of microfinance](https://www.povertyactionlab.org/policy-insight/microcredit-impacts-and-limitations).  We'll 
be using a small slice of the data from the paper by Banerjee, Duflo, Glennerster, and Kinnan to explore the use of **instrumental variables** techniques to estimate impacts of 
**treatment on the treated** - and to think about when such methods are appropriate.

Our first step is to review the mechanics of treatment-on-the-treated estimation.  There are four ways to arrive at 
an estimate of the impact of treatment (access to loans from Spandana) on individuals who take it up (by taking out a Spandana microloan):
1. We can calculate the impact of treatment on an outcome of interest (say, microenterprise profits), and then take the ratio of this coefficient to the estimated impact of treatment on take-up of Spandana microloans
2. We can estimate the impact of treatment on take-up of microloans and then regress our outcome of interest on **predicted** take-up of microloans
3. We can use the `linearmodels` library to implement two-stage least squares (as in 2, except using a single step)
4. We can estimate the impact of Spandana loans on our outcome of interest controlling for the residuals in our first-stage regression (the **control function** approach)

<br>

## Getting Started

The data that we will use in this exercise is available [here](https://pjakiela.github.io/ECON523/exercises/E6-BanerjeeEtAl-data.dta).  The data set 
contains information on 6,863 households in 104 neighborhoods in Hyderabad; these households were randomly sampled form 
the local population, so not all of them will have chosen to take out loans from an MFI. Half of the neighborhoods (52 of 104) were randomly assigned 
to treatment (and the rest to control).  The variable `treatment` indicates treatment status, and the variable `areaid` is a neighborhood identifier.  

We will be using the following outcome variables:

- `spandana_1` is an indicator for taking out a loan from Spandana 
- `bizprofit_1` is a measure of microenterprise profits
- `bizrev_1` is a measure of microenterprise revenues
- `bizassets_1` is a measure of assets owned by one's microenterprise
- `any_biz_1` is an indicator for operating a microenterprise

To get started, create a program that reads the data into Python directly from the web:
```
## ECON 523: In-Class Activity 6
## A. Student

## libraries
import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import statsmodels.formula.api as smf
from linearmodels.iv import IV2SLS
from openpyxl import load_workbook
from openpyxl.styles import Alignment, Font, Border, Side

## file path
username = os.getenv("USERNAME")
pjpath = f"C:/Users/{username}/Dropbox/ECON-523/topics/6-TOT/py/"

# load data -----------------------------------------------------

urlfile = 'https://pjakiela.github.io/ECON523/exercises/E6-BanerjeeEtAl-data.dta'
e6data = pd.read_stata(urlfile, 
                       convert_categoricals = False)
```

We are going to make use of the variables `treatment`, `spandana_1`, and `bizprofit_1`.  Before you begin, 
add a line to your code that drops any observations with one of these variables missing.  

Hint:  the code
```
df = df[~df[['x1', 'x2']].isna().any(axis=1)]
```
drops any rows with either `x1` or `x2` missing from the data frame `df`.

<br>

## In-Class Activity

### Question 1

Estimate the impact of `treatment` on the likelihood of taking a loan from Spandana (the variable `spandana_1`).  What is the estimated coefficient on `treatment`?  Because treatment is randomly assigned at the neighborhood level, we need to cluster our standard errors by neighborhood (`areaid` indexes neighborhoods).  Do this.  This is the **first stage** regression.  

Save the coefficient on `treatment` as `beta_fs`.  

Hint: remember that the syntax for clustered standard errors in `statsmodels.api` is:  
```
ols = smf.ols('y ~ x', data = df).fit(    
    cov_type='cluster', 
    cov_kwds={'groups': df['clustvar']})
```

### Question 2

Now extend your code so that you also run the **reduced form** regression of microenterprise profits (the variable `bizprofit_1`) on `treatment`.  What is the estimated impact of being randomly assigned to a treatment (at the neighborhood level) on business profits?  

Save the coefficient on `treatment` as `beta_rf`.  

### Question 3 

Based on your answers to Questions 1 and 2, what is the **treatment-on-the-treated** impact of random assignment to Spandana access on business profits?  Use `beta_fs` and `beta_rf` to calculate this quantity (in your code).

### Question 4 

Now we want to output our results to excel. To do this, we will create a data frame called `results` that contains the results that we wish to export, formatted appropriately.

#### Part (a)

The code below defines a function `reshape_regs()` that formats the results from a regression in a column, with the `term` column indicating the variable whose coefficient is being reported and the `type` column indicating whether the row contains a coefficient estimate or a standard error in parentheses.  Review the code below carefully to make sure that you understand each line. Then extend the code to include the p-value in the row below the standard error. Put the p-value in square brackets rather than parentheses.  
```
def reshape_regs(olsresults):
    results = pd.DataFrame({'coef': olsresults.params,
                            'error': olsresults.bse})
    results = results.tail(1)
    results['coef'] = results['coef'].map(lambda x: f"{x:.3f}")
    results['error'] = results['error'].map(lambda x: f"{x:.3f}")
    results = results.astype(str)
    results['error'] = results['error'].map(lambda x: f"({x})")
    results = results[['coef', 'error']]
    results.insert(0, 'var_num', range(len(results)))
    results = results.reset_index()
    results = (
        results.melt(id_vars=['index', 'var_num'], var_name='type', value_name='est')
    )
    results = results.sort_values(by = ['var_num', 'type'])
    results = results[['index', 'type', 'est']]
    return results
```

#### Part (b)

Use the `reshape_regs()` function to store the results from the first stage and reduced form regressions. You can also adapt the code below to store the number of observations and the R-squared.
```
N = ols.nobs
R2 = round(ols.rsquared, 3).astype(str)
```

#### Part (c) 

Now you need to merge the results from your first stage and reduced form regressions into a single data frame that you can export to excel. The code below does this. Make sure that you understand what every line is doing, and then use the code to generate the data frame `results`.  
```
results = fs_results.merge(rf_results, on=["index", "type"], how="left")

obs_row = pd.DataFrame([{'index': 'Observations', 
                         'C1': N_fs, 
                         'C2': N_rf}])
obs_row['C1'] = obs_row['C1'].apply(lambda x: f"{int(x):,}")
obs_row['C2'] = obs_row['C2'].apply(lambda x: f"{int(x):,}")
obs_row = obs_row.astype(str)

results.loc[results['type'] == "error", 'index'] = ''
results.loc[results['type'] == "pval", 'index'] = ''
results = results[['index', 'C1', 'C2']]
results = results.assign(index=lambda df: df['index'].map({
    'treatment': 'Treatment', 
    '': ''}))
results = pd.concat([results, obs_row], ignore_index = True)
results = results.rename(columns={'index': '', 
                                  'C1': 'Borrowed', 
                                  'C2': 'Profits'})
print(results)
```

#### Part (d) 

The last step is to export your results to excel. Here, we adapt the code from Empirical Exercise 5 to export our results to an excel file called `P6-in-class.xlsx`. Before doing this, make sure you have loaded the `openpyxl` library and defined your filepath correctly (so that you will be able to locate your results).  
```
file_name = f"{pjpath}/P6-in-class.xlsx"
sheet_name = "in-class"

with pd.ExcelWriter(file_name, engine='openpyxl') as writer:
    results.to_excel(writer, sheet_name=sheet_name, index=False)

wb = load_workbook(file_name)
ws = wb[sheet_name]

# apply header style (bold, centered, with top/bottom borders)
header_font = Font(bold=True)
header_alignment = Alignment(horizontal="center")
header_border = Border(top=Side(style="thin"), bottom=Side(style="thin"))

for col_idx, cell in enumerate(ws[1], start=1):  # First row (header)
    cell.font = header_font
    cell.alignment = header_alignment
    cell.border = header_border

# adjust column widths
my_widths = [20, 16, 16]  # Match R's column widths
for col_idx, width in enumerate(my_widths, start=1):
    col_letter = ws.cell(row=1, column=col_idx).column_letter
    ws.column_dimensions[col_letter].width = width
    
# adjust row heights
my_heights = [16] * 1 + [20] * 4  
for row_idx, height in enumerate(my_heights, start=1):
    row_number= ws.cell(row=row_idx, column=1).row
    ws.row_dimensions[row_number].height = height

# center align content in columns 2 to 4 (rows 1 to 7)
center_alignment = Alignment(horizontal="center", vertical="center")
for row in ws.iter_rows(min_row=1, max_row=5, min_col=2, max_col=3):
    for cell in row:
        cell.alignment = center_alignment

# add bottom border to last
bottom_border = Border(bottom=Side(style="thin"))
for cell in ws[5]:
    cell.border = bottom_border

# Save the formatted workbook
wb.save(file_name)
```

<br>

## Empirical Exercise

Start a new program for the main part of the empirical exercise.  We are going to make use of the variables `treatment`, `spandana_1`, `bizprofit_1`, `bizrev_1`, `bizassets_1`, and `any_biz_1`.  Before you begin, add a line to your code that drops any observations with one of these variables missing.

### Question 1:  Implementing 2SLS

Use two-stage least squares (2SLS) to estimate an instrumental variables (IV) regression of `bizprofit_1` on `spandana_1`, instrumenting for `spandana_1` with the treatment dummy.  Cluster your standard errors at the neighborhood level.  Your estimated coefficient should be identical to your answer from the In-Class Activity.  

Hint: the following code illustrates how to implement two-stage least squares using `IV2SLS` from the `linearmodels` library (given outcome y, endogenous regressor x, and instrument z):  
```
formula = 'y ~ 1 + [x ~ z]'
ivmodel = IV2SLS.from_formula(formula, data=df)
iv = ivmodel.fit(cov_type='clustered', clusters=df['clustvar'])
print(iv)
```

### Question 2:  2SLS Results

Now make a table that reports TOT estimates of the impact of Spandana loans on microenterprise profits (the variable `bizprofit_1`), microenterprise revenues (the variable `bizrev_1`), microenterprise assets (the variable `bizassets_1`), and the likelihood of operating a microenterprise (the variable `any_biz_1`). Modify the code from the In-Class Activity to store your results in a data frame and export them to excel as a nicely formatted table.  

Hint: `linearmodels` stores the standard errors of the regression coefficients in `.std_errors` rather than `.bse`.

### Question 3:  The Control Function Approach

Now make another table that replicates the treatment-on-the treated estimation from Question 2 using the control function approach.  

Hint: the following code reviews the process of generating a new variable reflecting the residuals from a regression:  
```
model1 = smf.ols('y ~ x', data = df).fit()
df['myresid'] = model1.resid
```

### Question 4

Print each of your tables to pdf so that you can upload your finished product(s) to gradescope.
 
### Question 5 

Using instrumental variables to estimate treatment effects on the treated makes sense when random assignment to treatment (i.e. inviting someone to participate in a program) has no impact on those who choose not to take up treatment.  Does this approach make sense in the context of microfinance?  Why or why not?

<br>

## Optional Extension

The relatively low take-up rates for microfinance loans can be interpreted as evidence that not everyone wants to be an entrepreneur, and several studies have found that access to credit is more effective at helping people expand their businesses than at encouraging non-entrepreneurs to start new businesses.  The variable `any_old_biz` is an indicator for operating a microenterprise prior to the start of the study.  Restrict your sample to those who were already operating microenterprises before Spandana's expansion, and estimate the impact of Spandana loans on microenterprise profits, revenues, and assets in this restricted sample.  Store your results in an excel table (but don't over-write your earlier work).  What do these results suggest about the impacts of microfinance?

 ---
 
This exercise is part of the module [Impacts of Treatment on the Treated](https://pjakiela.github.io/ECON523/M6-TOT.html).
