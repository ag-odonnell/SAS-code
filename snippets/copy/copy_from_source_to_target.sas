
libname source "&myfiles_root/.../Projects/.../data/...";
libname target "&myfiles_root/.../DEV/...";

/*Note: proc copy tends to keep most meta data associated with the file */
/*Note: proc copy is more efficient for large datases because copies in chunks */

/*Note: data ; set ; approach creates a new instance of file with non of the associated meta data */
/*Note: data ; set ; copies dataset row by row */

%macro result_same_name;
    proc copy in=source out=target;
        select
            dataset_01
            dataset_02
            ;
    run;
%mend result_same_name;
%result_same_name;

%macro result_same_name_less_efficient;
    data target.dataset_02; *easier to rename;
    set source.dataset_01;
    run;
%mend result_same_name_less_efficient;
%result_same_name_less_efficient;

%macro result_change_name;
    proc copy in=source out=target;
        select
            dataset_01
            dataset_02
            ;
    run;
    /* Rename the copied dataset */
    proc datasets library=target nolist;
    change dataset_01 = new_dataset_01;
    quit;
%mend result_change_name;
%result_change_name;

/*endProgram*/
