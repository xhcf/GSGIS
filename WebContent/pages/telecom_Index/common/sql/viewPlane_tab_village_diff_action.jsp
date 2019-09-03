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
    RANGE_SIGNL || RANGE_MIN || ' and MARKET_RATE1 ' || RANGE_SIGNR || RANGE_MAX
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
<e:q4o var="index_jzcd">
  <e:if condition="${!empty param.jzcd_flag}" var="empty_jzcd">
    SELECT CASE
    WHEN RANGE_SIGNR IS NULL THEN
    RANGE_SIGNL || RANGE_MIN
    WHEN RANGE_SIGNL IS NULL THEN
    RANGE_SIGNR || RANGE_MAX
    ELSE
    RANGE_SIGNL || RANGE_MIN || ' and COMPETE_PERCENT1 ' || RANGE_SIGNR || RANGE_MAX
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

<e:q4o var="index_village_mode">
  <e:if condition="${!empty param.villageMode_flag}" var="empty_villageMode">
    SELECT CASE
    WHEN RANGE_SIGNR IS NULL THEN
    RANGE_SIGNL || RANGE_MIN
    WHEN RANGE_SIGNL IS NULL THEN
    RANGE_SIGNR || RANGE_MAX
    ELSE
    RANGE_SIGNL || RANGE_MIN || ' and GZ_ZHU_HU_SHU ' || RANGE_SIGNR || RANGE_MAX
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
<e:set var="sql_part">
  <e:if condition="${!empty param.stl}">
    and MARKET_RATE1 ${index_stl.INDEX_RANGE}
  </e:if>
  <e:if condition="${!empty param.jzcd_flag}">
    and COMPETE_PERCENT1 ${index_jzcd.INDEX_RANGE}
  </e:if>
  <e:if condition="${!empty param.villageMode_flag}">
    and GZ_ZHU_HU_SHU ${index_village_mode.INDEX_RANGE}
  </e:if>
</e:set>

<e:set var="index_name">
  to_char(nvl(VILLAGE_RATE_AVG,0)*100,'fm9999999990.00')||'%' VILLAGE_RATE_AVG,
  to_char(nvl(CHARGE_AVG,0),'fm9999999990.00') HU_CHARGE_AVG,
  to_char(nvl(LS_RATE_AVG,0)*100,'fm9999999990.00')||'%' LS_RATE_AVG,
  to_char(nvl(PORT_RATE_AVG,0)*100,'fm9999999990.00')||'%' PORT_RATE_AVG,
  to_char(nvl(ZY_RATE_AVG,0)*100,'fm9999999990.00')||'%' ZY_RATE_AVG,

  to_char(nvl(VILLAGE_RATE_AVG,0)*100,'fm9999999990.00') VILLAGE_RATE_AVG1,
  to_char(nvl(LS_RATE_AVG,0)*100,'fm9999999990.00') LS_RATE_AVG1,
  to_char(nvl(PORT_RATE_AVG,0)*100,'fm9999999990.00') PORT_RATE_AVG1,
  to_char(nvl(ZY_RATE_AVG,0)*100,'fm9999999990.00') ZY_RATE_AVG1
</e:set>

