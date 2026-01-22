
%LET numeric_digit=7;
%LET character_number=%sysfunc(putn(&numeric_digit.,z2.));
%put ****&=numeric_digit****;
%put ****&=character_number****;

%macro m00;
    %do month_num=11 %to 12;
        %put "/some/libref/path/M2025%sysfunc(putn(&month_num.,z2.))/";
        data test_&month_num.;
            month_num_01=&month_num.;
            month_num_02=put(&month_num.,z2.);
        run;
    %end;
%mend m00;
%m00;
