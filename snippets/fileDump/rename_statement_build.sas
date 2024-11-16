
/************************************************************************************;*/
/* Note:
/************************************************************************************;*/

%let date_char = 07042021abc;

%let var_csv_in_f1_char_2016cy =
	CITY
	CMS_CONTRACT_NUMBER
	FIRST_NAME;
	
%let var_temp_f1_char_2016cy =
	char_var_1 $22
	char_var_2 $5
	char_var_3 $17;

%let var_sas_out_f1_char_2016cy =
	CITY $22
	CMS_CONTRACT_NUMBER $5
	FIRST_NAME $17;

%let var_csv_in_f1_num_2016cy =
	AAP_D_20_44
	AAP_D_45_64;
	
%let vnc=;
%let vnc=%sysfunc(countw(&var_csv_in_f1_char_2016cy.));
%put ****vnc: &vnc.****;

%let vnn=;
%let vnn=%sysfunc(countw(&var_csv_in_f1_num_2016cy.));
%put ****vnn: &vnn.****;
	
	data test_01;
	CITY = 'Supercalif';
	CMS_CONTRACT_NUMBER = '012345';
	FIRST_NAME = 'ABC';
	BIRTH_DATE = "&date_char.";
	AAP_D_20_44 = '1234';
	AAP_D_45_64 = '567';
	run;
	
	data test_01;
		length &var_temp_f1_char_2016cy. num_var_1 - num_var_&vnn. 8.;
	set test_01;
		array d_1(*) &var_csv_in_f1_char_2016cy.;
		array d_2(*) char_var_1 - char_var_&vnc.;
		array d_3(*) &var_csv_in_f1_num_2016cy.;
		array d_4(*) num_var_1 - num_var_&vnn.;
		
		do i_01 = 1 to dim(d_1);
			d_2(i_01) = strip(d_1(i_01));
		end; drop i_01 &var_csv_in_f1_char_2016cy;
		
		transform_BIRTH_DATE = compress(strip(BIRTH_DATE),'','AP');
		if length(transform_BIRTH_DATE) = 8 then do;
			m_num = input(substr(transform_BIRTH_DATE,1,2),2.);
			if 0 < input(substr(transform_BIRTH_DATE,1,2),2.) < 13 then do;
				if 0 < input(substr(transform_BIRTH_DATE,3,2),2.) < 32 then do;
					if 1581 < input(substr(transform_BIRTH_DATE,5,4),4.) < 9999 then do;
						BIRTH_DATE_num = mdy(
							input(substr(transform_BIRTH_DATE,1,2),2.)
							,input(substr(transform_BIRTH_DATE,3,2),2.)
							,input(substr(transform_BIRTH_DATE,5,4),4.));
						*BIRTH_DATE_num = mdy(07,03,1960);
					end;
				end;
			end;
		end;
		format BIRTH_DATE_num yymmdd8.;
		
		do i_02 = 1 to dim(d_3);
			d_4(i_02) = input(strip(d_3(i_02)),12.);
		end; drop i_02 &var_csv_in_f1_num_2016cy;
		
	run;
	
	
	data test_01;
		length &var_sas_out_f1_char_2016cy. BIRTH_DATE 8. &var_csv_in_f1_num_2016cy. 8.;
	set test_01(drop = BIRTH_DATE transform_BIRTH_DATE m_num);
		array d_1(*) &var_csv_in_f1_char_2016cy.;
		array d_2(*) char_var_1 - char_var_&vnc.;
		array d_3(*) &var_csv_in_f1_num_2016cy.;
		array d_4(*) num_var_1 - num_var_&vnn.;
		
		do i_01 = 1 to dim(d_1);
			d_1(i_01) = d_2(i_01);
		end; drop i_01 char_var_1 - char_var_&vnc.;
		
		BIRTH_DATE = BIRTH_DATE_num;
		format BIRTH_DATE yymmdd8.; 
		drop BIRTH_DATE_num;
		
		do i_02 = 1 to dim(d_3);
			d_3(i_02) = d_4(i_02);
		end; drop i_02 num_var_1 - num_var_&vnn.;
	run;

/************************************************************************************;*/
/*endProgram
/************************************************************************************;*/
