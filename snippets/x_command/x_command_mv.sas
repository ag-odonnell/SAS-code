
%let _source_libref=%str(&myfiles_root/OEDA_Prod/ODAP/CC_CHRONIC/2022/data/bene_clms/final);

%let _target_root=%str(&myfiles_root/OEDA_Prod/ODAP/CC/OTCC/TEP/RY2026/DEV/DY2022);
%let _target_ext=%str(data/bene_clms/final);

/*%put ****&_target_root./&_target_ext.****;*/
/*libname _TEST "&_target_root.";*/

%macro m00;
	%if %sysfunc(fileexist(&_target_root./&_target_ext.))=0 %then %do;
	    x "%LOWCASE(mkdir) &_target_root./data; %LOWCASE(y);";
	    x "%LOWCASE(mkdir) &_target_root./data/bene_clms; %LOWCASE(y);";
	    x "%LOWCASE(mkdir) &_target_root./&_target_ext.; %LOWCASE(y);";
	%end;
	%put ****DIRECTORY EXISTS (1/0 | YES/NO)=%sysfunc(fileexist(&_target_root./&_target_ext.))****;
%mend m00;
%m00;

%macro m01;
	X "mv &_source_libref./* &_target_root./&_target_ext.";
%mend m01;
%m01;
