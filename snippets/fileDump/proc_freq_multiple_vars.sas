
data test_01;
	do i = 1 to 100;
		if mod(i,2) then char_var_01 = 'a';
		else char_var_01 = 'b';
		if mod(i,3) then char_var_02 = 'c';
		else char_var_02 = 'd';
		if mod(i,5) then  char_var_03 = 'e';
		else char_var_03 = 'f';
		output;
	end;
run;

/************************************************************************************;*/

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

proc sort
	data = test_02
	out = test_03
		nodupkey;
by name;
	where type = 2; /*type = 2 is a char_var condition*/
run;

%let Parameter_List=;
proc sql noprint;
	select name into :Parameter_List separated by ' '
	from test_03;
quit;

%put ****Parameter_List: &Parameter_List.****;

/************************************************************************************;*/

ods output onewayfreqs=test_04;
proc freq data=test_01 ;*noprint <==may NOT be able to use NOPRINT in SASEG session;
tables &Parameter_List.;
run;


data test_05;
	length var_val $32;
set test_04 (
	rename = (
		table = table_temp
		frequency = count
	));
	table = strip(TRANWRD(table_temp,'Table',''));
	format count comma15.;
	var_val='';
run;

/************************************************************************************;*/

%macro loop(vlist);
	%let num_words = %sysfunc(countw(&vlist));
	%put ****num_words: &num_words.****;
	%let var_name_out = ;
	%do i = 1 %to &num_words;
		%let var_name_out = %scan(&vlist, &i);
		%put ****i: &i.****;
		%put ****var_name_out: &var_name_out.****;
		data test_05 (drop = var_val_temp);
			length var_val $32;
		set test_05 (rename = (var_val = var_val_temp));
			if strip(table) = strip("&var_name_out.") then var_val = &var_name_out;
			else var_val = var_val_temp;
		run;

	%end;
%mend;
%loop(&Parameter_List);

/************************************************************************************;*/

data test_06 (keep = table var_val count);
	length table $32 var_val $32;
set test_05 (rename = (table = table_temp_02));
	table = table_temp_02;
run;

/************************************************************************************;*/
/*endProgram
/************************************************************************************;*/
