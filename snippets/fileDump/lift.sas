/*SAS lift*/
/* Note:
/* – Unemployment Data Analysis-Logistic Regression
/* Note: This program will illustrate the Newton-Raphson method for
/* – finding estimates of Beta in the logistic model.
/* – We will make use of the unemployment data found in the Wiley website*/

%let test_switch=1; *<== Note: 1=ON – 0=OFF – switch to test code;
%let pgm_dir_str =;
%let data_dir_str =;
libname aago “&data_dir_str.”;

/***********************************************************************;*/*/

options pagesize=MAX sumsize=MAX center symbolgen mprint mlogic;

/***********************************************************************;*/*/

%let section_01_switch=0; *<==Note: 1=ON – 0=OFF switch – Conduct multiple linear regression;
%let section_02_switch=0; *<==Note: 1=ON – 0=OFF switch – Proc Plot to generate the graphs;
%let section_03_switch=0; *<==Note: 1=ON – 0=OFF switch – computation of the White test for Heteroscedasticity.;

/***********************************************************************;*/*/
/* – Note: Dummy macro to enable the use of macro variable conditional logic
/***********************************************************************;*/*/

%macro p();
	%if §ion_01_switch.=1 %then %do; %include “&pgm_dir_str./p01_model_deploy.sas” /nosource2; %end;
	%if §ion_02_switch.=1 %then %do; %include “&pgm_dir_str./p02_lift_calc.sas” /nosource2; %end;
	%if §ion_03_switch.=1 %then %do; %include “&pgm_dir_str./p03_lift_deploy_compare.sas” /nosource2; %end;
%mend;
%p;

/***********************************************************************;*/
/**EndProgram**;
/***********************************************************************;*/*/

/***********************************************************************;*/

%let test_switch=1; *<== Note: 1=ON – 0=OFF – switch to test code;
%let pgm_dir_str =;
%let data_dir_str =;
libname aago “&data_dir_str.”;

/***********************************************************************;*/

options pagesize=MAX sumsize=MAX center symbolgen mprint mlogic;

