/* 
https://communities.sas.com/t5/SAS-Programming/space-in-directory-name/td-p/447614

Re: space in directory name
 Posted 03-21-2018 06:44 PM (10662 views)  |   In reply to gaylebrekke
If you are using Proc import then typing the name with the spaces should suffice:

proc import datafile="c:\some folder\another dir\my datafile.text"
<rest of proc>
or similar for an INFILE statement in a data step or even associating a FILENAME.

If you are using Windows Explorer (or possibly similar in other programs) to examine you files then:
1) navigate to the folder where the file exists
2) click in the address bar at the top with the folder path after the last entry,
3) the address bar text should now look a bit different and you can copy the text of the path and
4) paste the path into the quotes you use for the filename, infile or datafile.
Then add the file name with extension after a \. */

%macro m01_local;
    %let file_name_01=test 01.xls;
    %let libref_path_01=P:\aago\data\test directory with spaces\;
    libname aalib01 "&libref_path_01.";

    PROC IMPORT
        OUT = aalib01.test_01
        DATAFILE = "&libref_path_01.&file_name_01."
        DBMS = xls
        REPLACE;
        GETNAMES = YES;
        *DATAROW = 2;
    RUN;
%mend m01_local;
/*%m01_local;*/

%macro m01_linux;
    %let file_name_01=test 01.xls;
    %let libref_path_01=/dev/data/temp/test directory with spaces/;
    libname aalib01 "&libref_path_01.";

    PROC IMPORT
        OUT = aalib01.test_01
        DATAFILE = "&libref_path_01.&file_name_01."
        DBMS = xls
        REPLACE;
        GETNAMES = YES;
        *DATAROW = 2;
    RUN;
%mend m01_linux;
%m01_linux;

/**endProgram */
