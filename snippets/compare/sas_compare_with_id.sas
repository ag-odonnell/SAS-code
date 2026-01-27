
%let start_year=2024;
%let end_year=2024;

%let def_source_path=%str(/deployment/path/new/);
%let def_target_path=%str(/validation/path/);

libname _source "&def_source_path.";
libname _target "&def_target_path.";

%macro m00;
    %macro m01;
        %do CYEAR=&start_year. %to &end_year.;
            proc sort data=_source.production_data_20241023;
                by var_01 var_02 var_03;
            run;

            proc compare 
                base=_source.production_data_20241023
                compare=_target.validation_data_20241023
                maxprint=(10,25000)
                listall;
                *id var_01 var_02 var_03;
            run;
        %end;
    %mend m01;
    %m01;
%mend m00;
%m00;
