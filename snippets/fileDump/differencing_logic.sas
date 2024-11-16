
data test_01;
	do i = 1 to 36;
		var_num_01 = i;
		output;
	end;
run;

proc timeseries
	data=test_01
	plot=series;
	id i interval=month;
	var var_num_01;
run;

proc sgplot
	data=test_01;
	scatter x=i y=var_num_01;
run;

/************************************************************************************;*/
/* Note: logic to prepare for manual lag(12) differencing
/************************************************************************************;*/

data test_02;
set test_01;
	length temp_01 - temp_12 8.;
	retain temp_01 - temp_12;
	if _n_ = 1 then temp_01 = var_num_01;
	else if _n_ = 2 then temp_02 = var_num_01;
	else if _n_ = 3 then temp_03 = var_num_01;
	else if _n_ = 4 then temp_04 = var_num_01;
	else if _n_ = 5 then temp_05 = var_num_01;
	else if _n_ = 6 then temp_06 = var_num_01;
	else if _n_ = 7 then temp_07 = var_num_01;
	else if _n_ = 8 then temp_08 = var_num_01;
	else if _n_ = 9 then temp_09 = var_num_01;
	else if _n_ = 10 then temp_10 = var_num_01;
	else if _n_ = 11 then temp_11 = var_num_01;
	else if _n_ = 12 then temp_12 = var_num_01;
	else do;
		if ~(mod((_n_-1),12)) then temp_01 = var_num_01;
		if ~(mod((_n_-2),12)) then temp_02 = var_num_01;
		if ~(mod((_n_-3),12)) then temp_03 = var_num_01;
		if ~(mod((_n_-4),12)) then temp_04 = var_num_01;
		if ~(mod((_n_-5),12)) then temp_05 = var_num_01;
		if ~(mod((_n_-6),12)) then temp_06 = var_num_01;
		if ~(mod((_n_-7),12)) then temp_07 = var_num_01;
		if ~(mod((_n_-8),12)) then temp_08 = var_num_01;
		if ~(mod((_n_-9),12)) then temp_09 = var_num_01;
		if ~(mod((_n_-10),12)) then temp_10 = var_num_01;
		if ~(mod((_n_-11),12)) then temp_11 = var_num_01;
		if ~(mod((_n_-12),12)) then temp_12 = var_num_01;
	end;
run;

/************************************************************************************;*/
/* Note: applied differencing logic to create lag(1) and lag(12) values
/************************************************************************************;*/

data test_03;
set test_01 (keep = i var_num_01);
	length var_num_01 delta_01 temp_delta_01 delta_12 temp_01 - temp_12 8.;
	retain temp_delta_01 temp_01 - temp_12;
	if _n_ = 1 then do;
		delta_01 = .;
		delta_12 = .;
		temp_delta_01 = var_num_01;
	end;
	else do;
		delta_01 = var_num_01 - temp_delta_01;
		temp_delta_01 = var_num_01;
	end;
	if _n_ = 1 then temp_01 = var_num_01;
	else if _n_ = 2 then temp_02 = var_num_01;
	else if _n_ = 3 then temp_03 = var_num_01;
	else if _n_ = 4 then temp_04 = var_num_01;
	else if _n_ = 5 then temp_05 = var_num_01;
	else if _n_ = 6 then temp_06 = var_num_01;
	else if _n_ = 7 then temp_07 = var_num_01;
	else if _n_ = 8 then temp_08 = var_num_01;
	else if _n_ = 9 then temp_09 = var_num_01;
	else if _n_ = 10 then temp_10 = var_num_01;
	else if _n_ = 11 then temp_11 = var_num_01;
	else if _n_ = 12 then temp_12 = var_num_01;
	else do;
		if ~(mod((_n_-1),12)) then do; delta_12 = var_num_01 - temp_01; temp_01 = var_num_01; end;
		if ~(mod((_n_-2),12)) then do; delta_12 = var_num_01 - temp_02; temp_02 = var_num_01; end;
		if ~(mod((_n_-3),12)) then do; delta_12 = var_num_01 - temp_03; temp_03 = var_num_01; end;
		if ~(mod((_n_-4),12)) then do; delta_12 = var_num_01 - temp_04; temp_04 = var_num_01; end;
		if ~(mod((_n_-5),12)) then do; delta_12 = var_num_01 - temp_05; temp_05 = var_num_01; end;
		if ~(mod((_n_-6),12)) then do; delta_12 = var_num_01 - temp_06; temp_06 = var_num_01; end;
		if ~(mod((_n_-7),12)) then do; delta_12 = var_num_01 - temp_07; temp_07 = var_num_01; end;
		if ~(mod((_n_-8),12)) then do; delta_12 = var_num_01 - temp_08; temp_08 = var_num_01; end;
		if ~(mod((_n_-9),12)) then do; delta_12 = var_num_01 - temp_09; temp_09 = var_num_01; end;
		if ~(mod((_n_-10),12)) then do; delta_12 = var_num_01 - temp_10; temp_10 = var_num_01; end;
		if ~(mod((_n_-11),12)) then do; delta_12 = var_num_01 - temp_11; temp_11 = var_num_01; end;
		if ~(mod((_n_-12),12)) then do; delta_12 = var_num_01 - temp_12; temp_12 = var_num_01; end;
	end;
run;

/************************************************************************************;*/

proc sgplot
	data=test_03;
	scatter x=i y=delta_01;
run;

proc sgplot
	data=test_03;
	scatter x=i y=delta_12;
run;

/************************************************************************************;*/
/*endProgram
/************************************************************************************;*/
