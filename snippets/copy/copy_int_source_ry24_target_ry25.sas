
/**Intermediate Required for completeness */
%let projects_root=%str(&myfiles_root/OEDA_Prod/Projects);
%let pac_puf_root=%str(MUP-Medicare Provider Utilization and Payment/MUP_PAC-Post-Acute Care);
%let ry24_int_root=%str(RY24-Release Year 2024/Data/Intermediate);
%let ry25_int_root=%str(RY25-Release Year 2025/Data/Intermediate);

%let run_m01=0;
/*NOTE: MUST DELETE SAME OUTPUT NAME DATASETS IN TARGET BEFORE RUNNING m02*/
%let run_m02=1;

%let start_year=2014;
%let end_year=2016;

%macro m00;
	%let start_yr=%eval(&start_year-2000);
	%let end_yr=%eval(&end_year-2000);
	
	%macro m01(ds_ext_01=, ds_ext_02=);
		libname source "&projects_root./&pac_puf_root./&ry25_int_root.";
		libname target "&projects_root./&pac_puf_root./&ry25_int_root./20250302";
		
		%let ry=25;

		%do dy=&start_yr. %to &end_yr.;
			proc copy in=source out=target;
				select
					mup_pac_ry&ry.&ds_ext_01.&dy.&ds_ext_02.;
			run;
		%end;
	%mend m01;
	%if &run_m01.=1 %then %do;
		%m01(ds_ext_01=_p22_v10_cy, ds_ext_02=_cc);
		%m01(ds_ext_01=_p23_v10_dy, ds_ext_02=_sn_as1);
		%m01(ds_ext_01=_p23_v10_dy, ds_ext_02=_sn_as2);
		%m01(ds_ext_01=_p24_v10_dy, ds_ext_02=_ir_as);
	%end;

	%macro m02(ds_ext_01=, ds_ext_02=);
		libname source "&projects_root./&pac_puf_root./&ry24_int_root.";
		libname target "&projects_root./&pac_puf_root./&ry25_int_root.";
		
		%let ry=24;
		%let ry_out=25;

		%do dy=&start_yr. %to &end_yr.;
			proc copy in=source out=target;
				select
					mup_pac_ry&ry.&ds_ext_01.&dy.&ds_ext_02.;
			run;
			/* Rename the copied dataset */
			proc datasets library=target nolist;
				change
					mup_pac_ry&ry.&ds_ext_01.&dy.&ds_ext_02.
					= mup_pac_ry&ry_out.&ds_ext_01.&dy.&ds_ext_02.;
			quit;
		%end;
	%mend m02;
	%if &run_m02.=1 %then %do;
		%m02(ds_ext_01=_p22_v10_cy, ds_ext_02=_cc);
		%m02(ds_ext_01=_p23_v10_dy, ds_ext_02=_sn_as1);
		%m02(ds_ext_01=_p23_v10_dy, ds_ext_02=_sn_as2);
		%m02(ds_ext_01=_p24_v10_dy, ds_ext_02=_ir_as=);
	%end;
%mend m00;
%m00;

/**endProgram */