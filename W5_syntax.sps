* ================================================================.
* Statistics for Social Science - Week 5.
* Comparing groups (t-test, Mann-Whitney U, ANOVA, Kruskal-Wallis).
* and building an index.
* Data: TGSS 2024.
* Rule of this course: syntax for data management.
* Analyses are run from the menus (paths given as comments).
* ================================================================.


* ----------------------------------------------------------------.
* PART 1 - TWO GROUPS.
* ----------------------------------------------------------------.

* 1.1 Mean height and 95% CI by gender (error bar graph).
* Menu: Graphs > Legacy Dialogs > Error Bar > Simple,.
*       Summaries for groups of cases.
*       Variable: height - Category Axis: gender.
*       Bars represent: Confidence interval for mean, 95%.
* Tip: double-click the chart > y-axis > Scale: Min 158, Max 176.

* 1.2 Independent-samples t-test: height x gender.
* Menu: Analyze > Compare Means > Independent-Samples T Test.
*       Test Variable: height - Grouping Variable: gender.
*       Define Groups: 1 and 2.
* Read Levene first, then choose the row.

* 1.3 Mann-Whitney U: comminute x gender.
* Menu: Analyze > Nonparametric Tests > Legacy Dialogs > 2 Independent Samples.
*       Test Variable: comminute - Grouping Variable: gender (1, 2).
*       Tick Mann-Whitney U.

* Medians for the report sentence.
* Menu: Analyze > Descriptive Statistics > Explore.
*       Dependent List: comminute - Factor List: gender.

* 1.4 Transformation: log of commuting minutes.
* LN needs values above 0. If comminute has zeros, use LN(comminute + 1).
COMPUTE ln_comminute = LN(comminute).
VARIABLE LABELS ln_comminute 'Commuting time (log minutes)'.
EXECUTE.

* Did it help? Compare the shape before and after.
FREQUENCIES VARIABLES=comminute ln_comminute
  /FORMAT=NOTABLE
  /STATISTICS=SKEWNESS KURTOSIS
  /HISTOGRAM.

* Other transformations (examples only, not run today).
* Moderately skewed to the right: square root.
* COMPUTE sqrt_comminute = SQRT(comminute).
* Skewed to the left: square.
* COMPUTE x_sq = x**2.

* Then: t-test on ln_comminute x gender (same menu as 1.2).


* ----------------------------------------------------------------.
* PART 2 - THREE OR MORE GROUPS.
* ----------------------------------------------------------------.

* 2.1 One-way ANOVA: ln_comminute x area14.
* Menu: Analyze > Compare Means > One-Way ANOVA.
*       Dependent List: ln_comminute - Factor: area14.
*       Options: Descriptive, Homogeneity of variance test.
*       Post Hoc: Tukey.

* 2.2 Kruskal-Wallis H: comminute x area14.
* Menu: Analyze > Nonparametric Tests > Legacy Dialogs > K Independent Samples.
*       Test Variable: comminute - Grouping Variable: area14.
*       Define Range: 1 to 4 - tick Kruskal-Wallis H.


* ----------------------------------------------------------------.
* PART 3 - BUILDING AN INDEX: satisfaction with social life.
* ----------------------------------------------------------------.

* Step 0 - Read the codebook first.
* satinc runs the other way: 1 = very satisfied, 5 = not at all satisfied.

* Step 2 - Reverse the item that runs backwards.
RECODE satinc (1=5) (2=4) (3=3) (4=2) (5=1) (ELSE=COPY)
  INTO satinc_r.
MISSING VALUES satinc_r (-88, -99, -90).
VARIABLE LABELS satinc_r 'Satisfaction with income (reversed)'.
VALUE LABELS satinc_r
  1 'Not at all satisfied' 2 'Not satisfied' 3 'Neither'
  4 'Satisfied' 5 'Very satisfied'
  -88 "Don't know" -99 'Refused' -90 'Not applicable'.
EXECUTE.

* Check: the people with 1 in satinc should have 5 in satinc_r.
FREQUENCIES VARIABLES=satinc satinc_r.

* Step 3 - COUNT, IF and MEAN.
COUNT n_missing = satsoc satfri satrela satfam satinc_r (MISSING).
VARIABLE LABELS n_missing 'Number of missing items (0-5)'.
EXECUTE.

* How many items did people skip?
FREQUENCIES VARIABLES=n_missing.

* Index only for people with at most 1 missing item.
IF (n_missing <= 1) sat_index = MEAN(satsoc, satfri, satrela, satfam, satinc_r).
VARIABLE LABELS sat_index 'Satisfaction index (mean of 5 items, 1-5)'.
EXECUTE.

* Step 4 - Look at what you built.
FREQUENCIES VARIABLES=satsoc sat_index
  /FORMAT=NOTABLE
  /STATISTICS=MEAN MEDIAN STDDEV SKEWNESS KURTOSIS
  /HISTOGRAM=NORMAL.

* Cronbach's alpha.
* Menu: Analyze > Scale > Reliability Analysis.
*       Items: satsoc satfri satrela satfam satinc_r (the REVERSED income item).
*       Model: Alpha - Statistics: tick Scale if item deleted.


* ----------------------------------------------------------------.
* PRACTICE - the index in a t-test.
* ----------------------------------------------------------------.
* Menu: Analyze > Compare Means > Independent-Samples T Test.
*       Test Variable: sat_index - Grouping Variable: gender (1, 2).
