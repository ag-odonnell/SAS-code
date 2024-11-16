
/************************************************************************************;*/

%let start_year = 2020;
%let start_month = 04;
%let end_year = 2021;
%let end_month = 03;

/************************************************************************************;*/
/* Note: %eval(&start_month-1+1) condition
/* - first iteration in do loop does not scrub off leading zero of cmonth
/************************************************************************************;*/

%macro macro_01;
	%let cmonth=%eval(&start_month-1+1);
	%let cyear=&start_year;
	%let process_iter=0;
	%do %until(%sysfunc(mdy(&cmonth,1,&cyear)) > %sysfunc(mdy(&end_month,1,&end_year)));

		/********************************************;*/
		
		%let process_iter=%eval(&process_iter+1);
		
		%put ****process_iter: &process_iter. | cyear: &cyear. | cmonth: &cmonth.****;
		
		/********************************************;*/
		
		%do sub_iter_01 = 1 %to 2;
			%if &cmonth. = 1 %then %do;
				%let cyear_num = %eval(&cyear-1);
				%let cmonth_num = 12;
			%end;
			%else %do;
				%let cyear_num = &cyear.;
				%let cmonth_num = %eval(&cmonth-1);
			%end;
			%if &sub_iter_01. = 2 %then %do;
				%let cyear_num = &cyear.;
				%let cmonth_num = &cmonth;
			%end;
			%put ****sub_iter_01: &sub_iter_01. | cyear_num: &cyear_num. | cmonth_num: &cmonth_num.****;
			
			/************************;*/
			/* DO SOMETHING HERE...*/
			/************************;*/
		%end;
		
		/********************************************;*/
		
		%let cmonth = %eval(&cmonth + 1);
		%if &cmonth > 12 %then %do;
			%let cmonth = 1;
			%let cyear = %eval(&cyear + 1);
		%end;
	%end;
%mend macro_01;
%macro_01;

/************************************************************************************;*/
/*endProgram*/
/************************************************************************************;*/
/************************************************************************************;*/



/************************************************************************************;*/
/************************************************************************************;*/
/* Note: The following code adds the complication of leading zeros
/************************************************************************************;*/

%let start_year = 2020;
%let start_month = 04;
%let end_year = 2021;
%let end_month = 03;

/************************************************************************************;*/
/* Note: %eval(&start_month-1+1) condition
/* - first iteration in do loop does not scrub off leading zero of cmonth
/************************************************************************************;*/

%macro macro_02;
	%let cmonth=%eval(&start_month-1+1);
	%let cyear=&start_year;
	%let process_iter=0;
	%do %until(%sysfunc(mdy(&cmonth,1,&cyear)) > %sysfunc(mdy(&end_month,1,&end_year)));

		/********************************************;*/
		
		%let process_iter=%eval(&process_iter+1);
		
		%let cyear_char_00 = &cyear.;
		%let cyear_char_01 = &cyear.;
		%let cmonth_char_01 = 0&cmonth.;
		%if &cmonth. < 2 %then %do;
			%let cyear_char_00 = %eval(&cyear-1);
			%let cmonth_char_00 = 12;
		%end;
		%else %if &cmonth. < 10 %then %do;
			%let cmonth_char_00 = 0%eval(&cmonth-1);
		%end;
		%else %if &cmonth. < 11 %then %do;
			%let cmonth_char_00 = 0%eval(&cmonth-1);
			%let cmonth_char_01 = &cmonth.;
		%end;
		%else %do;
			%let cmonth_char_00 = %eval(&cmonth-1);
			%let cmonth_char_01 = &cmonth.;
		%end;
		
		%put 	****process_iter: &process_iter. | cyear: &cyear. | cmonth: &cmonth.****;
		
		/********************************************;*/
		
		%do sub_iter_01 = 1 %to 2;
			%let cyear_char = &cyear_char_00.;
			%let cmonth_char = &cmonth_char_00.;
			%if &sub_iter_01. = 2 %then %do;
				%let cyear_char = &cyear_char_01.;
				%let cmonth_char = &cmonth_char_01.;
			%end;
			%put ****sub_iter_01: &sub_iter_01. | cyear_char: &cyear_char. | cmonth_char: &cmonth_char.****;
			
			/************************;*/
			/* DO SOMETHING HERE...*/
			/************************;*/
		%end;
		
		/********************************************;*/
		
		%let cmonth = %eval(&cmonth + 1);
		%if &cmonth > 12 %then %do;
			%let cmonth = 1;
			%let cyear = %eval(&cyear + 1);
		%end;
	%end;
%mend macro_02;
%macro_02;

/************************************************************************************;*/
/*endProgram*/
/************************************************************************************;*/

