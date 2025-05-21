data test_01;
	var_char='Q202402';
 	num_var=input(substr(strip(var_char),6,2),2.);
run;

data test_01;
	length var_01 8. var_02 $4;
	format var_01 mmddyy8.;
	var_01 = mdy(2,10,1927);
	var_02 = put(var_01,year4.);
	var_03 = put(var_01,month2.);
	if var_03 < 10 then var_04 = strip(compress(cat(var_02,'0',var_03)));
	else var_04 = strip(compress(cat(var_02,var_03)));
run;

/*******/

/*Test if CHARACTER or NUMERIC variable*/

data test_01;
	var_01 = 'a';
	var_02 = 1;
run;

data test_02;
set test_01;
	t1 = vtype(var_01);
	t2 = vtype(var_02);
run;

/*******/

data test_01;
var_01 = '  01234.567890  ';
var_02 = input(var_01,12.);;
run;

data test_01;
var_01 = '  01234.567890  ';
var_02 = input(strip(var_01),12.);;
run;

/*******/

data test_01;
    valid_ssn=0;
    valid_dob=0;
    valid_gender=1;
    valid_mdcr=1;
    valid_hic=1;
    valid_id = cat(strip(put(valid_ssn,3.)),strip(put(valid_dob,3.)),strip(put(valid_gender,3.)),strip(put(valid_mdcr,3.)),strip(put(valid_hic,3.)));
run;

/*******/

data test_01;
    valid_ssn=-1;
    valid_dob=0;
    valid_gender=1;
    valid_mdcr=1;
    valid_hic=1;
    array d_1(*)
        valid_ssn
        valid_dob
        valid_gender
        valid_mdcr
        valid_hic;
    array d_2(*)
        valid_ssn_id
        valid_dob_id
        valid_gender_id
        valid_mdcr_id
        valid_hic_id;
    do i = 1 to dim(d_1);
        if d_1(i) = -1 then d_2(i)=0;
        else d_2(i)=d_1(i);
    end;
    drop i;

    valid_id = cat(strip(put(valid_ssn_id,3.)),strip(put(valid_dob_id,3.)),strip(put(valid_gender_id,3.)),strip(put(valid_mdcr_id,3.)),strip(put(valid_hic_id,3.)));
run;

/*******/

