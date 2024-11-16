
data test_01;
	var_num_01 = 1;
	do i = 1 to 28;
		if i > 15 then var_num_01 = 2;
		var_num_02 = i;
		if mod(i,2) then var_char_01 = 'Y';
		else var_char_01 = 'N';
		if mod(i,4) then var_char_02 = 'F';
		else var_char_02 = 'M';
		output;
	end;
run;

proc sort
	data = test_01
	out = test_02;
by var_num_01 descending var_char_01;
run;

proc sort
	data = test_01 (
		keep =
			var_num_01
			var_num_02
			var_char_01
			var_char_02
		rename = (var_char_02 = var_char_02_new))
	out = test_03
	nodupkey;
where var_num_01 > 1;
by var_char_01 var_char_02_new;
run;

proc sort
	data = test_01 (
		firstobs = 5
		obs = 18)
	out = test_04 (
		keep =
			var_num_01
			var_num_02
			var_char_01
			var_char_02
		rename = (var_char_02 = var_char_02_new));
by var_char_01 var_char_02;
run;


proc sort
	data = test_01 (
		firstobs = 498268952
		obs = 498268957)
	out = test_04 (
		keep =
			var_num_01
			var_num_02
			var_char_01
			var_char_02
		rename = (var_char_02 = var_char_02_new));
by var_char_01 var_char_02;
run;
