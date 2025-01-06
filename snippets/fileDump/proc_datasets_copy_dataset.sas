libname source 'path_to_source_library';
libname target 'path_to_target_library';

proc datasets library=source;
    copy out=target;
    select original_dataset_name;
run;

proc datasets library=target;
    change original_dataset_name=new_dataset_name;
run;
