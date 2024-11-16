/*SAS logistic regression*/
/* Note: yhat=(1-aago_predict_prob)
%let logit_predict_vars = 0.4614 + tenure*0.0482 + slack*0.6375 + male*-0.2168 + married*0.2940 + yrdispl*-0.0476;
%let operator = exp;
aago_predict_prob = %eval(1/(1+(&operator.(&logit_predict_vars.))));
aago_predict_prob=1/(1+exp(0.4614 + tenure*0.0482 + slack*0.6375 + male*-0.2168 + married*0.2940 + yrdispl*-0.0476));
/***********************************************************************;*/

%macro deploy_logistic_model(
	response_var_1 =
	,predictor_var =
	,predictor_w_coeff =
	,deploy_dataset =);

	data unemploy_lr_wk3_tempd_deploy&deploy_dataset.;
		length unique_key 4. aago_predict_prob 8.;
	set aago.unemp_week_3;
		unique_key = _n_;
		aago_predict_prob = 1 / (1 + exp(&predictor_w_coeff.));
	run;
%mend;
%deploy_logistic_model(
	response_var_1 = y
	,predictor_var=tenure slack male married yrdispl
	,predictor_w_coeff=0.4614 + tenure*0.0482 + slack*0.6375 + male*-0.2168 + married*0.2940 + yrdispl*-0.0476
	,deploy_dataset=1);

/***********************************************************************;*/
/**EndProgramNode**
/***********************************************************************;*/