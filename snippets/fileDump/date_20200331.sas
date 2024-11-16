
%let date_mvar_01=31DEC9999;
%let date_mvar_02=06APR2020;

data test_01;
	date_var_01 = "&date_mvar_01."d;
	date_var_01b = date_var_01;

	date_var_02 = "&date_mvar_02."d;
	date_var_02b = date_var_02;

	date_var_02_day = day(date_var_02);
	date_var_02_week = week(date_var_02);
	date_var_02_month = month(date_var_02);
	date_var_02_qtr = qtr(date_var_02);
	date_var_02_year = year(date_var_02);

	format
		date_var_01b
		date_var_02b mmddyy8.;
run;

/************************************************************************************;*/

data test_01;
	length
		process_date 8.
		flag_01 $3
		text_01 $26
		flag_02 $3;
		
	process_date = mdy(2,1,2020);
	format process_date mmddyy8.;
	text_01 = 'DUAL_STUS_CD_201702_201705';
	
	flag_01  = lowcase(put(process_date,MONNAME3.)); *<==output: 'feb';
	flag_02  = lowcase(put(MDY(substr(text_01,25,2),1,substr(text_01,21,4)),MONNAME3.)); *<==output: 'may';
run;

/************************************************************************************;*/

%let CMONTH = 07;
%let CYEAR = 2017;

data test_01;
	firstDat=intnx('month',mdy(&CMONTH.,15,&CYEAR.),0,'B');
	lastDay=intnx('month',mdy(&CMONTH.,1,&CYEAR.),0,'E');
	format firstDat lastDay date9.;
run;

%LET CDATE1 = %STR(%')%SYSFUNC(PUTN(%SYSFUNC(INTNX(MONTH,"%SYSFUNC(PUTN(%SYSFUNC(MDY(&CMONTH,1,&CYEAR)),DATE9.))"D,0,B)),DATE9.))%STR(%');
%LET CDATE2 = %STR(%')%SYSFUNC(PUTN(%SYSFUNC(INTNX(MONTH,"%SYSFUNC(PUTN(%SYSFUNC(MDY(&CMONTH,1,&CYEAR)),DATE9.))"D,0,E)),DATE9.))%STR(%');

%put **** CDATE1 = &CDATE1. ****;
%put **** CDATE2 = &CDATE2. ****;

/************************************************************************************;*/

%let macro_var_month_num = 4;
%let yyyy = 2020;
%let mvar_month = %LOWCASE(%SYSFUNC(PUTN(%SYSFUNC(MDY(&macro_var_month_num,1,&yyyy)),MONNAME3.)));
%put mvar_month: &mvar_month.;

data test_01;
	var_01 = %SYSFUNC(PUTN(&macro_var_month_num,Z2.));
	var_02 = put(&macro_var_month_num.,MONNAME3.); *<=does NOT work - Result: Jan, because the SAS date for #4 is Jan 4, 1960;
	var_03 = "&mvar_month.";
	var_04 = put(MDY(&macro_var_month_num,1,&yyyy),MONNAME3.); *<=Result: Apr;
	var_05 = lowcase(put(MDY(&macro_var_month_num,1,&yyyy),MONNAME3.)); *<=Result: apr;
	var_06 = upcase(put(MDY(&macro_var_month_num,1,&yyyy),MONNAME3.)); *<=Result: APR;
	var_07 = propcase(put(MDY(&macro_var_month_num,1,&yyyy),MONNAME.)); *<=Result: April;
	%UPCASE(%SYSFUNC(PUTN(%SYSFUNC(MDY(&macro_var_month_num,1,&yyyy)),MONNAME3.))) = 1; *<=Result: New Var;
	%SYSFUNC(PROPCASE(%SYSFUNC(PUTN(%SYSFUNC(MDY(&macro_var_month_num,1,&yyyy)),MONNAME.)))) = 1; *<=Result: New Var;
run;

/************************************************************************************;*/

%let START_YR = 2019;
%let START_MO = 1;
%let END_YR = 2020;
%let END_MO = 03;

