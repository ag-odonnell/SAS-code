data test_01;
	do i = 1 to 4;
		var_num_01 = i;
		if i = 1 then var_char_01 = 'a';
		else if i = 2 then var_char_01 = 'b';
		else if i = 3 then var_char_01 = 'c';
		else if i = 4 then var_char_01 = 'd';
		output;
	end;
run;

data test_02;
	do i = 3 to 5;
		var_num_01 = i;
		if i = 3 then var_char_01 = 'c';
		else if i = 4 then var_char_01 = 'e';
		else var_char_01 = 'f';
		output;
	end;
run;

/*Note: the following code appends the two datasets together*/
/**append: add rows from the second dataset after the rows from the first/

data test_04;
set
	test_01
	test_02;
run;

proc datasets lib = work nolist;
	delete
		test_04
; quit;

/*******/
/*endProgram
/*******/
