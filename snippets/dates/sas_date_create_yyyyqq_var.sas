data test_01;
    /**Create date_01 using the mdy function */
    date_01=mdy(7,1,2024);
    format date_01 date9.;
    /**Extract the year from date_01 */
    yearDate=year(date_01);
    /**Convert the year to a Character Variable */
    yearChar=put(year(date_01),4.);
    /**Create a character version of the yyyyqq of date_01 */
    date_01_QTR=strip(compress(cat(put(year(date_01),4.),put(qtr(date_01),2.))));
    /**year and quarter functions should skip null values */
    if date_01~=. then do; date_01_QTR=strip(compress(cat(put(year(date_01),4.),put(qtr(date_01),2.)))); end;
run;
