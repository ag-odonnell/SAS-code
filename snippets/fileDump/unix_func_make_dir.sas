
%macro makeDir;
    %let END_YR=2024;
    %let END_MO=08; /*<==Adjust each run*/
    %let month_current_prod_data=M&END_YR.&END_MO.;
    
    %let root_odap_path=/pd_data/shares/oedaprod/ODAP;
    %let root_gvdb_path=&root_odap_path./GVDB;
    %let root_gvdb_dev_path=&root_gvdb_path./dev;
    %let root_gvdb_temp_path=&root_gvdb_dev_path./data/temp;

    %else %if &switch_month_18.=1 %then %do;
        %let runout=month_18;
        %let libref_path_archive_01=&root_gvdb_temp_path./&runout./%UPCASE(&month_current_prod_data.);
    %end;
    /**First check to see if new libref exists - If no, then mkdir (make directory) */
    %if %sysfunc(fileexist(&libref_path_archive_01.))=0 %then %do;
        x "%LOWCASE(mkdir) &libref_path_archive_01.; %LOWCASE(y);";
    %end;
%mend makeDir;
%makeDir;

%macro makeDir;
    /**Check to see if file to be moved is in the archive/destination libref - if yes, then do nothing */
    %if %sysfunc(fileexist(&libref_path_move_clm./%LOWCASE(pta_claim_&yyyy.).sas7b*))=0 %then %do;
        /**if the exists in the build location, then move to the production location */
        %if %sysfunc(fileexist(&libref_path_data_out./%LOWCASE(pta_claim_&yyyy.).sas7b*))=1 %then %do;
            x "%LOWCASE(&file_transfer_command) &libref_path_data_out./%LOWCASE(pta_claim_&yyyy.).sas7b* &libref_path_move_clm.";
            x "%LOWCASE(&file_transfer_command) &libref_path_data_out./%LOWCASE(pta_revenue_&yyyy.).sas7b* &libref_path_move_clm.";
        %end;
    %end;
%mend makeDir;
%makeDir;

/**endProgram */