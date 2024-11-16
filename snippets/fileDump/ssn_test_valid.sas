


%macro func_valid_ssn(var_in_01=);
	strip_ssn = compress(strip(&var_in_01.));						
	if strip_ssn = '' then value_ssn = 'nullValue';						
	else if strip_ssn = '999999999' then value_ssn = '999999999';
	else if strip_ssn = '888888888' then value_ssn = '888888888';
	else if strip_ssn = '777777777' then value_ssn = '777777777';
	else if strip_ssn = '666666666' then value_ssn = '666666666';
	else if strip_ssn = '555555555' then value_ssn = '555555555';
	else if strip_ssn = '444444444' then value_ssn = '444444444';
	else if strip_ssn = '333333333' then value_ssn = '333333333';
	else if strip_ssn = '222222222' then value_ssn = '222222222';
	else if strip_ssn = '111111111' then value_ssn = '111111111';
	else if strip_ssn = '000000000' then value_ssn = '000000000';
	else if substr(strip_ssn,1,1) = '&' then value_ssn = '&23456789';
	else if substr(strip_ssn,1,1) = '9' then value_ssn = '923456789';
	else if substr(strip_ssn,1,3) = '000' then value_ssn = '000456789';
	else if substr(strip_ssn,1,3) = '666' then value_ssn = '666456789';
	else if substr(strip_ssn,4,2) = '00' then value_ssn = '123006789';
	else if substr(strip_ssn,6,4) = '0000' then value_ssn = '123450000';
	else if length(strip_ssn) < 9 then value_ssn = 'not9Digit';
	else if length(compress(strip_ssn,'','DK')) < 9 then value_ssn = 'charWithin';
	else value_ssn = 'validForm';

	valid_ssn=0;
	if value_ssn = 'validForm' then valid_ssn=1;
	
	drop strip_ssn;
%mend func_valid_ssn;

/*******/

%macro macro_01;
	data aa_lib02.p01_meh_prod_hld_m202302_t01;
		length valid_ssn 8.;
	set aa_lib01.p01_meh_prod_hld_m202302 (
			keep = BENE_ID STATE_CD MSIS_ID MDCD_LINK_ID SSN_TXT CRNT_SW
		);
		%func_valid_ssn(var_in_01=SSN_TXT); /*Function that defines a valid ssn*/
		if valid_ssn = 0 then output;
	run;


	data aa_lib02.p01_meh_prod_hld_m202303_t01;
		length valid_ssn 8.;
	set aa_lib01.p01_meh_prod_hld_m202303 (
			keep = BENE_ID STATE_CD MSIS_ID MDCD_LINK_ID SSN_TXT CRNT_SW
		);
		%func_valid_ssn(var_in_01=SSN_TXT); /*Function that defines a valid ssn*/
		if valid_ssn = 0 then output;
	run;
%mend macro_01;
/*
%macro_01;

/*******/
/* Note: func_valid_hic
/* - The steps below were coded 
/* -- to provide a feel for the characteristics of the HIC_ID
/* -- some are based on observation, others are based on conversation
/*******/

