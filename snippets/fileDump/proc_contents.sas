
/*******/

%let vlist=;
%let nvars=;

%macro macro_01;
    proc contents
        data=aalib01.prvdr_pos_ey24_p01_v20_dy22
        out=aalib02.pos_20240329_01 (
            keep =
                /*libname
                memname*/
                name
                type
                /*length
                format
                formatl
                varnum
                npos
                nobs*/
            )
        short
        noprint;
    run;

    proc sort data=aalib02.pos_20240329_01; where type=2; by name; run;
    
    proc sql noprint;
        select name into :vlist separated by ' '
        from aalib02.pos_20240329_01;
    quit;

    %put ****vlist: &vlist.****;
    
	%let nvars = %sysfunc(countw(&vlist));
	%put ****number of vars: &nvars.****;

%mend macro_01;
%macro_01;

/*******/
/*
****number of vars: 344****
/*******/
/*

data test_01;
    length var_01 var_02 $4;
    do i=1 to 6;
        if i=1 then do; var_01='123'; var_02='456'; var_03='789'; end;
        else if i=2 then do; var_01=' 123'; var_02='456'; var_03='789'; end;
        else if i=3 then do; var_01='123'; var_02='456 '; var_03='789'; end;
        else if i=4 then do; var_01='123'; var_02=' 456'; var_03='789'; end;
        else if i=5 then do; var_01=' 123'; var_02=' 456'; var_03='789'; end;
        else if i=6 then do; var_01='123 '; var_02='456 '; var_03='789'; end;
        output;
    end;
    drop i;
run;

%let vlist=var_01 var_02 var_03;

data
    test_02
    test_03;
set test_01;
    array d_1(*) &vlist.;
    array d_2(*) 8. f_1 - f_3;
    flag_row=0;
    length_v1=length(var_01);
    length_v2=length(var_02);
    length_v3=length(var_03);
    do i = 1 to dim(d_1);
        d_2(i)=0;
        if length(strip(d_1(i)))<length(d_1(i)) then do;
            d_2(i)=1;
            flag_row=1;
        end;
    end;
    drop i;
    output test_02;
    if flag_row=1 then output test_03;
run;

proc freq data=test_02;
    tables flag_row / missing;
run;

proc transpose
    data = test_03 (
        keep=f_1 - f_3)
    out = test_03t;
run;

proc sort data=test_03t;
    by descending col1 descending col2 descending col3;
run;

data test_04t;
set test_03t;
by descending col1 descending col2 descending col3;
    array d_1(*) col1 - col3;
    array d_2(*) 8. c_1 - c_3;
    if _n_=1 then do;
        do i = 1 to dim(d_1);
            d_2(i)=0;
        end;
    end;
    drop i;
    do i = 1 to dim(d_1);
        if d_1(i)=1 then d_2(i)+1;
    end;
run;

proc transpose
    data = test_03 (
        drop=flag_row length_v1 - length_v3)
    out = test_05t;
run;

data test_06t;
set test_05t;
    if mod(_n_,2) then output;
run;

/*******/

%macro macro_02;
    data
        aalib02.pos_20240329_02
        aalib02.pos_20240329_03
        ;
    set aalib01.prvdr_pos_ey24_p01_v20_dy22;
        array d_1(*) &vlist.;
        array d_2(*) 8. f_1 - f_&nvars.;
        flag_row=0;
        do i = 1 to dim(d_1);
            d_2(i)=0;
            if length(strip(d_1(i)))<length(d_1(i)) then do;
                d_2(i)=1;
                flag_row=1;
            end;
        end;
        drop i;
        output aalib02.pos_20240329_02;
        if flag_row=1 then output aalib02.pos_20240329_03;
    run;

    proc freq data=aalib02.pos_20240329_02;
        tables flag_row / missing;
    run;

    proc transpose
        data = aalib02.pos_20240329_03 (
            keep=f_1 - f_&nvars.)
        out = aalib02.pos_20240329_03t;
    run;

    %let sort_order_01=descending col1 descending col13;

    proc sort data=aalib02.pos_20240329_03t;
        by &sort_order_01.;
    run;

    data aalib02.pos_20240329_04t;
    set aalib02.pos_20240329_03t;
    by &sort_order_01.;
        array d_1(*) col1 - col25;
        array d_2(*) 8. c_1 - c_25;
        if _n_=1 then do;
            do i = 1 to dim(d_1);
                d_2(i)=0;
            end;
        end;
        drop i;
        do i = 1 to dim(d_1);
            if d_1(i)=1 then d_2(i)+1;
        end;
    run;
%mend macro_02;
%macro_02;

/*******/
/*
NAME(line=164) = MDCD_VNDR_NUM
NAME(line=332) = ST_ADR

/*******/

%macro macro_03;
    data aalib02.pos_20240329_04;
    set aalib02.pos_20240329_03 (keep = flag_row f_164 f_332 FAC_NAME PRVDR_NUM MDCD_VNDR_NUM ST_ADR);
    run;
%mend macro_03;
%macro_03;

