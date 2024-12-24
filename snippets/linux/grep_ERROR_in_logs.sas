/* Define the directory containing the log files */
%let libref_path_00 = %str(&myfiles_root./OEDA_Prod/ODAP/MUP/dev/data/aago/MUP-Medicare Provider Utilization and Payment/MUP_PAC-Post-Acute Care/RY24-Release Year 2024);
%let libref_path_01 = &libref_path_00./Programs;
%let libref_path_02 = &libref_path_00./Logs/Review;
libname _MUP_LOG "&libref_path_02.";

%let tdate = %SYSFUNC(PUTN(%SYSFUNC(TODAY()),YYMMDDN8.));
 
/* Use a pipe to list all .log files in the directory */
filename loglist pipe "ls '&libref_path_01'/*.log";
 
/* Read the list of log files */
data _MUP_LOG.log_files_&tdate.;
    infile loglist truncover;
    input logfile_name $201.;
run;
 
/* Initialize a dataset to store error lines */
data _MUP_LOG.log_files_with_errors_&tdate.;
    length logfile_name $201 line $150;
    /* Loop through each log file */
    set _MUP_LOG.log_files_&tdate.;
    file_to_read = logfile_name;
    infile dummy filevar=file_to_read end=eof lrecl=150 truncover;
    do while (not eof);
        input line $150.;
        /* Check if the line contains 'ERROR' */
        if index(line, 'ERROR') > 0 then do;
            output;
        end;
    end;
run;
 
/* Print the errors */
proc print data=_MUP_LOG.log_files_with_errors_&tdate.;
    var logfile_name line;
run;

/**endProgram */
