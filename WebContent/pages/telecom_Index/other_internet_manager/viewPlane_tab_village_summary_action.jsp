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
      LEFT JOIN ${easy_user}.CMCODE_CITY C
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
      SELECT
      DISTINCT bureau_no,
      DECODE(replace(replace(BUREAU_NAME,'分局',''),'电信局',''),'其他','',replace(replace(BUREAU_NAME,'分局',''),'电信局','')) BUREAU_NAME,
      city_ord FROM ${channel_user}.tb_gis_channel_org t
      WHERE latn_id = '${param.city_id}'
      and t.bureau_no not in ('930013119','930013115', '930013199','930013113')
      and length(t.bureau_no)>3
      order by city_ord
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>获取区县下的支局</e:description>
  <e:case value="getBranchByBureauId">
    <e:q4l var="dataList">
      SELECT DISTINCT T.BRANCH_NO,T.BRANCH_NAME,'支局列表' b
      FROM ${channel_user}.tb_gis_channel_org T
      WHERE T.BUREAU_NO = '${param.bureau_no}'
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
      FROM ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO
      WHERE BRANCH_NO IN (SELECT UNION_ORG_CODE
      FROM ${gis_user}.DB_CDE_GRID
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
      FROM ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO
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
        SELECT segm_id,stand_Name FROM ${gis_user}.tb_gis_village_addr4 WHERE village_id = '${param.village_id}' order by segm_id asc
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
      ${easy_user}.cmcode_area              ff
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
      ${easy_user}.cmcode_area              ff
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
      ${easy_user}.cmcode_area              ff
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

  <e:description>异网网点录入</e:description>
  <e:case value="get_YWWD_day">
    <e:q4l var="dataList">
      SELECT a.* FROM (
      SELECT t.*,ROWNUM rn FROM(
      SELECT
      		IDN,
	      	LATN_ID,
			LATN_NAME,
			BUREAU_NO,
            BUREAU_NAME,
			BRANCH_NO,
			BRANCH_NAME,
			UNION_ORG_CODE,
			GRID_ID,
			GRID_NAME,
			BUSINESS_CIRCLE,
			CHANNEL_TYPE,
			nvl(CHANNEL_TYPE_NAME,'') CHANNEL_TYPE_NAME,
			CHANNEL_NAME,
			CHANNEL_ADDRESS,
			nvl(CHANNEL_JING,' ') CHANNEL_JING,
		  	nvl(CHANNEL_WEI,' ') CHANNEL_WEI,
			CHANNEL_AREA,
			to_char(nvl(CHANNEL_AREA1, '0.00'), 'FM9999999990') CHANNEL_AREA1,

			to_char(nvl(SELL_MONTH_CNT, '0.00'), 'FM9999999990') SELL_MONTH_CNT,
			DECODE(CARD_DX,'0',' ','1','是',' ')     CARD_DX,
			DECODE(CARD_YD,'0',' ','1','是',' ')     CARD_YD,
			DECODE(CARD_LT,'0',' ','1','是',' ')     CARD_LT,
			DECODE(ADV_DX,'0',' ','1','是',' ')       ADV_DX,
			DECODE(ADV_YD,'0',' ','1','是',' ')       ADV_YD,
			DECODE(ADV_LT,'0',' ','1','是',' ')       ADV_LT,
			DECODE(HEAD_DX,'0',' ','1','是',' ')     HEAD_DX,
			DECODE(HEAD_YD,'0',' ','1','是',' ')     HEAD_YD,
			DECODE(HEAD_LT,'0',' ','1','是',' ')     HEAD_LT,
			DECODE(MAIN_YYS,'0','不推荐','1','中国电信','2','中国移动','3','中国联通',MAIN_YYS)    MAIN_YYS,
			DECODE(STATUS,'1','正常','0','删除',STATUS) STATUS,
			NVL(t.user_name,' ') CREATE_OPR,
			to_char(CREATE_TIME,'yyyy-MM-dd') CREATE_TIME
			,COUNT(1) OVER() C_NUM
      FROM (select aa.*,u.* from
              (select * from ${channel_user}.TB_GIS_QD_COLLECT_INFO
              <e:if condition="${!empty param.query_text}">
                where (channel_name like '%${param.query_text}%' or
                channel_address like '%${param.query_text}%')
              </e:if>
              ) aa
      	left join
      (select DISTINCT user_id,user_name from ${easy_user}.E_USER e) u
      		on aa.create_opr = u.user_id ) t
      left join ${easy_user}.cmcode_area ff on t.latn_id = ff.area_no
      where 1 = 1
      and status = 1
      <e:if condition="${param.latn_id ne '999' && param.latn_id ne ''}">
        AND LATN_ID =${param.latn_id}
      </e:if>
      <e:if condition="${param.bureau_no ne '999' && param.bureau_no ne ''}">
        AND BUREAU_NO=${param.bureau_no}
      </e:if>
      <e:if condition="${!empty param.acct_day}">
       	AND CREATE_TIME BETWEEN TO_DATE('${param.acct_day}','yyyyMMdd') AND TO_DATE('${param.end_acct_day}','yyyyMMdd')+1
      </e:if>
      <e:if condition="${!empty param.tel_agent}">
       	AND MAIN_YYS = '${param.tel_agent}'
      </e:if>
      ORDER BY ff.ord,t.bureau_no,t.union_org_code,t.grid_id
      )t WHERE ROWNUM <=  ${param.page+1}*25    )a WHERE rn > ${param.page}*25
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>
  <e:description>保存异网网点信息</e:description>
  <e:case value="saveInternetInfo">
		<e:if condition="${empty param.id}" var="empty_recode">
			<e:update var="save_cnt">
				insert into ${channel_user}.TB_GIS_QD_COLLECT_INFO
				(
				LATN_ID,
				LATN_NAME,
				BUREAU_NO,
				BUREAU_NAME,
				BRANCH_NO,
				BRANCH_NAME,
				UNION_ORG_CODE,
				GRID_ID,
				GRID_NAME,
				BUSINESS_CIRCLE,
				CHANNEL_TYPE,
				CHANNEL_TYPE_NAME,
				CHANNEL_NAME,
				CHANNEL_ADDRESS,
				CHANNEL_JING,
				CHANNEL_WEI,
				CHANNEL_AREA,
				CHANNEL_AREA1,
				SELL_MONTH_CNT,
				CARD_DX,
				CARD_YD,
				CARD_LT,
				ADV_DX,
				ADV_YD,
				ADV_LT,
				HEAD_DX,
				HEAD_YD,
				HEAD_LT,
				MAIN_YYS,
				STATUS,
				CREATE_TIME,
				CREATE_OPR,
				UPDATE_TIME,
				UPDATE_OPR,
				DEL_TIME,
				DEL_OPR,
				IDN
				)
				values
				(
				'${param.latn_id}',
				'${param.latn_name}',

				'${param.bureau_no}',
				'${param.bureau_name}',

				'${param.branch_no}',
				'${param.branch_name}',
				'${param.union_org_code}',
				'${param.grid_id}',
				'${param.grid_name}',
				'${param.business_circle}',
				'${param.channel_type}',
				'${param.channel_type_name}',
				'${param.channel_name}',
				'${param.channel_address}',
				'${param.channel_jing}',
				'${param.channel_wei}',

				'${param.channel_area}',
				'${param.channel_area1}',
				'${param.channel_ave}',

				'${param.card_dx}',
				'${param.card_yd}',
				'${param.card_lt}',
				'${param.adv_dx}',
				'${param.adv_yd}',
				'${param.adv_lt}',
				'${param.head_dx}',
				'${param.head_yd}',
				'${param.head_lt}',
				'${param.main_yys}',
				'1',
				SYSDATE,
				'${sessionScope.UserInfo.USER_ID}',
				SYSDATE,
				'${sessionScope.UserInfo.USER_ID}',
				'${param.del_time}',
				'${param.del_opr}',
				E_IND_INTSEQ.nextval
				)
			</e:update>
		</e:if>
		<e:else condition="${empty_recode}">
			<e:update var="save_cnt">
				update ${channel_user}.TB_GIS_QD_COLLECT_INFO

				set

				latn_id           ='${param.latn_id}',
				latn_name         ='${param.latn_name}',
				bureau_no         ='${param.bureau_no}',
				bureau_name       ='${param.bureau_name}',

				channel_type      = '${param.channel_type}',
				channel_type_name = '${param.channel_type_name}',
				channel_name      = '${param.channel_name}',
				channel_address   = '${param.channel_address}',

				channel_area1     = '${param.channel_area1}',
				sell_month_cnt    = '${param.channel_ave}',

				card_dx           = '${param.card_dx}',
				card_yd           = '${param.card_yd}',
				card_lt           = '${param.card_lt}',
				adv_dx            = '${param.adv_dx}',
				adv_yd            = '${param.adv_yd}',
				adv_lt            = '${param.adv_lt}',
				head_dx           = '${param.head_dx}',
				head_yd           = '${param.head_yd}',
				head_lt           = '${param.head_lt}',
				main_yys          = '${param.main_yys}',

				update_time       =SYSDATE,
				update_opr        ='${sessionScope.UserInfo.USER_ID}'
				where IDN = '${param.id}'
			</e:update>
		</e:else>
	</e:case>${save_cnt}
	<e:case value="getInternetMsg">
			<e:q4o var="internet_obj">
			  SELECT
	      		IDN,
            	LATN_ID,
		        LATN_NAME,
		        BUREAU_NO,
		        BUREAU_NAME,
		        BRANCH_NO,
		        BRANCH_NAME,
		        UNION_ORG_CODE,
		        GRID_ID,
		        GRID_NAME,
		        BUSINESS_CIRCLE,
		        CHANNEL_TYPE,
		        CHANNEL_TYPE_NAME,
		        CHANNEL_NAME,
		        CHANNEL_ADDRESS,
		        nvl(CHANNEL_JING,' ') CHANNEL_JING,
		        nvl(CHANNEL_WEI,' ') CHANNEL_WEI,
		        CHANNEL_AREA,
		        CHANNEL_AREA1,
		        SELL_MONTH_CNT,
		         CARD_DX,
		         CARD_YD,
		         CARD_LT,
		          ADV_DX,
		          ADV_YD,
		          ADV_LT,
		         HEAD_DX,
		         HEAD_YD,
		         HEAD_LT,
		         MAIN_YYS,
		         STATUS,
		        CREATE_OPR,
		        to_char(CREATE_TIME,'yyyy-MM-dd') CREATE_TIME
		        ,COUNT(1) OVER() C_NUM
	      FROM ${channel_user}.TB_GIS_QD_COLLECT_INFO t
	      WHERE t.IDN = '${param.id}'
		</e:q4o>${e:java2json(internet_obj)}
	</e:case>
	<e:description>删除异网网点信息</e:description>
  <e:case value="delRecordById">
			<e:update var="del_cnt">
				update ${channel_user}.TB_GIS_QD_COLLECT_INFO

				set

				STATUS = '0'

				where IDN = '${param.id}'
			</e:update>
	</e:case>${del_cnt}
</e:switch>