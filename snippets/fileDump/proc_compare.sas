
/***********************************************************************;*/
/* Note: SAS proc compare
/***********************************************************************;*/

%let data_in_path_01 = /sas/…;
%let data_in_path_02 = /sas/…;

libname aa_lib01 "&data_in_path_01.";
libname aa_lib02 "&data_in_path_02.";
/*
options obs = 100;

/***********************************************************************;*/

%let start_year = 2018;
%let end_year = 2018;

/***********************************************************************;*/

%macro iteration_macro_01();
	%do yyyy = &start_year %to &end_year;
		%macro iteration_macro_02(dataset_in_out_01=);
			proc compare
				base = aa_lib01.&dataset_in_out_01.&yyyy.
				compare = aa_lib02.&dataset_in_out_01.&yyyy.
				listall
				maxprint = (10,20000);
			run;
		%mend;
		%iteration_macro_02(dataset_in_out_01 = data_set_name_01_);
		%iteration_macro_02(dataset_in_out_01 = data_set_name_02_);
	%end;
%mend;
%iteration_macro_01;

/***********************************************************************;*/
/***********************************************************************;*/
/*EndProgram
/***********************************************************************;*/
/***********************************************************************;*/

%let dataset1 = data_set_name_01_;
%let dataset2 = data_set_name_02_;
%let yyyy = 2018;

proc compare
	base = aa_lib01.&dataset1.&yyyy.
	compare = aa_lib02.&dataset1.&yyyy.
	listall
	maxprint = (10,20000);
where ~((pId='123' and qtr(dateVar)=1) or (pId='A789' and qtr(dateVar) in (3,4)));
run;

/***********************************************************************;*/
/* Note: Limit numeric comparisons to within .001
/* - as compared to comparing a continuous value 
/* -- versus one rounded to the nearest cents (0.01)
/***********************************************************************;*/

proc compare
	base = aa_lib01.&dataset1.&yyyy.
	compare = aa_lib01.&dataset2.&yyyy.
	METHOD = ABSOLUTE
	CRITERION = 0.001
	listall
	maxprint = (10,20000);
run;

/***********************************************************************;*/

proc compare
	base = aa_lib01.&dataset1.&yyyy.
	compare = aa_lib02.&dataset1.&yyyy.
	maxprint = (10,25000)
	listall;
	id var1 var2; *<=id is used like a by statement;
	var var1;
	with var3;
run;

/***********************************************************************;*/
/***********************************************************************;*/
/*EndProgram
/***********************************************************************;*/
/***********************************************************************;*/

data test1;
	var_01 = 1;
	var_02 = 2;
	var_03 = 3;
	var_04 = 4;
run;

data test2;
	var_01 = 1;
	var_02b = 5;
	var_03 = 3;
	var_04 = 4;
run;

/***********************************************************************;*/
/* NOte: this will only compare the related variables of 2 datasets
/***********************************************************************;*/
	
proc compare
	base = test1
	compare = test2
	listall
	maxprint = (10,20000);
	var
		var_02;
	with
		var_02b;
run;

/***********************************************************************;*/
/* NOte: this will compare the 4 variables of 2 datasets
/***********************************************************************;*/
	
proc compare
	base = test1
	compare = test2
	listall
	maxprint = (10,20000);
	var
		var_01
		var_02
		var_03
		var_04;
	with
		var_01
		var_02b
		var_03
		var_04;
run;

/***********************************************************************;*/
/***********************************************************************;*/
/*EndProgram
/***********************************************************************;*/
/***********************************************************************;*/
