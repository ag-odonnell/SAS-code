
%let cy=07; *current CY;
%let N_root=%str(&myfiles_root./some/path);
%let YEAR_root=%str(another/path/with/Data Year &cy.);
%let taxonomyfile=%str(&N_root./&YEAR_root./additional/path/LONG NAME with Spaces V01 01-20-2026.xlsx); *a note;

%put ****&=taxonomyfile****;

filename taxinput "&taxonomyfile.";

%macro m01(ds_in=);
    proc export
        data=&ds_in.
        outfile=taxinput
        dbms=xlsx
        replace;
        sheet="&ds_in.";
    run;
%mend m01;
%m01(ds_in=LIBNAME.FILE_NAME);
