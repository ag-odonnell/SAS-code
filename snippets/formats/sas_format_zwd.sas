
%include "https://github.com/ag-odonnell/SAS-code/blob/7af4a5ada7a9c4ee163f370fe5e1712c430d7b86/snippets/mvar/mvar_with_leading_zeros.sas";

data test_01;
    var_01=1;
    var_02=2;
    var_03=3;
    format var_01 mmddyy10. var_02 date9.;
    var_04=put(var_03, Z6.);
    var_05=put(var_03, Z6.1);
    var_06=put(var_03, Z6.2);
    var_07=put(var_03, Z6.3);
    var_08=put(var_03, Z6.4);
run;
