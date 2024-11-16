Create test dataset:
Remember that Day 0 in SAS is January 1st, 1960

data test_01;
	do i = -50 to 50;
		dob = i * 365;
		format dob mmddyy8.;
		year_dob = year(dob);
		output;
	end;
run;
2 ways to process a Means Procedure:
proc means
	data = test_01
		n sum min p5 p25 mean p75 p95 max std maxdec = 0;
	var year_dob;
run;

proc means data = test_01 noprint maxdec = 0;
	var year_dob;
	output out = test_02 (drop=_:)
	min(year_dob) = min_year_dob
	p5(year_dob) = p5_year_dob
	p25(year_dob) = p25_year_dob
	mean(year_dob) = mean_year_dob
	p75(year_dob) = p75_year_dob
	p95(year_dob) = p95_year_dob
	max(year_dob) = max_year_dob
	std(year_dob) = std_year_dob;
run;
Transpose from wide to narrow:
proc transpose
	data = test_02
	out = test_03 (
		rename = (
			_name_ = var_value
			col1 = M202002));
run;
Output Data:
var_value	M202002
min_year_dob	1910
p5_year_dob	1915
p25_year_dob	1935
mean_year_dob	1959.504951
p75_year_dob	1984
p95_year_dob	2004
max_year_dob	2009
std_year_dob	28.86611292

/************************************************************************************;*/
/* Note: Another transpose idea... 
/* - create a time series dataset that can be evaluated by proc gplot
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

/************************************************************************************;*/

data test_01;
	do i = 1 to 8;
		if i in (1,4) then var_01 = 'a';
		else if i in (2,3) then var_01 = 'b';
		else if i in (5) then var_01 = 'c';
		else if i in (6,7,8) then var_01 = 'd';
		output;
	end;
run;

proc freq
	data = test_01
		noprint;
	tables
		var_01
		/ missing nocol norow nocum nopct format = comma15.
		out = test_02;
run; 

proc transpose
	data = test_02 (
		drop = percent
		rename = (count = dataset_ref_2017_02))
	out = test_03 (
		drop = _label_
		rename = (
			_name_ = dataset_eval))
	prefix = var_val_;
	id var_01;
run;


/************************************************************************************;*/

%macro macro_04();
	%do yyyy = 2017 %to 2017;
		%do i = 1 %to 2;
			%if &i < 10 %then %do;
				%let i_char = 0%eval(&i);
			%end;
			%else %do;
				%let i_char = %eval(&i);
			%end;
			
			data test_01_&i_char.;
				do i = 1 to 8;
					if i in (1,4) then var_01 = 'a';
					else if i in (2,3) then var_01 = 'b';
					else if i in (5) then var_01 = 'c';
					else if i in (6,7,8) then var_01 = 'd';
					output;
				end;
			run;
			
			proc freq
				data = test_01_&i_char.
					noprint;
				tables
					var_01
					/ missing nocol norow nocum nopct format = comma15.
					out = test_02_&i_char.;
			run; 
			
			proc transpose
				data = test_02_&i_char. (
					drop = percent
					rename = (count = dataset_ref_&yyyy._&i_char.))
				out = test_03_&i_char. (
					drop = _label_
					rename = (
						_name_ = dataset_eval))
				prefix = var_val_;
				id var_01;
			run;
		%end;
	%end;
	data test_03;
	set
		test_03_01
		test_03_02;
	run;
	
%mend macro_04;
%macro_04();

/************************************************************************************;*/
/*endProgram
/************************************************************************************;*/
