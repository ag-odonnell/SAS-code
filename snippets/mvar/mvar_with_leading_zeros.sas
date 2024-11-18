%include "https://github.com/ag-odonnell/SAS-code/blob/462fe19b123882cc31a6bb06b0e3e256938b9214/snippets/formats/sas_format_zwd.sas";

/**startBuildProgram */
/**create clm_val_amt is actually stored as numeric with leading zeros */
%macro m01_build_ps;
    data test_01;
        do i=1 to 10;
            i2=sum(.2, -i/100);
            if i<3 then do; clm_val_amt=put(i2,z13.2); clm_val_cd='A'; end;
            else if i<7 then do; clm_val_amt=put(i2,z13.2); clm_val_cd='B'; end;
            else if i<8 then do; clm_val_amt=put(i2,z13.2); clm_val_cd='C'; end;
            else clm_val_cd='D';
            output;
        end;
    run;
    /*summarize the numeric version of clm_val_amt*/
    proc sql;
        create table test_02 as
        select 
            clm_val_cd,
            count(input(clm_val_amt, best32.)) as clm_val_amt_n, /* Count numeric values */
            sum(input(clm_val_amt, best32.)) as clm_val_amt_sum, /* Sum numeric values */
            mean(input(clm_val_amt, best32.)) as clm_val_amt_mean, /* Mean of numeric values */
            std(input(clm_val_amt, best32.)) as clm_val_amt_stdev /* Standard deviation of numeric values */
        from 
            test_01
        where not missing(clm_val_amt) /* Exclude missing values */
        group by 
            clm_val_cd;
    quit;
%mend m01_build_ps;
%m01_build_ps;

/**endBuildProgram */
