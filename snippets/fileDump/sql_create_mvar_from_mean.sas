proc sql;
    select avg(HCC_SCORE_YR) into:op_score
    from gv_temp.bene_hcc
    where FFS_MA_POPN=1;
quit;



