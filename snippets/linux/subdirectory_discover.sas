%put "**********myfiles_root: &myfiles_root.**********";

filename dirs pipe 'dir "/sas/vrdc/users/aod657/files"';

data subdirs;
    length dirName $200;
    infile dirs truncover;
    input dirName $200.;
run;

libname _MUPDEV "&myfiles_root./OEDA_Prod/ODAP/MUP/dev/data/aago";

data _MUPDEV.test_01;
    var_01=1;
    var_02='a';
run;
