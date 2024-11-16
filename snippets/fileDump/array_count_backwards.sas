
%let month_start=1;
%let month_end=12;

%let yyyy=2023;

data test_01;
    array d_1 $2 MDCR_STATUS_CODE_01 - MDCR_STATUS_CODE_12;
    do i=1 to 4;
        do j=&month_start. to &month_end.;
            d_1(j)='00';
        end;
        if i=1 then do;
            do j=&month_start. to &month_end.;
                d_1(j)='10';
            end;
        end;
        else if i=2 then do;
            do j=&month_start. to 4;
                d_1(j)='11';
            end;
        end;
        else if i=3 then do;
            do j=&month_start. to 7;
                d_1(j)='20';
            end;
        end;
        else if i=4 then do;
            do j=&month_start. to 11;
                d_1(j)='31';
            end;
        end;
        if i=3 then do;
            MDCR_STATUS_CODE_07='10';
        end;
        output;
    end;
    drop i j;
run;

data test_02;
    length ms_cd $2;
    set test_01;
    array d_1 $2 MDCR_STATUS_CODE_01 - MDCR_STATUS_CODE_12;
    do i_03=&month_end. to &month_start. by -1;
        if ~(d_1(i_03)='00') then do;
            ms_cd=d_1(i_03);
            leave;
        end;
    end;
    drop i_03;
run;

/**endProgram */
