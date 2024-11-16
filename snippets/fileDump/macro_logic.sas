
%macro macro_01(mark_extract=);
	data test_01;
		var_01 = 1;
		var_02 = 'a';
	run;
	data test_02_&mark_extract.;
	set test_01 (
		keep = 
			%if &mark_extract. = a %then var_01;
			%else %if &mark_extract. = b %then var_02;
	);
	run;
	
	%do iter = 1 %to 2;
		%if &iter. = 1 %then %let iter_name = 0&iter.;
		%else %let iter_name = 0&iter.;
		%put ****iteration &iter_name.****;
	%end;

%mend macro_01;
%macro_01(mark_extract=a);
%macro_01(mark_extract=b);

/************************************************************************************;*/
/*endProgarm
/************************************************************************************;*/
