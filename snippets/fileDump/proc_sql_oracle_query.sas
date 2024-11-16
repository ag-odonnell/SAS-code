
/************************************************************************************;*/
/*pull CCN from Oracle MDS table for LTI benes, for each service month, pull that month and previous 3m MDS records*/
/************************************************************************************;*/

proc sql;
	connect to oracle (
		user = "&ouser."
		orapw = "&opassp."
		path = "@tns:MMDWP"
		preserve_comments = yes);
	create table nf_bene_ccn_&year. as select *
		from connection to oracle (
			select %str(/)%str(*)%str(+) PARALLEL %str(*)%str(/)
				f.bene_id
				,m.A0100B_CMS_CRTFCTN_NUM as provider_id
				,m.state_cd
				,m.trgt_dt
				,m.SUBMSN_DT
			from 
				ccw_owner.CCW_Natl_MDS_3_ASMT m,
				&ouser..bene_finder_lti f
			where
				m.bene_id=f.bene_id
				and m.trgt_dt >= &from.
				and m.trgt_dt <= &to.
	);
quit;

/************************************************************************************;*/
/* According to BEO the M,R,Z indicates 
/* - specific types of facilitites: 
/* -- nursing home, hospice, swing bed  bpci is where this in known.
/************************************************************************************;*/

data nf_bene_ccn_&year.(drop=trgt_dt);
set nf_bene_ccn_&year.;
	target_dt = datepart(trgt_dt);
	trgt_mo = mdy(month(target_dt),1, year(target_dt));
	if substr(provider_id,3,1) in ('M','R','Z')
		then provider_id=substr(provider_id,1,2)||'1'||substr(provider_id,4,3);
	else if substr(provider_id,3,1) in ('A','B','C','D','E','F','G','H','I','J','K','L','N','O','P','Q','S','T','U','V','W','X','Y')
		then provider_id=substr(provider_id,1,2)||'0'||substr(provider_id,4,3);
	else provider_id=provider_id;
	format target_dt mmddyy10. trgt_mo monyy7.;
run;

/************************************************************************************;*/

%let aa_temp_libref_path = /sas/vrdc/data/support/GV/GV_DELETE_temp_hold/temp;
libname aa_temp "&aa_temp_libref_path.";

%macro macro_01;

%mend macro_01;
%macro_01;

%macro macro_01;
	proc sql noprint;
		connect to oracle (
			user = "&OUSER"
			orapw = "&OPASSP"
			path = "&OPATHP.,BUFFSIZE=5000"
			preserve_comments = yes);
		create table aa_temp.ccw_mds_20200424 as select *
			from connection to oracle (
				select 
					*
				from ccw_owner.CCW_Natl_MDS_3_ASMT a
				/*where rownum < 25*/
			);
	quit;

	proc contents data = aa_temp.ccw_mds_20200424; run;
%mend macro_01;
%macro_01;

/************************************************************************************;*/
/*
The CONTENTS Procedure

Data Set Name        AA_TEMP.CCW_MDS_SAMPLE                                   Observations           24    
Member Type          DATA                                                     Variables              868   
Engine               V9                                                       Indexes                0     
Created              04/24/2020 10:17:24                                      Observation Length     2197  
Last Modified        04/24/2020 10:17:24                                      Deleted Observations   0     
Protection                                                                    Compressed             BINARY
Data Set Type                                                                 Reuse Space            NO    
Label                                                                         Point to Observations  YES   
Data Representation  SOLARIS_X86_64, LINUX_X86_64, ALPHA_TRU64, LINUX_IA64    Sorted                 NO    
Encoding             latin1  Western (ISO)                                                                

/************************************************************************************;*/

%macro macro_02;
	proc sql noprint;
		connect to oracle (
			user = "&OUSER"
			orapw = "&OPASSP"
			path = "&OPATHP.,BUFFSIZE=5000"
			preserve_comments = yes);
		create table aa_temp.ccw_mds_ccn_sample as select *
			from connection to oracle (
				select
					*
				from ccw_owner.CCW_Natl_MDS_3_ASMT a
				where rownum < 25
			);
	quit;
	proc contents data = aa_temp.ccw_mds_ccn_sample; run;
