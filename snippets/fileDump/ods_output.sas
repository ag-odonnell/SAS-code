
%let dir_path_data_01 = /sas/vrdc/data/support/GV/GV_DELETE_temp_hold/cme_bene_abcd_copy_for_ml/data/temp;
libname aa_lib01 "&dir_path_data_01.";

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

%macro macro_01();
	filename graphout "&dir_path_data_01./seriesg.gif";
	goptions reset=all device=gif gsfname=graphout;
	goptions vsize=8 hsize=15;
	ODS _all_ CLOSE;
	ODS LISTING;
		legend1 label=none
			position=(bottom center outside)
			frame;*
			mode=share;
		axis1 label=none;
		axis2 label=none;
		proc gplot
			data=seriesg;
			plot
				x*date
				/
				overlay
				grid
				legend=legend1
				haxis=axis1
				vaxis=axis2;
			symbol1 v=diamondfilled c=Magenta;
			title "Series Values for x";
			axis1
				offset=(1 cm)
				label=("Date: MMMYY");
			axis2
				label=(angle=90 "X: Passenger Count");
		run;
		quit;
		title;
	ODS LISTING CLOSE;
		
%mend macro_01;
%macro_01();

/************************************************************************************;*/

%macro macro_02();
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
			proc sgplot
				data=seriesg;
				scatter
					x=date
					y=x
					/ datalabel=x;
				title "Series Values for x";
				yaxis label="X: Passenger Count";
				xaxis label="Date: YYYY";
			run;
		quit;
		goptions RESET=(TITLE AXIS);
	ods pdf close;
%mend macro_02;
%macro_02();

/************************************************************************************;*/
/*endProgram
/************************************************************************************;*/
