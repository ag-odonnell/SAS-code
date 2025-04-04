


%let date_update_dir = 20240320;
%let FORMAT_CAT_NAME=%str(formats); *<--this assignment will probably NOT change;

%let format_build_root=%str(&myfiles_root/path/to/file);

libname _source "&format_build_root./&date_update_dir./data_in";
libname _target "&format_build_root./&date_update_dir./data_out";
libname _temp "&format_build_root./&date_update_dir./temp";

%macro m00;
	%macro m01;
        /* Extract formats from both catalogs */
        proc format library=_source cntlout=_temp.format_source;
        run;

        proc format library=_target cntlout=_temp.format_target;
        run;

        proc sort data=_temp.format_source; by fmtname start end label; run;
        proc sort data=_temp.format_target; by fmtname start end label; run;
	%mend m01;
	/* %m01; */

	%macro m02;
        proc compare base=_temp.format_source compare=_temp.format_target
                    criterion=0.0001 /* allows tiny numeric tolerance */
                    out=_temp.fmt_differences noprint;
        id fmtname start end; /* Key variables for comparison */
        run;
	%mend m02;
	/* %m02; */

	%macro m03;
        data _temp.fmt_differences;
            length mark $2 match 8.;
            merge
                _temp.format_source(in=a
                    keep=fmtname start end label
                    rename=(label=label_source))
                _temp.format_target(in=b
                    keep=fmtname start end label
                    rename=(label=label_target));
            by fmtname start end;
            if a then do;
                mark='a';
                match=0;
                if b then do;
                    mark='ab';
                    if label_source=label_target then match=1;
                end;
            end;
            else mark='b';
        run;
	%mend m03;
	%m03;
	%macro m04;
        proc freq data=_temp.fmt_differences;
            tables match*mark
            / missing norow nocol nocum nopct format=comma15.;
        run;
        proc freq data=_temp.fmt_differences;
            where match=0;
            tables
                label_source
                label_target
                / missing norow nocol nocum nopct format=comma15.;
        run;
	%mend m04;
	%m04;
%mend m00;
%m00;
