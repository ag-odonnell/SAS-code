
/***********************************************************************;*/
/* Note: SAS proc compare
/***********************************************************************;*/

%let data_in_path_01 = /sas/…;
%let data_in_path_02 = /sas/…;

libname aa_lib01 "&data_in_path_01.";
libname aa_lib02 "&data_in_path_02.";
/*
options obs = 100;

/***********************************************************************;*/

%let start_year = 2018;
%let end_year = 2018;

/***********************************************************************;*/

%macro m00;
	%do yyyy = &start_year %to &end_year;
		%macro m000(dataset_in_out_01=);
			proc compare
				base = aa_lib01.&dataset_in_out_01.&yyyy.
				compare = aa_lib02.&dataset_in_out_01.&yyyy.
				listall
				maxprint = (10,20000);
			run;
		%mend m000;
		%m000(dataset_in_out_01 = data_set_name_01_);
		%m000(dataset_in_out_01 = data_set_name_02_);
	%end;
%mend m00;
%m00;


/*only comparing particular rows identified by the bene_id */
%macro m01;
	proc compare
		base = mbsf.mbsf_otcc_2023
		compare = in070484.clc_mdcr_summary_2023
		listall
		maxprint = (10,20000);
	where (bene_id in (21,47,211,239));
		var
			acp_medicare
			acp_medicare_ever;
		with
			acp_medicare
			acp_medicare_ever;
	run;
%mend m01;
%m01;

/*using the id statement because the 2 datasets do NOT have the same number of rows */
/*compare particular columns (because var/with statements) */
%macro m02;
    proc compare 
        base = mbsf.mbsf_otcc_2023
        compare = in070484.clc_mdcr_summary_2023
        /* maxprint = (10,25000) */
        noprint;  /* Suppresses detailed difference listings */
        /*listall; conflicts with noprint*/
        id bene_id;
        var
            acp_medicare
            acp_medicare_ever;
        with
            acp_medicare
            acp_medicare_ever;
    run;
%mend m02;
%m02;

/*using the id statement because the 2 datasets do NOT have the same number of rows */
/*compare all columns (because no var/with statements) */
%macro m03;
	proc compare
		base = mbsf.mbsf_otcc_2023
		compare = in070484.clc_mdcr_summary_2023
		noprint;
		*maxprint = (10,25000)
		listall;
		id bene_id; *<=id is used like a by statement;
	run;
%mend m03;
%m03;


%macro m04;
	%let dataset1 = data_set_name_01_;
	%let dataset2 = data_set_name_02_;
	%let yyyy = 2018;

	proc compare
		base = aa_lib01.&dataset1.&yyyy.
		compare = aa_lib02.&dataset1.&yyyy.
		listall
		maxprint = (10,20000);
	where ~((pId='123' and qtr(dateVar)=1) or (pId='A789' and qtr(dateVar) in (3,4)));
	run;
%mend m04;
%m04;

/***********************************************************************;*/
/* Note: Limit numeric comparisons to within .001
/* - as compared to comparing a continuous value 
/* -- versus one rounded to the nearest cents (0.01)
/***********************************************************************;*/

%macro m05;
	proc compare
		base = aa_lib01.&dataset1.&yyyy.
		compare = aa_lib01.&dataset2.&yyyy.
		METHOD = ABSOLUTE
		CRITERION = 0.001
		listall
		maxprint = (10,20000);
	run;
%mend m05;
%m05;

%macro m06;
	proc compare
		base = aa_lib01.&dataset1.&yyyy.
		compare = aa_lib02.&dataset1.&yyyy.
		maxprint = (10,25000)
		listall;
		id var1 var2; *<=id is used like a by statement;
		var var1;
		with var3;
	run;
%mend m06;
%m06;


%macro m07;
	data test1;
		var_01 = 1;
		var_02 = 2;
		var_03 = 3;
		var_04 = 4;
	run;

	data test2;
		var_01 = 1;
		var_02b = 5;
		var_03 = 3;
		var_04 = 4;
	run;
%mend m07;
%m07;

/***********************************************************************;*/
/* NOte: this will only compare the related variables of 2 datasets
/***********************************************************************;*/

%macro m08;
	proc compare
		base = test1
		compare = test2
		listall
		maxprint = (10,20000);
		var
			var_02;
		with
			var_02b;
	run;
%mend m08;
%m08;

/***********************************************************************;*/
/* NOte: this will compare the 4 variables of 2 datasets
/***********************************************************************;*/

%macro m09;
	proc compare
		base = test1
		compare = test2
		listall
		maxprint = (10,20000);
		var
			var_01
			var_02
			var_03
			var_04;
		with
			var_01
			var_02b
			var_03
			var_04;
	run;
%mend m09;
%m09;

/*endProgram */
