
/*(0)*/
%let obs_mode=max; /*run with all obs*/
%let obs_mode=100; /*test with obs=100*/

options obs=&obs_mode.;

/*(00)*/
%let query_limit=%str(inobs=10); /*test with obs=10*/
%let query_limit=%str(inobs=max); /*run with all obs*/

proc sql noprint &query_limit.;
	select *
 	from
  		_snowf.table_name
    ;
quit;

%let yyyy=2020;

/*#1)*/
options obs = 100;

/*#2)*/
data dataset_out_name_&yyyy.;
set dataset_in_name_&yyyy. (obs = 100);
run;

/*#3)*/
data dataset_out_name_&yyyy.;
set dataset_in_name_&yyyy. (firstobs = 1024 obs = 1025);
run;

%let state_mvar_list=%str('TX','CO','NM');

/*#4)*/
proc sql noprint;
connect to oracle (
	user = "&ouser."
	orapw = "&opassp."
	path = "&opathp."
	preserve_comments = yes);
	create table dataset_out_name_&yyyy. as 
	select * from connection to oracle (
		select * from table_in_name
		where
			year_var_01 = &yyyy.
			and state_var_01 in (&state_mvar_list.)
			and rownum < 101 
		order by state_var_01
	); quit; 

/*#5)*/
PROC SQL obs = 100;
	CREATE TABLE dataset_out_name_&yyyy. AS 
	SELECT *
	FROM 
		dataset_in_name_&yyyy.
; QUIT;
