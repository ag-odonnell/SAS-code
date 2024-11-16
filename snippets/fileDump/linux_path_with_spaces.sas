
%let lib_ref_path_01=/pd_data/data/libs/gvdb/ccw_char/new;
%let lib_ref_path_02=/pd_data/data/libs/gvdb/dev/data/temp/aago/temp;
libname aalib01 "&lib_ref_path_01.";
libname aalib02 "&lib_ref_path_02.";
/*libname aalib03 "&myfiles_root./IPAG_SHARED/Resources/External Data Sources/PRVDR-Providers/PRVDR_POS-Provider of Service/Data/DY22-Data Year 2022/Modified"; /** */
libname aalib03 "/pd_data/data/support/share/IPAG/Resources/External Data Sources/PRVDR-Providers/PRVDR_POS-Provider of Service/Data/DY22-Data Year 2022/Modified";

/*******/

"/pd_data/data/support/share/IPAG/Resources/External Data Sources/PRVDR-Providers/PRVDR_POS-Provider of Service/Data/DY22-Data Year 2022/Modified/prvdr_pos_ey24_p01_v20_dy22.sas7bdat"
using LINUX command line:
cd /pd_data/data/support/share/IPAG/Resources/External\ Data\ Sources/PRVDR-Providers/PRVDR_POS-Provider\ of\ Service/Data/DY22-Data\ Year\ 2022/Modified/
