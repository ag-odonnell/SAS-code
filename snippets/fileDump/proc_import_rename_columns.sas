
/*https://communities.sas.com/t5/SAS-Procedures/rename-the-column-attributes-from-the-first-row-values/td-p/55302*/
data have;
input (ABC F1 F2 FDG)($);
cards;
ID Name Sex Country
1 ABC M IND
2 BCD F USA
3 CDE M GER
4 DGE M UK
;

proc transpose data=have(obs=1) out=temp;
var _all_;
run;

proc sql ;
   select catx('=',_name_,col1)
     into :rename separated by ' '
        from temp;
quit;

data want;
  set have(firstobs=2 rename=(&rename));
run;

proc print;run;

/************************************************************************************;*/
/* Note: Enhanced PROC IMPORT read-in of <.csv> file
/* - Work around | enhancement
/* -- read the cloumn names as the first row of data
/* ---- then rename the auto-generated columns names to the first row of data
/************************************************************************************;*/

%let dir_path_hedis_data_02 = /data/libs/dev/data/temp;
libname aa_lib02 "&dir_path_hedis_data_02.";

options obs = 8;
%let rename =;
PROC IMPORT
	OUT = aa_lib02.data_out_000
	DATAFILE = "&dir_path_data_01./&source_csv_file_1_name_and_dir..csv" 
	DBMS = csv
	REPLACE;
	GETNAMES = no;
	*DATAROW = 2; 
RUN;

/************************************************************************************;*/
/* Note: Capture 1 row and output into a transposed dataset
/************************************************************************************;*/

proc transpose data=aa_lib02.&ds_out_02._000(obs=1) out=aa_lib02.&ds_out_02._0000;
var _all_;
run;

/************************************************************************************;*/
/* Note: assign the mvar "rename"
/* - into a series that includes the to and from of all variable names
/************************************************************************************;*/

proc sql ;
   select catx('=',_name_,col1)
	 into :rename separated by ' '
		from aa_lib02.&ds_out_02._0000;
quit;

/************************************************************************************;*/
/* Note: rename the auto-generated variables names to the "true" variable names
/************************************************************************************;*/

data aa_lib02.&ds_out_02._00;
 set aa_lib02.&ds_out_02._000(firstobs=2 rename=(&rename));
run;

/************************************************************************************;*/
/*endProgram
/************************************************************************************;*/
