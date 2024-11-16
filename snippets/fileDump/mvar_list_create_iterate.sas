
/************************************************************************************;*/

%let Parameter_List=;

data test_01;
	length var_name_in $18;
	do i = 1 to 100;
		if mod(i,2) then var_name_in = 'var_01';
		else if mod(i,3) then var_name_in = 'var_a';
		else if mod(i,5) then var_name_in = 'var_something_else';
		output;
	end;
run;

proc sort
	data = test_01
	out = test_02
		nodupkey;
by var_name_in;
run;

proc sql noprint;
	select var_name_in into :Parameter_List separated by ' '
	from test_02;
quit;

%put ****Parameter_List: &Parameter_List.****;

/************************************************************************************;*/

%macro loop(vlist);
	%let num_words = %sysfunc(countw(&vlist));
	%put ****num_words: &num_words.****;
	%let var_name_out = ;
	%do i = 1 %to &num_words;
		%let var_name_out = %scan(&vlist, &i);
		%put ****i: &i.****;
		%put ****var_name_out: &var_name_out.****;
		proc freq
			data = test_01;
			tables var_name_in / missing;
			where var_name_in = "&var_name_out.";
			title "where condition: var_name_in = &var_name_out.";
		run;
		title '';
	%end;
%mend;
%loop(&Parameter_List);

/************************************************************************************;*/
/*endProgram
/************************************************************************************;*/
