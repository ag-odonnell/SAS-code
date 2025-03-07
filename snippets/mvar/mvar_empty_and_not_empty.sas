
%let list_base=%str(a1 a2 a3 a4);
%let src_01=someValue;
%let src_02=;

%macro m01;
    data test_01;
        length %do i=1 %to %sysfunc(countw(&list_base)); prefix_%scan(&list_base,&i)_suffix %end; 8.;
        /*if src_01 is not empty and the dataset name contain in the mvar src_01 exists*/
        /*%if &src_01 ne and %sysfunc(exist(&src_01)) %then %do;*/
        %if &src_01 ne /*and %sysfunc(exist(&src_01))*/ %then %do;
            var_01="&src_01.";
        %end;
        %if %length(&src_02)=0 %then %do;
            array d_1(*) %do i=1 %to %sysfunc(countw(&list_base)); prefix_%scan(&list_base,&i)_suffix %end;;
            do i = 1 to dim(d_1); d_1(i)=i; end; drop i;
        %end;
    run;
%mend m01;
%m01;

/**endProgram */
