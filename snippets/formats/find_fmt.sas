%macro findfmt(fmt,type);

   proc sql noprint;
   create table test
   as select libname, fmtname, source, fmttype
   from dictionary.formats
   where fmtname="%upcase(&fmt)" and
         fmttype="%upcase(&type)";
   quit;

   %let dsid=%sysfunc(open(work.test));
   %let n=%sysfunc(attrn(&dsid,nobs));
   %let rc=%sysfunc(close(&dsid));

   %if %upcase(&type)=I %then %let msg_type=Informat;
   %if %upcase(&type)=F %then %let msg_type=Format;

   %if &n=0 %then
     %put &msg_type %upcase(&fmt) does not exist;

   %if &n>0 %then %do;
     data _null_;
       set test;
       if source="C" then
         put "&msg_type" +1 fmtname +1
             'is user-defined and exists in the'
              +1 libname +1 'library';
       if source="B" then
         put "&msg_type" +1 fmtname
       'is a SAS-supplied' +1 "&msg_type";
     run;
   %end;

%mend;

/*Sample Use:*/
options fmtsearch=(gvmisc24.formats) nofmterr;
%findfmt(sex_v1f, F);  /* Check for a format named SEX_V1F */
%findfmt(date9, I);    /* Check for SAS-supplied informat DATE9 */