/*******/

%macro macro_04;
%mend macro_04;
%macro_04;

/*******/
/*endProgram
/*******/

/***********************************************************************;*/
/*Create macro list of variables from a dataset
There are times that the order of variables or an array of variables
in an updated dataset could be facilitated by starting with the list of variables 
from the original/base dataset.

Create test dataset
/***********************************************************************;*/

data test_01;
	length
		M201910
		M201911
		DELTA_M201911_M201910
		M201912
		DELTA_M201912_M201911
		M202001
		DELTA_M202001_M201912 8.;
	do i = 1 to 5;
		M201910 = i;
		M201911 = i+2;
		M201912 = i*2;
		M202001 = i*4-2;
		DELTA_M201911_M201910 = M201911 - M201910;
		DELTA_M201912_M201911 = M201912 - M201911;
		DELTA_M202001_M201912 = M202001 - M201912;
		output;
	end;
	drop i;
run;

/***********************************************************************;*/
/*Use Proc Contents to output a dataset containing characteristics of each variable
/***********************************************************************;*/

proc contents
	data = test_01
	out = test_02 (
		keep =
			libname
			memname
			name
			type
			length
			format
			formatl
			varnum
			npos
			nobs)
	short
	noprint;
run;

/***********************************************************************;*/
/*Keep the variables of interest (and create count and length macro calls)
/***********************************************************************;*/

proc sort data = test_02;
by name;
run;

data test_02;
set test_02 (keep = name);
by name;
where upcase(substr(strip(name),1,5)) = 'DELTA';
cnt + 1;
length_name_string = cnt * 22 - 1;
call symput('macroCall_n', strip(cnt));
call symput('macroCall_length', strip(length_name_string));
run;

%put **** macroCall_n = &macroCall_n. ****;
%put **** macroCall_length = &macroCall_length. ****;

/***********************************************************************;*/
/*Create a macro call as a string that contains the names from the base dataset
/***********************************************************************;*/

data test_02;
length name_string $&macroCall_length.;
set test_02;
by name;
	retain name_string;
	if cnt = 1 then name_string = strip(name);
	else name_string = cat(trim(name_string),' ',strip(name));
	verify_length_name_string = length(name_string);
	call symput('macroCall_name_string', strip(name_string));
run;

%put **** macroCall_name_string = &macroCall_name_string. ****;

/***********************************************************************;*/
/*Apply the string to an updated dataset
/***********************************************************************;*/

%let dt_updt = M202002;
%let dt_base = M202001;

data test_03;
set test_01;
	&dt_updt. = _n_*10;
	delta_&dt_updt._&dt_base. = &dt_updt. - &dt_base.;
	array d_1(*) &macroCall_name_string. delta_&dt_updt._&dt_base.;
	min_delta = min(of d_1[*]);
	mean_delta = mean(of d_1[*]);
	max_delta = max(of d_1[*]);
	std_delta = std(of d_1[*]);
	if std_delta > 0
		then zscore_delta = (delta_&dt_updt._&dt_base. - mean_delta) / std_delta;
run;

/***********************************************************************;*/
/*endProgram
/***********************************************************************;*/
/***********************************************************************;*/




/***********************************************************************;*/
/*Create macro list of variables from a dataset
There are times that the order of variables or an array of variables
in an updated dataset could be facilitated by starting with the list of variables 
from the original/base dataset.

Create test dataset
/***********************************************************************;*/

data test_01;
	length
		M201910
		M201911
		DELTA_M201911_M201910
		M201912
		DELTA_M201912_M201911
		M202001
		DELTA_M202001_M201912 8.;
	do i = 1 to 5;
		M201910 = i;
		M201911 = i+2;
		M201912 = i*2;
		M202001 = i*4-2;
		DELTA_M201911_M201910 = M201911 - M201910;
		DELTA_M201912_M201911 = M201912 - M201911;
		DELTA_M202001_M201912 = M202001 - M201912;
		output;
	end;
	drop i;
run;

/***********************************************************************;*/
/*Use Proc Contents to output a dataset containing characteristics of each variable
/***********************************************************************;*/

proc contents
	data = test_01
	out = test_02 (
		keep =
			libname
			memname
			name
			type
			length
			format
			formatl
			varnum
			npos
			nobs)
	short
	noprint;
run;

/***********************************************************************;*/
/*Keep the variables of interest (and create count and length macro calls)
/***********************************************************************;*/

proc sort data = test_02;
by name;
run;

data test_02;
set test_02 (keep = name);
by name;
where upcase(substr(strip(name),1,5)) = 'DELTA';
cnt + 1;
length_name_string = cnt * 22 - 1;
call symput('macroCall_n', strip(cnt));
call symput('macroCall_length', strip(length_name_string));
run;

%put **** macroCall_n = &macroCall_n. ****;
%put **** macroCall_length = &macroCall_length. ****;

/***********************************************************************;*/
/*Create a macro call as a string that contains the names from the base dataset
/***********************************************************************;*/

