
%let bgn_time=%sysfunc(datetime());  
%put START TIME: %sysfunc(datetime(),datetime14.);
  %macro m01;
    /**/
  %mend m01;
  %m01;
%let end_time=%sysfunc(datetime());
%let run_time=%sysfunc(ceil(%sysevalf(&end_time. - &bgn_time.)));
%put SAS running time: %sysfunc(putn(&run_time.,time8.)) (HH:MM:SS);

/*endProgram*/
