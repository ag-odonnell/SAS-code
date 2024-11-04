%let cdate1=%sysfunc(mdy(10,1,2023));
%put &cdate1;

data test_01;
    date=23284;
    format date date9.;
run;
