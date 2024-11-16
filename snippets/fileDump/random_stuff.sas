
/************************************************************************************;*/
/*Create a random number within a range:*/
/************************************************************************************;*/

data _null_;
	firstobs_random_number = 1 + floor((1+10000000-1)*rand("uniform"));
	call symput('macroCall_firstobs_random_number', strip(firstobs_random_number));
run;
%let macroCall_obs_20_random_number = %eval(&macroCall_firstobs_random_number + 20);
%let obs1 = firstobs = &macroCall_firstobs_random_number. obs = &macroCall_obs_20_random_number.;
%put **** obs1 = &obs1. ****;

/************************************************************************************;*/
/*Create a function to generate random numbers:*/
/************************************************************************************;*/

%macro RandBetween(min_range, max_range);
   (&min_range + floor((1+&max_range-&min_range)*rand("uniform")))
%mend;

data test;
	do i = 1 to 100;
	   random_num = %RandBetween(1, 10);
	   output;
	end;
run;

/************************************************************************************;*/
/*Now look at a histogram and judge the normality of the variable random_num*/
/************************************************************************************;*/

TITLE 'Random Number Function Output';
PROC UNIVARIATE DATA = test NOPRINT;
	HISTOGRAM
		random_num 
		/
		NORMAL (
			COLOR=green 
			FILL
			W=5)
		CFILL = ltgray
		CTEXT = red
		NOBARS
		VAXISLABEL = "Percentage of value"
		CGRID = black
		OUTHISTOGRAM = _outhist;
	INSET
		N = 'Number of rows'
		MEDIAN (8.0)
		MEAN (8.0)
		STD= 'Standard Deviation' (8.1)
		/ POSITION = ne;
RUN;

/************************************************************************************;*/
/* Note: create link to a random point in the input data and extend 20 rows
/************************************************************************************;*/

%let macroCall_firstobs_random_number =;
%let macroCall_obs_20_random_number =;
%let obs1 =;

data _null_;
	firstobs_random_number = 1 + floor((1+10000000-1)*rand("uniform"));
	call symput('macroCall_firstobs_random_number', strip(firstobs_random_number));
run;
%put **** macroCall_firstobs_random_number = &macroCall_firstobs_random_number. ****;
%let macroCall_obs_20_random_number = %eval(&macroCall_firstobs_random_number + 20);
%let obs1 = firstobs = &macroCall_firstobs_random_number. obs = &macroCall_obs_20_random_number.;
%put **** obs1 = &obs1. ****;

/************************************************************************************;*/