
%macro macro_01a(where_condition_01=);
	%let switch = 0;
	%if &where_condition_01. NE %then %do;
		%let switch = 1;
	%end;
	%if &switch. = 1 %then %do;
		data test_01;
			var_01 = 1;
		run;
	%end;
	%put **** where_condition_01 = &where_condition_01. ****;
	%put **** switch = &switch. ****;
%mend macro_01a;
%macro_01a(where_condition_01=);
%macro_01a(where_condition_01=%str(where STATE = 'TX'));


%let start_year = 2020;
%let start_month = 07;
%let end_year = 2020;
%let end_month = 12;

%macro macro_01;
	%do CMONTH = &start_month. %to &end_month.;
		%if &CMONTH < 10 %then %do;
			%let CMONTH_char = 0%eval(&CMONTH);
		%end;
		%else %do;
			%let CMONTH_char = %eval(&CMONTH);
		%end;
		%put **** CMONTH: &CMONTH****;
		%put **** CMONTH_char: &CMONTH_char****;
	%end;
%mend macro_01;
%macro_01;
