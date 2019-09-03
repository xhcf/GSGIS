<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>

<e:q4o var="index_opt1">
  <e:if condition="${!empty param.opt1}" var="empty_stl">
    SELECT CASE
    WHEN RANGE_SIGNR IS NULL THEN
    RANGE_SIGNL || RANGE_MIN
    WHEN RANGE_SIGNL IS NULL THEN
    RANGE_SIGNR || RANGE_MAX
    ELSE
    RANGE_SIGNL || RANGE_MIN || ' and MARKET_LV1 ' || RANGE_SIGNR || RANGE_MAX
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
    AND KPI_CODE = 'KPI_D_005'
    AND RANGE_INDEX = '${param.opt1}'
    ORDER BY KPI_CODE ASC, RANGE_INDEX ASC)
  </e:if>
  <e:else condition="${empty_stl}">
    SELECT '' FROM DUAL
  </e:else>
</e:q4o>
<e:q4o var="index_opt3">
  <e:if condition="${!empty param.opt3}" var="empty_jzcd">
    SELECT CASE
    WHEN RANGE_SIGNR IS NULL THEN
    RANGE_SIGNL || RANGE_MIN
    WHEN RANGE_SIGNL IS NULL THEN
    RANGE_SIGNR || RANGE_MAX
    ELSE
    RANGE_SIGNL || RANGE_MIN || ' and LOST_LV1 ' || RANGE_SIGNR || RANGE_MAX
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
    AND KPI_CODE = 'KPI_D_007'
    AND RANGE_INDEX = '${param.opt3}'
    ORDER BY KPI_CODE ASC, RANGE_INDEX ASC)
  </e:if>
  <e:else condition="${empty_jzcd}">
    SELECT '' FROM DUAL
  </e:else>
</e:q4o>

<e:set var="sql_part">
  <e:if condition="${!empty param.opt1}">
    AND MARKET_LV1 ${index_opt1.INDEX_RANGE}
  </e:if>
  <e:if condition="${!empty param.opt2}">
    <e:switch value="${param.opt2}">
      <e:case value="h">
        AND GW_LV1>=60
      </e:case>
      <e:case value="m">
        AND GW_LV1>=30 AND GW_LV1<60
      </e:case>
      <e:case value="l">
        AND GW_LV1<30
      </e:case>
    </e:switch>
  </e:if>
  <e:if condition="${!empty param.opt3}">
    and LOST_LV1 ${index_opt3.INDEX_RANGE}
  </e:if>
  <e:if condition="${!empty param.opt4}">
    <e:switch value="${param.opt4}">
      <e:case value="h">
        AND PORT_LV1 >= 60
      </e:case>
      <e:case value="m">
        AND (PORT_LV1 < 60 AND PORT_LV1 >= 30)
      </e:case>
      <e:case value="l">
        AND PORT_LV1 < 30
      </e:case>
    </e:switch>
  </e:if>
</e:set>

<e:set var="sql_column">
  b.population_num,
  b.household_num,
  b.h_use_cnt,
  TO_CHAR(ROUND(DECODE(b.household_num, 0, 0, b.h_use_cnt / b.household_num), 4) * 100,'FM99999999990.00') MARKET_LV1,
  TO_CHAR(ROUND(DECODE(b.household_num, 0, 0, b.h_use_cnt / b.household_num), 4) * 100,'FM99999999990.00') || '%' MARKET_LV,
  nvl(eqp_cnt,0) OBD_CNT,
  TO_CHAR(ROUND(DECODE(b.brigade_id_cnt, 0, 0, b.zy_cnt / b.brigade_id_cnt), 4) * 100,'FM99999999990.00') gw_lv1,
  TO_CHAR(ROUND(DECODE(b.brigade_id_cnt, 0, 0, b.zy_cnt / b.brigade_id_cnt), 4) * 100,'FM99999999990.00') || '%' gw_lv,
  nvl(b.capacity,0) capacity,
  nvl(b.actualcapacity,0) actualcapacity,
  TO_CHAR(ROUND(DECODE(b.capacity, 0, 0, b.actualcapacity / b.capacity), 4) * 100,'FM99999999990.00') PORT_LV1,
  TO_CHAR(ROUND(DECODE(b.capacity, 0, 0, b.actualcapacity / b.capacity), 4) * 100,'FM99999999990.00') || '%' PORT_LV,
  nvl(b.chai_cnt,0)+nvl(b.stop_cnt,0)+nvl(b.chenm_cnt,0) lost_cnt,
  TO_CHAR(ROUND(DECODE(b.h_use_cnt, 0, 0, (nvl(b.chai_cnt,0)+nvl(b.stop_cnt,0)+nvl(b.chenm_cnt,0)) / b.h_use_cnt), 4) * 100,'FM99999999990.00') lost_lv1,
  TO_CHAR(ROUND(DECODE(b.h_use_cnt, 0, 0, (nvl(b.chai_cnt,0)+nvl(b.stop_cnt,0)+nvl(b.chenm_cnt,0)) / b.h_use_cnt), 4) * 100,'FM99999999990.00') || '%' lost_lv,
  nvl(b.chai_cnt,0) lost_cj_cnt,
  nvl(b.stop_cnt,0) lost_qt_cnt,
  nvl(b.chenm_cnt,0) lost_cm_cnt