%mend macro_02;
%macro_02;

/************************************************************************************;*/
/*

             
1    STATE_CD                          Char      2    $2.            $2.            STATE_CD
686    STATE_EXTRCT_FIL_ID               Char      8    $8.            $8.            STATE_EXTRCT_FIL_ID
41    C_STATE_2_CMI_TXT                 Char      7    $7.            $7.            C_STATE_2_CMI_TXT
38    C_STATE_2_RUG_GRP_TXT             Char     10    $10.           $10.           C_STATE_2_RUG_GRP_TXT
39    C_STATE_2_RUG_VRSN_TXT            Char     10    $10.           $10.           C_STATE_2_RUG_VRSN_TXT
40    C_STATE_2_SET_CD                  Char      3    $3.            $3.            C_STATE_2_SET_CD
37    C_STATE_CMI_TXT                   Char      7    $7.            $7.            C_STATE_CMI_TXT
34    C_STATE_RUG_GRP_TXT               Char     10    $10.           $10.           C_STATE_RUG_GRP_TXT
35    C_STATE_RUG_VRSN_TXT              Char     10    $10.           $10.           C_STATE_RUG_VRSN_TXT
36    C_STATE_SET_CD                    Char      3    $3.            $3.            C_STATE_SET_CD
868    C_STATE_SS_IND                    Char      1    $1.            $1.            C_STATE_SS_IND
24    C_URBN_RRL_CD                     Char      1    $1.            $1.            C_URBN_RRL_CD
629    Z0200A_STATE_RUG_GRP_TXT          Char     10    $10.           $10.           Z0200A_STATE_RUG_GRP_TXT
630    Z0200B_STATE_RUG_VRSN_TXT         Char     10    $10.           $10.           Z0200B_STATE_RUG_VRSN_TXT
866    Z0200C_STATE_SS_IND               Char      1    $1.            $1.            Z0200C_STATE_SS_IND
631    Z0250A_STATE_2_RUG_GRP_TXT        Char     10    $10.           $10.           Z0250A_STATE_2_RUG_GRP_TXT
632    Z0250B_STATE_2_RUG_VRSN_TXT       Char     10    $10.           $10.           Z0250B_STATE_2_RUG_VRSN_TXT
/************************************************************************************;*/

%macro macro_03;
	proc sql noprint;
		connect to oracle (
			user = "&OUSER"
			orapw = "&OPASSP"
			path = "&OPATHP.,BUFFSIZE=5000"
			preserve_comments = yes);
		create table aa_temp.ccw_mds_ccn_sample as select *
			from connection to oracle (
				select
					a.bene_id
					,a.A0100B_CMS_CRTFCTN_NUM
					,a.STATE_CD
					,a.STATE_EXTRCT_FIL_ID
					,a.C_STATE_2_CMI_TXT
					,a.C_STATE_2_RUG_GRP_TXT
					,a.C_STATE_2_RUG_VRSN_TXT
					,a.C_STATE_2_SET_CD
					,a.C_STATE_CMI_TXT
					,a.C_STATE_RUG_GRP_TXT
					,a.C_STATE_RUG_VRSN_TXT
					,a.C_STATE_SET_CD
					,a.C_STATE_SS_IND
					,a.C_URBN_RRL_CD
					,a.Z0200A_STATE_RUG_GRP_TXT
					,a.Z0200B_STATE_RUG_VRSN_TXT
					,a.Z0200C_STATE_SS_IND
					,a.Z0250A_STATE_2_RUG_GRP_TXT
					,a.Z0250B_STATE_2_RUG_VRSN_TXT
				from ccw_owner.CCW_Natl_MDS_3_ASMT a
				where rownum < 25
			);
	quit;
	proc contents data = aa_temp.ccw_mds_ccn_sample; run;
	proc print data = aa_temp.ccw_mds_ccn_sample (obs = 5); run;
%mend macro_03;
%macro_03;

