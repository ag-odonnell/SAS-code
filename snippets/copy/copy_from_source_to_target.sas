
libname source "&myfiles_root/.../Projects/.../data/...";
libname target "&myfiles_root/.../DEV/...";

proc copy in=source out=target;
    select
        dataset_01
        dataset_02
        ;
run;

/*endProgram*/
