
/************************************************************************************;*/

%let input_start_year = 2017;
%let input_start_month = 02;
%let input_end_year = 2020;
%let input_end_month = 06;

/************************************************************************************;*/

%macro macro_07(start_mo=,start_yr=,end_mo=,end_yr=);
	%let dir_path_data_05 = /sas/vrdc/data/support/GV/GV_DELETE_temp_hold/cme_bene_abcd_copy_for_ml/data/data_out;
	libname aa_lib05 "&dir_path_data_05.";
	goptions reset=all;
	ods _all_ close;
	ods graphics on / width=10.49in height=7.5in;
	ods graphics / AttrPriority=None;
	ods pdf file="&dir_path_data_05./delta_02_graph_&start_yr.&start_mo._&end_yr.&end_mo..pdf";
		options
			orientation=landscape
			nocenter
			topmargin=.25in
			bottommargin=.25in
			leftmargin=.25in
			rightmargin=.25in;
			proc sgplot
				data=aa_lib05.DUAL_STUS_CD_&start_yr.&start_mo._&end_yr.&end_mo.
				NoCycleAttrs;
				styleattrs
					datalinepatterns=(solid)
					datacontrastcolors=(
						Brown
						Olive
						Navy
						Red
						Orange
						DarkGreen
						Yellow
						Cyan
						Blue
						Purple
						SteelBlue)
					datasymbols=(
						TriangleFilled
						X
						Star
						Y
						Diamond
						plus
						Hash
						SquareFilled
						Z
						dot
						CircleFilled);
				scatter
					x=process_yyyymm
					y=delta_02
					/ group=DUAL_STUS_CD_  markerattrs=(size=10) ; *datalabel=process_yyyymm;
				title "Monthly Process: Changes in DUAL_STUS_CD_ values";
				yaxis label="January to February deltas";
				xaxis label="Process Month";
				legend label=('DUAL_STUS_CD_ values');*<=I did NOT get this to work the way I would like...;
			run;
		quit;
		goptions RESET=(TITLE AXIS);
	ods pdf close;
%mend macro_07;
%macro_07(start_mo=&input_start_month.,start_yr=&input_start_year.,end_mo=&input_end_month.,end_yr=&input_end_year.);

/************************************************************************************;*/

%macro macro_07(start_mo=,start_yr=,end_mo=,end_yr=);
	%let dir_path_data_05 = /sas/vrdc/data/support/GV/GV_DELETE_temp_hold/cme_bene_abcd_copy_for_ml/data/data_out;
	libname aa_lib05 "&dir_path_data_05.";
	goptions reset=all;
	ods _all_ close;
	ods graphics on / width=10.49in height=7.5in;
	ods graphics / AttrPriority=None;
	ods pdf file="&dir_path_data_05./delta_02_graph_&start_yr.&start_mo._&end_yr.&end_mo..pdf";
		options
			orientation=landscape
			nocenter
			topmargin=.25in
			bottommargin=.25in
			leftmargin=.25in
			rightmargin=.25in;
			proc sgplot
				data=aa_lib05.DUAL_STUS_CD_&start_yr.&start_mo._&end_yr.&end_mo.
				noautolegend;
				keylegend / title = 'DUAL_STUS_CD_ values';
				scatter
					x=process_yyyymm
					y=delta_02
					/ group=DUAL_STUS_CD_  markerattrs=(size=10);
				legenditem type=marker name='item1' / label="00" markerattrs=(symbol=TriangleFilled color=Brown);
				legenditem type=marker name='item2' / label="01" markerattrs=(symbol=X color=Olive);
				legenditem type=marker name='item3' / label="02" markerattrs=(symbol=Star color=Navy);
				legenditem type=marker name='item4' / label="03" markerattrs=(symbol=Y color=Red);
				legenditem type=marker name='item5' / label="04" markerattrs=(symbol=Diamond color=Orange);
				legenditem type=marker name='item6' / label="05" markerattrs=(symbol=Plus color=DarkGreen);
				legenditem type=marker name='item7' / label="06" markerattrs=(symbol=Hash color=Yellow);
				legenditem type=marker name='item8' / label="08" markerattrs=(symbol=SquareFilled color=Cyan);
				legenditem type=marker name='item9' / label="09" markerattrs=(symbol=Z color=Blue);
				legenditem type=marker name='item10' / label="99" markerattrs=(symbol=dot color=Purple);
				legenditem type=marker name='item11' / label="NA" markerattrs=(symbol=circlefilled color=SteelBlue);
				keylegend 'item1' 'item2' 'item3' 'item4' 'item5' 'item6' 'item7' 'item8' 'item9' 'item10''item11' / position=S;
				title "Monthly Process: Changes in DUAL_STUS_CD_ values";
				yaxis label="January to February deltas";
				xaxis label="Process Month";
			run;
		quit;
		goptions RESET=(TITLE AXIS);
	ods pdf close;
%mend macro_07;
%macro_07(start_mo=&input_start_month.,start_yr=&input_start_year.,end_mo=&input_end_month.,end_yr=&input_end_year.);

/************************************************************************************;*/

legenditem type=markerline name='item1' / label="00" lineattrs=(pattern=Solid color=Brown) markerattrs=(symbol=TriangleFilled color=Brown);
legenditem type=markerline name='item2' / label="01" lineattrs=(pattern=Solid color=Olive) markerattrs=(symbol=X color=Olive);
legenditem type=markerline name='item3' / label="02" lineattrs=(pattern=Solid color=Navy) markerattrs=(symbol=Star color=Navy);
legenditem type=markerline name='item4' / label="03" lineattrs=(pattern=Solid color=Red) markerattrs=(symbol=Y color=Red);
legenditem type=markerline name='item5' / label="04" lineattrs=(pattern=Solid color=Orange) markerattrs=(symbol=Diamond color=Orange);
legenditem type=markerline name='item6' / label="05" lineattrs=(pattern=Solid color=DarkGreen) markerattrs=(symbol=Plus color=DarkGreen);
legenditem type=markerline name='item7' / label="06" lineattrs=(pattern=Solid color=Yellow) markerattrs=(symbol=Hash color=Yellow);
legenditem type=markerline name='item8' / label="08" lineattrs=(pattern=Solid color=Cyan) markerattrs=(symbol=SquareFilled color=Cyan);
legenditem type=markerline name='item9' / label="09" lineattrs=(pattern=Solid color=Blue) markerattrs=(symbol=Z color=Blue);
legenditem type=markerline name='item10' / label="99" lineattrs=(pattern=Solid color=Purple) markerattrs=(symbol=dot color=Purple);
legenditem type=markerline name='item11' / label="NA" lineattrs=(pattern=Solid color=SteelBlue) markerattrs=(symbol=circlefilled color=SteelBlue);
keylegend 'item1' / position=S;
keylegend 'item2' / position=S;
keylegend 'item3' / position=S;
keylegend 'item4' / position=S;
keylegend 'item5' / position=S;
keylegend 'item6' / position=S;
keylegend 'item7' / position=S;
keylegend 'item8' / position=S;
keylegend 'item9' / position=S;
keylegend 'item10' / position=S;
keylegend 'item11' / position=S;

/************************************************************************************;*/
