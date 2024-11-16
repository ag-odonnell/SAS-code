SASEG Commands in UNIX
bjobs | list of current SASEG jobs | Output includes the SASEG session itself
bkill job_ID | kill/terminate a particular SASEG job
bkill 0 | kill/terminate all SASEG jobs


/* Note: BSAS (Batch) commands
/* This is a SAS EG macro that will print results showing on what servers batch jobs are running; Open a new SAS EG session and run inside of a “new” SAS Program; Look at Execute Host column in the results tab;
/***********************************************************************;*/

%bsaslook

/***********************************************************************;*/
/* SASGSUB Launches grid batch job from a SAS EG session for SAS programs that have been saved in the user's Files directory.
/***********************************************************************;*/

%BSAS(filename)

/***********************************************************************;*/
/* Monitors status of active batch jobs, updated every 60 seconds.
/***********************************************************************;*/

%BSASLOOK List

/***********************************************************************;*/
/* Kill Terminates a batch job.
/***********************************************************************;*/

%BSASKILL(job ID)

/***********************************************************************;*/
/* endProgram
/***********************************************************************;*/