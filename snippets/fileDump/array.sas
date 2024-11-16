/*Note: SAS Array*/

data test_01;
	array d_1(*) num_var_01 - num_var_4;
	array d_2(*) $4 char_var_01 - char_var_04;
	do i = 1 to dim(d_1); d_1(i) = 0; end; drop i;
	do j = 1 to dim(d_2); d_2(j) = '0000'; end; drop j;
run;

/***********************************************************************;*/
/***********************************************************************;*/
/***********************************************************************;*/
/***********************************************************************;*/

data test_01;
	array d_1(*) num_var_01 - num_var_04;
	do i = 1 to dim(d_1);
		d_1(i) = i;
	end;
	drop i;
run;

data test_02;
set test_01;
	array d_1(*) num_var_01 - num_var_03;
	array d_2(*) num_var_02 - num_var_04;
	array d_3(*) delta_var_02 - delta_var_04;
	array d_4(*) deltapct_var_02 - deltapct_var_04;
	do i = 1 to dim(d_1);
		d_3(i) = sum(d_2(i),-d_1(i));
	end;
	drop i;
	do i = 1 to dim(d_1);
		if ~(d_3(i) in (.,0)) then d_4(i) = d_3(i) / d_1(i);
	end;
	drop i;
	min_delta = min(of d_3[*]);
	mean_delta = mean(of d_3[*]);
	max_delta = max(of d_3[*]);
	std_delta = std(of d_3[*]);
	if ~(std_delta in (.,0)) then z_score_delta = (delta_var_04 - mean_delta) / std_delta;
	else z_score_delta = 0;
run;

/***********************************************************************;*/
/***********************************************************************;*/
/***********************************************************************;*/
/***********************************************************************;*/

%let PTA_NUM1 = var_01 var_02;

%let PTA_CLEAN_NUM_CNT = %SYSFUNC(COUNTW(&PTA_NUM1));

ARRAY NUM_CLEAN &PTA_NUM1;
DO K = 1 TO &PTA_CLEAN_NUM_CNT;
	IF NUM_CLEAN(K) = . THEN NUM_CLEAN(K) = 0;
END;
DROP K;

/***********************************************************************;*/
/***********************************************************************;*/
/***********************************************************************;*/
/***********************************************************************;*/

data test_02;
	do i = 10001 to 10010;
		if i = 10005 then do;
			numeric_var = .;
			var_01 = .;
			var_02 = i * 2;
			var_05 = .;
			var_06 = .;
		end;
		else do;
			numeric_var = i;
			chararacter_var_put_01 = put(numeric_var,8.);
			numeric_var_input_01 = input(chararacter_var_put_01,8.);
			
			var_01 = i * 4;
			var_02 = i * 7;
			var_05 = i;
			var_06 = i;
		end;
		output;
	end;
run;

data test_03;
set test_02;
	array d_2(*) var_01 var_02;
	array d_3(*) var_03 var_04;
	array d_4(*) var_05 var_06;
	array d_5(*) $10 var_07 var_08;
	do j = 1 to dim(d_2);
		if d_2(j) = . then d_3(j) = 0;
		else d_3(j) = d_2(j);
	end;
	do k = 1 to dim(d_4);
		if d_4(k) = . then d_5(k) = 'null_value';
		else d_5(k) = put(d_4(k),8.);
	end;
	drop j k;
run;

/***********************************************************************;*/
/* Note: notice the double-dash ''-'' below. This forces the read-in order.
/***********************************************************************;*/

array d_1 (12) var_with_month_jan_cd -- var_with_month_dec_cd;
array d_2 (12) $2 var_with_month_01 - var_with_month_12;
do i = 1 to 12; d_2(i) = d_1(i); end; drop i;

/***********************************************************************;*/
/* Note: Set s370ff0 dates to null *;
/***********************************************************************;*/

array d_1(*) dob dod_1 dod_2;
do i = 1 to dim(_d); if d_1{i} eq 0 then d_1{i} = .; end; drop i;

/***********************************************************************;*/
/* Note: Convert specific characters to null;
/***********************************************************************;*/

array segvar (4) id_var_1 - id_var_4;
do i = 1 to 4; if segvar(i) in ('~','^') then segvar(i)=''; end; drop i;

/***********************************************************************;*/

array segvar (4) pymt_var_1 pymt_var_2 pymt_var_3 pymt_var_4;
do i=1 to 4; segvar(i) = round(segvar(i),.01);
end;

/***********************************************************************;*/

data out_lib.base_transpose_&yyyy. (keep = out_var_01);
set in_lib.base_&yyyy.;
	length out_var_01 $2;
	array d_1(*) orig_var_1 -- orig_var_4452;
	do i = 1 to dim(d_1);
		if d_1{i} ~= '' then do;
		out_var_01 = d_1{i};
		output;
	end;
	drop i;
run;

/***********************************************************************;*/
/* Note:
/* - Notice the colon after source_dataset_:
/* - Look for the most recent value (by year in this case)
/***********************************************************************;*/

%let obs1 = obs = 100;
data data_out.output_dataset_&start_year._&end_year.;
merge source_dataset_: (&obs1.);
	array db(*) dob&start_year.-dob&end_year.;
	cnt_dim = 0;
	do i = 1 to dim(db);
		cnt_dim + 1;
		end;
		drop i;
		do i = cnt_dim to 1 by -1;
		if db(i) ~= . then dob = db(i);
		if dob ~= . then leave;
	end;
	drop i;
run;

/***********************************************************************;*/
/***********************************************************************;*/

/***********************************************************************;*/
/***********************************************************************;*/
/* annual FIPS Code conversion
/* - sorted in descending order of number of zip codes per fips state code
/***********************************************************************;*/
/***********************************************************************;*/

