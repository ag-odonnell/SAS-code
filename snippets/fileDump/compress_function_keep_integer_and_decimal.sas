
data test_01;
	x='/a/s/vvv122!!@#jfjfjf2222/-';
	w1=compress(x, '/');/*remove / */
	w2=compress(x,'','kd');/*Keeps only digits*/
	w3=compress(x,"","ka");/*Keep only alphanumeric characters*/
	w4=compress(x,' ','A');/*Keeps only digits and special characters*/
	w5=compress(x,"","kad");/*Keep only digits and alphanumeric characters*/
run;

data test_01;
	length RECORD_ID $12;
	do i = 1 to 5;
		if i = 1 then RECORD_ID = '  1234  ';
		else if i = 2 then RECORD_ID = '    ';
		else if i = 3 then RECORD_ID = ' 1234.5678/ ';
		else if i = 4 then RECORD_ID = ' - 1234.5678/';
		else if i = 5 then RECORD_ID = ' --1234.5678/';
		output;
	end;
run;

data test_01;
set test_01;
	transform_RECORD_ID_1 = input(compress(strip(RECORD_ID),'.','kd'),12.);
	transform_RECORD_ID_2 = input(compress(strip(RECORD_ID),'-.','kd'),12.);
	flag_1 = 0;
	flag_2 = 0;
	flag_3 = 0;
	if length(strip(RECORD_ID)) > 1 then flag_1 = 1;
	if length(compress(RECORD_ID,'kd')) > 0 then flag_2 = 1;
	if length(compress(strip(RECORD_ID),'kd')) > 0 then flag_3 = 1;
run;

/*******/
/* look for field defined as a character vs fields that have a character within...
/*******/

data test_01;
	do i=1 to 9;
		if i=1 then a='^aBc';
		else if i=2 then a='-';
		else if i=3 then a='a';
		else if i=4 then a='1';
		else if i=5 then a='a~2(';
		else if i=6 then a='12&a';
		else if i=7 then a='ABCD';
		else if i=8 then a='-A1bc';
		else if i=9 then a='A1-Bc';
		output;
	end;
run;

data test_02;
set test_01;
	length d $4;
	b=compress(a,,'ad');
	length_a=lengthn(compress(a,'','ad')); /*Notice the use of the LENGTHN function */
	length_b=length(b);
	lengthn_b=lengthn(b);
	/*if substr((compress(a,,'ad')),1,1)='-' then d='DASH'; /*<==problem with substr on 4 char (a). so, removed */
	if strip(a)='-' then d='DASH';
	else if compress(a,,'ad')='-' then d='UNKN';
	else if lengthn(compress(a,,'ad'))>0 then d='UNKN';
	else d=a;
run;

