
/************************************************************************************;*/
/* Note: read in csv file that contains changes to county_names
/************************************************************************************;*/
/* First few rows of fmt source <.csv>
START,sublabel,label_old,label,FMTNAME
XXXXX,XX,XXXXXXXXXXXXXXXXXXXXXXXXXX,XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX,$fipscountyname
22053,LA,Jeffrson Davis,Jefferson Davis,$fipscountyname
01049,AL,Dekalb,DeKalb,$fipscountyname
/************************************************************************************;*/
/* Note: the "X" values listed in the first row above, 
/* - force the type and length of the readin
/************************************************************************************;*/

%let sourceDatasetName = fips_fmt1_countyname;
%let data_in_dir_path = /sas/.../data/;
libname data_out "&data_in_dir_path.";

PROC IMPORT
	OUT = data_out.&sourceDatasetName. 
	DATAFILE = "&data_in_dir_path.&sourceDatasetName..csv" 
	DBMS = csv
	REPLACE;
	GETNAMES = YES;
	*DATAROW = 2; 
RUN;

proc sort data = data_out.&sourceDatasetName. (
	rename = (
		sublabel = state_cd
		label_old = OLD_COUNTY));
by START;
where START ~= 'XXXXX';
run;

proc datasets lib = data_out;
	modify
		&sourceDatasetName.;
	label 
		START = 'FIPS_STCO'
		state_cd = 'State Code (Postal)'
		OLD_COUNTY = 'County Name (Previous)'
		label = 'County Name';
quit;

/************************************************************************************;*/
/* First two rows of census pop <.csv>
SUMLEV,REGION,DIVISION,STATE,COUNTY,STNAME,CTYNAME,CENSUS2010POP,ESTIMATESBASE2010,POPESTIMATE2010,POPESTIMATE2011,POPESTIMATE2012,POPESTIMATE2013,POPESTIMATE2014,POPESTIMATE2015,POPESTIMATE2016,POPESTIMATE2017,POPESTIMATE2018,POPESTIMATE2019
XXX,X,X,XX,XXX,XXXXXXXXXXXXXXXXXXXX,XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX,0,0,0,0,0,0,0,0,0,0,0,0
050,3,6,01,001,Alabama,Autauga County,54571,54597,54773,55227,54954,54727,54893,54864,55243,55390,55533,55869
/************************************************************************************;*/
/* Note: the "X" values listed in the first row above, 
/* - force the type and length of the readin
/************************************************************************************;*/
/*
https://www.census.gov/data/datasets/time-series/demo/popest/2010s-counties-total.html#par_textimage_70769902
https://www2.census.gov/programs-surveys/popest/datasets/
/************************************************************************************;*/

%let sourceDatasetName = co-est2019-alldata_READ_IN;
%let source_out_DatasetName = co_est2019_alldata;
%let data_in_dir_path = /sas/.../data/census_gov/;
libname data_out "&data_in_dir_path.";

PROC IMPORT
	OUT = data_out.&source_out_DatasetName. 
	DATAFILE = "&data_in_dir_path.&sourceDatasetName..csv" 
	DBMS = csv
	REPLACE;
	GETNAMES = YES;
	*DATAROW = 2; 
RUN;

proc sort data = data_out.&source_out_DatasetName.;
by STATE COUNTY;
where STATE ~= 'XX';
run;

data data_out.census_popest_2010_2019_20200501;
	length FIPS $5;
set data_out.&source_out_DatasetName. (
		keep =
			SUMLEV
			REGION
			DIVISION
			STATE
			COUNTY
			STNAME
			CTYNAME
			CENSUS2010POP
			ESTIMATESBASE2010
			POPESTIMATE2010
			POPESTIMATE2011
			POPESTIMATE2012
			POPESTIMATE2013
			POPESTIMATE2014
			POPESTIMATE2015
			POPESTIMATE2016
			POPESTIMATE2017
			POPESTIMATE2018
			POPESTIMATE2019
		);
	FIPS = cat(STATE,COUNTY);
by STATE COUNTY;
run;

/************************************************************************************;*/
/**endProgram**
/************************************************************************************;*/





/************************************************************************************;*/
/**endProgram**
/************************************************************************************;*/
