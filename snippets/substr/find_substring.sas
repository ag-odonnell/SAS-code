data have;
    do i=1 to 6;
        if i<2 then var='ABCD';
        else if i<3 then var='abcd';
        else if i<4 then var='Bcde';
        else if i<5 then var='MNbC';
        else if i<6 then var='becf';
        else if i<7 then var='fcbe';
        output;
    end;
run;

data want;
    set have;
    where find(upcase(var), 'BC');
run;
