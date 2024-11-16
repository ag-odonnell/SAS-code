
%macro macro_00;
	%let var_val_found_04 = 0;

	data test_01;
		do i = 1 to 3;
			if i = 1 then char_var_01 = '01';
			else if i = 2 then char_var_01 = '02';
			*else if i = 3 then char_var_01 = '03'; *<==if use this line, var_val_found_04 resolves to 0;
			else if i = 3 then char_var_01 = '04'; *<==if use this line, var_val_found_04 resolves to 1;
			output;
		end;
		drop i;
	run;

	data _null_;
	set test_01;
	if char_var_01 = '04' then call symput('var_val_found_04', strip(1));
	run;

	%put ****var_val_found_04: &var_val_found_04.****;
%mend macro_00;
%macro_00;

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