/************************************************************************************;*/
/*
                                           STATE_     C_STATE_   C_STATE_2_   C_STATE_                           C_STATE_
                 A0100B_CMS_               EXTRCT_     2_CMI_     RUG_GRP_    2_RUG_       C_STATE_   C_STATE_   RUG_GRP_
Obs    BENE_ID   CRTFCTN_NUM    STATE_CD   FIL_ID       TXT         TXT       VRSN_TXT     2_SET_CD   CMI_TXT    TXT

  1   1   045352            AR                                                                                      
  2    2   555355            CA                                                                                      
  3    3   335760            NY                                                                                      
  4   4   045138            AR                                                                                      
  5   5   015027            AL                                                                                      

                                                                                              Z0250A_       Z0250B_
      C_STATE_                                          Z0200A_       Z0200B_      Z0200C_    STATE_2_      STATE_2_
      RUG_VRSN_     C_STATE_    C_STATE_    C_URBN_    STATE_RUG_    STATE_RUG_    STATE_     RUG_GRP_      RUG_VRSN_
Obs   TXT            SET_CD      SS_IND     RRL_CD      GRP_TXT       VRSN_TXT     SS_IND     TXT           TXT

  1                                            R                                                                      
  2                                            U                                                                      
  3                                            U                                                                      
  4                                            U       -             -                        ^             ^         
  5                                            U       ^             ^                        ^             ^         

/************************************************************************************;*/

%macro macro_04;
	proc sql noprint;
		connect to oracle (
			user = "&OUSER"
			orapw = "&OPASSP"
			path = "&OPATHP.,BUFFSIZE=5000"
			preserve_comments = yes);
		create table aa_temp.ccw_mds_ccn_sample as select *
			from connection to oracle (
				select
					a.bene_id
					,a.A0100B_CMS_CRTFCTN_NUM
					,a.STATE_CD
				from ccw_owner.CCW_Natl_MDS_3_ASMT a
				where rownum < 25
			);
	quit;
%mend macro_04;
%macro_04;

/************************************************************************************;*/
/* variable is a varchar $12
A0100B_CMS_CRTFCTN_NUM 
045352
555355
335760
045138
015027
056149
396070
445267
225222
215280
205126
225649
195199
435088
515060
055461
675576
145890
235175
015063
105327
335634
675848
676019

/************************************************************************************;*/

%macro macro_05;
	proc sql noprint;
		connect to oracle (
			user = "&OUSER"
			orapw = "&OPASSP"
			path = "&OPATHP.,BUFFSIZE=5000"
			preserve_comments = yes);
		create table aa_temp.ccw_mds_ccn as select *
			from connection to oracle (
				select
					a.bene_id
					,a.A0100B_CMS_CRTFCTN_NUM
					,a.STATE_CD
				from ccw_owner.CCW_Natl_MDS_3_ASMT a
				/*where rownum < 25*/
			);
	quit;
	
	data aa_temp.ccw_mds_ccn;
	set aa_temp.ccw_mds_ccn;
		length strip_ccn $12 length_ccn 8. first_ccn $1 third_ccn $1;
		strip_ccn = strip(A0100B_CMS_CRTFCTN_NUM);
		length_ccn = length(strip_ccn);
		first_ccn = substr(strip_ccn,1,1);
		third_ccn = substr(strip_ccn,3,1);
	run;
	
	proc freq data = aa_temp.ccw_mds_ccn;
		tables
			length_ccn
			first_ccn
			third_ccn
			/ missing;
	run;
%mend macro_05;
%macro_05;

