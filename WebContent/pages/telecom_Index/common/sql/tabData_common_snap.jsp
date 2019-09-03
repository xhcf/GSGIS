<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>

<e:description>仅用于快照表_历史数据</e:description>
<e:switch value="${param.eaction}">
  <e:description>获取地市下的区县</e:description>
  <e:case value="getBureauByCityId">
    <e:q4l var="dataList">
      SELECT DISTINCT bureau_no VAL,bureau_name NAME,region_order_Num,'县局列表' b FROM ${gis_user}.tb_gis_rpt_grid_activity2 WHERE latn_id = '${param.city_id}'
      <e:if condition="${param.branch_type eq '1'}">
        AND branch_type = 'a1'
      </e:if>
      <e:if condition="${param.branch_type eq '2'}">
        AND branch_type = 'b1'
      </e:if>
      order by REGION_ORDER_NUM
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>获取区县下的支局</e:description>
  <e:case value="getBranchByBureauId">
    <e:q4l var="dataList">
      SELECT DISTINCT T.UNION_ORG_CODE,T.BRANCH_NO VAL,T.BRANCH_NAME NAME,'支局列表' b
      FROM ${gis_user}.tb_gis_rpt_grid_activity2 T
      WHERE T.BUREAU_NO = '${param.bureau_id}'
      <e:if condition="${param.branch_type eq '1'}">
        AND branch_type = 'a1'
      </e:if>
      <e:if condition="${param.branch_type eq '2'}">
        AND branch_type = 'b1'
      </e:if>
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>获取支局下的网格</e:description>
  <e:case value="getGridByBranchId">
    <e:q4l var="dataList">
      SELECT DISTINCT T.GRID_ID VAL,T.GRID_NAME NAME,'网格列表' b
      FROM ${gis_user}.tb_gis_rpt_grid_activity2 T
      WHERE T.branch_no = '${param.branch_id}'
      <e:if condition="${param.branch_type eq '1'}">
        AND branch_type = 'a1'
      </e:if>
      <e:if condition="${param.branch_type eq '2'}">
        AND branch_type = 'b1'
      </e:if>
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>获取网格下的小区</e:description>
  <e:case value="getVillageIdByGridNo">
    <e:q4l var="dataList">
      SELECT VILLAGE_ID VAL, VILLAGE_NAME NAME
      FROM ${gis_user}.TB_GIS_VILLAGE_EDIT_INFO
      WHERE GRID_ID_2 = '${param.grid_id}'
      union all
      SELECT '99999999' VILLAGE_ID,'未建小区' VILLAGE_NAME
      from dual
      order by village_id,village_name
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>
</e:switch>