data test;
length zip 8. county_2010 $5 county_2011 $5 county_2012 $5;
input zip county_2010 $ county_2011 $ county_2012 $;
cards;
1 11111 11111 11111
2 . 11111 11111
3 11111 . 11111
4 11111 11111 .
5 22222 11111 11111
6 11111 22222 11111
7 11111 11111 22222
8 11111 11111 11222
9 48123 48123 48123
10 48123 08123 48123
;
run;

%let quantitybeneStateCd = 55;

data test_b;
set test (
	keep = zip county_2010 - county_2012);

	array d_1(*) county_2010 - county_2012;
	array d_2(*) $2 state_2010 - state_2016;
	length zip_county_change 8. zip_state_change 8. check_dim 8.;
	do i = 1 to dim(d_1);
		check_dim = dim(d_1);
		if d_1(i) ~= '' then do;
		if (i) < dim(d_1) then do;
		if d_1(i) ~= d_1(i+1) then zip_county_change = 1;
		if substr(d_1(i),1,2) ~= substr(d_1(i+1),1,2) then zip_state_change = 1;
		end;
		end;
		d_2(i) = substr(d_1(i),1,2);
	end;
	drop i;

	length fips_state $2 STATE_ABBV $2;
	fips_state = substr(county_2012,1,2);

	array beneStateCd [&quantitybeneStateCd] $2
		('06','48','36','42','17','12','39','51','29','26'
		,'37','19','18','27','13','21','55','54','01','47'
		,'20','40','53','34','05','22','25','08','31','24'
		,'45','28','04','23','41','35','09','38','30','46'
		,'49','16','50','33','02','32','11','56','72','15'
		,'44','10','78','66');
	array statePostalCd [&quantitybeneStateCd] $2
		('CA','TX','NY','PA','IL','FL','OH','VA','MO','MI'
		,'NC','IA','IN','MN','GA','KY','WI','WV','AL','TN'
		,'KS','OK','WA','NJ','AR','LA','MA','CO','NE','MD'
		,'SC','MS','AZ','ME','OR','NM','CT','ND','MT','SD'
		,'UT','ID','VT','NH','AK','NV','DC','WY','PR','HI'
		,'RI','DE','VI','GU');

	do i=1 to dim(beneStateCd);
		if fips_state=beneStateCd[i] then STATE_ABBV=statePostalCd[i];
	end;

	drop
		beneStateCd1-beneStateCd&quantitybeneStateCd
		statePostalCd1-statePostalCd&quantitybeneStateCd
		i;

run;

/***********************************************************************;*/
/***********************************************************************;*/
/* monthly SSA Code conversion
/***********************************************************************;*/
/***********************************************************************;*/

array beneStateCd [&quantitybeneStateCd] $2
	('05','10','45','33','14'
	,'01','02','03','04','06','07','08','09'
	,'11','12','13','15','16','17','18','19','20'
	,'21','22','23','24','25','26','27','28','29','30'
	,'31','32','34','35','36','37','38','39','40'
	,'41','42','43','44','46','47','49','50'
	,'51','52','53','55','64','66','67','68','69','70'
	,'71','72','73','74','80','97');
array statePostalCd [&quantitybeneStateCd] $2
	('CA','FL','TX','NY','IL'
	,'AL','AK','AZ','AR','CO','CT','DE','DC'
	,'GA','HI','ID','IN','IA','KS','KY','LA','ME'
	,'MD','MA','MI','MN','MS','MO','MT','NE','NV','NH'
	,'NJ','NM','NC','ND','OH','OK','OR','PA','PR'
	,'RI','SC','SD','TN','UT','VT','VA','WA'
	,'WV','WI','WY','CA','AS','MP','TX','FL','FL','KS'
	,'LA','OH','PA','TX','MD','MP');
array stateCd {*} $2 state01-state&indicatorVariableMonthRange;
array stateCountyCd {*} $5 ssacd01-ssacd&indicatorVariableMonthRange;

/***********************************************************************;*/
/* Note: Assign the stateCd and ssacd (state/county) values as of the first of the month.
/* - (i.e., does NOT matter what happened during the month. Only the first day counts)
/* - The rows are conditioned on a date between the range of EFCTV_DT and END_DT
/* - Note that American Samoa has its own line that looks at BENE_CNTY_CD.
/***********************************************************************;*/

retain state01-state&indicatorVariableMonthRange ssacd01-ssacd&indicatorVariableMonthRange;
if first.bene_id then do k=1 to &indicatorVariableMonthRange; stateCd[k]=''; end; drop k;
do j=1 to dim(stateCd);
do i=1 to dim(beneStateCd);
if (date1<=mdy(j,1,&yyyy.) and date2>=mdy(j,1,&yyyy.)) then do;
stateCountyCd[j]=ssacd;
if BENE_STATE_CD='99' then do; if BENE_CNTY_CD='000' then stateCd[j]='AS'; end;
else if BENE_STATE_CD=beneStateCd[i] then stateCd[j]=statePostalCd[i];
end;
end;
end;

drop beneStateCd1-beneStateCd&quantitybeneStateCd
statePostalCd1-statePostalCd&quantitybeneStateCd
i j;

/***********************************************************************;*/
/***********************************************************************;*/
/***********************************************************************;*/
/***********************************************************************;*/

data data_out.ssa_fips_cbsa_2003_2017_review (
	keep =
		null_2003
		change_2010 - change_2017
		null_2010 - null_2017);
