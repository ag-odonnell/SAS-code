
/******************************************************************************************;*/

data test_01;
	length i 8. var_01 $1 var_02 $2 var_03 $3;
	do i = 95 to 105;
		if mod(i,2) then var_01 = '0';
		else var_01 = '1';
		if mod(i,3) then var_02 = ' 2';
		else var_02 = '3 ';
		if mod(i,5) then var_03 = '456';
		else var_03 = ' 78';
		output;
	end;
run;


data test_02;
set test_01;
	length var_04 $6 var_05 $6 var_06 $4 var_07 $5 var_08 $5;
	var_04 = cat(var_01,var_02,var_03);
	var_05 = cat(var_01,strip(var_02),strip(var_03));
	var_06 = compress(cat(var_01,strip(var_02),strip(var_03)));
	var_07 = compress(cat(var_01,strip(var_02),strip(var_03)));
	var_08 = compress(cat(var_01,var_02,var_03));
run;

/*ex. name = 'delta_M202003_M202002' has char length of 21*/

%let macroCall_length =;

data source_dataset;
set source_dataset;
	where upcase(substr(strip(name),1,5)) = 'DELTA';
	cnt + 1;
	length_name_string = cnt * 22 - 1;
	call symput('macroCall_length', strip(length_name_string));
run;

%let macroCall_name_string =;

data _null_;
	length name_string $&macroCall_length.;
set source_dataset;
	retain name_string;
	if cnt = 1 then name_string = strip(name);
	else name_string = cat(trim(name_string),' ',strip(name));
	verify_length_name_string = length(name_string);
	call symput('macroCall_name_string', strip(name_string));
run;


/******************************************************************************************;*/
/*endProgram
/******************************************************************************************;*/
