
data test_01;
	MID = 1;
	SID = 1;
	do i = 1 to 10;
		if i < 3 then BID = 2;
		else if i < 7 then BID = 4;
		else BID = i;
		output;
	end;
run;

data test_02;
set test_01;
by MID SID BID;
	retain cnt_mid_sid;
	if first.SID then cnt_mid_sid = 0;
		cnt_mid_sid + 1;
	if last.SID then output;
run;

data test_03;
set test_01;
by MID SID BID;
	retain cnt_unique_mid_sid_bid temp_BID;
	if first.SID then do;
		cnt_unique_mid_sid_bid = 1;
		temp_BID = BID;
	end;
		if temp_BID ~= BID then cnt_unique_mid_sid_bid + 1;
		temp_BID = BID;
	if last.SID then output;
run;

/************************************************************************************;*/
/************************************************************************************;*/

data test_01;
	do i = 1 to 10;
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

%let m_sum_var_flag_01_0_count=;
%let m_sum_var_flag_01_1_count=;

data test_02;
set test_01;
	retain
		sum_var_flag_01_0_count
		sum_var_flag_01_1_count;
	if var_flag_01 = '0' then do;
		sum_var_flag_01_0_count + var_num_01;
		call symput('m_sum_var_flag_01_0_count', strip(sum_var_flag_01_0_count));
	end;
	else if var_flag_01 = '1' then do;
		sum_var_flag_01_1_count + var_num_01;
		call symput('m_sum_var_flag_01_1_count', strip(sum_var_flag_01_1_count));
	end;
run;

%put**** m_sum_var_flag_01_0_count: &m_sum_var_flag_01_0_count. ****;
%put**** m_sum_var_flag_01_1_count: &m_sum_var_flag_01_1_count. ****;

data test_03;
set test_01;
	if var_flag_01 = '0' then pct_flag_01_0 = var_num_01 / &m_sum_var_flag_01_0_count.;
	else if var_flag_01 = '1' then pct_flag_01_1 = var_num_01 / &m_sum_var_flag_01_1_count.;
	format
		pct_flag_01_0
		pct_flag_01_1 percent8.2;
run;

/************************************************************************************;*/
/* Note: Notice that mvar_out_01 and mvar_out_02 do the same thing in different ways
/************************************************************************************;*/

%macro macro_04(ds_out =,mvar_out_01=,mvar_out_02=);
	data &ds_out.;
		var_num_02 = &mvar_out_01.;
		var_num_03 = &&&mvar_out_02.;
	run;
%mend;
%macro_04 (
	ds_out = test_04
	,mvar_out_01 = &m_sum_var_flag_01_0_count.
	,mvar_out_02 = m_sum_var_flag_01_0_count);
%macro_04 (
	ds_out = test_05
	,mvar_out_01 = &m_sum_var_flag_01_1_count.
	,mvar_out_02 = m_sum_var_flag_01_1_count);
	
data test_06;
set
	test_04
	test_05;
run;
proc datasets library = work nolist;
	delete
		test_04
		test_05
; quit;

/************************************************************************************;*/
/*endProgram
/************************************************************************************;*/
