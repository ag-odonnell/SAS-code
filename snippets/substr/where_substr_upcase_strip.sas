
data test_01;
    do i=1 to 6;
        if i=1 then HCPCS_CD='    ';
        else if i=2 then HCPCS_CD='AA1';
        else if i=3 then HCPCS_CD='';
        else if i=4 then HCPCS_CD='wW1';
        else if i=5 then HCPCS_CD='WW1';
        else if i=6 then HCPCS_CD=' wW1';
        output;
    end;
run;

data test_02;
    set test_01;
    if length(strip(HCPCS_CD))>1 then do;
        if substr(upcase(strip(HCPCS_CD)), 1, 2) = 'WW' then output;
    end;
run;

data test_03;
    set test_01;
    where substr(upcase(strip(HCPCS_CD)), 1, 2) = 'WW';
run;

/*endProgram */