set data_out.ssa_fips_cbsa_2003_2017;

	array d_1(*) state_2003 county_2003 cbsa_cd_2003 cbsa_name_2003 null_2003;
	array d_2(*) state_2010 county_2010 cbsa_cd_2010 cbsa_name_2010 null_2010;
	array d_3(*) state_2011 county_2011 cbsa_cd_2011 cbsa_name_2011 null_2011;
	array d_4(*) state_2012 county_2012 cbsa_cd_2012 cbsa_name_2012 null_2012;
	array d_5(*) state_2013 county_2013 cbsa_cd_2013 cbsa_name_2013 null_2013;
	array d_6(*) state_2014 county_2014 cbsa_cd_2014 cbsa_name_2014 null_2014;
	array d_7(*) state_2015 county_2015 cbsa_cd_2015 cbsa_name_2015 null_2015;
	array d_8(*) state_2016 county_2016 cbsa_cd_2016 cbsa_name_2016 null_2016;
	array d_9(*) state_2017 county_2017 cbsa_cd_2017 cbsa_name_2017 null_2017;

	length change_2010 - change_2017 3.;

	do i = 1 to 4;
		if d_1(i) = '' then d_1(5) = 1;
		if d_2(i) = '' then d_2(5) = 1;
		if d_3(i) = '' then d_3(5) = 1;
		if d_4(i) = '' then d_4(5) = 1;
		if d_5(i) = '' then d_5(5) = 1;
		if d_6(i) = '' then d_6(5) = 1;
		if d_7(i) = '' then d_7(5) = 1;
		if d_8(i) = '' then d_8(5) = 1;
		if d_9(i) = '' then d_9(5) = 1;
		if d_1(i) ~= d_2(i) then change_2010 = 1;
		if d_2(i) ~= d_3(i) then change_2011 = 1;
		if d_3(i) ~= d_4(i) then change_2012 = 1;
		if d_4(i) ~= d_5(i) then change_2013 = 1;
		if d_5(i) ~= d_6(i) then change_2014 = 1;
		if d_6(i) ~= d_7(i) then change_2015 = 1;
		if d_7(i) ~= d_8(i) then change_2016 = 1;
		if d_8(i) ~= d_9(i) then change_2017 = 1;
	end;
	drop i;
run;

/***********************************************************************;*/
/***********************************************************************;*/
/***********************************************************************;*/
/***********************************************************************;*/

data test;
	deltapct07_08 = .;
	deltapct08_09 = .;
	deltapct09_10 = .;
	deltapct10_11 = .;
	deltapct11_12 = .;
	deltapct12_13 = .;

	array d_1(*) deltapct07_08 -- deltapct12_13;

	flag_null_pct = 0;
	if deltapct07_08 = . then flag_null_pct = 1;

	do i = 2 to dim(d_1);
		if d_1(i) = . and flag_null_pct = 1 then flag_null_pct = 1;
		else flag_null_pct = 0;
	end;
	drop i;
run;

/***********************************************************************;*/

array d_1(*)
	delta07_08 delta08_09
	delta09_10 delta10_11
	delta11_12 delta12_13
	delta13_14
%if &processFinalCurrentYearSwitch. = 1 %then %do;
	delta_fin&midyearFinalCurrentYY._fin&midyearFinalPreviousYY.
%end;
%else %do;
	delta_mid&midyearFinalCurrentYY._fin&midyearFinalPreviousYY.
%end;;
array d_2(*) deltapct07_08 deltapct08_09
deltapct09_10 deltapct10_11
deltapct11_12 deltapct12_13
deltapct13_14
%if &processFinalCurrentYearSwitch. = 1 %then %do;
	deltapct_fin&midyearFinalCurrentYY._fin&midyearFinalPreviousYY.
%end;
%else %do;
	eltapct_mid&midyearFinalCurrentYY._fin&midyearFinalPreviousYY.
%end;;

min_delta = 0;
max_delta = 0;
mean_delta = 0;
std_delta = 0;
min_delta = min(of d_1[*]);
max_delta = max(of d_1[*]);
mean_delta = mean(of d_1[*]);
std_delta = std(of d_1[*]);

min_deltapct = 0;
max_deltapct = 0;
mean_deltapct = 0;
std_deltapct_100 = 0;
mean_deltapct_100 = 0;
min_deltapct = min(of d_2[*])/100;
max_deltapct = max(of d_2[*])/100;
mean_deltapct = mean(of d_2[*])/100;
mean_deltapct_100 = mean(of d_2[*]);
std_deltapct_100 = std(of d_2[*]);

if std_delta ~= 0 then do;
	zscoreRow = (delta_fin&midyearFinalCurrentYY._fin&midyearFinalPreviousYY.
	- mean_delta) / std_delta;
end;
if std_deltapct_100 ~= 0 then do;
	zscorePctRow = (deltapct_fin&midyearFinalCurrentYY._fin&midyearFinalPreviousYY.
	- mean_deltapct_100) / std_deltapct_100;
end;
%if &processFinalCurrentYearSwitch. = 1 %then %do;
	if std_deltapct_fin&midyearFinalCurrentYY._fin&midyearFinalPreviousYY. ~= 0 then do;
		zScorePctColumn = (deltapct_fin&midyearFinalCurrentYY._fin&midyearFinalPreviousYY.
		- mean_deltapct_fin&midyearFinalCurrentYY._fin&midyearFinalPreviousYY.)
		/ std_deltapct_fin&midyearFinalCurrentYY._fin&midyearFinalPreviousYY.;
	end;
%end;
%else %do;
	if std_deltapct_mid&midyearFinalCurrentYY._fin&midyearFinalPreviousYY. ~= 0 then do;
		zScorePctColumn = (deltapct_mid&midyearFinalCurrentYY._fin&midyearFinalPreviousYY.
		- mean_deltapct_mid&midyearFinalCurrentYY._fin&midyearFinalPreviousYY.)
		/ std_deltapct_mid&midyearFinalCurrentYY._fin&midyearFinalPreviousYY.;
	end;
%end;

run;

