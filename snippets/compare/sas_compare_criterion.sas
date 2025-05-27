
%macro m01;
    %do CYEAR=&start_year. %to &end_year.;
        proc compare
            base = aa_lib01.&dataset1.&CYEAR.
            compare = aa_lib01.&dataset2.&CYEAR.
            METHOD = ABSOLUTE
            CRITERION = 0.001
            listall
            maxprint = (10,20000);
            id var_01;
        run;
    %end;
%mend m01;
%m01;