%macro func_valid_hic(var_in_02=);
    strip_hic = compress(strip(&var_in_02.));
    strip_hic_9_digits = substr(strip_hic,1,9);
    if strip_hic_9_digits = '' then value_hic = 'nullValue';
    else if upcase(substr(strip_hic_9_digits,1,1)) in ('{','A','B','C','D','E','F','G','H','I') then value_hic = 'rrbAlpha';
    else if length(compress(strip_hic_9_digits,'','DK')) = 9 then do;
        if strip_hic_9_digits = '999999999' then value_hic = '999999999';
        else if strip_hic_9_digits = '888888888' then value_hic = '888888888';
        else if strip_hic_9_digits = '777777777' then value_hic = '777777777';
        else if strip_hic_9_digits = '666666666' then value_hic = '666666666';
        else if strip_hic_9_digits = '555555555' then value_hic = '555555555';
        else if strip_hic_9_digits = '444444444' then value_hic = '444444444';
        else if strip_hic_9_digits = '333333333' then value_hic = '333333333';
        else if strip_hic_9_digits = '222222222' then value_hic = '222222222';
        else if strip_hic_9_digits = '111111111' then value_hic = '111111111';
        else if strip_hic_9_digits = '000000000' then value_hic = '000000000';
        
        else if substr(strip_hic_9_digits,1,3) = '000' then value_hic = '000456789';
        else if substr(strip_hic_9_digits,1,3) = '666' then value_hic = '666456789';
        else if substr(strip_hic_9_digits,1,3) = '999' then value_hic = '999456789';
        else if substr(strip_hic_9_digits,4,2) = '00' then value_hic = '123006789';
        else if substr(strip_hic_9_digits,6,4) = '0000' then value_hic = '123450000';
        else if substr(strip_hic,10,3) = 'ZZZ' then value_hic = 'bicIn_ZZZ';
        else if substr(strip_hic,11,2) = 'ZZ' then value_hic = 'bicIn_ZZ';
        else value_hic = 'validForm';
    end;
    else if substr(strip_hic,10,3) = 'ZZZ' then value_hic = 'nvBic_ZZZ';
    else if substr(strip_hic,11,2) = 'ZZ' then value_hic = 'nvBic_ZZ';
    else if substr(strip_hic,1,1) = '&' then value_hic = 'ampsFirst';
    else if upcase(substr(strip_hic,1,1)) in ('J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z') then value_hic = 'alphaFirst';
    else if substr(strip_hic,1,1) in ('*','^','~') then value_hic = 'charFirst';
    else value_hic = 'notValid';

	valid_hic=0;
	if (strip(value_hic) in ('validForm','bicIn_ZZZ','bicIn_ZZ')) then valid_hic=1;
	drop strip_hic strip_hic_9_digits;
%mend func_valid_hic;

/*******/
/* Note: func_valid_hic
/* - The steps below were coded 
/* -- to provide a feel for the characteristics of the HIC_ID
/* -- some are based on observation, others are based on conversation
/*******/

%macro func_valid_can(var_in_03=,var_in_04=);
    strip_can = strip(&var_in_03.);
    if strip_can = '' then value_can = 'nullValue';
    else if upcase(substr(strip_can,1,1)) in ('{','A','B','C','D','E','F','G','H','I') then value_can = 'rrbAlpha';
    else if length(compress(strip_can,'','DK')) = 9 then do;
        if strip_can = '999999999' then value_can = '999999999';
        else if strip_can = '888888888' then value_can = '888888888';
        else if strip_can = '777777777' then value_can = '777777777';
        else if strip_can = '666666666' then value_can = '666666666';
        else if strip_can = '555555555' then value_can = '555555555';
        else if strip_can = '444444444' then value_can = '444444444';
        else if strip_can = '333333333' then value_can = '333333333';
        else if strip_can = '222222222' then value_can = '222222222';
        else if strip_can = '111111111' then value_can = '111111111';
        else if strip_can = '000000000' then value_can = '000000000';
        
        else if substr(strip_can,1,3) = '000' then value_can = '000456789';
        else if substr(strip_can,1,3) = '666' then value_can = '666456789';
        else if substr(strip_can,1,3) = '999' then value_can = '999456789';
        else if substr(strip_can,4,2) = '00' then value_can = '123006789';
        else if substr(strip_can,6,4) = '0000' then value_can = '123450000';
        else if &var_in_04. = 'ZZ' then value_can = 'bicIn_ZZ';
        else value_can = 'validForm';
    end;
    else if &var_in_04. = 'ZZ' then value_can = 'nvBic_ZZ';
    else if substr(strip_can,1,1) = '&' then value_can = 'ampsFirst';
    else if upcase(substr(strip_can,1,1)) in ('J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z') then value_can = 'alphaFirst';
    else if substr(strip_can,1,1) in ('*','^','~') then value_can = 'charFirst';
    else value_can = 'notValid';

	valid_can=0;
	if (strip(value_can) in ('validForm','bicIn_ZZ')) then valid_can=1;
	drop strip_can;
%mend func_valid_can;

/*******/

%macro func_valid_gndr(var_in_05=);
    valid_gender=0;
    if upcase(&var_in_05.) in ('M','F','U') then valid_gender=1;
%mend func_valid_gndr;

/*******/
/* Note: 20200326: Agreed on valid birth date after 1800 up to current year.
/*******/

%macro func_valid_dob(var_in_06=);
    %if &ds_in.=m202112 %then %do;
        year_dob = year(datepart(birth_dt));
    %end;
    %else %if &ds_in.=m202201 %then %do;
        year_dob = year(datepart(birth_dt));
    %end;
    %else %do;
        year_dob = year(birth_dt);
    %end;
    valid_dob=0;
    if year_dob > 1799 then do;
        if year_dob < year(today())+1 then valid_dob = 1;
    end;
    drop year_dob;
