
%let switch_m01=1;
%let switch_m02=1;
%let switch_m03=1;

%let path_root=%str(&myfiles_root./OEDA_Prod);
%let path_oeda_xwalks=%str(&path_root./ODAP/GVDB/dev/data/build/geography/oeda_xwalks);
%let path_temp=%str(&path_root./ODAP/GVDB/dev/data/temp/aago);
libname _TESTIN "&path_oeda_xwalks.";
libname _TESTOUT "&path_root./ODAP/GVDB/dev/data/temp/aago";

%let FORMAT_CAT_NAME = rtb_gzip_ry24_p03_v10_fmtccw;
%let zipfmt=&FORMAT_CAT_NAME.;

%let dy=22;

options obs=max
		varinitchk=error

		fmtsearch=(/*IPAGFIPS.&fipsfmt.*/
                   /*IPAGZIP.&zipfmt.*/
                   _TESTIN.&zipfmt.);

%macro m00;
    /*Print out the Formats in the Catalog*/
    %macro m01;
        PROC CATALOG CAT = _TESTIN.&FORMAT_CAT_NAME.; CONTENTS; QUIT;
    %mend m01;
    %if &switch_m01.=1 %then %do; %m01; %end;

    %macro m02;
        /*Print out the values of all Formats in the Catalog*/
        proc format library = _TESTIN.&FORMAT_CAT_NAME. cntlout = _TESTOUT.format_cat_values; quit;

        /*Narrow down the output of "all" to the Format of interest*/
        data _TESTOUT.format_cat_values;
        set _TESTOUT.format_cat_values;
        where FMTNAME="ZIP_RUCA_DESC_D22F"; /*<--Case-sensitive*/
        run;
    %mend m02;
    %if &switch_m02.=1 %then %do; %m02; %end;

    /*Link one of the Formats up to a value that is know to exist in the Format (in this case:Zip Code Value)*/
    %macro m03;
        data _TESTOUT.test_01;
            Rndrng_Prvdr_Zip5='83844'; 
            Rndrng_Prvdr_RUCA_Desc=put(Rndrng_Prvdr_Zip5, $zip_ruca_desc_d&dy.f.);
        run;
    %mend m03;
    %if &switch_m03.=1 %then %do; %m03; %end;
%mend m00;
%m00;

/*endProgram */