<e:switch value="${param.eaction}">
  <e:description>获取某指标下的对标数据</e:description>
  <e:case value="getDiffIndex">
    <e:q4l var="dataList">
      SELECT A.MARK_TYPE_CODE,
      B.MARK_DESC,
      TO_CHAR(ROUND(NVL(VILLAGE_RATE_AVG, 0), 4) * 100, 'FM990.00') || '%' VILLAGE_RATE_AVG,
      ROUND(NVL(VILLAGE_RATE_AVG, 0), 4) * 100 VILLAGE_RATE_AVG1,
      ROUND(NVL(HU_CHARGE_AVG, 0), 2) HU_CHARGE_AVG,
      TO_CHAR(ROUND(NVL(LS_RATE_AVG, 0), 4) * 100, 'FM990.00') || '%' LS_RATE_AVG,
      ROUND(NVL(LS_RATE_AVG, 0), 4) * 100 LS_RATE_AVG1,
      TO_CHAR(ROUND(NVL(PORT_RATE_AVG, 0), 4) * 100, 'FM990.00') || '%' PORT_RATE_AVG,
      ROUND(NVL(PORT_RATE_AVG, 0), 4) * 100 PORT_RATE_AVG1,
      TO_CHAR(ROUND(NVL(ZY_RATE_AVG, 0), 4) * 100, 'FM990.00') || '%' ZY_RATE_AVG,
      ROUND(NVL(ZY_RATE_AVG, 0), 4) * 100 ZY_RATE_AVG1
      FROM
      (  SELECT * FROM
      ${gis_user}.TB_GIS_DMCODE_MARK a
      WHERE
      (
      <e:forEach var="where_item" items="${e:split(param.where_str,'_')}" indexName="index">
        <e:if condition="${index > 0}">
          or
        </e:if>
        a.mark_type_code = 'MT0${e:substringBefore(where_item, "," )}' AND a.mark_code = 'MT0${e:substringBefore(where_item, "," )}00${e:substringAfter(where_item, "," )}'
      </e:forEach>
      )
      ) B
      LEFT JOIN
      (  SELECT * FROM
      ${gis_user}.TB_DW_GIS_VILL_VIEW_DAY a
      WHERE A.ACCT_DAY = '${param.acct_month}'
      and flg = 0
      AND (
      <e:forEach var="where_item" items="${e:split(param.where_str,'_')}" indexName="index">
        <e:if condition="${index > 0}">
          or
        </e:if>
        a.mark_type_code = 'MT0${e:substringBefore(where_item, "," )}' AND a.mark_code = 'MT0${e:substringBefore(where_item, "," )}00${e:substringAfter(where_item, "," )}'
      </e:forEach>
      )
      )A
      ON A.MARK_TYPE_CODE = B.MARK_TYPE_CODE
      AND A.MARK_CODE = B.MARK_CODE
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>
  <e:description>获取小区画像中小区列表</e:description>
  <e:case value="setvillages">
    <e:q4l var="list">
      <e:description>
      select a.village_id,village_Name,market_rate1,gz_zhu_hu_shu,COMPETE_PERCENT1 from
      (SELECT DISTINCT village_id,village_name FROM ${gis_user}.tb_gis_village_edit_info WHERE branch_no = '${param.id}' and village_id <> '${param.village_except}')a,
      (select
      latn_id,
      DECODE(NVL(GZ_ZHU_HU_COUNT, '0'), '0', 0, ROUND(NVL(GZ_H_USE_CNT, 0) / GZ_ZHU_HU_COUNT, 4) * 100) MARKET_RATE1,
      NVL(GZ_ZHU_HU_COUNT,0) GZ_ZHU_HU_SHU
      from
      ${gis_user}.tb_gis_res_info_day
      )b,
      (
      SELECT
      latn_id,
      CASE WHEN nvl(arrive_cnt,0) = 0 then 0 else round(nvl(cm_cnt + remove_cnt + owe_cnt + stop_cnt,0) /arrive_cnt,4)*100 end COMPETE_PERCENT1 FROM
      ${gis_user}.TB_DW_GIS_SCENE_USER_M cc
      WHERE cc.acct_month = '${param.acct_month}')c
      where a.village_id = b.latn_id
      AND a.village_id = c.latn_id
      ${sql_part}
      </e:description>
      SELECT DISTINCT village_id,village_name FROM ${gis_user}.tb_gis_village_edit_info WHERE branch_no = '${param.id}' and village_id <> '${param.village_except}'
      <e:if condition="${!empty param.grid_id}">
        and grid_id_2 = (select distinct grid_id from ${gis_user}.db_cde_grid where grid_union_org_code = '${param.grid_id}')
      </e:if>
    </e:q4l>${e:java2json(list.list)}
  </e:case>

  <e:description>获取省级均值，分公司均值，本小区均值，对标小区均值</e:description>
  <e:case value="getVillageAndCityAndProvAvg">
    <e:q4l var="dataList">
      SELECT '5' type,'本小区' MARK_DESC, ${index_name} FROM ${gis_user}.tb_dw_gis_vill_view_day WHERE flg = 5 AND acct_day = '${param.acct_month}' AND latn_id = '${param.village_id}'
      union all
      SELECT '2' type,'分公司均值' MARK_DESC, ${index_name} FROM ${gis_user}.tb_dw_gis_vill_view_day WHERE flg = 2 AND acct_day = '${param.acct_month}' AND latn_id = '${param.latn_id}'
      union all
      SELECT '1' type,'全省均值' MARK_DESC, ${index_name} FROM ${gis_user}.tb_dw_gis_vill_view_day WHERE flg = 1 AND acct_day = '${param.acct_month}'
      <e:if condition="${!empty param.other_village_id}">
        union all
        SELECT '5_1' type,'对标小区' MARK_DESC, ${index_name} FROM ${gis_user}.tb_dw_gis_vill_view_day WHERE flg = 5 AND acct_day = '${param.acct_month}' AND latn_id = '${param.other_village_id}'
      </e:if>
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:case value="getVillageByMonths">
    <e:q4l var="dataList">
      SELECT B.MONTH_CODE,
      NVL(A.USE_RATE, 0) USE_RATE,
      NVL(A.LS_RATE_AVG, 0) LS_RATE_AVG,
      NVL(A.LOST_REMOVE, 0) LOST_REMOVE
      FROM (SELECT ACCT_MONTH MONTH_CODE,
      ROUND(NVL(RATE, 0), 4) * 100 USE_RATE,
      ROUND(NVL(LS_RATE_AVG, 0), 4) * 100 LS_RATE_AVG,
      NVL(LOST_REMOVE, 0) LOST_REMOVE
      FROM ${gis_user}.TB_GIS_ST_RATE_MON
      WHERE VILLAGE_ID = '${param.village_id}'
      AND FLG = 5) A
      RIGHT JOIN (SELECT DISTINCT MONTH_CODE, MONTH_NAME
      FROM ${gis_user}.TB_DIM_TIME
      WHERE MONTH_CODE BETWEEN
      TO_CHAR(ADD_MONTHS(TO_DATE('${param.month}', 'yyyymm'), -${param.begin_count}),
      'yyyymm') AND
      TO_CHAR(ADD_MONTHS(TO_DATE('${param.month}', 'yyyymm'), 0),
      'yyyymm')) B
      ON A.MONTH_CODE = B.MONTH_CODE
      ORDER BY MONTH_CODE ASC
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>宽带渗透率、宽带流失数 6个数字</e:description>
  <e:case value="getMarketLostSix">
    <e:q4l var="dataList">
      SELECT
      to_char(round(nvl(a.rate,0),2),'FM9999999990.00')||'%' rate_this,
      nvl(a.lost_remove,0) lost_this,
      to_char(round(nvl(b.rate,0),2),'FM9999999990.00')||'%' rate_last,
      nvl(b.lost_remove,0) lost_last,
      CASE WHEN nvl(b.rate,0) = 0 THEN '--' ELSE to_char((round(nvl(a.rate,0)/b.rate,2)-1)*100,'FM9999999990.00')||'%' END rate_huan,
      CASE WHEN b.lost_remove = 0 THEN '--' ELSE to_char((round(nvl(a.lost_remove,0)/b.lost_remove,2)-1)*100,'FM9999999990.00')||'%' END lost_huan
      FROM (SELECT A.MONTH_CODE,
      NVL(BB.RATE, 0) * 100 RATE,
      NVL(BB.LOST_REMOVE, 0) LOST_REMOVE,
      GZ_KD_H_COUNT,
      GZ_ZHU_HU_COUNT
      FROM (SELECT DISTINCT MONTH_CODE
      FROM ${gis_user}.TB_DIM_TIME
      WHERE MONTH_CODE = '${param.acct_month}') A
      LEFT JOIN (SELECT ACCT_MONTH,
      RATE,
      LOST_REMOVE,
      GZ_KD_H_COUNT,
      GZ_ZHU_HU_COUNT
      FROM ${gis_user}.TB_GIS_ST_RATE_MON
      WHERE VILLAGE_ID = '${param.village_id}'
      AND (ACCT_MONTH = '${param.acct_month}')) BB
      ON A.MONTH_CODE = BB.ACCT_MONTH) A,
      (SELECT *
      FROM (SELECT A.MONTH_CODE,
      NVL(BB.RATE, 0) * 100 RATE,
      NVL(BB.LOST_REMOVE, 0) LOST_REMOVE,
      GZ_KD_H_COUNT,
      GZ_ZHU_HU_COUNT
      FROM (SELECT DISTINCT MONTH_CODE
      FROM ${gis_user}.TB_DIM_TIME
      WHERE MONTH_CODE =
      TO_CHAR((ADD_MONTHS(TO_DATE('${param.acct_month}', 'yyyymm'),
      -1)),
      'yyyymm')) A
      LEFT JOIN (SELECT ACCT_MONTH,
      RATE,
      LOST_REMOVE,
      GZ_KD_H_COUNT,
      GZ_ZHU_HU_COUNT
      FROM ${gis_user}.TB_GIS_ST_RATE_MON
      WHERE VILLAGE_ID = '${param.village_id}'
      AND (ACCT_MONTH =
      TO_CHAR((ADD_MONTHS(TO_DATE('${param.acct_month}',
      'yyyymm'),
      -1)),
      'yyyymm'))) BB
      ON A.MONTH_CODE = BB.ACCT_MONTH)) B
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

</e:switch>