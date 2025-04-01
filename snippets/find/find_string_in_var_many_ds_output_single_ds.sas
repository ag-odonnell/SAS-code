%macro output_single_dataset;
    %let string=brain;
    data _temp.&string.;
        length dataset_name $32 _start $201 label $201;
        stop;
    run;
    %macro scan_dataset_var(want=, have=);
        data _temp.&string.;
            set
                _temp.&string. (in=a)
                _temp.&have. (in=b
                    rename=(_start=_start_in label=label_in));
            
            if b then dataset_name="&have.";
            _start=_start_in;
            label=label_in;
            drop
                _start_in
                label_in;

            if b then do;
                if find(_start, "&string.", 'i') > 0 then &string._start = 1;
                else &string._start = 0;
                if find(label, "&string.", 'i') > 0 then &string._label = 1;
                else &string._label = 0;
            end;
        run;
    %mend scan_dataset_var;
    %scan_dataset_var(want=, have=fmt_p11_hh);
    %scan_dataset_var(want=, have=fmt_p12_hs);
    %scan_dataset_var(want=, have=fmt_p13_ir);
    %scan_dataset_var(want=, have=fmt_p14_sn);
    %scan_dataset_var(want=, have=fmt_p15_sn1);
    %scan_dataset_var(want=, have=fmt_p15_sn2);

    proc freq data=_temp.&string.; 
        tables
            dataset_name*&string._start
            dataset_name*&string._label
            / missing nocol nocum norow nopct format=comma15.;
        title "_temp.&string.";
    run;
    title '';
%mend output_single_dataset;
%output_single_dataset;
