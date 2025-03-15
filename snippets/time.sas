
%let start_time=%sysfunc(datetime());
%put ****START TIME: %sysfunc(datetime(),datetime14.)****;
%put ****START TIME: %sysfunc(datetime(),datetime20.3)****;

  %macro m01;
    %put ****THIS SHOULD TAKE NO TIME***;
  %mend m01;
  %m01;

%put ****END TIME: %sysfunc(datetime(),datetime14.)****;
%put ****END TIME: %sysfunc(datetime(),datetime20.3)****;

%let end_time=%sysfunc(datetime());
%let run_time=%sysfunc(ceil(%sysevalf(&end_time. - &start_time.)));

%put ****start_time_fmt = %sysfunc(putn(&start_time, datetime14.))****;
%put ****end_time_fmt = %sysfunc(putn(&end_time, datetime14.))****;
%put ****SAS running time: %sysfunc(putn(&run_time.,time8.)) (HH:MM:SS)****;

/*endProgram*/