/************************************************************************************;*/
/*
                                       Cumulative    Cumulative
length_ccn    Frequency     Percent     Frequency      Percent
---------------------------------------------------------------
         1      395328        0.21        395328         0.21  
         2        8340        0.00        403668         0.22  
         3        2844        0.00        406512         0.22  
         4       13402        0.01        419914         0.22  
         5       39539        0.02        459453         0.24  
         6    1.8641E8       99.40      1.8687E8        99.64  
         7      258609        0.14      1.8713E8        99.78  
         8       39204        0.02      1.8717E8        99.80  
         9      271757        0.14      1.8744E8        99.95  
        10       71741        0.04      1.8751E8        99.98  
        11        4382        0.00      1.8751E8        99.99  
        12       24742        0.01      1.8754E8       100.00  

                                      Cumulative    Cumulative
first_ccn    Frequency     Percent     Frequency      Percent
--------------------------------------------------------------
0            22345331       11.92      22345331        11.92  
1            43197913       23.03      65543244        34.95  
2            29187891       15.56      94731135        50.51  
3            51614749       27.52      1.4635E8        78.03  
4            16767751        8.94      1.6311E8        86.98  
5            14292753        7.62      1.7741E8        94.60  
6             9603295        5.12      1.8701E8        99.72  
7                7297        0.00      1.8702E8        99.72  
8                8429        0.00      1.8703E8        99.73  
9               45708        0.02      1.8707E8        99.75  
A               15483        0.01      1.8709E8        99.76  
B                  12        0.00      1.8709E8        99.76  
C                3202        0.00      1.8709E8        99.76  
D                2228        0.00      1.8709E8        99.76  
E                   9        0.00      1.8709E8        99.76  
F                   1        0.00      1.8709E8        99.76  
G                   1        0.00      1.8709E8        99.76  
H                1398        0.00      1.8709E8        99.76  
I                 695        0.00      1.8709E8        99.76  
J                4249        0.00       1.871E8        99.76  
K                3774        0.00       1.871E8        99.77  
L                5604        0.00      1.8711E8        99.77  
M                3140        0.00      1.8711E8        99.77  
N               21782        0.01      1.8713E8        99.78  
O                4892        0.00      1.8714E8        99.79  
P                 403        0.00      1.8714E8        99.79  
Q                  49        0.00      1.8714E8        99.79  
R                  16        0.00      1.8714E8        99.79  
S                1162        0.00      1.8714E8        99.79  
T                 114        0.00      1.8714E8        99.79  
U                 409        0.00      1.8714E8        99.79  
V                 149        0.00      1.8714E8        99.79  
W                4181        0.00      1.8714E8        99.79  
X                 171        0.00      1.8714E8        99.79  
Y                  18        0.00      1.8714E8        99.79  
Z                1962        0.00      1.8715E8        99.79  
^              393135        0.21      1.8754E8       100.00 

                                      Cumulative    Cumulative
third_ccn    Frequency     Percent     Frequency      Percent
--------------------------------------------------------------
               403668        0.22        403668         0.22  
0              129510        0.07        533178         0.28  
1               71813        0.04        604991         0.32  
2              110763        0.06        715754         0.38  
3               95978        0.05        811732         0.43  
4               53749        0.03        865481         0.46  
5            1.6901E8       90.12      1.6987E8        90.58  
6            16076216        8.57      1.8595E8        99.15  
7               18519        0.01      1.8597E8        99.16  
8               12921        0.01      1.8598E8        99.17  
9               34636        0.02      1.8601E8        99.19  
A              691861        0.37      1.8671E8        99.56  
B                   7        0.00      1.8671E8        99.56  
C                5598        0.00      1.8671E8        99.56  
D                6471        0.00      1.8672E8        99.56  
E              744886        0.40      1.8746E8        99.96  
F               55354        0.03      1.8752E8        99.99  
H                   1        0.00      1.8752E8        99.99  
I                   3        0.00      1.8752E8        99.99  
K                 365        0.00      1.8752E8        99.99  
L                   8        0.00      1.8752E8        99.99  
M                   1        0.00      1.8752E8        99.99  
N               10262        0.01      1.8753E8        99.99  
P                   7        0.00      1.8753E8        99.99  
Q                   2        0.00      1.8753E8        99.99  
R                  71        0.00      1.8753E8        99.99  
S                 385        0.00      1.8753E8        99.99  
T                9069        0.00      1.8754E8       100.00  
U                  11        0.00      1.8754E8       100.00  
X                  37        0.00      1.8754E8       100.00  
Z                 702        0.00      1.8754E8       100.00  

/************************************************************************************;*/

%macro macro_06;
	proc freq data = aa_temp.ccw_mds_ccn;
		where length_ccn > 5;
		tables
			first_ccn
			third_ccn
			/ missing;
	run;
%mend macro_06;
%macro_06;