%mend func_valid_dob;

/*******/

%macro macro_00 (ds_in=);
    %macro macro_01;
        proc sort
            data=aalib01.p01_meh_prod_hld_&ds_in.
            out=aalib02.meh_m01_&ds_in.;
        by MSIS_ID STATE_CD BENE_ID;
        *where CRNT_SW='Y';
        run;
    %mend macro_01;
    %if &run_m01.=1 %then %do; %macro_01; %end;

    /*******/

    %macro macro_02;
        data aalib02.meh_m02_&ds_in.;
        set aalib02.meh_m01_&ds_in.;
        by MSIS_ID STATE_CD BENE_ID;
            array d_1(*) BENE_ID MDCD_LINK_ID MDCR_LINK_ID;
            array d_2(*) bene_cat mdcd_cat mdcr_cat;
            do i = 1 to dim(d_1);
                if d_1(i)=. then d_2(i)=-9;
                else if d_1(i)<0 then d_2(i)=-1;
                else if d_1(i)=0 then d_2(i)=0;
                else d_2(i)=1;
            end;
            drop i;
            %func_valid_ssn(var_in_01=SSN_TXT); /*Function that defines a valid_ssn*/
            %func_valid_gndr(var_in_05=GNDR_CD); /*Function that defines a valid_gender*/
            %func_valid_dob(var_in_06=BIRTH_DT); /*Function that defines a valid_dob*/
            %func_valid_hic(var_in_02=HIC_ID); /*Function that defines a valid_hic*/
            %func_valid_can(var_in_03=CAN_NUM,var_in_04=BIC_CD); /*Function that defines a valid_can*/
            null_ebic=0;
            if strip(EQTBL_BIC_CD)='' then null_ebic=1;
        run;
        proc freq data=aalib02.meh_m02_&ds_in.;
            tables
                BENE_MATCH_CD*bene_cat
                BENE_MATCH_CD*mdcd_cat
                BENE_MATCH_CD*mdcr_cat
                BENE_MATCH_CD*valid_ssn
                BENE_MATCH_CD*valid_gender
                BENE_MATCH_CD*valid_dob
                BENE_MATCH_CD*valid_hic
                BENE_MATCH_CD*valid_can
                / missing nocol norow nopct nocum format=comma15. out=aalib02.meh_m02_freq_&ds_in.;
        run;
    %mend macro_02;
    %if &run_m02.=1 %then %do; %macro_02; %end;

    /*******/

    %macro macro_03(ind_in=);
        proc freq data=aalib02.meh_m02_&ds_in.;
            tables
                BENE_MATCH_CD*&ind_in.
                / missing nocol norow nopct nocum format=comma15. out=aalib02.meh_m03_&ind_in._&ds_in.;
        run;
        proc sort data=aalib02.meh_m03_&ind_in._&ds_in. (drop=percent rename=(count=&ds_in.));
            by BENE_MATCH_CD &ind_in.;
        run;
    %mend macro_03;
    %if &run_m03.=1 %then %do; %macro_03(ind_in=bene_cat); %end;
    %if &run_m03.=1 %then %do; %macro_03(ind_in=mdcd_cat); %end;
    %if &run_m03.=1 %then %do; %macro_03(ind_in=mdcr_cat); %end;
    %if &run_m03.=1 %then %do; %macro_03(ind_in=valid_ssn); %end;
    %if &run_m03.=1 %then %do; %macro_03(ind_in=valid_gender); %end;
    %if &run_m03.=1 %then %do; %macro_03(ind_in=valid_dob); %end;
    %if &run_m03.=1 %then %do; %macro_03(ind_in=valid_hic); %end;
    %if &run_m03.=1 %then %do; %macro_03(ind_in=valid_can); %end;
%mend macro_00;
%macro_00 (ds_in=m202112);
%macro_00 (ds_in=m202201);
%macro_00 (ds_in=m202303);
%macro_00 (ds_in=m202309);

/*******/
/*
From: Lentz, Liz (NE) <Liz.Lentz@GDIT.com>
Sent: Wednesday, March 4, 2020 10:57 AM

SSA Rules:
1.     SSN has 9 characters
2.     SSN has characters 0 – 9 only
3.     Position 1 is not '9'
4.     Positions 1 – 3 are not '000' or '666'
5.     Positions 4 – 5 are not '00'
6.     Positions 6 – 9 are not '0000'
Let me know if you have any questions.

/************************************************************************************;*/

