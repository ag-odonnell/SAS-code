
/************************************************************************************;*/
/* Note: Compare Variable Population
/************************************************************************************;*/

data test_01;
	do i = 1 to 5;
		if i = 1 then do; var_01 = 1; var_03 = 1; end;
		else if i = 2 then do; var_01 = .; var_03 = 1; end;
		else if i = 3 then do; var_01 = 1; var_03 = 1; end;
		else if i = 4 then do; var_01 = 2; var_03 = 1; end;
		else if i = 5 then do; var_01 = 0; var_03 = 1; end;
		output;
	end;
run;


data test_02;
	do i = 2 to 6;
		if i = 2 then do; var_02 = .; var_04 = 1; end;
		else if i = 3 then do; var_02 = 3; var_04 = 1; end;
		else if i = 4 then do; var_02 = 2; var_04 = 1; end;
		else if i = 5 then do; var_02 = .; var_04 = 2; end;
		else if i = 6 then do; var_02 = 5; var_04 = 2; end;
		output;
	end;
run;

data test_03;
	length i 8. mark $2;
merge
	test_01 (in = a)
	test_02 (in = b);
by i;
	match_var_01_02 = 0;
	match_var_03_04 = 0;
	if a then do;
		mark = 'a';
		if b then do;
			mark = 'ab';
			match_var_01_02 = 1;
			match_var_03_04 = 1;
			if var_01 = . then do;
				if var_01 = var_02 then match_var_01_02 = 2;
			end;
			else do;
				if var_01 = var_02 then match_var_01_02 = 3;
			end;
			if var_03 = . then do;
				if var_03 = var_04 then match_var_03_04 = 2;
			end;
			else do;
				if var_03 = var_04 then match_var_03_04 = 3;
			end;
		end;
	end;
	else mark = 'b';
	eval_match = compress(cat(strip(put(match_var_01_02,1.)),strip(put(match_var_03_04,1.))));
run;

proc freq data = test_03;
tables
	mark * match_var_01_02
	mark * match_var_03_04
	eval_match
	/ missing nocol norow nocum nopct format=comma15.;
run;

/************************************************************************************;*/
/* Note: continuing the evaluation framework (below are shells for basic arrays)
/************************************************************************************;*/

data aa_lib02.<dataset_name_out_01>;
length mark $2;
merge
	aa_lib02.<dataset_name_in_01> (in = a
		keep =
			num_var_00
			num_var_01
			num_var_02
			num_var_03
			num_var_04
			char_var_01
			char_var_02
			char_var_03
			char_var_04
		rename = (
			num_var_01 = &state_cd_chip._num_var_01
			num_var_02 = &state_cd_chip._num_var_02
			num_var_03 = &state_cd_chip._num_var_03
			num_var_04 = &state_cd_chip._num_var_04
			char_var_01 = &state_cd_chip._char_var_01
			char_var_02 = &state_cd_chip._char_var_02
			char_var_03 = &state_cd_chip._char_var_03
			char_var_04 = &state_cd_chip._char_var_04))
	aa_lib02.<dataset_name_in_02> (in = b
		keep =
			num_var_00
			num_var_01
			num_var_02
			num_var_03
			num_var_04
			char_var_01
			char_var_02
			char_var_03
			char_var_04
		rename = (
			num_var_01 = &state_cd_postal._num_var_01
			num_var_02 = &state_cd_postal._num_var_02
			num_var_03 = &state_cd_postal._num_var_03
			num_var_04 = &state_cd_postal._num_var_04
			char_var_01 = &state_cd_postal._char_var_01
			char_var_02 = &state_cd_postal._char_var_02
			char_var_03 = &state_cd_postal._char_var_03
			char_var_04 = &state_cd_postal._char_var_04));
