
%let path_root=%str(&myfiles_root./OEDA_Prod);
%let path_oeda_xwalks=%str(&path_root./ODAP/GVDB/dev/data/build/geography/oeda_xwalks);
libname _TESTIN "&path_oeda_xwalks.";
libname _TESTOUT "&path_root./ODAP/GVDB/dev/data/temp/aago";

options obs=max
		varinitchk=error

		fmtsearch=(/*IPAGFIPS.&fipsfmt.*/
                   /*IPAGZIP.&zipfmt.*/
                   _TESTIN.&fipsfmt.
                   _TESTIN.&zipfmt.);

%let fips_FORMAT_CAT_NAME = rtb_gfips_ry24_p03_v10_fmtccw;
%let zip_FORMAT_CAT_NAME = rtb_gzip_ry24_p03_v10_fmtccw;
%let fipsfmt=&fips_FORMAT_CAT_NAME.;
%let zipfmt=&zip_FORMAT_CAT_NAME.;

/*Print out the values of all Formats in the Catalog*/
proc format library = _TESTIN.&fips_FORMAT_CAT_NAME. cntlout = _TESTOUT.fips_format_cat_values; quit;

/*Narrow down the output of "all" to the Format of interest*/
data _TESTOUT.format_cat_values;
set _TESTOUT.format_cat_values;
where FMTNAME="STABBV_STFIPSF"; /*<--Case-sensitive*/
run;

/**endProgram */
