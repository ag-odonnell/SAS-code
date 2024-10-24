
%LET libref_path_01=/source/data/path/;
%LET libref_path_02=/temp/data/path/;
%LET libref_path_03=/output/data/path/;

libname aalib01 "&libref_path_01.";
libname aalib02 "&libref_path_02.";
libname aalib03 "&libref_path_03.";

PROC IMPORT 
    OUT = aalib02.name_temp_data
    DATAFILE = "&libref_path_01./name_of_csv.csv"
    DBMS = csv
    REPLACE;
    GETNAMES = YES;
    *DATAROW = 2;
RUN;

data aalib03.name_final_data;
    length
        var_01 $5
        var_02 8.
        var_03 8.;
    set aalib02.name_temp_data;
    if var_01~='ZZZZZ' then output;
    Label
        var_01='var_01'
        var_02='var_02'
        var_03='var_03';
    Format
        var_01 $CHAR5.
        var_02 mmddyy10.
        var_03 4.;
run;
