<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>

<e:switch value="${param.eaction}">
  <e:description>获取地市下的区县</e:description>
  <e:case value="getBureauByCityId">
    <e:q4l var="dataList">
      SELECT DISTINCT bureau_no,bureau_name，region_order_Num FROM ${gis_user}.db_cde_grid WHERE latn_id = '${param.city_id}' AND branch_type = 'a1' order by REGION_ORDER_NUM
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:case value="getAllBureauByCityId">
    <e:q4l var="dataList">
      SELECT DISTINCT bureau_no,bureau_name，region_order_Num FROM ${gis_user}.db_cde_grid WHERE latn_id = '${param.city_id}' order by REGION_ORDER_NUM
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
</e:switch>