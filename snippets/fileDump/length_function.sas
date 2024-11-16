
data test_01;
	var_01 = 123456789;
	length var_02 $4;
	if length(strip(put(var_01,11.))) < 9 then var_02 = substr(strip(put(var_01,11.)),1,1);
	else if length(strip(put(var_01,11.))) < 10 then var_02 = substr(strip(put(var_01,11.)),1,2);
	var_03 = put(var_01,11.);
	var_04 = strip(put(var_01,11.));
	var_05 = length(var_03);
	var_06 = length(var_04);
	var_07 = length(strip(var_03));
	if var_07 < 9 then var_08 = substr(strip(put(var_01,11.)),1,1);
	else if var_07 < 10 then var_08 = substr(strip(put(var_01,11.)),1,2);
run;

/************************************************************************************;*/
/*endProgram
/************************************************************************************;*/
