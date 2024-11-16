
/************************************************************************************;*/
/* Note: base ideas around compress function in SAS
/************************************************************************************;*/

data abc;
input a $;
cards;
BA231
CDA224
744BAS
;
run;

data abc1;
set abc;
b = compress(a,'','A');
c = compress(a, b);
run; 

/************************************************************************************;*/
/* NOte: play around with modifiers
/************************************************************************************;*/

data test;
	length SSN_TXT val_SSN_TXT $9;
	do i = 1 to 2;
		if i = 1 then SSN_TXT = '123456789';
		else SSN_TXT = '12aBc &^9';
		strip_SSN_TXT = strip(SSN_TXT);
		compress_strip_SSN_TXT = compress(strip(SSN_TXT));
		compress_remove_AP_output = compress(strip_SSN_TXT,'','AP'); *<-AP are modifiers;
		length_compress_output = length(compress_remove_AP_output);
		compress_keep_D_output_01 = compress(strip_SSN_TXT,'','DK'); *<-DK are modifiers;
		length_compress_keep_output_01 = length(compress_keep_D_output_01);
		
		compress_keep_D_output_02 = compress(compress_strip_SSN_TXT,'','DK'); *<-DK are modifiers;
		length_compress_keep_output_02 = length(compress_keep_D_output_02);
		
		if length(compress(strip_SSN_TXT,'','DK')) < 9 then val_SSN_TXT = '1 aBc^& 9';
		else val_SSN_TXT = '123456789';
		output;
	end;
	drop i strip_SSN_TXT;
run;

/************************************************************************************;*/

/* Note: SAS COMPRESS Code
/* – Use “data _null_” when you want to test a command, but don’t want to create a data set
/* Form: COMPRESS(VariableName,option)
/* – put command – prints results in log
/***********************************************************************;*/

data _null_;
	name = compress(‘ Houston ,’);
	put name;
run;

data _null_;
	name = Compress(‘Houston,’,”,”);
	put name;
run;

data _null_;
	name = left(compress(‘ Houston ,’,”,”));
	put name;
run;

/***********************************************************************;*/
/* Note: Houston with leading and trailing spaces removed.
/* – Did not remove space in middle.
/* – Right Justified
/***********************************************************************;*/

data _null_;
	name = right(compress (” Hous ton .”,”.”));
	put name;
run;

/***********************************************************************;*/
/* Note: O’Donnell as upcase and remove apostophe
/***********************************************************************;*/

data _null_;
	name = upcase(left(compress(“O’Donnell “,”‘”)));
	put name;
run;

/***********************************************************************;*/
/* Note: Des Moines as one word upcase
/***********************************************************************;*/

data _null_;
	name = upcase (left(compress(“first_word second_word”)));
	put name;
run;

/***********************************************************************;*/
/* Note: A couple of ways to use the concatenate function
/***********************************************************************;*/

%let input_variable_01 = first_word;
%let input_variable_02 = second_word;

data _null_;
	variable_1=&input_variable_01.;
	variable_2=&input_variable_02.;
	name=new_variable_name=variable_1||” – “||variable_2;
	put name;
run;

/***********************************************************************;*/

data _null_;
	variable_1=&input_variable_01.;
	variable_2=&input_variable_02.;
	name=new_variable_name=compress(variable_1||” – “||variable_2);
	put name;
run;

/***********************************************************************;*/
/* Note: Functions and CALL Routines: CAT Function – 9.2 – SAS
/* – http://support.sas.com/documentation/cdl/en/lrdict/64316/HTML/default/viewer.htm#a002257060.htm
/***********************************************************************;*/
/* – Syntax
/* – CAT(item-1 <, …, item-n>)
/* –
Comparisons
/* – The results of the CAT, CATS, CATT, and CATX functions are usually equivalent to results
/* – that are produced by certain combinations of the concatenation operator (||)
/* – and the TRIM and LEFT functions.
/* – However, the default length for the CAT, CATS, CATT, and CATX functions is different
/* – from the length that is obtained when you use the concatenation operator.
/* – For more information, see Length of Returned Variable.
/* – Using the CAT, CATS, CATT, and CATX functions is faster than using TRIM and LEFT,
/* – and you can use them with the OF syntax for variable lists in calling environments that support variable lists.
/* – The following table shows equivalents of the CAT, CATS, CATT, and CATX functions.
/* – The variables X1 through X4 specify character variables, and SP specifies a delimiter, such as a blank or comma.
/* – Function = Equivalent Code
/* – CAT(OF X1-X4) = X1||X2||X3||X4
/* – CATS(OF X1-X4) = TRIM(LEFT(X1))||TRIM(LEFT(X2))||TRIM(LEFT(X3))||TRIM(LEFT(X4))
/* – CATT(OF X1-X4) = TRIM(X1)||TRIM(X2)||TRIM(X3)||TRIM(X4)
/* – CATX(SP, OF X1-X4) = TRIM(LEFT(X1))||SP||TRIM(LEFT(X2))||SP||TRIM(LEFT(X3))||SP||TRIM(LEFT(X4))
/***********************************************************************;*/

