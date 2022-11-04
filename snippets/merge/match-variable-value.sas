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

data test_03;
	length mark $2 match_vc1 8.;
merge
	test_01 (in=a)
	test_02 (in=b
		rename = (var_char_01 = vc1b));
by var_num_01;
	match_vc1 = .;
	if a then do;
		mark = 'a';
		if b then do;
			mark = 'ab';
			match_vc1 = 0;
			if var_char_01 = vc1b then match_vc1 = 1;
		end;
	end;
	else do;
		mark = 'b';
	end;
run;

proc freq data = test_03;
	tables mark / missing;
run;

proc freq data = test_03;
	tables mark * match_vc1 
	/ missing nocol norow nocum nopct format=comma15.;
run;

/*******/
/*endProgram
/*******/
