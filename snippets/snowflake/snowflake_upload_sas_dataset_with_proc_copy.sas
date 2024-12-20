%put _all_;

%let snow_dua = 070484;
%let db = extracts;
%let sch = aod657;

libname _snowf sasiosnf
    server="ccw.us-east-1-gov.privatelink.snowflakecomputing.com"
    uid="&OUSER"
    pwd="&OPASSP"
    preserve_tab_names=no
    role = &&R&SNOW_DUA
    warehouse = &&W&SNOW_DUA
    database=&DB
    schema=&SCH
    readbuff=10000
    insertbuff=10000
    dbcommit=10000
    bulkload=yes
    bl_compress=yes
    bl_num_read_threads=10
    bl_internal_stage="user/&OUSER";

data finder;
x = 1;
run;

proc copy inlib = work outlib = _snowf;
select finder;
run;
