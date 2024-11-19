%let cdate1=%sysfunc(mdy(10,1,2023));
%let cdate2=;
%let cdate3=;

data test_01;
    date_01=&cdate1.;
    date_03=23284;
    format date_01 date_03 date9.;
    call symput('cdate2', strip(put(date_01,date9.)));
    call symput('cdate3', strip(put(date_03,date9.)));
run;

%put ****cdate1:&cdate1****;
%put ****cdate2:&cdate2****;
%put ****cdate3:&cdate3****;
