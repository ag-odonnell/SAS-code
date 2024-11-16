
/*******/
/* Note: PRIMARY PARAMETERS  
/*******/

%macro macro_primary_parms;
    %let INPUT_START_MONTH=1; /*monthly integer - no leading zeros*/
    %let INPUT_START_YEAR=2024; /*probably only update this 4-digit value once per year (i.e., when year no longer receives updates...)*/
    %let INPUT_END_MONTH=2; /*monthly integer - no leading zeros*/
    %let INPUT_END_YEAR=2024; /*probably only update this 4-digit value once per year (i.e., when new year of info becomes available...)*/

    %let run_p01a_ptaf_extract=0;
%mend macro_primary_parms;
%macro_primary_parms;

/*******/
/* Note: SECONDARY PARAMETERS  
/*******/

%macro macro_secondary_parms;
    %let aalib01_path=%str(/pd_data/data/test/data_in);
    %let aalib02_path=%str(/pd_data/data/test/temp);
    %let aalib03_path=%str(/pd_data/data/test/data_out);
    %let aalib04_path=%str(/pd_data/data/test/archive);
    %let log_path=%str(/pd_data/data/test/logs);
    %let include_path=%str(/pd_data/data/dev/pgms/includes);
    
    libname aalib01 "&aalib01_path.";
    libname aalib02 "&aalib02_path.";
    libname aalib03 "&aalib03_path.";
    libname aalib04 "&aalib04_path.";

    %LET TDATE = %SYSFUNC(PUTN(%SYSFUNC(TODAY()),YYMMDDN8.));

    %LET task_compile_macro_switch_01=0;

    options pagesize=MAX compress=binary sumsize=MAX nofmterr mprint mlogic symbolgen;
    options metauser="&ouser." metapass="&opassp.";

    %let chg_queue=queue=support_users;
    %let rc=%sysfunc(grdsvc_enable(_ALL_, resource=sasCCW%str(;) jobopts=chg_queue));
%mend macro_secondary_parms;
%macro_secondary_parms;

/*******/
/* Note: SETUP SNOWFLAKE  
/*******/

%MACRO MACRO_SNOWFLAKE_SETUP;
	%let dua=###;
	libname _snowfl sasiosnf server="###...privatelink.snowflakecomputing.com"
	uid=&ouser. pwd="&opassp." preserve_tab_names=no role=dua_&dua._&ouser. warehouse=dua_&dua. database=### schema=###
	    readbuff=10000 insertbuff=10000 dbcommit=10000 bulkload=yes bl_compress=yes bl_num_read_threads=10 bl_internal_stage="user/&ouser.";

	options user=aalib03 mlogic mprint symbolgen;
%MEND MACRO_SNOWFLAKE_SETUP;
%MACRO_SNOWFLAKE_SETUP;

/*******/
/* Note: CONVERT SIMPLE INPUT DATES TO DATES THAT ARE ACCEPTABLE PROC SQL OF SNOWFLAKE
/*******/
/*DERIVE SNOWFLAKE COMPILE DATES*/
/*ALSO use to set CMONTH in a couple of situations */
%LET CDATE1=;
%LET CDATE2=;
%MACRO MACRO_CDATE;
	%LET CMONTH=;
    %IF &CYEAR<&END_YR %THEN %DO;
        %LET CMONTH=12;
    %END;
    %ELSE %DO;
        %LET CMONTH=&END_MO;
    %END;

    /**Now simply derive DATE MVARS that will be used during the SNOWFLAKE QUERY processes */
	%LET CDATE1 = %STR(%')%SYSFUNC(PUTN(%SYSFUNC(MDY(1,1,&CYEAR)),DATE9.))%STR(%');/*first day of CYEAR*/
	%LET CDATE2 = %STR(%')%SYSFUNC(PUTN(%SYSFUNC(INTNX(MONTH,"%SYSFUNC(PUTN(%SYSFUNC(MDY(&CMONTH,1,&CYEAR)),DATE9.))"D,0,E)),DATE9.))%STR(%');/*<==last day of CMONTH*/
%MEND MACRO_CDATE;
%MACRO_CDATE;

/*******/
/* Note: COMPILE MACRO to EXTRACT DATA FROM SNOWFLAKE TABLE 
/*******/

%macro query_macro(START_YR=,START_MO=,END_YR=,END_MO=);

	PROC PRINTTO 
		NEW
		LOG = "&log_path./create_test_log_M&END_YR.&END_MO._&TDATE..txt";
	RUN;

	%LET CMONTH =;
    %LET CYEAR = &START_YR;

	%DO %UNTIL(&CYEAR > &END_YR);
        /* %INCLUDE "&include_path./assign_libname.inc"; /*I turned off (commented out) this include, because its actions are written above, but keep for your reference of how to use*/

        proc sql;
            create table aalib01.ntl_claims_&CYEAR. as select
                T.CLM_ID,
                T.CLM_PMT_AMT,
                P.PRVDR_NUM,
                A.NCH_CLM_TYPE_CD,
                I.CLAIM_QUERY_CODE
            from 
                _snowfl.main_Table t,
                _snowfl.another_table_01 a,
                _snowfl.another_table_02 p,
                _snowfl.another_table_03 i

            where
                t.clm_type_id=a.clm_type_id
                and t.prvdr_at_time_of_clm_id=p.prvdr_id
                and t.isohh_clm_fields_id=i.isohh_clm_fields_id
                and t.clm_thru_dt between "&CDATE1."d AND "&CDATE2."d
                and a.nch_clm_type_cd in ('10','20','30','40','50','60')
                /*and nvl(t.old_finl_actn_id,29) ~= -1*/
                and coalesce(t.old_finl_actn_id,29) ~= -1
            ;
        quit;
        %LET CYEAR = %EVAL(&CYEAR + 1);
    %END;
%mend query_macro;

/*******/
/* Note: EXECUTE query_macro macro if run_p01a_ptaf_extract switch is turned on (i.e.., set equal to "1")
/*******/

/**execute the below once the table update finished, usually the first week of each month;*/
%macro macro_00;
	%if &run_p01a_ptaf_extract.=1 %then %do;
		%query_macro(
        	START_YR=&INPUT_START_YEAR
			,START_MO=%SYSFUNC(PUTN(&INPUT_START_MONTH,8.))
			,END_YR=&INPUT_END_YEAR
			,END_MO=%SYSFUNC(PUTN(&INPUT_END_MONTH,8.))
		);
	%end;
%mend macro_00;
%macro_00;

/*******/
/* Note: CLOSE STORED COMPILED MACRO CATALOG (SAS FUNCTION)  
/*******/

%SYSMSTORECLEAR;

/*******/
/* Note: ROUTE LOG TO DEFAULT DESTINATION
/*******/

PROC PRINTTO; RUN;

/*******/
/**endProgram
/*******/