data _null_;
	x=’ The 2002 Olym’;
	y=’pic Arts Festi’;
	z=’ val included works by D ‘;
	a=’ale Chihuly.’;
	result=cat(x,y,z,a);
	put result $char.;
run;

/***********************************************************************;*/
/* – SAS writes the following line to the log:
/* – —-+—-1—-+—-2—-+—-3—-+—-4—-+—-5—-+—-6—-+—-7
/* – The 2002 Olympic Arts Festi val included works by D ale Chihuly.
/***********************************************************************;*/


/***********************************************************************;*/
/* Note: Results of var_08 should look like the string below (notice the use of ‘ and “)
‘0016070’ = “0016070 – Bypass Cerebral Ventricle to Nasopharynx with Autologous Tissue Substitute, Open Approach”
/***********************************************************************;*/

data test;
	length var_06 $113;
	var_01 = ’01’;
	var_02 = ‘a’;
	var_03 = ‘0016070’;
	var_04 = ” Bypass Cerebral Ventricle to Nasopharynx with Autologous Tissue Substitute, Open Approach “;

	var_05 = left(cat(“‘”,var_01,”‘”,” = “,'”‘,var_01,’ – ‘,var_02,'”‘));
	var_06 = left(cat(“‘”,var_03,”‘”,” = “,'”‘,var_03,’ – ‘,var_04,'”‘));
	var_07 = left(cat(“‘”,var_03,”‘”,” = “,'”‘,var_03,’ – ‘,left(trim(var_04)),'”‘));
	var_08 = left(cat(“‘”,var_03,”‘”,” = “,'”‘,var_03,’ – ‘,strip(var_04),'”‘));
run;

/***********************************************************************;*/
/* Note: the trim funciton would not remove the trailing tab
/***********************************************************************;*/

data test;
	x = ‘Impl pressure sensor w/angioÂ ‘;
	x_clean = translate(x,”,’Â ‘);
	*x_clean = left(trim(x));
	*x_clean = strip(x);
	*x_clean = trim(x);
	length_x = length(x);
	length_x_clean = length(x_clean);
run;

/***********************************************************************;*/
/* Note:
http://support.sas.com/documentation/cdl/en/lrdict/64316/HTML/default/viewer.htm#a002295689.htm
The STRIP function returns the argument with all leading and trailing blanks removed.
If the argument is blank, STRIP returns a string with a length of zero.
Note: STRIP(string) returns the same result as TRIMN(LEFT(string)),
but the STRIP function runs faster.
/***********************************************************************;*/

data test;
	var_01 = 2;
	var_02 = 10;
	var_03 = “XX – Unknown “;
	var_04 = ” AA – Some character string”;
	var_05 = STRIP(SUBSTR(var_01,1,LENGTH(var_01)));
	var_06 = STRIP(SUBSTR(var_02,1,LENGTH(var_02)));
	var_07 = STRIP(SUBSTR(var_03,1,LENGTH(var_03)));
	var_08 = STRIP(SUBSTR(var_04,1,LENGTH(var_04)));
run;

/***********************************************************************;*/
/*
Resulting dataset:
var_01 = 2; – Numeric 8 with Format best12.
var_02 = 10; – Numeric 8 with Format best12.
var_03 = “XX – Unknown “; – Character 13. – “XX – Unknown”
var_04 = ” AA – Some character string”; – Character 27. – ” AA – Some character string”
var_05 = STRIP(SUBSTR(var_01,1,LENGTH(var_01))); – Character 12. –
var_06 = STRIP(SUBSTR(var_02,1,LENGTH(var_02))); – Character 12. –
var_07 = STRIP(SUBSTR(var_03,1,LENGTH(var_03))); – Character 13. – “XX – Unknown”
var_08 = STRIP(SUBSTR(var_04,1,LENGTH(var_04))); – Character 27. – “AA – Some character string”

(i.e., scrubs the leading and trailing spaces, but leaves the length of the variable unchanged)
Also converts numeric variables to character.

/***********************************************************************;*/
/***********************************************************************;*/

data test;
	var_01_percentage = “48.94%”;
	var_02_denominator = “28,013”;
	b_bene_2 = input(left(trim(compress(translate(var_02_denominator,”,’,’,”,’%’)))),24.);
	pct_male_2 = input(left(trim(compress(translate(var_01_percentage,”,’,’,”,’%’)))),24.);
run;

/***********************************************************************;*/
/***********************************************************************;*/

var_01 = translate(var_01,”,'{');
var_03 = trim(left(compress(translate(var_02,’ ‘,byte(0)))));

/***********************************************************************;*/
/***********************************************************************;*/

length length_var_01 3. adj_var_01 $20;
length_var_01 = 0;
length_var_01 = length(var_01);
if reverse(substr(reverse(right(var_01)),1,1)) in (‘{‘)
then adj_var_01 = left(trim(reverse(substr(reverse(right(var_01)),2,length_var_01))));
else adj_var_01 = left(trim(var_01));

/***********************************************************************;*/
/*EndProgram
/***********************************************************************;*/


