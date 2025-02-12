
/* libname source "&myfiles_root/IPAG_SHARED/Projects/.../data/..."; */
/* libname target "&myfiles_root/OEDA_Prod/Projects/.../data/..."; */
libname source "&myfiles_root/OEDA_Prod/Projects/.../data/...";
libname target "&myfiles_root/OEDA_Prod/ODAP/DEV/...";

proc copy in=source out=target;
    select
        dataset_01
        dataset_02
        ;
run;

/*endProgram*/
