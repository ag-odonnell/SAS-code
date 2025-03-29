
%let rdt=%sysfunc(today());
%let cdt_last=%sysfunc(intnx(month,&rdt.,-1,e));
%let cy_last=%sysfunc(year(&cdt_last));
%put **** &=cy_last ****;
