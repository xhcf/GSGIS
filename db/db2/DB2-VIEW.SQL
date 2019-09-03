CREATE OR REPLACE VIEW KPI_REPORT_VIEW
AS
SELECT A.ID AS "ID", A.NAME AS "NAME", '指标库' AS "SYS_NAME", A.CREATE_USER AS "CREATE_USER", T.KPI_CODE AS "KPI_CODE", CONCAT (T.KPI_VERSION, '') AS "KPI_VERSION", A.CREATE_DATE AS "CREATE_DATE" 
  FROM ( 
  SELECT DISTINCT I.ID AS "ID", I.NAME AS "NAME", I.CREATE_USER AS "CREATE_USER", K.KPI_ID AS "KPI_ID", CAST(I.PUBLISH_TIME AS CHAR) AS "CREATE_DATE" 
  FROM X_REPORT_INFO I JOIN X_META_KPI K ON I.ID = K.REPORT_ID) A, X_KPI_INFO_TMP T 
  WHERE A.KPI_ID = CAST (T.KPI_KEY AS CHAR) 
  UNION 
  SELECT CONCAT (U.USEAREA_ID, '') AS "ID", U.REPORT_NAME AS "NAME", U.SYS_NAME AS "SYS_NAME", U.REPORT_CREATE_USER AS "REPORT_CREATE_USER", U.KPI_CODE AS "KPI_CODE", CONCAT (U.KPI_VERSION, '') AS "KPI_VERSION", CAST(U.REPORT_CREATE_DATE AS CHAR) AS "CREATE_DATE" 
  FROM X_KPI_INFO_TMP Z JOIN X_KPI_USEAREA U ON (Z.KPI_CODE = U.KPI_CODE AND Z.KPI_VERSION = U.KPI_VERSION)
WITH NO ROW MOVEMENT;

CREATE OR REPLACE VIEW VIEW_ALL_KPI
AS
select t.id as id,         t.kpi_category as parent_id,         t.kpi_name as name,         t.base_key as kpi_code,         t.kpi_version as kpi_version,         t.type as kpi_type,         t.account_type,         'basekpi' as type,         '0' as dim_attr,         t.cube_code,         '3' data_type,         t.kpi_code busikey,         t.kpi_category,         t.create_time,         t.kpi_ord    
  from x_base_kpi t    
  where t.kpi_state='1'  
  union all  
  select t.kpi_key,         t.kpi_category,         t.kpi_name,         t.kpi_code,         t.kpi_version,         t.kpi_type as kpi_type,         t.accttype,         'compositeKpiNode' as type,         '0' as dim_attr,          t.cube_code,          '2' data_type,          SERVICE_KEY as busikey,          t.kpi_category,          t.create_datetime,          t.kpi_ord    
  from x_kpi_info t   
  where t.kpi_flag != 'D'
WITH NO ROW MOVEMENT;

CREATE OR REPLACE VIEW VIEW_ALL_KPI_HIS
AS
SELECT H.BASE_KEY KPI_CODE,         H.KPI_VERSION KPI_VERSION,         H.KPI_NAME KPI_NAME,         SUBSTR(H.CREATE_TIME, 1, 8) CREATE_DATETIME,         H.KPI_ORIGIN_REGULAR KPI_CALIBER,         H.KPI_EXPLAIN KPI_EXPLAIN    
  FROM X_BASE_KPI_HIS H  
  UNION ALL  
  SELECT T.KPI_CODE,         T.KPI_VERSION KPI_VERSION,         T.KPI_NAME,         SUBSTR(T.CREATE_DATETIME, 1,8) CREATE_DATETIME,         T.KPI_CALIBER,         T.KPI_EXPLAIN    
  FROM X_KPI_INFO_TMP T
WITH NO ROW MOVEMENT;

