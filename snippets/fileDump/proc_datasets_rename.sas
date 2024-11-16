
%macro macro_01;
    data delivery_a;
        do bid=1 to 10;
            cid=bid*2;
            output;
        end;
    run;

    proc datasets library = work nolist;
        modify delivery_a (sortedby=bid);
        index create bid / unique;
    quit;

    proc datasets library = work nolist;
        modify delivery_a;
        index delete _all_;
    quit;

    proc datasets library = work;
    change delivery_a=beneficiary_yyyy;
    run;

    proc datasets library = work nolist;
        modify beneficiary_yyyy (sortedby=bid);
        index create bid / unique;
    quit;
%mend macro_01;
%macro_01;/** */

%macro macro_02;
    data delivery_a;
        do bid=1 to 10;
            cid=bid*2;
            output;
        end;
    run;

    data beneficiary_yyyy;
    set delivery_a;
    run;

    proc datasets library = work nolist;
        modify beneficiary_yyyy (sortedby=bid);
        index create bid / unique;
    quit;
%mend macro_02;
%macro_02;/** */