/************************************************************************************;*/
/*

                                      Cumulative    Cumulative
first_ccn    Frequency     Percent     Frequency      Percent
--------------------------------------------------------------
0            22339885       11.94      22339885        11.94  
1            43186071       23.08      65525956        35.03  
2            29184140       15.60      94710096        50.63  
3            51599736       27.58      1.4631E8        78.21  
4            16764401        8.96      1.6307E8        87.17  
5            14278053        7.63      1.7735E8        94.80  
6             9602756        5.13      1.8696E8        99.93  
7                7197        0.00      1.8696E8        99.94  
8                6530        0.00      1.8697E8        99.94  
9               45703        0.02      1.8701E8        99.97  
A               15481        0.01      1.8703E8        99.97  
B                   9        0.00      1.8703E8        99.97  
C                3200        0.00      1.8703E8        99.98  
D                2228        0.00      1.8704E8        99.98  
E                   3        0.00      1.8704E8        99.98  
G                   1        0.00      1.8704E8        99.98  
H                 814        0.00      1.8704E8        99.98  
I                 694        0.00      1.8704E8        99.98  
J                4249        0.00      1.8704E8        99.98  
K                3773        0.00      1.8704E8        99.98  
L                5604        0.00      1.8705E8        99.98  
M                3136        0.00      1.8705E8        99.99  
N               12818        0.01      1.8707E8        99.99  
O                4892        0.00      1.8707E8       100.00  
P                 399        0.00      1.8707E8       100.00  
Q                  12        0.00      1.8707E8       100.00  
R                  15        0.00      1.8707E8       100.00  
S                1162        0.00      1.8707E8       100.00  
T                  57        0.00      1.8707E8       100.00  
U                 407        0.00      1.8707E8       100.00  
V                 146        0.00      1.8707E8       100.00  
W                4180        0.00      1.8708E8       100.00  
X                 171        0.00      1.8708E8       100.00  
Y                  18        0.00      1.8708E8       100.00  
Z                1962        0.00      1.8708E8       100.00  

                                      Cumulative    Cumulative
third_ccn    Frequency     Percent     Frequency      Percent
--------------------------------------------------------------
0              117616        0.06        117616         0.06  
1               57015        0.03        174631         0.09  
2              109225        0.06        283856         0.15  
3               93605        0.05        377461         0.20  
4               53467        0.03        430928         0.23  
5            1.6899E8       90.33      1.6942E8        90.56  
6            16074664        8.59       1.855E8        99.16  
7               17573        0.01      1.8552E8        99.16  
8               12232        0.01      1.8553E8        99.17  
9               31734        0.02      1.8556E8        99.19  
A              691859        0.37      1.8625E8        99.56  
B                   7        0.00      1.8625E8        99.56  
C                5598        0.00      1.8626E8        99.56  
D                6415        0.00      1.8626E8        99.56  
E              744610        0.40      1.8701E8        99.96  
F               55354        0.03      1.8706E8        99.99  
H                   1        0.00      1.8706E8        99.99  
I                   2        0.00      1.8706E8        99.99  
K                 365        0.00      1.8707E8        99.99  
L                   8        0.00      1.8707E8        99.99  
M                   1        0.00      1.8707E8        99.99  
N                4379        0.00      1.8707E8        99.99  
P                   4        0.00      1.8707E8        99.99  
Q                   2        0.00      1.8707E8        99.99  
R                  68        0.00      1.8707E8        99.99  
S                 383        0.00      1.8707E8        99.99  
T                9069        0.00      1.8708E8       100.00  
U                  10        0.00      1.8708E8       100.00  
X                  37        0.00      1.8708E8       100.00  
Z                 702        0.00      1.8708E8       100.00  

/************************************************************************************;*/

%macro macro_07;
	proc freq data = aa_temp.ccw_mds_ccn;
		where length_ccn = 6;
		tables
			first_ccn
			third_ccn
			/ missing;
	run;
%mend macro_07;
%macro_07;

/************************************************************************************;*/
/*

/************************************************************************************;*/




/************************************************************************************;*/