CREATE OR REPLACE VIEW VIEW_DIM
AS
SELECT T.TABLE_NAME,         T.COLUMN_DESC,         T.COLUMN_NAME AS DIM_FIELD,         '' AS CODE,         '' AS NAME,         '' AS AILS,         '' AS CONDITION,         '1' AS CONF_TYPE,         T.ID || '' AS DIM_CODE,         '' AS SQL_CODE,         C.CUBE_DATASOURCE AS DATASOURCE,         '2' AS DIM_TYPE,         T.ATTR_TYPE,         T.TABLE_NAME AS DIM_TABLE,         C.CUBE_CODE AS CUBE_CODE    
  FROM X_KPI_CUBE C, X_KPI_RAL_ATTR T   
  WHERE T.CUBE_CODE = C.CUBE_CODE  
  UNION  
  SELECT (CASE WHEN T.CONF_TYPE = '2' THEN  NULL ELSE  T.CODE_TABLE 
  END) AS TABLENAME,         T.CODE_TABLE_DESC AS DIM_NAME,         D.COLUMN_CODE AS DIM_FIELD,         T.COLUMN_CODE AS CODE,         T.COLUMN_DESC AS NAME,         T.COLUMN_ORD AS AILS,         T.CONDITION,         T.CONF_TYPE,         T.DIM_CODE,         (CASE WHEN T.CONF_TYPE= '1' THEN  NULL ELSE  T.CODE_TABLE 
  END) AS SQL_CODE,         C.CUBE_DATASOURCE AS DATASOURCE,         '1' AS DIM_TYPE,         'R' AS ATTR_TYPE,         D.TABLE_NAME AS DIM_TABLE,         C.CUBE_CODE AS CUBE_CODE    
  FROM X_KPI_CUBE C, X_KPI_RAL_DIM D, X_KPI_DIM_CODE T   
  WHERE T.DIM_CODE = D.DIM_CODE     AND D.CUBE_CODE = C.CUBE_CODE  
  union  
  SELECT         TABLENAME,         DIM_NAME,         DIM_FIELD,         CODE AS CODE,         NAME AS NAME,         AILS AS AILS,         CONDITION,         CONF_TYPE,         DIM_CODE,         SQL_CODE,         CUBE_DATASOURCE AS DATASOURCE,         '1' AS DIM_TYPE,         'R' AS ATTR_TYPE,         null as DIM_TABLE,         ACCOUNT_TYPE AS CUBE_CODE    
  FROM (
  SELECT T.DIM_CODE,                 T.DIM_NAME,                 T.DIM_FIELD,                 (CASE                     WHEN T.CONF_TYPE = '0' THEN                      CONCAT(CONCAT(T.SRC_ONWER, '.'), T.SRC_TABLE)                     ELSE                      NULL                   
  END) AS TABLENAME,                 (
  SELECT CODE                    
  FROM X_SUB_BASEDIM_INFO                   
  WHERE DIM_ID = T.ID                     AND NAME = 'code') AS CODE,                 (
  SELECT CODE                    
  FROM X_SUB_BASEDIM_INFO                   
  WHERE DIM_ID = T.ID                     AND NAME = 'name') AS NAME,                  (
  SELECT CODE                    
  FROM X_SUB_BASEDIM_INFO                   
  WHERE DIM_ID = T.ID                     AND NAME = 'ails') AS AILS,                 T.CONDITION,                 (CASE                     WHEN T.CONF_TYPE = '0' THEN                      '1'                     ELSE                      '2'                   
  END) AS CONF_TYPE,                   (CASE                     WHEN T.CONF_TYPE = '1' THEN                      SQL_CODE                     ELSE                      NULL                   
  END) AS SQL_CODE,                 T.DATASOURCE AS CUBE_DATASOURCE,                 T.ACCOUNT_TYPE            
  FROM X_BASEDIM_INFO T           
  WHERE T.DIM_TYPE = '1')   
  WHERE CODE IS NOT NULL
WITH NO ROW MOVEMENT;

