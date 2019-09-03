<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@taglib prefix="a" tagdir="/WEB-INF/tags/app" %>
<e:set var="sql_part_tab">
  <e:description>EDW.TB_MKT_ORDER_LIST@GSEDW</e:description>
  ${gis_user}.VIEW_GIS_ORDER_LIST_TMP
</e:set>
<e:switch value="${param.eaction}">
  <e:description>支局长部分 begin</e:description>
  <e:case value="getBaseInfo">
    <e:q4o var="dataObject">
      SELECT COUNT(*) GRID_COUNT
	    FROM ${gis_user}.DB_CDE_GRID
	  WHERE GRID_STATUS = 1
	    AND BRANCH_TYPE IN ('a1', 'b1')
	    AND UNION_ORG_CODE = '${param.substation}'
	    AND GRID_UNION_ORG_CODE <> '-1'
    </e:q4o>${e:java2json(dataObject)}
  </e:case>

  <e:description>已废弃，日派单数 以get_yx_data为主</e:description>
  <e:case value="get_jz_count">
    <e:q4o var="dataObject">
      select * from (
      SELECT COUNT(1) JZ_COUNT
      FROM EDW.TB_MKT_ORDER_LIST@GSEDW
      WHERE UNION_ORG_CODE = '${param.substation}'),
      (select '--' yw_exec_lv_day,'--' yw_exec_lv_month from dual)
    </e:q4o>${e:java2json(dataObject)}
  </e:case>

  <e:case value="get_yw_count">
    <e:q4o var="dataObject">
      <e:description>
      SELECT NVL(SUM(A.DQ_1_COUNT), 0) + NVL(SUM(A.DQ_2_COUNT), 0) DQ_COUNT
      FROM ${gis_user}.VIEW_GIS_GRID_COLLECT A
      WHERE 1 = 1
      AND A.BRANCH_TYPE IN ('a1', 'b1')
      AND A.UNION_ORG_CODE = '${param.substation}'
      GROUP BY LATN_ID,
      BUREAU_NO,
      BUREAU_NAME,
      UNION_ORG_CODE,
      BRANCH_NAME
      ORDER BY BUREAU_NO, UNION_ORG_CODE
      </e:description>
      SELECT
      count(1) DQ_COUNT
      FROM
      ${gis_user}.TB_GIS_ADDR_OTHER_ALL T,
      SDE.TB_GIS_MAP_SEGM_LATN_MON C
      WHERE
      T.SEGM_ID = C.SEGM_ID
      AND (TO_CHAR(T.KD_DQ_DATE, 'YYYYMM') = TO_CHAR(SYSDATE, 'YYYYMM') OR TO_CHAR(T.KD_DQ_DATE, 'YYYYMM') = TO_CHAR(ADD_MONTHS(SYSDATE,1), 'YYYYMM'))
      AND T.KD_BUSINESS <> '5'
      AND C.UNION_ORG_CODE ='${param.substation }'
    </e:q4o>${e:java2json(dataObject)}
  </e:case>
  <e:case value="get_jz_rate">
    <e:q4o var="dataObject">
      select * from (
      SELECT CASE
      WHEN COUNT(T2.ORDER_ID) = 0 THEN
      '--'
      ELSE
      TO_CHAR(SUM(CASE
      WHEN T2.EXEC_STAT <> 0 THEN
      1
      ELSE
      0
      END) / COUNT(T2.ORDER_ID) * 100,
      'FM99999999990.00') || '%'
      END RATE_DAY
      FROM ${gis_user}.TB_DIM_TIME T1
      LEFT JOIN EDW.TB_MKT_ORDER_LIST@GSEDW  T2
      ON T2.ORDER_DATE = T1.DAY_CODE
      AND T2.UNION_ORG_CODE = '${param.substation}'
      WHERE 1 = 1
      AND T1.DAY_CODE = TO_CHAR(SYSDATE, 'yyyymmdd')
      GROUP BY SUBSTR(T1.DAY_CODE, 7, 2)),
      (SELECT CASE
      WHEN COUNT(T2.ORDER_ID) = 0 THEN
      '--'
      ELSE
      TO_CHAR(SUM(CASE
      WHEN T2.EXEC_STAT <> 0 THEN
      1
      ELSE
      0
      END) / COUNT(T2.ORDER_ID) * 100,
      'FM99999999990.00') || '%'
      END RATE_MONTH
      FROM ${gis_user}.TB_DIM_TIME T1
      LEFT JOIN EDW.TB_MKT_ORDER_LIST@GSEDW  T2
      ON T2.ORDER_DATE = T1.DAY_CODE
      AND T2.UNION_ORG_CODE = '${param.substation}'
      WHERE 1 = 1
      AND T1.MONTH_CODE = TO_CHAR(SYSDATE, 'YYYYMM')
      GROUP BY SUBSTR(T1.DAY_CODE, 1, 6))
    </e:q4o>${e:java2json(dataObject)}
  </e:case>

  <e:case value="getCollect">
    <e:q4o var="dataObject">
      SELECT * FROM ( SELECT COUNT(VILLAGE_ID) VILLAGE_NUM
      FROM ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO
      WHERE BRANCH_NO = '${param.substation}'),
      (SELECT COUNT(SEGM_ID) BUILD_IN_MAP
      FROM ${gis_user}.TB_GIS_VILLAGE_ADDR4
      WHERE VILLAGE_ID IN
      (SELECT VILLAGE_ID
      FROM ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO
      WHERE BRANCH_NO = '${param.substation}')),
      (SELECT SUM(NUM) COLLECT_NUM
      FROM ${gis_user}.VIEW_GIS_GRID_COLLECT
      WHERE UNION_ORG_CODE = '${param.substation}'),
      (SELECT NO_INSTALL_CNT,no_res_village_cnt
      FROM ${gis_user}.TB_GIS_RES_INFO_DAY
      WHERE FLG = 3
      AND LATN_ID = '${param.substation}')
    </e:q4o>${e:java2json(dataObject)}
  </e:case>
  <e:description>获取异网执行率</e:description>
  <e:case value="get_yw_rate">
    <e:q4o var="dataObject">
        SELECT '0.00%' DAY_RATE, '0.00%' MONTH_RATE FROM DUAL
    </e:q4o>${e: java2json(dataObject) }
  </e:case>

  <e:description>支局下的行政村数</e:description>
  <e:case value="getVillageCellCnt">
      <e:q4o var="dataObject">
        SELECT count(DISTINCT a.village_id) vc_cnt FROM edw.vw_tb_cde_village@gsedw a,
        ${gis_user}.db_cde_grid b
        WHERE a.branch_no = b.branch_no
        AND b.union_org_code = '${param.substation}'
      </e:q4o>${e: java2json(dataObject)}
  </e:case>

  <e:description>支局下的营销汇总数</e:description>
  <e:case value="getYxSummary">
    <e:q4o var="dataObject">
      SELECT COUNT(1) JZ_COUNT
      FROM EDW.TB_MKT_ORDER_LIST@GSEDW
      WHERE UNION_ORG_CODE = '${param.substation}'
    </e:q4o>${e: java2json(dataObject)}
  </e:case>

  <e:description>首页基础信息加载</e:description>
  <e:case value="get_info_all">
  <e:q4l var="list">
    SELECT DECODE(NVL(HOUSEHOLD_NUM, '0'),
    '0',
    ' ',
    TO_CHAR(ROUND(NVL(H_USE_CNT, 0) / HOUSEHOLD_NUM, 4) * 100,
    'FM990.00') || '%') MARKET_RATE,
    HOUSEHOLD_NUM,
    POPULATION_NUM,
    H_USE_CNT,
    nvl(ITV_CNT,0) ITV_CNT,
    0 YD_NUM,
    0 DY_NUM,
    R_USE_CNT RY_NUM,
    DECODE(NVL(H_USE_CNT, '0'),0,'0.00%',TO_CHAR(ROUND(NVL(R_USE_CNT, 0) / H_USE_CNT, 4) * 100,'FM990.00') || '%') RH_RATE,
    DECODE(NVL(BRIGADE_ID_CNT, '0'),
    0,
    '0.00%',
    TO_CHAR(ROUND(NVL(ZY_CNT, 0) / BRIGADE_ID_CNT, 4) * 100,
    'FM990.00') || '%') RESOURCE_RATE,
    ZY_CNT,
    BRIGADE_ID_CNT,
    nvl(brigade_id_cnt,0) - nvl(zy_cnt,0) resource_unreach_cnt,
    NVL(T.EQP_CNT, 0) OBD_CNT,
    high_use_cnt H_OBD_CNT,
    zero_use_cnt L_OBD_CNT,
    DECODE(NVL(CAPACITY, 0),
    0,
    '0.00%',
    TO_CHAR(ROUND(NVL(ACTUALCAPACITY, 0) / CAPACITY, 4) * 100,
    'FM990.00') || '%') PORT_LV,
    NVL(CAPACITY, 0) CAPACITY,
    NVL(ACTUALCAPACITY, 0) ACTUALCAPACITY,
    NVL(CAPACITY, 0) - NVL(ACTUALCAPACITY, 0) FREE_PORT,
    0 YX_CNT,
    0 YX_ZX_LV_DAY,
    0 YX_ZX_LV_MONTH,
    0 YWYJ,
    0 YW_ZX_LV_DAY,
    0 YW_ZX_LV_MONTH,
    DECODE(NVL(Y_COLLECT_CNT, 0),
    0,
    '0.00%',
    TO_CHAR((case when NVL(Y_COLLECT_CNT, 0)<0 then 0 else ROUND(NVL(COLLECT_CNT, 0) / Y_COLLECT_CNT, 4) end) * 100,
    'FM990.00') || '%') COLLECT_LV,
    case when NVL(Y_COLLECT_CNT, 0)<0 then 0 else NVL(Y_COLLECT_CNT, 0) end Y_COLLECT_CNT,
    NVL(COLLECT_CNT, 0) COLLECT_CNT,
    NVL(YW_COLLECT_CNT, 0) YW_COLLECT_CNT,
    NVL(ZX_COLLECT_CNT, 0) ZX_COLLECT_CNT,
    0 XZ_VILL_CNT,
    0 BAO_YOU_LV,
    '0.00%' HY_LV,
    '0.00%' XY_LV,
    '0.00%' LW_LV
    FROM ${gis_user}.TB_GIS_COUNT_INFO_D t
    WHERE FLG = 7
    AND LATN_ID = (SELECT DISTINCT branch_no FROM ${gis_user}.db_cde_grid WHERE union_org_code = '${param.substation }' )
    AND ACCT_DAY = (SELECT CONST_VALUE
    FROM SYS_CONST_TABLE
    WHERE CONST_TYPE = 'var.dss27'
    AND DATA_TYPE = 'day'
    AND CONST_NAME = 'calendar.curdate')
  </e:q4l>${e: java2json(list.list) }
  </e:case>

  <e:description>支局汇总信息补充</e:description>
  <e:case value="get_info_all2">
    <e:q4o var="dataObject">
      SELECT
      '支局汇总信息补充' a,
      nvl(gz_h_rh_count,0) together_broadband_user,
      to_char(round(decode(nvl(gz_h_use_cnt,0),0,0,nvl(gz_h_rh_count,0)/nvl(gz_h_use_cnt,0)),4)*100,'FM9999999990.00') || '%' together_broadband_lv,
      nvl(gov_h_rh_count,0) gov_together_broadband,
      to_char(round(decode(nvl(gov_h_use_cnt,0),0,0,nvl(gov_h_rh_count,0)/nvl(gov_h_use_cnt,0)),4)*100,'FM9999999990.00') || '%' gov_together_broadband_lv
      FROM ${gis_user}.TB_GIS_RES_INFO_DAY
      WHERE LATN_ID = '${param.substation }'
      <e:description>已废弃20190410
      SELECT
      nvl(mobile_user,0) mobile_user,
      nvl(single_product_user,0) single_product_user,
      nvl(together_product_user,0) together_product_user,
      nvl(work_mobile_user,0) work_mobile_user,
      nvl(home_mobile_user,0) home_mobile_user
      FROM ${gis_user}.TB_DW_GIS_GIRD_BASE_M WHERE flag = 4 AND org_code =
      (SELECT DISTINCT branch_no FROM ${gis_user}.db_cde_grid WHERE union_org_code = '${param.substation}')
      AND acct_month = (SELECT const_value FROM easy_data.sys_const_table WHERE const_type = 'var.dss23' AND data_type = 'mon')
      </e:description>
    </e:q4o>${e:java2json(dataObject)}
  </e:case>

  <e:description>支局长部分 end</e:description>

  <e:description>获取未进小区的楼宇列表</e:description>
  <e:case value="getUnusedBuildList">
	  <e:q4l var="dataList">
	  	SELECT *
          FROM (SELECT RESID, RESFULLNAME, C_NUM, ROWNUM RN
            FROM (SELECT A.*, COUNT(1) OVER() C_NUM
                    FROM SDE.MAP_ADDR_SEGM_${param.latn_id} A
                   WHERE 1 = 1
                     <e:if condition="${!empty param.union_org_code}">
              and UNION_ORG_CODE = '${param.union_org_code}'
           </e:if>
           <e:if condition="${!empty param.grid_id}">
                          and GRID_UNION_ORG_CODE = '${param.grid_id}'
                 </e:if>
                     AND RESID NOT IN
                         (SELECT SEGM_ID FROM ${gis_user}.TB_GIS_VILLAGE_ADDR4)
                  )
           WHERE ROWNUM <= (${param.page} + 1) * 25)
         WHERE RN > ${param.page} * 25
	  </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>概述弹窗 营销派单类数据</e:description>
  <e:case value="get_yx_data">
    <e:q4o var="dataObject">
      <e:description>
      SELECT '支局营销类数据' A,
      TO_CHAR(ROUND(DECODE(ALL_CNT_D, 0, 0, EXEC_CNT_D / ALL_CNT_D), 4) * 100,
      'FM99999999990.00') || '%' RATE_DAY,
      TO_CHAR(ROUND(DECODE(ALL_CNT_D, 0, 0, SUCC_CNT_D / ALL_CNT_D), 4) * 100,
      'FM99999999990.00') || '%' SUCC_DAY,
      TO_CHAR(ROUND(DECODE(ALL_CNT_M, 0, 0, EXEC_CNT_M / ALL_CNT_M), 4) * 100,
      'FM99999999990.00') || '%' RATE_MONTH,
      TO_CHAR(ROUND(DECODE(ALL_CNT_M, 0, 0, SUCC_CNT_M / ALL_CNT_M), 4) * 100,
      'FM99999999990.00') || '%' SUCC_MONTH,
      NVL(ALL_CNT_D,0) ALL_CNT_D,
      nvl(EXEC_CNT_D,0) EXEC_CNT_D,
      NVL(ALL_CNT_M,0) ALL_CNT_M,
      nvl(EXEC_CNT_M,0) EXEC_CNT_M
      FROM (SELECT SUM(CASE
      WHEN T2.EXEC_STAT <> 0 AND
      T2.ORDER_DAY = TO_CHAR(SYSDATE-1, 'yyyymmdd') THEN
      1
      ELSE
      0
      END) EXEC_CNT_D,
      SUM(CASE
      WHEN T2.SUCC_FLAG <> 0 AND
      T2.ORDER_DAY = TO_CHAR(SYSDATE-1, 'yyyymmdd') THEN
      1
      ELSE
      0
      END) SUCC_CNT_D,
      COUNT(CASE
      WHEN T2.ORDER_DAY = TO_CHAR(SYSDATE-1, 'yyyymmdd') THEN
      ORDER_ID
      ELSE
      NULL
      END) ALL_CNT_D,
      SUM(CASE
      WHEN T2.EXEC_STAT <> 0 THEN
      1
      ELSE
      0
      END) EXEC_CNT_M,
      SUM(CASE
      WHEN T2.SUCC_FLAG <> 0 THEN
      1
      ELSE
      0
      END) SUCC_CNT_M,
      COUNT(ORDER_ID) ALL_CNT_M
      FROM ${sql_part_tab} T2
      WHERE
      t2.union_org_code = '${param.substation}'
      and t2.scene_id <> '999'
      and t2.succ_flag = 0
      )
      </e:description>

      SELECT
      '支局营销类数据' A,
      T.LATN_ID REGION_ID,
      T.LATN_NAME AREA_DESC,
      NVL(SUM(NVL(T.ORDER_CNT, 0)), 0) ALL_CNT_D,
      NVL(SUM(NVL(T.EXEC_CNT, 0) - NVL(T1.EXEC_CNT, 0)), 0) EXEC_CNT_D,
      DECODE(NVL(SUM(NVL(T.ORDER_CNT, 0)), 0),
      '0',
      '0.00%',
      TO_CHAR(ROUND(SUM(NVL(T.EXEC_CNT - T1.EXEC_CNT,
      0)) /
      SUM(NVL(T.ORDER_CNT, 0)),
      4) * 100,
      'FM999999990.00') || '%') RATE_DAY,
      NVL(SUM(NVL(T.SUCC_CNT - T1.SUCC_CNT, 0)), 0) SUCC_CNT_D,
      DECODE(NVL(SUM(NVL(T.ORDER_CNT, 0)), 0),
      '0',
      '0.00%',
      TO_CHAR(ROUND(SUM(NVL(T.SUCC_CNT - T1.SUCC_CNT,
      0)) /
      SUM(NVL(T.ORDER_CNT, 0)),
      4) * 100,
      'FM999999990.00') || '%') SUCC_DAY,

      NVL(SUM(NVL(T.ORDER_CNT, 0)), 0) ALL_CNT_M,
      NVL(SUM(NVL(T.EXEC_CNT, 0)), 0) EXEC_CNT_M,
      DECODE(NVL(SUM(NVL(T.ORDER_CNT, 0)), 0),
      '0',
      '0.00%',
      TO_CHAR(ROUND(SUM(NVL(T.EXEC_CNT, 0)) /
      SUM(NVL(T.ORDER_CNT, 0)),
      4) * 100,
      'FM999999990.00') || '%') RATE_MONTH,
      NVL(SUM(NVL(T.SUCC_CNT, 0)), 0) SUCC_CNT_M,
      DECODE(NVL(SUM(NVL(T.ORDER_CNT, 0)), 0),
      '0',
      '0.00%',
      TO_CHAR(ROUND(SUM(NVL(T.SUCC_CNT, 0)) /
      SUM(NVL(T.ORDER_CNT, 0)),
      4) * 100,
      'FM999999990.00') || '%') SUCC_MONTH,
      COUNT(1) OVER() C_NUM
      FROM ${gis_user}.VIEW_GSCH_MKT_ORDER_STAT_DAY T,
      ${gis_user}.VIEW_GSCH_MKT_ORDER_STAT_DAY T1,
      (select distinct latn_id,bureau_no,branch_no,union_org_code from ${gis_user}.db_cde_grid) m
      WHERE T.LATN_ID = T1.LATN_ID
      AND T.BRANCH_TYPE = T1.BRANCH_TYPE
      AND T.SCENE_ID = T1.SCENE_ID
      AND T.STAT_LVL = T1.STAT_LVL
      AND T.ACCT_DAY = TO_CHAR(sysdate,'yyyymmdd')
      AND T1.ACCT_DAY = TO_CHAR(sysdate - 1,'yyyymmdd')
      AND T.BRANCH_TYPE <> 'c1'
      AND T.STAT_LVL = 3
      AND T.SCENE_ID IS NOT NULL
      AND t.latn_id = m.branch_no
      AND m.union_org_code = '${param.substation}'
      GROUP BY T.LATN_ID, T.LATN_NAME
    </e:q4o>${e:java2json(dataObject)}
  </e:case>

  <e:description>它网运营商</e:description>
  <e:case value="get_buss_cnt">
    <e:q4o var="dataObject">
      SELECT
      count(case when carrier_type <> 0 then 1 else null end) OTHER_BUSS_CNT,
      count(decode(CARRIER_TYPE,0,1,null)) D_COUNT,
      count(decode(CARRIER_TYPE,1,1,null)) YD_CNT,
      count(decode(CARRIER_TYPE,2,1,null)) LT_CNT,
      count(decode(CARRIER_TYPE,3,1,null)) GD_CNT,
      count(decode(CARRIER_TYPE,4,1,null)) QT_CNT
      FROM EDWWEB.TB_COUNTRY_GATHER@GSEDW t
      WHERE t.village_id in (
      SELECT DISTINCT village_id FROM edw.vw_tb_cde_village@gsedw WHERE branch_no = (SELECT DISTINCT branch_no FROM ${gis_user}.db_cde_grid WHERE union_org_code = '${param.substation}')
      )
    </e:q4o>${e:java2json(dataObject)}
  </e:case>
</e:switch>