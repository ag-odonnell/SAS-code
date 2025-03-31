
%let path_root=%str(&myfiles_root./OEDA_Prod);
%let path_oeda_xwalks=%str(&path_root./ODAP/GVDB/dev/data/build/geography/oeda_xwalks);
libname _TESTIN "&path_oeda_xwalks.";
libname _TESTOUT "&path_root./ODAP/GVDB/dev/data/temp/aago";

%let fips_FORMAT_CAT_NAME = rtb_gfips_ry24_p03_v10_fmtccw;
%let zip_FORMAT_CAT_NAME = rtb_gzip_ry24_p03_v10_fmtccw;
%let fipsfmt=&fips_FORMAT_CAT_NAME.;
%let zipfmt=&zip_FORMAT_CAT_NAME.;

%let dy=22;

options obs=max
		varinitchk=error

		fmtsearch=(/*IPAGFIPS.&fipsfmt.*/
                   /*IPAGZIP.&zipfmt.*/
                   _TESTIN.&fipsfmt.
                   _TESTIN.&zipfmt.);

data _TESTOUT.mup_inp_ry24_p04_v10_dy&dy._prvb;
    do i=1 to 4;
        if i=1 then do; facility_zip_code='36301'; facility_state_code='AL'; end;
        else if i=2 then do; facility_zip_code='80631'; facility_state_code='CO'; end;
        else if i=3 then do; facility_zip_code='50316'; facility_state_code='IA'; end;
        else if i=4 then do; facility_zip_code='79936'; facility_state_code='TX'; end;
        output;
    end;
run;

data _TESTOUT.test_01;
    set _TESTOUT.mup_inp_ry24_p04_v10_dy&dy._prvb;
    Rndrng_Prvdr_State_FIPS=put(facility_state_code, $STABBV_STFIPSF.);
    Rndrng_Prvdr_RUCA=put(facility_zip_code, $zip_ruca_d&dy.f.);
    Rndrng_Prvdr_RUCA_Desc=put(facility_zip_code, $zip_ruca_desc_d&dy.f.);
run;

/**endProgram */
