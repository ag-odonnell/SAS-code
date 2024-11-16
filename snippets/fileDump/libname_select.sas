
/************************************************************************************;*/

%let start_year = 2018;
%let end_year = 2019;
%let current_production_year = 2019;
%let current_production_run_month_18 = 0;

/************************************************************************************;*/
/*
options obs = 100;
/************************************************************************************;*/

%let aa_dev_dir_path = /sas/data/dev/month_24;
%let aa_temp_dir_path = /sas/data/temp;

libname aa_dev "&aa_dev_dir_path.";
libname aa_temp "&aa_temp_dir_path.";

/************************************************************************************;*/

%macro macro_01(ds_02=,sort_order=);
	%let dir_path_18mo=;
	%let dir_path_24mo=;
	
	%if &ds_02. = bene_ %then %do;
		%let dir_path_18mo=gvbene18;
		%let dir_path_24mo=gvbene24;
	%end;
	%else %do;
		%let dir_path_18mo=gvclm18;
		%let dir_path_24mo=gvclm24;
	%end;
	
	%do yyyy = &start_year. %to &end_year.;
		%let iter_max = 2;
		%if &yyyy. = &current_production_year. %then %do;
			%if &current_production_run_month_18. = 1 %then %do;
				%let dir_path_18mo=aa_dev;
				%let iter_max = 1;
			%end;
			%else %do;
				%let dir_path_24mo=aa_dev;
				%let iter_max = 2;
			%end;
		%end;
		
		%let iter_start=;
		%if &process_dev_only. = 1 %then %let iter_start=&iter_max.;
		%else %let iter_start = 1;
					   
		%let dir_path_iter=;
		
		%do iter_num = &iter_start. %to &iter_max.;
			%if &iter_num. = 1 %then %let dir_path_iter=&dir_path_18mo.;
			%else %let dir_path_iter=&dir_path_24mo.;
			
			%put ****yyyy: &yyyy. | dir_path_iter: &dir_path_iter.****;
		%end;
	%end;

%mend macro_01;
%macro_01(ds_02=bene_ ,sort_order=BENE_ID);
		
/************************************************************************************;*/
/*endProgram
/************************************************************************************;*/
