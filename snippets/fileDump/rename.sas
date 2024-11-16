
data test_01;
	num_var_01 = 1;
	char_var_01 = 'a';
	char_var_02 = 'b';
run;

proc sort 
	data = test_01 (
		rename = (
			char_var_01 - char_var_02 = char_var_b_01 - char_var_b_02))
	out = test_02;
by num_var_01;
run;

data test_01;
	var_01 = 1;
	var_02 = put(var_01,1.);
	var_03 = 3;
	*drop var_01; *cannot drop var using statement to recreate in same data step
	*length var_01 $1; *this will cause the program to crash because drop is not executed until end;
	*var_01 = var_02; *this char to num will not reformat var type;
	var_03 = var_01;
	*drop var_01; *this will work and can be added into an array;
run;


data test_01;
	var_01 = 1;
	var_02 = put(var_01,1.);
	var_03 = 3;
	var_03 = var_01;
	array d_1(*) var_01;
	array d_3(*) var_03;
	do p_01 = 1 to dim(d_1);
		d_3(p_01) = d_1(p_01);
	end;
	drop p_01 var_01;
run;