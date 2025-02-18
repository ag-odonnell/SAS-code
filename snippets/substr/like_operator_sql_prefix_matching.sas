
/*The LIKE operator with wildcard matching looks for any row with values that start with */

data test_01;
    do bid=1 to 3;
        output;
    end;
run;

data test_02;
    do bid=1 to 5;
        SRVC='AAA';
        if bid=1 then RBCS_ID='D1234';
        else if bid=2 then RBCS_ID='OB123';
        else RBCS_ID='E1234';
        if RBCS_ID IN:('D','OB') then SRVC='DME';
        output;
    end;
run;

proc sql;
    create table test_03 as
    select
        b.*
    from test_01 as a
    left join test_02 as b
    on a.bid=b.bid
    where b.RBCS_ID LIKE 'D%'
        or b.RBCS_ID LIKE 'OB%';
quit;

/*endProgram */
