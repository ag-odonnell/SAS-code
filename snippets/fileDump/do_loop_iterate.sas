
/************************************************************************************;*/

%let start_year = 2014;
%let end_year = 2016;
%let iter_mo_num=;
%let iter_mo_char=;
%let iter_num_01=;

%macro macro_01b();
	%do yyyy = &start_year. %to &end_year.;
		%if &yyyy. = 2014 %then %do;
			%put ****&yyyy.****;
			%do iter_mo_num = 1 %to 12;
				%put ****&iter_mo_num.****;
				%do iter_num_01 = 81 %to 70 %by -1;
					%put ****&iter_num_01.****;
				%end;
			%end;
		%end;
		%else %if &yyyy. = 2015 %then %do;
		%end;
		%else %if &yyyy. = 2016 %then %do;
		%end;
	%end;
%mend macro_01b;
%macro_01b ();

/************************************************************************************;*/

%let start_year = 2014;
%let end_year = 2014;
%let iter_mo_num=;
%let iter_mo_char=;
%let iter_mo_char=;
%let iter_num_01=;
%let iter_num_start_2014=81;
%let iter_num_start_2015=69;
%let iter_num_start_2016=57;

%macro macro_01a();
	%do yyyy = &start_year. %to &end_year.;
		%if &yyyy. = 2014 %then %do;
			%put ****&yyyy.****;
			%let iter_num_01=&iter_num_start_2014.;
			%do iter_mo_num = 1 %to 12;
				%if &iter_mo_num. < 10 %then %let iter_mo_char = 0&iter_mo_num.;
				%else %let iter_mo_char = &iter_mo_num.;
				%put ****&iter_mo_num.****;
				%put ****&iter_mo_char.****;
				%put ****&iter_num_01.****;
				%let iter_num_01=%eval(&iter_num_01-1);
			%end;
		%end;
		%else %if &yyyy. = 2015 %then %do;
			%put ****&yyyy.****;
			%let iter_num_01=&iter_num_start_2015.;
			%do iter_mo_num = 1 %to 12;
				%put ****&iter_mo_num.****;
				%put ****&iter_num_01.****;
				%let iter_num_01=%eval(&iter_num_01-1);
			%end;
		%end;
		%else %if &yyyy. = 2016 %then %do;
			%put ****&yyyy.****;
			%let iter_num_01=&iter_num_start_2016.;
			%do iter_mo_num = 1 %to 12;
				%put ****&iter_mo_num.****;
				%put ****&iter_num_01.****;
				%let iter_num_01=%eval(&iter_num_01-1);
			%end;
		%end;
	%end;
%mend macro_01a;
%macro_01a ();