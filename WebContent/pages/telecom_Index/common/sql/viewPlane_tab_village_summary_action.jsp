<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>

<e:q4o var="index_stl">
  <e:if condition="${!empty param.stl}" var="empty_stl">
  SELECT CASE
  WHEN RANGE_SIGNR IS NULL THEN
  RANGE_SIGNL || RANGE_MIN
  WHEN RANGE_SIGNL IS NULL THEN
  RANGE_SIGNR || RANGE_MAX
  ELSE
  RANGE_SIGNL || RANGE_MIN || ' and market_lv ' || RANGE_SIGNR || RANGE_MAX
  END INDEX_RANGE
  FROM (SELECT KPI_CODE,
  RANGE_NAME,
  RANGE_NAME_SHORT,
  RANGE_MIN,
  RANGE_SIGNL,
  RANGE_SIGNR,
  RANGE_MAX
  FROM ${gis_user}.TB_GIS_KPI_RANGE
  WHERE IS_VALID = 1
  AND KPI_CODE = 'KPI_D_001'
  AND RANGE_INDEX = '${param.stl}'
  ORDER BY KPI_CODE ASC, RANGE_INDEX ASC)
  </e:if>
  <e:else condition="${empty_stl}">
    SELECT '' FROM DUAL
  </e:else>
</e:q4o>

<e:q4o var="index_village_mode">
  <e:if condition="${!empty param.villageMode_flag}" var="empty_villageMode">
    SELECT CASE
    WHEN RANGE_SIGNR IS NULL THEN
    RANGE_SIGNL || RANGE_MIN
    WHEN RANGE_SIGNL IS NULL THEN
    RANGE_SIGNR || RANGE_MAX
    ELSE
    RANGE_SIGNL || RANGE_MIN || ' and gz_zhu_hu_count ' || RANGE_SIGNR || RANGE_MAX
    END INDEX_RANGE
    FROM (SELECT KPI_CODE,
    RANGE_NAME,
    RANGE_NAME_SHORT,
    RANGE_MIN,
    RANGE_SIGNL,
    RANGE_SIGNR,
    RANGE_MAX
    FROM ${gis_user}.TB_GIS_KPI_RANGE
    WHERE IS_VALID = 1
    AND KPI_CODE = 'KPI_D_002'
    AND RANGE_INDEX = '${param.villageMode_flag}'
    ORDER BY KPI_CODE ASC, RANGE_INDEX ASC)
  </e:if>
  <e:else condition="${empty_villageMode}">
    SELECT '' FROM DUAL
  </e:else>
</e:q4o>

<e:q4o var="index_fiber_percent">
  <e:if condition="${!empty param.fgl}" var="empty_fgl">
    SELECT CASE
    WHEN RANGE_SIGNR IS NULL THEN
    RANGE_SIGNL || RANGE_MIN
    WHEN RANGE_SIGNL IS NULL THEN
    RANGE_SIGNR || RANGE_MAX
    ELSE
    RANGE_SIGNL || RANGE_MIN || ' and fgl_lv ' || RANGE_SIGNR || RANGE_MAX<e:description>待改参数</e:description>
    END INDEX_RANGE
    FROM (SELECT KPI_CODE,
    RANGE_NAME,
    RANGE_NAME_SHORT,
    RANGE_MIN,
    RANGE_SIGNL,
    RANGE_SIGNR,
    RANGE_MAX
    FROM ${gis_user}.TB_GIS_KPI_RANGE
    WHERE IS_VALID = 1
    AND KPI_CODE = 'KPI_D_008'<e:description>待改参数</e:description>
    AND RANGE_INDEX = '${param.fgl}'<e:description>待改参数</e:description>
    ORDER BY KPI_CODE ASC, RANGE_INDEX ASC)
  </e:if>
  <e:else condition="${empty_fgl}">
    SELECT '' FROM DUAL
  </e:else>
</e:q4o>

