* Encoding: UTF-8.
* =====================================================================.
* Statistics for Social Science - Week 3: Describing distributions.
* Data: TGSS 2024. The syntax we write together in class.
* Rules: * starts a comment. Every command ends with a full stop.
* Run: select the lines and press Ctrl+R.
* =====================================================================.

* Missing codes (-88, -99, -90) are already defined in the TGSS file.
* For your own data: MISSING VALUES var (-99 THRU -88).

* ---------------------------------------------------------------------.
* Block 1 - Last week's practice C1, in code.
* ---------------------------------------------------------------------.
* INTO creates a new variable; age stays as it is.
* TGSS already has agegroup (6 groups), so ours is called age4.

RECODE age (18 THRU 29=1) (30 THRU 44=2)
  (45 THRU 64=3) (65 THRU HIGHEST=4)
  INTO age4.
VARIABLE LABELS age4 'Age, 4 groups'.
VALUE LABELS age4
  1 '18-29' 2 '30-44'
  3 '45-64' 4 '65+'.
VARIABLE LEVEL age4 (ORDINAL).
EXECUTE.

FREQUENCIES VARIABLES=age4.

* ---------------------------------------------------------------------.
* Blocks 3-5 - Central tendency, shape, dispersion (one command, edited step by step).
* ---------------------------------------------------------------------.
* Block 3: /STATISTICS=MEAN MEDIAN MODE.
* Block 4: + SKEWNESS KURTOSIS and /HISTOGRAM=NORMAL.
* Block 5: + /NTILES=4 and STDDEV VARIANCE RANGE MINIMUM MAXIMUM.

FREQUENCIES VARIABLES=age comminute
  /FORMAT=NOTABLE
  /NTILES=4
  /STATISTICS=MEAN MEDIAN MODE STDDEV VARIANCE RANGE
     MINIMUM MAXIMUM SKEWNESS KURTOSIS
  /HISTOGRAM=NORMAL.

* Block 5 - the boxplot: a picture of the median and the IQR.
EXAMINE VARIABLES=comminute
  /PLOT=BOXPLOT
  /STATISTICS=NONE.

* ---------------------------------------------------------------------.
* Block 6 - z-scores: distance from the mean, in SDs.
* ---------------------------------------------------------------------.
* z = (value - mean) / SD. Mean and SD of age from the output above.

COMPUTE z_age = (age - 40.29) / 15.27.
EXECUTE.

* /SAVE adds Zage. Compare z_age and Zage in Data View.
DESCRIPTIVES VARIABLES=age
  /SAVE.

* Optional check: the mean of Zage is 0, the SD is 1.
DESCRIPTIVES VARIABLES=Zage.

* The BMI question (last week's Extra 2) is in the practice worksheet (C3).
