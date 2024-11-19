%let switch_run_on_linux=1; /*If testing on sasCCW: 1/0: ON/OFF switch */
%let switch_run_on_local=0; /*If testing on local: 1/0: ON/OFF switch */

/**Note: using command line in linux, access the directory with spaces as follows*/
/**(using "\" to escape spaces (i.e., to indicate that spaces are a part of the name))*/
/**cd /dev/data/temp/test\ directory\ with\ spaces */

%macro m00;
    %let file=test 01; /**test 01 (with space in name) vs test_01 - both work*/
    %let dbms=xls; /**xls vs xlsx - both work */

    %macro run_on_linux;
        %let libref_path_01=/dev/data/temp/test directory with spaces;
        libname out24 "&libref_path_01.";
        proc import
            file="&libref_path_01./&file..&dbms."
            out=out24.test_01
            dbms=&dbms.
            replace;
            range="test_01$A1:A4";
        run;

        proc export
            data=out24.test_01
            outfile="&libref_path_01./test_out_%sysfunc(date(),yymmdd10.).&dbms."
            dbms=&dbms.
            replace;
        run;
    %mend run_on_linux;
    %if &switch_run_on_linux.=1 %then %do; %run_on_linux; %end;

    %macro run_on_local;
        %let libref_path_01=U:\dev\data\temp\test directory with spaces;
        libname out24 "&libref_path_01.";

        proc import
            file="&libref_path_01.\&file..&dbms."
            out=out24.test_01
            dbms=&dbms.
            replace;
            range="test_01$A1:A4";
        run;

        proc export
            data=out24.test_01
            outfile="&libref_path_01.\test_out_%sysfunc(date(),yymmdd10.).&dbms."
            dbms=&dbms.
            replace;
        run;
    %mend run_on_local;
    %if &switch_run_on_local.=1 %then %do; %run_on_local; %end;
%mend m00;
%m00;

/**endProgram */