CREATE OR REPLACE VIEW VIEW_DIM_CODE
AS
SELECT T.DIM_CODE,         (CASE           WHEN T.CONF_TYPE = '2' THEN            NULL           ELSE            T.CODE_TABLE         
  END) AS TABLENAME,         T.COLUMN_CODE AS CODE,         T.COLUMN_DESC AS NAME,         T.CONDITION,         T.CONF_TYPE,         (CASE           WHEN T.CONF_TYPE = '1' THEN            NULL           ELSE            T.CODE_TABLE         
  END) AS SQL_CODE,         C.CUBE_DATASOURCE    
  FROM X_KPI_CUBE C, X_KPI_RAL_DIM D, X_KPI_DIM_CODE T   
  WHERE T.DIM_CODE = D.DIM_CODE     AND D.CUBE_CODE = C.CUBE_CODE    
  UNION    
  SELECT DIM_CODE,           TABLENAME,           CODE AS CODE,           NAME AS NAME,           CONDITION,           CONF_TYPE,           SQL_CODE,           CUBE_DATASOURCE      
  FROM (
  SELECT T.DIM_CODE,                   (CASE                     WHEN T.CONF_TYPE = '0' THEN                      CONCAT(CONCAT(T.SRC_ONWER, '.'), T.SRC_TABLE)                     ELSE                      NULL                   
  END) AS TABLENAME,                   (
  SELECT CODE                      
  FROM X_SUB_BASEDIM_INFO                     
  WHERE DIM_ID = T.ID                       AND NAME = 'code') AS CODE,                   (
  SELECT CODE                      
  FROM X_SUB_BASEDIM_INFO                     
  WHERE DIM_ID = T.ID                       AND NAME = 'name') AS NAME,                   T.CONDITION,                   (CASE                     WHEN T.CONF_TYPE = '0' THEN                      '1'                     ELSE                      '2'                   
  END) AS CONF_TYPE,                   (CASE                     WHEN T.CONF_TYPE = '1' THEN                      SQL_CODE                     ELSE                      NULL                   
  END) AS SQL_CODE,                   T.DATASOURCE AS CUBE_DATASOURCE              
  FROM X_BASEDIM_INFO T             
  WHERE T.DIM_TYPE = '1') T     
  WHERE CODE IS NOT NULL
WITH NO ROW MOVEMENT;

CREATE OR REPLACE VIEW VIEW_KPI
AS
select t.category_id as id,         t.category_parent_id as parent_id,         t.category_name as name,         null as kpi_code,         '' as kpi_caliber,         '' as kpi_explain,         null as kpi_version,         '0' as kpi_type,         t.account_type as account_type,         (case when t.category_type = '1' then 'compositeKpiRoot'               when t.category_type = '2' then 'compositeKpiRoot'               when t.category_type = '3' then 'compositeKpiRoot'               when t.category_type = '4' then 'baseKpiRoot'               when t.category_type = '5' then 'baseLabelRoot'               when t.category_type = '6' then 'baseDimRoot'               else  'compositeKpiCategory' 
  end)as type,         '0' as dim_attr,          t.cube_code as cube_code,          '1' as data_type,          ord as ord    
  from x_kpi_category t   
  where category_flag  is null  
  union all  
  select t.id,         t.kpi_category,         t.kpi_name,         t.base_key,         t.kpi_origin_regular kpi_caliber,         t.kpi_explain,         t.kpi_version,         t.type,         t.account_type,         'basekpi' as type,         '0' as dim_attr,         t.cube_code,         (case when type ='4' then '3' else '5' 
  end) as data_type,         kpi_ord as ord    
  from x_base_kpi t    
  where t.kpi_state='1'  
  union all  
  select t.kpi_key,         t.kpi_category,         t.kpi_name,         t.kpi_code,         t.kpi_caliber,         t.kpi_explain,         t.kpi_version,         t.kpi_type as kpi_type,         t.accttype,         'compositeKpiNode' as type,         '0' as dim_attr,          t.cube_code,          '2' data_type,          kpi_ord as ord    
  from x_kpi_info t   
  where t.kpi_flag != 'D'
WITH NO ROW MOVEMENT;

CREATE OR REPLACE VIEW VIEW_KPI_DIM
AS
SELECT KPI_CODE, KPI_NAME, KPI_CALIBER, KPI_EXPLAIN, T.KPI_USER, T.KPI_DEPT, T.EXPLAIN, T.ACCTTYPE 
  FROM X_KPI_INFO T 
  WHERE KPI_FLAG <> 'D' 
  UNION ALL 
  SELECT BASE_KEY AS KPI_CODE, KPI_NAME, KPI_ORIGIN_REGULAR, KPI_EXPLAIN, KPI_PROPOSER, KPI_PROPOSER_DEPT, T.KPI_ORIGIN_DESC, T.ACCOUNT_TYPE 
  FROM X_BASE_KPI T 
  WHERE T.KPI_STATE = '1'
