/**In SAS, you can measure the execution time of a process using the datetime() function to capture the start and end times of the process, 
and then calculate the difference. Here's an example: */
/* Capture the start time */
%let start_time = %sysfunc(datetime());

/* Your process code here */
data work.example;
    set sashelp.class;
run;

/* Capture the end time */
%let end_time = %sysfunc(datetime());

/* Calculate the execution time in seconds */
%let exec_time = %sysevalf(&end_time - &start_time);

/* Display the execution time */
%put Process executed in &exec_time seconds.;
