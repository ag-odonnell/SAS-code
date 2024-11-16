
/*Basic Macro Shell*/

%macro macro_01;
	proc contents 
		data = dataset_name_01;
	run;
%mend macro_01;
%macro_01;

/*Add a macro variable to Macro Shell*/

%macro macro_02(ds = );
	proc contents 
		data = &ds.;
	run;
%mend macro_02;
%macro_02 (ds = dataset_name_01);
%macro_02 (ds = dataset_name_02);

/*Add a couple of macro variables to Macro Shell */

%macro macro_03(ds=,var_01=);
	data &ds._out;
	set &ds. (
		keep =
			var_id
			&var_01.);
	run;
%mend macro_03;
%macro_03 (ds = dataset_name_01, var_01 = variable_name_01);
%macro_03 (ds = dataset_name_02, var_01 = variable_name_02);

/*another way to iterate through years*/

%let START_YR = 2019;
%let START_MO = 1;
%let END_YR = 2020;
%let END_MO = 2;

%macro macro_07;
	%LET CMONTH =;
	%LET CYEAR = &START_YR;

	%DO %UNTIL(&CYEAR > &END_YR);
		data test_&CYEAR.;
		run;
		%LET CYEAR = %EVAL(&CYEAR + 1);
	%END;
%mend macro_07;
%macro_07;

/************************************************************************************;*/
/*endProgram
/************************************************************************************;*/

%let START_YR = 2017;
%let START_MO = 2;
%let END_YR = 2017;
%let END_MO = 2;

%macro macro_01;
	%LET CMONTH =&START_MO;
	%LET CYEAR =&START_YR;

	%DO %UNTIL(%SYSFUNC(MDY(&CMONTH,1,&CYEAR)) > %SYSFUNC(MDY(&END_MO,1,&END_YR)));
		
		data test_&CYEAR._&CMONTH.;
			var_01 = 1;
			var_02 = 'a';
		run;
		
		data _null_;
			call sleep(10,1);
		run;

		%LET CMONTH = %EVAL(&CMONTH + 1);
		%IF &CMONTH > 12 %THEN %DO;
			%LET CMONTH = 1;
			%LET CYEAR = %EVAL(&CYEAR + 1);
		%END;

	%END;
	
%mend macro_01;
%macro_01;

/************************************************************************************;*/
/*endProgram
/************************************************************************************;*/

%let START_YR = 2020;
%let START_MO = 9;
%let END_YR = 2020;
%let END_MO = 11;

%macro macro_01;
	%LET CMONTH =&START_MO;
	%LET CYEAR =&START_YR;
	
	%do yyyy = &START_YR. %to &END_YR.;
		%do m_var_in = &END_MO. %to &START_MO. %by -1;
			%if &m_var_in. < 10 %then %do;
				%let mm_var = 0&m_var_in.;
			%end;
			%else %do;
				%let mm_var = &m_var_in.;
			%end;
			
			data test_&yyyy.&mm_var.;
				var_01 = &yyyy.;
				var_02 = "&mm_var.";
			run;
		%end;
	%end;
%mend macro_01;
%macro_01;

/************************************************************************************;*/
/*endProgram
/************************************************************************************;*/