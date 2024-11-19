%let run_m01=1;
%let run_on_network_switch=0;
%let file_name=RBCS_2023;

%macro macro_00;
    %macro macro_01;

        %let libref_root=/pd_data/shares/oedaprod/ODAP/;
        %let divider_slash=/;
        %if &run_on_network_switch.=1 %then %do;
            %let libref_root=U:\DUA_070484\_Shared\ODAP\;
            %let divider_slash=\;
        %end;

        %LET libref_path_in=&libref_root.RBCS&divider_slash.data&divider_slash.src&divider_slash.;
        %LET libref_path_out=&libref_root.RBCS&divider_slash.data&divider_slash.data_in;

        libname aalib03 "&libref_path_out.";

        proc import
            out = aalib03.&file_name.
            datafile = "&libref_path_in.&file_name..csv"
            dbms = csv
            replace;
            getnames = YES;
            *datarow = 2;
        RUN;

    %mend macro_01;
    %if &run_m01.=1 %then %do; %macro_01; %end;
%mend macro_00;
%macro_00;

/**endProgram */
