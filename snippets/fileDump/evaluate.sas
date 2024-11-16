
/***********************************************************************;*/

%let CYEAR = 2017;
%let eval_CYEAR_plus_two = %eval(&CYEAR+2);
%put eval_CYEAR_plus_two: &eval_CYEAR_plus_two.;

/*output: eval_CYEAR_plus_two: 2019*/

/***********************************************************************;*/

%if &bdir2. ne %then %do;
	proc sort
		data = &bdir2..test_in_%eval(&cyear. + 1) (
		keep = var_01 var_02 var_03
		rename = (month_var_01 = month_var_13))
		out = test_out_%eval(&cyear. + 1)
		noequals;
	by bene_id;
	run;
%end;

/***********************************************************************;*/

http://support.sas.com/documentation/cdl/en/mcrolref/61885/HTML/default/viewer.htm#a000208971.htm

%let d = %eval(10+20); /* Correct usage */
%let d = %eval(10.0+20.0); /* Incorrect usage */

/***********************************************************************;*/

%let a = 1 + 2;
%let b = 10*3;
%let c = 5/3;
%let eval_a = %eval(&a);
%let eval_b = %eval(&b);
%let eval_c = %eval(&c);

%put &a is &eval_a;
%put &b is &eval_b;
%put &c is &eval_c;

/***********************************************************************;*/

macro y();
	%let input_year = 2012;
	%do yyyy = &input_year. %to &input_year.;
		%let yy = %substr(&yyyy,3,2);
		%let yyyy2 = %eval(&yyyy+1);
		%let yy2 = %substr(&yyyy2,3,2);
%mend y;
%y();

/***********************************************************************;*/

%macro figureit(a,b);
	%let y = %sysevalf(&a+&b);
	%put The result with SYSEVALF is: &y;
	%put The BOOLEAN value is: %sysevalf(&a +&b, boolean);
	%put The CEIL value is: %sysevalf(&a +&b, ceil);
	%put The FLOOR value is: %sysevalf(&a +&b, floor);
	%put The INTEGER value is: %sysevalf(&a +&b, int);
%mend figureit;
%figureit(100,1.597);

/***********************************************************************;*/

%macro varargs / parmbuff;
	%let arglist = &syspbuff;
	%let argn = 1;
	%let argv = %qscan(&arglist, &argn, %str((,)));
	%do %while (%eval(&argv ne));
		%let arg&argn = &argv;
		%let argn = %eval(&argn+1);
		%let argv = %qscan (&arglist, &argn, %str((,)));
	%end;
	%let argn = %eval(&argn – 1);
	%do i=1 %to &argn;
		&&&arg&i
		%if %eval(&i < &argn) %then ,;
	%end;
%mend varargs;

/***********************************************************************;*/
/* Note:
(sum(0.4614, tenure*0.0482, slack*0.6375, male*-0.2168, married*0.2940, yrdispl*-0.0476))
/***********************************************************************;*/

%macro deploy_logistic_model/parmbuff;
	%let arglist = &syspbuff;
	%let predictor_w_coeff2 = %sysfunc(sum(%varargs(&arglist)));

	libname libref “\\vmware\\sasDesktop”;

	data unemploy_lr_wk3_tempd_deploy1;
	length unique_key 4. new_var_1 aago_predict_prob 8.;
	set libref.unemp_week_3;
		unique_key = _n_;
		new_var_1 = &predictor_w_coeff2;
		aago_predict_prob = 1 / (1 + exp(new_var_1));
	run;
%mend deploy_logistic_model;
%deploy_logistic_model(
	2 * 0.0482
	,0.6375
	,-0.2168
	,0.2940
	,-0.0476);

/***********************************************************************;*/
/*EndProgram
/***********************************************************************;*/
