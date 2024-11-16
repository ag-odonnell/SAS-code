
%let macroCall_num_vars =;
	
data test_01;
	var_01 = 1;
	var_02 = 2;
	var_03 = 3;
	var_04 = 4;
	array d_1(*) var_01 - var_04;
	do i = 1 to dim(d_1);
		cnt = i;
	end; drop i;
	call symput('macroCall_num_vars', strip(put(cnt,8.)));
run;

data test_01;
set test_01;
	array d_2(*) t1 - t&macroCall_num_vars.;
	do i = 1 to dim(d_2);
		d_2(i) = 0;
	end; drop i;
run;

%put ****macroCall_num_vars: &macroCall_num_vars.****;

/************************************************************************************;*/
/************************************************************************************;*/

%let macroCall_num_vars =;
	
data test_01;
	length char_var $1;
	array d_1(*) var_01 - var_04;
	do i = 1 to dim(d_1);
		d_1(i) = i;
		cnt = i;
		if i < 3 then char_var = 'a';
		else char_var = 'b';
		output;
	end; drop i;
	call symput('macroCall_num_vars', strip(put(cnt,8.)));
run;

data test_02 (
	drop =
		cnt
		var_01 - var_04
	rename = (
		t1 - t&macroCall_num_vars. = var_01 - var_04));
set test_01;
by char_var;
	retain t1 - t&macroCall_num_vars.;
	array d_1(*) var_01 - var_04;
	array d_2(*) t1 - t&macroCall_num_vars.;
	if first.char_var then do;
		do i = 1 to dim(d_2);
			d_2(i) = 0;
		end; drop i;
	end;
	do i = 1 to dim(d_2);
		d_2(i) + d_1(i);
	end; drop i;
	if last.char_var then output;
run;

/************************************************************************************;*/
/*endProgram
/************************************************************************************;*/
