
/*The IN: operator is a variabion of the IN operator that performs PREFIX MATCHING*/

data test_01;
    do i=1 to 3;
        SRVC='AAA';
        if i=1 then RBCS_ID='D1234';
        else if i=2 then RBCS_ID='OB123';
        else RBCS_ID='E1234';
        if RBCS_ID IN:('D','OB') then SRVC='DME';
        output;
    end;
run;

/*endProgram*/
