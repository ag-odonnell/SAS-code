
/***********************************************************************;*/
/* Note: Build test dataset
/* - The example uses various ways to assign variable names and values
/***********************************************************************;*/

%let dt_base = M201912;
%let dt_updt = M202001;
%let macroCall_max_load_cnt = 20;
%let dir_path_data_03 =;

data test_01;
	do i = 1 to &macroCall_max_load_cnt.;
		M201911 = 1 + i;
		&dt_base. = 2 + (2 * i);
		&dt_updt. = 3 + (3 * i) + i;
		delta_&dt_base._M201911 = &dt_base. - M201911;
		delta_&dt_updt._&dt_base. = &dt_updt. - &dt_base.;
		output;
	end;
run;

data test_01;
length i sort_index M201911 &dt_base. delta_&dt_base._M201911 &dt_updt. delta_&dt_updt._&dt_base. 8.;
set test_01;
	array d_1(*) delta_&dt_base._M201911 delta_&dt_updt._&dt_base.;
	
	min_delta = min(of d_1[*]);
	mean_delta = mean(of d_1[*]);
	max_delta = max(of d_1[*]);
	std_delta = std(of d_1[*]);
	z_score_delta = (&dt_updt. - mean_delta) / std_delta;
	
	if i < 5 then sort_index = 1;
	else if i < 7 then sort_index = 2;
	else if i < 11 then sort_index = 3;
	else if i < 15 then sort_index = 4;
	else if i < 18 then sort_index = 5;
	else sort_index = 6;
run;

/***********************************************************************;*/
/* Note: develop macro call list
/***********************************************************************;*/

%let macroCall_cnt_sort_index_01 =;
%let macroCall_cnt_sort_index_02 =;
%let macroCall_cnt_sort_index_03 =;
%let macroCall_cnt_sort_index_04 =;
%let macroCall_cnt_sort_index_05 =;
%let macroCall_cnt_sort_index_06 =;

%LET sort_index_LIST =;
%LET sort_index_mLIST =;
%LET  sort_index_cnum = 1;
%macro macro_01();
	%DO %UNTIL(&sort_index_cnum > 6);
		%LET sort_index_num1 = %SYSFUNC(PUTN(&sort_index_cnum,Z2.));
		%LET sort_index_LIST = &sort_index_LIST cnt_sort_index_&sort_index_num1;
		%LET sort_index_mLIST = &sort_index_mLIST macroCall_cnt_sort_index_&sort_index_num1;
		%LET sort_index_cnum = %EVAL(&sort_index_cnum + 1);
	%END;
%mend;
%macro_01;
%put **** sort_index_mLIST = &sort_index_mLIST. ****;

/***********************************************************************;*/
/* Note: determine number of rows associated with each sort index
/***********************************************************************;*/

data test_02;
set test_01;
by sort_index;
	array d_1(*) &sort_index_LIST.;
	do i = 1 to dim(d_1);
		if sort_index = i then d_1(i) + 1;
	end;
	drop i;
	if last.sort_index then do;
		do i = 1 to dim(d_1);
			sort_index_less_than_mark = sum(of d_1[*])+1;
		end;
		keep sort_index sort_index_less_than_mark;
		output;
	end;
run;

data _null_;
set test_02;
	if sort_index = 1 then call symput('macroCall_cnt_sort_index_01',strip(put(sort_index_less_than_mark,3.)));
	else if sort_index = 2 then call symput('macroCall_cnt_sort_index_02',strip(put(sort_index_less_than_mark,3.)));
	else if sort_index = 3 then call symput('macroCall_cnt_sort_index_03',strip(put(sort_index_less_than_mark,3.)));
	else if sort_index = 4 then call symput('macroCall_cnt_sort_index_04',strip(put(sort_index_less_than_mark,3.)));
	else if sort_index = 5 then call symput('macroCall_cnt_sort_index_05',strip(put(sort_index_less_than_mark,3.)));
	else if sort_index = 6 then call symput('macroCall_cnt_sort_index_06',strip(put(sort_index_less_than_mark,3.)));
run;

