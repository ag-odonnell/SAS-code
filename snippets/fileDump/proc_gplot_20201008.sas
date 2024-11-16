
/************************************************************************************;*/
/* Note: Another transpose idea... 
/* - create a time series dataset that can be evaluated by proc gplot
/* - https://support.sas.com/rnd/app/ets/examples/gplot/index.html
/************************************************************************************;*/

%macro macro_01;
	data test_01;
		array d_1(*) num_var_01 - num_var_15; 
		do i = 1 to 3;
			if i = 1 then do;
				do j = 1 to dim(d_1);
					d_1(j) = j;
				end;
			end;
			else if i = 2 then do;
				do j = 1 to dim(d_1);
					if j < 10 then do;
						d_1(j) = input(strip(compress(cat('2019','0',put(j,3.)))),6.);
					end;
					else if j < 13 then do;
						d_1(j) = input(strip(compress(cat('2019',put(j,3.)))),6.);
					end;
					else do;
						d_1(j) = input(strip(compress(cat('2020','0',put(j-12,3.)))),6.);
					end;
				end;
			end;
			else do;
				do j = 1 to dim(d_1);
					d_1(j) = j * 100 / j**2;
				end;
			end;
			output;
		end;
		drop i j;
	run;
%mend macro_01;
%macro_01;

%macro macro_02;
	data test_02;
	set test_01 (
		keep = num_var_01 -- num_var_15); /*The double dash signifies that variables must be layed out in this order...*/
		if _n_ in (2,3) then output;
	run;

	proc transpose
		data = test_02
		out = test_02_transposed (
			rename = (
				_name_ = var_value
				col1 = yyyymm
				col2 = var_to_evaluate));
	run;
	
	data test_02_transposed;
	set test_02_transposed;
		yyyymm_char = strip(put(yyyymm,8.));
		process_month = mdy(input(substr(yyyymm_char,5,2),2.),1,input(substr(yyyymm_char,1,4),4.));
		format process_month mmddyy8.;
	run;
%mend macro_02;
%macro_02;

libname aa_local "P:\data\adhoc_output"; /*Notice that the gplot works on SAS9.4 without workaround options (not readily available on current SASEG setup)*/
*%let dataset_plot_name = aa_local.test_02_transposed;
%let dataset_plot_name = test_02_transposed; /*this output is generated in workspace, no need for aa_local libref assignment*/
%let var_01 = var_to_evaluate;
%let var_02 = var_to_evaluate;
%let href_line = '01aug19'd;
%let plot_title = Random Base Data to Evaluate;
%let plot_subtitle = Monthly Values;
%let xref_axis_label = Monthly Data;
%let xref_axis_scale = '01jan19'd to '01mar20'd by month;
%let yref_axis_label = Monthly Values: Take a Look See;
%let yref_axis_scale = 0 to 110 by 10;
%let symbol_label_01 = --- Look at the line graph;
%let symbol_label_02 = * Look at the actual data points;

%macro macro_03;
	goptions cback=white ctitle=bl ctext=bl ftitle=centx ftext=centx reset=(axis symbol);
		proc gplot
			data=&dataset_plot_name.;
			format process_month yymmn6.;
			plot
				&var_01.*process_month=1
				&var_02.*process_month=2
				/ overlay
					haxis=axis1
					vaxis=axis2
					vminor=4
					href=&href_line.
					lh=2;
			title  "&plot_title.";
			title2 "&plot_subtitle.";
			axis1
				offset=(1 cm)
				label=("&xref_axis_label.")
				order=(&xref_axis_scale.);
			axis2
				label=(angle=90 "&yref_axis_label.")
				order=(&yref_axis_scale.);
			symbol1 i=join l=1 c=red;
			symbol2 h=2 pct v=star c=blue;
			footnote1
				c=r f=centx  " &symbol_label_01."
				c=b f=centx  " &symbol_label_02.";
		run;
		quit;
		title;
		footnote;
%mend macro_03;
%macro_03;


%macro macro_04;
	proc gplot
		data=test_02_transposed;
		plot var_to_evaluate*process_month=1;
		symbol1 v=star c=blue;
		title "Time Series Plot";
	run;
	quit;
	title;

%mend macro_04;
%macro_04;

%macro macro_05;
	%let lib_ref_path_01 = /sas/.../input_dir_01;
	filename graphout "&lib_ref_path_01./test_02_graph.gif";
	goptions reset=all device=gif gsfname=graphout;
	ODS _all_ CLOSE;
	ODS LISTING;
		proc gplot
			data=test_02_transposed;
			plot var_to_evaluate*process_month=1;
			symbol1 v=star c=blue;
			title "Time Series Plot";
		run;
		quit;
		title;
	ODS LISTING CLOSE;
%mend macro_05;
%macro_05;

/************************************************************************************;*/
/*endProgram
/************************************************************************************;*/
