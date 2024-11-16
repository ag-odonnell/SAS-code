
%let max_length_table_mvar=;

data test_01;
	length TABLE $24;
	do i = 1 to 100;
		if mod(i,2) then TABLE = 'Table var_01';
		else if mod(i,3) then TABLE = 'Table var_a';
		else if mod(i,5) then TABLE = 'Table var_something_else';
		output;
	end;
run;

data test_01;
set test_01 (rename = (TABLE = table_temp));
	table = strip(TRANWRD(table_temp,'Table',''));
	length_table = length(TABLE);
	retain max_length_table;
	if _n_ = 1 then max_length_table = 0;
	if length_table > max_length_table then do;
		max_length_table = length_table;
		call symput('max_length_table_mvar', strip(max_length_table));
	end;
run;

%put ****max_length_table_mvar: &max_length_table_mvar.****;

data test_01;
length TABLE $&max_length_table_mvar.;;
set test_01 (rename = (TABLE = table_temp_02));
	TABLE = table_temp_02;
run;

/************************************************************************************;*/
/*endProgram
/************************************************************************************;*/