/*Initialize Macro Vars*/
%let CYEAR = &START_YR.;
%let MVARS_SMO =;
%let MVARS_EMO =;
%let MVARS_CMO =;
%let MVAR_MONTH1 =;
%let MVAR_MONTH2 =;
%let MVAR_MONTH3 =;
%let MVAR_MONTH_LIST =;

%macro macro_01;
	%DO %UNTIL(&CYEAR > &END_YR);
		%IF &CYEAR = &START_YR %THEN %LET MVARS_SMO = &START_MO;
		%ELSE %LET MVARS_SMO = 1;
		
		%IF &CYEAR = &END_YR %THEN %LET MVARS_EMO = &END_MO;
		%ELSE %LET MVARS_EMO = 12;
		
		%LET MVARS_CMO = &MVARS_SMO;
		%DO %UNTIL(&MVARS_CMO > &MVARS_EMO);
			%LET MVAR_MONTH1 = %SYSFUNC(PUTN(&MVARS_CMO,Z2.));
			%LET MVAR_MONTH2 = %UPCASE(%SYSFUNC(PUTN(%SYSFUNC(MDY(&MVARS_CMO,1,&CYEAR)),MONNAME3.)));
			%LET MVAR_MONTH3 = %SYSFUNC(PROPCASE(%SYSFUNC(PUTN(%SYSFUNC(MDY(&MVARS_CMO,1,&CYEAR)),MONNAME.))));

			%LET MVAR_MONTH_LIST = &MVAR_MONTH_LIST MONTHLY_VAR_NAME&MVAR_MONTH1;

			%LET MVARS_CMO = %EVAL(&MVARS_CMO + 1);
		%END;
		%LET CYEAR = %EVAL(&CYEAR + 1);
	%END;
	
	%put MVAR_MONTH1 = &MVAR_MONTH1.;
	%put MVAR_MONTH2 = &MVAR_MONTH2.;
	%put MVAR_MONTH3 = &MVAR_MONTH3.;

	%put MVAR_MONTH_LIST = &MVAR_MONTH_LIST.;
%mend macro_01;
%macro_01;

/************************************************************************************;*/

%let char_mvar_today = %SYSFUNC(PUTN(%SYSFUNC(TODAY()),YYMMDDN8.));
%put char_mvar_today = &char_mvar_today.;

data test_01;
	length
		char_var_from_mvar_today
		char_var_from_sysfunc_today $8;
		
	char_var_from_mvar_today = &char_mvar_today.;
	char_var_from_sysfunc_today = %SYSFUNC(PUTN(%SYSFUNC(TODAY()),YYMMDDN8.));
	
	num_var_not_date_var_from_mvar = &char_mvar_today.;
	num_var_not_date_var_sfunc_today = %SYSFUNC(PUTN(%SYSFUNC(TODAY()),YYMMDDN8.));
	
	increment_num_var_not_date_var = num_var_not_date_var_sfunc_today + 1;
	
	num_var_year_sysfunc_today = year(%SYSFUNC(TODAY()));
	num_var_next_year_sysfunc_today = year(%SYSFUNC(TODAY()))+1;
	
	num_var_year_func_today = year(TODAY());
	if year(today())+1 > 2020 then flag = 1;
	
	date_var_dec_31_1959 = -1;
	format_date_var_dec_31_1959 = date_var_dec_31_1959;
	
	date_var_jan_1_1960 = 0;
	format_date_var_jan_1_1960 = date_var_jan_1_1960;
	
	create_date_var_mdy_func = mdy(02,18,2020);
	format_create_date_var_mdy_func = create_date_var_mdy_func;
	
	create_date_var_mdy_func_charvar = mdy(
		substr(char_var_from_mvar_today,5,2)
		,substr(char_var_from_mvar_today,7,2)
		,substr(char_var_from_mvar_today,1,4));
	
	format
		format_date_var_dec_31_1959
		format_date_var_jan_1_1960
		format_create_date_var_mdy_func
		create_date_var_mdy_func_charvar YYMMDDN8.;
	
run;

/************************************************************************************;*/