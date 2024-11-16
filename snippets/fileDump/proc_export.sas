
%let switch_run_m01 = 1;

%macro macro_00;
	%macro macro_01;
		/*export long and wide datasets to excel .xlsx*/
		%macro macro_01a(ds_in=, sheet_name=);
			proc export 
				data=aalib04.ptbni_&runout_id.&ds_in.&start_year._&end_year.
				dbms=xlsx
				outfile="&aa_gvalid_libref_01./gvdb_&end_year._&runout_id._v5e_ptbni_&date_ext_xlsx_output..xlsx"
				replace;
				sheet="&sheet_name.";
			run;
		%mend macro_01a;
		%macro_01a(ds_in=_long_, sheet_name=count_long);
		%macro_01a(ds_in=_delta_, sheet_name=delta_wide);
	%mend macro_01;
	%if &switch_run_m01. = 1 %then %do; %macro_01; %end;
%mend macro_00;
%macro_00;


/************************************************************************************;*/

%let ds_in_name = test_;
%let ds_out_name = test_csv_output_;
%let yyyy = 2020;
%let tdate = %SYSFUNC(PUTN(%SYSFUNC(TODAY()),YYMMDDN8.));
%let libref_path_01 =/sas/.../data_out;

/************************************************************************************;*/

data &ds_in_name.&yyyy.;
	ref_yr = &yyyy.;
	do i = 1 to 20;
		var_01 = put(i,3.);
		if i < 10 then var_02 = strip(compress((cat('0',var_01))));
		else var_02 = strip(var_01);
		output;
	end;
run;

/************************************************************************************;*/
/* Note:
/* - to view the leading zeros created in test_ dataset, 
/* -- must right click the output data and select "Open with" => "Notepad"
/************************************************************************************;*/

proc export
	data = &ds_in_name.&yyyy.
	/*outfile = "&libref_path_01./&ds_out_name.&yyyy._&tdate..csv"*/
	outfile = "&ds_out_name.&yyyy._&tdate..csv" /*send to desktop work C:\Users\aod228*/
	dbms =
		csv
		replace;
run;

/************************************************************************************;*/
/*endProgram
/************************************************************************************;*/

