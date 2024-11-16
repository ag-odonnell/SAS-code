
data test_01;
	MID = 1;
	SID = 1;
	do i = 1 to 10;
		SID = mod(i,6);
		if i < 3 then BID = 2;
		else if i < 7 then BID = 4;
		else BID = i;
		output;
	end;
run;

proc sort data = test_01;
by MID SID;
run;

PROC DATASETS LIBRARY = work NOLIST;
	MODIFY	test_01 (
		SORTEDBY = MID SID);
	INDEX CREATE MSID = (MID SID);
	INDEX CREATE MID SID;
	INDEX CREATE BID;
	INDEX CREATE i / UNIQUE;
; QUIT;

proc contents data = test_01; run; 

/************************************************************************************;*/

%let start_yyyy = 2019;
%let end_yyyyy = 2020;

%macro macro_01(ds=,sort_by_list=,index_var_list=);
	%do yyyy = &start_yyyy. %to &end_yyyyy.;
		PROC DATASETS LIBRARY = work NOLIST;
			MODIFY	&ds.&yyyy. (
				SORTEDBY = &sort_by_list.);
			INDEX CREATE &index_var_list.;
		; QUIT;
			
		proc contents data = test_01; run;
	%end;
%mend macro_01;
%macro_01 (
	ds = test_01_
	,sort_by_list = MID SID
	,index_var_list = MID SID BID);

/************************************************************************************;*/
/*endProgram
/************************************************************************************;*/
