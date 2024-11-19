/* Delete datasets dataset_01 through dataset_05 */
proc delete data=work.dataset_01 work.dataset_02 work.dataset_03 work.dataset_04 work.dataset_05;
run;

/* Delete datasets dataset_01 through dataset_05 using PROC DATASETS */
proc datasets library=work nolist;
  delete dataset_01-dataset_05;
quit;
