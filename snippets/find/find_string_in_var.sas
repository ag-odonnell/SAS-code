%macro scan_dataset_var(want=, have=);
    %let string=brain;
    data _temp.&have._out;
        set _temp.&have.;
        if find(_start, "&string.", 'i') > 0 then &string._start = 1;
        else &string._start = 0;
        if find(label, "&string.", 'i') > 0 then &string._label = 1;
        else &string._label = 0;
    run;
    proc freq data=_temp.&have._out; 
        tables &string._start &string._label / missing;
        title "&have.";
    run;
    title '';
%mend scan_dataset_var;
%scan_dataset_var(want=, have=fmt_p11_hh);
%scan_dataset_var(want=, have=fmt_p13_ir);
%scan_dataset_var(want=, have=fmt_p14_sn);

%let string=brain;
%macro scan_dataset_var(want=, have=);
    data _temp.&string.;
        set _temp.fmt_p13_ir;
        where find(label, "&string.", 'i') > 0;
    run;
%mend scan_dataset_var;
%scan_dataset_var(want=&string., have=fmt_p13_ir);

%let string=brain;
data _temp.&string.;
    set _temp.fmt_p13_ir;
    where find(label, "&string.", 'i') > 0;
run;