data test_valid_ssn;
	length SSN_TXT value_SSN_TXT $9;
	do i = 1 to 23;
		if i = 1 then SSN_TXT = '123456789';
		else if i = 2 then SSN_TXT = ' 12345678';
		else if i = 3 then SSN_TXT = '&12345678';
		else if i = 4 then SSN_TXT = '912345678';
		else if i = 5 then SSN_TXT = '000123456';
		else if i = 6 then SSN_TXT = '123006789';
		else if i = 7 then SSN_TXT = '123450000';
		else if i = 8 then SSN_TXT = '12345678 ';
		else if i = 9 then SSN_TXT = '  ';
		else if i = 10 then SSN_TXT = '000000000';
		else if i = 11 then SSN_TXT = '111111111';
		else if i = 12 then SSN_TXT = '222222222';
		else if i = 13 then SSN_TXT = '333333333';
		else if i = 14 then SSN_TXT = '444444444';
		else if i = 15 then SSN_TXT = '555555555';
		else if i = 16 then SSN_TXT = '666666666';
		else if i = 17 then SSN_TXT = '777777777';
		else if i = 18 then SSN_TXT = '888888888';
		else if i = 19 then SSN_TXT = '1234 5678';
		else if i = 20 then SSN_TXT = '123aBcD78';
		else if i = 21 then SSN_TXT = '666123456';
		else if i = 22 then SSN_TXT = '1234';
		else SSN_TXT = '999999999';
		
		strip_SSN_TXT = compress(strip(SSN_TXT));
		
		if strip_SSN_TXT = '' then value_SSN_TXT = 'nullValue';
		
		else if strip(SSN_TXT) = '999999999' then value_SSN_TXT = '999999999';
		else if strip(SSN_TXT) = '888888888' then value_SSN_TXT = '888888888';
		else if strip(SSN_TXT) = '777777777' then value_SSN_TXT = '777777777';
		else if strip(SSN_TXT) = '666666666' then value_SSN_TXT = '666666666';
		else if strip(SSN_TXT) = '555555555' then value_SSN_TXT = '555555555';
		else if strip(SSN_TXT) = '444444444' then value_SSN_TXT = '444444444';
		else if strip(SSN_TXT) = '333333333' then value_SSN_TXT = '333333333';
		else if strip(SSN_TXT) = '222222222' then value_SSN_TXT = '222222222';
		else if strip(SSN_TXT) = '111111111' then value_SSN_TXT = '111111111';
		else if strip(SSN_TXT) = '000000000' then value_SSN_TXT = '000000000';
		
		else if substr(strip_SSN_TXT,1,1) = '9' then value_SSN_TXT = '923456789';
		else if substr(strip_SSN_TXT,1,3) = '000' then value_SSN_TXT = '000456789';
		else if substr(strip_SSN_TXT,1,3) = '666' then value_SSN_TXT = '666456789';
		else if substr(strip_SSN_TXT,4,2) = '00' then value_SSN_TXT = '123006789';
		else if substr(strip_SSN_TXT,6,4) = '0000' then value_SSN_TXT = '123450000';
				
		else if length(strip_SSN_TXT) < 9 then value_SSN_TXT = 'not9Digit';
		else if length(compress(strip_SSN_TXT,'','DK')) < 9 then value_SSN_TXT = '1 aBc^& 9';
		
		else value_SSN_TXT = '123456789';
		
		if strip(value_SSN_TXT) = '123456789' then valid_SSN = 1;
		else valid_SSN = 0;
		
		output;
	end;
run;

proc freq data=test_valid_ssn;
tables
	valid_SSN
	value_SSN_TXT
	/ missing norow nocol nocum nopercent format=comma10.;
run;

/************************************************************************************;*/
/* NOte: the frequency output of test_valid_ssn produces the following table
/************************************************************************************;*/
/*
valid_SSN Frequency 
0 22 
1 1 

value_SSN_TXT Frequency 
000000000 1 
000456789 1 
1 aBc^& 9 2 
111111111 1 
123006789 1 
123450000 1 
123456789 1 
222222222 1 
333333333 1 
444444444 1 
555555555 1 
666456789 1 
666666666 1 
777777777 1 
888888888 1 
923456789 1 
999999999 1 
not9Digit 4 
nullValue 1 

/************************************************************************************;*/


 