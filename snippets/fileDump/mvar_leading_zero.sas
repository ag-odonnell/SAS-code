
%let INPUT_START_YEAR = 2023;
%let INPUT_START_MONTH = 01;
%let INPUT_END_YEAR = 2024;
%let INPUT_END_MONTH = 08; /*<==Adjust each run - Most recent month of data (enter as 2-digit number);*/
%let month_current_prod_data = M&INPUT_END_YEAR.&INPUT_END_MONTH.;

%macro macro_01;
    %do mm = &START_MO. %to &END_MO.;
        %put ****&mm.****;
        %let xmm=%sysfunc(putn(%mm,z2.));
        %put ****&xmm.****;
        /* x "%LOWCASE(&file_transfer_command) &root_gvdb_data_out_path./%LOWCASE(ptb_inst_revenue_&yyyy.&xmm.).sas7b* &libref_path_archive_02."; */
    %end;
%mend macro_01;
%macro_01;


%macro macro_02;
    %LET TDATE = %SYSFUNC(PUTN(%SYSFUNC(TODAY()),YYMMDDN8.));
    %PUT ****TDATE: &TDATE.****;
    %let data_end_month=M%SUBSTR(&TDATE,1,4)%SYSFUNC(PUTN(%EVAL(%SUBSTR(&TDATE,5,2)-1),z2.))
    %PUT ****data_end_month: &data_end_month.****;
%mend macro_02;
%macro_02;