%macro i();

	/***********************************************************************;*/

	%if &test_switch.=1 %then %do;
		%let obs1=obs=5;
		%let obs2=inobs=5;
	%end;
	%else %do;
		%let obs1=;
		%let obs2=;
	%end;

	/***********************************************************************;*/
	/******************************************************************************************;
	/* Note: what does the original dataset look like
	/***********************************************************************;*/
	/*
	proc contents data=aago.unemp_week_3; run;
	proc print data=aago.unemp_week_3 (obs=5); run;

	/***********************************************************************;*/

	%macro deploy_logistic_model(
		response_var_1 =
		,predictor_var =
		,predictor_w_coeff =
		,deploy_dataset =
		,num_var_discrete_1 =
		,num_var_contin_1 =
		,char_var_1 =);

		/***********************************************************************;*/
		/*
		proc freq data = aago.unemp_week_3;
		tables &num_var_discrete_1. / missing list;
		run;

		proc univariate data = aago.unemp_week_3;
		var &num_var_contin_1.;
		run;

		/***********************************************************************;*/
		/* Note: Rerun final model to validate the AIC/SC(Schwartz) values
		/* – and coefficients to be deployed in data step.
		/***********************************************************************;*/

		data unemploy_lr_wk3_tempd_deploy&deploy_dataset.;
			length unique_key 4. aago_predict_prob 8.;
		set aago.unemp_week_3;
			unique_key = _n_;
			u = uniform(123);
			train = (u < 0.7); *<==create train with (1,0) values;
			/*if a16=’+’ then y=1; else if a16=’-‘ then y=0; else y=.;*/
			if (train = 1) then Y_train = &response_var_1.;
			else Y_train = .; *<==Create a training/testing response indicator;

			/***********************************************************************;*/

			mark_null = 0;
			/*array _d1(*) &char_var_1.; do i = 1 to dim(_d1); if _d1{i}=’?’ then mark_null=1; end; drop i;*/
			array _d2(*)
				&num_var_discrete_1.;
			do i = 1 to dim(_d2);
				if _d2{i}=. then mark_null= 1;
			end;
			drop i;

			/******************************************************************************************;
			/* Note: yhat=(1-aago_predict_prob)
			/***********************************************************************;*/
			/*
			%let logit_predict_vars =
			(0.4614 + tenure*0.0482 + slack*0.6375 + male*-0.2168 + married*0.2940 + yrdispl*-0.0476);
			%let logit_predict_vars =
			(-1.8699 + age*0.0211 + tenure*0.0330 + slack*0.5862 + stateur*0.1268 + statemb*0.00286);
			%let logit_predict_vars =
			(-2.8005 + rr*3.0681 + rr2*-4.8906 + age*0.0677 + age2*-0.00597
			+ tenure*0.0312 + slack*0.6248 + abol*-0.0362 + seasonal*0.2709
			+ head*-0.2107 + married*0.2423 + dkids*-0.1579 + dykids*0.2059
			+ smsa*-0.1704 + nwhite*0.0741 + yrdispl*-0.0637 + school12*-0.0653
			+ male*-0.1798 + stateur*0.0956 + statemb*0.00603);
			/***********************************************************************;*/

			%let logit_predict_vars =
				(-2.8005 + rr*3.0681 + rr2*-4.8906 + age*0.0677 + age2*-0.00597
				+ tenure*0.0312 + slack*0.6248 + abol*-0.0362 + seasonal*0.2709
				+ head*-0.2107 + married*0.2423 + dkids*-0.1579 + dykids*0.2059
				+ smsa*-0.1704 + nwhite*0.0741 + yrdispl*-0.0637 + school12*-0.0653
				+ male*-0.1798 + stateur*0.0956 + statemb*0.00603);
				aago_predict_prob = 1 / (1 + exp(&logit_predict_vars.));

			/***********************************************************************;*/

			if mark_null ~= 1;

			/***********************************************************************;*/

		run;

		/***********************************************************************;*/

		proc print
			data = unemploy_lr_wk3_tempd_deploy&deploy_dataset. (
			obs = 5
			keep =
			unique_key
			&response_var_1.
			aago_predict_prob
			&predictor_var.
			train
			y_train);
		run;

		/***********************************************************************;*/

	%mend deploy_logistic_model;

	/***********************************************************************;*/
	/* Note: I cannot figure out how to pass the model below to a macro variable
	/* – That can be interpreted by the exp function
	/* — predictor_w_coeff=(0.4614 + tenure*0.0482 + slack*0.6375 + male*-0.2168 + married*0.2940 + yrdispl*-0.0476)
	/***********************************************************************;*/
	/*
	%deploy_logistic_model(
		response_var_1=y
		,predictor_var=tenure slack male married yrdispl
		,predictor_w_coeff=
		,deploy_dataset=1
		,num_var_discrete_1=y slack abol seasonal nwhite school12 male
		bluecol smsa married dkids dykids head
		,num_var_contin_1= stateur statemb state age age2 tenure rr rr2 yrdispl
		,char_var_1=);

	/***********************************************************************;*/
	/* — predictor_w_coeff=(-1.8699 + age*0.0211 + tenure*0.0330 + slack*0.5862 + stateur*0.1268 + statemb*0.00286)
	/***********************************************************************;*/
	/*
	%deploy_logistic_model(
		response_var_1=y
		,predictor_var=age tenure slack stateur statemb
		,predictor_w_coeff=
		,deploy_dataset=2
		,num_var_discrete_1=y slack abol seasonal nwhite school12 male
		bluecol smsa married dkids dykids head
		,num_var_contin_1= stateur statemb state age age2 tenure rr rr2 yrdispl
		,char_var_1=);

	/***********************************************************************;*/
	/* predictor_w_coeff=
		(-2.8005 + rr*3.0681 + rr2*-4.8906 + age*0.0677 + age2*-0.00597
		+ tenure*0.0312 + slack*0.6248 + abol*-0.0362 + seasonal*0.2709
		+ head*-0.2107 + married*0.2423 + dkids*-0.1579 + dykids*0.2059
		+ smsa*-0.1704 + nwhite*0.0741 + yrdispl*-0.0637 + school12*-0.0653
		+ male*-0.1798 + stateur*0.0956 + statemb*0.00603)
	/***********************************************************************;*/

	%deploy_logistic_model(
		response_var_1 = y
		,predictor_var = rr rr2 age age2 tenure slack abol
		seasonal head married dkids dykids smsa nwhite
		yrdispl school12 male stateur statemb
		,predictor_w_coeff =
		,deploy_dataset = 3
		,num_var_discrete_1 = y slack abol seasonal nwhite school12 male
		bluecol smsa married dkids dykids head
		,num_var_contin_1 = stateur statemb state age age2 tenure rr rr2 yrdispl
		,char_var_1 = );

	/***********************************************************************;*/