%macro macro_08;
	data aa_temp.pos_2018_temp01;
	set ccw_char.pos_2018 (
		keep =
			PRVDR_NUM
			FAC_NAME
			STATE_CD CITY_NAME
			ZIP_CD
			FIPS_STATE_CD
			FIPS_CNTY_CD
			SSA_STATE_CD
			SSA_CNTY_CD
			CBSA_CD);
			length strip_PRVDR_NUM $12 length_PRVDR_NUM 8. first_PRVDR_NUM $1;
			strip_PRVDR_NUM = strip(PRVDR_NUM);
			length_PRVDR_NUM = length(strip_PRVDR_NUM);
			first_PRVDR_NUM = substr(strip_PRVDR_NUM,1,1);
			third_PRVDR_NUM = substr(strip_PRVDR_NUM,3,1);
	run;
	
	proc freq data = aa_temp.pos_2018_temp01;
		tables
			length_PRVDR_NUM
			first_PRVDR_NUM
			third_PRVDR_NUM
			/ missing;
	run;
%mend macro_08;
%macro_08;

/************************************************************************************;*/
/*
                                             Cumulative    Cumulative
length_PRVDR_NUM    Frequency     Percent     Frequency      Percent
---------------------------------------------------------------------
               6      137376       20.94        137376        20.94  
              10      518688       79.06        656064       100.00  

first_PRVDR_NUM                    Cumulative    Cumulative
          Frequency     Percent     Frequency      Percent
-----------------------------------------------------------
0           109128       16.63        109128        16.63  
1           159208       24.27        268336        40.90  
2            91436       13.94        359772        54.84  
3           142864       21.78        502636        76.61  
4           112566       17.16        615202        93.77  
5            31206        4.76        646408        98.53  
6             6599        1.01        653007        99.53  
7             2422        0.37        655429        99.90  
8               70        0.01        655499        99.91  
9              565        0.09        656064       100.00

third_PRVDR_NUM                    Cumulative    Cumulative
          Frequency     Percent     Frequency      Percent
-----------------------------------------------------------
0             8077        1.23          8077         1.23  
1            18723        2.85         26800         4.08  
2             9955        1.52         36755         5.60  
3             9235        1.41         45990         7.01  
4             4572        0.70         50562         7.71  
5            19713        3.00         70275        10.71  
6             8851        1.35         79126        12.06  
7            18082        2.76         97208        14.82  
8             6644        1.01        103852        15.83  
9             3638        0.55        107490        16.38  
A             4045        0.62        111535        17.00  
C             8391        1.28        119926        18.28  
D           508730       77.54        628656        95.82  
E            12311        1.88        640967        97.70  
F             1237        0.19        642204        97.89  
G            10383        1.58        652587        99.47  
H              893        0.14        653480        99.61  
J                1        0.00        653481        99.61  
K              370        0.06        653851        99.66  
L              571        0.09        654422        99.75  
P               75        0.01        654497        99.76  
X             1567        0.24        656064       100.00  

/************************************************************************************;*/

%macro macro_09;
	data aa_temp.pos_2018_temp02;
	set aa_temp.pos_2018_temp01;
		if length_PRVDR_NUM = 10 then output;
	run;
%mend macro_09;
%macro_09;

/************************************************************************************;*/

%macro macro_10;
	proc sort data = aa_temp.ccw_mds_ccn;
	by strip_ccn;
	run;
	proc sort data = aa_temp.pos_2018_temp01;
	by strip_PRVDR_NUM;
	run;

	data aa_temp.pos_2018_merge_mds_01;
		length mark $2;
	merge
		aa_temp.ccw_mds_ccn (in = a
			rename = (strip_ccn = provider)
		aa_temp.pos_2018_temp01 (in = b
			rename = (strip_PRVDR_NUM = provider));
		if length_PRVDR_NUM = 10 then output;
	by provider;
		if a then do;
			mark = 'a';
			if b then mark = 'ab';
			output;
		end;
	run;
	
	
	
	proc freq data = aa_temp.pos_2018_merge_mds_01;
		tables
			mark
			/ missing;
	run;
	proc freq data = aa_temp.pos_2018_merge_mds_01;
		where mark = 'ab';
		tables
			mark
			/ missing nocol norow nocum nopct format=comma15.;
	run;
%mend macro_10;
%macro_10;

/************************************************************************************;*/
/**endProgram
/************************************************************************************;*/

