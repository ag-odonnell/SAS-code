%LET TDATE = %SYSFUNC(PUTN(%SYSFUNC(TODAY()), YYMMDDN8.));
%put ****TDATE: &TDATE.****;
%LET TDATE = 20240518; *this was written in November. So, override with date that contains leading zero in month;
%put ****TDATE: &TDATE.****;

%let data_end_month=%substr(&TDATE,1,4)%eval(%substr(&TDATE,5,2)-1);
%put ****data_end_month: &data_end_month.****;

%let data_end_month=%substr(&TDATE,1,4)%sysfunc(putn(%eval(%substr(&TDATE,5,2)-1), z2.));
%put ****data_end_month: &data_end_month.****;

%let input_yyyy=rbcs_taxonomy_20241004;
%if %substr(&input_yyyy,15,4)<2024 %then %do;
    %put ****THE DATE IS BEFORE****;
%end;
%else %do;
    %put ****THE DATE IS EQUAL TO OR AFTER****;
%end;