%LET  sort_index_cnum = 1;
%macro macro_02();
	%DO %UNTIL(&sort_index_cnum > 6);
		%LET sort_index_num1 = %SYSFUNC(PUTN(&sort_index_cnum,Z2.));
		%put **** macroCall_cnt_sort_index_&sort_index_num1 = &&macroCall_cnt_sort_index_&sort_index_num1. ****;
		%LET sort_index_cnum = %EVAL(&sort_index_cnum + 1);
	%END;
%mend;
%macro_02;

/***********************************************************************;*/
/* Note: apply color indicator to rows based on modulus value
/* - mod(var_name,2) = every other group (row in the case of count var)
/* - the mark value will NOT actually be used. Simply to verify modulus
/***********************************************************************;*/

data
	test_01
	test_01_&dt_base.&dt_updt. (
		drop = count)
	;
set test_01;
	count+1;
	if mod(sort_index,2) then do;
		if mod(count,2) then do;
			mark='orange';
		end;
	end;
	else do;
		if mod(count,2) then do;
			mark='gray';
		end;
	end;
run;

/***********************************************************************;*/
/* Note: Using ODS to output to a single <.pdf> file
/***********************************************************************;*/

%macro macro_03();
	goptions reset=all;
	ods _all_ close;
	ods pdf file="&dir_path_data_03.test_01_&dt_base.&dt_updt..pdf";
		options
			orientation=landscape
			nocenter
			topmargin=.25in
			bottommargin=.25in
			leftmargin=.25in
			rightmargin=.25in;
		PROC SGPLOT DATA = test_01_&dt_base.&dt_updt.;
			where i > 1;
			NEEDLE X=i Y=z_score_delta;
			LOESS X=i Y=z_score_delta;
			xaxis GRID VALUES = (0 TO %eval(&macroCall_max_load_cnt+6) BY 5);
			YAXIS LABEL = 'z_score_delta';
			TITLE1 'z_score_delta by iteration (i)';
			run;
		quit;
		goptions RESET=(TITLE FOOTNOTE AXIS);


		proc report
			data=test_01_&dt_base.&dt_updt. (
				keep =
					sort_index
					M201911
					&dt_base.
					delta_&dt_base._M201911
					&dt_updt.
					delta_&dt_updt._&dt_base.
					min_delta
					mean_delta
					max_delta
					std_delta
					z_score_delta
					mark
				)
			nowd;
			compute &dt_updt.;
				CALL DEFINE(_COL_, "style", "STYLE=[BACKGROUND=yellow]");
			endcomp;
			compute &dt_base.;
				CALL DEFINE(_COL_, "style", "STYLE=[BACKGROUND=lightyellow]");
			endcomp;
			compute delta_&dt_updt._&dt_base.;
				CALL DEFINE(_COL_, "style", "STYLE=[BACKGROUND=lightyellow]");
			endcomp;
			compute sort_index;
				count+1;
				if count < %eval(&macroCall_cnt_sort_index_01.) then do;
					if mod(count,2) then do;
						call define(_row_, "style", "style=[background=orange]");
					end;
				end;
				else if count < %eval(&macroCall_cnt_sort_index_02.) then do;
					if mod(count,2) then do;
						call define(_row_, "style", "style=[background=gray]");
					end;
				end;
				else if count < %eval(&macroCall_cnt_sort_index_03.) then do;
					if mod(count,2) then do;
						call define(_row_, "style", "style=[background=orange]");
					end;
				end;
				else if count < %eval(&macroCall_cnt_sort_index_04.) then do;
					if mod(count,2) then do;
						call define(_row_, "style", "style=[background=gray]");
					end;
				end;
				else if count < %eval(&macroCall_cnt_sort_index_05.) then do;
					if mod(count,2) then do;
						call define(_row_, "style", "style=[background=orange]");
					end;
				end;
				else if count < %eval(&macroCall_cnt_sort_index_06.) then do;
					if mod(count,2) then do;
						call define(_row_, "style", "style=[background=gray]");
					end;
				end;
			endcomp;
			run;
		quit;
	ods pdf close;
%mend;
%macro_03;

/***********************************************************************;*/
/*endProgram
/***********************************************************************;*/