WITH NO ROW MOVEMENT;

CREATE OR REPLACE VIEW VIEW_KPI_INTERFACE
AS
SELECT CAST(T.KPI_KEY AS VARCHAR(2000)) AS "ID", T.KPI_CODE AS "KPI_CODE", CAST(T.KPI_CATEGORY AS VARCHAR(2000)) AS "PID", T.KPI_NAME AS "NAME", T.KPI_CODE AS "KPI_FIELD", '0' AS "ISLEAF", T.ACCTTYPE AS "ACCTTYPE", T.KPI_TYPE AS "KPITYPE", '1' AS "ISKPI", CAST(T.CUBE_CODE AS VARCHAR(2000)) AS "CUBE_CODE", '1' AS "DATA_TYPE", T.KPI_ORD AS "KPI_ORD" 
  FROM X_KPI_INFO T 
  WHERE T.KPI_FLAG != 'D' 
  UNION 
  SELECT CONCAT(CONCAT(T.KPI_KEY,'_') ,T2.ATTR_CODE) AS "ID", CONCAT(CONCAT(T.KPI_CODE,'_'),T2.ATTR_CODE) AS "KPI_CODE", CAST(T.KPI_KEY AS CHAR) AS "PID", CONCAT(CONCAT(T.KPI_NAME ,'_') ,T2.ATTR_NAME) AS "KPI_NAME", T.KPI_CODE AS "KPI_FIELD", '1' AS "ISLEAF", T.ACCTTYPE AS "ACCTTYPE", T.KPI_TYPE AS "KPITYPE", '0' ISKPI, T.CUBE_CODE||'' CUBE_CODE, '2' AS "DATA_TYPE", T.KPI_ORD AS "KPI_ORD" 
  FROM X_KPI_INFO T INNER JOIN ( 
  SELECT T1.KPI_CODE, T1.KPI_VERSION, T2.ATTR_CODE , T2.ATTR_NAME 
  FROM X_KPI_ATTR_RELATION T1 INNER JOIN X_KPI_ATTRIBUTE T2 ON T1.ATTR_CODE = T2.ATTR_CODE AND T1.ACCTTYPE = T2.ATTR_TYPE ) T2 ON T.KPI_CODE = T2.KPI_CODE AND T.KPI_VERSION = T2.KPI_VERSION 
  WHERE T.KPI_FLAG != 'D' 
  UNION 
  SELECT CAST(X.ID AS VARCHAR(2000)) AS "ID", X.BASE_KEY AS "KPI_CODE", CAST(X.KPI_CATEGORY AS VARCHAR(2000)) AS "PID", X.KPI_NAME AS "NAME", X.BASE_KEY AS "KPI_FIELD", '1' AS "ISLEAF", X.ACCOUNT_TYPE AS "ACCOUNT_TYPE", '0' AS "KPITYPE", '1' AS "ISKPI", CAST(X.CUBE_CODE AS VARCHAR(2000)) AS "CUBE_CODE", '1' AS "DATA_TYPE", X.KPI_ORD AS "KPI_ORD" 
  FROM X_BASE_KPI X 
  WHERE X.KPI_STATE = '1'
WITH NO ROW MOVEMENT;

CREATE OR REPLACE VIEW DUAL
AS
select IBMREQD as DUMMY 
  from SYSIBM.SYSDUMMY1
WITH NO ROW MOVEMENT;

CREATE OR REPLACE VIEW CONSECUTIVE_2YEAR_MON
AS
with t(rownum,acct_month,acct_desc) as ( 
  select 0 as rownum, to_char(sysdate,'yyyymm') acct_month, replace(to_char(sysdate,'yyyy-mm'),'-','年')||'月' acct_desc 
  from dual 
  union all 
  select t.rownum+1 as rownum, to_char(ADD_MONTHS(sysdate, -(t.rownum+1)),'yyyymm') acct_month, replace(to_char(add_months(sysdate, -(t.rownum+1)),'yyyy-mm'),'-','年')||'月' acct_desc 
  from dual,t 
  where t.rownum<25 ) 
  select acct_month,acct_desc 
  from t
WITH NO ROW MOVEMENT;