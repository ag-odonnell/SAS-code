/*******/
/* Note: mvar input that will be manipulated
/*******/

data test_01;
	do i = 1 to 4;
		id_var = put(i,3.); /*change the numeric iteration "i" input to a char_var using put function*/
		char_var_01 = 'a';
		char_var_02 = 'aaa';
		num_var_01 = 2;
		char_var_03 = 'aa';
		char_var_dt = '20220628';
		if i = 3 then do;
			char_var_01 = '';
			char_var_02 = '';
			num_var_01 = .;
			char_var_03 = '';
			char_var_dt = '';
		end;
		output;
	end;
	drop i;
run;

/*******/
/* NOte: Manual input of mvar
%let char_mvar = char_var_01 char_var_02 char_var_03;

%put ****char_mvar: &char_mvar.****;

/*******/
/* Note: create an mvar list of all variables by type
/* - In the following macro "_DT" is a char_var in the format yyyymmdd
/*******/

%let date_mvar = ;
%let char_mvar = ;
%let num_mvar = ;
	
/*******/

%macro create_mvar_list;
	
	/*create a dataset that contains a list of all variable names*/
	
	proc contents
		data = test_01
		out = test_04 (
			keep =
				name
				type
				length
				format)
		short
		noprint;
	run;
	
	/*parse the dataset into 3 new datasets by type */
	
	data 
		date_var_list
		char_var_list
		num_var_list;
	set test_04;
		name = upcase(name);		
		if type = 2 then do;
			if find(upcase(name),"_DT") > 0 then output date_var_list;
			else output char_var_list;
		end;
		else output num_var_list;
	run;
	
	/*a sub macro that outputs the variable names into an mvar*/
	%macro create_mvar_list_sub(ds_in=, mvar_out=);
		proc sql noprint;
			select name into :&mvar_out. separated by ' '
			from &ds_in.;
		quit;

		%put ****&mvar_out.: &&&mvar_out.****;
	%mend create_mvar_list_sub;
	%create_mvar_list_sub(ds_in=date_var_list, mvar_out=date_mvar);
	%create_mvar_list_sub(ds_in=char_var_list, mvar_out=char_mvar);
	%create_mvar_list_sub(ds_in=num_var_list, mvar_out=num_mvar);

%mend create_mvar_list;
%create_mvar_list;

/*******/
/* Note: add single quotes around mvar elements
/*******/

%macro add_single_quotes_mvar_list;
	%let char_mvar_up1 =;

	%macro loop_mvar_list(mvar_list_in=, mvar_list_out=);
		%let num_elements = %sysfunc(countw(&mvar_list_in));
		%put ****num_elements: &num_elements.****;
		%do i = 1 %to &num_elements.;
			%let &mvar_list_out. = &&&mvar_list_out. %str(%')%scan(&mvar_list_in, &i)%str(%');
		%end;
	%mend loop_mvar_list;
	%loop_mvar_list(mvar_list_in=&char_mvar.,mvar_list_out=char_mvar_up1);


	%put ****char_mvar_up1: &char_mvar_up1.****;
%mend add_single_quotes_mvar_list;
%add_single_quotes_mvar_list;

/*******/
/* Note: add prefix to mvar elements
/*******/

%macro add_prefix_mvar_list;
	%let char_mvar_up1 =;

	%macro loop_mvar_list(mvar_list_in=, mvar_list_out=,pre_val=);
		%let num_elements = %sysfunc(countw(&mvar_list_in));
		%put ****num_elements: &num_elements.****;
		%do i = 1 %to &num_elements.;
			%let &mvar_list_out. = &&&mvar_list_out. %str(&pre_val.)%scan(&mvar_list_in, &i);
		%end;
	%mend loop_mvar_list;
	%loop_mvar_list(mvar_list_in=&char_mvar.,mvar_list_out=char_mvar_up1,pre_val=e_);


	%put ****char_mvar_up1: &char_mvar_up1.****;
%mend add_prefix_mvar_list;
%add_prefix_mvar_list;

/*******/
/*endProgram
/*******/
