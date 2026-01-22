
%LET numeric_digit=7;
%LET character_number=%sysfunc(putn(&numeric_digit.,z2.));
%put ****&=numeric_digit****;
%put ****&=character_number****;

%macro m00;
    %do month_num=11 %to 12;
        %put "/some/libref/path/M2025%sysfunc(putn(&month_num.,z2.))/";
    %end;
%mend m00;
%m00;
