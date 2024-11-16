
%let aa_dir_path_02 = data/support/temp;
%let aa_dir_path_04 = data/support/archive;

libname aa_lib02 "&aa_dir_path_02.";
libname aa_lib04 "&aa_dir_path_04.";


%let ds_02=NRH_HLD_M;
%let cyear_num= 2021;
%let cmonth_num= 9;
proc contents
	data = aa_lib04.&ds_02.&cyear_num.%eval(&cmonth_num-1)_contents
	out = aa_lib02.&ds_02.&cyear_num.%eval(&cmonth_num-1)_01 (
		keep =
			libname
			memname
			name)
	short
	noprint;
run;

%let process_iter_start_num_mvar = 1;
%put ****process_iter_start_num_mvar before derivation : &process_iter_start_num_mvar.****;

data aa_lib02.&ds_02.&cyear_num.%eval(&cmonth_num-1)_02;
*data _null_;
set aa_lib02.&ds_02.&cyear_num.%eval(&cmonth_num-1)_01;
	if upcase(substr(name,1,6)) = 'COUNT_' then do; /*variable name ex. 'count_17'*/
		derive_process_iter = compress(name,'','kd'); /*keep only digits*/
		call symput('process_iter_start_num_mvar', strip(derive_process_iter));
		output;
	end;
run;

%put ****process_iter_start_num_mvar before derivation : &process_iter_start_num_mvar.****;