data test_02;
length name_string $&macroCall_length.;
set test_02;
by name;
	retain name_string;
	if cnt = 1 then name_string = strip(name);
	else name_string = cat(trim(name_string),' ',strip(name));
	verify_length_name_string = length(name_string);
	call symput('macroCall_name_string', strip(name_string));
run;

%put **** macroCall_name_string = &macroCall_name_string. ****;

/***********************************************************************;*/
/*Apply the string to an updated dataset
/***********************************************************************;*/

%let dt_updt = M202002;
%let dt_base = M202001;

data test_03;
set test_01;
	&dt_updt. = _n_*10;
	delta_&dt_updt._&dt_base. = &dt_updt. - &dt_base.;
	array d_1(*) &macroCall_name_string. delta_&dt_updt._&dt_base.;
	min_delta = min(of d_1[*]);
	mean_delta = mean(of d_1[*]);
	max_delta = max(of d_1[*]);
	std_delta = std(of d_1[*]);
	if std_delta > 0
		then zscore_delta = (delta_&dt_updt._&dt_base. - mean_delta) / std_delta;
run;

/***********************************************************************;*/
/*endProgram
/***********************************************************************;*/

/***********************************************************************;*/
/***********************************************************************;*/

%let start_yyyy = 2006;
%let end_yyyy = 2019;

%let ds_root_name_to_eval_ = ds_name_;
%let var_to_plot = AGE; *This program requires that this macro var is defined all in cap letters;

%let lib_ref_path_01 = /sas/.../input_dir_01;
%let lib_ref_path_02 = /sas/.../work_dir_01;
%let lib_ref_path_03 = /sas/.../input_dir_02;


libname aa_lib01 "&lib_ref_path_01.";
libname aa_lib02 "&lib_ref_path_02.";
libname aa_lib03 "&lib_ref_path_03.";

/************************************************************************************;*/

%macro macro_01();
	%do yyyy = &start_yyyy. %to &end_yyyy.;
		%if &yyyy. < &end_yyyy. %then %do;
			%let lib_ref = aa_lib01;
		%end;
		%else %do;
			%let lib_ref = aa_lib03;
		%end;
		proc contents
			data = &lib_ref..&ds_root_name_to_eval_.&yyyy.
			out = aa_lib02.test_02_&yyyy. (
				keep =
					libname
					memname
					name
					type
					length
					format
					formatl
					varnum
					npos
					nobs)
			short
			noprint;
		run;
		
		proc sort
			data = aa_lib02.test_02_&yyyy.(
				keep = 
					name
					nobs
				rename = (
					nobs = nobs&yyyy.))
			out = aa_lib02.test_03_&yyyy.;
		by name;
		run;
	%end;
	
	/***********************************************************************;*/
	
	data aa_lib02.test_content_summary_&start_yyyy._&end_yyyy.;
	merge aa_lib02.test_03_:;
	by name;
	run;
	
	data aa_lib02.test_05_&start_yyyy._&end_yyyy.;
	set
		aa_lib02.test_content_summary_&start_yyyy._&end_yyyy.;
		if upcase(strip(name)) in ("&var_to_plot.") then output;
	run;
		
	proc transpose
		data = aa_lib02.test_05_&start_yyyy._&end_yyyy. 
		out = aa_lib02.test_05_transpose_&start_yyyy._&end_yyyy. (
			rename = (
				col1 = var_to_evaluate));
	run;
	
	/***********************************************************************;*/
	
	data aa_lib02.test_06_&start_yyyy._&end_yyyy.;
		do i = &start_yyyy. to &end_yyyy.;
			name = 'yyyymm';
			process_year = mdy(6,1,i);
			output;
		end;
		drop = i;
		format process_year mmddyy8.;
	run;
	
	data aa_lib02.test_graph_&start_yyyy._&end_yyyy.(
		keep = _name_ var_to_evaluate process_year);
	merge
		aa_lib02.test_05_transpose_&start_yyyy._&end_yyyy.
		aa_lib02.test_06_&start_yyyy._&end_yyyy.;
	*notice that NO by statement is used;
	run;
	
	/***********************************************************************;*/
	
	filename graphout "&lib_ref_path_02./test_graph_&start_yyyy._&end_yyyy..gif";
	goptions reset=all device=gif gsfname=graphout;
	ODS _all_ CLOSE;
	ODS LISTING;
		proc gplot
			data=aa_lib02.test_graph_&start_yyyy._&end_yyyy.;
			plot var_to_evaluate*process_year=1;
			symbol1 v=star c=blue;
			title "Time Series Plot";
		run;
		quit;
		title;
	ODS LISTING CLOSE;
	
	proc datasets library = aa_lib02 nolist;
		delete
			test_02_:
			test_03_:
			test_05_&start_yyyy._&end_yyyy.
			test_05_transpose_&start_yyyy._&end_yyyy.
			test_06_&start_yyyy._&end_yyyy.;
	quit;

%mend macro_01;
%macro_01();


/***********************************************************************;*/
/*endProgram
/***********************************************************************;*/