</e:set>

<e:set var="sql_part_order">
  (select distinct latn_id,bureau_no,city_order_num,region_order_num from ${gis_user}.db_cde_grid) c
  where a.latn_id = c.latn_id and a.bureau_no = c.bureau_no
  order by c.city_order_num,c.region_order_num
</e:set>

<e:switch value="${param.eaction}">
  <e:description>划小清单</e:description>
  <e:case value="list_hx">
    <e:q4l var="dataList">
      select * from (
      SELECT t.* FROM(
      SELECT a.*,
      COUNT(1) OVER() C_NUM,
      ROW_NUMBER() OVER(ORDER BY c.CITY_ORDER_NUM,c.REGION_ORDER_NUM,a.BRANCH_NAME,a.GRID_NAME,a.VILLAGE_NAME) RN
      FROM (
      select * from (
      SELECT
      a.*,
      ${sql_column}
      FROM
      (SELECT DISTINCT
      latn_id,
      nvl(latn_name,    ' ')latn_name,
      nvl(bureau_no,    ' ')bureau_no,
      nvl(bureau_name,  ' ')bureau_name,
      nvl(branch_no,    ' ')branch_no,
      nvl(branch_name,  ' ')branch_name,
      nvl(grid_id,      ' ')grid_id,
      nvl(grid_name,    ' ')grid_name,
      nvl(village_id,   ' ')village_id,
      nvl(village_name, ' ')village_name
      FROM
      edw.vw_tb_cde_village@gsedw
      WHERE 1=1
      <e:if condition="${param.city_id ne '999' && !empty param.city_id}">
        and latn_id=${param.city_id}
      </e:if>
      <e:if condition="${!empty param.bureau_id && param.bureau_id ne '999'}">
        and bureau_no = '${param.bureau_id}'
      </e:if>
      <e:if condition="${!empty param.union_org_code}">
        and branch_no = (select distinct branch_no from ${gis_user}.db_cde_grid where union_org_code = '${param.union_org_code}')
      </e:if>
      <e:if condition="${!empty param.grid_union_org_code}">
        and grid_id = '${param.grid_union_org_code}'
      </e:if>
      ) a,
      ${gis_user}.TB_GIS_COUNT_INFO_D b WHERE a.village_id = b.latn_id
      AND b.acct_day = (SELECT const_value FROM sys_const_table WHERE const_type = 'var.dss27' AND const_name = 'calendar.curdate')
      )
      where 1 = 1
      <e:description>渗透率、覆盖率、流失占比、端口占用率 等条件查询</e:description>
      ${sql_part})a,
      ${sql_part_order}
      )
      t) WHERE rn <= ${param.page+1}*25 and rn >${param.page}*25
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>行政清单</e:description>
  <e:case value="list_xz">
    <e:q4l var="dataList">
      select * from (
      SELECT t.* FROM(
      SELECT a.*,
      COUNT(1) OVER() C_NUM,
      ROW_NUMBER() OVER(ORDER BY c.CITY_ORDER_NUM,c.REGION_ORDER_NUM,a.COUNTY_NAME,a.TOWN_NAME,a.VILLAGE_NAME) RN
      FROM (
      select * from (
      SELECT
      a.*,
      ${sql_column}
      FROM
      (SELECT DISTINCT
      city_id latn_id,
      nvl(city_name,   ' ')city_name,
      nvl(bureau_no,   ' ')bureau_no,
      nvl(county_id,   ' ')county_id,
      nvl(county_name, ' ')county_name,
      nvl(town_id,     ' ')town_id,
      nvl(town_name,   ' ')town_name,
      nvl(village_id,  ' ')village_id,
      nvl(village_name,' ')village_name
      FROM
      edw.vw_tb_cde_village@gsedw
      WHERE 1=1
      <e:if condition="${param.city_id ne '999' && !empty param.city_id}">
        and city_id=${param.city_id}
      </e:if>
      <e:if condition="${!empty param.county_id && param.county_id ne '999'}">
        and county_id = '${param.county_id}'
      </e:if>
      <e:if condition="${!empty param.town_id}">
        and town_id = '${param.town_id}'
      </e:if>
      ) a,
      ${gis_user}.TB_GIS_COUNT_INFO_D b WHERE a.village_id = b.latn_id
      AND b.acct_day = (SELECT const_value FROM sys_const_table WHERE const_type = 'var.dss27' AND const_name = 'calendar.curdate')
      )
      where 1 = 1
      <e:description>渗透率、覆盖率、流失占比、端口占用率 等条件查询</e:description>
      ${sql_part})a,
      ${sql_part_order}
      )
      t) WHERE rn <= ${param.page+1}*25 and rn >${param.page}*25
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

</e:switch>