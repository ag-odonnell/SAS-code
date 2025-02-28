proc datasets library = aalib02 nolist;
    delete dataset_01-datatset_05;
quit;

proc datasets library=_TEMP nolist;
    delete
        dual_&cyear._1_:
        dual_&cyear._2_:;
quit;
