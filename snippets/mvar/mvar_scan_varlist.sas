
%let stratify_sum_var_01=%str(
    ACTUAL_PMT
    ALLOWED_AMT
    B_COINS
    B_DED
    CHRG_AMT
    CLM_ALLOWED_AMT
    CLM_CHRG_AMT
    CLM_PMT
    CLM_PRVDR_PMT
    IP_LOW_VOL_PMT_AMT
    NCH_PRMRY_PYR_CLM_PD_AMT
    NONCVRD_CHRG_AMT
    STANDARD_CLM_PMT
    STANDARD_PMT
    VISITS
    );

%macro m06b_sum_by_rbcs_subcat_vars(varlist=);
    %let i=1;  /* Initialize counter for variable list */
    %put ****BEFORE SCAN: &=varlist****;
    %let var=%scan(&varlist., &i., %str( ));  /* Get first variable from list */
    %put ****BEFORE WHILE LOOP: &=i****;
    %put ****BEFORE WHILE LOOP: &=var****;
    %do %while(&var. ne );  /* Loop through all variables in varlist */
        /*sum(&var.) as sum_&var.  /* Create sum for each variable */
        %let i=%eval(&i.+1);  /* Increment counter */
        %put ****INSIDE WHILE LOOP: &=i****;
        %let var=%scan(&varlist., &i., %str( ));  /* Get next variable */
        /*%if &var. ne %then %do; , %end;  /* Add comma if more variables exist */
        %put ****INSIDE WHILE LOOP: &=var****;
    %end;
    %put ****AFTER WHILE LOOP: &=var****;
%mend m06b_sum_by_rbcs_subcat_vars;
%m06b_sum_by_rbcs_subcat_vars(varlist=&stratify_sum_var_01.);
