
/**20241004: table_1 is unique by the combination of column_1 and column_2. Write SQL to create table_2 from table_1 with unique column_1 and largest column_2. */

%macro macro_01;
    data table_1;
        do i = 1 to 8;
            if i<4 then column_1=1;
            else if i<5 then column_1=2;
            else if i<9 then column_1=3;
            column_2=i*2;
            output;
        end;
        drop i;
    run;

    proc sql;
    create table table_2 as
    select column_1, column_2/*, other_column /* Include other columns as needed */
    from (
        select column_1, column_2, /*other_column, */
                monotonic() as row_num,
                max(column_2) as max_column_2
        from table_1
        group by column_1
        having column_2 = calculated max_column_2
    );
    quit;
%mend macro_01;
%macro_01;

/**table_1 is unique by the combination of column_1 and column_2. 
column_1 contains numeric values. 
column_2 can contain any of the following character values (' ', 'Y', 'N', 'E') 
create table_2 from table_1 with unique column_1 and the 1st value ranked as ('Y', 'N', 'E', ' ') */

%macro macro_02;
    data table_1;
        do i = 1 to 10;
            if i=1 then do; bene_id=1; crnt_hic_sw='N'; end;
            else if i=2 then do; bene_id=1; crnt_hic_sw='Y'; end;
            else if i=3 then do; bene_id=1; crnt_hic_sw='E'; end;
            else if i=4 then do; bene_id=2; crnt_hic_sw=''; end;
            else if i=5 then do; bene_id=3; crnt_hic_sw=''; end;
            else if i=6 then do; bene_id=3; crnt_hic_sw='Y'; end;
            else if i=7 then do; bene_id=3; crnt_hic_sw='E'; end;
            else if i=8 then do; bene_id=3; crnt_hic_sw='N'; end;
            else if i=9 then do; bene_id=4; crnt_hic_sw='N'; end;
            else if i=10 then do; bene_id=4; crnt_hic_sw='E'; end;
            output;
        end;
        drop i;
    run;

    proc sql;
    create table table_2 as
    select bene_id,
            case min(case 
                        when crnt_hic_sw = 'Y' then 1
                        when crnt_hic_sw = 'N' then 2
                        when crnt_hic_sw = 'E' then 3
                        when crnt_hic_sw = ' ' then 4
                    end)
                when 1 then 'Y'
                when 2 then 'N'
                when 3 then 'E'
                when 4 then ' '
            end as crnt_hic_sw
    from table_1
    group by bene_id;
    quit;
%mend macro_02;
%macro_02;





%macro macro_91;
    BEGIN
        -- Create the table
        CREATE OR REPLACE TABLE table_1 (
            column_1 INT,
            column_2 INT
        );

        -- Loop through rows 1 to 4
        FOR i IN 1..4 DO
            IF i = 1 THEN
                -- For the first row, set column_1 = 1
                INSERT INTO table_1 (column_1, column_2)
                VALUES (1, i * 2);
            ELSE
                -- For rows 2, 3, and 4, set column_1 = 2
                INSERT INTO table_1 (column_1, column_2)
                VALUES (2, i * 2);
            END IF;
        END FOR;
    END;

    /**SQL that won't work in PROC SQL */
    CREATE TABLE table_2 AS
        WITH RankedRows AS (
            SELECT 
                column_1,
                column_2,
                other_column,  -- Any other columns from table_1
                ROW_NUMBER() OVER (PARTITION BY column_1 ORDER BY column_2 DESC) AS rn
            FROM 
                table_1
        )
        SELECT 
            column_1,
            column_2,
            other_column  -- Any other columns
        FROM 
            RankedRows
        WHERE 
            rn = 1;
%mend macro_91;
/* %macro_91; */