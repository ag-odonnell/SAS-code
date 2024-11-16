
/************************************************************************************;*/

%let eval_date = %sysfunc(mdy(2,1,17));
%put eval_date: &eval_date.;

/*output: eval_date: 20851 (i.e., the sas date for Feb 1, 2017*/

proc means data = test_01;
	where ~(process_date in (%sysfunc(mdy(2,1,17)), %sysfunc(mdy(&end_mo,1,&end_yr))));
	var delta_var_01;
	output out = test_02 (drop=_:)
	mean(delta_var_01) = mean_delta_var_01
	std(delta_var_01) = std_delta_var_01;
run;

/************************************************************************************;*/

/*incorporate the following code into a do looop*/
*date = intnx( 'month', '31dec1948'd, _n_ );

data test_01;
	do i = 1 to 10;
		date = intnx( 'month', '31dec2020'd, i );
		format date monyy.;
		output;
	end;
run;

data test_02;
set test_01;
where date >= '1may21'd;
run;

/************************************************************************************;*/
/*endProgram
/************************************************************************************;*/
