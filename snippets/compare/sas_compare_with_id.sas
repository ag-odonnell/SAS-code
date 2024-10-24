%let start_year=2024;
%let end_year=2024;

%let def_libref_01=/deployment/path/new/;
%let def_libref_03=/validation/path/;

libname aalib01 "&def_libref_01.";
libname aalib03 "&def_libref_03.";

%macro macro_00;
    %macro macro_01;
        %do CYEAR=&start_year. %to &end_year.;
            proc sort data=aalib01.production_data_20241023;
                by var_01 var_02 var_03;
            run;

            proc compare 
                base=aalib01.production_data_20241023
                compare=aalib03.validation_data_20241023
                maxprint=(10,25000)
                listall;
                *id var_01 var_02 var_03;
            run;
        %end;
    %mend macro_01;
    %macro_01;
%mend macro_00;

%macro_00;
