
data test_01;
	var_01 = '12345';
	var_02 = "'12345'";
	var_03 = '"12345"';
	var_04 = '{12345}';
	var_05 = '';
	var_06 = '{';
	var_07 = '{"12345"}';
run;

data test_02;
set test_01;
	if strip(substr(var_07,1,1)) IN ("'",'"','{') then var_07 = strip(substr(var_07 ,2));
	
	array d_5(*) var_01 - var_06;
	array d_6(*) var_len_01 - var_len_06;
	do i_03 = 1 to dim(d_5);
		d_6(i_03) = length(d_5(i_03));
		if d_6(i_03) < 2 then do;
			IF strip(substr(d_5(i_03),1,1)) IN ('',"'",'"','{') then d_5(i_03) = '';
		end;
		else do;
			if strip(substr(d_5(i_03),1,1)) IN ("'",'"','{') then d_5(i_03) = strip(substr(d_5(i_03),2));
		end;
	end; drop i_03;
run;