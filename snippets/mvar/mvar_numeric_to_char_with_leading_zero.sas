
%LET numeric_digit=7;
%LET character_digit=%sysfunc(putn(&numeric_digit.,z2.));
%put ****&=numeric_digit****;
%put ****&=character_digit****;