by num_var_00;
	array d_1a(*)
		match_num_var_01
		match_num_var_02
		match_num_var_03
		match_num_var_04;
	array d_1b(*)
		match_char_var_01
		match_char_var_02
		match_char_var_03
		match_char_var_04;
	array d_2a(*)
		&state_cd_chip._num_var_01
		&state_cd_chip._num_var_02
		&state_cd_chip._num_var_03
		&state_cd_chip._num_var_04;
	array d_2b(*)
		&state_cd_chip._char_var_01
		&state_cd_chip._char_var_02
		&state_cd_chip._char_var_03
		&state_cd_chip._char_var_04;
	array d_3a(*)
		&state_cd_postal._num_var_01
		&state_cd_postal._num_var_02
		&state_cd_postal._num_var_03
		&state_cd_postal._num_var_04;
	array d_3b(*)
		&state_cd_postal._char_var_01
		&state_cd_postal._char_var_02
		&state_cd_postal._char_var_03
		&state_cd_postal._char_var_04;
	do i = 1 to dim(d_1a); d_1a(i) = 0; end; drop i;
	do i = 1 to dim(d_1b); d_1b(i) = 0; end; drop i;
	if a then do;
		mark = 'a';
		if b then do;
			mark = 'ab';
			do i = 1 to dim(d_1a);
				d_1a(i) = 1;
				if d_2a(i) = . then do;
					if d_2a(i) = d_3a(i) then d_1a(i) = 2;
				end;
				else do;
					if d_2a(i) = d_3a(i) then d_1a(i) = 3;
				end;
			 end; drop i;
			do i = 1 to dim(d_1b);
				d_1b(i) = 1;
				if strip(d_2b(i)) = '' then do;
					if d_2b(i) = d_3b(i) then d_1b(i) = 2;
				end;
				else do;
					if d_2b(i) = d_3b(i) then d_1b(i) = 3;
				end;
			 end; drop i;
		end;
	end;
	else mark = 'b';
	eval_match = compress(cat(
		strip(put(match_num_var_01,1.))
		,strip(put(match_num_var_02,1.))
		,strip(put(match_num_var_03,1.))
		,strip(put(match_char_var_01,1.))
		,strip(put(match_num_var_04,1.))
		,strip(put(match_char_var_02,1.))
		,strip(put(match_char_var_03,1.))
		,strip(put(match_char_var_04,1.))
	));
run;
	
proc freq data = aa_lib01.<dataset_name_out_01>;
tables
	eval_match * mark
	/ missing nocol norow nocum nopct format=comma15.;
	title "aa_lib01.<dataset_name_out_01>";
run;

/************************************************************************************;*/
/* NOte: Add Complication: Test for null on both sides 
/************************************************************************************;*/

if a then do;
	mark = 'a';
	if b then do;
		mark = 'ab';
		do i = 1 to dim(d_1a);
			if d_2a(i) = . then do;
				if d_2a(i) = d_3a(i) then d_1a(i) = 4; /*Both a and b are null;*/
				else d_1a(i) = 3; /*a is null, but b is NOT null;*/
			end;
			else do;
				if d_2a(i) = d_3a(i) then d_1a(i) = 5; /*Both a and b are populated and equal;*/
				else do;
					if d_3a(i) = . then d_1a(i) = 2; /*b is null, but a is NOT null;*/
					else d_1a(i) = 1; /*Both a and b are populated but NOT equal;*/
				end;
			end;
		 end; drop i;
		do i = 1 to dim(d_1b);
			if strip(d_2b(i)) = '' then do;
				if d_2b(i) = d_3b(i) then d_1b(i) = 4; /*Both a and b are null;*/
				else d_1b(i) = 3; /*a is null, but b is NOT null;*/
			end;
			else do;
				if d_2b(i) = d_3b(i) then d_1b(i) = 5; /*Both a and b populated and equal;*/
				else do;
					if d_3b(i) = '' then d_1b(i) = 2; /*b is null, but a is NOT null;*/
					else d_1b(i) = 1; /*Both a and b are populated but NOT equal;*/
				end;
			end;
		 end; drop i;
	end;
end;
else mark = 'b';

/************************************************************************************;*/
/*endProgram
/************************************************************************************;*/
