
data test_01;
	do i = 1 to 100;
		if mod(i,3) then char_var_01 = 'b';
		else char_var_01 = 'a';
		if mod(i,4) then num_var_01 = i/4;
		else num_var_01 = i;
		output;
	end;
run;

proc univariate data = test_01;
	var
		num_var_01;
run;

Proc Freq data = test_01;
	tables
		char_var_01
		/ missing;
run;

/************************************************************************************;*/
/*endProgram
/************************************************************************************;*/

