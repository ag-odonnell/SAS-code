
%let spatht=test123;
%let spathp=test456;
%macro macro_000(src_server=);
    data test_01;
        var_01="&&&src_server.";
    run;
%mend macro_000;
%macro_000(src_server=spatht); /** */
%macro_000(src_server=spathp); /** */

/*******/
/*endProgram
/*******/
