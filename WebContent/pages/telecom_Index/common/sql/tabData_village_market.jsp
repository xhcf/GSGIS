<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>

<e:switch value="${param.eaction}">

  <e:description>获取地市下的区县</e:description>
  <e:case value="getBureauByCityId">
    <e:q4l var="dataList">
      select '-1' val,'请选择' name,'0' ord from dual
      <e:if condition="${!empty param.bureau_id}" var="single">
        union all
        select distinct bureau_no val,bureau_name name,region_order_num ord from ${gis_user}.db_cde_grid
        where bureau_no = '${param.bureau_id}'
      </e:if>
      <e:else condition="${single}">
        <e:if condition="${!empty param.city_id}">
          union all
          select distinct bureau_no val,bureau_name name,region_order_num ord from ${gis_user}.db_cde_grid
          where latn_id = '${param.city_id}'
        </e:if>
      </e:else>
      order by ord
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>获取区县下的支局</e:description>
  <e:case value="getBranchByBureauId">
    <e:q4l var="dataList">
      select '-1' val,'请选择' name from dual
      <e:if condition="${!empty param.branch_id}" var="single">
        union all
        select distinct union_org_code val,branch_name name from ${gis_user}.db_cde_grid
        where union_org_code = '${param.branch_id}'
      </e:if>
      <e:else condition="${single}">
        <e:if condition="${!empty param.bureau_id}">
          union all
          select distinct union_org_code val,branch_name name from ${gis_user}.db_cde_grid
          where bureau_no = '${param.bureau_id}'
        </e:if>
      </e:else>
      order by val
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>获取支局下的网格</e:description>
  <e:case value="getGridByBranchId">
    <e:q4l var="dataList">
      select '-1' val,'请选择' name from dual
      <e:if condition="${!empty param.grid_id}" var="single">
        union all
        select distinct grid_union_org_code val,grid_name name from ${gis_user}.db_cde_grid
        where grid_union_org_code = '${param.grid_id}'
      </e:if>
      <e:else condition="${single}">
        <e:if condition="${!empty param.branch_id}">
          union all
          select distinct grid_union_org_code val,grid_name name from ${gis_user}.db_cde_grid
          where union_org_code = '${param.branch_id}'
          and grid_union_org_code <> -1 and grid_union_org_code is not null
        </e:if>
      </e:else>
      order by val
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>获取支局下的小区</e:description>
  <e:case value="getVillageIdByReginId">
    <e:q4l var="dataList">
      select * from (
      SELECT t.*,ROWNUM rn FROM (
      SELECT
      LATN_ID,
      LATN_NAME,
      BUREAU_NO,
      BUREAU_NAME,
      BRANCH_NAME,
      GRID_NAME,
      a.VILLAGE_ID,
      a.VILLAGE_NAME,
      nvl(ly_cnt,0) ly_cnt,
      nvl(GZ_ZHU_HU_COUNT,0) GZ_ZHU_HU_COUNT,
      nvl(GZ_H_USE_CNT,0) GZ_H_USE_CNT,
      to_char(nvl(MARKET_LV,0),'FM9999999990.00')||'%' MARKET_LV1,
      nvl(MARKET_LV,0) MARKET_LV,
      nvl(C.ADD_H,0) ADD_H,
      nvl(C.REMOVE_H,0) REMOVE_H,
      nvl(C.ADD_H - C.REMOVE_H,0) JZ_H,
      FILTER_MON_RATE,
      FILTER_YEAR_RATE,
      CITY_ORDER_NUM,
      REGION_ORDER_NUM,
      no_res_village_cnt,
      COUNT(1) OVER() c_num
      FROM ${gis_user}.VIEW_GIS_VILLAGE_SUM_LIST a left join
      ${gis_user}.TB_DW_VILLAEG_BASIC_DAY C
      on a.village_id = c.village_id
      WHERE 1=1
      ${sql_part}
      <e:if condition="${param.city_id ne '999' && !empty param.city_id}">
        and latn_id=${param.city_id}
      </e:if>
      <e:if condition="${!empty param.bureau_id && param.bureau_id ne '999'}">
        and bureau_no = '${param.bureau_id}'
      </e:if>
      <e:if condition="${!empty param.branch_id}">
        and union_org_code = '${param.branch_id}'
      </e:if>
      <e:if condition="${!empty param.grid_id}">
        and grid_union_org_code = '${param.grid_id}'
      </e:if>
      <e:if condition="${!empty param.data_monitor}">
        AND GZ_H_USE_CNT>use_port_cnt
      </e:if>
      <e:description>白区小区 渗透率小于10%</e:description>
      <e:if condition="${param.vil_type eq 'white_area'}">
        and nvl(MARKET_LV,0)<10
      </e:if>
      <e:description>拔旗小区 没有资源进入</e:description>
      <e:if condition="${param.vil_type eq 'no_res_in'}">
        and nvl(no_res_village_cnt,0)>0
      </e:if>
      <e:if condition="${!empty param.village_name}">
        and a.village_name like '%${param.village_name}%'
      </e:if>
      ORDER BY city_order_num ASC,region_order_num ASC,village_name ASC)t
      WHERE ROWNUM <= ${param.page + 1}*30)
      WHERE rn > ${param.page}*30
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

</e:switch>