<e:q4o var="index_jzcd">
  <e:if condition="${!empty param.jzcd_flag}" var="empty_jzcd">
  SELECT CASE
  WHEN RANGE_SIGNR IS NULL THEN
  RANGE_SIGNL || RANGE_MIN
  WHEN RANGE_SIGNL IS NULL THEN
  RANGE_SIGNR || RANGE_MAX
  ELSE
  RANGE_SIGNL || RANGE_MIN || ' and COMPETE_PERCENT ' || RANGE_SIGNR || RANGE_MAX
  END INDEX_RANGE
  FROM (SELECT KPI_CODE,
  RANGE_NAME,
  RANGE_NAME_SHORT,
  RANGE_MIN,
  RANGE_SIGNL,
  RANGE_SIGNR,
  RANGE_MAX
  FROM ${gis_user}.TB_GIS_KPI_RANGE
  WHERE IS_VALID = 1
  AND KPI_CODE = 'KPI_D_003'
  AND RANGE_INDEX = '${param.jzcd_flag}'
  ORDER BY KPI_CODE ASC, RANGE_INDEX ASC)
  </e:if>
  <e:else condition="${empty_jzcd}">
    SELECT '' FROM DUAL
  </e:else>
</e:q4o>

<e:q4o var="index_port_percent">
  <e:if condition="${!empty param.portLv_flag}" var="empty_portLv_flag">
    SELECT CASE
    WHEN RANGE_SIGNR IS NULL THEN
    RANGE_SIGNL || RANGE_MIN
    WHEN RANGE_SIGNL IS NULL THEN
    RANGE_SIGNR || RANGE_MAX
    ELSE
    RANGE_SIGNL || RANGE_MIN || ' and port_lv ' || RANGE_SIGNR || RANGE_MAX<e:description>待改参数</e:description>
    END INDEX_RANGE
    FROM (SELECT KPI_CODE,
    RANGE_NAME,
    RANGE_NAME_SHORT,
    RANGE_MIN,
    RANGE_SIGNL,
    RANGE_SIGNR,
    RANGE_MAX
    FROM ${gis_user}.TB_GIS_KPI_RANGE
    WHERE IS_VALID = 1
    AND KPI_CODE = 'KPI_D_009'<e:description>待改参数</e:description>
    AND RANGE_INDEX = '${param.portLv_flag}'<e:description>待改参数</e:description>
    ORDER BY KPI_CODE ASC, RANGE_INDEX ASC)
  </e:if>
  <e:else condition="${empty_portLv_flag}">
    SELECT '' FROM DUAL
  </e:else>
</e:q4o>

<e:set var="sql_part">
  <e:if condition="${!empty param.stl}">
    and market_lv ${index_stl.INDEX_RANGE}
  </e:if>
  <e:if condition="${!empty param.jzcd_flag}">
    and COMPETE_PERCENT ${index_jzcd.INDEX_RANGE}
  </e:if>
  <e:if condition="${!empty param.villageMode_flag}">
    and gz_zhu_hu_count ${index_village_mode.INDEX_RANGE}
  </e:if>
  <e:if condition="${!empty param.fgl}">
    and fgl_lv ${index_fiber_percent.INDEX_RANGE}
  </e:if>
  <e:if condition="${!empty param.portLv_flag}">
    and port_lv ${index_port_percent.INDEX_RANGE}
  </e:if>

  <e:if condition="${!empty param.line_flag}">
    AND yys_count = '${param.line_flag}'
  </e:if>