%mend;
%i;

/***********************************************************************;*/
/**EndProgramNode**;
/***********************************************************************;*/

/******************************************************************************************;
/* Note: – Fit the Model
/* – MODEL #1
/* — Find the optimal model using backward variable selection.
/* —- This logistic procedure below is building the model using the in-sample/training data
/* – MODEL #2 – Fit the Model of manager
/* — How does it compare to the model that was defined using backward selection.
/* — This logistic procedure below is assessing the model using the in-sample/training data
/***********************************************************************;*/

%let test_switch = 1; *<== Note: 1=ON – 0=OFF – switch to test code;

%macro i();

	/***********************************************************************;*/

	%if &test_switch.= 1 %then %do;
	%let obs1 = obs = 5;
	%let obs2 = inobs = 5;
	%end;
	%else %do;
	%let obs1 =;
	%let obs2 =;
	%end;

	/***********************************************************************;*/

	%macro define_logistic_model(
		p =
		,define_param =
		,model_ds_out =
		,scores_ds_out_1 =
		,scores_ds_out_2 =
		,lift_ds_out =
		,success_num =
		,in_out_sample =
		,model_set =
		,data_set =
		,deploy_dataset = );

		title “&model_set.: &data_set.”;

		proc logistic
			data = unemploy_lr_wk3_tempd_deploy&deploy_dataset.
			descending;
			model
			Y_train = &p.
			&define_param.;
			output
			out = &model_ds_out.
			pred = yhat; *<==yhat is the probability that row was approved;
		run;

		proc print data = &model_ds_out. (obs = 10); run;

		/******************************************************************************************;
		/* Note: – Assessing the Predictive Accuracy
		/* – assess the predictive accuracy of model by creating a lift chart
		/* – Compute the respective Kolmogorov-Smirnov test statistic
		/* – First use proc rank to rank the variables across rows and
		/* — group into deciles.(i.e., groups=10)
		/* — The descending option assigns from the highest to lowest score to create score_decile
		/* —- by ranking this way,
		/* —- the row with the highest probability of approval is moved to the top of the dataset,
		/* —- grouped in the top decile (in this case score_decile=0)
		/* —- and used to calculate a lift value for the decile
		/***********************************************************************;*/

		proc rank
			data = &model_ds_out.
			out = &scores_ds_out_1.
			descending
			groups = 10;
			var yhat;
			ranks score_decile;
			where train = &in_out_sample.;
		run;

		/******************************************************************************************;
		/* Note: Create the lift chart
		/* – pred_rate equals the number of approvals/successes predicted by the model
		/* — divided by the number of approvals/successes experienced in the training/testing data
		/***********************************************************************;*/

		proc means
			data = &scores_ds_out_1.
			sum;
			class score_decile;
			var Y;
			output out = &scores_ds_out_2.
			sum(Y) = Y_Sum;
		run;

		proc print data = &scores_ds_out_2.; run;

		/******************************************************************************************;
		/* Note: Create macro variable that populates with the count of approvals (Y_Sum)
		/* – Y_Sum was created in the Means procedure
		/***********************************************************************;*/

		data &scores_ds_out_2.;
		set &scores_ds_out_2.;
			if _TYPE_ = 0 then do;
			call symput(“approval_count”,Y_Sum);
			end;
		run;

		proc sort data = &scores_ds_out_2.;
		by _type_;
		run;

		data &lift_ds_out.;
		set &scores_ds_out_2. (
		where = (_type_ = 1));
		by _type_;
			Nobs = _freq_;
			score_decile = score_decile + 1;
			if first._type_ then do;
				cum_obs = Nobs;
				model_pred = Y_Sum;
			end;
			else do;
				cum_obs = cum_obs + Nobs;
				model_pred = model_pred + Y_Sum;
			end;
			retain cum_obs model_pred;

			pred_rate = model_pred / &approval_count./*&success_num.*/;
			base_rate = score_decile * 0.1;
			lift = pred_rate – base_rate;
			drop _freq_ _type_ ;
		run;

		proc print data = &lift_ds_out.; run;

			/******************************************************************************************;
			/* Note: Plot the lift chart
			/* –
			/***********************************************************************;*/

		ods graphics on;
			axis1 label = (angle = 90 ‘% Captured from Target Population’);
			axis2 label = (‘Total Population’);
			legend1 label = (color = black height = 1 ”)
			value = (color = black height = 1 “&model_set.” ‘Random Guess’);
			title “&model_set.: &data_set. Lift Chart”;
			symbol1 color = green interpol = join w = 2 value = dot height = 1;
			symbol2 color = black interpol = join w = 2 value = dot height = 1;
			proc gplot
				data = &lift_ds_out.;
				plot
				pred_rate * base_rate base_rate * base_rate / overlay
				legend = legend1 vaxis = axis1 haxis = axis2;
			run;
			quit;
		ods graphics off;

		/***********************************************************************;*/

	%mend define_logistic_model;

	/******************************************************************************************;
	/* Note: Find scaling factor
	/* — 201 is the scaling factor for the in-sample lift chart.
	/* – This is AaGO observed potential list of predictors with notable differences
	/* – Orginal use of success_num was to manually define as follows,success_num=/*201*/
	/***********************************************************************;*/
	/*
	%define_logistic_model(
		p=tenure slack male married yrdispl
		,define_param=/ selection=forward
		,model_ds_out=model_data_1
		,scores_ds_out_1=training_scores_1a
		,scores_ds_out_2=training_scores_1b
		,lift_ds_out=lift_chart_1
		,success_num=
		,in_out_sample=1
		,model_set=Model #1
		,data_set=In-Sample
		,deploy_dataset=1);

	/***********************************************************************;*/
	/*
	%define_logistic_model(
		p=aago_predict_prob
		,define_param=
		,model_ds_out=model_data_3
		,scores_ds_out_1=training_scores_3a
		,scores_ds_out_2=training_scores_3b
		,lift_ds_out=lift_chart_3
		,success_num=
		,in_out_sample=1
		,model_set=Model #3 (Deploy Model #1)
		,data_set=In-Sample
		,deploy_dataset=1);

	/***********************************************************************;*/
	/* – This is the best=5 forward selection
	/***********************************************************************;*/
	/*
	%define_logistic_model(
		p=age tenure slack stateur statemb
		,define_param=/ selection=forward
		,model_ds_out=model_data_2
		,scores_ds_out_1=training_scores_2a
		,scores_ds_out_2=training_scores_2b
		,lift_ds_out=lift_chart_2
		,success_num=
		,in_out_sample=1
		,model_set=Model #2
		,data_set=In-Sample
		,deploy_dataset=2);

	/***********************************************************************;*/
	/*
	%define_logistic_model(
		p=aago_predict_prob
		,define_param=
		,model_ds_out=model_data_4
		,scores_ds_out_1=training_scores_4a
		,scores_ds_out_2=training_scores_4b
		,lift_ds_out=lift_chart_4
		,success_num=
		,in_out_sample=1
		,model_set=Model #4 (Deploy Model #2)
		,data_set=In-Sample
		,deploy_dataset=2);

	/***********************************************************************;*/
	/* – Full model
	/***********************************************************************;*/

	%define_logistic_model(
		p =
		rr rr2 age age2 tenure slack abol
		seasonal head married dkids dykids smsa nwhite
		yrdispl school12 male stateur statemb
		,define_param =
		,model_ds_out = model_data_5
		,scores_ds_out_1 = training_scores_5a
		,scores_ds_out_2 = training_scores_5b
		,lift_ds_out = lift_chart_5
		,success_num =
		,in_out_sample = 1
		,model_set = Model #5
		,data_set = In-Sample
		,deploy_dataset = 3);

	/***********************************************************************;*/

	%define_logistic_model(
		p = aago_predict_prob
		,define_param =
		,model_ds_out = model_data_6
		,scores_ds_out_1 = training_scores_6a
		,scores_ds_out_2 = training_scores_6b
		,lift_ds_out = lift_chart_6
		,success_num =
		,in_out_sample = 1
		,model_set = Model #6 (Deploy Model #3)
		,data_set = In-Sample
		,deploy_dataset = 3);

	/***********************************************************************;*/

