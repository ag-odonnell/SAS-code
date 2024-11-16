
data test_01;
	do i = 1 to 1000000;
		var_num_01 = i;
		var_char_01 = 'ab';
		if mod(i,2) then var_flag_01 = '0';
		else var_flag_01 = '1';
		if mod(i,5) then var_flag_02 = 'a';
		else var_flag_02 = 'b';
		if mod(i,10) then var_flag_03 = 'x';
		else var_flag_03 = 'y';
		output;
	end;
	drop i;
run;

proc freq data = test_01;
tables
	var_char_01
	var_flag_01 * var_flag_02
	var_flag_01 * var_flag_02 * var_flag_03
	/ missing nocol norow nocum nopct format=comma15.;
run;

proc freq
	data = test_01
		noprint;
	tables
		var_flag_01
		/ missing nocol norow nocum nopct format = comma15.
		out = test_02;
run;


%macro macro_02();
	%do i = 1 %to 3;
		%if &i < 10 %then %do;
			%let i_char = 0%eval(&i);
		%end;
		%else %do;
			%let i_char = %eval(&i);
		%end;
		proc freq
			data = test_01
				noprint;
			tables
				var_flag_&i_char.
				/ missing nocol norow nocum nopct format = comma15.
				out = test_02_vf_&i_char.;
		run;
	%end;
	
	data test_02;
	merge 
		test_02_vf_01 (drop = percent rename = (count = count_v01))
		test_02_vf_02 (drop = percent rename = (count = count_v02))
		test_02_vf_03 (drop = percent rename = (count = count_v03));
	run;
%mend macro_02;
%macro_02();