</e:set>
<e:switch value="${param.eaction}">
  <e:description>全省显示市级数量</e:description>
  <e:case value="province">
    <e:q4l var="dataList">
      SELECT 999 LATN_ID,
      '全部' LATN_NAME,
      NVL(COUNT(VILLAGE_ID), 0) TOTAL,
      '0' ORD
      FROM (SELECT
      LATN_ID,
      LATN_NAME,
      BUREAU_NO,
      BUREAU_NAME,
      VILLAGE_ID,
      VILLAGE_NAME,
      GZ_ZHU_HU_COUNT,
      GZ_H_USE_CNT,
      MARKET_LV MARKET_LV1,
      FGL_LV,
      PORT_LV,
      COMPETE_PERCENT,
      CM_CNT,
      REMOVE_CNT,
      OWE_CNT,
      STOP_CNT,
      VILLAGE_MODE,
      YYS_COUNT,
      CITY_ORDER_NUM,
      REGION_ORDER_NUM
      FROM ${gis_user}.VIEW_GIS_VILLAGE_SUM_LIST
      WHERE 1=1
      ${sql_part}
      )
      UNION ALL
      SELECT LATN_ID, LATN_NAME, COUNT(VILLAGE_ID) TOTAL, CITY_ORDER_NUM ORD
      FROM (SELECT
      LATN_ID,
      LATN_NAME,
      BUREAU_NO,
      BUREAU_NAME,
      VILLAGE_ID,
      VILLAGE_NAME,
      GZ_ZHU_HU_COUNT,
      GZ_H_USE_CNT,
      MARKET_LV MARKET_LV1,
      FGL_LV,
      PORT_LV,
      COMPETE_PERCENT,
      CM_CNT,
      REMOVE_CNT,
      OWE_CNT,
      STOP_CNT,
      VILLAGE_MODE,
      YYS_COUNT,
      CITY_ORDER_NUM,
      REGION_ORDER_NUM
      FROM ${gis_user}.VIEW_GIS_VILLAGE_SUM_LIST
      WHERE 1=1
      ${sql_part}
      )
      GROUP BY LATN_ID, LATN_NAME, CITY_ORDER_NUM
      ORDER BY ORD ASC
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>市级概况 显示区县数量</e:description>
  <e:case value="city">
    <e:q4l var="dataList">
      SELECT '999' bureau_no,
      '全部' bureau_name,
      NVL(COUNT(VILLAGE_ID), 0) TOTAL,
      '0' ORD
      FROM (SELECT LATN_ID,
      LATN_NAME,
      BUREAU_NO,
      BUREAU_NAME,
      VILLAGE_ID,
      VILLAGE_NAME,
      GZ_ZHU_HU_COUNT,
      GZ_H_USE_CNT,
      MARKET_LV        MARKET_LV1,
      FGL_LV,
      PORT_LV,
      COMPETE_PERCENT,
      CM_CNT,
      REMOVE_CNT,
      OWE_CNT,
      STOP_CNT,
      VILLAGE_MODE,
      YYS_COUNT,
      CITY_ORDER_NUM,
      REGION_ORDER_NUM
      FROM ${gis_user}.VIEW_GIS_VILLAGE_SUM_LIST
      WHERE 1 = 1
      <e:if condition="${param.city_id ne '999'}">
        and latn_id=${param.city_id}
      </e:if>
      ${sql_part}
      )
      UNION ALL
      SELECT bureau_no,bureau_name, COUNT(VILLAGE_ID) TOTAL, CITY_ORDER_NUM ORD
      FROM (SELECT LATN_ID,
      LATN_NAME,
      BUREAU_NO,
      BUREAU_NAME,
      VILLAGE_ID,
      VILLAGE_NAME,
      GZ_ZHU_HU_COUNT,
      GZ_H_USE_CNT,
      MARKET_LV        MARKET_LV1,
      FGL_LV,
      PORT_LV,
      COMPETE_PERCENT,
      CM_CNT,
      REMOVE_CNT,
      OWE_CNT,
      STOP_CNT,
      VILLAGE_MODE,
      YYS_COUNT,
      CITY_ORDER_NUM,
      REGION_ORDER_NUM
      FROM ${gis_user}.VIEW_GIS_VILLAGE_SUM_LIST
      WHERE 1 = 1
      <e:if condition="${param.city_id ne '999'}">
        and latn_id=${param.city_id}
      </e:if>
      ${sql_part}
      )
      GROUP BY LATN_ID, LATN_NAME,bureau_no,bureau_name, CITY_ORDER_NUM
      ORDER BY ORD ASC
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>详单</e:description>
  <e:case value="market">
    <e:q4l var="dataList">
      <%--SELECT a.* FROM (
      SELECT t.*,ROWNUM rn FROM(
      SELECT A.LATN_NAME, A.BUREAU_NAME, B.*，COUNT(1) OVER() C_NUM
      FROM (SELECT DISTINCT LATN_ID, LATN_NAME, BUREAU_NO, BUREAU_NAME
      FROM ${gis_user}.DB_CDE_GRID
      WHERE 1 = 1
      AND LATN_ID ='${param.city_id}'
      <e:if condition="${!empty param.bureau_id}">
        and bureau_no = '${param.bureau_id}'
      </e:if>
      ) A
      LEFT JOIN (SELECT ACCT_MONTH,
      CITY_GRID_CNT,
      VILLAGE_CNT,
      ARRIVE_CNT,
      CM_CNT,
      CASE WHEN arrive_cnt = 0 THEN '0.00%' ELSE to_char(ROUND((cm_cnt /arrive_cnt),4),'999.00')*100||'%' END cm_lv,
      REMOVE_CNT,
      CASE WHEN arrive_cnt = 0 THEN '0.00%' ELSE to_char(ROUND((remove_cnt /arrive_cnt),4),'999.00')*100||'%' END remove_lv,
      OWE_CNT,
      CASE WHEN arrive_cnt = 0 THEN '0.00%' ELSE to_char(ROUND((owe_cnt /arrive_cnt),4),'999.00')*100||'%' END owe_lv,
      LATN_ID
      FROM ${gis_user}.TB_DW_GIS_SCENE_USER_M
      WHERE 1 = 1
      AND ACCT_MONTH = '${param.acct_mon}'
      AND FLG ='${param.flag}') B
      ON A.BUREAU_NO = B.LATN_ID
      LEFT JOIN EASY_DATA.CMCODE_CITY C
      ON A.BUREAU_NO = C.CITY_NO
      ORDER BY C.ORD)t WHERE ROWNUM <= ${param.page+1}*10)a WHERE rn >${param.page}*10--%>

      SELECT a.* FROM (
      SELECT t.*,ROWNUM rn FROM(
      SELECT
      LATN_ID,
      LATN_NAME,
      BUREAU_NO,
      BUREAU_NAME,
      VILLAGE_ID,
      VILLAGE_NAME,
      decode(nvl(VILLAGE_VALUE,0),0,' ',1,'公众',2,'政企',3,'商住一体') VILLAGE_VALUE_TEXT,
      GZ_ZHU_HU_COUNT,
      GZ_H_USE_CNT,
      to_char(nvl(MARKET_LV,0),'FM9999999990.00')||'%' MARKET_LV1,
      MARKET_LV,
      to_char(nvl(FGL_LV,0),'FM9999999990.00')||'%' FGL_LV1,
      FGL_LV,
      to_char(nvl(PORT_LV,0),'FM9999999990.00')||'%' PORT_LV1,
      PORT_LV,
      to_char(nvl(COMPETE_PERCENT,0),'FM9999999990.00')||'%' COMPETE_PERCENT1,
      COMPETE_PERCENT,
      CM_CNT,
      REMOVE_CNT,
      OWE_CNT,
      STOP_CNT,
      lost_all,
      decode(village_ru_rate,'1','80%以上','2','60-80%','3','40-60%','4','40%以下',' ') village_ru_rate,
      decode(village_xf,'0','城中村','1','低档小区','2','中档小区','3','高档小区',' ') village_xf,
      decode(nvl(village_label,'0'),'0','--','1','--','2','--',village_label) village_label,
      nvl(VILLAGE_MODE,' ')VILLAGE_MODE,
      YYS_COUNT,
      OTHER_CM_CNT,
      OTHER_CU_CNT,
      OTHER_SARFT_CNT,
      OTHER_Y_CNT,
      <e:description>
      nvl(year_dev_cnt ,0) year_dev_cnt,
      nvl(mon_dev_cnt ,0) mon_dev_cnt,
      to_char(nvl(hb ,0),'FM9999999990.00') || '%' hb,
      to_char(nvl(rh_lv ,0),'FM9999999990.00') || '%' rh_lv,
      to_char(nvl(dk_lv ,0),'FM9999999990.00') || '%' dk_lv,
      </e:description>
      CITY_ORDER_NUM,
      REGION_ORDER_NUM,
      port_id_cnt ,
      use_port_cnt,
      COUNT(1) OVER() c_num
      FROM ${gis_user}.VIEW_GIS_VILLAGE_SUM_LIST
      WHERE 1=1
      ${sql_part}
      <e:if condition="${param.city_id ne '999' && !empty param.city_id}">
        and latn_id=${param.city_id}
      </e:if>
      <e:if condition="${!empty param.bureau_id && param.bureau_id ne '999'}">
        and bureau_no = '${param.bureau_id}'
      </e:if>
      <e:if condition="${!empty param.union_org_code}">
        and union_org_code = '${param.union_org_code}'
      </e:if>
      <e:if condition="${!empty param.grid_union_org_code}">
        and grid_union_org_code = '${param.grid_union_org_code}'
      </e:if>
      <e:if condition="${!empty param.data_monitor}">
        AND GZ_H_USE_CNT>use_port_cnt
      </e:if>
      ORDER BY city_order_num ASC,region_order_num ASC,village_name ASC)
      t WHERE ROWNUM <= ${param.page+1}*25    )a WHERE rn >${param.page}*25
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>详单 datagrid</e:description>
  <e:case value="market_datagrid">
    <c:tablequery>
      SELECT
      LATN_ID,
      LATN_NAME,
      BUREAU_NO,
      BUREAU_NAME,
      VILLAGE_ID,
      VILLAGE_NAME,
      decode(nvl(VILLAGE_VALUE,0),0,' ',1,'公众',2,'政企',3,'商住一体') VILLAGE_VALUE_TEXT,
      GZ_ZHU_HU_COUNT,
      GZ_H_USE_CNT,
      to_char(nvl(MARKET_LV,0),'FM9999999990.00')||'%' MARKET_LV1,
      to_char(nvl(FGL_LV,0),'FM9999999990.00')||'%' FGL_LV1,
      to_char(nvl(PORT_LV,0),'FM9999999990.00')||'%' PORT_LV1,
      to_char(nvl(COMPETE_PERCENT,0),'FM9999999990.00')||'%' COMPETE_PERCENT1,
      CM_CNT,
      REMOVE_CNT,
      OWE_CNT,
      STOP_CNT,
      lost_all,
      decode(village_xf,'0','城中村','1','低档小区','2','中档小区','3','高档小区',' ') village_xf,
      decode(nvl(village_label,'0'),'0','--','1','--','2','--',village_label) village_label,
      nvl(VILLAGE_MODE,' ')VILLAGE_MODE,
      YYS_COUNT,
      OTHER_CM_CNT,
      OTHER_CU_CNT,
      OTHER_SARFT_CNT,
      OTHER_Y_CNT,
      nvl(OTHER_CM_CNT,0)+nvl(OTHER_CU_CNT,0)+nvl(OTHER_SARFT_CNT,0)+nvl(OTHER_Y_CNT,0) innet_buss_cnt,
      <e:description>
        nvl(year_dev_cnt ,0) year_dev_cnt,
        nvl(mon_dev_cnt ,0) mon_dev_cnt,
        to_char(nvl(hb ,0),'FM9999999990.00') || '%' hb,
        to_char(nvl(rh_lv ,0),'FM9999999990.00') || '%' rh_lv,
        to_char(nvl(dk_lv ,0),'FM9999999990.00') || '%' dk_lv,
      </e:description>
      CITY_ORDER_NUM,
      REGION_ORDER_NUM,
      port_id_cnt ,
      use_port_cnt,
      COUNT(1) OVER() c_num
      FROM ${gis_user}.VIEW_GIS_VILLAGE_SUM_LIST
      WHERE 1=1
      ${sql_part}
      <e:if condition="${param.city_id ne '999' && !empty param.city_id}">
        and latn_id=${param.city_id}
      </e:if>
      <e:if condition="${!empty param.bureau_id && param.bureau_id ne '999'}">
        and bureau_no = '${param.bureau_id}'
      </e:if>
      <e:if condition="${!empty param.union_org_code}">
        and union_org_code = '${param.union_org_code}'
      </e:if>
      <e:if condition="${!empty param.grid_union_org_code}">
        and grid_union_org_code = '${param.grid_union_org_code}'
      </e:if>
      <e:if condition="${!empty param.data_monitor}">
        AND GZ_H_USE_CNT>use_port_cnt
      </e:if>
      ORDER BY city_order_num ASC,region_order_num ASC,village_name ASC
    </c:tablequery>
  </e:case>


  <e:description>获取地市下的区县</e:description>
  <e:case value="getBureauByCityId">
    <e:q4l var="dataList">
      SELECT DISTINCT bureau_no,bureau_name，region_order_Num FROM ${gis_user}.db_cde_grid WHERE latn_id = '${param.city_id}' AND branch_type = 'a1' order by REGION_ORDER_NUM
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>获取区县下的支局</e:description>
  <e:case value="getBranchByBureauId">
    <e:q4l var="dataList">
      SELECT DISTINCT T.UNION_ORG_CODE,T.BRANCH_NO,T.BRANCH_NAME,'支局列表' b
      FROM ${gis_user}.DB_CDE_GRID T
      WHERE T.BUREAU_NO = '${param.bureau_no}' AND branch_type = 'a1'
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>获取支局下的网格</e:description>
  <e:case value="getGridByUnionOrgCode">
    <e:q4l var="dataList">
      SELECT DISTINCT T.GRID_ID,T.GRID_NAME,'网格列表' b
      FROM ${gis_user}.DB_CDE_GRID T
      WHERE T.UNION_ORG_CODE = '${param.union_org_code}' AND branch_type = 'a1'
      and t.grid_union_org_code <> -1 and t.grid_union_org_code is not null
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>获取支局下的小区</e:description>
  <e:case value="getVillageIdByBranchNo">
    <e:q4l var="dataList">
      SELECT VILLAGE_ID, VILLAGE_NAME
      FROM GIS_DATA.TB_GIS_VILLAGE_EDIT_INFO
      WHERE BRANCH_NO IN (SELECT UNION_ORG_CODE
      FROM GIS_DATA.DB_CDE_GRID
      WHERE UNION_ORG_CODE = '${param.union_org_code}')
      union all
      SELECT '99999999' VILLAGE_ID,'未建小区' VILLAGE_NAME
      from dual
      order by village_id,village_name
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>获取网格下的小区</e:description>
  <e:case value="getVillageIdByGridNo">
    <e:q4l var="dataList">
      SELECT VILLAGE_ID, VILLAGE_NAME
      FROM GIS_DATA.TB_GIS_VILLAGE_EDIT_INFO
      WHERE GRID_ID_2 = '${param.grid_id}'
      union all
      SELECT '99999999' VILLAGE_ID,'未建小区' VILLAGE_NAME
      from dual
      order by village_id,village_name
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>获取某范围内的楼宇</e:description>
  <e:case value="getBuildIdByRegionId">
    <e:q4l var="dataList">
        select ' ' segm_id,'全部' stand_Name from dual union all
        SELECT segm_id,stand_Name FROM gis_data.tb_gis_village_addr4 WHERE village_id = '${param.village_id}' order by segm_id asc
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>获取支局下的网格</e:description>
  <e:case value="getGridByBranchId">
    <e:q4l var="dataList">
      select DISTINCT grid_id,grid_name,'网格列表' c from ${gis_user}.DB_CDE_GRID t WHERE branch_no = '${param.branch_id}' AND branch_type = 'a1' AND grid_status = 1 and grid_union_org_code <> -1
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>白区反抢统计</e:description>
  <e:case value="get_BQFQ">
    <e:q4l var="dataList">
      SELECT a.* FROM (
      SELECT t.*,ROWNUM rn FROM(
      SELECT LATN_ID,
      LATN_NAME,
      BUREAU_NO,
      BUREAU_NAME,
      UNION_ORG_CODE,
      BRANCH_NAME,
      GRID_ID,
      GRID_NAME,
      VILLAGE_ID,
      VILLAGE_NAME,
      case when NVL(FILTER_RATE_1,0)=0 then '0.00%' else to_char(ROUND(FILTER_RATE_1 * 100, 2),'FM990.00')||'%' end YUAN_ST,
      case when NVL(FILTER_RATE_2,0)=0 then '0.00%' else to_char(ROUND(FILTER_RATE_2 * 100, 2),'FM990.00')||'%' end LJ_ST
      FROM ${gis_user}.TB_GIS_FILTER_COMPARE_DAY aa,
      easy_data.cmcode_area              ff
      where aa.latn_id = ff.area_no

      <e:if condition="${param.latn_id ne '999' && param.latn_id ne ''}">
        AND LATN_ID =${param.latn_id}
      </e:if>
      <e:if condition="${param.bureau_no ne '999' && param.bureau_no ne ''}">
        AND BUREAU_NO=${param.bureau_no}
      </e:if>
      ORDER BY ff.ord,aa.bureau_no,aa.union_org_code,aa.grid_id,aa.village_id
      )t WHERE ROWNUM <=  ${param.page+1}*25    )a WHERE rn > ${param.page}*25
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>


  <e:description>白区反抢日报</e:description>
  <e:case value="get_BQFQ_day">
    <e:q4l var="dataList">
      SELECT a.* FROM (
      SELECT t.*,ROWNUM rn FROM(
      SELECT LATN_ID,
      LATN_NAME,
      BUREAU_NO,
      BUREAU_NAME,
      UNION_ORG_CODE,
      BRANCH_NAME,
      GRID_ID,
      GRID_NAME,
      VILLAGE_ID,

      VILLAGE_NAME,
      case when NVL(FILTER_RATE_Y,0)=0 then '0.00%' else to_char(ROUND(FILTER_RATE_Y * 100, 2),'FM990.00')||'%' end FILTER_RATE_Y,

      case when NVL(filter_rate_day,0)=0 then '0.00%' else to_char(ROUND(filter_rate_day * 100, 2),'FM990.00')||'%' end filter_rate_day,
      nvl(ADD_KD_CNT,0) ADD_KD_CNT,

      case when NVL(FILTER_RATE,0)=0 then '0.00%' else to_char(ROUND(FILTER_RATE * 100, 2),'FM990.00')||'%' end FILTER_RATE,
      case when NVL(FILTER_RATE_M,0)=0 then '0.00%' else to_char(ROUND(FILTER_RATE_M * 100, 2),'FM990.00')||'%' end FILTER_RATE_M,
      nvl(LJ_ADD_KD_CNT,0) LJ_ADD_KD_CNT,
      case when jz_cnt is null then '0.00%' else to_char(round(jz_cnt*100,2),'FM990.00')||'%' end jz_cnt

      FROM ${gis_user}.TB_GIS_FILTER_COMPARE_NEW_DAY aa,
      easy_data.cmcode_area              ff
      where aa.latn_id = ff.area_no

      <e:if condition="${param.latn_id ne '999' && param.latn_id ne ''}">
        AND LATN_ID =${param.latn_id}
      </e:if>
      <e:if condition="${param.bureau_no ne '999' && param.bureau_no ne ''}">
        AND BUREAU_NO=${param.bureau_no}
      </e:if>
      <e:if condition="${!empty param.acct_day}">
        AND ACCT_DAY = '${param.acct_day}'
      </e:if>
      ORDER BY ff.ord,aa.bureau_no,aa.union_org_code,aa.grid_id,aa.village_id
      )t WHERE ROWNUM <=  ${param.page+1}*25    )a WHERE rn > ${param.page}*25
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>城中村攻坚活动日报</e:description>
  <e:case value="get_villageInCity_attack_day">
    <e:q4l var="dataList">
      SELECT a.* FROM (
      SELECT t.*,ROWNUM rn FROM(
      SELECT LATN_ID,
      LATN_NAME,
      BUREAU_NO,
      BUREAU_NAME,
      UNION_ORG_CODE,
      BRANCH_NAME,
      GRID_ID,
      GRID_NAME,
      VILLAGE_ID,

      VILLAGE_NAME,
      case when NVL(FILTER_RATE_Y,0)=0 then '0.00%' else to_char(ROUND(FILTER_RATE_Y * 100, 2),'FM990.00')||'%' end FILTER_RATE_Y,

      case when NVL(filter_rate_day,0)=0 then '0.00%' else to_char(ROUND(filter_rate_day * 100, 2),'FM990.00')||'%' end filter_rate_day,
      nvl(ADD_KD_CNT,0) ADD_KD_CNT,

      case when NVL(FILTER_RATE,0)=0 then '0.00%' else to_char(ROUND(FILTER_RATE * 100, 2),'FM990.00')||'%' end FILTER_RATE,
      case when NVL(FILTER_RATE_M,0)=0 then '0.00%' else to_char(ROUND(FILTER_RATE_M * 100, 2),'FM990.00')||'%' end FILTER_RATE_M,
      nvl(LJ_ADD_KD_CNT,0) LJ_ADD_KD_CNT,
      case when jz_cnt is null then '0.00%' else to_char(round(jz_cnt*100,2),'FM990.00')||'%' end jz_cnt

      FROM ${gis_user}.TB_GIS_VILLAGE_CITY_DAY aa,
      easy_data.cmcode_area              ff
      where aa.latn_id = ff.area_no

      <e:if condition="${param.latn_id ne '999' && param.latn_id ne ''}">
        AND LATN_ID =${param.latn_id}
      </e:if>
      <e:if condition="${param.bureau_no ne '999' && param.bureau_no ne ''}">
        AND BUREAU_NO=${param.bureau_no}
      </e:if>
      <e:if condition="${!empty param.acct_day}">
        AND ACCT_DAY = '${param.acct_day}'
      </e:if>
      ORDER BY ff.ord,aa.bureau_no,aa.union_org_code,aa.grid_id,aa.village_id
      )t WHERE ROWNUM <=  ${param.page+1}*25    )a WHERE rn > ${param.page}*25
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

</e:switch>