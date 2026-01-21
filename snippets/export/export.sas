
%let cy=07; *current CY;

%let N_root=%str(&myfiles_root./OEDA_Prod/ODAP/DEV/aago/rbcs/N);
%let YEAR_root=%str(Project/50915_CCW_BETOS/MA1/05 Option Years 2-5/01 BETOS/02 Contract Year &cy.);
%let taxonomyfile=%str(&N_root./&YEAR_root./00 Reference Materials/RBCS 2025 Taxonomy Final V01 11-12-2025.xlsx); *taxonomy file from prior CY;
%let taxonomysheet=RBCS Taxonomy; *taxonomy sheet from taxonomy file;
%let datasheet=RBCS Data; *RBCS data sheet from prior CY;

%put ****&=taxonomyfile****;

filename taxout "&taxonomyfile.";

%macro m01(ds_in=, ds_out=);
    data &ds_out.;
        set &ds_in.;
        by HCPCS_CD FIRST_RBCS_RELEASE_YEAR;
        if last.HCPCS_CD then output;
    run;
%mend m01;
%m01(ds_in=PUF.RBCS_TAXONOMY_20251112, ds_out=rbcs_data_unique_hcpcs);

%macro m02(ds_in=, sheetname=);
    proc export
        data=&ds_in.
        outfile=taxout
        dbms=xlsx
        replace;
        sheet="&sheetname.";
    run;
%mend m02;
%m02(ds_in=PUF.RBCS_TAXONOMY_20251112, sheetname=&taxonomysheet.);
%m02(ds_in=rbcs_data_unique_hcpcs, sheetname=&datasheet.);
