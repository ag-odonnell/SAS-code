
%macro m06;
    %let path_root=%str(&myfiles_root./OEDA_Prod);
    %let path_oeda_xwalks=%str(&path_root./ODAP/GVDB/dev/data/data_in/ipg_format_cat);
    libname _TESTIN "&path_oeda_xwalks.";
    libname _TESTOUT "&path_root./ODAP/GVDB/dev/data/temp/aago";

    %let fips_FORMAT_CAT_NAME = rtb_gfips_ry25_p03_v10_fmtccw;
    %let zip_FORMAT_CAT_NAME = rtb_gzip_ry25_p03_v10_fmtccw;
    %let fipsfmt=&fips_FORMAT_CAT_NAME.;
    %let zipfmt=&zip_FORMAT_CAT_NAME.;

    options obs=max
            varinitchk=error

            fmtsearch=(/*IPAGFIPS.&fipsfmt.*/
                    /*IPAGZIP.&zipfmt.*/
                    _TESTIN.&fipsfmt.
                    _TESTIN.&zipfmt.);

    /*Print out the values of all Formats in the Catalog*/
    proc format library = _TESTIN.&fips_FORMAT_CAT_NAME. cntlout = _TESTOUT.fips_format_cat_values; quit;

    proc freq data=_TESTOUT.fips_format_cat_values;
        tables fmtname / missing;
    run;

    /*Narrow down the output of "all" to the Format of interest*/
    /*STABBV_STFIPSF */
    /*FIPS_STABBV_D24F */
    /*STSSA_STABBVF */
    /*STSSA_STFIPSF */
    data _TESTOUT.fips_format_cat_values_samp;
    set _TESTOUT.fips_format_cat_values;
    where FMTNAME="FIPS_STABBV_D24F"; /*<--Case-sensitive*/
    run;
%mend m06;
/* %m06; */

%macro m07;
    %let path_root=%str(&myfiles_root./OEDA_Prod);
    %let path_oeda_xwalks=%str(&path_root./ODAP/GVDB/dev/data/data_in/ipg_format_cat);
    libname _TESTIN "&path_oeda_xwalks.";
    libname _TESTOUT "&path_root./ODAP/GVDB/dev/data/temp/aago";

    %let fips_FORMAT_CAT_NAME = rtb_gfips_ry25_p03_v10_fmtccw;
    %let zip_FORMAT_CAT_NAME = rtb_gzip_ry25_p03_v10_fmtccw;
    %let fipsfmt=&fips_FORMAT_CAT_NAME.;
    %let zipfmt=&zip_FORMAT_CAT_NAME.;

    options obs=max
            varinitchk=error

            fmtsearch=(/*IPAGFIPS.&fipsfmt.*/
                    /*IPAGZIP.&zipfmt.*/
                    _TESTIN.&fipsfmt.
                    _TESTIN.&zipfmt.);

    /* Print out the values of all Formats in the Catalog */
    proc format library = _TESTIN.&zip_FORMAT_CAT_NAME. cntlout = _TESTOUT.zip_format_cat_values; quit;

    proc freq data=_TESTOUT.zip_format_cat_values;
        tables fmtname / missing;
    run;

    /*Narrow down the output of "all" to the Format of interest*/
    data _TESTOUT.zip_format_cat_values_samp;
    set _TESTOUT.zip_format_cat_values;
    where FMTNAME="ZIP_SSA_D24F"; /*<--Case-sensitive*/
    run;
%mend m07;
%m07;

/**endProgram */
