
libname aalib02 '/pd_data/data/libs/gvdb/dev/data/temp/aago/temp';

/*get a list of the datasets in referenced library*/
ods output members=Members;
/* the following library=work should locate your SASEG work directory. I prefer to define my output hence aalib02*/
/*proc datasets library=work memtype=data; run; quit;*/
proc datasets library=aalib02 memtype=data; run; quit;

/*define the max length of the final list of all dataset names. To include a space in between each name */
%let mvar_total_length=;

/*data _null_; /*use the _null_ to create a "non" dataset once you complete your review what is going on...*/
data members;
set members(keep = Name);
	if _n_ = 1 then total_length = 0;
	length_name = length(name);
	total_length+length_name+1; /*+1 includes a space between each name*/
	CALL SYMPUT("mvar_total_length",strip(total_length));
run;

/*create a list of dataset names*/
%put ****mvar_total_length: &mvar_total_length.****;

%let mvar_list=;

data _null_;
length var_list $&mvar_total_length.;
set members (keep=name);
retain var_list;
if _n_ = 1 then var_list ='';
/*else var_list = cat(strip(var_list),' ',strip(Name));*/
var_list = cat(strip(var_list),' ',strip(Name));
CALL SYMPUT("mvar_list",strip(var_list));
run;

%put ****mvar_list: &mvar_list.****;
 
/*iterate through the mvar = &mvar_list. sand do something (in this case print the name to log...)*/
%macro loop(vlist);
	%let num_words = %sysfunc(countw(&vlist));
	%put ****num_words: &num_words.****;
 
	%let fmt_name_out = ;
	%do i = 1 %to &num_words;
		%let fmt_name_out = %scan(&vlist, &i);
		%put ****fmt_name_out: &fmt_name_out.****;
	%end;
%mend loop;
%loop(&mvar_list.);

/*******/
/*endProgram
/*******/
