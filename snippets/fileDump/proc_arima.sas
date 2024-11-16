/*--------------------------------------------------------------

                    SAS Sample Library

        Name: ariex02.sas
 Description: Example program from SAS/ETS User's Guide,
              The ARIMA Procedure
       Title: Seasonal Model for the Airline Series
     Product: SAS/ETS Software
        Keys: time series analysis
        PROC: ARIMA
       Notes:

--------------------------------------------------------------*/

%let dir_path_data_01 = /sas/vrdc/data/support/GV/GV_DELETE_temp_hold/cme_bene_abcd_copy_for_ml/data/data_out;
libname aa_lib01 "&dir_path_data_01.";

goptions reset=all;
ods _all_ close;
ods graphics on / width=10.49in height=7.5in;
ods pdf file="&dir_path_data_01./seriesg.pdf";
	options
		orientation=landscape
		nocenter
		topmargin=.25in
		bottommargin=.25in
		leftmargin=.25in
		rightmargin=.25in;

	/************************************************************************************;*/
	
	title1 'International Airline Passengers';
	title2 '(Box and Jenkins Series-G)';
	data seriesg;
	   input x @@;
	   xlog = log( x );
	   date = intnx( 'month', '31dec1948'd, _n_ );
	   format date monyy.;
	datalines;
	112 118 132 129 121 135 148 148 136 119 104 118
	115 126 141 135 125 149 170 170 158 133 114 140
	145 150 178 163 172 178 199 199 184 162 146 166
	171 180 193 181 183 218 230 242 209 191 172 194
	196 196 236 235 229 243 264 272 237 211 180 201
	204 188 235 227 234 264 302 293 259 229 203 229
	242 233 267 269 270 315 364 347 312 274 237 278
	284 277 317 313 318 374 413 405 355 306 271 306
	315 301 356 348 355 422 465 467 404 347 305 336
	340 318 362 348 363 435 491 505 404 359 310 337
	360 342 406 396 420 472 548 559 463 407 362 405
	417 391 419 461 472 535 622 606 508 461 390 432
	;

	/************************************************************************************;*/

	proc timeseries data=seriesg plot=series;
	   id date interval=month;
	   var x;
	run;
	
	/*-- Seasonal Model for the Airline Series --*/
	proc arima data=seriesg;
	   identify var=xlog(1,12);
	   estimate q=(1)(12) noint method=ml;
	   forecast id=date interval=month printall out=b;
	run;

	data c;
	   set b;
	   x        = exp( xlog );
	   forecast = exp( forecast + std*std/2 );
	   l95      = exp( l95 );
	   u95      = exp( u95 );
	run;

	proc sgplot data=c;
	   where date >= '1jan58'd;
	   band Upper=u95 Lower=l95 x=date
		  / LegendLabel="95% Confidence Limits";
	   scatter x=date y=x;
	   series x=date y=forecast;
	run;
	
	goptions RESET=(TITLE AXIS);
ods pdf close;

/************************************************************************************;*/
/*endProgram
/************************************************************************************;*/
