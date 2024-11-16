
data test_01;
    var_01='s1';
    mark=0;
    if var_01 in ('s1', 's2') then mark=1;
run;


%let step=s1;
data test_01;
    var_01=1;
    mark=0;
    %if %index(s1 s2, &step)>0 %then %do; mark=1; %end;
run;



%let step=s3;
data test_01;
    var_01=1;
    mark=0;
    %if %SYSFUNC(indexW(s1 s2, &step))  %then %do; mark=1; %end;
run;