/***********************************************************************;*/
/***********************************************************************;*/
/***********************************************************************;*/
/***********************************************************************;*/
/* Iteration #1
/***********************************************************************;*/
/***********************************************************************;*/
/***********************************************************************;*/
/***********************************************************************;*/

%let vla=a b c;
%let vlcu=x y z;

/***********************************************************************;*/

%macro varlst(mc=, vlc=, vls=);
	%let vn=%sysfunc(countw(&&&vls.));
	%do j=1 %to &vn.;
		%let vvar=%scan(&&&vls.,&j.,' ');
		%let vvar&j.=%scan(&&&vls.,&j.,' ');
		data test;
			length var1 $5 var2 $5 var3 3. var4 $20;
			var1 = ''&vla.'';
			var2 = ''&vlcu.'';
			var3 = &vn.;
			var4 = ''&vvar.'';
			varTest&j. = ''&&vvar&j.'';
		run;
	%end;
%mend;
%varlst(mc=varlstsf, vlc=vla, vls=vlcu);

/***********************************************************************;*/
/***********************************************************************;*/
/***********************************************************************;*/
/***********************************************************************;*/
/* Iteration #2
/***********************************************************************;*/
/***********************************************************************;*/
/***********************************************************************;*/
/***********************************************************************;*/

%let vla=a b c;
%let vlcu=x y z;