%mend;
%i;

/***********************************************************************;*/
/**EndProgramNode**;
/***********************************************************************;*/

/***********************************************************************;*/
/* Note: Compare the proc logistic model to the deployment of its coefficients
/***********************************************************************;*/

%let test_switch = 1; *<== Note: 1 = ON – 0 = OFF – switch to test code;

%macro i();

	/***********************************************************************;*/

	%if &test_switch.= 1 %then %do;
		%let obs1 = obs = 5;
		%let obs2 = inobs = 5;
	%end;
	%else %do;
		%let obs1 =;
		%let obs2 =;
	%end;

	/***********************************************************************;*/
	/*
	proc print data=model_data_1 (obs=10 keep=unique_key y aago_predict_prob tenure slack male married yrdispl train y_train yhat); run;
	proc print data=model_data_3 (obs=10 keep=unique_key y tenure slack male married yrdispl train y_train yhat); run;

	proc print data=model_data_2 (obs=10 keep=unique_key y aago_predict_prob age tenure slack stateur statemb train y_train yhat); run;
	proc print data=model_data_4 (obs=10 keep=unique_key y age tenure slack stateur statemb train y_train yhat); run;

	/***********************************************************************;*/

	%macro compare_lr_deploy(
		model_ds_in_1 =
		,model_ds_in_2 =
		,deploy_dataset = );

		data unemploy_lr_wk3_tempd_deploy&deploy_dataset.;
		merge
			model_data_1 (in = a
				keep = unique_key yhat)
			model_data_3 (in = b
				keep = unique_key yhat
				rename = (yhat = yhat_deploy));
		by unique_key;
			if a and b;
		run;

		ods graphics on;
			title “LOESS Scatterplot compare Deployment vs Forward Selection”;
			proc sgscatter
				data=unemploy_lr_wk3_tempd_deploy&deploy_dataset.;
				compare
					x = yhat_deploy
					y = yhat
					/ loess reg;
				label
					yhat_deploy = ‘yhat_deploy’
					yhat = ‘yhat_forward_selection’;
			run;
			quit;
		ods graphics off;

		/***********************************************************************;*/

	%mend;
	%compare_lr_deploy;

	/***********************************************************************;*/
	/*
	%compare_lr_deploy(
		model_ds_in_1 = model_data_1
		,model_ds_in_2 = model_data_3
		,deploy_dataset = 1);

	/***********************************************************************;*/
	/*
	%compare_lr_deploy(
		model_ds_in_1=model_data_2
		,model_ds_in_2=model_data_4
		,deploy_dataset=2);

	/***********************************************************************;*/

	%compare_lr_deploy(
		model_ds_in_1 = model_data_5
		,model_ds_in_2 = model_data_6
		,deploy_dataset = 7);

	/***********************************************************************;*/

%mend;
%i;

/***********************************************************************;*/
/**EndProgramNode**;
/***********************************************************************;*/
