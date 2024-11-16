
/************************************************************************************;*/

%let dir_path_data_01 = /sas/data/data_in;
%let dir_path_data_02 = /sas/temp;

libname aa_lib01 "&dir_path_data_01.";
libname aa_lib02 "&dir_path_data_02.";

%macro EXTRACT_FINDER_FILE_INFO();
	libname  &ouser oracle user = "&ouser." orapw = "&opassp." path = "&opathp." schema="aod228";

	data aa_lib02.test_finder_01;
		do i = 1 to 2;
			if i = 1 then TABLE_NAME_FACT_KEY_ID = 1234;
			else TABLE_NAME_FACT_KEY_ID = 5678;
			output;
		end; drop i;
	run;
	
	proc delete data = &ouser..test_finder_01; run;
	
	data &ouser..test_finder_01;
	set aa_lib02.test_finder_01;
	run;

	proc sql noprint;
		connect to oracle (
			USER = "&ouser."
			ORAPW = "&opassp."
			PATH = "&opathp.,BUFFSIZE=5000"
			PRESERVE_COMMENTS = YES);
		create TABLE aa_lib01.test_link_tmsis_monthly_fact_00 as
			select * from connection to oracle
				(select /*+ parallel */
					H.CREAT_TS
					,H.TABLE_NAME_FACT_KEY_ID
					,F.VAR_ID AS RENAME_VAR_ID
					,H.TABLE_NAME_DIM_KEY_ID
				FROM
					TABLE_OWNER.TABLE_NAME_FACT    H
					,TABLE_OWNER.TABLE_NAME_DIM	F
					,&ouser..test_finder_01				FF
				WHERE
					FF.TABLE_NAME_FACT_KEY_ID = H.TABLE_NAME_FACT_KEY_ID
					AND H.TABLE_NAME_DIM_KEY_ID = f.TABLE_NAME_DIM_KEY_ID
				);
		disconnect from oracle;
	QUIT;
%mend EXTRACT_FINDER_FILE_INFO;
%EXTRACT_FINDER_FILE_INFO;

/************************************************************************************;*/
/* Note: Baseline result | 20210505
/************************************************************************************;*/

/************************************************************************************;*/
/*endProgram
/************************************************************************************;*/
