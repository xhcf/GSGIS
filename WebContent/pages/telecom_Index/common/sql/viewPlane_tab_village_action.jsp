<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<e:switch value="${param.eaction}">
  <e:description>省级概况 显示全省及各地市</e:description>
  <e:case value="province">
    <c:tablequery>
      SELECT 999 LATN_ID,
      '全省' LATN_NAME,
      SUM(nvl(BRANCH_NUM,0)) BRANCH_NUM,
      SUM(nvl(GRID_NUM,0)) GRID_NUM,
      SUM(nvl(VILLAGE_NUM,0)) VILLAGE_NUM,
      SUM(nvl(BRANCH_V,0)) BRANCH_V,
      SUM(nvl(GRID_V,0)) GRID_V,
      '0' CITY_ORDER_NUM
      FROM ${gis_user}.VIEW_GIS_LATN_COUNT
      UNION
      SELECT LATN_ID,
      LATN_NAME,
      nvl(BRANCH_NUM,0) BRANCH_NUM,
      nvl(GRID_NUM,0) GRID_NUM,
      nvl(VILLAGE_NUM,0) VILLAGE_NUM,
      nvl(BRANCH_V,0) BRANCH_V,
      nvl(GRID_V,0) GRID_V,
      CITY_ORDER_NUM
      FROM ${gis_user}.VIEW_GIS_LATN_COUNT
      ORDER BY CITY_ORDER_NUM
    </c:tablequery>
  </e:case>
  
  <e:description>市级概况 显示区县</e:description>
  <e:case value="city">
    <c:tablequery>
      SELECT
        A.CITY_ORDER_NUM,
        A.REGION_ORDER_NUM,
        A.BUREAU_NO,
        A.LATN_ID,
        A.LATN_NAME,
        A.BUREAU_NAME,
        nvl(A.BRANCH_NUM,0) BRANCH_NUM,
        nvl(A.GRID_NUM,0) GRID_NUM,
        nvl(A.VILLAGE_NUM,0) VILLAGE_NUM,
        nvl(A.BRANCH_V,0) BRANCH_V,
        nvl(A.GRID_V,0) GRID_V
      FROM ${gis_user}.VIEW_GIS_BUREAU_COUNT A
      WHERE 1 = 1
      <e:if condition="${!empty param.city_id1 && param.city_id1 ne '999'}">
        AND A.LATN_ID='${param.city_id1}'
      </e:if>
      <e:if condition="${empty param.city_id1}">
        AND A.LATN_ID='${param.city_id}'
      </e:if>
      ORDER BY A.REGION_ORDER_NUM
    </c:tablequery>
  </e:case>
  
  <e:description>区县概况 显示网格下小区情况</e:description>
  <e:case value="grid">
    <c:tablequery>
        SELECT * FROM (
          SELECT
             T.LATN_ID,
             T.LATN_NAME,
             T.BUREAU_NO,
             T.BUREAU_NAME,
             T.BRANCH_NO,
             T.BRANCH_NAME,
             CASE
             WHEN GROUPING(T.GRID_ID) = 1 THEN
             MAX(T.BRANCH_NO)
             ELSE
             MAX(T.GRID_ID)
             END GRID_ID,
             CASE
             WHEN GROUPING(T.GRID_ID) = 1 THEN
             '小计 '
             ELSE
             MAX(T.GRID_NAME)
             END GRID_NAME,
             SUM(NVL(VILLAGE_COUNT1, 0)) VILLAGE_NUM,
             SUM(NVL(SEGM_COUNT, 0)) BUILD_NUM,
             SUM(NVL(UN_ASSIGNED_COUNT1, 0)) BUILD_NUM_V
                FROM (
                  select a.latn_id,a.latn_name,a.bureau_no,a.bureau_name,a.branch_no,a.branch_name,a.grid_id,a.grid_name,nvl(village_count1,0) village_count1,nvl(segm_count,0) segm_count,nvl(un_assigned_count1,0) un_assigned_count1 from (
                  SELECT a.latn_id,a.latn_name,a.bureau_no,a.bureau_name,a.branch_no,a.branch_name,a.grid_id,a.grid_name,c.village_count1,c.segm_count,c.un_assigned_count1
                  FROM ${gis_user}.db_cde_grid a,(select * from ${gis_user}.TB_GIS_VILLAGE_ADDR_DAY where grid_id is not null) c
                  where a.latn_id=c.latn_id(+)
                  and a.bureau_no = c.bureau_no(+)
                  and a.branch_no = c.branch_no(+)
                  and a.grid_id = c.grid_id(+)
                  and a.grid_status=1 and a.grid_union_org_code <>'-1' and a.branch_type='a1'
                  union
                  SELECT a.latn_id,a.latn_name,a.bureau_no,a.bureau_name,a.branch_no,a.branch_name,a.grid_id,a.grid_name,a.village_count1,a.segm_count,a.un_assigned_count1 FROM ${gis_user}.TB_GIS_VILLAGE_ADDR_DAY a
                  where  a.grid_id is null
                  )A
                ) T
               WHERE 1 = 1
                <e:if condition="${!empty param.city_id1}" var="empty_cityid1">
                  AND LATN_ID='${param.city_id1}'
                </e:if>
                <e:else condition="${empty_cityid1}">
                  AND LATN_ID='${param.city_id}'
                </e:else>
                <e:if condition="${!empty param.bureau_id2}" var="empty_bureau_id2">
                  <e:description>
                  已废弃的部分，取消默认查询第一个分局数据
                  AND BUREAU_NO=(
                  SELECT BUREAU_NO
                    FROM (SELECT DISTINCT BUREAU_NO, BUREAU_NAME，REGION_ORDER_NUM
                      FROM ${gis_user}.DB_CDE_GRID
                      WHERE LATN_ID = '${param.city_id1}'
                        AND BRANCH_TYPE = 'a1'
                        ORDER BY REGION_ORDER_NUM)
                        WHERE ROWNUM = 1
                  )
                  </e:description>
                </e:if>
                <e:else condition="${empty_bureau_id2}">
                  <e:if condition="${!empty param.bureau_id1 && param.bureau_id1 ne '999'}">
                    AND BUREAU_NO='${param.bureau_id1}'
                  </e:if>
                  <e:if condition="${empty param.bureau_id1 && !empty param.bureau_id && param.bureau_id ne '999'}">
                    AND BUREAU_NO='${param.bureau_id}'
                  </e:if>
                </e:else>
                AND BRANCH_NO IN (SELECT BRANCH_NO FROM ${gis_user}.db_cde_grid WHERE branch_type = 'a1'
                  <e:if condition="${!empty param.city_id1}" var="empty_cityid1">
                    AND LATN_ID='${param.city_id1}'
                  </e:if>
                  <e:else condition="${empty_cityid1}">
                    AND LATN_ID='${param.city_id}'
                  </e:else>
                  <e:else condition="${empty_bureau_id2}">
                    <e:if condition="${!empty param.bureau_id1 && param.bureau_id1 ne '999'}">
                      AND BUREAU_NO='${param.bureau_id1}'
                    </e:if>
                    <e:if condition="${empty param.bureau_id1 && param.bureau_id ne '999'}">
                      AND BUREAU_NO='${param.bureau_id}'
                    </e:if>
                  </e:else>
                )
                  <e:if condition="${!empty param.branch_id}">
                    AND BRANCH_NO = '${param.branch_id}'
                  </e:if>
                  <e:if condition="${!empty param.grid_id}">
                    AND GRID_ID = '${param.grid_id}'
                  </e:if>
                GROUP BY
                  T.LATN_ID,
                  T.LATN_NAME,
                  T.BUREAU_NO,
                  T.BUREAU_NAME,
                  T.BRANCH_NO,
                  T.BRANCH_NAME,
                  ROLLUP(T.GRID_ID)
                order by latn_id,bureau_no,branch_no
        ) where GRID_NAME is not null
    </c:tablequery>
  </e:case>

  <e:description>网格下 展示各小区详细的情况</e:description>
  <e:case value="village">
    <c:tablequery>
      SELECT VILLAGE_ID,
      VILLAGE_NAME,
      STATION_ID,
      LATN_ID,
      LATN_NAME,
      BUREAU_NO,
      BUREAU_NAME,
      UNION_ORG_CODE,
      BRANCH_NAME,
      CASE
      WHEN BRANCH_TYPE = 'a1' THEN
      '城市'
      WHEN BRANCH_TYPE = 'b1' THEN
      '农村'
      END BRANCH_TYPE_TEXT,
      GRID_ID,
      DECODE(GRID_NAME, NULL, BRANCH_NAME, GRID_NAME) GRID_NAME,
      nvl(BUILD_SUM, 0) BUILD_SUM,
      NVL(ZHU_HU_SUM, 0) ZHU_HU_SUM,
      nvl(PEOPLE_NUM, 0) PEOPLE_NUM,
      NVL(PORT_SUM, 0) PORT_SUM,
      NVL(PORT_USED_SUM, 0) PORT_USED_SUM,
      NVL(PORT_FREE_SUM, 0) PORT_FREE_SUM,
      MARKET_LV,
      PORT_LV
      FROM ${gis_user}.VIEW_GIS_VILLAGE_ZJ_QUERY A
      WHERE 1 = 1
      <e:if condition="${!empty param.city_id1 && param.city_id1 ne '999'}">
        and a.latn_id = '${param.city_id1}'
      </e:if>
      <e:if condition="${empty param.city_id1}">
        and a.latn_id = '${param.city_id}'
      </e:if>
      <e:if condition="${!empty param.bureau_id1 && param.bureau_id1 ne '999'}">
        and a.bureau_no = '${param.bureau_id1}'
      </e:if>
      <e:if condition="${empty param.bureau_id1}">
        and a.bureau_no = '${param.bureau_id}'
      </e:if>
      <e:if condition="${!empty param.branch_id1 && param.branch_id1 ne '999'}">
        and a.union_org_code = '${param.branch_id1}'
      </e:if>
      <e:if condition="${empty param.branch_id1}">
        and a.union_org_code = '${param.branch_id}'
      </e:if>
      <e:if condition="${!empty param.grid_id1 && param.grid_id1 ne '999'}">
        and a.grid_id = '${param.grid_id1}'
      </e:if>
      <e:if condition="${empty param.grid_id1 && !empty param.grid_id}">
        and a.grid_id = '${param.grid_id}'
      </e:if>
      <e:if condition="${!empty param.text}">
        and (a.VILLAGE_NAME like '%${param.text}%' or a.BRANCH_NAME like '%${param.text}%' or a.GRID_NAME like '%${param.text}%')
      </e:if>
      and branch_type = 'a1'
      ORDER BY A.CITY_ORDER_NUM,
      A.REGION_ORDER_NUM,
      BRANCH_TYPE,
      GRID_ID,
      VILLAGE_NAME
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
      WHERE T.BUREAU_NO = '${param.bureau_id}' AND branch_type = 'a1'
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>获取支局下的网格</e:description>
  <e:case value="getGridByBranchId">
    <e:q4l var="dataList">
      select DISTINCT grid_id,grid_name,'网格列表' c from ${gis_user}.DB_CDE_GRID t WHERE branch_no = '${param.branch_id}' AND branch_type = 'a1' AND grid_status = 1 and grid_union_org_code <> -1
    </e:q4l>${e:java2json(dataList.list)}
  </e:case>

  <e:description>获取未建小区的网格明细</e:description>
  <e:case value="getGridDetailHasNoVillage">
    <c:tablequery>
      SELECT
        LATN_ID,
        LATN_NAME,
        BUREAU_NO,
        BUREAU_NAME,
        BRANCH_NO,
        BRANCH_NAME,
        GRID_ID,
        GRID_NAME
      FROM ${gis_user}.DB_CDE_GRID
        WHERE GRID_ID IN (
            SELECT
              GRID_ID
            FROM ${gis_user}.VIEW_GIS_ALL_GRID_VILLAGE T
            WHERE GRID_ID IS NOT NULL
            AND BRANCH_TYPE = 'a1'
            AND BUREAU_NO = '${param.bureau_id}'
            GROUP BY GRID_ID
            HAVING COUNT(VILLAGE_ID) < 1
        )
      AND BUREAU_NO = '${param.bureau_id}'
      AND BRANCH_TYPE = 'a1'
      AND GRID_STATUS = 1
      AND GRID_UNION_ORG_CODE <> -1
    </c:tablequery>
  </e:case>

  <e:description>获取支局或网格未划配地址明细</e:description>
  <e:case value="getBuildNoInVillageBySubOrGridId">
    <c:tablequery>
      SELECT
        s.latn_id,
        s.latn_name,
        s.branch_no,
        s.branch_name,
        s.grid_id,
        s.grid_name,
        s.segm_id,
        c.STAND_NAME
      FROM sde.TB_GIS_MAP_SEGM_LATN_MON s, ${gis_user}.tb_gis_addr4_info c
        where s.segm_id = c.segm_id
        <e:if condition="${param.flag eq '1'}">
          and s.branch_no = '${param.branch_no}'
        </e:if>
        <e:if condition="${param.flag eq '2'}">
          and s.grid_id = '${param.grid_id}'
        </e:if>
        and s.segm_id not in
        (SELECT a.segm_id
        FROM ${gis_user}.view_gis_all_grid_village  v, ${gis_user}.TB_GIS_VILLAGE_ADDR4 a
        where v.village_id = a.village_id
        <e:if condition="${param.flag eq '1'}">
          and V.branch_no = '${param.branch_no}'
        </e:if>
        <e:if condition="${param.flag eq '2'}">
          and V.grid_id = '${param.grid_id}'
        </e:if>
      )
    </c:tablequery>
  </e:case>

</e:switch>