%macro varlst(mc=, vlc=, vls
	%let vn=%sysfunc(countw(&&&vls.));

	data test;
		%do j=1 %to &vn.;
			%let vvar1&j.=%scan(&&&vls.,&j.,' ');
			%let vvar2&j.=%scan(&&&vlc.,&j.,' ');
			varA&j. = ''&&vvar1&j.'';
			varX&j. = ''&&vvar2&j.'';
		%end;
	run;
%mend;
%varlst(mc=varlstsf, vlc=vla, vls=vlcu);

/***********************************************************************;*/
/***********************************************************************;*/
/***********************************************************************;*/
/***********************************************************************;*/
/* Iteration #3
/***********************************************************************;*/
/***********************************************************************;*/
/***********************************************************************;*/
/***********************************************************************;*/

%let vla =
	col_2007 col_2008 col_2009 col_2010 col_2011 col_2012 col_2013
	col_midyear_2014
	col_final_2014
	col_midyear_2015
	col_final_2015;
%let vlcu =
	2007 2008 2009 2010 2011 2012 2013 2014 2014 2015 2015;
%macro varlst(mc=, vlc=, vls=);
	%let vn=%sysfunc(countw(&&&vls.));

	data test;
		%do j=1 %to &vn.;
			%let vvar1&j.=%scan(&&&vls.,&j.,' ');
			%let vvar2&j.=%scan(&&&vlc.,&j.,' ');
			varA&j. = ''&&vvar1&j.'';
			varX&j. = ''&&vvar2&j.'';
		%end;
	run;
%mend;
%varlst(mc=varlstsf, vlc=vla, vls=vlcu);

/***********************************************************************;*/
/***********************************************************************;*/
/***********************************************************************;*/
/***********************************************************************;*/
/* Iteration #4
/***********************************************************************;*/
/***********************************************************************;*/
/***********************************************************************;*/
/***********************************************************************;*/

%let vla =
	col_2007 col_2008 col_2009 col_2010 col_2011 col_2012 col_2013
	col_midyear_2014
	col_final_2014
	col_midyear_2015
	col_final_2015;
	%let vlcu =
	2007 2008 2009 2010 2011 2012 2013 2014 2014 2015 2015;;
	
%macro varlst(mc=, vlc=, vls=);
	%let vn=%sysfunc(countw(&&&vls.));

	data test;
	%do j=1 %to &vn.;
	%let vvar1&j.=%scan(&&&vls.,&j.,' ');
	%let vvar2&j.=%scan(&&&vlc.,&j.,' ');
	varA&j. = ''&&vvar1&j.'';
	varX&j. = ''&&vvar2&j.'';
	%end;
	run;
%mend;
%varlst(mc=varlstsf, vlc=vla, vls=vlcu);

/***********************************************************************;*/
/***********************************************************************;*/
/***********************************************************************;*/
/***********************************************************************;*/
/* Iteration #5
/***********************************************************************;*/
/***********************************************************************;*/
/***********************************************************************;*/
/***********************************************************************;*/

%let versionGvdbCode =Version 4.1;
%let count_vars_3 =
	col_2007 col_2008 col_2009 col_2010 col_2011 col_2012 col_2013
	col_midyear_2014
	col_final_2014
	col_midyear_2015
	col_final_2015;
%let year_vars_5 =
	2007 2008 2009 2010 2011 2012 2013 2014 2014 2015 2015;
%let year_vars_6 =
	Final Final Final Final Final Final Final Midyear Final Midyear Final;

%let mvar1_in = &count_vars_3.;
%let mvar2_in = &year_vars_5.;
%let mvar3_in = &year_vars_6.;

%macro varlst(mvar1=, mvar2=, mvar3=);
	%let vn=%sysfunc(countw(&&&mvar1.));

	data test;
		%do j=1 %to &vn.;
			%let vvar2&j.=%scan(&&&mvar2.,&j.,' ');
			%let vvar3&j.=%scan(&&&mvar3.,&j.,' ');
			var&j. = ''&versionGvdbCode. &&vvar2&j. &&vvar3&j.'';
		%end;
	run;
%mend;
%varlst(mvar1=mvar1_in, mvar2=mvar2_in, mvar3=mvar3_in);

/***********************************************************************;*/

data test2;
	label %label(datain = test);
	var1 = 1;
	var2 = 2;
	var3 = 3;
	var4 = 4;
	var5 = 5;
	var6 = 6;
	var7 = 7;
	var8 = 8;
	var9 = 9;
	var10 = 10;
	var11 = 11;
run;

/***********************************************************************;*/
/***********************************************************************;*/
/***********************************************************************;*/
/***********************************************************************;*/
/* Iteration #6
/***********************************************************************;*/
/***********************************************************************;*/
/***********************************************************************;*/
/***********************************************************************;*/
/* Note: Routine to dynamically assign labels
/***********************************************************************;*/

%macro label(datain= );
	%local dsid getvalue getvarname close i;
	/* Open dataset whose values in the first observation will become new labels */
	%let dsid=%sysfunc(open(&datain));
	/* ATTRN and NVARS will return the number of variables in &datain */
	%do i=1 %to %sysfunc(attrn(&dsid,nvars));
		/* Retrieve each variable name in &datain */
		%let getvarname=%sysfunc(varname(&dsid,&i));
		/* FETCHOBS reads the specified observation from &datain */
		%let rc=%sysfunc(fetchobs(&dsid,1));
		/* Retrieve the value of each variable */
		%let getvalue=%qsysfunc(getvarc(&dsid,&i));
		/* Build the syntax for the LABEL statement that will be generated */
		&getvarname = ''&getvalue''
	%end;
	/* Close the dataset */
	%let close=%sysfunc(close(&dsid));
%mend label;

/***********************************************************************;*/
/***********************************************************************;*/
/***********************************************************************;*/
/***********************************************************************;*/

%let versionGvdbCode = Version 4.1;
%let count_vars_3 =
	col_2007 col_2008 col_2009 col_2010 col_2011 col_2012 col_2013
	col_midyear_2014
	col_final_2014
	col_midyear_2015
	col_final_2015;
%let year_vars_5 =
	2007 2008 2009 2010 2011 2012 2013 2014 2014 2015 2015;
%let year_vars_6 =
	Final Final Final Final Final Final Final Midyear Final Midyear Final;
%let mvar1_in = &count_vars_3.;
%let mvar2_in = &year_vars_5.;
%let mvar3_in = &year_vars_6.;

%macro varlst(mvar1=, mvar2=, mvar3=);
	%let vn=%sysfunc(countw(&&&mvar1.));

	data test;
		%do j=1 %to &vn.;
			%let vvar1&j.=%scan(&&&mvar1.,&j.,' ');
			%let vvar2&j.=%scan(&&&mvar2.,&j.,' ');
			%let vvar3&j.=%scan(&&&mvar3.,&j.,' ');
			&&vvar1&j. = ''&versionGvdbCode. &&vvar2&j. &&vvar3&j.'';
		%end;
	run;
%mend;
%varlst(mvar1=mvar1_in, mvar2=mvar2_in, mvar3=mvar3_in);

/***********************************************************************;*/

data test2;
	label %label(datain = test);
	col_2007 = 1;
	col_2008 = 2;
	col_2009 = 3;
	col_2010 = 4;
	col_2011 = 5;
	col_2012 = 6;
	col_2013 = 7;
	col_midyear_2014 = 8;
	col_final_2014 = 9;
	col_midyear_2015 = 10;
	col_final_2015 = 11;
run;

/***********************************************************************;*/
/***********************************************************************;*/
/***********************************************************************;*/
/***********************************************************************;*/
/* Iteration #7
/***********************************************************************;*/
/***********************************************************************;*/
/***********************************************************************;*/
/***********************************************************************;*/
/* Note: Routine to dynamically assign labels
/***********************************************************************;*/

%macro label(datain= );
	%local dsid getvalue getvarname close i;
	%let dsid=%sysfunc(open(&datain));
	%do i=1 %to %sysfunc(attrn(&dsid,nvars));
		%let getvarname=%sysfunc(varname(&dsid,&i));
		%let rc=%sysfunc(fetchobs(&dsid,1));
		%let getvalue=%qsysfunc(getvarc(&dsid,&i));
		&getvarname = ''&getvalue''
	%end;
	%let close=%sysfunc(close(&dsid));
%mend label;

/***********************************************************************;*/
/***********************************************************************;*/
/***********************************************************************;*/
/***********************************************************************;*/

%let versionGvdbCode =Version 4.1;
%let countVarLabels =countVarLabels_in;
%let deltaVarLabels =deltaVarLabels_in;
%let deltaLabel_in =Delta;
%let deltaPctVarLabels =deltaPctVarLabels_in;
%let deltaPctLabel_in =% Delta;

%let count_vars_3 =
	col_2007 col_2008 col_2009 col_2010 col_2011 col_2012 col_2013
	col_midyear_2014
	col_final_2014
	col_midyear_2015
	col_final_2015;

%let year_vars_5 =
	2007 2008 2009 2010 2011 2012 2013 2014 2014 2015 2015;
%let year_vars_6 =
	Final Final Final Final Final Final Final Midyear Final Midyear Final;
%let delta_vars_1 =
	delta07_08 delta08_09 delta09_10 delta10_11 delta11_12 delta12_13
	delta_final_2013_midyear_2014 delta_final_2014_midyear_2015
	delta_midyear_2014_final_2014 delta_midyear_2015_final_2015
	delta_final_2013_final_2014 delta_final_2014_final_2015;
%let deltapct_vars_1 =
	deltapct07_08 deltapct08_09 deltapct09_10 deltapct10_11 deltapct11_12 deltapct12_13
	deltapct_final_2013_midyear_2014 deltapct_final_2014_midyear_2015
	deltapct_midyear_2014_final_2014 deltapct_midyear_2015_final_2015
	deltapct_final_2013_final_2014 deltapct_final_2014_final_2015;
%let year_delta_vars_1 =
	2007 2008 2009 2010 2011 2012 2013 2014 2014 2015 2013 2014;
%let year_delta_vars_2 =
	2008 2009 2010 2011 2012 2013 2014 2014 2015 2015 2014 2015;
%let year_delta_vars_3 =
	Final Final Final Final Final Final Final Midyear Final Midyear Final Final;
%let year_delta_vars_4 =
	Final Final Final Final Final Final Midyear Final Midyear Final Final Final;
%let mvar1_in = &count_vars_3.;
%let mvar2_in = &year_vars_5.;
%let mvar3_in = &year_vars_6.;
%let mvar4_in = &delta_vars_1.;
%let mvar5_in = &deltapct_vars_1.;
%let mvar6_in = &year_delta_vars_1.;
%let mvar7_in = &year_delta_vars_2.;
%let mvar8_in = &year_delta_vars_3.;
%let mvar9_in = &year_delta_vars_4.;

/***********************************************************************;*/
/***********************************************************************;*/

%macro varlst(mvar1=, mvar2=, mvar3=, dsVar1=);
	%let vn=%sysfunc(countw(&&&mvar1.));
	data &dsVar1.;
		%do j=1 %to &vn.;
			%let vvar1&j.=%scan(&&&mvar1.,&j.,' ');
			%let vvar2&j.=%scan(&&&mvar2.,&j.,' ');
			%let vvar3&j.=%scan(&&&mvar3.,&j.,' ');
			&&vvar1&j. = ''&versionGvdbCode. &&vvar2&j. &&vvar3&j.'';
		%end;
	run;
%mend;
%varlst(mvar1=mvar1_in, mvar2=mvar2_in, mvar3=mvar3_in, dsVar1=countVarLabels);

/***********************************************************************;*/
/***********************************************************************;*/

%macro varlst(mvar1=, mvar2=, mvar3=, mvar4=, mvar5=, mvar6=, dsVar1=);
	%let vn=%sysfunc(countw(&&&mvar1.));
	data &dsVar1.;
		%do j=1 %to &vn.;
			%let vvar1&j.=%scan(&&&mvar1.,&j.,' ');
			%let vvar2&j.=%scan(&&&mvar2.,&j.,' ');
			%let vvar3&j.=%scan(&&&mvar3.,&j.,' ');
			%let vvar4&j.=%scan(&&&mvar4.,&j.,' ');
			%let vvar5&j.=%scan(&&&mvar5.,&j.,' ');
			&&vvar1&j. = ''&mvar6. (&&vvar2&j. &&vvar3&j. - &&vvar4&j. &&vvar5&j.)'';
		%end;
	run;
%mend;

%varlst(
	mvar1=mvar4_in
	,mvar2=mvar9_in
	,mvar3=mvar7_in
	,mvar4=mvar8_in
	,mvar5=mvar6_in
	,mvar6=Delta
	,dsVar1=deltaVarLabels);
%varlst(
	mvar1=mvar5_in
	,mvar2=mvar9_in
	,mvar3=mvar7_in
	,mvar4=mvar8_in
	,mvar5=mvar6_in
	,mvar6=% Delta
	,dsVar1=deltaPctVarLabels);

/***********************************************************************;*/

data test2a;
	label %label(datain = countVarLabels);
	col_2007 = 1;
	col_2008 = 2;
	col_2009 = 3;
	col_2010 = 4;
	col_2011 = 5;
	col_2012 = 6;
	col_2013 = 7;
	col_midyear_2014 = 8;
	col_final_2014 = 9;
	col_midyear_2015 = 10;
	col_final_2015 = 11;
run;

/***********************************************************************;*/

data test2b;
	label %label(datain = deltaVarLabels);
	delta07_08 = 1;
	delta08_09 = 2;
	delta09_10 = 3;
	delta10_11 = 4;
	delta11_12 = 5;
	delta12_13 = 6;
	delta_final_2013_midyear_2014 = 7;
	delta_final_2014_midyear_2015 = 8;
	delta_midyear_2014_final_2014 = 9;
	delta_midyear_2015_final_2015 = 10;
	delta_final_2013_final_2014 = 11;
	delta_final_2014_final_2015 = 12;
run;

/***********************************************************************;*/

data test2c;
	label %label(datain = deltaPctVarLabels);
	deltapct07_08 = 1;
	deltapct08_09 = 2;
	deltapct09_10 = 3;
	deltapct10_11 = 4;
	deltapct11_12 = 5;
	deltapct12_13 = 6;
	deltapct_final_2013_midyear_2014 = 7;
	deltapct_final_2014_midyear_2015 = 8;
	deltapct_midyear_2014_final_2014 = 9;
	deltapct_midyear_2015_final_2015 = 10;
	deltapct_final_2013_final_2014 = 11;
	deltapct_final_2014_final_2015 = 12;
run;

/***********************************************************************;*/

data test;
	col_2007 = 1;
	col_2008 = 2;
	col_2009 = 3;
	col_2010 = 4;
	col_2011 = 5;
	col_2012 = 6;
	col_2013 = 7;
	col_midyear_2014 = 8;
	col_final_2014 = 9;
	col_midyear_2015 = 10;
	col_final_2015 = 11;
	delta07_08 = 1;
	delta08_09 = 2;
	delta09_10 = 3;
	delta10_11 = 4;
	delta11_12 = 5;
	delta12_13 = 6;
	delta_final_2013_midyear_2014 = 7;
	delta_final_2014_midyear_2015 = 8;
	delta_midyear_2014_final_2014 = 9;
	delta_midyear_2015_final_2015 = 10;
	delta_final_2013_final_2014 = 11;
	delta_final_2014_final_2015 = 12;
	deltapct07_08 = 1;
	deltapct08_09 = 2;
	deltapct09_10 = 3;
	deltapct10_11 = 4;
	deltapct11_12 = 5;
	deltapct12_13 = 6;
	deltapct_final_2013_midyear_2014 = 7;
	deltapct_final_2014_midyear_2015 = 8;
	deltapct_midyear_2014_final_2014 = 9;
	deltapct_midyear_2015_final_2015 = 10;
	deltapct_final_2013_final_2014 = 11;
	deltapct_final_2014_final_2015 = 12;
run;

/***********************************************************************;*/

data test2c;
set test;
	label %label(datain = countVarLabels);
	label %label(datain = deltaVarLabels);
	label %label(datain = deltaPctVarLabels);
run;

/***********************************************************************;*/
/***********************************************************************;*/
/***********************************************************************;*/
/* EndProgram
/***********************************************************************;*/
/***********************************************************************;*/
/***********************************************************************;*/
/***********************************************************************;*/

/***********************************************************************;*/
/* Note: Array Code
/***********************************************************************;*/

array v(2) char_variable_1 char_variable_2;
do i=1 to 2; v(i)= left(v(i)); if length(v(i))=1 then v(i)='0'|| v(i); end;

/***********************************************************************;*/
/* Note: Create an array of monthly variables then compare to month of a date Variable;
/***********************************************************************;*/

%let year=2012;
data pTest;
	FSD=mdy(02,15,2012);
	p_&year._1=.;
	p_&year._2=0;
	p_&year._3=1;
	p_&year._4=.;
	mFSD=month(FSD);
	array _d1(*) p_&year._1-p_&year._4;
	do i = mFSD to mFSD;
		pSMonthFSD=_d1{i};
	end;
	drop i;
run;

/***********************************************************************;*/
/* Note: Converts all variables that begin in s and u and end in a number;
/***********************************************************************;*/

array c(*) s_: u_:;
do i=1 to dim(c);
	if c(i)=. then c(i)=0;
end;

/***********************************************************************;*/

data aago.output_dataset;
set dp.source_dataset_&year.&mo._&version. (
	keep =
		num_variable_1 num_variable_2 num_variable_3 num_variable_4);
		num_variable_mark_1=0; num_variable_mark_2=0; num_variable_mark_3=0; num_variable_mark_4=0;
	array v(*) num_variable_1 num_variable_2 num_variable_3 num_variable_4;
	array m(*) num_variable_mark_1 num_variable_mark_2 num_variable_mark_3 num_variable_mark_4;
	do i = 1 to dim(v);
		if length (v(i))=0 then m(i)=0;
		else if length (v(i))=1 then m(i)=1;
		else if length (v(i))=2 then m(i)=2;
		else if length (v(i))=3 then m(i)=3;
		else if length (v(i))=4 then m(i)=4;
	end;
	drop i;
run;

/***********************************************************************;*/
/* Note: Did the event occur in a month that the individual was fully covered;
/***********************************************************************;*/

if year(DEATH_DT)~=&year. then ALIVE_MOS=.; else ALIVE_MOS=MONTH(DEATH_DT);
if alive_mos=. then x=12; else x=alive_mos;

indVar1=0;
indVar2=0;
indVar3=0;
L=MONTH(LAST_SRVC_DT);
if L<=x then do;
	array _d1 (12) inDate01 - inDate12;
	array _d2 (12) indVarA01 - indDVarA12;
	array _d3 (12) indVarJanCd -- indVarDecCd;
	array _d4 (12) indVarB01 - indDVarB12;
	if ((_d1 (L) in ('3','C')) and (_d2 (L) in ('0','4'))) then indVar1=1;
	if (_d3 (L) in ('01','02','03','04','05','06','08')) then indVar2=1;
	if (_d4 (L) in ('1')) then indVar3=1;
end;
output;
run;

/***********************************************************************;*/
/* Note: convert the CONTRACT_ID for a particular month (i.e., PTD_CNTRCT) to ORGANIZATION_TYPE;
/***********************************************************************;*/

data out_lib.base_&year._transpose_8 (drop=ORGANIZATION_TYPE);
set in_lib.base_&year._transpose_7 (drop=CONTRACT_ID);
	array _d(*) _1 -- _2032;
	do i = 1 to dim(_d);
		if _d{i} ~= '' then _d{i} = ORGANIZATION_TYPE;
	end;
	drop i;
run;

/***********************************************************************;*/

array _d(*) variable_1 variable_2 ;
array _d2(*) variable_mark_1 variable_mark_2;
do i = 1 to dim(_d);
	if _d{i}=. then _d2{i}=0;
	else if _d{i}<0 then _d2{i}=1;
	else if _d{i}=0 then _d2{i}=2;
	else if _d{i}>0 then _d2{i}=3;
end;
drop i;

/***********************************************************************;*/
/* Note:
/* - The variables listed below in the following let macro variables,
/* -- are segmented by variable type ;
/* - The macro variables will be used in a cleaning process inside of a data step.
/***********************************************************************;*/

%let pt_rename=date_1=date_1_temp date_2=date_2_temp date_3=date_3_temp;
%let pt_date1= date_1_temp date_2_temp date_3_temp ;
%let pt_date2= date_1 date_2 date_3;
%let pt_char1= char_variable_1 char_variable_2 char_variable_3;
%let pt_num1= num_variable_1 num_variable_2;

/***********************************************************************;*/
/* Note: the array below has been partially reworked to make generic
/* - The number of variables stated in the array statements are NOT correct
/* -- (kept for reference)
/***********************************************************************;*/

DATA data_out.dataset_tempb&CYEAR;
	LENGTH variable_1 8. variable_2 $6.;
SET data_in.dataset_tempa&CYEAR (&obs1. rename=(&pt_rename.));
	ARRAY d1(3) &pt_date1.;
	ARRAY d2(3) &pt_date2.;
	ARRAY c1(3) &pt_char1.;
	ARRAY n1(2) &pt_num1.;
	DO i=1 to 33; d2(i)= datepart(d1(i)); end;
	DO i=1 to 102; if c1(i) in ('~','^') then c1(i)=''; c1(i)=left(trim(c1(i))); end;
	DO i=1 to 12; if n1(i)=. then n1(i)=0; end;
	FORMAT variable_1 15.2 variable_2 $6. &pt_date2. MMDDYY10.;
	INFORMAT variable_1 15.2 variable_2 $6. &pt_date2. MMDDYY10.;
	LABEL date_variable_1='date_variable_1 label' date_variable_2='date_variable_2 label' ;
	%MACRO DO_LABEL (n); %DO i=1 %TO &n; PRCDR_DT&i = ''PRCDR_DT&i'' %END; %MEND DO_LABEL; LABEL %DO_LABEL(25);
	LENGTH &pt_date2. 4.;
	DROP &pt_date1. i;

/***********************************************************************;*/
/* Note: another way to accomplish the above;
/***********************************************************************;*/

%let pt_date1=date_1_temp date_2_temp date_3_temp;
%LET CLEAN_DATE_CNT=%SYSFUNC(COUNTW(&PTA_DATE1));
%let pt_date2=date_1 date_2 date_3;
ARRAY DATEOUT &pt_date2;
ARRAY DATEIN &pt_date1;
DO I = 1 TO &CLEAN_DATE_CNT;
	DATEOUT(I)= DATEPART(DATEIN(I));
END;
ARRAY CHAR_CLEAN &PTA_CHAR1;
DO J=1 to &CLEAN_CHAR_CNT;
	CHAR_CLEAN(J) = LEFT(TRIM(TRANSLATE(CHAR_CLEAN(J),'' '',BYTE(0))));
	IF CHAR_CLEAN(J) IN ('~','^') THEN CHAR_CLEAN(J)='';
END;
ARRAY NUM_CLEAN &PTA_NUM1;
DO K = 1 TO &PTA_CLEAN_NUM_CNT;
	IF NUM_CLEAN(K) = . THEN NUM_CLEAN(K) = 0;
END;
char_var_4 = CAT(char_var_1,char_var_2,char_var_3);
DROP &pt_date1 I J K;

/***********************************************************************;*/
/***********************************************************************;*/
/***********************************************************************;*/
/***********************************************************************;*/
/* Note: The array below is code that will match multiple columns of one dataset
/* - with unique rows of another dataset.
/***********************************************************************;*/

proc sort
	data=pdplnchr.plan_char_&year. nodupkey
	out=plan_char_&year. (
	keep=contract_id organization_type) ;
	by contract_id;
run;

/***********************************************************************;*/
/* Note: creates a new column called fmtname and ;
/***********************************************************************;*/

data fmt;
	retain fmtname ''$cntrtfmt'';
set plan_char_&year. (rename=(contract_id=start organization_type=label));
run;

/***********************************************************************;*/
/* Note: The most robust method available for migrating user-defined format libraries
/* - is PROC FORMAT with the CNTLOUT= and CNTLIN= options.
/* - With this method,
/* -- all of the information needed to recreate a format library is written out to a SAS data set.
/* -- The SAS data set is called a ''control data set''.
/* -- The file is then transferred to the receiving site where the process is reversed
/* -- and the format catalog is recreated using PROC FORMAT and the CNTLIN= option.;
/* - Said another way…;
/* -- CNTLIN=input-control-SAS-data-set
/* -- specifies a SAS data set from which PROC FORMAT builds informats and formats.
/* -- CNTLIN= builds formats and informats without using a VALUE, PICTURE, or INVALUE statement.
/* -- If you specify a one-level name, the procedure searches only the default data library
/* -- (either the WORK data library or USER data library)
/* -- for the data set, regardless of whether you specify the LIBRARY= option.;
/* - Said by Aaron…
/* -- This process and the one above created formats that would apply the unique value to an array below;
/* -- Completely goes around the need to merge the plan_char file with the dual_base file by CONTRACT_ID;
/***********************************************************************;*/

proc format library=work cntlin=fmt;
run;

/***********************************************************************;*/
/* Note: This datastep assigns the org_type value based on the ptd_cntrct value
/***********************************************************************;*/

data dual_org_&year._HUI;
set out.dual_base_&year.;
	array cntrct(12)
		ptd_cntrct_jan_id ptd_cntrct_feb_id ptd_cntrct_mar_id ptd_cntrct_apr_id ptd_cntrct_may_id ptd_cntrct_jun_id
		ptd_cntrct_jul_id ptd_cntrct_aug_id ptd_cntrct_sept_id ptd_cntrct_oct_id ptd_cntrct_nov_id ptd_cntrct_dec_id ;
	array org_type(12) $2 org_type1 - org_type12;
	do i=1 to 12;
		org_type(i) = put(cntrct(i), $cntrtfmt2.);
	end;
run;

/***********************************************************************;*/
/**EndProgramSection**/
/***********************************************************************;*/

/***********************************************************************;*/
/* The DIM function returns the number of literal elements in an array.
/* It functions against multi-dimensional arrays as well as one-dimensional arrays.;
/***********************************************************************;*/
/* 1-dimensional array example;
/***********************************************************************;*/

DIM(array_name)

/***********************************************************************;*/
/* Multi-dimensional array examples
/***********************************************************************;*/

DIM(m_array) -> returns the number of elements in the first dimension of the array

DIM5(m_array) -> returns the number of elements in the 5th dimension of the array

DIM(m_array, 5) -> returns the number of elements in the 5th dimension of the array

/***********************************************************************;*/
/* The classic use case for the DIM function
/* is to return the number of elements in an array for the upper bound of a do loop process.
/* Example:
/***********************************************************************;*/

array array_name(5) var1 var2 var3 var4 var5;

do i = 1 to dim(array_name);
	some SAS statements here
end;

/***********************************************************************;*/
/*EndProgram
/***********************************************************************;*/