

data test_01;
    var_01='ABC12 3DEF456GHI789 !@#0';
    VAR_02=compress(var_01,'','kd');
    VAR_03=compress(compress(var_01,'','kd'));
    length VAR_04 VAR_05 4.;
    VAR_04=input(compress(substr(var_01,5,1),'','kd'),1.);
    VAR_05=input(compress(substr(var_01,3,1),'','kd'),1.);
    if input(substr(var_01,4,1),1.)>. then flag_01=1;
    if VAR_04>. then flag_02=1;
    if VAR_05>. then flag_03=1;
    /*where I stand today, EQUAL_NUMERIC is the BEST solution to identifying numbers in a string*/
    EQUAL_NUMERIC= (input(compress(substr(var_01,4,1),'','kd'),1.)>.);
    if EQUAL_NUMERIC then flag_04=1;
run;

