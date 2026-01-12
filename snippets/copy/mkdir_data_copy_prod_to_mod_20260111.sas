
%let start_year=2017;
%let end_year=2021;

%let _source_01_root=%str(/sas/vrdc/users/aod657/files/OEDA_Prod/ODAP/CC/OTCC/TEP/RY2026/PROD/);
%let _target_01_root=%str(/sas/vrdc/users/aod657/files/OEDA_Prod/ODAP/CC/OTCC/TEP/RY2026/MOD/);
            
%macro m00;
    %do data_year = &start_year. %to &end_year.;
        %macro m01a(folder_name_path=);
            %if %sysfunc(fileexist(&_target_01_root.&folder_name_path.))=0 %then %do;
                x "%LOWCASE(mkdir) &_target_01_root.&folder_name_path.; %LOWCASE(y);";
            %end;
        %mend m01a;
        %m01a(folder_name_path=DY&data_year./);
        %m01a(folder_name_path=DY&data_year./data/);
        %m01a(folder_name_path=DY&data_year./data/bene_clms/);
        %m01a(folder_name_path=DY&data_year./data/claims/);
        %m01a(folder_name_path=DY&data_year./data/clmsum/);
        %m01a(folder_name_path=DY&data_year./data/everdates/);
        %m01a(folder_name_path=DY&data_year./data/bene_clms/final/);
        %m01a(folder_name_path=DY&data_year./data/claims/final/);
        %m01a(folder_name_path=DY&data_year./data/clmsum/final/);
        %m01a(folder_name_path=DY&data_year./data/everdates/final/);

        %macro m01b(folder_name_grp01=);
            %let _source_01=%str(/sas/vrdc/users/aod657/files/OEDA_Prod/ODAP/CC/OTCC/TEP/RY2026/PROD/DY&data_year./data/&folder_name_grp01./final/);
            %let _target_01=%str(/sas/vrdc/users/aod657/files/OEDA_Prod/ODAP/CC/OTCC/TEP/RY2026/MOD/DY&data_year./data/&folder_name_grp01./final/);
            X "cp &_source_01.* &_target_01.";
        %mend m01b;
        %m01b(folder_name_grp01=bene_clms);
        %m01b(folder_name_grp01=claims);
        %m01b(folder_name_grp01=clmsum);
        %m01b(folder_name_grp01=everdates);

        /*******/

        %macro m02a(folder_name_path=);
            %if %sysfunc(fileexist(&_target_01_root.&folder_name_path.))=0 %then %do;
                x "%LOWCASE(mkdir) &_target_01_root.&folder_name_path.; %LOWCASE(y);";
            %end;
        %mend m02a;
        %m02a(folder_name_path=DY&data_year./);
        %m02a(folder_name_path=DY&data_year./mdcr_only/);
        %m02a(folder_name_path=DY&data_year./mdcr_only/data/);
        %m02a(folder_name_path=DY&data_year./mdcr_only/data/cc/);
        %m02a(folder_name_path=DY&data_year./mdcr_only/data/coverage/);
        %m02a(folder_name_path=DY&data_year./mdcr_only/data/cc/final/);
        %m02a(folder_name_path=DY&data_year./mdcr_only/data/coverage/final/);

        %macro m02b(folder_name_grp02=);
            %let _source_02=%str(/sas/vrdc/users/aod657/files/OEDA_Prod/ODAP/CC/OTCC/TEP/RY2026/PROD/DY&data_year./mdcr_only/data/&folder_name_grp02./final/);
            %let _target_02=%str(/sas/vrdc/users/aod657/files/OEDA_Prod/ODAP/CC/OTCC/TEP/RY2026/MOD/DY&data_year./mdcr_only/data/&folder_name_grp02./final/);
            
            X "cp &_source_02.* &_target_02.";
        %mend m02b;
        %m02b(folder_name_grp02=cc);
        %m02b(folder_name_grp02=coverage);
    %end;
%mend m00;
%m00;
