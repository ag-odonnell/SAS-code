
%let CYEAR = 2016;
%let PRELIM = 2017 2018;
%let FINAL = ;*2017 2018;

%macro macro_01;
    %IF %INDEX(&PRELIM &FINAL,&CYEAR) > 0 %THEN %DO;
        %PUT ****LOOKS LIKE WE HAVE A MATCH****;
    %END;
	%ELSE %PUT ****NOMATCH****;;
%mend macro_01;
/*
%macro_01;

/*******/

%macro macro_02;
    /*Note: Initialize values to null for CYEAR before 2017 */
    %LET SCD_END_MVAR_01=;
    %LET SCD_END_MVAR_02=;
    %IF %INDEX(&PRELIM &FINAL,&CYEAR) > 0 %THEN %DO;
        %IF &CYEAR > 2016 %THEN %DO;
            /*The following midyear process is different than final*/
            %IF %INDEX(&PRELIM,&CYEAR) > 0 %THEN %DO;
                %IF %INDEX(&CYEAR,2017) > 0 %THEN %DO;
                    /*Note: If processing midyear (month_18) then SCD_MEDICARE is NOT available in CYEAR = 2017*/
                    %LET SCD_END_MVAR_01=;
                    /*Note: create a the output variable SCD_END and set all values equal to null */
                    %LET SCD_END_MVAR_02=%STR(SCD_END = .);
                %END;
                %ELSE %DO;
                    /*Note: midyear, everything after 2017 contains SCD_MEDICARE*/
                    %LET SCD_END_MVAR_01=%STR(SCD_MEDICARE = SCD_END);
                %END;
            %END;
            /*Note: final, everything after 2016 contains SCD_MEDICARE*/
            %ELSE %DO;
                %LET SCD_END_MVAR_01=%STR(SCD_MEDICARE = SCD_END);
            %END;
        %END;
    %END;
    %PUT ****CYEAR: &CYEAR.****;
    %PUT ****PRELIM: &PRELIM.****;
    %PUT ****FINAL: &FINAL.****;
    %PUT ****SCD_END_MVAR_01: &SCD_END_MVAR_01.****;
    %PUT ****SCD_END_MVAR_02: &SCD_END_MVAR_02.****;
%mend macro_02;
%macro_02;

/*******/
/*endProgram
/*******/
