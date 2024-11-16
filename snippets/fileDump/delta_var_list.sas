
%macro macro_01;
	data test_01;
		length
			sort_category $2
			M201911
			M201912
			delta_M201912_M201911
			M202001
			delta_M202001_M201912
			M202002
			delta_M202002_M202001
			min_delta
			mean_delta
			max_delta
			std_delta
			z_score_delta 8.;
		format
			M201911
			M201912
			delta_M201912_M201911
			M202001
			delta_M202001_M201912
			M202002
			delta_M202002_M202001
			min_delta
			mean_delta
			max_delta
			std_delta comma15.0
			z_score_delta comma15.3;
		
		sort_category = '01';
		M201911 = 1001 + 2;
		M201912 = 1001 - 2;
		M202001 = 1001 * 2;
		M202002 = 1001 / 2;
		
		delta_M201912_M201911 = M201912 - M201911;
		delta_M202001_M201912 = M202001 - M201912;
		delta_M202002_M202001 = M202002 - M202001;

		array d_1(*)
			delta_M201912_M201911
			delta_M202001_M201912
			delta_M202002_M202001;
		min_delta = min(of d_1[*]);
		mean_delta = mean(of d_1[*]);
		max_delta = max(of d_1[*]);
		std_delta = std(of d_1[*]);
		z_score_delta = (delta_M202002_M202001 - mean_delta) / std_delta;
	run;
%mend macro_01;
%macro_01


/************************************************************************************;*/
/* Note: Create a macro call
/* - that contains a string equal to the list of delta variables found in the base dataset.
/************************************************************************************;*/

%let macroCall_name_string =;

%macro macro_02;
	proc contents
		data = test_01
		out = test_02 (keep = name)
		short
		noprint;
	run;
	
	proc sort data = test_02;
	by name;
	run;
	
	%let macroCall_length =;
	
	data test_02;
	set test_02;
		where upcase(substr(strip(name),1,5)) = 'DELTA';
		cnt + 1;
		length_name_string = cnt * 22 - 1;
		call symput('macroCall_length', strip(length_name_string));
	run;
	
	%put **** macroCall_length = &macroCall_length. ****;
	%let macroCall_name_string =;
	
	data _null_;
		length name_string $&macroCall_length.;
	set test_02;
		retain name_string;
		if cnt = 1 then name_string = strip(name);
		else name_string = cat(trim(name_string),' ',strip(name));
		verify_length_name_string = length(name_string);
		call symput('macroCall_name_string', strip(name_string));
	run;
	
	%put **** macroCall_name_string = &macroCall_name_string. ****;
%mend macro_02;
%macro_02;

/************************************************************************************;*/

%let dt_base = M202002;
%let dt_updt = M202003;

%macro macro_03;
	data test_03;
		sort_category = '01';
		M202003 = 1004;
	run;

	data test_04;
	merge 
		test_01 (
			drop =
				min_delta
				mean_delta
				max_delta
				std_delta
				z_score_delta)
		test_03;
	by sort_category;
	
		length
			&dt_updt.
			delta_&dt_updt._&dt_base.
			min_delta
			mean_delta
			max_delta
			std_delta
			z_score_delta 8.;
		format
			&dt_updt.
			delta_&dt_updt._&dt_base.
			min_delta
			mean_delta
			max_delta
			std_delta comma15.0
			z_score_delta comma15.3;
			
		delta_&dt_updt._&dt_base. = &dt_updt. - &dt_base.;
	
		array d_1(*) &macroCall_name_string. delta_&dt_updt._&dt_base.;
		min_delta = min(of d_1[*]);
		mean_delta = mean(of d_1[*]);
		max_delta = max(of d_1[*]);
		std_delta = std(of d_1[*]);
		z_score_delta = (delta_&dt_updt._&dt_base. - mean_delta) / std_delta;
	run;
%mend macro_03;
%macro_03;
