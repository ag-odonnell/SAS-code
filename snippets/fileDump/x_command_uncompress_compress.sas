
%let start_yyyy = 2020;
%let end_yyyy = 2020;
%let file_transfer_command = cp; *<=cp = copy;

%let aa_temp_libref_path = /sas/.../temp;
%let aa_output_libref_path = /sas/.../another_temp;
libname aa_temp "&aa_temp_libref_path.";

%macro macro_01;
	%do yyyy = &start_yyyy. %to &end_yyyy.;
		data aa_temp.test_01_&yyyy.;
			MID = 1;
			do i = 1 to 100000;
				j = i * 3.14;
				SID = mod(i,6);
				if i < 3 then BID = 2;
				else if i < 7 then BID = 4;
				else BID = i;
				output;
			end;
		run;

		x "%LOWCASE(compress) &aa_temp_libref_path./%LOWCASE(test_01_)&yyyy..sas7b*";
		x "%LOWCASE(&file_transfer_command) &aa_temp_libref_path./%LOWCASE(test_01_)&yyyy..sas7b* &aa_output_libref_path./";
		x "%LOWCASE(uncompress) &aa_output_libref_path./%LOWCASE(test_01_)&yyyy..sas7b*.Z";

	%end;
%mend macro_01;
%macro_01;

