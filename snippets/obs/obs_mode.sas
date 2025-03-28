
/*Switch: ON/OFF | 1/0*/
/*Test process with obs=100 */
%let switch_test=0;

%let obs_mode=;
%let query_limit=;
%macro general_switch_decisions;
  /*This is a limiter to SAS syntax, links and dataset availability*/
  %let obs_mode=%str(max);
  %if &switch_test.=1 %then %do;
    %let obs_mode=%str(100);
  %end;
  /*This is a limiter to TEST SNOWFLAKE CONNECTIVITY*/
  %if &switch_test_query.=1 %then %do;
    %let query_limit=%str(inobs=10);
  %end;
%mend general_switch_decisions;
%general_switch_decisions;

/*IF GRID PROCESS*/
%syslput obs_mode=&obs_mode;

/*the actual SAS dataset obs_mode application*/
options
  user=out
  obs=&obs_mode.;

/*the obs_mode application to SNOWFLAKE table*/
proc sql noprint &query_limit.;
    create table dataset_out_name as
    select
      *
    from
        _snowf.table_name_t f
    where
      some_condition=1
    ;
quit;

/*endProgram*/
