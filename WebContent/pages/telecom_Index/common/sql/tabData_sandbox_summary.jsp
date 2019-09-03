<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@taglib prefix="a" tagdir="/WEB-INF/tags/app" %>
<e:set var="sql_part_tab">
  <e:description>EDW.TB_MKT_ORDER_LIST@GSEDW</e:description>
  ${gis_user}.VIEW_GIS_ORDER_LIST_TMP
</e:set>
<e:set var="sql_part_buss_cnt">
  COUNT(CASE
  WHEN O.IS_KD_DX > 0 THEN
  '1'
  END) D_COUNT,
  count(case
  when O.IS_KD_DX = 0 AND O.KD_BUSINESS <> '0' then
  '1'
  end) OTHER_BUSS_CNT,
  COUNT(CASE
  WHEN O.IS_KD_DX = 0 AND O.KD_BUSINESS = '1' THEN
  '1'
  END) YD_CNT,
  COUNT(CASE
  WHEN O.IS_KD_DX = 0 AND O.KD_BUSINESS = '2' THEN
  '1'
  END) LT_CNT,
  COUNT(CASE
  WHEN O.IS_KD_DX = 0 AND O.KD_BUSINESS = '3' THEN
  '1'
  END) GD_CNT,
  COUNT(CASE
  WHEN O.IS_KD_DX = 0 AND O.KD_BUSINESS = '4' THEN
  '1'
  END) QT_CNT,
  COUNT(CASE
  WHEN O.IS_KD_DX = 0 AND O.KD_BUSINESS = '0' THEN
  '1'
  END) UNINTALL_CNT
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

  <e:description>已废弃</e:description>
  <e:case value="get_jz_count">
    <e:q4o var="dataObject">
      select * from (
      SELECT '日派单数' a,COUNT(1) JZ_COUNT
      FROM ${sql_part_tab}
      WHERE UNION_ORG_CODE = '${param.substation}'
      and order_date = to_char(sysdate,'yyyymmdd')
      ),
      (select '--' yw_exec_lv_day,'--' yw_exec_lv_month from dual)
    </e:q4o>${e:java2json(dataObject)}
  </e:case>

  <e:description>月营销</e:description>
  <e:case value="get_yx_month">
  	<e:q4o var="dataObject">
      SELECT '月派单数' a,COUNT(1) cnt
        FROM ${sql_part_tab}
        WHERE UNION_ORG_CODE = '${param.substation}'
 	</e:q4o>${e:java2json(dataObject)}
  </e:case>

  <e:description>支局概况 营销类数据</e:description>
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
      <e:description>
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
      </e:description>
      SELECT '支局营销类数据' A,
      T.LATN_ID REGION_ID,
      T.LATN_NAME AREA_DESC,
      NVL(SUM(NVL(T.ORDER_CNT, 0)), 0) ALL_CNT_D,
      NVL(SUM(NVL(T.EXEC_CNT, 0) - NVL(T1.EXEC_CNT, 0)), 0) EXEC_CNT_D,
      DECODE(NVL(SUM(NVL(T.ORDER_CNT, 0)), 0),
      '0',
      '0.00%',
      TO_CHAR(ROUND(SUM(NVL(T.EXEC_CNT - T1.EXEC_CNT, 0)) /
      SUM(NVL(T.ORDER_CNT, 0)),
      4) * 100,
      'FM999999990.00') || '%') RATE_DAY,
      NVL(SUM(NVL(T.SUCC_CNT - T1.SUCC_CNT, 0)), 0) SUCC_CNT_D,
      DECODE(NVL(SUM(NVL(T.ORDER_CNT, 0)), 0),
      '0',
      '0.00%',
      TO_CHAR(ROUND(SUM(NVL(T.SUCC_CNT - T1.SUCC_CNT, 0)) /
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
      FROM
      (SELECT DISTINCT LATN_ID, BUREAU_NO, BRANCH_NO, UNION_ORG_CODE
      FROM ${gis_user}.DB_CDE_GRID WHERE UNION_ORG_CODE = '${param.substation}') M
      LEFT JOIN
      (SELECT * FROM ${gis_user}.VIEW_GSCH_MKT_ORDER_STAT_DAY
      WHERE STAT_LVL = 3
      AND SCENE_ID IS NOT NULL
      AND BRANCH_TYPE <> 'c1'
      AND ACCT_DAY = TO_CHAR(SYSDATE, 'yyyymmdd')) T
      ON T.LATN_ID = M.BRANCH_NO
      LEFT JOIN
      (SELECT * FROM ${gis_user}.VIEW_GSCH_MKT_ORDER_STAT_DAY
      WHERE ACCT_DAY = TO_CHAR(SYSDATE - 1, 'yyyymmdd')) T1
      ON T.LATN_ID = T1.LATN_ID
      AND T.BRANCH_TYPE = T1.BRANCH_TYPE
      AND T.SCENE_ID = T1.SCENE_ID
      AND T.STAT_LVL = T1.STAT_LVL
      GROUP BY T.LATN_ID, T.LATN_NAME
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

  <e:description>已废弃</e:description>
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
      END RATE_DAY,

      CASE
      WHEN COUNT(T2.ORDER_ID) = 0 THEN
      '--'
      ELSE
      TO_CHAR(SUM(CASE
      WHEN T2.SUCC_FLAG <> 0 THEN
      1
      ELSE
      0
      END) / COUNT(T2.ORDER_ID) * 100,
      'FM99999999990.00') || '%'
      END SUCC_DAY

      FROM ${gis_user}.TB_DIM_TIME T1
      LEFT JOIN ${sql_part_tab}  T2
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
      END RATE_MONTH,

      CASE
      WHEN COUNT(T2.ORDER_ID) = 0 THEN
      '--'
      ELSE
      TO_CHAR(SUM(CASE
      WHEN T2.SUCC_FLAG <> 0 THEN
      1
      ELSE
      0
      END) / COUNT(T2.ORDER_ID) * 100,
      'FM99999999990.00') || '%'
      END SUCC_MONTH

      FROM ${gis_user}.TB_DIM_TIME T1
      LEFT JOIN ${sql_part_tab}  T2
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

  <e:description>首页基础信息加载</e:description>
  <e:case value="get_info_all">
  <e:q4l var="list">
    SELECT
    '支局概述窗口' a,
    nvl(GZ_ZHU_HU_COUNT,0) GZ_ZHU_HU_COUNT,
    nvl(GZ_H_USE_CNT,0) GZ_H_USE_CNT,
    DECODE(NVL(GZ_ZHU_HU_COUNT, '0'), '0', ' ', TO_CHAR(ROUND(NVL(GZ_H_USE_CNT, 0) / GZ_ZHU_HU_COUNT, 4) * 100, 'FM990.00') || '%') MARKET_RATE,
    nvl(GOV_ZHU_HU_COUNT,0)  GOV_ZHU_HU_COUNT,
    nvl(GOV_H_USE_CNT,0) GOV_H_USE_CNT,
    nvl(OBD_CNT,0) OBD_CNT,
    nvl(ZERO_OBD_CNT,0) ZERO_OBD_CNT,
    nvl(HIGH_USE_OBD_CNT,0) HIGH_USE_OBD_CNT,
    nvl(LY_CNT,0) LY_CNT,
    nvl(NO_RES_ARRIVE_CNT,0) NO_RES_ARRIVE_CNT,
    NVL(LY_CNT, 0) - NVL(NO_RES_ARRIVE_CNT, 0) RES_ARRIVE_CNT,
    DECODE(NVL(LY_CNT, '0'), '0', ' ', TO_CHAR(ROUND((NVL(LY_CNT, 0) - NVL(NO_RES_ARRIVE_CNT, 0)) / LY_CNT, 4) * 100, 'FM999999990.00') || '%') RESOUCE_RATE,
    nvl(PORT_ID_CNT,0) PORT_ID_CNT,
    nvl(USE_PORT_CNT,0) USE_PORT_CNT,
    nvl(KONG_PORT_CNT,0) KONG_PORT_CNT,
    DECODE(NVL(PORT_ID_CNT, '0'), '0', ' ', TO_CHAR(ROUND(NVL(USE_PORT_CNT, 0) / PORT_ID_CNT, 4) * 100, 'FM990.00') || '%') PORT_RATE,
    NVL(LY_CNT, 0) - NVL(WJ_CNT, 0) USED_BUILD_NUM,
    nvl(WJ_CNT,0) WJ_CNT,
    <e:description>20190604 白区小区口径自己算
    nvl(LOW_10_FILTER_VILLAGE_CNT,0) LOW_10_FILTER_VILLAGE_CNT,
    </e:description>
    (SELECT COUNT(1) FROM ${gis_user}.view_db_cde_village a,${gis_user}.TB_GIS_RES_INFO_DAY b WHERE a.union_org_code = '${param.substation }' AND a.village_id = b.latn_id AND
    DECODE(NVL(GZ_ZHU_HU_COUNT,0),0,0,NVL(GZ_H_USE_CNT, 0) / GZ_ZHU_HU_COUNT)<0.1) LOW_10_FILTER_VILLAGE_CNT,
    nvl(NO_RES_VILLAGE_CNT,0) NO_RES_VILLAGE_CNT,
    nvl(VILLAGE_CNT,0) VILLAGE_CNT,
    DECODE(NVL(ACTIVE_ALL_CNT, '0'), '0', ' ', TO_CHAR(ROUND(NVL(ACTIVE_CNT, 0) / ACTIVE_ALL_CNT, 4) * 100, 'FM990.00') || '%') ACTIVE_RATE,
    DECODE(NVL(XY_ALL_CNT, '0'), '0', ' ', TO_CHAR(ROUND(NVL(XY_CNT, 0) / XY_ALL_CNT, 4) * 100, 'FM990.00') || '%') XY_RATE,
    DECODE(NVL(LW_ALL_CNT, '0'), '0', ' ', TO_CHAR(ROUND(NVL(LW_CNT, 0) / LW_ALL_CNT, 4) * 100, 'FM990.00') || '%') LW_RATE,
    DECODE(NVL(BY_ALL_CNT, '0'), '0', ' ', TO_CHAR(ROUND(NVL(BY_CNT, 0) / BY_ALL_CNT, 4) * 100, 'FM990.00') || '%') BY_RATE,
    nvl(SHOULD_COLLECT_CNT,0) SHOULD_COLLECT_CNT,
    nvl(ALREADY_COLLECT_CNT,0) ALREADY_COLLECT_CNT,
    DECODE(NVL(SHOULD_COLLECT_CNT, '0'), '0', ' ', TO_CHAR(ROUND(NVL(ALREADY_COLLECT_CNT, 0) / SHOULD_COLLECT_CNT, 4) * 100, 'FM990.00') || '%') COLLECT_RATE
    FROM ${gis_user}.TB_GIS_RES_INFO_DAY
    WHERE LATN_ID = '${param.substation }'
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
        '支局汇总信息补充' a,
        nvl(mobile_user,0) mobile_user,
        nvl(single_product_user,0) single_product_user,
        nvl(together_product_user,0) together_product_user,
        to_char(round(decode(nvl(mobile_user,0),0,0,nvl(together_product_user,0)/nvl(mobile_user,0)),4)*100,'FM9999999990.00') || '%' together_product_lv,
        nvl(work_mobile_user,0) work_mobile_user,
        nvl(home_mobile_user,0) home_mobile_user,
        nvl(broadband_product_user,0) broadband_product_user,
        nvl(together_broadband_user,0) together_broadband_user,
        to_char(round(decode(nvl(broadband_product_user,0),0,0,nvl(together_broadband_user,0)/nvl(broadband_product_user,0)),4)*100,'FM9999999990.00') || '%' together_broadband_lv,
        nvl(gov_broadband_product,0) gov_broadband_product,
        nvl(gov_together_broadband,0) gov_together_broadband,
        to_char(round(decode(nvl(gov_broadband_product,0),0,0,nvl(gov_together_broadband,0)/nvl(gov_broadband_product,0)),4)*100,'FM9999999990.00') || '%' gov_together_broadband_lv
        FROM ${gis_user}.TB_DW_GIS_GIRD_BASE_M WHERE flag = 4 AND org_code =
        (SELECT DISTINCT branch_no FROM ${gis_user}.db_cde_grid WHERE union_org_code = '${param.substation}')
        AND acct_month = (SELECT const_value FROM easy_data.sys_const_table WHERE const_type = 'var.dss23' AND data_type = 'mon')
      </e:description>
    </e:q4o>${e:java2json(dataObject)}
  </e:case>

  <e:description>支局长部分 end</e:description>

	<e:description>支局长 四心小区统计数</e:description>
	<e:case value="get_four_vill_type">
		<e:q4o var="dataObject">
            SELECT
            COUNT(DECODE(nvl(village_label_flg,0),1,1)) v_type1,
            COUNT(DECODE(nvl(village_label_flg,0),2,1)) v_type2,
            COUNT(DECODE(nvl(village_label_flg,0),3,1)) v_type3,
            COUNT(DECODE(nvl(village_label_flg,0),4,1)) v_type4
            FROM ${gis_user}.tb_gis_village_edit_info where branch_no = '${param.substation}'
		</e:q4o>${e:java2json(dataObject)}
	</e:case>

	<e:description>它网运营商</e:description>
	<e:case value="get_buss_cnt">
      <e:q4o var="dataObject">
        <e:description>
        SELECT
          ${sql_part_buss_cnt}
           FROM SDE.TB_GIS_MAP_SEGM_LATN_MON a,
          ${gis_user}.TB_GIS_ADDR_OTHER_ALL o
          WHERE a.segm_id = o.SEGM_ID
          and a.union_org_code = '${param.substation}'
        </e:description>
        select
        other_bd_cnt OTHER_BUSS_CNT,
        other_cm_cnt YD_CNT,
        other_cu_cnt LT_CNT,
        other_sarft_cnt GD_CNT,
        other_y_cnt QT_CNT,
        wz_collect_cnt UNINTALL_CNT
        from ${gis_user}.tb_gis_res_city_day
        where flg = 3
        and latn_id = '${param.substation}'
      </e:q4o>${e:java2json(dataObject)}
	</e:case>

	<e:case value="get_add4_data">
		<e:q4o var="dataObject">
			select count(1) cnt from SDE.TB_GIS_MAP_SEGM_LATN_MON where union_org_code = '${param.substation}'
		</e:q4o>${e:java2json(dataObject)}
	</e:case>

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

  <e:description>获取已归小区的楼宇列表</e:description>
  <e:case value="getusedBuildList">
    <e:q4l var="dataList">
      SELECT *
      FROM (SELECT RESID, RESFULLNAME, C_NUM, row_num
      FROM (SELECT A.*, COUNT(1) OVER() C_NUM,
      row_number() over(order by resfullname) row_num
      FROM SDE.MAP_ADDR_SEGM_${param.latn_id} A,
      ${gis_user}.TB_GIS_VILLAGE_ADDR4 B
      WHERE 1 = 1
      <e:if condition="${!empty param.union_org_code}">
        and UNION_ORG_CODE = '${param.union_org_code}'
      </e:if>
      <e:if condition="${!empty param.grid_id}">
        and GRID_UNION_ORG_CODE = '${param.grid_id}'
      </e:if>
      AND a.RESID = b.segm_id))
      WHERE row_num > ${param.page} * 25
      and row_num <= (${param.page} + 1) * 25
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>
</e:switch>