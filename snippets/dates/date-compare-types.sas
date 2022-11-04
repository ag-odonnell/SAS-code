data test_01;
	date_var_01 = 1; *Jan 1, 1960 | formatted as a number;
	date_var_02 = date_var_01; *Jan 1, 1960 | formatted as a date;
	date_var_02b = year(date_var_02); *the year 1960 | formatted as a number;
	date_var_02c = date_var_02b; *the number 1960 | resolves to May 14, 1965 | formatted as a date;
	date_var_03 = mdy(7,6,2022); *Jul 6, 2022 | formatted as a number;
	date_var_04 = date_var_03; *Jul 6, 2022 | formatted as a date;
	date_var_05 = '20220628'; *Jun 28, 2022 | formatted as a string;
	date_var_06 = mdy(
		input(substr(date_var_05,5,2),2.)
		,input(substr(date_var_05,7,2),2.)
		,input(substr(date_var_05,1,4),4.)); *the string 20220628 | read into date | formatted as a number;
	date_var_07 = date_var_06; *Jun 28, 2022 | formatted as date;
	format
		date_var_02
		date_var_02c
		date_var_04
		date_var_07 mmddyy8.;
run;
