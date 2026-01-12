
%let start_year=2023;
%let end_year=2024;

%macro m00;
    %do data_year = &start_year. %to &end_year.;
        %macro m01(folder_name_grp01=);
            %let _source_01=%str(/sas/vrdc/users/aod657/files/OEDA_Prod/ODAP/CC/OTCC/TEP/RY2026/PROD/DY&data_year./data/&folder_name_grp01./final/);
            %let _target_01=%str(/sas/vrdc/users/aod657/files/OEDA_Prod/ODAP/CC/OTCC/TEP/RY2026/MOD/DY&data_year./data/&folder_name_grp01./final/);
            
            X "cp &_source_01.* &_target_01.";
        %mend m01;
        /*%m01(folder_name_grp01=bene_clms);*/
        %m01(folder_name_grp01=claims);
        %m01(folder_name_grp01=clmsum);
        %m01(folder_name_grp01=everdates);

        %macro m02(folder_name_grp02=);
            %let _source_02=%str(/sas/vrdc/users/aod657/files/OEDA_Prod/ODAP/CC/OTCC/TEP/RY2026/PROD/DY&data_year./mdcr_only/data/&folder_name_grp02./final/);
            %let _target_02=%str(/sas/vrdc/users/aod657/files/OEDA_Prod/ODAP/CC/OTCC/TEP/RY2026/MOD/DY&data_year./mdcr_only/data/&folder_name_grp02./final/);
            
            X "cp &_source_02.* &_target_02.";
        %mend m02;
        /*%m02(folder_name_grp02=cc);*/
        %m02(folder_name_grp02=coverage);
    %end;
%mend m00;
%m00;