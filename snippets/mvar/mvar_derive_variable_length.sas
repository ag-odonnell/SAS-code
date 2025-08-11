
%macro create_test_data;
    data test_01;
        var_01='     ';    
        var_02='ab';
        var_03='cde';
        var_04='fghi';
    run;
%mend create_test_data;
%create_test_data;

%macro create_char_lengths(lib=WORK, data=);
    %local dsname;
    %let dsname=_temp_char_lengths;

    proc sql noprint;
        create table &dsname. as
        select name, length
        from dictionary.columns
        where libname = "%upcase(&lib.)" and memname = "%upcase(&data.)" and type = "char";
    quit;

    data _null_;
        set &dsname.;
        call symputx(cats("len_", lowcase(name)), length, "G"); /*Note: "G" makes the mvar assignment global, without mvar will be local */
    run;

    proc print data=_null_; run;
%mend;

/* Example usage */
%create_char_lengths(lib=work, data=test_01);

%put **** &=len_var_01 &=len_var_02 &=len_var_03 &=len_var_04****;
