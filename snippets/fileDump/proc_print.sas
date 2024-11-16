
/************************************************************************************;*/
/* Note: ASSIGN SOME LIB_REFs
/************************************************************************************;*/

%let aa_dev_dir_path = /sas/data/.../dev;
%let aa_temp_dir_path = /sas/data/.../temp;
%let aa_log_dir_path = /sas/data/.../logs;

libname aa_dev "&aa_dev_dir_path.";
libname aa_temp "&aa_temp_dir_path.";

/************************************************************************************;*/
/* Note: DERIVE TODAY's DATE 
/************************************************************************************;*/

%LET TDATE = %SYSFUNC(PUTN(%SYSFUNC(TODAY()),YYMMDDN8.));

/************************************************************************************;*/

%macro macro_00(ds_01=,ds_02=,sort_order=);
	PROC PRINTTO 
		NEW 
		LOG = "&aa_log_dir_path./a_base_name_for_the_log_&ds_02.char_values_&TDATE..txt"; 
	RUN;
	
	/************************************************************************************;*/
	/* Note: The ONLY intent of the code below is to guide placement of the PROC PRINTTO function
	/************************************************************************************;*/
	
	data &ds_01.;
		do i = 1 to 100;
			count = i;
			var_id_01 = 'a';
			if mod(i,2) then var_id_02 = 'b';
			else var_id_02 = 'c';
			if mod(i,3) then var_id_03 = 'd';
			else var_id_03 = 'e';
			output;
		end; drop i;
	run;
	
	proc sort data = &ds_01. out = &ds_02.;
	by &sort_order.;
	run;
	
	/************************************************************************************;*/
	
%mend macro_00;
*%macro_00(ds_01=a_long_name ,ds_02=aln_ ,sort_order=var_id_01 var_id_02);
*%macro_00(ds_01=another_long_name ,ds_02=anln_ ,sort_order=var_id_01 var_id_02 var_id_03);

/************************************************************************************;*/
/* Note: CLOSE STORED COMPILED MACRO CATALOG (SAS FUNCTION)  
/************************************************************************************;*/

%SYSMSTORECLEAR;

/************************************************************************************;*/
/* Note: ROUTE LOG TO DEFAULT DESTINATION
/************************************************************************************;*/

PROC PRINTTO; RUN;

/************************************************************************************;*/
/*endProgram
/************************************************************************************;*/
