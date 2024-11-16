
data test_01;
	length 
		num_var_01 8
		num_var_02 8.
		num_var_03 8
		num_var_04 4
		char_var_01	$2;
	num_var_01 = 1;
	num_var_02 = 2;
	num_var_03 = 2019;
	num_var_04 = mdy(2,5,2017);
	char_var_01	= 'ab';
	
	format
		num_var_01 8.
		num_var_02 8.
		num_var_03 8.
		num_var_04 mmddyy8.
		char_var_01	$2.;
run;

proc sql;
	create table test_02 as 
		select
			a.num_var_01 length = 8 format = 15. informat = 15. label = 'num_var_label_01'
			,a.num_var_02 length = 8 format = 10.2 informat = 10.2 label = 'num_var_label_02'
			,a.num_var_03 length = 8 FORMAT = 4. INFORMAT = 4. LABEL = 'num_year_label_01'
			,a.num_var_04 length = 4 FORMAT = MMDDYY10. INFORMAT = MMDDYY10. LABEL = 'num_date_label_01'
			,a.char_var_01 length = 2 format = $2. informat = $2. label = 'char_var_label_01'
		from test_01 as a
	ORDER BY a.num_var_01;
QUIT;
