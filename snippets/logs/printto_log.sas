
%let release_year=%str(RY2024);
%let sasccw_process_root=%str(&myfiles_root./OEDA_Prod/ODAP);
%let dual_upr_root=%str(&sasccw_process_root./DUAL_UPR);
%let out_ry_root=%str(&dual_upr_root./&release_year.);

%let out=%str(&out_ry_root./data);
%let logs=%str(&out_ry_root./logs);
libname out "&out.";
libname _logs "&logs.";
options user=out;
 
PROC PRINTTO 
    NEW 
    LOG = "&logs./claims2024.log"; 
RUN;  
