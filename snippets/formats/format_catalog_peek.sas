
%let path_01=OEDA_Prod/Projects/RTB-Reference Tables;
%let path_02=RTB_GZIP-Geography ZIP Crosswalk/RY24-Release Year 2024/Data/Published;
libname _TESTIN "&myfiles_root./&path_01./&path_02.";
libname _TESTOUT "&myfiles_root./OEDA_Prod/ODAP/GVDB/dev/data/temp/aago";
%let FORMAT_CAT_NAME = rtb_gzip_ry24_p03_v10_fmtccw;
%let zipfmt=&FORMAT_CAT_NAME.;

%let dy=22;

options obs=max
		varinitchk=error

		fmtsearch=(/*IPAGFIPS.&fipsfmt.*/
                   /*IPAGZIP.&zipfmt.*/
                   _TESTIN.&zipfmt.);

/*Print out the Formats in the Catalog*/
%macro m01;
	PROC CATALOG CAT = _TESTIN.&FORMAT_CAT_NAME.; CONTENTS; QUIT;
%mend m01;
/*%m01;*/

%macro m02;
	/*Print out the values of all Formats in the Catalog*/
	proc format library = _TESTIN.&FORMAT_CAT_NAME. cntlout = _TESTOUT.format_cat_values; quit;

	/*Narrow down the output of "all" to the Format of interest*/
	data _TESTOUT.format_cat_values;
	set _TESTOUT.format_cat_values;
	where FMTNAME="ZIP_RUCA_DESC_D22F"; /*<--Case-sensitive*/
	run;
%mend m02;
/*%m02;*/

/*Link one of the Formats up to a value that is know to exist in the Format (in this case:Zip Code Value)*/
%macro m03;
	data _TESTOUT.test_01;
		Rndrng_Prvdr_Zip5='83844'; 
		Rndrng_Prvdr_RUCA_Desc=put(Rndrng_Prvdr_Zip5, $zip_ruca_desc_d&dy.f.);
	run;
%mend m03;
/*%m03;*/
