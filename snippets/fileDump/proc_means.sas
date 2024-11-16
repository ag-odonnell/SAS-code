
/***********************************************************************;*/
/***********************************************************************;*/
/* Proc Means Sample Code
/***********************************************************************;*/
/***********************************************************************;*/

data test_2017;
	length var_cat_01 $1 var_num_01 8. var_num_02 8. var_cat_02 $2;
	input var_cat_01 $ var_num_01 var_num_02 var_cat_02 $;
	cards;
c 1 1 aa
d 0 1 bb
c 1 1 aa
d 1 0 aa
c . 1 aa
d 0 . aa
;
run;

data test_2017;
set test_2017;
	var_num_03 = 100000 + _n_;
	var_char_03 = put(var_num_03,6.);
	substr_var_char_03 = substr(put(var_num_03,6.),5,2);
run;

/***********************************************************************;*/
/* Note: Use the code below to observe difference in sum vs count
/* - If summing on a (0,1) dichotomous flag, 
/* -- then the ones will be summed together to provide the total of the flagged situation. 
/* -- The count function will count all rows of the dataset. 
/* ---- (think of it as a denominator for the sum function...)
/***********************************************************************;*/

data test_01;
	do i = 1 to 10;
		num_var_01 = mod(i,3);
		flag_var_01 = mod(i,2);
		class_var_01 = mod(i,4);
		output;
	end;
run;


proc means
	data = test_01
		noprint
		maxdec = 0;
		class class_var_01;
		output
			out = test_02 (drop=_:)
			sum(flag_var_01) = sum_flag_var_01
			n(flag_var_01) = cnt_flag_var_01;
run;

/***********************************************************************;*/

proc means data = test_2017 n mean std;
	var var_num_01 var_num_02;
run;

proc means data = test_2017 noprint maxdec = 4;
	var var_num_01 var_num_02;
	id var_cat_02;
	output out = test_mean_01 (drop=_:)
	mean() = ;
run;

proc means data = test_2017 noprint maxdec = 4;
	class var_cat_01;
	var var_num_01 var_num_02;
	output out = test_mean_02 (drop=_:)
	mean() = ;
run;

proc means
	data = test_2017
		n sum min p5 p25 mean p75 p95 max std maxdec = 2;
	class var_cat_01;
	*where (substr(put(var_num_03,6.),5,2) in ('01'));
	where substr(var_cat_01,1,1) in ('c');
	var var_num_01 var_num_02;
run;

/***********************************************************************;*/

proc sort data = test_2017;
by var_cat_01;
run;

proc means data = test_2017 noprint maxdec = 4;
	by var_cat_01;
	var var_num_01 var_num_02;
	output out = test_mean_02 (drop=_:)
	mean() =
	std (var_num_02) = std_var_num_02
	sum(var_num_01) = sum_var_num_01
	n(var_num_01 var_num_02) = n_var_num_01 n_var_num_02;
run;

proc means data = test_2017 noprint maxdec = 4;
	by var_cat_01;
	var var_num_01;
	output out = test_mean_03 (drop=_:)
	mean(var_num_01) = mean_var_num_01
	std(var_num_01) = std_var_num_01
	uclm(var_num_01) = uclm_var_num_01
	lclm(var_num_01) = lclm_var_num_01;
run;

/***********************************************************************;*/
/***********************************************************************;*/
/*endProgram
/***********************************************************************;*/
/***********************************************************************;*/



/***********************************************************************;*/
/***********************************************************************;*/
/* Note: the two routines below accomplish the same thing...
/***********************************************************************;*/
/***********************************************************************;*/

%let macroCall_max_bid =;
%let macroCall_max_bid_02 =;

data test_01;
	do i = 1 to 4;
		if i = 1 then do; bid = 3; bid2 = 3; end;
		else if i = 2 then do; bid = 1; bid2 = 1; end;
		else if i = 3 then do; bid = 518; bid2 = 518; end;
		else if i = 4 then do; bid = 4; bid2 = 628; end;
		output;
	end;
run;

/***********************************************************************;*/
/* NOte: Routine #1
/***********************************************************************;*/

data test_02;
set test_01;
	row_count = _n_;
	retain max_bid;
	if _n_ = 1 then max_bid = bid;
	else do;
		if bid > max_bid then do;
			max_bid = bid;
			call symput('macroCall_max_bid', strip(max_bid));
		end;
	end;
	/*if bid > max_bid then mark = 1;*/
run;

%put macroCall_max_bid: &macroCall_max_bid.;	

/***********************************************************************;*/
/* NOte: Routine #2
/***********************************************************************;*/

proc means data = test_02 noprint;
var bid;
output out = test_03 (drop=_:)
max(bid) = max_bid;
run;

data _null_;
set test_03;
	call symput('macroCall_max_bid_02', strip(max_bid));
run;

%put macroCall_max_bid_02: &macroCall_max_bid_02.;

/***********************************************************************;*/
/* Note: test functionality of macro call
/***********************************************************************;*/

data test_04;
set test_02;
	var_01 = input("&macroCall_max_bid.",15.);
	var_02 = 0;
	if bid2 > var_01 then var_02 = 1;
	if bid2 > input("&macroCall_max_bid.",15.) then var_03 = 1;
run;

/***********************************************************************;*/
/***********************************************************************;*/
/*endProgram
/***********************************************************************;*/
/***********************************************************************;*/



/***********************************************************************;*/
/***********************************************************************;*/
/* – CANNOT perform a proc mean count of rows (n)
/* — on large continuous variables (ex. bid with millions of rows)
/* — because run out of memory (example below)
/***********************************************************************;*/
/***********************************************************************;*/

proc means
	data = test
		N
		ndec = 2;
	class bid;
	var bid;
run;

/***********************************************************************;*/
/* INSTEAD run a frequency on one categorical variables:
/***********************************************************************;*/

proc freq data = test;
	tables
		SEX
		/ missing nocol norow;
run;

/***********************************************************************;*/
/***********************************************************************;*/
/**endProgram**
/***********************************************************************;*/
/***********************************************************************;*/
