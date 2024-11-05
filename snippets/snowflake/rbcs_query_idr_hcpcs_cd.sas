/**RBCS query HCPCS_CD from IDR : old code from Keri Apostle - "of course change the years."" */
PROC SQL;
    CONNECT TO TERADATA(database=cms_vdm_view_mdcr_prd Mode=Teradata SERVER="pd-nlb.biaaws.local" connection=global authdomain="TD_EUA ID");
    CREATE TABLE EUA ID_lib.HCPCS_IDR_17_21
    AS SELECT * FROM CONNECTION TO TERADATA (
        select *
        from V2_MDCR_HCPCS_CD
        where year(HCPCS_CD_ADD_DT) BETWEEN 2017 and 2021 or CLNDR_HCPCS_YR_NUM  BETWEEN 2017 and 2021;
    );
    DISCONNECT FROM TERADATA;
QUIT;
